package components
{
	public class LoginInfo
	{
		public var userName:String;
		public var password:String;
		public var rememberMe:Boolean;
		
		public function LoginInfo (aUserName:String, aPassword:String, aRememberMe:Boolean)
		{
			userName = aUserName;
			password = aPassword;
			rememberMe = aRememberMe;
		}
		
		

	}
}