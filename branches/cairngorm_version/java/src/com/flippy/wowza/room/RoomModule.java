package com.flippy.wowza.room;

import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.client.IClient;
import com.wowza.wms.request.RequestFunction;

/**
 * This interface define all functionality of server side of Room Module.
 * 
 * @author uudashr
 *
 */
public interface RoomModule {
    
    /**
     * Create room.
     * 
     * @param client
     * @param function
     * @param params should be name:String, learningAge:int, description:String.
     */
    void createRoom(IClient client, RequestFunction function, AMFDataList params);
    
    /**
     * Get room list.
     * 
     * @param client
     * @param function
     * @param params (all parameters will be ignored).
     */
    void getRooms(IClient client, RequestFunction function, AMFDataList params);
    
    /**
     * Get room list with specified required learning age.
     * 
     * @param client
     * @param function
     * @param params should be requiredLearningAge:int.
     */
    void getRoomsWithRequiredLearningAge(IClient client, RequestFunction function, AMFDataList params);
    
    /**
     * Delete room.
     * 
     * @param client
     * @param function
     * @param params should be roomId:int.
     */
    void deleteRoom(IClient client, RequestFunction function, AMFDataList params);
    
    /**
     * Update room.
     * 
     * @param client
     * @param function
     * @param params should be roomId:int, name:String, learningAge:int, description:String.
     */
    void updateRoom(IClient client, RequestFunction function, AMFDataList params);
}
