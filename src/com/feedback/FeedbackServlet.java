package com.feedback;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FeedbackServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            if (action.equals("add")) {
                addFeedback(request, response);
            } else if (action.equals("delete")) {
                deleteFeedback(request, response);
            } else if (action.equals("edit")) {
                editFeedback(request, response);
            } else if (action.equals("update")) {
                updateFeedback(request, response);
            } else if (action.equals("search")) {
                searchFeedback(request, response);
            } else {
                listFeedback(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FeedbackServlet?action=list");
        }
    }

    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");

        String title = request.getParameter("title");
        String message = request.getParameter("message");

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO feedback(user_id, title, message) VALUES(?, ?, ?)"
        );
        ps.setInt(1, userId);
        ps.setString(2, title);
        ps.setString(3, message);

        ps.executeUpdate();
        con.close();

        response.sendRedirect("FeedbackServlet?action=list");
    }

    private void listFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "SELECT feedback.*, users.username FROM feedback " +
            "JOIN users ON feedback.user_id = users.id ORDER BY feedback.id DESC"
        );

        ResultSet rs = ps.executeQuery();

        ArrayList<HashMap<String, String>> feedbackList = new ArrayList<HashMap<String, String>>();

        while (rs.next()) {
            HashMap<String, String> feedback = new HashMap<String, String>();
            feedback.put("id", String.valueOf(rs.getInt("id")));
            feedback.put("username", rs.getString("username"));
            feedback.put("title", rs.getString("title"));
            feedback.put("message", rs.getString("message"));
            feedback.put("created_at", rs.getString("created_at"));

            feedbackList.add(feedback);
        }

        con.close();

        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private void searchFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        String keyword = request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "SELECT feedback.*, users.username FROM feedback " +
            "JOIN users ON feedback.user_id = users.id " +
            "WHERE title LIKE ? OR message LIKE ? OR username LIKE ? " +
            "ORDER BY feedback.id DESC"
        );

        String searchValue = "%" + keyword + "%";

        ps.setString(1, searchValue);
        ps.setString(2, searchValue);
        ps.setString(3, searchValue);

        ResultSet rs = ps.executeQuery();

        ArrayList<HashMap<String, String>> feedbackList = new ArrayList<HashMap<String, String>>();

        while (rs.next()) {
            HashMap<String, String> feedback = new HashMap<String, String>();
            feedback.put("id", String.valueOf(rs.getInt("id")));
            feedback.put("username", rs.getString("username"));
            feedback.put("title", rs.getString("title"));
            feedback.put("message", rs.getString("message"));
            feedback.put("created_at", rs.getString("created_at"));

            feedbackList.add(feedback);
        }

        con.close();

        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int id = Integer.parseInt(request.getParameter("id"));

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "DELETE FROM feedback WHERE id=?"
        );
        ps.setInt(1, id);

        ps.executeUpdate();
        con.close();

        response.sendRedirect("FeedbackServlet?action=list");
    }

    private void editFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int id = Integer.parseInt(request.getParameter("id"));

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM feedback WHERE id=?"
        );
        ps.setInt(1, id);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            request.setAttribute("id", rs.getInt("id"));
            request.setAttribute("title", rs.getString("title"));
            request.setAttribute("message", rs.getString("message"));
            request.getRequestDispatcher("updateFeedback.jsp").forward(request, response);
        } else {
            response.sendRedirect("FeedbackServlet?action=list");
        }

        con.close();
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String message = request.getParameter("message");

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(
            "UPDATE feedback SET title=?, message=? WHERE id=?"
        );
        ps.setString(1, title);
        ps.setString(2, message);
        ps.setInt(3, id);

        ps.executeUpdate();
        con.close();

        response.sendRedirect("FeedbackServlet?action=list");
    }
}
