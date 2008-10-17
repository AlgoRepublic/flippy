package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class ChatSendMessageEvent extends CairngormEvent
	{
		public static const SEND_MSG:String = "flippy.ChatSendMessage";
		
		public var sessionId:int;		
		public var userName:String;		
		public var destUserName:String;
		public var msg:String;
		public var date:Date;
		
		public function ChatSendMessageEvent(sessionId:int, userName:String, destUserName:String, msg:String, date:Date)
		{
			super(SEND_MSG);
			this.sessionId = sessionId;
			this.userName = userName;		
			this.destUserName = destUserName;	
			this.msg = msg;
			this.date = date;
		}
		
		override public function clone():Event {
            return new ChatSendMessageEvent(sessionId,userName,destUserName, msg,date);
        }
		
	}
}