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
  <form name=help method=get action=help.html><input type=submit name=help value=help></form>
</div>
<%
String userName=(String)session.getAttribute("USERNAME");

if (userName==null){
    response.sendRedirect("login.jsp");
}
else{

    //Go to groups page
    out.println("<form method=post action=groups.jsp>");
    out.println("<p>Go to groups page:</p><input type=submit name=groups value=groups>");
    out.println("</form>");
    //takes the user to the upload image page
    out.println("<form method=post action=uploadImage.jsp>");
    out.println("<p>Upload an image:</p><input type=submit name=upload value=upload>");
    out.println("</form>");
    //takes the user to picture browse page
    out.println("<form method=post action=pictureBrowse.jsp>");
    out.println("<p>Browse pictures:</p><input type=submit name=browse value=browse>");
    out.println("</form>");
    //takes user to search
    out.println("<form method=post action=search.jsp>");
    out.println("<p>Search pictures:</p><input type=submit name=search value=search>");
    out.println("</form>");
    //takes the admin to the data analysis page
    if (userName.equals("admin")){
       out.println("<form method=get action=Olap>");
       out.println("<p>Analyze Data:</p><input type=submit name=analysis value=analysis>");
       out.println("</form>");
    }
}
%>


</BODY>
</HTML>
