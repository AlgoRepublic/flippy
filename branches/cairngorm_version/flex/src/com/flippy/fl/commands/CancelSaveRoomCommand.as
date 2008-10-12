package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	public class CancelSaveRoomCommand implements ICommand
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		public function CancelSaveRoomCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			model.main.roomToEdit = null;
			model.main.roomName = "";
			model.main.roomLearningAgeSelectedIndex = -1;
			model.main.roomDescription = "";
			model.main.mainScreenState = model.main.MAIN_ROOM_LIST;
		}
	}
}