package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.ChatDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	
	import flash.net.Responder;

	public class ChatSendMessageCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		
		public function ChatSendMessageCommand():void
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			var ce:ChatSendMessageEvent = event as ChatSendMessageEvent;
			
			new ChatDelegate(new Responder(onResult, onFault)).sendMessage(ce.sessionId, ce.userName, ce.destUserName, ce.msg, ce.date); 			
		}
		
		/**************** RESPONDERs ******************/
		public function onResult(data:Object):void {
			logger.logMessage("Incoming result: " + data, this);			
		}
		
		public function onFault(data:Object):void {
			logger.logMessage("got fault: " + data, this);
		}
		
	}
}
