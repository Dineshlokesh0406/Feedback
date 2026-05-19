package com.feedback;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(username, password) VALUES(?, ?)"
            );
            ps.setString(1, username);
            ps.setString(2, password);

            int result = ps.executeUpdate();

            con.close();

            if (result > 0) {
                response.sendRedirect("login.jsp?success=Registration successful. Please login.");
            } else {
                response.sendRedirect("register.jsp?error=Registration failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Username already exists");
        }
    }
}
