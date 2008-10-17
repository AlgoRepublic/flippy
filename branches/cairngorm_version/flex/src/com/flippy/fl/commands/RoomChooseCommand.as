package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.*;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import com.flippy.fl.commands.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;

	public class RoomChooseCommand extends SequenceCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();				
		
		public function RoomChooseCommand()
		{
		}

		override public function execute(event:CairngormEvent):void
		{
			model.logger.logMessage("About to execute", "RoomChooseCommand");
			
			var chooseEvent:RoomChooseEvent = RoomChooseEvent (event);
			
			model.logger.logMessage("sessionId: " + chooseEvent.sessionId, "RoomChooseCommand");
			
			model.main.sessionId = chooseEvent.sessionId;
			
			// init chat here
			nextEvent = new ChatSetupEvent(model.main.sessionId, model.main.userName, model.main.city);
			this.executeNextCommand();
			
		}	
		
		
		
	}
}