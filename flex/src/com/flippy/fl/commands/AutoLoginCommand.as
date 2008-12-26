package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.SessionDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.vo.LoginVO;
	import com.flippy.fl.vo.SessionInfoVO;
	
	import mx.core.Application;

	public class AutoLoginCommand extends SequenceCommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function AutoLoginCommand ()
		{
			
		}

		override public function execute(event:CairngormEvent):void
		{
			var conferenceSessionId:String = Application.application.parameters.sessionId;
			//conferenceSessionId = "asdf";
			model.logger.logMessage("Using session id " + conferenceSessionId, "AutoLoginCommand");
			if (conferenceSessionId == null) {
				// session not available! show login screen!!
				logger.logMessage("session not available, show login screen!!", this);				
				model.main.mainScreenState = model.main.MAIN_LOGIN_SCREEN;
			} else {
				var delegate:SessionDelegate = new SessionDelegate(conferenceSessionId);
				function onResult(data:Object):void
				{
					model.logger.logMessage("Result found" , "AutoLoginCommand");
					var session:SessionInfoVO = data as SessionInfoVO;
					model.logger.logMessage("User name '" + session.username + "', type '" + session.type + "'" , "AutoLoginCommand");
					if (session != null) {
						var loginVO:LoginVO = new LoginVO(session.username, "", session.type, session.city, session.learningAge);
						var le:LoginEvent = new LoginEvent(null, null, null, LoginEvent.AUTHENTICATED, loginVO);
						
						nextEvent = le;
						executeNextCommand(); 
					} else {
						model.logger.logMessage("session is null" , "AutoLoginCommand");
					}
				}
				
				function onFault(info:Object):void
				{
					model.logger.logMessage("Failed getting session info: " + info , "AutoLoginCommand");
				}
				delegate.getInfo(onResult, onFault);
			}

		}
		
		public function result(data:Object):void
		{
			logger.logMessage( "Got result in loginCommand: " + data, this);			
			
			var loginVO:LoginVO = null;
			
			if (data != "") {
			    loginVO = new LoginVO(loginEvent.userName, loginEvent.password, data.roleName, data.city, data.learningAge);
			}						
			
			loginEvent.eventType = LoginEvent.AUTHENTICATED;
			loginEvent.loginVO = loginVO;
			
			nextEvent = loginEvent;
			executeNextCommand();
		}
		
		public function fault(event:Object):void 
		{
			logger.logMessage( "Got fault in loginCommand", this);
		}
		
		
		
	}
}
