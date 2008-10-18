package com.flippy.wowza.whiteboard;

import java.util.HashSet;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleOnConnect;
import com.wowza.wms.request.RequestFunction;

/**
 * This module used to track the shared object if no one connected to the room
 * for several time, so we have to destroy the shared object.
 * 
 * @author uudashr
 * 
 */
public class Whiteboard extends FlippyModuleBase implements IModuleOnConnect, WhiteboardModule {
    private Map<Integer, Set<IClient>> sessionMap = new Hashtable<Integer, Set<IClient>>();
    
    @Override
    public void joinSession(IClient client, RequestFunction function,
            AMFDataList params) {
        
        int sessionId = params.getInt(PARAM1);
        getLogger().info("Client with id " + client.getClientId() + " joining a session " + sessionId);
        registerClient(sessionId, client);
        sendResult(client, params, true);
    }

    /**
     * Register the client to a specified session.
     * 
     * @param sessionId is the session identifier.
     * @param client is the client.
     * @return <tt>true</tt> if the registration is succeed, or <tt>false</tt>
     *         if failed or the client is already registered.
     */
    private boolean registerClient(Integer sessionId, IClient client) {
        Set<IClient> clients = sessionMap.get(sessionId);
        if (clients == null) {
            clients = new HashSet<IClient>();
        }
        return clients.add(client);
    }

    /**
     * Unregister the client and return the sessionId where the client connected
     * to.
     * 
     * @param client is the client.
     * @return the session id.
     */
    private Integer unregisterClient(IClient client) {
        for (Entry<Integer, Set<IClient>> entry : sessionMap.entrySet()) {
            boolean succeed = entry.getValue().remove(client);
            if (succeed) {
                return entry.getKey();
            }
        }
        return 0;
    }
    
    
    @Override
    public void onConnect(IClient client, RequestFunction function, AMFDataList params) {
    }
    
    @Override
    public void onConnectAccept(IClient client) {
    }
    
    @Override
    public void onConnectReject(IClient client) {
    }
    
    @Override
    public void onDisconnect(IClient client) {
        getLogger().info("Client " + client.getClientId() + " disconnected");
        Integer sessionId = unregisterClient(client);
        getLogger().debug("Client " + client.getClientId() + " unregistered from session " + sessionId);
    }
}
