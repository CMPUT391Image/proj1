<HTML>
<HEAD>
<TITLE>Main Menu</TITLE>
</HEAD>
<H1><CENTER>Main Menu</CENTER></H1>
<BODY>
<div style="float: right">
  <form name="logout" method="post" action="logout.jsp">
  <input type="submit" name="logout" value="logout">
  </form>
</div>
<%
String userName=(String)session.getAttribute("USERNAME");

//takes the user to the edit group page
out.println("<form method=post action=editGroup.jsp>");
out.println("<p>Edit a groups members:</p><input type=submit name=edit value=edit>");
out.println("</form>");
//takes the user to the creat group page
out.println("<form method=post action=createGroup.jsp>");
out.println("<p>Create a group:</p><input type=submit name=create value=create>");
out.println("</form>");
//takes the user to the delete group page
out.println("<form method=post action=deleteGroup.jsp>");
out.println("<p>Delete a group:</p><input type=submit name=delete value=delete>");
out.println("</form>");
//takes the user to the upload image page
out.println("<form method=post action=uploadImage.jsp>");
out.println("<p>Upload an image:</p><input type=submit name=upload value=upload>");
out.println("</form>");
//takes the user to picture browse page
out.println("<form method=post action=pictureBrowse.jsp>");
out.println("<p>Browse pictures:</p><input type=submit name=browse value=browse>");
out.println("</form>");
//takes the admin to the data analysis page
if (userName.equals("admin")){
   out.println("<form method=post action=Olapview.jsp>");
   out.println("<p>Analyze Data:</p><input type=submit name=analysis value=analysis>");
   out.println("</form>");
}
%>


</BODY>
</HTML>
