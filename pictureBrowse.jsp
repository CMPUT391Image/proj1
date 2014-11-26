<HTML>
<HEAD>
<TITLE>Picture Browse</TITLE>
</HEAD>
<BODY>
<div style="float: right">
   <form name="logout" method="post" action="logout.jsp">
   <input type="submit" name="logout" value="logout">
   </form>
   <form name="menu" method="post" action="menu.jsp">
   <input type="submit" name="menu" value="menu">
   </form>
</div>

<H1>Choose Group</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%
   String userName=(String)session.getAttribute("USERNAME");
   if (userName==null){
    response.sendRedirect("login.jsp");
    userName="";
   }
   
    db newDB= new db();
    Connection conn=newDB.connect();
   
    /*
     *If the user is admin sends them directly to Browse Gallery
     *since the admin has access to all pictures
     */
     if (userName.equals("admin")){
         response.sendRedirect("BrowseGallery");
     } 

     /*
      * Retrieves all the group names and their creators 
       *and puts them in a drop down box for the user to 
       * select which photos they are able and want to see
      */
      ArrayList<String> groups=new ArrayList<String>();
      groups.add("all viewable");
      groups.add("top");
      groups.add("public");
      groups.add("private");

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
         groups.add(nameCreator);
         
       }
       String sql1 = "select group_name, user_name from groups where user_name ='"+userName+"'";
   
       rset = stmt.executeQuery(sql1);
       while(rset != null && rset.next()){
          groupName = (rset.getString(1)).trim();
          groupCreator=(rset.getString(2)).trim();
          nameCreator=groupName+","+groupCreator;
          groups.add(nameCreator);
        }

        /*
         *Gets the group id for the group the user
         *wants to see its pictures and sends it to 
         *BrowseGallery.java so that it can get those
         *specific pictures
         */
        if (request.getParameter("hSubmit")!=null){
      
           String group1=request.getParameter("GROUPS");
           String group_int="";
           if(group1.equals("public")){
               group_int="1";	
           }
           else if(group1.equals("private")){
               group_int="2";
          }
          else if (group1.equals("all viewable")){
                group_int="all";
          }
          else if (group1.equals("top")){
                group_int="top";
          }
          else{
              String[] parts=group1.split(",");
              String name=parts[0];
              String creator=parts[1];
		           
	      String sql2="select group_id from groups where group_name='"+name+"' and user_name='"+creator+"'";
	      rset= stmt.executeQuery(sql2);
				              
              while(rset != null && rset.next())
	      group_int=(rset.getString(1)).trim();
          }
          session.setAttribute("PERMITTED",group_int);
          response.sendRedirect("BrowseGallery");
       }
 
       try{
          conn.close();  
       }
       catch(Exception ex){
           out.println("<hr>" + ex.getMessage() + "<hr>");
       }
   
 %>

<form  method="POST" action="pictureBrowse.jsp">
Select which pictures you want to see:<select name="GROUPS">
<% for (String item:groups){%>     
   <option value="<%=item %>">
      <%=item%>
   </option>
   <%}
   %>
</select><br>
<input type="submit" name="hSubmit" value="See">

</form>
</BODY> 
</HTML>
