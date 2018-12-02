package test;

import java.sql.*;
import java.util.Scanner;

public class OracleJDBC_Select{
	public static void main(String[] args) {
		String url = "jdbc:oracle:thin:@localhost:1521:oraknu";
		String user = "test";
		String pass = "test";
		Connection conn = null;
		String sql = null;
		String query = null;

		Scanner kbd = new Scanner(System.in);

		int result;
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("드라이버 검색 성공!");
		} catch (ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}

		try {
			conn = DriverManager.getConnection(url, user, pass);
			conn.setAutoCommit(false);
		} catch (SQLException e) {
			System.err.println("sql error = " + e.getMessage());
			System.exit(1);
		}

		Statement stmt;

		//selelct human
		while (true) {
			try {
				stmt = conn.createStatement();
				System.out.print("query : ");
				sql = kbd.nextLine();
				System.out.println("입력 메시지: \""+ sql + "\"");
				ResultSet rs = stmt.executeQuery(sql);
				
				if (sql == "q"){
					conn.commit();
					stmt.close();
					break;
				}
				else if (sql.contains("select *from human")) {
					conn.setAutoCommit(false);
					while(rs.next()) {
					String add =  rs.getString("hid")+ " " ;
					add += rs.getString("NAME") + " ";
					add += rs.getString("SEX") + " ";
					add += rs.getString("BIRTH") + " ";
					add += rs.getString("DEATH") + " ";
					add += rs.getString("PID") + " ";
					add += rs.getString("SIBORD") + " ";
					System.out.println(add);
					}
					rs.close();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				//selelct parent
				else if (sql.contains("select *from parents")) {
					conn.setAutoCommit(false);
					while(rs.next()) {
					String add =  rs.getString("pid") + " ";
					add += rs.getString("fhid") + " ";
					add += rs.getString("mhid") + " ";
					add += rs.getInt("chald_count") + " ";
					System.out.println(add);
					}
					rs.close();
					conn.commit();
					conn.setAutoCommit(true);
				}
				/*부계 찾기*/
				else if (sql.contains("LEVEL")&&sql.contains("HID")&&sql.contains("NAME")&&sql.contains("SEX")&&sql.contains("BIRTH")
						&&sql.contains("DEATH")&&sql.contains("PID")&&sql.contains("SIBORD")) {
					conn.setAutoCommit(false);
					while(rs.next()) {
						String add =rs.getString("LEVEL")+ " ";
						add += rs.getString("HID")+ " " ;
						add += rs.getString("NAME") + " ";
						add += rs.getString("SEX") + " ";
						add += rs.getString("BIRTH") + " ";
						add += rs.getString("DEATH") + " ";
						add += rs.getString("PID") + " ";
						add += rs.getString("SIBORD") + " ";
						System.out.println(add);
						}
					rs.close();
					conn.commit();
					conn.setAutoCommit(true);
				}
				/*배우자 찾기*/
				else if (sql.contains("HID")&&sql.contains("NAME")&&sql.contains("SEX")&&sql.contains("BIRTH")
						&&sql.contains("MATE_P_PID")&&sql.contains("MATE_HID")&&sql.contains("MATE_NAME")&&sql.contains("MATE_SEX"))
				{
					conn.setAutoCommit(false);
					while(rs.next()) {
						String add = rs.getString("HID")+ " " ;
						add += rs.getString("NAME") + " ";
						add += rs.getString("SEX") + " ";
						add += rs.getString("BIRTH") + " ";
						add += rs.getString("MATE_P_PID") + " ";
						add += rs.getString("MATE_HID") + " ";
						add += rs.getString("MATE_NAME") + " ";
						add += rs.getString("MATE_SEX") + " ";
						System.out.println(add);
						}
					rs.close();
					conn.commit();
					conn.setAutoCommit(true);
				}
				/*자식찾기*/
				else if (sql.contains("HID")&&sql.contains("NAME")&&
						sql.contains("PID")&&sql.contains("FHID")) {
					conn.setAutoCommit(false);
					while(rs.next()) {
						String add =  rs.getString("HID")+ " " ;
						add += rs.getString("NAME") + " ";
						add += rs.getString("PID") + " ";
						add += rs.getString("FHID") + " ";
						System.out.println(add);
						}
					rs.close();
					conn.commit();
					conn.setAutoCommit(true);
				}
				else {
					result = stmt.executeUpdate(sql);
					System.out.println(result + " 행이 업데이트 되었습니다.");
				}
				conn.commit();
				stmt.close();

			} catch (Exception e) {
				System.err.println("sql error = " + e.getMessage());
				System.exit(1);
			}
		}

	}
}
