package components
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class Chat extends EventDispatcher
	{
		
		public var serverURL:String;
		public var sessionId:String;
		public var from:String;
		
		private var nc:NetConnection;
		private var res:Responder = new Responder(onResult);
				
		
		public function Chat(sessionId:String, from:String, serverURL:String)
		{
			this.serverURL = serverURL;
			this.sessionId = sessionId;
			this.from = from;
			
			initConnection();
		}
		
		private function initConnection():void {
			if (nc != null && !nc.connected) {
				nc.close();
				nc = null
			}
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			
			nc.client = this;
			nc.connect(serverURL);
		}

		// --------------- client RPC
		public function sendChatRequest(sendTo:String, topic:String, message:String):void {
			
			if (nc != null && nc.connected) {
				nc.call("sendChatRequest", res, sessionId, topic, from, message, sendTo);
			} else {
				trace("NC error on sendingchatrequest");
			}
		}
		
		public function publish(topic:String, sendTo:String, message:String):void {
			nc.call("publish", res, sessionId, topic, from, message, sendTo);
		}
		
		public function subscribe(topic:String):void {
			nc.call("subscribe", res, sessionId, topic, from);
		}
		
		public function onStatus(event:NetStatusEvent):void {
			if (event.info.code == "NetConnection.Connect.Success") {
				// subscribe
				//subscribe(defaultTopic);
				trace("Connect success");
			} else {
				trace("Connect failed: " + event.info.code);
			}
		}
		
		public function onResult(ret:Object):void {
			trace("got result from server: " + String(ret));
		}
		
		// ------------- SERVER CALL
		public function onMessage (from:String, sendTo:String, topic:String, msg:String):String {
			if (hasEventListener(MessageEvent.MESSAGE_RECEIVED)) {
				var msgEvt:MessageEvent = new MessageEvent(MessageEvent.MESSAGE_RECEIVED, sessionId, from, sendTo, topic, msg);
				dispatchEvent(msgEvt);
			}
			return msg + " successfully received";
		}
		
		public function onChatRequest(from:String, topic:String, msg:String):String {
			var msg:String = from + ": " + msg + "\r\n";
			if (hasEventListener(MessageEvent.CHAT_REQUEST)) {
				var msgEvt:MessageEvent = new MessageEvent(MessageEvent.CHAT_REQUEST, sessionId, from, this.from, topic, msg);
				dispatchEvent(msgEvt);
			}
			return msg + " chat request successfully received";
		}
		
	}
}