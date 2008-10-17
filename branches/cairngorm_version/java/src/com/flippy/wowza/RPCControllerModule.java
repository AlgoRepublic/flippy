package com.flippy.wowza;

import com.flippy.wowza.chat.Chat;
import com.flippy.wowza.login.Login;
import com.flippy.wowza.member.MemberInfo;
import com.flippy.wowza.question.Question;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleOnCall;
import com.wowza.wms.request.RequestFunction;

public class RPCControllerModule extends FlippyModuleBase implements IModuleOnCall {
	
	@Override
	public void onCall(String method, IClient client, RequestFunction function,
			AMFDataList params) {
		
		// commands map
		
		if (method.equals("question.submit")) {
			new Question().submitQuestion(client, function, params);
		} else if (method.equals("chat.broadcast")) {
			new Chat().broadcast(client, function, params);
		} else if (method.equals("chat.login")) {
			new Chat().login(client, function, params);
		} else if (method.equals("chat.logout")) {
			new Chat().logout(client, function, params);
		} else if (method.equals("chat.sendMessage")) {
			new Chat().sendMessage(client, function, params);
		} else if (method.equals("chat.disableTopic")) {
			new Chat().disableRoom(client, function, params);
		} else if (method.equals("login.login")) {
			Login.login(client, function, params);
		} else if (method.equals("member.findByUserName")) {
			new MemberInfo().findByUserName(client, function, params);
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
		new Chat().onAppStop(appInstance);
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("onConnect: " + client.getClientId());
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		Chat.cleanUpClient(client);
	}

}
