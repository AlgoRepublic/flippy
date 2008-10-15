package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.SaveNewRoomEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	import flash.net.Responder;
	
	public class SaveNewRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		public function SaveNewRoomCommand()
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			var evt:SaveNewRoomEvent = event as SaveNewRoomEvent;
			
			function roomsResultHandler(data:Object):void
			{
				model.main.rooms = data as Array;
				model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_LIST;
				evt.resultHandler(true);
			}
			
			function statusHandler(info:Object):void
			{
				model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_LIST;
				evt.resultHandler(false);
			}
			
			model.main.businessNc.call("createRoom", new Responder(roomsResultHandler, statusHandler), evt.roomName, evt.learningAge, evt.roomDescription);
		}
	}
}