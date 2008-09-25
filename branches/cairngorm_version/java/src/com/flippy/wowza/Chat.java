package com.flippy.wowza;

import java.util.Date;
import java.util.Hashtable;
import java.util.Map;

import com.flippy.service.ChatLogService;
import com.flippy.service.ServiceManager;
import com.flippy.wowza.BaseRequest;
import com.flippy.wowza.FlippyModuleBase;
import com.flippy.wowza.PublishRequest;
import com.flippy.wowza.SubscribeRequest;
import com.flippy.wowza.Topic;
import com.flippy.wowza.TopicStatusRequest;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleCallResult;
import com.wowza.wms.request.RequestFunction;

public class Chat extends FlippyModuleBase implements IModuleCallResult {

	public static final int RESULT_OK = 200;
	public static final int RESULT_NOK = 500;
	
	public static String CALL_PUBLISH = "publish";
	public static String CALL_SUBSCRIBE = "subscribe";
	public static String CALL_SENDCHATREQ = "sendChatRequest";
	public static String CALL_DISABLE_TOPIC = "disableTopic";
	
	/**
	 * List of connected client identified by clientId
	 */
	private Map<String, IClient> mClientsMap = new Hashtable<String, IClient>();
	
	/**
	 * List of connected client identified by userId
	 */
	private Map<String, IClient> mClientsUsers = new Hashtable<String, IClient>();
	
	/**
	 * List of topics that a client subscribe to
	 */
	private Map<String, Map<String, String>> mClientsTopics = new Hashtable<String, Map<String,String>>();
	
	/**
	 * List of currently subscribed topic.
	 * contains list of clients who subscribed to a topic
	 */
	private Map<String, Topic> mTopicsMap = new Hashtable<String, Topic>();
	
	// ----------------- CHAT RPC  ------------------------
	public void publish(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("publish");
		
		PublishRequest cc = getPublishRequest(client, function, params);
		
		doPublish(cc);
	}

	public void subscribe(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("subscribe");
		
		SubscribeRequest cc = getSubscribeRequest(client, function, params);
		
		addChatClient(cc);
	}
	
	public void unSubscribe(IClient client, RequestFunction function, AMFDataList params) {
		getLogger().info("unSubscribe");
		
		SubscribeRequest cc = getSubscribeRequest(client, function, params);

		removeChatClient(cc);
	}

	public void sendChatRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("sendChatRequest");
		
