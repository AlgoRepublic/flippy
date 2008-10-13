package com.flippy.wowza.login;

import java.util.Map;

import com.flippy.service.LoginService;
import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.amf.AMFDataObj;
import com.wowza.wms.client.IClient;
import com.wowza.wms.request.RequestFunction;

public class Login extends FlippyModuleBase {

	public static void login(IClient client, RequestFunction function, AMFDataList params) {
		String userName = getParamString(params, PARAM1);
		String password = getParamString(params, PARAM2);
		
        getLogger().info("login");
        
        getLogger().info("username: " + userName);
        getLogger().info("password: " + password);
        
		Map<String, Object> result = LoginService.login(userName, password);
		
		if (result != null) {
            getLogger().info("VALID username and password");        
			// oke
            AMFDataObj ret = new AMFDataObj();
            ret.put("userName", userName);
            ret.put("password", password);
            ret.put("roleId", Integer.parseInt(result.get("role_id").toString()));
            ret.put("roleName", (String)result.get("name"));
			sendResult(client, params, ret);
		} else {
            getLogger().info("INVALID username and password");
			sendResult(client, params, "");
		}
	}

}
