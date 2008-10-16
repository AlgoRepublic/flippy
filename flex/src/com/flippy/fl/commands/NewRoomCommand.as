package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.NewRoomEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	public class NewRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		public function NewRoomCommand()
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			model.logger.logMessage("New room", "NewRoomCommand");
			var evt:NewRoomEvent = event as NewRoomEvent;
			model.main.roomFormTitle = "New Room";
			model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_FORM;
		}
	}
}