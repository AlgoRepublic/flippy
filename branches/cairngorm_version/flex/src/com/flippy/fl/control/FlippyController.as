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
			addCommand(NewRoomEvent.NEW_ROOM, NewRoomCommand);
			addCommand(SaveNewRoomEvent.SAVE_NEW_ROOM, SaveNewRoomCommand);
			addCommand(UpdateRoomEvent.UPDATE_ROOM, UpdateRoomCommand);
			addCommand(ModifyRoomEvent.MODIFY_ROOM, ModifyRoomCommand);
			addCommand(DeleteRoomEvent.DELETE_ROOM, DeleteRoomCommand);
			addCommand(CancelSaveRoomEvent.CANCEL_SAVE_ROOM, CancelSaveRoomCommand);
			
			// chat
			addCommand(ChatSetupEvent.SETUP, ChatSetupCommand);
			addCommand(ChatBroadcastEvent.BROADCAST, ChatBroadcastCommand);
			addCommand(ChatSendMessageEvent.SEND_MSG, ChatSendMessageCommand);
			
		}
		
	}
}