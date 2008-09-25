package com.flippy.fl.view
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
		public var defaultTopic:String;
		
		private var nc:NetConnection;
		private var res:Responder = new Responder(onResult);
				
		public static const CALL_PUBLISH:String = "chat.publish";
		public static const CALL_SUBSCRIBE:String = "chat.subscribe";
		public static const CALL_UNSUBSCRIBE:String = "chat.unSubscribe";
		public static const CALL_SENDCHATREQ:String = "chat.sendChatRequest";
		public static const CALL_DISABLE_TOPIC:String = "chat.disableTopic";
		
		public function Chat(sessionId:String, from:String, serverURL:String, defaultTopic:String)
		{
			this.serverURL = serverURL;
			this.sessionId = sessionId;
			this.from = from;
			this.defaultTopic = defaultTopic;
			
			initConnection();
		}
		
		private function initConnection():void {
			
			trace("Initializing connection to: " + serverURL);
			
			if (nc != null && !nc.connected) {
				nc.close();
				nc = null
			}
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			
			nc.client = this;
			nc.connect(serverURL);
			
			// subscribe to default topic
			// subscribe(sessionId+".public");
		}

		// --------------- client RPC
		public function sendChatRequest(sendTo:String, topic:String, message:String):void {
			
			if (nc != null && nc.connected) {
				nc.call(CALL_SENDCHATREQ, res, sessionId, topic, from, message, sendTo);
			} else {
				trace("NC error on sendingchatrequest to: " + sendTo);
			}
		}
		
		public function publish(topic:String, sendTo:String, message:String):void {
			if (nc != null && nc.connected) {
				nc.call(CALL_PUBLISH, res, sessionId, topic, from, message, sendTo);
			} else {
				trace("NC error on publish to: " + topic);
			}
		}
		
		public function subscribe(topic:String):void {
			if (nc != null && nc.connected) {
				trace("subscribing to: " + topic);
				nc.call(CALL_SUBSCRIBE, res, sessionId, topic, from);
			} else {
				trace("NC error on subscribe to: " + topic);
			}
		}
		
		public function unsubscribe(topic:String):void {
			if (nc != null && nc.connected) {
				trace("unsubscribing to: " + topic);
				nc.call(CALL_UNSUBSCRIBE, res, sessionId, topic, from);
			} else {
				trace("NC error on unsubscribe to: " + topic);
			}
		}
		
		public function disableTopic(topic:String, message:String):void {
			if (nc != null && nc.connected) {
				nc.call(CALL_DISABLE_TOPIC, res, sessionId, topic, from, true, message);
			} else {
				trace("NC error on disable topic");
			}
		}
		
		public function enableTopic(topic:String, message:String):void {
			if (nc != null && nc.connected) {
				nc.call(CALL_DISABLE_TOPIC, res, sessionId, topic, from, false, message);
			} else {
				trace("NC error on enable topic");
			}
		}
		
		public function onStatus(event:NetStatusEvent):void {
			if (event.info.code == "NetConnection.Connect.Success") {
				// subscribe
				//subscribe(defaultTopic);
				trace("Connect success");
				
				if (defaultTopic != null) {
					subscribe(defaultTopic);
				}
				
			} else {
				trace("Connect failed: " + event.info.code);
			}
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
		
		public function onResult(ret:Object):void {
			trace("got result from server: " + String(ret));
			if (hasEventListener(CallResultEvent.RESULT_RECEIVED)) {
				var res:Array = splitResultString(String(ret));
				trace("result: " + res);
				var resEvt:CallResultEvent = new CallResultEvent(CallResultEvent.RESULT_RECEIVED, sessionId, res["method"], from, res["code"], res["topic"], res["message"]);
				dispatchEvent(resEvt);
			}
		}
		
		
		// --------------- Helper
		public function splitResultString(str:String):Array {
			// errorcode:topic:method:errormessage
			var tokens:Array = str.split(":");
			if (tokens.length == 4) {
				tokens["code"] = tokens[0];
				tokens["topic"] = tokens[1];
				tokens["method"] = tokens[2];
				tokens["message"] = tokens[3];
			} else {
				trace("invalid result string");
			}
			return tokens;
		}
	}
}