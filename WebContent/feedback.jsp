<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    ArrayList<HashMap<String, String>> feedbackList =
        (ArrayList<HashMap<String, String>>) request.getAttribute("feedbackList");

    String keyword = (String) request.getAttribute("keyword");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Feedback</title>
</head>
<body>

<h2>Feedback Management System</h2>

<p>
    Welcome, <b><%= session.getAttribute("username") %></b>
    |
    <a href="LogoutServlet">Logout</a>
</p>

<h3>Add Feedback</h3>

<form action="FeedbackServlet" method="post">
    <input type="hidden" name="action" value="add">

    <label>Title:</label><br>
    <input type="text" name="title" required><br><br>

    <label>Message:</label><br>
    <textarea name="message" rows="4" cols="40" required></textarea><br><br>

    <input type="submit" value="Add Feedback">
</form>

<hr>

<h3>Search Feedback</h3>

<form action="FeedbackServlet" method="get">
    <input type="hidden" name="action" value="search">

    <input type="text" name="keyword"
           value="<%= keyword != null ? keyword : "" %>"
           placeholder="Search feedback">

    <input type="submit" value="Search">
    <a href="FeedbackServlet?action=list">View All</a>
</form>

<hr>

<h3>All Feedback</h3>

<table border="1" cellpadding="8">
    <tr>
        <th>ID</th>
        <th>User</th>
        <th>Title</th>
        <th>Message</th>
        <th>Date</th>
        <th>Action</th>
    </tr>

<%
    if (feedbackList != null && feedbackList.size() > 0) {
        for (HashMap<String, String> feedback : feedbackList) {
%>
    <tr>
        <td><%= feedback.get("id") %></td>
        <td><%= feedback.get("username") %></td>
        <td><%= feedback.get("title") %></td>
        <td><%= feedback.get("message") %></td>
        <td><%= feedback.get("created_at") %></td>
        <td>
            <a href="FeedbackServlet?action=edit&id=<%= feedback.get("id") %>">Update</a>
            |
            <a href="FeedbackServlet?action=delete&id=<%= feedback.get("id") %>"
               onclick="return confirm('Are you sure you want to delete this feedback?');">
               Delete
            </a>
        </td>
    </tr>
<%
        }
    } else {
%>
    <tr>
        <td colspan="6">No feedback found</td>
    </tr>
<%
    }
%>

</table>

</body>
</html>
