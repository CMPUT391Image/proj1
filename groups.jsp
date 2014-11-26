<HTML>
<HEAD>
<TITLE>Groups</TITLE>
</HEAD>
<H1><CENTER>Groups</CENTER></H1>
<BODY>
<div style="float: right">
  <form name="logout" method="post" action="logout.jsp">
  <input type="submit" name="logout" value="logout">
  </form>
  <form name="menu" method="post" action="menu.jsp">
  <input type="submit" name="menu" value="menu">
  </form>
</div>
<%
   String userName=(String)session.getAttribute("USERNAME");
   if (userName==null){
    response.sendRedirect("login.jsp");
   }
   //takes the user to the edit group page
   out.println("<form method=post action=editGroup.jsp>");
   out.println("<p>Edit a groups members:</p><input type=submit name=edit value=edit>");
   out.println("</form>");
   //takes the user to the create group page
   out.println("<form method=post action=createGroup.jsp>");
   out.println("<p>Create a group:</p><input type=submit name=create value=create>");
   out.println("</form>");
   //takes the user to the delete group page
   out.println("<form method=post action=deleteGroup.jsp>");
   out.println("<p>Delete a group:</p><input type=submit name=delete value=delete>");
   out.println("</form>");
%>


</BODY>
</HTML>
