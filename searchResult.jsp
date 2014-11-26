<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE HTML>
<%
	//retrieves the text field paramters from search.jsp
	String kWord = request.getParameter("searchKey");
	String fromTime = request.getParameter("searchFromTime");
	String toTime = request.getParameter("searchToTime");
	String sortType = request.getParameter("sort");
	//error checks to make sure required text fields have values
	if (kWord == "" && fromTime == "" && toTime == "") {
		String error = "<p><b><font color=ff0000>You have not entered in all required search parameters!</font></b></p>";
		session.setAttribute("error", error);
		response.sendRedirect("search.jsp");
		return;
	}
%>

<HTML>
<HEAD>
<TITLE> Search Results</Title>
</head>

<body>
		<%
	String m_url = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    String m_driverName = "oracle.jdbc.driver.OracleDriver";
	  
	String m_userName = "elbohtim"; //supply username
    String m_password = "foster423"; //supply password
            
    Connection m_con;
	      
      try
      {
      
        Class drvClass = Class.forName(m_driverName);
        DriverManager.registerDriver((Driver)
        drvClass.newInstance());
        m_con = DriverManager.getConnection(m_url, m_userName, m_password);
        
      } 
      catch(Exception e)
      {      
        out.print("Error displaying data: ");
        out.println(e.getMessage());
        return;
      }
	  %>
	  <%	
	  //Rank(photo_id) = 6*frequency(subject) + 3*frequency(place) + frequency(description)
	String userID = (String) session.getAttribute("person_id");
	out.println("<HTML>");
	out.println("<h1>search</h1>");
	out.println("<BODY>Searching for: " + request.getParameter("searchKey") + "<BR>");
	
	String[] keywords = kWord.split(" ");
	Statement doSearch = m_con.createStatement();
	String sql = "Select photo_id";
	//if there is no keyword, use dates
	if (kWord.isEmpty()){
		sql += " from images where";
		//if range of times given
		if (!fromTime.isEmpty() && !toTime.isEmpty()) {
			sql += " (timing between to_date('" + fromTime
					+ "', 'DD/MM/YYYY') " + "AND to_date('" + toTime + "','DD/MM/YYYY')) ";
		}
		//else only begining of time
			else if(!fromTime.isEmpty()){
				sql += " (timing >= to_date('" + fromTime
						+ "','DD/MM/YYYY')) ";
			}
			//else only end of time
			else if(!toTime.isEmpty()){
				sql += " (timing <= to_date('" + toTime
						+ "','DD/MM/YYYY')) ";
			}
	}
	//if there are keywords, take score of keywords
	if(!kWord.isEmpty()){
		sql+=", ";
		int mod = 0;
		for (int i = 1; i <= keywords.length; ++i)
		{
			sql += "6*score(" + Integer.toString(mod+1) + ") +" 
			+ "3*score(" + Integer.toString(mod+2) + ") +"
			+ "score(" + Integer.toString(mod+3) + ") ";
			if (i != keywords.length){
			sql += "+";
			mod +=3;
			}
		}
		sql += "as rank from images where (";

		mod = 0;
		for (int j = 0; j < keywords.length; ++j) {
		sql += "contains(SUBJECT, '" + keywords[j] +"', "+ Integer.toString(mod + 1) + ") >0 OR " 
		+ "contains(PLACE, '" + keywords[j] +"', "+ Integer.toString(mod + 2) + ") >0 OR "
		+ "contains(DESCRIPTION, '" + keywords[j] +"', "+ Integer.toString(mod + 3) + ") >0 ";
		if (j != keywords.length-1) {
			sql += "OR ";
			mod += 3;
			}
		}
		sql+=")";
			//if range of times given
	if (!fromTime.isEmpty() && !toTime.isEmpty()) {
		sql += "AND (timing between to_date('" + fromTime
				+ "', 'DD/MM/YYYY') " + "AND to_date('" + toTime + "','DD/MM/YYYY')) ";
	}
	//else only begining of time
		else if(!fromTime.isEmpty()){
			sql += "AND (timing >= to_date('" + fromTime
					+ "','DD/MM/YYYY')) ";
		}
		//else only end of time
		else if(!toTime.isEmpty()){
			sql += "AND (timing <= to_date('" + toTime
					+ "','DD/MM/YYYY')) ";
		}
	}
	if (sortType.equals("none")){
		sql+="ORDER BY RANK desc";
		//out.println("one");
		
	}
	else if (sortType.equals("desc")){
		sql+="ORDER BY timing desc";
		//out.println("two");
	}
	else if	(sortType.equals("ascen")){
		sql+="ORDER BY timing asc";
		//out.println("three");
	}
	//print results
	//out.println(sortType);
	out.println(sql);
	try{
	ResultSet rset2 = doSearch.executeQuery(sql);
	String p_id = "";
	while (rset2.next()){
		p_id = (rset2.getObject(1)).toString();
		// specify the servlet for the image
		out.println("<a href=\"/proj1/GetBigPic?"+p_id+"\">");
		// specify the servlet for the themernail
		out.println("<img src=\"/proj1/GetOnePic?thumb"+p_id +"\"></a>");
	  }
	  } catch (Exception e) {
				out.println(e.getMessage());
	}
	out.println(sql);
	out.println("</BODY></HTML>");		  
			  
	%>
  </body>
</html>
	
