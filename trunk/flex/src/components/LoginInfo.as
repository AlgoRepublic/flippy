package components
{
	
	public class LoginInfo
	{
		public var userName:String;
		public var password:String;
		public var rememberMe:Boolean;
		public var lastLogin:Date;
		
		public function LoginInfo (aUserName:String, aPassword:String, aRememberMe:Boolean)
		{
			userName = aUserName;
			password = aPassword;
			rememberMe = aRememberMe;
			lastLogin = new Date();
		}
		
		public function toString():String {
			return userName+"; "+password+"; "+rememberMe;
		}

	}
	
}