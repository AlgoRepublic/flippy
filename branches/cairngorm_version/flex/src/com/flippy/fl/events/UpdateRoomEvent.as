package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class UpdateRoomEvent extends CairngormEvent
	{
		public static var UPDATE_ROOM:String = "flippy.updateRoomEvent";
		
		public var resultHandler:Function;
		public var roomId:int;
		public var roomName:String;
		public var learningAge:int;
		public var roomDescription:String;
		
		public function UpdateRoomEvent(resultHandler:Function, roomId:int, roomName:String, learningAge:int, roomDescription:String)
		{
			super(UPDATE_ROOM);
			this.resultHandler = resultHandler;
			this.roomId = roomId;
			this.roomName = roomName;
			this.learningAge = learningAge;
			this.roomDescription = roomDescription;
		}

	}
}