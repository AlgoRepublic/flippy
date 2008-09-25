package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class LoginEvent extends CairngormEvent
	{
		public static const LOGIN:String = "flippy.Login";
		
		public var userName:String;
		public var password:String;		
		public var loginBox:UIComponent;
		
		public function LoginEvent(userName:String, password:String, loginBox:UIComponent)
		{
			super(LOGIN);
			this.userName = userName;
			this.password = password;			
			this.loginBox = loginBox;
		}
		
		override public function clone():Event {
            return new LoginEvent(userName,password,loginBox);
        }
		
	}
}