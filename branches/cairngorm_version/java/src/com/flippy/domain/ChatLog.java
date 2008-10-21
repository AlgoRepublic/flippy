package com.flippy.domain;

import java.util.Date;

public class ChatLog {
	private int id;
	private String sessionId;
	private String senderUserName;
	private String destinationUserName;
	private String message;
	private Date timestamp;
	private Date clientTimestamp;
	
	public ChatLog() {
		super();
	}
	
	public ChatLog(int id, String destinationUserName, String message,
			String senderUserName, String sessionId, Date timestamp,
			Date clientTimestamp) {
		super();
		this.id = id;
		this.destinationUserName = destinationUserName;
		this.message = message;
		this.senderUserName = senderUserName;
		this.sessionId = sessionId;
		this.timestamp = timestamp;
		this.clientTimestamp = clientTimestamp;
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
	 * @return the destinationUserName
	 */
	public String getDestinationUserName() {
		return destinationUserName;
	}
	/**
	 * @param destinationUserName the destinationUserName to set
	 */
	public void setDestinationUserName(String destinationUserName) {
		this.destinationUserName = destinationUserName;
	}
	/**
	 * @return the message
	 */
	public String getMessage() {
		return message;
	}
	/**
	 * @param message the message to set
	 */
	public void setMessage(String message) {
		this.message = message;
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
	
	public Date getClientTimestamp() {
		return clientTimestamp;
	}

	public void setClientTimestamp(Date aClientTimestamp) {
		clientTimestamp = aClientTimestamp;
	}


	
	@Override
	public String toString() {
		return "{id=" + id + ";session_id=" + sessionId + ";sender="+senderUserName+";dest="+ destinationUserName+";message="+message+";timestamp="+timestamp+";ctimestamp="+clientTimestamp+"}";
	}
	
	
}
