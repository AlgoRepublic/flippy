package com.flippy.wowza.whiteboard;

import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.client.IClient;
import com.wowza.wms.request.RequestFunction;

/**
 * @author uudashr
 *
 */
public interface WhiteboardModule {
    /**
     * @param client
     * @param function
     * @param params sessionId
     */
    void joinSession(IClient client, RequestFunction function,
            AMFDataList params);
}
