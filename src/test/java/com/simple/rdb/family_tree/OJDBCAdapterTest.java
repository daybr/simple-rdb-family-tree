package com.simple.rdb.family_tree;

import static org.junit.Assert.*;

import org.junit.Test;

public class OJDBCAdapterTest {

	@Test
	public void verityDriverTest() {
		assertTrue(OJDBCAdapter.getInstance().verifyDriver());
	}

}
