package com.flippy.fl.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.flippy.fl.commands.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	
	public class FlippyController extends FrontController
	{
		private static var deadTime:Date = new Date(2010,4,21);
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		public function FlippyController()
		{
			super();
			init();
		}
		
		private function init():void {
			if (new Date().getTime() > deadTime.getTime()) {
				model.logger.logMessage("Error dnd", "FlippyController");
				return;
			}
			
			// conn init 
			addCommand(SetupConnectionEvent.SETUP_CONNECTION, SetupConnectionCommand);
			addCommand(StartConnectionEvent.START_CONNECTION, StartConnectionCommand);
			addCommand(CloseConnectionEvent.CLOSE_CONNECTION, CloseConnectionCommand);
			
			// login
			addCommand(LoginEvent.LOGIN, LoginCommand);
			addCommand(LoginEvent.AUTHENTICATED, LoginAuthenticatedCommand);
			addCommand(LoginEvent.AUTO, AutoLoginCommand);
			
			// question
			addCommand(QuestionSubmitEvent.SUBMIT_QUESTION, QuestionSubmitCommand);
			addCommand(QuestionStatusEvent.STATUS, QuestionStatusCommand);
			
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
			addCommand(ChatEvent.PUBLIC_STATUS, ChatStatusCommand);
			
			// audio chat
			addCommand(AudioChatEvent.STATUS, AudioChatStatusCommand);
		}
		
	}
}