		PublishRequest cc = getPublishRequest(client, function, params);
		
		
		IClient destClient = mClientsUsers.get(cc.getDestUserName());
		if (destClient != null) {
			
			// check should be from the same session
			getLogger().info("About to call: onChatRequest");
			
			// subscribe sender to this topic
			getLogger().info("About to subscribe " + cc.getUserName() + " to topic: " + cc.getTopic());
			addChatClient(cc);
			
			// subscribe dest to this topic 
			SubscribeRequest dc = new SubscribeRequest();
			dc.setClient(destClient);
			dc.setUserName(cc.getDestUserName());
			dc.setId(String.valueOf(destClient.getClientId()));
			dc.setSessionId(cc.getSessionId());
			dc.setTopic(cc.getTopic());

			getLogger().info("About to subscribe " + dc.getUserName() + " to topic: " + dc.getTopic());
			addChatClient(dc);
			
			// publish to both
			publish(client, function, params);
			
			sendResult(client, params, composeResult(RESULT_OK, cc.getTopic(), CALL_SENDCHATREQ, "success sending chat request to: " + cc.getMessage() + " from: " + cc.getUserName()));
		} else {
			
			getLogger().info("Failed calling onChatRequest: no client with name" + cc.getDestUserName() + " was found");
			sendResult(client, params, composeResult(RESULT_NOK, cc.getTopic(), CALL_SENDCHATREQ, "client with name " + cc.getDestUserName() + " does not exists"));
		}
	}
	
	public void disableTopic(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("disableTopic");
		
		TopicStatusRequest cc = getTopicStatusRequest(client, function, params);

		String topic = cc.getTopic();
		
		Topic t = mTopicsMap.get(topic);
		
		if (t != null) {
			getLogger().info( (cc.isDisableTopic()?" disabling":" enabling") + " topic + '" + topic + "'" );
			
			PublishRequest pr = getPublishRequest(client, function, params);
			pr.setMessage(cc.getMessage());
			
			if (cc.isDisableTopic()) {
				doPublish(pr);
				t.setDisabled(cc.isDisableTopic());
			} else if (t.isDisabled() && !cc.isDisableTopic()) {
				t.setDisabled(cc.isDisableTopic());
				doPublish(pr);
			}
		} else {
			// topic not found
			getLogger().info("Topic '" + topic + "' was not found");
		}

	}
	
	// ---------------- HELPER ------------------------------
	public static BaseRequest getBaseRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		BaseRequest cc = new BaseRequest();
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		
		return cc;
	}
	
	public static PublishRequest getPublishRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		PublishRequest cc = new PublishRequest();
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		cc.setTopic(getParamString(params, PARAM2));
		cc.setUserName(getParamString(params, PARAM3));
		cc.setMessage(getParamString(params, PARAM4));
		cc.setDestUserName(getParamString(params, PARAM5));
		
		return cc;
	}
	
	public static SubscribeRequest getSubscribeRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		SubscribeRequest cc = new SubscribeRequest();
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		cc.setTopic(getParamString(params, PARAM2));
		cc.setUserName(getParamString(params, PARAM3));
		
		return cc;
	}
	
	public static TopicStatusRequest getTopicStatusRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		TopicStatusRequest cc = new TopicStatusRequest();
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		cc.setTopic(getParamString(params, PARAM2));
		cc.setUserName(getParamString(params, PARAM3));
		cc.setDisableTopic(getParamBoolean(params, PARAM4));
		cc.setMessage(getParamString(params, PARAM5));
		
		return cc;
	}
	
	
	public static String composeResult(int code, String topic, String method, String message) {
		return code + ":" + topic + ":" + method + ":" + message;
	}
	
	private void doPublish(PublishRequest cc) {
		String topic = cc.getTopic();
		
		Topic t = mTopicsMap.get(topic);
		
		if (t!=null) {
		
			if (!t.isDisabled()) {
				Map<String, BaseRequest> subscribers = t.getSubscribers();
				
				if (subscribers != null) {
					// publishing
					getLogger().info("publishing message to topic '" + topic + "'");
					
					// log:
					final String lUserName = cc.getUserName();
					final String lmsg = cc.getMessage();
					final String ldestUname = cc.getDestUserName();
					final String lSessionId = cc.getSessionId();
					final String lTopic = cc.getTopic();
					final Date ldate = new Date();
					
					ServiceManager.getInstance().execute(new Runnable() {
					
						@Override
						public void run() {
							ChatLogService.writeLog(ldestUname, lmsg, lUserName, lSessionId, ldate, lTopic);
						}
					});
					
					for (String clientId : subscribers.keySet()) {
						//sendResult(client, params, cc.getUserName() + ": " + cc.getMessage());
						IClient subs = mClientsMap.get(clientId);
						if (subs != null) {
							subs.call("onMessage", this, cc.getUserName(), cc.getDestUserName(), cc.getTopic(), cc.getMessage() );
						}
					}
				} else {
					getLogger().info("no subscribers found in topic: " + topic);
				}
			} else {
				getLogger().info("Topic '"+topic+"' is disabled");
			}
		
		} else {
			getLogger().info("No topic found: " + topic);
		}
	}
	
	public void addChatClient(SubscribeRequest cc) {
			String clientId = cc.getId();
		
			// add client
			if (mClientsMap.get(clientId) == null) {
				getLogger().debug("Add client with id: " +  clientId + " to clienstmap");
				mClientsMap.put(clientId, cc.getClient());
			}
		
			// find topic
			Topic t = mTopicsMap.get(cc.getTopic());
			
			if (t != null) {
				// topic found! add this client
				
				if (t.addSubscriber(clientId, cc) == null) {
					getLogger().info("Add new client: " + cc + " to Topics list: " + cc.getTopic());
				} else {
					getLogger().info("Client already subsriber to topic: " + cc.getTopic());
				}
			} else {
				// topic Not Found! create one
				getLogger().info("Create NEW TOPIC " + cc.getTopic() + " and Add new client: " + cc.getUserName());
				
				t = new Topic(cc.getTopic());
				t.addSubscriber(clientId, cc);
				
				mTopicsMap.put(cc.getTopic(), t);
			}
			
			// add chat topic 
			Map<String, String> topicList = mClientsTopics.get(clientId);
			if (topicList == null) {
				topicList  = new Hashtable<String, String>();
				topicList.put(cc.getTopic(), clientId);
				
				getLogger().info("About to add NEW topic list: " + cc.getTopic() + "  to client: " + cc.getUserName());
				mClientsTopics.put(clientId, topicList);
			} else {
				
				if (topicList.get(cc.getTopic()) == null) {
					getLogger().info("About to add topic "+ cc.getTopic() +" to " + cc.getUserName());
					topicList.put(cc.getTopic(), clientId);
				} else {
					getLogger().info("Topic: " + cc.getTopic() +" already subscribed by " + cc.getUserName());
				}
			}
			
			// add client user mapping
			
			if (mClientsUsers.get(cc.getUserName()) == null) {
				getLogger().info("About to add user: " + cc.getUserName() + " to clientuser list");
				mClientsUsers.put(cc.getUserName(), cc.getClient());
			}
	}
	
	public void removeChatClient(SubscribeRequest cc) {
		
		// find topic
		Topic t = mTopicsMap.get(cc.getTopic());
		
		if (t != null) {
			// found! remove this client
			getLogger().info("Removing client: " + cc + " from Topic: " + cc.getTopic());
			t.removeSubscriber(cc.getId());
			
			// check empty maps
			Map<String, BaseRequest> subs = t.getSubscribers();
			if (subs.size() == 0) {
				getLogger().info("Removing empty topic: " + t.getName());
				// remove it from topicList
				mTopicsMap.remove(cc.getTopic());
			}
		} else {
			// topic Not Found!
			getLogger().info("Topic '" + cc.getTopic() + "' was not found");
		}
		
	}
	
	public void unsubscribeFromAll(IClient client) {
		// remove this client from all collections
		String cid = String.valueOf(client.getClientId());
		
		Map<String, String> subscribedTopics = mClientsTopics.get(client);
		
		if (subscribedTopics != null) {
			for (String topics : subscribedTopics.keySet()) {
				Topic t = mTopicsMap.get(topics);
				if (t != null) {
					getLogger().info("removing: " + cid);
					t.removeSubscriber(cid);
				} else {
					getLogger().error("unsubscribeFromAll: this block should be unreachable!!");
				}
			}
		} else {
			getLogger().debug("Clients subscribe to nothing");
		}
		
		mClientsTopics.remove(cid);
		
		mClientsMap.remove(cid);
	}
	
	// ---------------- LIFE CYCLE --------------------------
	public void onAppStart(IApplicationInstance appInstance) {
		super.onAppStart(appInstance);
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