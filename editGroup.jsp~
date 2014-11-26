<HTML>
<HEAD>
<TITLE>Edit Group</TITLE>
</HEAD>
<BODY>
<div style="float: right">
   <form name="logout" method="post" action="logout.jsp">
   <input type="submit" name="logout" value="logout">
   </form>   
   <form name="logout" method="post" action="menu.jsp">
   <input type="submit" name="menu" value="menu">
   </form> 
</div>

<H1>Edit Group</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%
  String userName=(String)session.getAttribute("USERNAME");
  if (userName==null){
    response.sendRedirect("login.jsp");
  }
  db newDB= new db();
  Connection conn=newDB.connect();
    
  ArrayList<String> myGroup=new ArrayList<String>();  
   
  Statement stmt = null;
  ResultSet rset = null;
  //Getting all the group names to add them into a drop down box   
  String sql = "select group_name from groups where user_name='"+userName+"'";
  try{
     stmt = conn.createStatement();
     rset = stmt.executeQuery(sql);
  }
   
  catch(Exception ex){
      out.println("<hr>" + ex.getMessage() + "<hr>");
  }
  String groupName = "";
   
  while(rset != null && rset.next()){
      groupName = (rset.getString(1)).trim();
      myGroup.add(groupName);
  }

  if (request.getParameter("dSubmit")!=null){
      String action=request.getParameter("ACTION");
      String member=request.getParameter("USERNAME");
      String group=request.getParameter("MYGROUP");
      String notice=null;
      notice=request.getParameter("NOTICE");

       //Getting the group id so that we can use that id for the group_lists table
      String sql1 = "select group_id from groups where group_name='"+group+"' and user_name='"+userName+"'";
      rset = stmt.executeQuery(sql1);

      String group_id="";
      while(rset != null && rset.next())
      group_id = (rset.getString(1)).trim();
      //Add a user to a group and displaying proper error messages
      if (action.equals("Add")){
         try{
             stmt.execute("INSERT INTO group_lists VALUES('"+group_id+"','"+member+"',sysdate,'"+notice+"')");
             response.sendRedirect("menu.jsp");
         }
         catch(Exception ex){
             out.println("<p><b>Either member doesn't exist or is already in the group</b></p>");
         }
      }
      else{

         //Removing user from a group and displaying the proper error messages
         try{
             String sql2 = "select friend_id from group_lists where group_id='"+group_id+"'and friend_id='"+member+"'";
             rset = stmt.executeQuery(sql2);

             String check="";
             while(rset != null && rset.next())
             check = (rset.getString(1)).trim();
             if (check.equals("")){
                 out.println("<p><b>Member is not in the group</b></p>");
             }
             else{
               stmt.execute("update images set permitted='2' where permitted='"+group_id+"' and user_name='"+member+"'");   
               stmt.execute("delete from group_lists where group_id='"+group_id+"'and friend_id='"+member+"'");
               response.sendRedirect("menu.jsp");
             }
         }
         catch(Exception ex){
             out.println("<p><b>Member is already not in the group</b></p>");
         }
      } 
   }
  try{
     conn.close();  
  }
  catch(Exception ex){
     out.println("<hr>" + ex.getMessage() + "<hr>");
  }
%>

<form method=post action=editGroup.jsp>
Group:<select name="MYGROUP">
<% for (String item:myGroup){%>     
   <option value="<%=item %>">
      <%=item%>
   </option>
   <%}
   %>
</select><br>

User Name:<input type="text" name="USERNAME" maxlength="24" size="24"><br>

Action:<select name="ACTION">
<option value="Add">Add</option>
<option value="Remove">Remove</option>
</select><br>


Notice:<br><textarea type="text" name="NOTICE" maxlength="1024" rows="16" cols="32" ></textarea><br>
(Please leave blank if removing a member)<br>
<input type="submit" name="dSubmit" value="Edit">

</form>
</BODY> 
</HTML>
