<HTML>
<HEAD>
<TITLE>Image Upload</TITLE>
</HEAD>
<BODY>
<div style="float: right">
   <form name="logout" method="post" action="logout.jsp">
   <input type="submit" name="logout" value="logout">
   </form>
</div>

<H1>Upload Image</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%
  

   String error=(String)session.getAttribute("error");
   if (error!=null){
      out.println(error);
      session.removeAttribute("error");
   }
   
   String userName=(String)session.getAttribute("USERNAME");
   db newDB= new db();
   Connection conn=newDB.connect();
  /*
   *Gets all the groups the user owns and is a part of
   *and puts in a drop down box for them
   */  
   ArrayList<String> privacy=new ArrayList<String>();
   privacy.add("public");
   privacy.add("private");  
   
   Statement stmt = null;
   ResultSet rset = null;
   
   String sql = "select g1.group_name, g1.user_name from groups g1,group_lists g2 where g1.group_id=g2.group_id and g2.friend_id = '"+userName+"'";
   try{
       stmt = conn.createStatement();
       rset = stmt.executeQuery(sql);
   }
   
   catch(Exception ex){
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }
   String nameCreator="";
   String groupName = "";
   String groupCreator="";
   while(rset != null && rset.next()){
      groupName = (rset.getString(1)).trim();
      groupCreator=(rset.getString(2)).trim();
      nameCreator=groupName+","+groupCreator;
      privacy.add(nameCreator);
   }
  
   String sql1 = "select group_name, user_name from groups where user_name ='"+userName+"'";
   
   rset = stmt.executeQuery(sql1);
   while(rset != null && rset.next()){
      groupName = (rset.getString(1)).trim();
      groupCreator=(rset.getString(2)).trim();
      nameCreator=groupName+","+groupCreator;
      privacy.add(nameCreator);
   } 

   try{
       conn.close();  
   }
   catch(Exception ex){
       out.println("<hr>" + ex.getMessage() + "<hr>");
   } 
 %>
<form name="upload-image" method="POST" enctype="multipart/form-data" action="UploadImage">
<table>
 
</table>
Please input or select the path of the image!
<table>
  <tr>
    <th>File path: </th>
    <td><input name="file-path" type="file" size="30" ></input></td>
  </tr>
  <tr>
    <th>Subject:</th>
    <td><input type="text" name="SUBJECT" maxlength="128" size="128"></td>
  </tr>
  <tr>
    <th>Place:</th>
    <td><input type="text" name="PLACE" maxlength="128" size="128"></td>
  </tr>
  <tr>
    <th>Description:</th>
    <td><textarea type="text" name="DESCRIPTION" maxlength="2048" rows="32" cols="64" ></textarea></td>
  </tr>
  <tr>
    <th>Privacy (Group Name, Creator):</th>
    <td><select name="PRIVACY">
    <% for (String item:privacy){%>     
       <option value="<%=item %>">
          <%=item%>
       </option>
    <%}
    %>
    </select></td>
  </tr>
  <tr>
    <td ALIGN=CENTER COLSPAN="2"><input type="submit" name=".submit" 
     value="Upload"></td>
  </tr>
</table>
</form>
</BODY> 
</HTML>
