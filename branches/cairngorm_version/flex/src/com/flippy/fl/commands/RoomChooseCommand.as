package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import com.flippy.fl.commands.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;

	public class RoomChooseCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();				
		
		public function RoomChooseCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			model.logger.logMessage("About to execute", "RoomChooseCommand");
			
			var chooseEvent:RoomChooseEvent = RoomChooseEvent (event);
			
			model.logger.logMessage("sessionId: " + chooseEvent.sessionId, "RoomChooseCommand");
			
			model.main.sessionId = chooseEvent.sessionId;
			model.main.mainScreenState = model.main.MAIN_CONFERENCE_SCREEN;
						
		}				
		
	}
}