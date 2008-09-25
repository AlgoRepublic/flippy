package com.flippy.wowza.chat;

import java.util.Hashtable;
import java.util.Map;

import com.flippy.wowza.FlippyBaseRequest;

public class Topic {
	private String name;
	private Map<String, FlippyBaseRequest> subscribers = new Hashtable<String, FlippyBaseRequest>();
	private	boolean disabled;
	


	public Topic(String name) {
		this.name = name;
	}
	
	public FlippyBaseRequest getSubscriber(String clientId) {
		return (FlippyBaseRequest) subscribers.get(clientId);
	}
	
	public FlippyBaseRequest addSubscriber(String clientId, FlippyBaseRequest client) {
		return subscribers.put(clientId, client);
	}
	
	public FlippyBaseRequest removeSubscriber(String clientId) {
		return subscribers.remove(clientId);
	}
	
	// standard getter setter
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Map<String, FlippyBaseRequest> getSubscribers() {
		return subscribers;
	}

	public void setSubscribers(Map<String, FlippyBaseRequest> subscribers) {
		this.subscribers = subscribers;
	}

	public boolean isDisabled() {
		return disabled;
	}

	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}
}
