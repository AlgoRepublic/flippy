package com.flippy.service;

import java.util.Date;
import java.util.List;

import org.springframework.context.ApplicationContext;

import com.flippy.domain.QuestionLog;

public class QuestionLogService {

	public static List<QuestionLog> getLogBySenderAndSessionId(
			String senderUserName, String sessionId) {
		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((QuestionLogDAOImpl) ctx.getBean("QuestionLogService"))
				.getBySenderAndSessionId(senderUserName, sessionId);
	}

	public static List<QuestionLog> getLogBySessionId(String sessionId) {
		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((QuestionLogDAOImpl) ctx.getBean("QuestionLogService"))
				.getBySessionId(sessionId);
	}

	public static int writeLog(String sessionId, String senderUserName,
			String question, Date timestamp) {

		ApplicationContext ctx = ServiceManager.getInstance().getContext();
		
		return ((QuestionLogDAOImpl) ctx.getBean("QuestionLogService"))
				.writeLog(sessionId, senderUserName, question, timestamp);
	}

	public static void main(String[] args) {
		List<QuestionLog> l = QuestionLogService.getLogBySenderAndSessionId(
				"hendra", "session1");

		if (l != null) {
			for (QuestionLog QuestionLog : l) {
				System.out.println(QuestionLog);
			}
		} else {
			System.out.println("Empty result");
		}
	}

}
