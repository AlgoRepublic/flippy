package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class LoginEvent extends CairngormEvent
	{
		public static const LOGIN:String = "flippy.Login";
		public static const AUTHENTICATED:String = "flippy.LoginAuth";
		public static const AUTO:String = "flippy.LoginAuto";
		
		public var userName:String;
		public var password:String;		
		public var loginBox:UIComponent;
		public var eventType:String;
		public var loginVO:LoginVO;
		
		public function LoginEvent(userName:String, password:String, loginBox:UIComponent, eventType:String, loginVO:LoginVO)
		{
			super(eventType);						
			this.userName = userName;
			this.password = password;			
			this.loginBox = loginBox;
				
			this.eventType = eventType;
			this.loginVO = loginVO;		
		}
		
		override public function clone():Event {
            return new LoginEvent(userName,password,loginBox,eventType,loginVO);
        }
		
	}
}