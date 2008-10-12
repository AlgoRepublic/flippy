package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class NewRoomEvent extends CairngormEvent
	{
		public static var NEW_ROOM:String = "flippy.newRoom";
		public var room:Object;
		
		public function NewRoomEvent(room:Object)
		{
			super(NEW_ROOM);
			this.room = room;
		}

	}
}