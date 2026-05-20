package fms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class FeedbackServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String role = (String) session.getAttribute("role");
        int userId = (Integer) session.getAttribute("userId");

        try {
            if ("add".equals(action) && "user".equals(role)) {
                addFeedback(request, userId);
            } else if ("update".equals(action) && "user".equals(role)) {
                updateFeedback(request, userId);
            } else if ("delete".equals(action) && "user".equals(role)) {
                deleteFeedback(request, userId);
            }

            loadFeedback(request, role, userId);

            if ("admin".equals(role)) {
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("user.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Something went wrong");
            loadFeedbackSafely(request, role, userId);
            request.getRequestDispatcher("user".equals(role) ? "user.jsp" : "admin.jsp").forward(request, response);
        }
    }

    private void addFeedback(HttpServletRequest request, int userId) throws Exception {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
                "INSERT INTO feedback(user_id, subject, message) VALUES(?, ?, ?)");
        ps.setInt(1, userId);
        ps.setString(2, request.getParameter("subject"));
        ps.setString(3, request.getParameter("message"));
        ps.executeUpdate();
        con.close();
        request.setAttribute("message", "Feedback added");
    }

    private void updateFeedback(HttpServletRequest request, int userId) throws Exception {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
                "UPDATE feedback SET subject=?, message=? WHERE id=? AND user_id=?");
        ps.setString(1, request.getParameter("subject"));
        ps.setString(2, request.getParameter("message"));
        ps.setInt(3, Integer.parseInt(request.getParameter("feedbackId")));
        ps.setInt(4, userId);
        ps.executeUpdate();
        con.close();
        request.setAttribute("message", "Feedback updated");
    }

    private void deleteFeedback(HttpServletRequest request, int userId) throws Exception {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
                "DELETE FROM feedback WHERE id=? AND user_id=?");
        ps.setInt(1, Integer.parseInt(request.getParameter("feedbackId")));
        ps.setInt(2, userId);
        ps.executeUpdate();
        con.close();
        request.setAttribute("message", "Feedback deleted");
    }

    private void loadFeedbackSafely(HttpServletRequest request, String role, int userId) {
        try {
            loadFeedback(request, role, userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void loadFeedback(HttpServletRequest request, String role, int userId) throws Exception {
        String keyword = request.getParameter("keyword");
        boolean searching = keyword != null && !keyword.trim().isEmpty();

        String sql = "SELECT f.id, f.user_id, f.subject, f.message, f.created_at, u.name, u.email "
                + "FROM feedback f INNER JOIN users u ON f.user_id = u.id ";

        if ("admin".equals(role)) {
            if (searching) {
                sql += "WHERE f.subject LIKE ? OR f.message LIKE ? OR u.name LIKE ? OR u.email LIKE ? ";
            }
        } else {
            if (searching) {
                sql += "WHERE f.subject LIKE ? OR f.message LIKE ? OR u.name LIKE ? OR u.email LIKE ? ";
            } else {
                sql += "WHERE f.user_id=? ";
            }
        }

        sql += "ORDER BY f.id DESC";

        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);

        int index = 1;
        if ("user".equals(role) && !searching) {
            ps.setInt(index++, userId);
        }
        if (searching) {
            String searchText = "%" + keyword.trim() + "%";
            ps.setString(index++, searchText);
            ps.setString(index++, searchText);
            ps.setString(index++, searchText);
            ps.setString(index++, searchText);
        }

        ResultSet rs = ps.executeQuery();
        List<Map<String, String>> feedbackList = new ArrayList<Map<String, String>>();

        while (rs.next()) {
            Map<String, String> row = new HashMap<String, String>();
            row.put("id", rs.getString("id"));
            row.put("user_id", rs.getString("user_id"));
            row.put("subject", rs.getString("subject"));
            row.put("message", rs.getString("message"));
            row.put("created_at", rs.getString("created_at"));
            row.put("name", rs.getString("name"));
            row.put("email", rs.getString("email"));
            feedbackList.add(row);
        }

        con.close();
        request.setAttribute("feedbackList", feedbackList);
    }
}
