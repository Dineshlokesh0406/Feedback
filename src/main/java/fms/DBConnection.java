package fms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = System.getProperty("db.url", "jdbc:mysql://localhost:3306/feedback_db");
    private static final String USERNAME = System.getProperty("db.username", "root");
    private static final String PASSWORD = System.getProperty("db.password", "password");

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found in WEB-INF/lib", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
