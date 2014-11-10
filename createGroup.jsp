<HTML>
<HEAD>
<TITLE>CREATE GROUP</TITLE>
</HEAD>
<H1><CENTER>Create Group</CENTER></H1>
<BODY>
<%@ page import="java.sql.*,Database.db" %>
<%
    if (request.getParameter("cSubmit")!=null)
    {

       int group_id;
       String userName=(String)session.getAttribute("USERNAME");


       String groupName=(request.getParameter("groupName")).trim();
       if (groupName.equals("")){
          out.println("<b>Please put in a name</b><br>");
       }
       else{
           db newDB= new db();
           Connection conn=newDB.connect();
           //select the user table from the underlying db and validate the user name and password
           Statement stmt = null;
           ResultSet rset = null;
           String sql = "select group_name from groups where group_name = '"+groupName+"'";
                    

           try{
               stmt = conn.createStatement();
               rset = stmt.executeQuery(sql);
           }
   
           catch(Exception ex){
               out.println("<hr>" + ex.getMessage() + "<hr>");
           } 
   
           ResultSet rset1 = stmt.executeQuery("SELECT group_id_sequence.nextval from dual");
           rset1.next();
           group_id = rset1.getInt(1);
         

           String truegroup = "";
   
           while(rset != null && rset.next())
           truegroup = (rset.getString(1)).trim();
           //ASK ABOUT DUPLICATE GROUP NAMES
           //display the result
         //  if(groupName.equals(truegroup)){
           //     out.println("<b>Group name has been already taken</b><br>");
          // }
          // else{
               stmt.execute("INSERT INTO groups VALUES('"+group_id+"','"+userName+"','"+groupName+"',sysdate)");
               response.sendRedirect("menu.jsp");
      
           //}
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
