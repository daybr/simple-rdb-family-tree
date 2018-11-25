package com.simple.rdb.family_tree.result_set.printers;

import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import java.sql.ResultSet;
import java.sql.SQLException;

public class HumanResultSetPrinter extends ResultSetPrinter {

	public HumanResultSetPrinter(OutputStream output) {
		super(output);
	}

	public HumanResultSetPrinter(Writer writer) {
		super(writer);
	}

	@Override
	public void print(ResultSet rs) throws IOException, SQLException {
		while (rs.next()) {
			writer.write("  HID = ");
			writer.write(getValueOrTextNull(rs, rs.getBytes("HID")));
			writer.write(", NAME = ");
			writer.write(getValueOrTextNull(rs, rs.getString("NAME")));
			writer.write(", SEX = ");
			writer.write(getValueOrTextNull(rs, rs.getString("SEX")));
			writer.write(", BIRTH = ");
			writer.write(getValueOrTextNull(rs, rs.getDate("BIRTH")));
			writer.write(", DEATH = ");
			writer.write(getValueOrTextNull(rs, rs.getDate("DEATH")));
			writer.write(", PID = ");
			writer.write(getValueOrTextNull(rs, rs.getBytes("PID")));
			writer.write(", SIBORD = ");
			writer.write(getValueOrTextNull(rs, rs.getInt("SIBORD")));
			writer.write("\n");
		}
	}

}
