package com.flippy.wowza.question;

import com.flippy.wowza.FlippyBaseRequest;
import com.wowza.wms.client.IClient;

public class SubmitQuestionRequest extends FlippyBaseRequest {
	String userName;
	String question;
	
	public SubmitQuestionRequest() {
		super();
	}
	
	public SubmitQuestionRequest(String sessionId, IClient client, String userName, String question) {
		super(sessionId, client);
		
		this.userName = userName;
		this.question = question;
	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return the question
	 */
	public String getQuestion() {
		return question;
	}

	/**
	 * @param question the question to set
	 */
	public void setQuestion(String question) {
		this.question = question;
	}
	
}
