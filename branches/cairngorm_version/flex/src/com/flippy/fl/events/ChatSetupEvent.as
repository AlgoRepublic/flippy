package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class ChatSetupEvent extends CairngormEvent
	{
		public static const SETUP:String = "flippy.ChatSetup";
		
		public var sessionId:int;		
		public var userName:String;		
		public var city:String;
		
		public function ChatSetupEvent(sessionId:int, userName:String, city:String)
		{
			super(SETUP);
			this.sessionId = sessionId;
			this.userName = userName;			
			this.city = city;
		}
		
		override public function clone():Event {
            return new ChatSetupEvent(sessionId,userName,city);
        }
		
	}
}