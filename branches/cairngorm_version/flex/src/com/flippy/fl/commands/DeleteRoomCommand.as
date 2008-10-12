package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.DeleteRoomEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	import flash.net.Responder;
	
	public class DeleteRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		public function DeleteRoomCommand()
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			var evt:DeleteRoomEvent = event as DeleteRoomEvent;
			function roomsResultHandler(data:Object):void
			{
				model.main.rooms = data as Array;
			}
			
			function statusHandler(info:Object):void
			{
				
			}
			model.main.businessNc.call("deleteRoom", new Responder(roomsResultHandler, statusHandler), evt.room.id);
		}
	}
}