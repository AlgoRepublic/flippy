package com.flippy.wowza.question;

import java.util.Date;

import com.flippy.service.QuestionLogService;
import com.flippy.wowza.FlippyModuleBase;
import com.wowza.wms.amf.AMFDataList;
import com.wowza.wms.application.IApplicationInstance;
import com.wowza.wms.client.IClient;
import com.wowza.wms.module.IModuleCallResult;
import com.wowza.wms.request.RequestFunction;

public class Question extends FlippyModuleBase implements IModuleCallResult {

	public static final int RESULT_OK = 200;
	public static final int RESULT_NOK = 500;
	
	public static String CALL_SUBMIT = "submitQuestion";
	
	// ----------------- CHAT RPC  ------------------------
	public void submitQuestion(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("submitQuestion");
		
		SubmitQuestionRequest cc = getSubmitQuestionRequest(client, function, params);
		
		getLogger().debug("got question: " + cc);
		
		int affected = QuestionLogService.writeLog(cc.getSessionId(), cc.getUserName(), cc.getQuestion(), new Date());
		
		if (affected > 0) {
			sendResult(client, params, "ok");		
		} else {
			sendResult(client, params, "nok");
		}
	}
	
	// ---------------- HELPER ------------------------------
	
	public static SubmitQuestionRequest getSubmitQuestionRequest(IClient client, RequestFunction function,
			AMFDataList params) {
		SubmitQuestionRequest cc = new SubmitQuestionRequest();				
		
		cc.setId(String.valueOf(client.getClientId()));
		cc.setClient(client);
		cc.setSessionId(getParamString(params, PARAM1));
		cc.setUserName(getParamString(params, PARAM2));
		cc.setQuestion(getParamString(params, PARAM3));
		
		return cc;
	}
	
	public static String composeResult(int code, String method, String message) {
		return code + ":" + method + ":" + message;
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
	}

	@Override
	public void onResult(IClient client, RequestFunction function,
			AMFDataList params) {
		getLogger().info("got result from client: " + getParamString(params, PARAM1));
	}

}