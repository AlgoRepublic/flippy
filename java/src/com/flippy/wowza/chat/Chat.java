package com.flippy.wowza.chat;

import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleCallResult;
import com.wowza.wms.request.RequestFunction;
import com.wowza.wms.sharedobject.ISharedObject;
import com.wowza.wms.sharedobject.ISharedObjects;

public class Chat extends FlippyModuleBase implements IModuleCallResult {

	public static final int RESULT_OK = 200;
	public static final int RESULT_NOK = 500;
	
	public static final int KICK_CODE_OTHER_LOGIN = 1; // other user login with same username
	public static final int KICK_CODE_MODERATOR = 2; // kick by moderator
	public static final int KICK_CODE_LOGOUT = 3; // kick by logout
	
	/**
	 * List of connected client identified by username
	 */
	private static Map<String, Map<String,Object>> mClients = new Hashtable<String, Map<String,Object>>();
	private static Map<String, Map<String,Object>> mClientsIdx = new Hashtable<String, Map<String,Object>>();	
	
	// ----------------- CHAT RPC  ------------------------
	
	public void login(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("login");
		
		try {
			
		
			// 1. GET PARAMETERS
			// sessionId, userName, password, city
			int sessionId = getParamInt(params, PARAM1);
			String userName = getParamString(params, PARAM2);
			//String password = getParamString(params, PARAM3);
			String city = getParamString(params, PARAM3);
			
			// TODO: implements validate()				 			
			
			Map<String, Object> clientMap = new HashMap<String, Object>();
			clientMap.put("sessionId", sessionId);
			clientMap.put("userName", userName);
			clientMap.put("client", client);
			clientMap.put("city", city);
			
			addNewUser(clientMap);
		
			sendResult(client, params, "OK");
		} catch (Exception e) {
			sendResult(client, params, "NOK");
		}
	}
	
	
	public void logout(IClient client, RequestFunction function, AMFDataList params) {
		getLogger().info("logout");
		
		// 1. GET PARAMETERS
		// sessionId, userName
		String userName = getParamString(params, PARAM2);
		
		kickByUserName(userName, KICK_CODE_LOGOUT);
	}

	public void kick(IClient client, RequestFunction function, AMFDataList params) {
		getLogger().info("kick");

		// 1. GET PARAMETERS
		// sessionId, userName, targetUserName
		int sessionId = getParamInt(params, PARAM1);
		String userName = getParamString(params, PARAM2);
		String targetUserName = getParamString(params, PARAM3);
		String msg = getParamString(params, PARAM4);
		
		kickByUserName(targetUserName, KICK_CODE_MODERATOR);
		
	}
	
	public void broadcast(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("broadcast");
		
		int sessionId = getParamInt(params, PARAM1);
		String userName = getParamString(params, PARAM2);
		String msg = getParamString(params, PARAM3);
		Date date = getParamDate(params, PARAM4);
		
		ISharedObject so = getAppInstance(client).getSharedObjects(false).get(getUserRSOName(sessionId));
		if (so != null) {
			so.send("onBroadcastMessage", sessionId, userName, msg, date);
		} else {
			getLogger().error("Could not broadcast: Null RSO");
		}
	}

	
	/**
	 * Send message to destUserName. Call onMessage() on client
	 * 
	 * @param client
	 * @param function
	 * @param params
	 */
	public void sendMessage(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("sendMessage");

		int sessionId = getParamInt(params, PARAM1);
		String userName = getParamString(params, PARAM2);
		String destUserName = getParamString(params, PARAM3);
		String msg = getParamString(params, PARAM4);
		Date date = getParamDate(params, PARAM5);
		
		Map<String, Object> destClient = mClients.get(destUserName);
		
		if (destClient != null) {
			boolean senderBanned = false; // TODO: implements banning
			if (! senderBanned) {
				IClient dc = (IClient) destClient.get("client");
				dc.call("onChatMessage", this, sessionId, userName, msg, date, false);
			} else {
				getLogger().debug("sender is banned by dest");
			}
		}
		
	}
	
	public void disableRoom(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("disableRoom");
		

	}
	
	// ---------------- HELPER ------------------------------
	private static String getUserRSOName(int sessionId) {		
		return sessionId + "users"; // RSO SLOT NAME
	}
	
	private static void addNewUser(Map<String, Object> aClientMap) {
		getLogger().info("Abour To add new use");
		
		String userName = (String) aClientMap.get("userName");		
		IClient client = (IClient) aClientMap.get("client");
		int sessionId = ((Integer)aClientMap.get("sessionId")).intValue();
		
		String soName = getUserRSOName(sessionId); // RSO SLOT NAME				
		
		// 1. Check double logon, kick old one 
		Map<String, Object> prevClient = mClients.get(userName); 
		if (prevClient != null) {
			getLogger().info("prev entries exists, kick old one");
			kickByUserName(userName, KICK_CODE_OTHER_LOGIN);	
		}
		
		// 2. Add new user in mClients&Idx
		getLogger().info("add new user: " + aClientMap);
		mClients.put(userName, aClientMap);		
		mClientsIdx.put(String.valueOf(client.getClientId()), aClientMap);
		
		// 3. Add new user in User List RSO						
		addToUserListRSO(aClientMap, soName);
	
	}

