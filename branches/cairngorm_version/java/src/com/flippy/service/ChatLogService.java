package com.flippy.service;

import java.util.Date;
import java.util.List;

import org.springframework.context.ApplicationContext;

import com.flippy.domain.ChatLog;

public class ChatLogService {

	public static List<ChatLog> getLogBySender(String senderUserName) {
		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((ChatLogDAOImpl) ctx.getBean("ChatLogService"))
				.getBySender(senderUserName);
	}

	public static int writeLog(String destinationUserName, String message,
			String senderUserName, String sessionId, Date timestamp,
			Date clientTimestamp) {

		ApplicationContext ctx = ServiceManager.getInstance().getContext();

		return ((ChatLogDAOImpl) ctx.getBean("ChatLogService")).writeLog(
				destinationUserName, message, senderUserName, sessionId,
				timestamp, clientTimestamp);
	}

	public static void main(String[] args) {
		List<ChatLog> l = ChatLogService.getLogBySender("hendra");
		
		if (l != null) {
			for (ChatLog chatLog : l) {
				System.out.println(chatLog);
			}
		} else {
			System.out.println("Empty result");
		}
	}

}
