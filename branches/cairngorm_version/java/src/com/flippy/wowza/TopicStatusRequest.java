package com.flippy.wowza;

import com.flippy.wowza.SubscribeRequest;
import com.wowza.wms.client.IClient;

public class TopicStatusRequest extends SubscribeRequest {
	private boolean disableTopic;
	private String message;
	
	public TopicStatusRequest() {
		super();
	}
	
	public TopicStatusRequest(String sessionId, IClient client, String topic,
			String userName, boolean topicStatus, String message) {
		super(sessionId, client, topic, userName);
		
		this.disableTopic = topicStatus;
		this.message = message;
	}

	public boolean isDisableTopic() {
		return disableTopic;
	}

	public void setDisableTopic(boolean disableTopic) {
		this.disableTopic = disableTopic;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	
}