	private static void addToUserListRSO(Map<String, Object> aClientMap,
			String aSoName) {
		
		getLogger().info("adding user to user RSO");
		
		// GET PARAMS
		String userName = (String) aClientMap.get("userName");		
		int sessionId = ((Integer)aClientMap.get("sessionId")).intValue();
		String city = (String)aClientMap.get("city");
		IClient client = (IClient) aClientMap.get("client");
		
		// GET RSO
		ISharedObject rso = getAppInstance(client).getSharedObjects(false).getOrCreate(aSoName);
		
		// Compose AMF Data 
		AMFDataObj obj = new AMFDataObj();
//		obj.put("sessionId", sessionId);
		obj.put("userName", userName);
		obj.put("city", city);
		
		// Add to RSO
		rso.lock();
		try {
			rso.setProperty(userName, obj);
		} finally {
			rso.unlock();
		}
		
	}
	
	private static void removeFromUserListRSO(Map<String, Object> aClientMap, String aSoName) {
		// GET PARAMS
		String userName = (String) aClientMap.get("userName");		
		IClient client = (IClient) aClientMap.get("client");
		
		// GET RSO
		ISharedObject rso = getAppInstance(client).getSharedObjects(false).getOrCreate(aSoName);
				
		// Remove from RSO
		rso.lock();
		try {
			rso.deleteSlot(userName);
		} finally {
			rso.unlock();
		}
		
	}		
	
	/**
	 * Call client method (onKickDoubleLogon, onKickByModerator) and disconnect this client. 
	 * The cleanup will be done in onDisconnect() method.
	 * 
	 * @param userName to be kicked
	 * @param i KICK CODE
	 */
	private static void kickByUserName(String userName, int i) {
		
		getLogger().debug("kick user: " + userName);
		
		Map<String, Object> c = mClients.get(userName);
		
		if (c != null) {
			IClient iClient = (IClient) c.get("client");
			if (i == KICK_CODE_OTHER_LOGIN) {
				getLogger().debug("send kick doublelogon: " + userName);
				iClient.call("onKickDoubleLogon");			
			} else if (i == KICK_CODE_MODERATOR) {
				getLogger().debug("send kick by moderator: " + userName);
				iClient.call("onKickByModerator");
			} else {
				// show nothing
			}
			
			removeFromUserListRSO(c, getUserRSOName(((Integer)c.get("sessionId")).intValue()));
			
			getLogger().debug("shutting down user: " + userName);
			iClient.shutdownClient();
			// clean up will be called on onDisconnect
		}		
				
	}
	
	public static void cleanUpClient(IClient client) {
		//removeFromRSO
		Map<String, Object> aClientMap = mClientsIdx.get(String.valueOf(client.getClientId()));		
		if (aClientMap != null) {
			try {
				// cleanup client				
				int sessionId = ((Integer)aClientMap.get("sessionId")).intValue();
				String userName = (String)aClientMap.get("userName");
				String aSoName = getUserRSOName(sessionId);
				
				// check other connection with same username and sessionId
				// if exists dont remove from mClients and RSO
				Map<String, Object> other = mClients.get(userName);
				
				if(other != null && ((IClient)other.get("client")).getClientId() != client.getClientId()) {
					// other member with same username already logged in
					mClientsIdx.remove(client.getClientId());
				} else {					
					mClientsIdx.remove(client.getClientId());
					mClients.remove(userName);				
					removeFromUserListRSO(aClientMap, aSoName);					
				}
			} catch (Exception e) {
				getLogger().error("Exception while removing client with id (" + client.getClientId() + ")", e);
			}
		} else {
			getLogger().error("Ghost user! how can this client does not exists in the mClients: " + client.getClientId());
		}
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
		
		// cleanupResources
		ISharedObjects sharedObjects = appInstance.getSharedObjects(false);
		List list = sharedObjects.getObjectNames();
		
		for (Object object : list) {
			ISharedObject connectedUsersSO = sharedObjects.get(object.toString()); 
			if (connectedUsersSO != null)
			{
				getLogger().info("onAppStart: release shared object: "+ object.toString());
				connectedUsersSO.lock();
				try
				{
					connectedUsersSO.release();
				}
				catch (Exception e)
				{
					getLogger().error("Exception while releasing RSO: " + e.getMessage());
				}
				finally
				{
					connectedUsersSO.unlock();
				}
			}
		}
		
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("onConnect: " + client.getClientId());
		// clean up rso
		
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		// clean up client
		cleanUpClient(client);		
	}	

	@Override
	public void onResult(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("got result from client: " + getParamString(params, PARAM1));
	}

}