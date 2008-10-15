package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.ModifyRoomEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	import mx.core.Application;
	
	public class ModifyRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		public function ModifyRoomCommand()
		{
		}
		
		public function execute(event:CairngormEvent):void
		{
			
			var evt:ModifyRoomEvent = event as ModifyRoomEvent;
			model.logger.logMessage("Modifiying room (" + evt.room.id + ", " + evt.room.name + ")", "ModifyRoomCommand");
			model.main.roomFormTitle = "Modify Title";
			model.main.roomToEdit = evt.room;
			model.main.roomName = evt.room.name;
			model.main.roomLearningAgeSelectedIndex = evt.room.learningAge - 1;
			model.main.roomDescription = evt.room.description;
			model.main.roomManagementScreenState = model.main.ROOMMANAGEMENT_ROOM_FORM;
		}
	}
}