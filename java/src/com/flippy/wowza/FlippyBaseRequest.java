package com.flippy.wowza;

import com.wowza.wms.client.IClient;

public class FlippyBaseRequest {
	String sessionId;
	String id;
	IClient client;
	
	public FlippyBaseRequest() {
		super();
	}
	
	public FlippyBaseRequest(String sessionId, IClient client) {
		super();
		this.sessionId = sessionId;
		this.client = client;
		this.id = String.valueOf(client.getClientId());
	}
	
	public String getSessionId() {
		return sessionId;
	}
	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
	public IClient getClient() {
		return client;
	}
	public void setClient(IClient client) {
		this.client = client;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
}
