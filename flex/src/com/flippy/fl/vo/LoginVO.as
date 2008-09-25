package com.flippy.fl.vo
{
	
	public class LoginVO
	{
		public var userName:String;
		public var password:String;
		public var role:String;
		
		public function LoginVO (aUserName:String, aPassword:String, aRole:String)
		{
			userName = aUserName;
			password = aPassword;
			role = aRole;
		}
		
		public function toString():String {
			return "u="+userName+";p="+password+";role="+role;
		}

	}
	
}