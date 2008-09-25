package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.core.UIComponent;
	import mx.rpc.IResponder;
	
	import com.flippy.fl.business.LoginDelegate;
	import com.flippy.fl.business.NetConnectionDelegate;
	import com.flippy.fl.commands.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.view.Login;
	import com.flippy.fl.vo.LoginVO;

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
				
				model.logger.logMessage( "changing state to " + model.main.MAIN_ROOM_SCREEN, "LoginCommand");
				
				model.main.mainScreenState = model.main.MAIN_ROOM_SCREEN;
				
				
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