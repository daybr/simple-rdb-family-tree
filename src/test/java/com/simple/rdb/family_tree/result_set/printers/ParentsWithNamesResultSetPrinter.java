package com.simple.rdb.family_tree.result_set.printers;

import java.io.IOException;
import java.io.OutputStream;
import java.io.Writer;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ParentsWithNamesResultSetPrinter extends ResultSetPrinter {

	public ParentsWithNamesResultSetPrinter(OutputStream output) {
		super(output);
	}

	public ParentsWithNamesResultSetPrinter(Writer writer) {
		super(writer);
	}

	@Override
	public void print(ResultSet rs) throws IOException, SQLException {
		while (rs.next()) {
			writer.write("  PID = ");
			writer.write(getValueOrTextNull(rs, rs.getBytes("PID")));
			writer.write(", FHID = ");
			writer.write(getValueOrTextNull(rs, rs.getBytes("FHID")));
			writer.write(", FHNAME = ");
			writer.write(getValueOrTextNull(rs, rs.getString("FHNAME")));
			writer.write(", MHID = ");
			writer.write(getValueOrTextNull(rs, rs.getBytes("MHID")));
			writer.write(", MHNAME = ");
			writer.write(getValueOrTextNull(rs, rs.getString("MHNAME")));
			writer.write(", CHILDCOUNT = ");
			writer.write(getValueOrTextNull(rs, rs.getInt("CHILDCOUNT")));
			writer.write("\n");
		}
	}

}
