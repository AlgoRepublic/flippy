package com.flippy.service;

import java.util.Date;
import java.util.List;

import com.flippy.domain.QuestionLog;

public interface QuestionLogDAO {
	int writeLog(String sessionId, String senderUserName, String question, Date timestamp);

	List<QuestionLog> getBySenderAndSessionId(String senderUserName, String sessionId);

	List<QuestionLog> getBySessionId(String sessionId);

}
