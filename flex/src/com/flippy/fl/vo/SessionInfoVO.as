package com.flippy.fl.vo
{
	public class SessionInfoVO
	{
		private var _username:String;
		private var _type:String;
		private var _learningAge:int;
		private var _city:String;
		
		public function SessionInfoVO(username:String, type:String, learningAge:int, city:String)
		{
			_username = username;
			_type = type;
			_learningAge = learningAge;
			_city = city;
		}
		
		public function get username():String
		{
			return _username;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get learningAge():int
		{
			return _learningAge;
		}
		
		public function get city():String
		{
			return _city;
		}
	}
}