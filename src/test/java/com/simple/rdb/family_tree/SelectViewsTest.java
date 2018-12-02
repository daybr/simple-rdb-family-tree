package com.simple.rdb.family_tree;

import java.io.BufferedWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.junit.Test;

import com.simple.rdb.family_tree.result_set.printers.HumanWithParentsResultSetPrinter;
import com.simple.rdb.family_tree.result_set.printers.ParentsWithNamesResultSetPrinter;
import com.simple.rdb.family_tree.result_set.printers.ResultSetPrinter;

public class SelectViewsTest {

	@Test(expected = Test.None.class)
	public void selectHumanWithParents() throws Exception {
		try (Connection conn = OJDBCAdapter.getInstance().getConnection(true)) {
			try (PreparedStatement pstmtSelect
					= conn.prepareStatement("SELECT * FROM HUMAN_WITH_PARENTS")) {
				try (ResultSet rs = pstmtSelect.executeQuery()) {
					ResultSetPrinter rsPrinter = new HumanWithParentsResultSetPrinter(System.out);
					BufferedWriter writer = rsPrinter.getWriter();
					writer.write("\nHUMAN_WITH_PARENTS\n");
					writer.write("========================================\n");
					rsPrinter.print(rs);
					writer.write("========================================\n\n");
					writer.flush();
				}
			}
		}
	}

	@Test(expected = Test.None.class)
	public void selectParentsWithNames() throws Exception {
		try (Connection conn = OJDBCAdapter.getInstance().getConnection(true)) {
			try (PreparedStatement pstmtSelect
					= conn.prepareStatement("SELECT * FROM PARENTS_WITH_NAMES")) {
				try (ResultSet rs = pstmtSelect.executeQuery()) {
					ResultSetPrinter rsPrinter = new ParentsWithNamesResultSetPrinter(System.out);
					BufferedWriter writer = rsPrinter.getWriter();
					writer.write("\nPARENTS_WITH_NAMES\n");
					writer.write("========================================\n");
					rsPrinter.print(rs);
					writer.write("========================================\n\n");
					writer.flush();
				}
			}
		}
	}

}

