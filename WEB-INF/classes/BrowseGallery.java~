import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class BrowseGallery extends HttpServlet implements SingleThreadModel{
    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {

	//  send out the HTML file
	res.setContentType("text/html");
	PrintWriter out = res.getWriter ();
        
	out.println("<html>");
	out.println("<head>");
	out.println("<title> Photo List </title>");
	out.println("</head>");
        out.println("<div style='float: right'><form name=logout method=post action=logout.jsp><input type=submit name=logout value=logout></form>");
        out.println("<form name=logout method=post action=menu.jsp><input type=submit name=menu value=menu></form></div>");
	out.println("<body bgcolor=\"#000000\" text=\"#cccccc\" >");
	out.println("<center>");
	out.println("<h3>The List of Images </h3>");
	
        HttpSession session = request.getSession();
	try{
	 
	    /*
	     *Retrives a group id from pictureBrowse.jsp and from that the conditional statements get the appropriate pictures 
	     *for the user to see depending on the permissions they chose
	     */
                String query="";
                String userName=(String)session.getAttribute("USERNAME");
                String group_id=(String)session.getAttribute("PERMITTED");
		if (userName==null){
		    res.sendRedirect("login.jsp");
                    userName="";
		}

                if(userName.equals("admin")){
              	     query = "Select photo_id from images";
                }
                else if (group_id.equals("2")){
		     query = "Select photo_id from images where permitted='2' and owner_name='"+userName+"'";
		}
                else if (group_id.equals("all")){
		    //Sql query that gets all viewable pictures
		     query = "Select photo_id from images where permitted='2' and owner_name='"+userName+"'";
		}
                else if (group_id.equals("top")){
		    //Sql query that gets the top pictures
		     query = "Select photo_id from images where permitted='2' and owner_name='"+userName+"'";
		} 
		else{
		     query = "Select photo_id from images where permitted='"+group_id+"'";
		}
		session.removeAttribute("PERMITTED");
		

                Connection conn = getConnected();
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery(query);
		String p_id = "";
		while (rset.next() ) {
		    p_id = (rset.getObject(1)).toString();

		    // specify the servlet for the image
		    out.println("<a href=\"/proj1/GetBigPic?"+p_id+"\">");
		    // specify the servlet for the themernail
		    out.println("<img src=\"/proj1/GetOnePic?thumb"+p_id +"\"></a>");
		}
		stmt.close();
		conn.close();
	} catch ( Exception ex ){ out.println( ex.toString() );}

	out.println("</body>");
	out.println("</html>");
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
