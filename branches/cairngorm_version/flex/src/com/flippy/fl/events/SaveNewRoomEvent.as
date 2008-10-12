package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class SaveNewRoomEvent extends CairngormEvent
	{
		public static var SAVE_NEW_ROOM:String = "flippy.saveNewRoom";
		
		public var resultHandler:Function;
		public var roomName:String;
		public var learningAge:int;
		public var roomDescription:String;
		
		public function SaveNewRoomEvent(resultHandler:Function, roomName:String, learningAge:int, roomDescription:String)
		{
			super(SAVE_NEW_ROOM);
			this.resultHandler = resultHandler;
			this.roomName = roomName;
			this.learningAge = learningAge;
			this.roomDescription = roomDescription;
		}

	}
}