package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CancelSaveRoomEvent extends CairngormEvent
	{
		public static var CANCEL_SAVE_ROOM:String = "flippy.cancelSaveRoom";
		public function CancelSaveRoomEvent()
		{
			super(CANCEL_SAVE_ROOM);
		}

	}
}