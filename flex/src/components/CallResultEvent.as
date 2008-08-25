package components
{
	import flash.events.Event;
	
	public class CallResultEvent extends Event {
		
		public static const RESULT_RECEIVED:String = "result_received";
		
		public var sessionId:String;
		public var from:String;
		public var method:String;
		public var code:int;
		public var topic:String;
		public var message:String;
		
		public function CallResultEvent(type:String, sessionId:String, method:String, from:String, code:int, topic:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			
			this.sessionId = sessionId;
			this.from = from;
			this.code = code;
			this.topic = topic;
			this.message = message;
			this.method = method;
		}
		
		override public function clone():Event {
			return new CallResultEvent(type, sessionId, method, from, code, topic, message, bubbles, cancelable);
		}
	}
}