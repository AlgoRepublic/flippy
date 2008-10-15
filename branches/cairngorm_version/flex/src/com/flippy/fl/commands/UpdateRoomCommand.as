package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.UpdateRoomEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	import flash.net.Responder;
	
	public class UpdateRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		public function UpdateRoomCommand()
		{
		}
		
		
		public function execute(event:CairngormEvent):void
		{
			var evt:UpdateRoomEvent = event as UpdateRoomEvent;
			function roomsResultHandler(data:Object):void
			{
				model.logger.logMessage("Getting result ok when update room", "UpdateRoomCommand");
				model.main.rooms = data as Array;
				model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_LIST;
				evt.resultHandler(true);
			}
			
			function statusHandler(info:Object):void
			{
				model.logger.logMessage("Getting result nok when update room", "UpdateRoomCommand");
				model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_LIST;
				evt.resultHandler(false);
			}
			model.logger.logMessage("Updating room", "UpdateRoomCommand");
			model.main.businessNc.call("updateRoom", new Responder(roomsResultHandler, statusHandler), evt.roomId, evt.roomName, evt.learningAge, evt.roomDescription);
		}
	}
}