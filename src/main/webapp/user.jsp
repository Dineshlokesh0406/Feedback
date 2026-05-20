<%@ page import="java.util.*" %>
<%
if (session.getAttribute("userId") == null || !"user".equals(session.getAttribute("role"))) {
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
<title>User Dashboard</title>
<style>
body { font-family: Arial, sans-serif; margin: 0; background: #f4f6f8; color: #222; }
.top { background: #245a8d; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
.nav { display: flex; gap: 18px; align-items: center; }
.nav a, .nav button { color: white; background: none; border: 0; padding: 0; font: inherit; text-decoration: underline; cursor: pointer; }
.wrap { width: 90%; margin: 25px auto; }
.panel { background: white; padding: 18px; border: 1px solid #ccc; margin-bottom: 20px; }
input, textarea { padding: 9px; margin: 5px 0; box-sizing: border-box; }
textarea { width: 100%; height: 70px; }
button { padding: 9px 14px; background: #245a8d; color: white; border: 0; cursor: pointer; }
.button-link { display: inline-block; padding: 9px 14px; background: #245a8d; color: white; text-decoration: none; }
table { width: 100%; border-collapse: collapse; background: white; }
th, td { border: 1px solid #ccc; padding: 10px; text-align: left; vertical-align: top; }
th { background: #e7edf3; }
.msg { color: #1f6b2a; }
.small-input { width: 180px; }
.edit-form { display: none; margin-top: 12px; }
</style>
</head>
<body>
<div class="top">
    <span>Welcome, <%= session.getAttribute("name") %></span>
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
            <input class="small-input" type="text" name="name" value="<%= session.getAttribute("name") %>" required>
            <input class="small-input" type="email" name="email" value="<%= session.getAttribute("email") %>" required>
            <input class="small-input" type="text" name="username" value="<%= session.getAttribute("username") %>" required>
            <input class="small-input" type="password" name="password" placeholder="New password">
            <button type="submit">Update Profile</button>
        </form>
    </div>

    <div class="panel">
        <h3>Add Feedback</h3>
        <form action="FeedbackServlet" method="post">
            <input type="hidden" name="action" value="add">
            <input type="text" name="subject" placeholder="Subject" required style="width:100%;">
            <textarea name="message" placeholder="Write feedback" required></textarea>
            <button type="submit">Add Feedback</button>
        </form>
    </div>

    <div class="panel">
        <h3>Search Feedback</h3>
        <form action="FeedbackServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Search all feedback">
            <button type="submit">Search</button>
            <a class="button-link" href="FeedbackServlet?action=viewAll">View All</a>
            <a class="button-link" href="FeedbackServlet?action=view">Clear Search</a>
        </form>
    </div>

    <h3>Feedback List</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>User</th>
            <th>Subject</th>
            <th>Message</th>
            <th>Date</th>
            <th>Update</th>
            <th>Delete</th>
        </tr>
        <% for (Map<String, String> feedback : feedbackList) { %>
        <tr>
            <td><%= feedback.get("id") %></td>
            <td><%= feedback.get("name") %></td>
            <td><%= feedback.get("subject") %></td>
            <td><%= feedback.get("message") %></td>
            <td><%= feedback.get("created_at") %></td>
            <td>
                <% if (String.valueOf(session.getAttribute("userId")).equals(feedback.get("user_id"))) { %>
                <button type="button" onclick="openEditForm('<%= feedback.get("id") %>')">Update</button>
                <div class="edit-form" id="editForm<%= feedback.get("id") %>">
                    <form action="FeedbackServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="feedbackId" value="<%= feedback.get("id") %>">
                        <input type="text" name="subject" value="<%= feedback.get("subject") %>" required>
                        <textarea name="message" required><%= feedback.get("message") %></textarea>
                        <button type="submit">Save</button>
                    </form>
                </div>
                <% } else { %>
                View only
                <% } %>
            </td>
            <td>
                <% if (String.valueOf(session.getAttribute("userId")).equals(feedback.get("user_id"))) { %>
                <form action="FeedbackServlet" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="feedbackId" value="<%= feedback.get("id") %>">
                    <button type="submit">Delete</button>
                </form>
                <% } else { %>
                View only
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
</div>
<script>
function openProfile() {
    document.getElementById("profilePanel").style.display = "block";
}

function openEditForm(feedbackId) {
    document.getElementById("editForm" + feedbackId).style.display = "block";
}
</script>
</body>
</html>
