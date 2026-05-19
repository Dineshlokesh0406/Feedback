<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>

<h2>Login</h2>

<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");

    if (error != null) {
%>
    <p style="color:red;"><%= error %></p>
<%
    }

    if (success != null) {
%>
    <p style="color:green;"><%= success %></p>
<%
    }
%>

<form action="LoginServlet" method="post">
    <label>Username:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <input type="submit" value="Login">
</form>

<p>New user? <a href="register.jsp">Register here</a></p>

</body>
</html>
