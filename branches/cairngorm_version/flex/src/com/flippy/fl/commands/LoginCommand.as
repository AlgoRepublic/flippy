package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.LoginDelegate;
	import com.flippy.fl.business.RoomDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.view.Login;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.net.Responder;
	
	import mx.rpc.IResponder;

	public class LoginCommand implements ICommand, IResponder
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var loginEvent:LoginEvent;		
		
		public function LoginCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			model.logger.logMessage("About to execute loginCommand", "LoginCommand");
			
			loginEvent = LoginEvent (event);
			
			model.logger.logMessage("userName: " + loginEvent.userName + "; pwd: " + loginEvent.password, "LoginCommand");
						
			new LoginDelegate(this).validate(loginEvent.userName, loginEvent.password);			
			
		}
		
		public function result(event:Object):void
		{
			model.logger.logMessage( "Got result in loginCommand", "LoginCommand");
			
			model.logger.logMessage( "result: " + event, "LoginCommand");
			
			model.logger.logMessage( "result.result: " + event.result, "LoginCommand");
			
			var loginVO:LoginVO = null;
			
			if (event.result != "") {
			    loginVO = new LoginVO(loginEvent.userName, loginEvent.password, event.result.roleName);
			}						
			
			if (loginVO != null) {
				
				model.logger.logMessage( "valid user", "LoginCommand");												
				
				model.main.userName = loginVO.userName;
				model.main.password = loginVO.password;				
				model.main.role = loginVO.role;
				
				function resultHandler(data:Object):void
				{
					model.main.rooms = data as Array;
					model.logger.logMessage("Got result as list of room: size " + model.main.rooms.length, "LoginCommand");
					model.logger.logMessage("changing state to " + model.main.MAIN_ROOM_SCREEN, "LoginCommand");
					model.main.mainScreenState = model.main.MAIN_ROOM_SCREEN;
				}
				
				function faultHandler(info:Object):void
				{
					model.logger.logMessage("Got fault in getRoomList", "LoginCommand");
				}
				new RoomDelegate(new Responder(resultHandler, faultHandler)).getRoomList(3);
				
			} else {
				// animate login failed
				if (loginEvent.loginBox != null) {
					Login(loginEvent.loginBox).doInvalid("Invalid UserName or Password");
				}
			}
			
		}
		
		public function fault(event:Object):void 
		{
			model.logger.logMessage( "Got fault in loginCommand", "LoginCommand");
		}
		
	}
}