package com.flippy.fl.control
{
	import com.adobe.cairngorm.control.FrontController;
	
	import com.flippy.fl.commands.*;	
	import com.flippy.fl.events.*;
	
	public class FlippyController extends FrontController
	{
		public function FlippyController()
		{
			super();
			init();
		}
		
		private function init():void {
			
			// conn init 
			addCommand(SetupConnectionEvent.SETUP_CONNECTION, SetupConnectionCommand);
			addCommand(StartConnectionEvent.START_CONNECTION, StartConnectionCommand);
			addCommand(CloseConnectionEvent.CLOSE_CONNECTION, CloseConnectionCommand);
			
			// login
			addCommand(LoginEvent.LOGIN, LoginCommand);
			
			// question
			addCommand(QuestionSubmitEvent.SUBMIT_QUESTION, QuestionSubmitCommand);
			
			// room
			addCommand(RoomChooseEvent.CHOOSE, RoomChooseCommand);
		}
		
	}
}