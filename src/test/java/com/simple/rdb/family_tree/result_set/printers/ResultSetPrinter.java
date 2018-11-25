package com.simple.rdb.family_tree.result_set.printers;

import java.io.BufferedWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.apache.commons.codec.binary.Hex;

public abstract class ResultSetPrinter {
	
	public static DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy/MM/dd");
	
	protected BufferedWriter writer;
	
	public ResultSetPrinter(OutputStream output) {
		this.writer = new BufferedWriter(new OutputStreamWriter(output));
	}

	public ResultSetPrinter(Writer writer) {
		this.writer = new BufferedWriter(writer);
	}

	protected String getValueOrTextNull(ResultSet rs, String value) throws SQLException {
		if (rs.wasNull()) {
			return "(NULL)";
		}
		return value;
	}

	protected String getValueOrTextNull(ResultSet rs, byte[] value) throws SQLException {
		if (value == null) {
			return "(NULL)";
		}
		return Hex.encodeHexString(value, false);
	}

	protected String getValueOrTextNull(ResultSet rs, int value) throws SQLException {
		return getValueOrTextNull(rs, String.valueOf(value));
	}

	protected String getValueOrTextNull(ResultSet rs, Date value) throws SQLException {
		if (value == null) {
			return "(NULL)";
		}
		return DATE_FORMAT.format(value);
	}
	
	public BufferedWriter getWriter() {
		return writer;
	}

	public abstract void print(ResultSet rs) throws IOException, SQLException;

}
