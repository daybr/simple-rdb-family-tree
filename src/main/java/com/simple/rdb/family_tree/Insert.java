package com.simple.rdb.family_tree;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;
import java.util.UUID;
public class Insert {
	
	static String url;
	static String user;
	static String pass;
	
	public Insert(String url, String user, String pass) {
		this.url = url;
		this.user = user;
		this.pass = pass;
	}
	
	public static void mian(String[] args) {	
		Connection conn = null;
		StringBuffer sql = new StringBuffer();
		int result; 
		String table_name;
		String parents_name;
		String Father;
		String Mother;
		String death;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("드라이버 검색 성공!");
		}catch(ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		} 

		try{
			conn = DriverManager.getConnection(url,user,pass);
		}catch(SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		} 
		try {
			conn.setAutoCommit(false);
			Statement stmt = conn.createStatement();
			
			Scanner scan = new Scanner(System.in);
			
			System.out.print("입력할 테이블 이름: ");
			table_name = scan.nextLine();
			if(table_name.equals("HUMAN")) {
				sql.append("insert into HUMAN values('");
				sql.append(UUID.randomUUID().toString().replace("-", ""));
				sql.append("', '");
				System.out.print("Name: ");
				sql.append(scan.nextLine());
				sql.append("', '");
				System.out.print("Sex(M/F): ");
				sql.append(scan.nextLine());
				sql.append("', '");
				System.out.print("Birth(yy/mm/dd): ");
				sql.append(scan.nextLine());
				sql.append("', ");
				System.out.print("Death(yy/mm/dd): ");
				death = scan.nextLine();
				if(!death.equals("NULL")) {
					sql.append("'");
					sql.append(death);
					sql.append("'");
				}else
					sql.append(death);
				sql.append(", ");
				System.out.print("Father name: ");
				parents_name = scan.nextLine();
				if(parents_name.equals("")) { //아빠가 없는 경우
					System.out.print("Mother name: ");
					parents_name = scan.nextLine();
					sql.append("(SELECT P.PID FROM PARENTS P, HUMAN MH WHERE P.MHID = MH.HID AND MH.NAME = '");
					sql.append(parents_name);
					sql.append("')");
				}else {//아빠 있는 경우
					sql.append("(SELECT P.PID FROM PARENTS P, HUMAN FH WHERE P.FHID = FH.HID AND FH.NAME = '");
					sql.append(parents_name);
					sql.append("')");
				}
				sql.append(", NULL)"); //자식 수  null
				System.out.println(sql.toString());
			}
			else if(table_name.equals("PARENTS")) {
				sql.append("insert into PARENTS values('");
				sql.append(UUID.randomUUID().toString().replace("-", ""));
				sql.append("', ");
				System.out.print("Father Name: ");
				Father = scan.nextLine();
				sql.append(" (SELECT HID FROM HUMAN WHERE NAME = '");
				sql.append(Father);
				sql.append("'), ");
				System.out.print("Mother Name: ");
				Mother = scan.nextLine();
				sql.append(" (SELECT HID FROM HUMAN WHERE NAME = '");
				sql.append(Mother);
				sql.append("'), NULL)");
				System.out.println(sql.toString());
			}
			else {
				System.out.println("table name error!");
				System.exit(1);
			}

			result = stmt.executeUpdate(sql.toString());
			System.out.println(result + " row inserted");
			
			conn.commit();
			conn.setAutoCommit(true);
			stmt.close();
			conn.close();
		} catch(Exception e) {
			System.err.println("sql error = " + e.getMessage());
		}
	}
}