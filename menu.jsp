<HTML>
<HEAD>
<TITLE>Main Menu</TITLE>
</HEAD>
<H1><CENTER>Main Menu</CENTER></H1>
<BODY>

<%

out.println("<form method=post action=editGroup.jsp>");
out.println("<p>Edit a groups members:</p><input type=submit name=edit value=edit>");
out.println("</form>");
out.println("<form method=post action=createGroup.jsp>");
out.println("<p>Create a group:</p><input type=submit name=create value=create>");
out.println("</form>");
out.println("<form method=post action=deleteGroup.jsp>");
out.println("<p>Delete a group:</p><input type=submit name=delete value=delete>");
out.println("</form>");
out.println("<form method=post action=uploadImage.jsp>");
out.println("<p>Upload an image:</p><input type=submit name=upload value=upload>");
out.println("</form>");
%>


</BODY>
</HTML>
