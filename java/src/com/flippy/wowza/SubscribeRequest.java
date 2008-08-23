package com.flippy.wowza;

import com.wowza.wms.client.IClient;

public class SubscribeRequest extends BaseRequest {
	String topic;
	String userName;
	
	public SubscribeRequest() {
		super();
	}
	
	public SubscribeRequest(String sessionId, IClient client, String topic, String userName) {
		super(sessionId, client);
		
		this.topic = topic;
		this.userName = userName;
	}
	
	public String getTopic() {
		return topic;
	}
	public void setTopic(String topic) {
		this.topic = topic;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
