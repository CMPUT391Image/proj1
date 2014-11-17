<html>
<head>
<title>Logout</title>
</head>
<body>
<%
    session.removeAttribute("USERNAME");
    response.sendRedirect("login.jsp");
%>

</body>
</html>
