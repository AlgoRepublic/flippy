package com.flippy.wowza;

import com.flippy.wowza.login.Login;
import com.flippy.wowza.question.Question;
import com.flippy.wowza.chat.Chat;
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
		} else if (method.equals("chat.publish")) {
			new Chat().publish(client, function, params);
		} else if (method.equals("chat.subscribe")) {
			new Chat().subscribe(client, function, params);
		} else if (method.equals("chat.unSubscribe")) {
			new Chat().unSubscribe(client, function, params);
		} else if (method.equals("chat.sendChatRequest")) {
			new Chat().sendChatRequest(client, function, params);
		} else if (method.equals("chat.disableTopic")) {
			new Chat().disableTopic(client, function, params);
		} else if (method.equals("login")) {
			new Login().login(client, function, params);
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
	}

	public void onConnect(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("onConnect: " + client.getClientId());
	}

	public void onDisconnect(IClient client) {
		getLogger().info("onDisconnect: " + client.getClientId());
		new Chat().unsubscribeFromAll(client);
	}

}
