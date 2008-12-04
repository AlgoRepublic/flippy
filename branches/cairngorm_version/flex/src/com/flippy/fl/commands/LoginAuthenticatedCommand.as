package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.RoomDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.net.Responder;

	public class LoginAuthenticatedCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function LoginAuthenticatedCommand ()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			var loginEvent:LoginEvent = null;
			if (event is LoginEvent) {
				loginEvent = LoginEvent(event);
			}
						
			if (loginEvent != null && loginEvent.eventType == LoginEvent.AUTHENTICATED) {
				var loginVO:LoginVO = loginEvent.loginVO;				
				
				if (loginVO != null) {
					
					logger.logMessage( "valid user", this);												
					
					// populate model
					model.main.userName = loginVO.userName;
					model.main.password = loginVO.password;				
					model.main.role = loginVO.role;
					if (model.main.role == "author")
					{
						model.main.learningAge = 99;
					}
					else
					{
						model.main.learningAge = loginVO.learningAge;	
					}
					
					model.main.city = loginVO.city;
					trace("Learning age : " + model.main.learningAge);
					// init room
					function resultHandler(data:Object):void
					{
						model.main.rooms = data as Array;
						model.logger.logMessage("Got result as list of room: size " + model.main.rooms.length, "LoginCommand");
						
						if (model.main.role == "member")
						{
							
							model.main.mainScreenState = model.main.MAIN_ROOM_SCREEN; // use this for member
						}
						else
						{
							// this should be author
							model.main.mainScreenState = model.main.MAIN_AUTHOR_SCREEN; // use this for author
						}
						model.main.authorScreenState = model.main.AUTHOR_ROOM_SELECTION;
					}
					
					function faultHandler(info:Object):void
					{
						model.logger.logMessage("Got fault in getRoomList", this);
					}
					new RoomDelegate(new Responder(resultHandler, faultHandler)).getRoomList(model.main.learningAge);
					
				} else {
					// invalid login show login box
					model.main.mainScreenState = model.main.MAIN_LOGIN_SCREEN;					
				}
				
			} else {
				// invalid event
				logger.logMessage("invalid event type / null event", this); 
			}
			
		}						
		
	}
}
