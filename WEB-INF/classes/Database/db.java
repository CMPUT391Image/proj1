package Database;

import java.sql.*;

public class db{
    Connection conn = null;
    
    private String driverName = "oracle.jdbc.driver.OracleDriver";
    //private String dbstring="jdbc:oracle:thin@localhost:1525:crs";
    private String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    public Connection connect(){
	try{
	    //load and register the driver
	    Class drvClass = Class.forName(driverName);
	    DriverManager.registerDriver((Driver) drvClass.newInstance());
	}
	catch(Exception ex){
	    System.out.println("<hr>" + ex.getMessage() + "<hr>");

	}

	try{
	    //establish the connection
	    conn = DriverManager.getConnection(dbstring,"elbohtim","foster423");//CHANGE THIS TO YOUR OWN USERNAME AND PASSWORD
	    conn.setAutoCommit(false);
	}
	catch(Exception ex){

	    System.out.println("<hr>" + ex.getMessage() + "<hr>");
	}
	return conn;
    }
  
} 