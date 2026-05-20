<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Feedback Management Login</title>
<style>
body { font-family: Arial, sans-serif; margin: 0; background: #eef2f6; color: #222; }
.box { width: 360px; margin: 80px auto; background: white; padding: 25px; border: 1px solid #ccc; }
h2 { margin-top: 0; text-align: center; }
input { width: 100%; padding: 10px; margin: 8px 0; box-sizing: border-box; }
button { width: 100%; padding: 10px; background: #245a8d; color: white; border: 0; cursor: pointer; }
a { color: #245a8d; }
.msg { color: #b00020; text-align: center; }
</style>
</head>
<body>
<div class="box">
    <h2>Feedback Management System</h2>
    <p class="msg">${message}</p>
    <form action="LoginServlet" method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>
    <p>New user? <a href="register.jsp">Register here</a></p>
    
</div>
</body>
</html>
