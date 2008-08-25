package components
{
	import flash.events.Event;
	
	public class MessageEvent extends Event {
		
		public static const MESSAGE_RECEIVED:String = "message_received";
		public static const CHAT_REQUEST:String = "chat_request";
		public static const CALL_RESULT:String = "call_result";
		
		public var sessionId:String;
		public var from:String;
		public var sendTo:String;
		public var topic:String;
		public var message:String;
		
		public function MessageEvent(type:String, sessionId:String, from:String, sendTo:String, topic:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			this.sessionId = sessionId;
			this.from = from;
			this.sendTo = sendTo;
			this.topic = topic;
			this.message = message;
		}
		
		override public function clone():Event {
			return new MessageEvent(type, sessionId, from, sendTo, topic, message, bubbles, cancelable);
		}
	}
}