package test;

import java.sql.*;
import java.util.Scanner;

public class OracleJDBC_Delete {
	public static void main(String[] args) {
		String url = "jdbc:oracle:thin:@localhost:1521:oraknu";
		String user = "test";
		String pass = "test";
		Connection conn = null;
		String sql = null;
		String query = null;
		int result;
		Scanner kbd = new Scanner(System.in);
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("드라이버 검색 성공!");
		} catch (ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}
		try {
			conn = DriverManager.getConnection(url, user, pass);
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}
		
		Statement stmt;
		
		try {
			stmt = conn.createStatement();
			conn.setAutoCommit(false);
			System.out.print("query : ");
			sql = kbd.nextLine();
			System.out.println("입력 메시지: \""+ sql + "\"");
			ResultSet rs = stmt.executeQuery(sql);
			result = stmt.executeUpdate(sql);
			conn.commit();
			conn.setAutoCommit(true);
			stmt.close();
			conn.close();
		} catch (Exception e) {
			System.err.println("sql error = " + e.getMessage());
		}
	}
}
