package com.flippy.wowza.room;

import java.util.List;

import com.flippy.domain.Room;
import com.flippy.service.RoomService;
import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataArray;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleNotify;
import com.wowza.wms.module.IModuleOnConnect;
import com.wowza.wms.module.ModuleItem;
import com.wowza.wms.request.RequestFunction;

/**
 * This are Wowza Media Server module for Room Management.
 * 
 * @author uudashr
 *
 */
public class RoomManagement extends FlippyModuleBase implements IModuleNotify, IModuleOnConnect, RoomModule {
    
    public void onModuleLoad(ModuleItem moduleItem) {
        getLogger().info("Load '" + moduleItem.getName() + "' module");
    }
    
    public void onModuleUnload(ModuleItem moduleItem) {
        getLogger().info("Unload '" + moduleItem.getName() + "' module");
    }
    
    public void onConnect(IClient client, RequestFunction function, AMFDataList params) {
        getLogger().info("Client connect from " + client.getIp() + "(" + client.getClientId() + ")");
    }
    
    public void onConnectAccept(IClient client) {
        getLogger().info("Accept connection from " + client.getIp() + "(" + client.getClientId() + ")");
    }
    
    public void onConnectReject(IClient client) {
        getLogger().info("Reject connection from " + client.getIp() + "(" + client.getClientId() + ")");
    }
    
    public void onDisconnect(IClient client) {
        getLogger().info("Disconnect connection from " + client.getIp() + "(" + client.getClientId() + ")");
    }
    
    public void doSomething(IClient client, RequestFunction function, AMFDataList params) {
        getLogger().info("Invoking doSomething");
        sendResult(client, params, "Hello World");
        getLogger().info("Result returned");
    }
    
    /* (non-Javadoc)
     * @see com.flippy.wowza.RoomModule#createRoom(com.wowza.wms.client.IClient, com.wowza.wms.request.RequestFunction, com.wowza.wms.amf.AMFDataList)
     */
    public void createRoom(IClient client, RequestFunction function, AMFDataList params) {
        String name = params.getString(PARAM1);
        int learningAge = params.getInt(PARAM2);
        String description = params.getString(PARAM3);
        getLogger().debug("Parameters:");
        for (int i = 0; i < params.size(); i++) {
            getLogger().debug("Param[" + i + "]=" + params.get(i) + " " + params.get(i).getClass());
        }
        
        StringBuilder builder = new StringBuilder("\nname: " + name);
        builder.append("\nlearningAge: " + learningAge);
        builder.append("\ndescription: " + description);
        getLogger().info("Create room, param size " + params.size() + builder.toString());
        
        List<Room> rooms = RoomService.createRoom(name, learningAge, description);
        AMFDataArray arr = toAmfArray(rooms);
        sendResult(client, params, arr);
    }
    
    /* (non-Javadoc)
     * @see com.flippy.wowza.RoomModule#getRooms(com.wowza.wms.client.IClient, com.wowza.wms.request.RequestFunction, com.wowza.wms.amf.AMFDataList)
     */
    public void getRooms(IClient client, RequestFunction function,
            AMFDataList params) {
        List<Room> rooms = RoomService.getRoom();
        AMFDataArray arr = toAmfArray(rooms);
        sendResult(client, params, arr);
    }
    
    /* (non-Javadoc)
     * @see com.flippy.wowza.RoomModule#getRoomsWithRequiredLearningAge(com.wowza.wms.client.IClient, com.wowza.wms.request.RequestFunction, com.wowza.wms.amf.AMFDataList)
     */
    public void getRoomsWithRequiredLearningAge(IClient client,
            RequestFunction function, AMFDataList params) {
        int requiredLearningAge = params.getInt(PARAM1);
        List<Room> rooms = RoomService.getRooms(requiredLearningAge);
        AMFDataArray arr = toAmfArray(rooms);
        sendResult(client, params, arr);
    }
    
    /* (non-Javadoc)
     * @see com.flippy.wowza.RoomModule#deleteRoom(com.wowza.wms.client.IClient, com.wowza.wms.request.RequestFunction, com.wowza.wms.amf.AMFDataList)
     */
    public void deleteRoom(IClient client, RequestFunction function,
            AMFDataList params) {
        int roomId = params.getInt(PARAM1);
        List<Room> rooms = RoomService.delete(roomId);
        AMFDataArray arr = toAmfArray(rooms);
        sendResult(client, params, arr);
    }

    /* (non-Javadoc)
     * @see com.flippy.wowza.RoomModule#updateRoom(com.wowza.wms.client.IClient, com.wowza.wms.request.RequestFunction, com.wowza.wms.amf.AMFDataList)
     */
    public void updateRoom(IClient client, RequestFunction function,
            AMFDataList params) {
        int roomId = params.getInt(PARAM1);
        String name = params.getString(PARAM2);
        int learningAge = params.getInt(PARAM3);
        String description = params.getString(PARAM4);
        List<Room> rooms = RoomService.update(roomId, name, learningAge, description);
        AMFDataArray arr = toAmfArray(rooms);
        sendResult(client, params, arr);
    }
    
    /**
     * This is utility function to convert {@link List} of {@link Room} to the
     * {@link AMFDataArray}.
     * 
     * @param rooms is the {@link List} of {@link Room}.
     * @return the collection of rooms as {@link AMFDataArray}.
     */
    private static AMFDataArray toAmfArray(List<Room> rooms) {
        AMFDataArray arr = new AMFDataArray();
        for (Room room : rooms) {
            AMFDataObj amfObj = new AMFDataObj();
            amfObj.put("id", room.getId());
            amfObj.put("name", room.getName());
            amfObj.put("learningAge", room.getLearningAge());
            amfObj.put("description", room.getDescription());
            amfObj.put("dateCreate", room.getDateCreate());
            arr.add(amfObj);
        }
        return arr;
    }
}
