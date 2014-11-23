<html>
<head>
<title>Data Analysis</title>
</head>
<div style="float: right">
   <form name="logout" method="post" action="logout.jsp">
   <input type="submit" name="logout" value="logout">
   </form>
</div>
<body>
<H1>Data Analysis</H1>
<form name="olapresult" method="post" action="OlapResult.jsp">
Analyze Options: 
<input type="checkbox" name="imageowner" value="1"></input> User
<input type="checkbox" name="subject" value="1"></input> Subject
<input type="checkbox" name="time" value="1"></input> Time Period<br>
 Order Time Period by:
 <select name="interval">
    <option value="week">Week</option>
    <option value="month">Month</option>
    <option value="year">Year</option>
</select><br>
<input type="submit" name="analyze" value="Analyze">
</form>

</BODY>
</HTML>
