package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class ChatBroadcastEvent extends CairngormEvent
	{
		public static const BROADCAST:String = "flippy.ChatBroadcast";
		
		public var sessionId:int;		
		public var userName:String;		
		public var msg:String;
		public var date:Date;
		
		public function ChatBroadcastEvent(sessionId:int, userName:String, msg:String, date:Date)
		{
			super(BROADCAST);
			this.sessionId = sessionId;
			this.userName = userName;			
			this.msg = msg;
			this.date = date;
		}
		
		override public function clone():Event {
            return new ChatBroadcastEvent(sessionId,userName,msg,date);
        }
		
	}
}