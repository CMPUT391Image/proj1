<HTML>
<HEAD>
<TITLE>CREATE GROUP</TITLE>
</HEAD>
<H1><CENTER>Create Group</CENTER></H1>
<BODY>
<div style="float: right">
   <form name="logout" method="post" action="logout.jsp">
   <input type="submit" name="logout" value="logout">
   </form>
   <form name="logout" method="post" action="menu.jsp">
   <input type="submit" name="menu" value="menu">
   </form>
</div>
<%@ page import="java.sql.*,Database.db" %>
<%
    if (request.getParameter("cSubmit")!=null)
    {

       int group_id;
       String userName=(String)session.getAttribute("USERNAME");

      //Making sure the user did not leave the group name blank
       String groupName=(request.getParameter("groupName")).trim();
       if (groupName.equals("")){
          out.println("<b>Please put in a name</b><br>");
       }
       else{
           //Connect to the database
           db newDB= new db();
           Connection conn=newDB.connect();
           Statement stmt = null;
           ResultSet rset = null;
                    

           try{
               stmt = conn.createStatement();
                        
               //Generating a unique group ID and adding the information into the database
               rset = stmt.executeQuery("SELECT group_id_sequence.nextval from dual");
               rset.next();
               group_id = rset.getInt(1);
               stmt.execute("INSERT INTO groups VALUES('"+group_id+"','"+userName+"','"+groupName+"',sysdate)");
              
               response.sendRedirect("menu.jsp");
           } catch(Exception ex){
               out.println("<p>You cannot give the same name to two different groups</p>");
           } 
           
           try{
              conn.close();  
           }
           catch(Exception ex){
               out.println("<hr>" + ex.getMessage() + "<hr>");
           }

           
    }
}
%>
<form method=post action=createGroup.jsp>
Group Name: <input type=text name=groupName size=24 maxlength=24><br>
<input type=submit name=cSubmit value=Submit>
</form>

</BODY>
</HTML>
