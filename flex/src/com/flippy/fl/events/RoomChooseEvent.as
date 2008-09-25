package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class RoomChooseEvent extends CairngormEvent
	{
		public static const CHOOSE:String = "flippy.roomChoose";
				
		public var sessionId:String;		
		
		public function RoomChooseEvent(sessionId:String)
		{
			super(CHOOSE);
			this.sessionId = sessionId;
		}
		
		override public function clone():Event {
            return new RoomChooseEvent(sessionId);
        }
		
	}
}