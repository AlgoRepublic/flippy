package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class DeleteRoomEvent extends CairngormEvent
	{
		public static var DELETE_ROOM:String = "flippy.deleteRoom";
		
		public var room:Object;
		public function DeleteRoomEvent(room:Object)
		{
			super(DELETE_ROOM);
			this.room = room;
		}

	}
}