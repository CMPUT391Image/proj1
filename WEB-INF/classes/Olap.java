
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import Database.db;

                  public class Olap extends HttpServlet{
      public void doHTML(HttpServletRequest request,
                         HttpServletResponse response)
	throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        out.println("<html><head><title>"+"Data Analysis"+"</title></head>");
        out.println("<div style='float: right'>"
                    + "<form name='logout' method='post' action='logout.jsp'>"
                    + "<input type='submit' name='logout' value='logout'> </form>"
                    + "</div>");
        out.println("<body> <H1>Data Analysis</H1>"
                    + "<form name='olapresult' method='get' action='Olap'>"
                    + "Analyze Options:"
                    + "<input type='checkbox' name='imageowner' value='1'></input> User"
                    + "<input type='checkbox' name='subject' value='1'></input> Subject"
                    + "<input type='checkbox' name='time' value='1'></input> Time Period<br>"
                    + "Order Time Period by:" + "<select name='interval'>"
                    + "<option value='week'>Week</option>"
                    + "<option value='month'>Month</option>"
                    + "<option value='year'>Year</option>" + "</select><br>"
                    + "<input type='submit' name='analyze' value='Analyze'>"
                    + "</form>" + "</BODY></HTML>");

      }

      public void doGet(HttpServletRequest request,
                        HttpServletResponse response)
	throws ServletException, IOException {
        String owner = request.getParameter("imageowner");
        String subject = request.getParameter("subject");
        String time = request.getParameter("time");
        String sql="";
        String view="";
        String select="select ";
        String groupby="group by cube(";
        int element=0;
        
      
      }
                  }
