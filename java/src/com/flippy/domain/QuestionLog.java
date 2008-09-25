package com.flippy.domain;

import java.util.Date;

public class QuestionLog {
	private int id;
	private String sessionId;
	private String senderUserName;
	private String question;
	private Date timestamp;
	
	public QuestionLog() {
		super();
	}
	
	public QuestionLog(int id, String destinationUserName, String message,
			String senderUserName, String sessionId, Date timestamp,
			String topic) {
		super();
		this.id = id;
		this.question = message;
		this.senderUserName = senderUserName;
		this.sessionId = sessionId;
		this.timestamp = timestamp;
	}

	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}

	
	/**
	 * @return the sessionId
	 */
	public String getSessionId() {
		return sessionId;
	}
	/**
	 * @param sessionId the sessionId to set
	 */
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	/**
	 * @return the senderUserName
	 */
	public String getSenderUserName() {
		return senderUserName;
	}
	/**
	 * @param senderUserName the senderUserName to set
	 */
	public void setSenderUserName(String senderUserName) {
		this.senderUserName = senderUserName;
	}
	/**
	 * @return the message
	 */
	public String getQuestion() {
		return question;
	}
	/**
	 * @param question the message to set
	 */
	public void setQuestion(String question) {
		this.question = question;
	}
	/**
	 * @return the timestamp
	 */
	public Date getTimestamp() {
		return timestamp;
	}
	/**
	 * @param timestamp the timestamp to set
	 */
	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}
	
	@Override
	public String toString() {
		return "{id=" + id + ";session_id=" + sessionId + ";sender="+senderUserName+";question="+question+";timestamp="+timestamp+"}";
	}
	
	
}
