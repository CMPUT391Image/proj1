
<HTML>
<HEAD>


<TITLE>Online Image Share</TITLE>
</HEAD>
<H1><CENTER>Online Image Sharer</CENTER></H1>
<BODY>
<%@ page import="java.sql.*" %>
<% 

   if(request.getParameter("bSubmit") != null)
   {
       //get the user input from the login page
       String userName = (request.getParameter("USERID")).trim();
       String passwd = (request.getParameter("PASSWD")).trim();
       
       //establish the connection to the underlying database
       Connection conn = null;
				
       String driverName = "oracle.jdbc.driver.OracleDriver";
       String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
					
       try{
           //load and register the driver
           Class drvClass = Class.forName(driverName); 
           DriverManager.registerDriver((Driver) drvClass.newInstance());
       }
       catch(Exception ex){
       out.println("<hr>" + ex.getMessage() + "<hr>");
   
       }
   
       try{
           //establish the connection 
           conn = DriverManager.getConnection(dbstring,"Username","password");//CHANGE THIS TO YOUR OWN USERNAME AND PASSWORD 
           conn.setAutoCommit(false);
       }
       catch(Exception ex){
   
       out.println("<hr>" + ex.getMessage() + "<hr>");
       }
   
   
       //select the user table from the underlying db and validate the user name and password
       Statement stmt = null;
       ResultSet rset = null;
       String sql = "select password from users where user_name = '"+userName+"'";
      // out.println(sql);
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
           //out.println("<p><b>Your Login is Successful!</b></p>");
           response.sendRedirect("menu.jsp");
       }
       else{
           out.println("<p><b>Either your userName or Your password is inValid!</b></p>");
           out.println("<form method=post action=login.jsp>");
           out.println("UserName: <input type=text name=USERID maxlength=20><br>");
           out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
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
%>



</BODY>
</HTML>