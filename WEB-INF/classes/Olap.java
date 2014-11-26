import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import Database.db;

public class Olap extends HttpServlet {
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
          HttpSession session = request.getSession();
                String userName=(String)session.getAttribute("USERNAME");
		PrintWriter out = response.getWriter();
		if (userName==null){
		    response.sendRedirect("login.jsp");
                    userName="";
		}
                if (!userName.equals("admin")){
                  out.println("Insufficient permissions!");
                }

		// pruint out form for analysis
		out.println("<html><head><title>" + "Data Analysis" + "</title></head>");
		out.println("<div style='float: right'>"
				+ "<form name='logout' method='post' action='logout.jsp'>"
				+ "<input type='submit' name='logout' value='logout'> </form>"
                                +"<form name=menu method=get action=menu.jsp><input type=submit name=menu value=menu></form>"
                                +" <form name=help method=get action=help.html><input type=submit name=help value=help></form>"
				+ "</div>");
		out.println("<body> <H1>Data Analysis</H1>"
				+ "<form name='olapresult' method='post' action = 'Olap'>"
				+ "Analyze Options:<br>"
				+ "<input type='checkbox' name='imageowner' value='1'></input> User: "
                            	+ "<input name='ownerText' type='text' size='30'></input> <br>"
				+ "<input type='checkbox' name='subjectBox' value='1'></input> Subject: "
				+ "<input name='subjectText' type='text' size='30'></input> <br>"
				+ "<input type='checkbox' name='time' value='1'></input> Find by date: <br>"
				+ "from: <input name='fromTime' placeholder ='DD/MM/YYYY' type='text' size='30'></input> <br>"
				+ "to: <input name='toTime' placeholder ='DD/MM/YYYY'type='text' size='30'></input><br>"
				+ "<hr>"
				+ "Order Time Period by:"
				+ "<input type='radio' name='order' value='Daily'></input> Daily"
				+ "<input type='radio' name='order' value='Monthly'></input> Monthly"
				+ "<input type='radio' name='order' value='Yearly'></input> Yearly<br><br>"
				+ "<input type='submit' name='analyze' value='Analyze'>"
				+ "</form>" + "</BODY></HTML>");

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// creating parameters
		String ownerBox = request.getParameter("imageowner");
		String subjectBox = request.getParameter("subjectBox");
		String subject = request.getParameter("subjectText");
                String owner = request.getParameter("ownerText");
		String timeBox = request.getParameter("time");
		String fromTime = request.getParameter("fromTime");
		String toTime = request.getParameter("toTime");
		String orderOp = request.getParameter("order");
		String sql = "";
		String view = "";
		String select = "select ";
		String where = "where ";
		String groupby = "group by cube(";
		String endGroupBy = "";
		int element = 0;
		PrintWriter out = response.getWriter();
		doGet(request, response);
		// all fields blank
		if (owner == null && subjectBox == null && timeBox == null
				&& orderOp == null) {
			out.println("<p>All fields were left blank");
		} else {
			// if owner box is ticked, data cube for owner
			if (ownerBox != null && ownerBox.equals("1")) {
				if (element > 0) {
					select += ", ";
					groupby += ", ";
				}
				select = select + "owner_name";
				groupby = groupby + "owner_name";
                                if (!owner.isEmpty()){
                                  where +="(owner_name like '%" + owner+ "%') ";
                                }
				view += "<th><b> Owner </b></th>";
				element++;
                                if ((timeBox != null && timeBox.equals("1"))
                                    ||(subjectBox!=null && subjectBox.equals("1"))) {
					where += " and ";
				}
			}
			// if subject box is ticked, datacube for owner. If keyword in
			// subject, use subject to search
			// otherwise use all subjects
			if (subjectBox != null && subjectBox.equals("1")) {
				if (element > 0) {
					select += ", ";
					groupby += ", ";
				}
				select += "subject";
				groupby += "subject";
				if (!subject.isEmpty()) {
					where += "(subject like '%" + subject + "%') ";
				}
				element++;
				view += "<th><b>Subject</b></th>";
				// if time is also a parameter, add and to select
				if (timeBox != null && timeBox.equals("1")) {
					where += " and ";
				}
			}
			// retrieve time ranges
			if (timeBox != null && timeBox.equals("1")) {
				if (!fromTime.isEmpty() && !toTime.isEmpty()) {
					where += " (trunc(timing) between to_date('" + fromTime
							+ "', 'DD/MM/YYYY') " + "AND to_date('" + toTime
							+ "','DD/MM/YYYY')) ";
				}
				// else only begining of time
				else if (!fromTime.isEmpty()) {
					where += " (trunc(timing) >= to_date('" + fromTime
							+ "','DD/MM/YYYY')) ";
				}
				// else only end of time
				else if (!toTime.isEmpty()) {
					where += " (trunc(timing) <= to_date('" + toTime
							+ "','DD/MM/YYYY')) ";
				}
				if (element > 0) {
					select += ", ";
					groupby += ", ";
				}
				element++;
				select += "trunc(timing)";
				groupby += "trunc(timing)";
				view += "<th><b>Date</b></th>";
			}

		}
		// second level drilling
		if (orderOp != null) {
			String header = null;
			if (element > 0) {
				select += ", ";
				endGroupBy += ", ";
			}
			if (orderOp.equals("Daily")) {
				header = "Day";
				select += "extract(day from timing)";
				endGroupBy += "extract(day from timing)";
			}
			if (orderOp.equals("Monthly")) {
				header = "Month";
				select += "extract(month from timing)";
				endGroupBy += "extract(month from timing)";
			}
			if (orderOp.equals("Yearly")) {
				header = "Year";
				select += "extract(year from timing)";
				endGroupBy += "extract(year from timing)";
			}
			element++;
			view += "<th><b>" + orderOp + "</b></th>";
		}
		// building queries
		// If everything is null except drilling parameters
		if (owner == null && subjectBox == null && timeBox == null) {
			sql = select + ",count(photo_id) " + "from images " + "group by "
					+ endGroupBy;
		}
		// else start building sql statement
		else {
			sql = select + ", count(photo_id)" + " from images ";
			// if there is no where statement, append group by
			if (where.equals("where ")) {
				sql += groupby;
			}
			// otherwise append where statement
			else {
				sql += where + groupby;
			}
			// check if we are grouping by drilling operation
			if (orderOp != null) {
				sql += ")" + endGroupBy;
			}
			// otherwise finish statement
			else {
				sql += ")";
			}

		}
		view = view + "<th><b>Number of Images</b></th>";

		//out.println(sql);
		out.println("<hr>");
		out.println("<table border = '1'><tr>" + view + "</tr>");
		db newDB = new db();

		Connection conn = newDB.connect();
		// printing out result set in table
		Statement stmt = null;
		ResultSet rset = null;
		// out.println(sql);

		try {
			stmt = conn.createStatement();
			rset = stmt.executeQuery(sql);
			String cell = "";
			while (rset != null && rset.next()) {
				out.println("<tr>");
				for (int i = 1; i <= element + 1; i++) {
					cell = (rset.getString(i));
					if (cell == null) {
						cell = "-";
					}
					out.println("<td>" + cell + "</td>");
				}
				out.println("</tr>");
			}
		} catch (Exception ex) {
			out.println("<hr>" + ex.getMessage() + "<hr>");
		} finally {
			try {
				conn.close();
			} catch (Exception ex) {
				out.println("<hr>" + ex.getMessage() + "<hr>");
			}
		}

	}
}
