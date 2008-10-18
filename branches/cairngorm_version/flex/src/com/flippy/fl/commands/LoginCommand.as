package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.LoginDelegate;
	import com.flippy.fl.business.RoomDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.view.Login;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.net.Responder;
	import flash.utils.getQualifiedClassName;

	public class LoginCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function LoginCommand()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			if (!model.main.bncConnected) {
				model.logger.logMessage("Opening new connection..", "Login.mxml");
				new SetupConnectionEvent().dispatch();
				new StartConnectionEvent("rtmp://202.158.39.178:1935/flippy").dispatch();
			}
			 
			logger.logMessage("About to execute loginCommand", this);
			
			loginEvent = LoginEvent (event);
			
			logger.logMessage("userName: " + loginEvent.userName + "; pwd: " + loginEvent.password, this);
						
			new LoginDelegate(new Responder(result, fault)).validate(loginEvent.userName, loginEvent.password);				
			
		}
		
		public function result(data:Object):void
		{
			logger.logMessage( "Got result in loginCommand: " + data, this);			
			
			var loginVO:LoginVO = null;
			
			if (data != "") {
			    loginVO = new LoginVO(loginEvent.userName, loginEvent.password, data.roleName, data.city, data.learningAge);
			}						
			
			if (loginVO != null) {
				
				logger.logMessage( "valid user", this);												
				
				// populate model
				model.main.userName = loginVO.userName;
				model.main.password = loginVO.password;				
				model.main.role = loginVO.role;
				model.main.learningAge = loginVO.learningAge;
				model.main.city = loginVO.city;
				
				// init room
				function resultHandler(data:Object):void
				{
					model.main.rooms = data as Array;
					model.logger.logMessage("Got result as list of room: size " + model.main.rooms.length, "LoginCommand");
					
					model.main.mainScreenState = model.main.MAIN_ROOM_SCREEN; // use this for member
					//model.main.mainScreenState = model.main.MAIN_AUTHOR_SCREEN; // use this for author
					model.main.authorScreenState = model.main.AUTHOR_ROOM_SELECTION;
				}
				
				function faultHandler(info:Object):void
				{
					model.logger.logMessage("Got fault in getRoomList", this);
				}
				var requiredLearningAge:int = 3;
				new RoomDelegate(new Responder(resultHandler, faultHandler)).getRoomList(requiredLearningAge);
				
			} else {
				// animate login failed
				if (loginEvent.loginBox != null) {
					Login(loginEvent.loginBox).doInvalid("Invalid UserName or Password");
				}
			}
			
		}
		
		public function fault(event:Object):void 
		{
			logger.logMessage( "Got fault in loginCommand", this);
		}
		
		
		
	}
}
