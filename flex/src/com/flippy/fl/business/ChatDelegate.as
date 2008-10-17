package com.flippy.fl.business
{
	import com.flippy.fl.model.FlippyModelLocator;
	
	import flash.net.Responder;
	
	
	
	public class ChatDelegate
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		private var responder:Responder;
		
		public function ChatDelegate(responder:Responder):void
		{
			this.responder = responder;
		}
		
		public function login(sessionId:int, userName:String, city:String):void
		{
			model.logger.logMessage("login to chat room", this);
			model.main.businessNc.call("chat.login", responder, sessionId, userName, city);
		}
		
		public function broadcast(sessionId:int, userName:String, msg:String, date:Date):void {
			model.main.businessNc.call("chat.broadcast", responder, sessionId, userName, msg, date);
		}
		
		public function sendMessage(sessionId:int, userName:String, destUserName:String, msg:String, date:Date):void {
			model.main.businessNc.call("chat.sendMessage", responder, sessionId, userName, destUserName, msg, date);
		}
	}
	
	
}