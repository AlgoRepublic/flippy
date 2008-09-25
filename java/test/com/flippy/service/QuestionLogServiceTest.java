package com.flippy.service;

import java.util.Date;
import java.util.List;

import junit.framework.TestCase;

import com.flippy.domain.QuestionLog;
import com.flippy.service.QuestionLogService;

public class QuestionLogServiceTest extends TestCase {

	public void testGetLogBySenderAndSessionId() {
		testWriteLog();
		List<QuestionLog> ret = QuestionLogService.getLogBySenderAndSessionId("reni","sess-1");

		System.out.println("done select: ");
		
		assertNotNull(ret);
		
		assertTrue(ret.size() > 0);
		
		for (QuestionLog qLog : ret) {
			System.out.println(qLog);
		}
	}

	public void testWriteLog() {
		System.out.println("inserting..");
		assertTrue(QuestionLogService.writeLog("sess-1", "apa yah?", "reni", new Date()) > 0);
		System.out.println("done..");
		
	}

}
