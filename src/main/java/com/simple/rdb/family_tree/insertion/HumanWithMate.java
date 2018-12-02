package com.simple.rdb.family_tree.insertion;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.apache.commons.codec.binary.Hex;

public class HumanWithMate {

	private final String hid;
	private final String name;
	private final char sex;
	private final Date birth;
	private final Date death;
	private final String pid;
	private final Integer sibOrd;
	private final String matePPid;
	private final String mateHid;
	private final String mateName;
	private final char mateSex;
	private final Date mateBirth;
	private final Date mateDeath;
	private final String matePid;
	
	public HumanWithMate(ResultSet rs) throws SQLException {
		byte[] rawBytes = null;
		// HID
		rawBytes = rs.getBytes("HID");
		if (rawBytes != null) {
			hid = Hex.encodeHexString(rawBytes, false);
		} else {
			hid = null;
		}
		// NAME
		name = rs.getString("NAME");
		// SEX
		String rawSex = rs.getString("SEX");
		sex = rawSex.charAt(0);
		// BIRTH
		birth = rs.getDate("BIRTH");
		// DEATH
		death = rs.getDate("DEATH");
		// PID
		rawBytes = rs.getBytes("PID");
		if (rawBytes != null) {
			pid = Hex.encodeHexString(rawBytes, false);
		} else {
			pid = null;
		}
		// SIBORD
		int rawSibOrd = rs.getInt("SIBORD");
		if (!rs.wasNull()) {
			sibOrd = Integer.valueOf(rawSibOrd);
		} else {
			sibOrd = null;
		}
		// MATE_P_PID
		rawBytes = rs.getBytes("MATE_P_PID");
		if (rawBytes != null) {
			matePPid = Hex.encodeHexString(rawBytes, false);
		} else {
			matePPid = null;
		}
		// MATE_HID
		rawBytes = rs.getBytes("MATE_HID");
		if (rawBytes != null) {
			mateHid = Hex.encodeHexString(rawBytes, false);
		} else {
			mateHid = null;
		}
		// MATE_NAME
		mateName = rs.getString("MATE_NAME");
		// MATE_SEX
		String rawMateSex = rs.getString("MATE_SEX");
		if (rawMateSex != null) {
			mateSex = rawMateSex.charAt(0);
		} else {
			mateSex = ' ';
		}
		// MATE_BIRTH
		mateBirth = rs.getDate("MATE_BIRTH");
		// MATE_DEATH
		mateDeath = rs.getDate("MATE_DEATH");
		// MATE_PID
		rawBytes = rs.getBytes("MATE_PID");
		if (rawBytes != null) {
			matePid = Hex.encodeHexString(rawBytes, false);
		} else {
			matePid = null;
		}
	}
	
	public String getHid() {
		return hid;
	}

	public String getName() {
		return name;
	}

	public char getSex() {
		return sex;
	}

	public Date getBirth() {
		return birth;
	}

	public Date getDeath() {
		return death;
	}

	public String getPid() {
		return pid;
	}

	public Integer getSibOrd() {
		return sibOrd;
	}

	public String getMatePPid() {
		return matePPid;
	}

	public String getMateHid() {
		return mateHid;
	}

	public String getMateName() {
		return mateName;
	}

	public char getMateSex() {
		return mateSex;
	}

	public Date getMateBirth() {
		return mateBirth;
	}

	public Date getMateDeath() {
		return mateDeath;
	}

	public String getMatePid() {
		return matePid;
	}

}
