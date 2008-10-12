package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class ModifyRoomEvent extends CairngormEvent
	{
		public static var MODIFY_ROOM:String = "flippy.modifyRoom";
		public var room:Object;
		
		public function ModifyRoomEvent(room:Object)
		{
			super(MODIFY_ROOM);
			this.room = room;
		}

	}
}