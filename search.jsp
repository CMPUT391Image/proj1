<!DOCTYPE html>
<html>
<head>
<title>Search</title>
</head>
<div style="float: right">
    <form name="logout" method="post" action="logout.jsp">
    <input type="submit" name="logout" value="logout">
    </form>
    <form name="logout" method="post" action="menu.jsp">
    <input type="submit" name="menu" value="menu">
    </form>
    <form name=help method=get action=help.html>
    <input type=submit name=help value=help>
    </form>
</div>
<body>
        <%
         String userName=(String)session.getAttribute("USERNAME");
         if (userName==null){
             response.sendRedirect("login.jsp");
         }
        %>
	<h1>Search</h1>
	<form name = "sResult" method="post" action="searchResult.jsp">
	By keywords: <input name = "searchKey" type="text" placeholder="Search..."></input> <br>
	<hr>
	Find posts by date:<br>

	from: <input name="searchFromTime" placeholder ="DD/MM/YYYY" type="text" size="30"></input> <br>
	to: <input name="searchToTime" placeholder ="DD/MM/YYYY"type="text" size="30"></input><br><br>
	Sort by:<br>
	<select name='sort'>
		<option value="none">None</option>
		<option value="desc">Descending</option>
		<option value="ascen">Ascending</option>
	</select>
	<br>
	<br>
	<input type = "submit" name ="searchData" value="Search">
	</form>
</body>
	<%
		String error = (String) session.getAttribute("error");
		if (error != null) {
			out.println(error);
			session.removeAttribute("error");
		}
	%>

</html>

