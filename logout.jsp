<html>
<head>
<title>Logout</title>
</head>
<body>
<%
    //The user logouts and gets redirected to the login page
    session.removeAttribute("USERNAME");
    response.sendRedirect("login.jsp");
%>

</body>
</html>
