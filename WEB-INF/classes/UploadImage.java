import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import oracle.sql.*;
import oracle.jdbc.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import Database.db;

public class UploadImage extends HttpServlet {
    public String response_message;
    

    FileItem imageFile=null;
    String privacy_int="";
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	
	int pic_id;
	HttpSession session = request.getSession();
	String userName=(String)session.getAttribute("USERNAME");
        String subject=null; 	
	String place=null;
	String description=null;
        String privacy=null;
	
	try {
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List<FileItem> FileItems = fu.parseRequest(request);
	            
	    // Process the uploaded items, assuming only 1 image file uploaded
	    Iterator<FileItem> i = FileItems.iterator();
 
	    while (i.hasNext()){
		FileItem item = (FileItem) i.next();
		if(item.isFormField()){
		    if (item.getFieldName().equals("SUBJECT")){
			subject=item.getString();
		    }
		    if(item.getFieldName().equals("PLACE")){
			place=item.getString();
		    }
		    if(item.getFieldName().equals("DESCRIPTION")){
			description=item.getString();
		    }
                    if(item.getFieldName().equals("PRIVACY")){
		       privacy=item.getString();
		    }
		}
		else{
		    imageFile=item;
		    if (imageFile.getName().equals("")){
			String error="<p> No Image to Upload</p>";
			session.setAttribute("error", error);
			response.sendRedirect("uploadImage.jsp");
		    }
		}
	    }

	    //Get the image stream
	    InputStream instream = imageFile.getInputStream();

	    BufferedImage img = ImageIO.read(instream);
	    BufferedImage thumbNail = shrink(img, 7);
	    
            

	    // Connect to the database and create a statement
	    db newDB= new db();
	    Connection conn=newDB.connect();
	    Statement stmt = conn.createStatement();

      
	    /*
	     *  First, to generate a unique pic_id using an SQL sequence
	     */
	    ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
	    rset1.next();
	    pic_id = rset1.getInt(1);
            
            //String privacy_int="";
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
	    
		String sql="select group_id from groups where group_name='"+name+"' and user_name='"+creator+"'";
		rset1= stmt.executeQuery(sql);
	       
		while(rset1 != null && rset1.next())
		privacy_int=(rset1.getString(1)).trim();
	    }
	    
	    
	    //Insert an empty blob into the table first. Note that you have to 
	    //use the Oracle specific function empty_blob() to create an empty blob
	    stmt.execute("INSERT INTO images VALUES("+pic_id+",'"+userName+"','"+privacy_int+"','"+subject+"','"+place+"',sysdate,'"+description+"',empty_blob(),empty_blob())");
 
	    // to retrieve the lob_locator 
	    // Note that you must use "FOR UPDATE" in the select statement
	    String cmd = "SELECT * FROM images WHERE photo_id = "+pic_id+" FOR UPDATE";
	    ResultSet rset = stmt.executeQuery(cmd);
	    rset.next();
	    BLOB thumb = ((OracleResultSet)rset).getBLOB(8);
	    BLOB real = ((OracleResultSet)rset).getBLOB(9);
            
	    OutputStream thumbpic=null;
            OutputStream realpic=null;
	    //Write the image to the blob object
	    try{ 
               thumbpic = thumb.getBinaryOutputStream();
	       ImageIO.write(thumbNail, "jpg", thumbpic);
	   
	       realpic = real.getBinaryOutputStream();
	       ImageIO.write(img, "jpg", realpic);
	    }catch(Exception e){
		try{ 
		    thumbpic = thumb.getBinaryOutputStream();
		    ImageIO.write(thumbNail, "gif", thumbpic);
		
		    realpic = real.getBinaryOutputStream();
		    ImageIO.write(img, "gif", realpic);
		}catch(Exception f){
		    response_message = "Gif or jpg files only please";
		}
	    }
	   
	    
	    instream.close();
	    thumbpic.close();
	    realpic.close();

            stmt.executeUpdate("commit");
	    response_message = " Upload OK!  ";
            conn.close();

        } catch( Exception ex ) {
	    //System.out.println( ex.getMessage());
	    response_message = "Error in uploading photo please try again ";
	}
 
	//Output response to the client
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
		        "Transitional//EN\">\n" +
		        "<HTML>\n" +
                        "</head><div style='float: right'><form name=logout method=post action=logout.jsp><input type=submit name=logout value=logout></form></div>\n"+
		        "<HEAD><TITLE>Upload Message</TITLE></HEAD>\n" +
		        "<BODY>\n" +
		        "<H1>" +
		                response_message+
		        "</H1>\n" +
		    "<form method= post action=menu.jsp><input type=submit name=eSubmit value=Menu></form></BODY></HTML>");
    }

    
    //shrink image by a factor of n, and return the shrinked image
    public static BufferedImage shrink(BufferedImage image, int n) {

        int w = image.getWidth() / n;
        int h = image.getHeight() / n;

        BufferedImage shrunkImage =
            new BufferedImage(w, h, image.getType());

        for (int y=0; y < h; ++y)
            for (int x=0; x < w; ++x)
                shrunkImage.setRGB(x, y, image.getRGB(x*n, y*n));

        return shrunkImage;
    }
}