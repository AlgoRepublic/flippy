package com.flippy.wowza;

import java.util.Hashtable;
import java.util.Map;

import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleCallResult;
import com.wowza.wms.module.ModuleBase;
import com.wowza.wms.request.RequestFunction;

public class Chat extends ModuleBase implements IModuleCallResult {

	/*
	 * sessionsMap<SessionId, TopicsMap>
	 *     +-- TopicsMap<TopicId, clientId>
	 * ClientsMap<ClientId, ChatClient> 
	 */
	private Map<String, IClient> mClientsMap = new Hashtable<String, IClient>();
	private Map<String, Map<String, String>> mClientsTopics = new Hashtable<String, Map<String,String>>();
	private Map<String, IClient> mClientsUsers = new Hashtable<String, IClient>();
	
	
	private Map<String, Map<String,ChatClient>> mTopicsMap = new Hashtable<String, Map<String,ChatClient>>();
	
	
	// ----------------- CHAT RPC  ------------------------
	public void publish(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("publish");
		
		ChatClient cc = composeChatClient(client, function, params);
		
		doPublish(cc);
	}

	public void subscribe(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("subscribe");
		
		ChatClient cc = composeChatClient(client, function, params);
		
		addChatClient(cc);
	}
	
	public void unSubscribe(IClient client, RequestFunction function, AMFDataList params) {
		getLogger().info("unSubscribe");
		
		ChatClient cc = composeChatClient(client, function, params);

		removeChatClient(cc);
	}

	public void sendChatRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("sendChatRequest");
		
