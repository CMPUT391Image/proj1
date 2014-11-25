<HTML>
<HEAD>
<TITLE>Results</TITLE>
</HEAD>
<BODY>

<H1>Results</H1>
<%@ page import="java.sql.*,Database.db,java.util.ArrayList" %>
<%
      String owner = request.getParameter("imageowner");
      String subject = request.getParameter("subject");
      String time = request.getParameter("time");
      String sql="";
      String view="";
      String select="select ";
      String groupby="group by cube(";
      int element=0;
      if (owner == null) {
          owner = "0";
      }
      if (subject == null) {
          subject = "0";
      }
      if (time == null) {
          time = "0";
      }
      if (owner.equals("0") && subject.equals("0") && time.equals("0")){
         out.println("<p>All fields were left blank");
      }
      else{
          if(owner.equals("1")){
            if (element==0){
               select=select+"owner_name";
               groupby=groupby+"owner_name"; 
            }
            else{
               select=select+",owner_name";
               groupby=groupby+",owner_name";
            }
            view=view+"<th><b> Owner </b></th>";
            element++;
          }
          if(subject.equals("1")){
            if (element==0){
               select=select+"subject";
               groupby=groupby+"subject"; 
            }
            else{
               select=select+",subject";
               groupby=groupby+",subject";
            }
            element++;
            view=view+"<th><b>Subject</b></th>";
          }
          if(time.equals("1")){
             String interval = request.getParameter("interval");
             if (interval.equals("week")){
                if (element==0){
                    select=select+"trunc(timing,'IW')";
                    groupby=groupby+"timing"; 
                }
                else{
                   select=select+",trunc(timing,'IW')";
                   groupby=groupby+",timing";
                }
                view=view+"<th><b>week</b></th>";
             }
             else if (interval.equals("month")){
                if (element==0){
                   select=select+"extract(month from trunc(timing,'MM'))";
                   groupby=groupby+"timing"; 
                }
                else{
                   select=select+",extract (month from trunc(timing,'MM'))";
                   groupby=groupby+",timing";
                }
                view=view+"<th><b>Month</b></th>";
             }
             else{
                if (element==0){
                   select=select+"extract(year from trunc(timing,'Y'))";
                   groupby=groupby+"timing"; 
                }
                else{
                   select=select+",extract (year from trunc(timing,'Y'))";
                   groupby=groupby+",timing";
                }
                view=view+"<th><b>Year</b></th>";
             }
             element++;
          }
          sql=select+", count(photo_id) from images " + groupby+")";
          view=view+"<th><b>Number of Images</b></th>";
       }
 %>
 <table border="1">        
     <tr>
        <%  out.println(view);%>
      </tr>
      <%
       db newDB= new db();

       Connection conn=newDB.connect();
           
       Statement stmt = null;
       ResultSet rset = null;
		out.println(sql);
       try{
           stmt = conn.createStatement();
           rset = stmt.executeQuery(sql);
           String cell="";
           while(rset != null && rset.next()){
              out.println("<tr>");
              for (int i=1;i<=element+1;i++){
                  cell=(rset.getString(i));
                  if(cell==null){
                    cell="-";
                  }
                  out.println("<td>"+cell+"</td>");        
              }
            out.println("</tr>");
           }
        } 
        catch(Exception ex){
              out.println("<hr>" + ex.getMessage() + "<hr>");
        }
        finally{
             conn.close();  
        }
%>
</table>
        



            
	  
<%      
out.println("<form method=post action=menu.jsp>");
out.println("<input type=submit name=menu value=menu>");
out.println("</form>");

%>

</BODY> 
</HTML>
