import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.ArrayList;

/**
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet.
 *
 *   picture( photo_id: integer, title: varchar, place: varchar, 
 *            sm_image: blob,   image: blob )
 *
 *  The request must come with a query string as follows:
 *    GetOnePic?12:        sends the picture in sm_image with photo_id = 12
 *    GetOnePicture?big12: sends the picture in image  with photo_id = 12
 *Adapted from Dr.Yuan's GetBigPic.java
 *  @author  Kevin Tang, Tarek El Bohitimy
 *
 */
public class GetBigPic extends HttpServlet 
    implements SingleThreadModel {

    /**
     *This method inserts into unique_views whenever a unique viewer has viewed the image
     *
     *

     */

public void doPost2(HttpServletRequest request,
                   HttpServletResponse response)
	throws ServletException, IOException {
  		HttpSession session = request.getSession();
  String userName=(String)session.getAttribute("USERNAME");
  String picid  = request.getQueryString();
  	PrintWriter out = response.getWriter();
  String insert = "insert into unique_views values(" + picid + ",'"+userName+"')";
  
  Connection conn = null;
  try{
  conn = getConnected();
  	   Statement stmt = conn.createStatement();
           int success = stmt.executeUpdate(insert);
  }catch( Exception ex ) {
    //out.println( ex.getMessage() );
    //out.println("Did not insert");
	}
    try{
      conn.close();
  }catch( Exception ex ) {
          out.println("Did not close");
	}

  
}
    /**
     *    This method first gets the query string indicating PHOTO_ID,
     *    and then executes the query 
     *          select image from yuan.photos where photo_id = PHOTO_ID   
     *    Finally, it sends the picture to the client
     */
    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
	
	//  construct the query  from the client's QueryString
		HttpSession session = request.getSession();
	String userName=(String)session.getAttribute("USERNAME");
	String picid  = request.getQueryString();
	String query;
        doPost2(request,response);
	query = "select owner_name, timing, description, subject, place from images where photo_id="
	        + picid;

	//ServletOutputStream out = response.getOutputStream();
	PrintWriter out = response.getWriter();

	/*
	 *   to execute the given query
	 */
	Connection conn = null;
	try {
	    conn = getConnected();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    response.setContentType("text/html");
        String subject, place,timing, description;
		String owner_name = null;
		//print out picture and information
	    if ( rset.next() ) {
	        subject = rset.getString("subject");
	        place = rset.getString("place");
			owner_name = rset.getString("owner_name");
			timing = rset.getString("timing");
			description = rset.getString("description");
                out.println("<html><head><title>"+subject+ "</title>+</head>" +
	                 "<body bgcolor=\"#000000\" text=\"#cccccc\">" +
		 "<center><img src = \"/proj1/GetOnePic?"+picid+"\">" +
			 "<h3>" + subject +"  at " + place + " </h3>" + "<br> taken by: " + owner_name + " on "+timing +
			 "<br> <br>" + description);
            }
	    else
	      out.println("<html> Pictures are not available</html>");
		  
		  //if user is owner, show them the update/edit form
            if (userName.equals(owner_name) || userName.equals("admin")){
			ArrayList<String> privacy=new ArrayList<String>();
                   privacy.add("none");
		   privacy.add("public");
		   privacy.add("private");  
		   ResultSet rset2 = null;
	    	   String sql1 = "select group_name, user_name from groups where user_name ='"+userName+"'";
		   rset2 = stmt.executeQuery(sql1);
		   String nameCreator="";
		   String groupName = "";
		   String groupCreator="";
		   //getting permissions
		   while(rset2 != null && rset2.next()){
		       groupName = (rset2.getString(1)).trim();
		       groupCreator=(rset2.getString(2)).trim();
		       nameCreator=groupName+","+groupCreator;
		       privacy.add(nameCreator);
		   }
		   String sql2 = "select g1.group_name, g1.user_name from groups g1,group_lists g2 where g1.group_id=g2.group_id and g2.friend_id = '"+userName+"'";
                   rset2 = stmt.executeQuery(sql2);
                   while(rset2 != null && rset2.next()){
		       groupName = (rset2.getString(1)).trim();
		       groupCreator=(rset2.getString(2)).trim();
		       nameCreator=groupName+","+groupCreator;
		       privacy.add(nameCreator);
		   } 
				//Creating form, onclick = doPost
				out.println("</center>"
						+ "<h4> Edit Image: </h4>"
						+ "<form action='GetBigPic?"+ picid +"' method='post'>"
						+ "Subject: "
						+ "<input type='text' name='new_subject' maxlength='128' size='30'> <br>"
						+ "Place: "
						+ "<input type='text' name='new_place' maxlength='128' size='30'><br>"
						+ "Description: <Br> "
						+ "<textarea type='text' name='new_description' maxlength='2048' rows='10' cols='25'></textarea> <br>"
						+ "<th>Privacy (Group Name, Creator):</th>"
					        + " <td><select name='new_privacy'>");
				for (String item:privacy){//TAREK CHANGE
				    out.println( "<option value='"+item+"'>"+item 
						 + " </option>"); 
				 }
				out.println( "</select></td>"
						+ "<br><input type='submit' name='editButton' value='update' />"
						+ "</form>");

		}

		out.println("</body></html>"); 

				
	} catch( Exception ex ) {
	
	    out.println(ex.getMessage() );
	}
	// to close the connection
	finally {
	    try {
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
    }
	//called when update form button is clicked - this will udpate the image with the userinputted information
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		Connection conn = null;
		Statement stmt = null;
                ResultSet rset=null;//TAREK CHANGE
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		String userName=(String)session.getAttribute("USERNAME");
		String picid  = request.getQueryString();
		String subject = request.getParameter("new_subject");
		String place = request.getParameter("new_place");
		String description = request.getParameter("new_description");
		String sql = "Update images set ";
                String privacy = request.getParameter("new_privacy");//TAREK CHANGE
                try{
			conn = getConnected();
			stmt = conn.createStatement();
			
		 }
			
		catch(Exception ex){
		    out.println("<hr>" + sql +"<hr>");
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		}
		//creating sql statement for updating
		if (subject != "" || place != "" || description != "" || !privacy.equals("none")){//TAREK CHANGE
			if (subject != ""){
				sql+= "subject = '" + subject+ "'";
			}
			if (place != ""){
				if (subject != ""){
					sql+=", ";
				}
				sql+= "place = '" + place+ "'";
			}
			if (description != ""){
				if (subject != "" || place != ""){
					sql+=", ";
				}
				sql+= "description = '" + description+ "'";
			}
                        if (!privacy.equals("none")){
                            String privacy_int="";
			    if(privacy.equals("public")){
				privacy_int="1";
			    }
			    else if(privacy.equals("private")){
				privacy_int="2";
			    }
 
			    else{
				String[] parts=privacy.split(",");
				String name=parts[0];
				String creator=parts[1];
				try{
				    String sql1="select group_id from groups where group_name='"+name+"' and user_name='"+creator+"'";
				    rset=stmt.executeQuery(sql1);
				    while(rset != null && rset.next())
				    privacy_int=(rset.getString(1)).trim();
				    sql+="permitted = '" + privacy_int+"'";
				}
				catch(Exception ex1){
				    out.println("<hr>" + ex1.getMessage() + "<hr>");
				}
			    }
			}
			sql += " where photo_id = " + picid;
                        out.println(sql);
                        try{
                            stmt.executeUpdate(sql);
                        }
                        catch(Exception e){
			     out.println("<hr>" + e.getMessage() + "<hr>");
			}
		}
		
		doGet(request,response);
			try{
             conn.close();  
			 }       catch(Exception ex){
              out.println("<hr>" + ex.getMessage() + "<hr>");
        }
	
	}
	
	    /*
     *   Connect to the specified database
     */
	 
    private Connection getConnected() throws Exception {

	String username = "elbohtim";
	String password = "foster423";
        /* one may replace the following for the specified database */
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    String driverName = "oracle.jdbc.driver.OracleDriver";
	/*
	 *  to connect to the database
	 */
	Class drvClass = Class.forName(driverName); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password) );
    }
}