		ChatClient cc = composeChatClient(client, function, params);
		
		
		IClient destClient = mClientsUsers.get(cc.getSendTo());
		if (destClient != null) {
			
			// check should be from the same session
			getLogger().info("About to call: onChatRequest");
			
			// subscribe sender to this topic
			getLogger().info("About to subscribe " + cc.getFrom() + " to topic: " + cc.getTopic());
			addChatClient(cc);
			
			ChatClient dc = new ChatClient();
			dc.setClient(destClient);
			dc.setFrom(cc.getSendTo());
			dc.setId(String.valueOf(destClient.getClientId()));
			dc.setSendTo(cc.getFrom());
			dc.setSessionId(cc.getSessionId());
			dc.setTopic(cc.getTopic());

			// subscribe dest to this topic
			getLogger().info("About to subscribe " + dc.getFrom() + " to topic: " + dc.getTopic());
			addChatClient(dc);
			
			publish(client, function, params);
//			destClient.call("onChatRequest", this, cc.getFrom(), cc.getTopic(), cc.getMessage());
			
			sendResult(client, params, "success sending chat request to: " + cc.getMessage() + " from: " + cc.getFrom());
		} else {
			
			getLogger().info("Failed calling onChatRequest: no client with name" + cc.getSendTo() + " was found");
			sendResult(client, params, "err:No Client with name: " + cc.getSendTo());
		}
	}
	
	// ---------------- HELPER ------------------------------
	public static ChatClient composeChatClient(IClient client, RequestFunction function,
			AMFDataList params) {
		ChatClient cc = new ChatClient();
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		cc.setTopic(getParamString(params, PARAM2));
		cc.setFrom(getParamString(params, PARAM3));
		cc.setMessage(getParamString(params, PARAM4));
		cc.setSendTo(getParamString(params, PARAM5));
		
		return cc;
	}
	
	private void doPublish(ChatClient cc) {
		String topic = cc.getTopic();
		
		Map<String, ChatClient> subscribers = mTopicsMap.get(topic);
		
		if (subscribers != null) {
			// publishing
			getLogger().info("publishing message to topic '" + topic + "'");
			for (String clientId : subscribers.keySet()) {
				//sendResult(client, params, cc.getFrom() + ": " + cc.getMessage());
				IClient subs = mClientsMap.get(clientId);
				if (subs != null) {
					subs.call("onMessage", this, cc.getFrom(), cc.getSendTo(), cc.getTopic(), cc.getMessage() );
				}
			}
		} else {
			getLogger().info("no subscribers found in topic: " + topic);
		}
	}
	
	public void addChatClient(ChatClient cc) {
			String clientId = cc.getId();
		
			// add client
			if (mClientsMap.get(clientId) == null) {
				mClientsMap.put(clientId, cc.getClient());
			}
		
			// find topic
			Map<String, ChatClient> topicClients = mTopicsMap.get(cc.getTopic());
			
			if (topicClients != null) {
				// clients Map found! add this client
				
				if (topicClients.get(clientId) == null) {
					getLogger().info("Add new client: " + cc + " to Topics list: " + cc.getTopic());
					topicClients.put(clientId, cc);
				} else {
					getLogger().info("Client already subsriber to topic: " + cc.getTopic());
				}
			} else {
				// topic Not Found! create one
				getLogger().info("Create NEW clients Map for topic " + cc.getTopic() + " and Add new client: " + cc.getFrom());
				topicClients = new Hashtable<String, ChatClient>();
				topicClients.put(clientId, cc);
				
				mTopicsMap.put(cc.getTopic(), topicClients);
			}
			
			// add chattopic 
			Map<String, String> topicList = mClientsTopics.get(clientId);
			if (topicList == null) {
				topicList  = new Hashtable<String, String>();
				topicList.put(cc.getTopic(), clientId);
				
				getLogger().info("About to add NEW topic list: " + cc.getTopic() + "  to client: " + cc.getFrom());
				mClientsTopics.put(clientId, topicList);
			} else {
				
				if (topicList.get(cc.getTopic()) == null) {
					getLogger().info("About to add topic "+ cc.getTopic() +" to " + cc.getFrom());
					topicList.put(cc.getTopic(), clientId);
				} else {
					getLogger().info("Topic: " + cc.getTopic() +" already subscribed by " + cc.getFrom());
				}
			}
			
			// add client user mapping
			
			if (mClientsUsers.get(cc.getFrom()) == null) {
				getLogger().info("About to add user: " + cc.getFrom() + " to clientuser list");
				mClientsUsers.put(cc.getFrom(), cc.getClient());
			}
	}
	
	public void removeChatClient(ChatClient cc) {
		
		// find topic
		Map<String, ChatClient> topicSubscribers = mTopicsMap.get(cc.getTopic());
		
		if (topicSubscribers != null) {
			// clients Map found! add this client
			getLogger().info("Removing client: " + cc + " from Topic: " + cc.getTopic());
			topicSubscribers.remove(cc.getId());
		} else {
			// topic Not Found!
			getLogger().info("Topic '" + cc.getTopic() + "' was not found");
		}
		
		// check empty maps
		if (topicSubscribers.size() == 0) {
			// remove it from topicList
			mTopicsMap.remove(cc.getTopic());
		}
	}
	
	public void unsubscribeFromAll(IClient client) {
		// remove this client from all collections
		String cid = String.valueOf(client.getClientId());
		
		Map<String, String> subscribedTopics = mClientsTopics.get(client);
		
		if (subscribedTopics != null) {
			for (String topics : subscribedTopics.keySet()) {
				Map<String, ChatClient> allTopicSubs = mTopicsMap.get(topics);
				allTopicSubs.remove(cid);
			}
		} else {
			getLogger().debug("Clients subscribe to nothing");
		}
		
		mClientsTopics.remove(cid);
		
		mClientsMap.remove(cid);
	}
	
	// ---------------- LIFE CYCLE --------------------------
	public void onAppStart(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStart: " + fullname);
	}

	public void onAppStop(IApplicationInstance appInstance) {
		String fullname = appInstance.getApplication().getName() + "/"
				+ appInstance.getName();
		getLogger().info("onAppStop: " + fullname);
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("onConnect: " + client.getClientId());
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		unsubscribeFromAll(client);
	}

	@Override
	public void onResult(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("got result from client: " + getParamString(params, PARAM1));
	}

}