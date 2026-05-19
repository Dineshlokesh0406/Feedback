<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Feedback</title>
</head>
<body>

<h2>Update Feedback</h2>

<form action="FeedbackServlet" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<%= request.getAttribute("id") %>">

    <label>Title:</label><br>
    <input type="text" name="title"
           value="<%= request.getAttribute("title") %>"
           required><br><br>

    <label>Message:</label><br>
    <textarea name="message" rows="4" cols="40" required><%= request.getAttribute("message") %></textarea><br><br>

    <input type="submit" value="Update Feedback">
</form>

<br>

<a href="FeedbackServlet?action=list">Back</a>

</body>
</html>
