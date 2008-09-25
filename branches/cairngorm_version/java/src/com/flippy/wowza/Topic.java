package com.flippy.wowza;

import java.util.Hashtable;
import java.util.Map;

import com.flippy.wowza.BaseRequest;

public class Topic {
	private String name;
	private Map<String, BaseRequest> subscribers = new Hashtable<String, BaseRequest>();
	private	boolean disabled;
	


	public Topic(String name) {
		this.name = name;
	}
	
	public BaseRequest getSubscriber(String clientId) {
		return (BaseRequest) subscribers.get(clientId);
	}
	
	public BaseRequest addSubscriber(String clientId, BaseRequest client) {
		return subscribers.put(clientId, client);
	}
	
	public BaseRequest removeSubscriber(String clientId) {
		return subscribers.remove(clientId);
	}
	
	// standard getter setter
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Map<String, BaseRequest> getSubscribers() {
		return subscribers;
	}

	public void setSubscribers(Map<String, BaseRequest> subscribers) {
		this.subscribers = subscribers;
	}

	public boolean isDisabled() {
		return disabled;
	}

	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}
}
