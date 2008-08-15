package components
{
	import flash.events.Event;
	
	public class LoginEvent extends Event {
		
		public var loginInfo:LoginInfo;
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, loginInfo:LoginInfo=null) {
			super(type, bubbles, cancelable);
			
			this.loginInfo = loginInfo;
		}
		
		override public function clone():Event {
			return new LoginEvent(type, bubbles, cancelable, loginInfo);
		}
	}
}