 
<HTML>
<HEAD>


<TITLE>Online Image Share</TITLE>
</HEAD>
<H1><CENTER>Online Image Sharer</CENTER></H1>
<div style='float: right'><form name=help method=get action=help.html><input type=submit name=help value=help></form></div>
<BODY>
<%@ page import="java.sql.*,Database.db" %>
<% 

   if(request.getParameter("bSubmit") != null)
   {
       //get the user input from the login page
       String userName = (request.getParameter("USERID")).trim();
       String passwd = (request.getParameter("PASSWD")).trim();
       
       //establish the connection to the underlying database
      
       db newDB= new db();
       Connection conn=newDB.connect();
   	 
     
   
       //select the user table from the underlying db and validate the user name and password
       Statement stmt = null;
       ResultSet rset = null;
       String sql = "select password from users where user_name = '"+userName+"'";
     
       try{
           stmt = conn.createStatement();
           rset = stmt.executeQuery(sql);
       }
   
       catch(Exception ex){
       out.println("<hr>" + ex.getMessage() + "<hr>");
       }
   
       String truepwd = "";
   
       while(rset != null && rset.next())
       truepwd = (rset.getString(1)).trim();
   
       //display the result
       if(passwd.equals(truepwd) && !userName.equals("")){
           session.setAttribute("USERNAME",userName);
           response.sendRedirect("menu.jsp");
       }
       else{
           out.println("<p><b>Either your user name or your password is invalid!</b></p>");
           out.println("<form method=post action=login.jsp>");
           out.println("UserName: <input type=text name=USERID maxlength=24><br>");
           out.println("Password: <input type=password name=PASSWD maxlength=24><br>");
           out.println("<input type=submit name=bSubmit value=Submit>");
           out.println("</form>");
       
       }

       try{
        conn.close();  
       }
       catch(Exception ex){
           out.println("<hr>" + ex.getMessage() + "<hr>");
       }
   }
   else
   {
       out.println("<form method=post action=login.jsp>");
       out.println("UserName: <input type=text name=USERID maxlength=20><br>");
       out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
       out.println("<input type=submit name=bSubmit value=Submit>");
       out.println("</form>");
   }    

   //Button to go to registration  
%>
<hr>
Register
<form method=post action=register.jsp>
<input type=submit name=register value=register>
</form>



</BODY>
</HTML>
