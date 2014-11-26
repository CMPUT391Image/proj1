<HTML>
<HEAD>
<TITLE>Remove Group</TITLE>
</HEAD>
<BODY>
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
<H1>Remove Group</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%
  
  String userName=(String)session.getAttribute("USERNAME");
  if (userName==null){
    response.sendRedirect("login.jsp");
  }
  db newDB= new db();
  Connection conn=newDB.connect();
  /*
   *Retrieves all the groups that the user owns and 
   * puts it in a drop down box for easier access
   * so that the user can remove the group
   */  
  ArrayList<String> myGroup=new ArrayList<String>();  
   
  Statement stmt = null;
  ResultSet rset = null;
   
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

  /*
  *Takes the group the user wishes to delete and removes all its members
  *and sets all the images that were part of that group to private,
  * then finally removes the group from the database
  */
  if(request.getParameter("fSubmit")!=null){
     String group=request.getParameter("PASTGROUP");
     String sql1 = "select group_id from groups where group_name='"+group+"' and user_name='"+userName+"'";
     
     ResultSet rset1=stmt.executeQuery(sql1);
     String group_id=""; 
     while(rset1 != null && rset1.next())
     group_id = (rset1.getString(1)).trim();

     stmt.execute("update images set permitted='2' where permitted='"+group_id+"'");      
     stmt.execute("delete from group_lists where group_id='"+group_id+"'");
     stmt.execute("delete from groups where group_id='"+group_id+"'");
     response.sendRedirect("menu.jsp");
  }
  try{
     conn.close();  
  }
  catch(Exception ex){
     out.println("<hr>" + ex.getMessage() + "<hr>");
  } 
%>
<form method=post action=deleteGroup.jsp>
Group:<select name="PASTGROUP">
<% for (String item:myGroup){%>     
   <option value="<%=item %>">
      <%=item%>
   </option>
   <%}
   %>
</select><br>
<input type="submit" name="fSubmit" value="remove">

</form>
</BODY> 
</HTML>
