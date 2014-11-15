<HTML>
<HEAD>
<TITLE>REGISTER</TITLE>
</HEAD>
<H1><CENTER>Register</CENTER></H1>
<BODY>
<%@ page import="java.sql.*,Database.db" %>

<%!
 //A function that checks that the user filled in all the fields
 Boolean emptyField=false;
 private void emptyChecker(String string){
     if (string.equals("")){
        emptyField=true;
 }     
 }
%>

<%
    if (request.getParameter("aSubmit")!=null)
    {
       //Making sure the user did not leave any blank fields
       String userName=(request.getParameter("username")).trim();
       emptyChecker(userName);
       String password=(request.getParameter("password")).trim();
       emptyChecker(password);
       String fname=(request.getParameter("fname")).trim();
       emptyChecker(fname);
       String lname=(request.getParameter("lname")).trim();
       emptyChecker(lname);
       String address=(request.getParameter("address")).trim();
       emptyChecker(address);
       String email=(request.getParameter("email")).trim();
       emptyChecker(email);
       String phone=(request.getParameter("phone")).trim();
       emptyChecker(phone);
       if (emptyField==true){
          out.println("<b>Please fill in all fields</b><br>");
          emptyField=false;
       }
       else{

            //Connect to the database
            db newDB= new db();
            Connection conn=newDB.connect();
    
     
   
            //select the user table from the underlying db and validate the user name and password
            Statement stmt = null;
            ResultSet rset = null;
            String sql = "select user_name from users where user_name = '"+userName+"'";
     
           try{
               stmt = conn.createStatement();
               rset = stmt.executeQuery(sql);
           }
   
           catch(Exception ex){
               out.println("<hr>" + ex.getMessage() + "<hr>");
           } 
   
           String trueuser = "";
   
           while(rset != null && rset.next())
           trueuser = (rset.getString(1)).trim();
   
           //display the result to make sure that user name is already not in use by someone else
           if(userName.equals(trueuser)){
                out.println("<b>Username has been already taken</b><br>");
           }
           else{
               stmt.execute("INSERT INTO users VALUES('"+userName+"','"+password+"',sysdate)");
               stmt.execute("INSERT INTO persons VALUES('"+userName+"','"+fname+"','"+lname+"','"+address+"','"+email+"','"+phone+"')");

               response.sendRedirect("login.jsp");
      
           }

          try{
              conn.close();  
          }
          catch(Exception ex){
               out.println("<hr>" + ex.getMessage() + "<hr>");
          }
       }
    }

//Getting all the information from the user
%>
<form method=post action=register.jsp>
UserName: <input type=text name=username maxlength=24><br>
Password: <input type=password name=password maxlength=24><br>
First Name: <input type=text name=fname maxlength=24><br>
Last Name: <input type=text name=lname maxlength=24><br>
Address: <input type=text name=address maxlength=128><br>
Email: <input type=text name=email maxlength=128><br>
Phone Number: <input type=text name=phone maxlength=10><br>
<input type=submit name=aSubmit value=Submit>
</form>




</BODY>
</HTML>
