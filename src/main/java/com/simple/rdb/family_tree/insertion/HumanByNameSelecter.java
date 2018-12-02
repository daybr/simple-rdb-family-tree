package com.simple.rdb.family_tree.insertion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.fasterxml.jackson.module.paramnames.ParameterNamesModule;
import com.simple.rdb.family_tree.OJDBCAdapter;

public class HumanByNameSelecter {

	private transient final Logger logger = LoggerFactory.getLogger(HumanByNameSelecter.class);
	
	public List<HumanWithMate> query(boolean usingDBProperties, String nameQuery) throws SQLException {
		logger.debug("Starting to find human by name...: {}", nameQuery);
		List<HumanWithMate> list = new ArrayList<>();
		if ("".equals(nameQuery)) {
			return list;
		}
		try (Connection conn = OJDBCAdapter.getInstance().getConnection(usingDBProperties)) {
			try (PreparedStatement pstmt
					= conn.prepareStatement("SELECT * FROM HUMAN_WITH_MATE WHERE NAME LIKE CONCAT(?, '%')")) {
				pstmt.setString(1, nameQuery);
				ResultSet rs = pstmt.executeQuery();
				while (rs.next()) {
					HumanWithMate hwm = new HumanWithMate(rs);
					list.add(hwm);
				}
			}
		} catch (SQLException e) {
			logger.error("Cannot get human by name: {}", nameQuery, e);
			throw e;
		}
		return list;
	}
	
	public String queryAsJson(boolean usingDBProperties, String nameQuery) {
		String result = null;
		try {
			ObjectMapper mapper = new ObjectMapper()
					.registerModule(new Jdk8Module())
					.registerModule(new ParameterNamesModule(JsonCreator.Mode.PROPERTIES))
					.registerModule(new JavaTimeModule())
					.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false)
					.enable(SerializationFeature.INDENT_OUTPUT);
			List<HumanWithMate> list = query(usingDBProperties, nameQuery);
			result = mapper.writeValueAsString(list);
		} catch (SQLException e) {
		} catch (JsonProcessingException e) {
			logger.error("Cannot convert human by name to JSON: {}", nameQuery, e);
		}
		logger.debug("Got human by name: {}", result);
		return result;
	}

	/*
	public static void main(String args[]) {
		try {
			List<HumanWithMate> list = new HumanByNameSelecter().query(true, "작");
			for (HumanWithMate hwm : list) {
				System.out.println(hwm.getName());
			}
			System.out.println(new HumanByNameSelecter().queryAsJson(true, "작"));
		} catch (SQLException e) {
			System.err.println("오류!");
		}
	}
	*/
	
}
