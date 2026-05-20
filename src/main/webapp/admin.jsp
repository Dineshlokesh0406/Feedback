<%@ page import="java.util.*" %>
<%
if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect("login.jsp");
    return;
}
if (request.getAttribute("feedbackList") == null) {
    response.sendRedirect("FeedbackServlet?action=view");
    return;
}
List<Map<String, String>> feedbackList = (List<Map<String, String>>) request.getAttribute("feedbackList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
<style>
body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f8; color: #222; }
.top { background: #245a8d; color: white; padding: 15px 30px; }
.top a { color: white; float: right; }
.wrap { width: 90%; margin: 25px auto; }
.panel { background: white; padding: 18px; border: 1px solid #ccc; margin-bottom: 20px; }
input { padding: 9px; width: 260px; }
button { padding: 9px 14px; background: #245a8d; color: white; border: 0; cursor: pointer; }
table { width: 100%; border-collapse: collapse; background: white; }
th, td { border: 1px solid #ccc; padding: 10px; text-align: left; vertical-align: top; }
th { background: #e7edf3; }
</style>
</head>
<body>
<div class="top">
    Admin Dashboard
    <a href="LogoutServlet">Logout</a>
</div>
<div class="wrap">
    <div class="panel">
        <h3>Search Feedback</h3>
        <form action="FeedbackServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search all feedback">
            <button type="submit">Search</button>
            <a href="FeedbackServlet?action=view">View All</a>
        </form>
    </div>

    <h3>All Feedback</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Email</th>
            <th>Subject</th>
            <th>Message</th>
            <th>Date</th>
        </tr>
        <% for (Map<String, String> feedback : feedbackList) { %>
        <tr>
            <td><%= feedback.get("id") %></td>
            <td><%= feedback.get("name") %></td>
            <td><%= feedback.get("email") %></td>
            <td><%= feedback.get("subject") %></td>
            <td><%= feedback.get("message") %></td>
            <td><%= feedback.get("created_at") %></td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>
