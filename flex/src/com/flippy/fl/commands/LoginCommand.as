package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.LoginDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.net.Responder;

	public class LoginCommand extends SequenceCommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function LoginCommand()
		{
			
		}

		override public function execute(event:CairngormEvent):void
		{
			if (!model.main.bncConnected) {
				model.logger.logMessage("Opening new connection..", this);
				new SetupConnectionEvent().dispatch();
				new StartConnectionEvent(model.main.RTMP_URL).dispatch();
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
