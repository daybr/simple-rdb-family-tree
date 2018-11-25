package com.simple.rdb.family_tree;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OJDBCAdapter {

	public static final String DB_PROP_FILE = "db.properties";
	private static final String DB_PROP_DEFAULT_URL = "jdbc:oracle:thin:@localhost:1521:oraknu";
	private static final String DB_PROP_DEFAULT_USERNAME = "kdhong";
	private static final String DB_PROP_DEFAULT_PASSWORD = "kdhong";

	private static class SingletonHolder {

		private static OJDBCAdapter INSTANCE = null;

	}

	public static OJDBCAdapter getInstance() {
		if (SingletonHolder.INSTANCE == null) {
			SingletonHolder.INSTANCE = new OJDBCAdapter();
		}
		return SingletonHolder.INSTANCE;
	}

	private transient final Logger logger = LoggerFactory.getLogger(OJDBCAdapter.class);

	private Properties prop = new Properties();

	public OJDBCAdapter() {
		readProperties();
	}

	public Connection getConnection(boolean usingPropertiesFile) throws SQLException {
		if (!usingPropertiesFile) {
			// Use default only
			return DriverManager.getConnection(
					DB_PROP_DEFAULT_URL, DB_PROP_DEFAULT_USERNAME, DB_PROP_DEFAULT_PASSWORD);
		}
		return DriverManager.getConnection(prop.getProperty("url", DB_PROP_DEFAULT_URL),
				prop.getProperty("username", DB_PROP_DEFAULT_USERNAME),
				prop.getProperty("password", DB_PROP_DEFAULT_PASSWORD));
	}

	public void readProperties() {
		ClassLoader classLoader = getClass().getClassLoader();
		try (InputStream input = classLoader.getResourceAsStream(DB_PROP_FILE)) {
			prop.load(input);
			logger.debug("Jusb read OJDBC properties file");
		} catch (IOException e) {
			logger.error("Error occurred while reading OJDBC properties file");
		} catch (NullPointerException e) {
			logger.warn("Cannot find OJDBC properties file");
		}
		logger.info("OJDBC properties. url: \"{}\", username: \"{}\", password: \"{}\"",
				prop.getProperty("url", DB_PROP_DEFAULT_URL),
				prop.getProperty("username", DB_PROP_DEFAULT_USERNAME),
				prop.getProperty("password", DB_PROP_DEFAULT_PASSWORD));
	}

	public boolean verifyDriver() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		} catch (ClassNotFoundException e) {
			return false;
		}
		return true;
	}

}
