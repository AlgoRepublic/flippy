package com.flippy.service;

import java.util.Date;
import java.util.List;

import com.flippy.domain.ChatLog;

public interface ChatLogDAO {
	int writeLog(String destinationUserName, String message,
			String senderUserName, String sessionId, Date timestamp,
			String topic);
	
	List<ChatLog> getBySender(String senderUserName);
}
