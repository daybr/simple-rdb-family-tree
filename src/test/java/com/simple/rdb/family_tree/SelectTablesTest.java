package com.simple.rdb.family_tree;

import java.io.BufferedWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.junit.Test;

import com.simple.rdb.family_tree.result_set.printers.HumanResultSetPrinter;
import com.simple.rdb.family_tree.result_set.printers.ParentsResultSetPrinter;
import com.simple.rdb.family_tree.result_set.printers.ResultSetPrinter;

public class SelectTablesTest {

	@Test(expected = Test.None.class)
	public void selectHuman() throws Exception {
		try (Connection conn = OJDBCAdapter.getInstance().getConnection(false)) {
			try (PreparedStatement pstmtSelect
					= conn.prepareStatement("SELECT * FROM HUMAN")) {
				try (ResultSet rs = pstmtSelect.executeQuery()) {
					ResultSetPrinter rsPrinter = new HumanResultSetPrinter(System.out);
					BufferedWriter writer = rsPrinter.getWriter();
					writer.write("\nHUMAN\n");
					writer.write("========================================\n");
					rsPrinter.print(rs);
					writer.write("========================================\n\n");
					writer.flush();
				}
			}
		}
	}

	@Test(expected = Test.None.class)
	public void selectParents() throws Exception {
		try (Connection conn = OJDBCAdapter.getInstance().getConnection(false)) {
			try (PreparedStatement pstmtSelect
					= conn.prepareStatement("SELECT * FROM PARENTS")) {
				try (ResultSet rs = pstmtSelect.executeQuery()) {
					ResultSetPrinter rsPrinter = new ParentsResultSetPrinter(System.out);
					BufferedWriter writer = rsPrinter.getWriter();
					writer.write("\nPARENTS\n");
					writer.write("========================================\n");
					rsPrinter.print(rs);
					writer.write("========================================\n\n");
					writer.flush();
				}
			}
		}
	}

}
