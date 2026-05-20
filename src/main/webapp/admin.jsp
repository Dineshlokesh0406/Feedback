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
.top { background: #245a8d; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
.nav { display: flex; gap: 18px; align-items: center; }
.nav a, .nav button { color: white; background: none; border: 0; padding: 0; font: inherit; text-decoration: underline; cursor: pointer; }
.wrap { width: 90%; margin: 25px auto; }
.panel { background: white; padding: 18px; border: 1px solid #ccc; margin-bottom: 20px; }
input { padding: 9px; width: 260px; }
button { padding: 9px 14px; background: #245a8d; color: white; border: 0; cursor: pointer; }
.button-link { display: inline-block; padding: 9px 14px; background: #245a8d; color: white; text-decoration: none; }
table { width: 100%; border-collapse: collapse; background: white; }
th, td { border: 1px solid #ccc; padding: 10px; text-align: left; vertical-align: top; }
th { background: #e7edf3; }
.msg { color: #1f6b2a; }
</style>
</head>
<body>
<div class="top">
    <span>Admin Dashboard</span>
    <div class="nav">
        <button type="button" onclick="openProfile()">Profile</button>
        <a href="LogoutServlet">Logout</a>
    </div>
</div>
<div class="wrap">
    <p class="msg">${message}</p>

    <div class="panel" id="profilePanel" style="display:none;">
        <h3>Edit Profile</h3>
        <form action="ProfileServlet" method="post">
            <input type="text" name="name" value="<%= session.getAttribute("name") %>" required>
            <input type="email" name="email" value="<%= session.getAttribute("email") %>" required>
            <input type="text" name="username" value="<%= session.getAttribute("username") %>" required>
            <input type="password" name="password" placeholder="New password">
            <button type="submit">Update Profile</button>
        </form>
    </div>

    <div class="panel">
        <h3>Search Feedback</h3>
        <form action="FeedbackServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search all feedback">
            <button type="submit">Search</button>
            <a class="button-link" href="FeedbackServlet?action=view">View All</a>
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
<script>
function openProfile() {
    document.getElementById("profilePanel").style.display = "block";
}
</script>
</body>
</html>
