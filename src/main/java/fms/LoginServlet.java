package fms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM users WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                if ("admin".equals(rs.getString("role"))) {
                    response.sendRedirect("FeedbackServlet?action=view");
                } else {
                    response.sendRedirect("FeedbackServlet?action=view");
                }
            } else {
                request.setAttribute("message", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Login failed");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
