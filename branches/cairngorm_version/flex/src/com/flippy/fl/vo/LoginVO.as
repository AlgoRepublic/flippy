package com.flippy.fl.vo
{
	
	public class LoginVO
	{
		public var userName:String;
		public var password:String;
		public var role:String;
		public var city:String;
		public var learningAge:int;
		
		public function LoginVO (aUserName:String, aPassword:String, aRole:String, aCity:String, aLearingAge:int)
		{
			userName = aUserName;
			password = aPassword;
			role = aRole;
			city = aCity;
			learningAge = aLearingAge;
		}
		
		public function toString():String {
			return "u="+userName+";p="+password+";role="+role+";learningAge="+learningAge+";city="+city;
		}

	}
	
}