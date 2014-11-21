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
 *
 *  @author  Li-Yan Yuan
 *
 */
public class GetBigPic extends HttpServlet 
    implements SingleThreadModel {

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
	      out.println("<html> Pictures are not avialable</html>");
		  
		if (userName == owner_name){
			out.println("HELLO </BODY></HTML>");	
		}
		else{ 
 		   ArrayList<String> privacy=new ArrayList<String>();
		   privacy.add("public");
		   privacy.add("private");  
		    ResultSet rset2 = null;
	    	String sql1 = "select group_name, user_name from groups where user_name ='"+userName+"'";
			rset2 = stmt.executeQuery(sql1);
			String nameCreator="";
			String groupName = "";
			String groupCreator="";
			while(rset2 != null && rset.next()){
				groupName = (rset.getString(1)).trim();
				groupCreator=(rset.getString(2)).trim();
				nameCreator=groupName+","+groupCreator;
				privacy.add(nameCreator);
				}
		out.println("</center>" +"<h4> Edit Image: </h4>"
			+ "<form action='editImage' method='post'>"
			+ "Subject: " + "<input type='text' name='SUBJECT' maxlength='128' size='30'> <br>" 
			+ "Place: "+"<input type='text' name='PLACE' maxlength='128' size='30'><br>"
			+ "Description: "+"<textarea type='text' name='DESCRIPTION' maxlength='2048' rows='10' cols='25'></textarea> <br>"
			
			+ "<input type='submit' name='editButton' value='Update' />"
			+ "</form>");
		out.println("GOODBYE</body></html>"); }
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