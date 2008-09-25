package com.flippy.wowza.chat;

import com.flippy.wowza.chat.SubscribeRequest;
import com.wowza.wms.client.IClient;

public class PublishRequest extends SubscribeRequest {
	String destUserName;
	String message;
	
	public PublishRequest() {
		super();
	}
	
	public PublishRequest(String sessionId, IClient client, String topic,
			String userName, String destUserName, String message) {
		super(sessionId, client, topic, userName);
		
		this.destUserName = destUserName;
		this.message = message;
	}

	public String getDestUserName() {
		return destUserName;
	}

	public void setDestUserName(String destUserName) {
		this.destUserName = destUserName;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	
}
