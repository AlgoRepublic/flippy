package com.flippy.service;

import java.util.Date;
import java.util.List;

import com.flippy.domain.ChatLog;

import junit.framework.TestCase;

public class ChatLogServiceTest extends TestCase {

	public void testGetLogBySender() {
		testWriteLog();
		List<ChatLog> ret = ChatLogService.getLogBySender("hendra");

		System.out.println("done select: " + ret);
		
		assertNotNull(ret);
		
		for (ChatLog chatLog : ret) {
			System.out.println(chatLog);
		}
	}

	public void testWriteLog() {
		System.out.println("inserting..");
		assertTrue(ChatLogService.writeLog("hendra", "apa yah?", "reni", "sess-1", new Date(), "sess-1.public")>0);
		System.out.println("done..");
		
	}

}
