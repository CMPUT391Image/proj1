<HTML>
<HEAD>
<TITLE>Image Upload</TITLE>
</HEAD>
<BODY>

<H1>Upload Image</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%

   //Used this as resource https://www.daniweb.com/web-development/jsp/threads/412354/populating-a-drop-down-box-with-data-in-sql
   

   String error=(String)session.getAttribute("error");
   if (error!=null){
      out.println(error);
      session.removeAttribute("error");
   }
   
   String userName=(String)session.getAttribute("USERNAME");
   db newDB= new db();
   Connection conn=newDB.connect();
    
   ArrayList<String> privacy=new ArrayList<String>();
   privacy.add("public");
   privacy.add("private");  
   
   Statement stmt = null;
   ResultSet rset = null;
   
   String sql = "select group_name from groups g1,group_lists g2 where g1.group_id=g2.group_id and g2.friend_id = '"+userName+"'";
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
      privacy.add(groupName);
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
    <th>Privacy:</th>
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
