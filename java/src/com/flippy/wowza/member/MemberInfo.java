package com.flippy.wowza.member;

import com.flippy.service.MemberInfoService;
import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.client.IClient;
import com.wowza.wms.request.RequestFunction;

public class MemberInfo extends FlippyModuleBase {

	public void findByUserName(IClient client, RequestFunction function, AMFDataList params) {
		String userName = getParamString(params, PARAM1);
		
        getLogger().info("findByUserName");
        
        getLogger().info("username: " + userName);
        
		com.flippy.domain.MemberInfo m = MemberInfoService.findByUserName(userName);
		
		if (m!= null) {
            getLogger().info("member info for username: " + userName + " was found: " + m);        
			// oke
            AMFDataObj ret = new AMFDataObj();
            ret.put("userName", userName);
            ret.put("roleName", m.getRoleName());
            ret.put("city", m.getCity());
            if (m.getDtlastlogin()!=null) {
            	ret.put("dtlastlogin", m.getDtlastlogin());
            } else {
            	ret.put("dtlastlogin", "");
            }
			sendResult(client, params, ret);
		} else {
            getLogger().info("member info not found");
			sendResult(client, params, "");
		}
	}

}
