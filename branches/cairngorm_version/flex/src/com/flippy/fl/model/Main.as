package com.flippy.fl.model
{
	import flash.net.NetConnection;
	
	import com.flippy.fl.business.NetConnectionDelegate;
		
	public class Main
	{
		
		// public vars
		public var businessNc:NetConnection;
		public var bncDelegate:NetConnectionDelegate;
		
		[Bindable]	
		/**
		* Flag to check if there's a connection with the RTMP server.
		*/		
		[Bindable]	
		public var bncConnected : Boolean;	
		public var streamNc:NetConnection; 
		
		// credential model
		[Bindable]	
		public var sessionId:String;
		[Bindable]	
		public var role:String;
		[Bindable]	
		public var userName:String;
		[Bindable]	
		public var password:String;
		
		// view state
		[Bindable]	
		public var mainScreenState:uint = MAIN_LOGIN_SCREEN;
		
		// const
		public var MAIN_LOGIN_SCREEN:uint = 0;
		public var MAIN_ROOM_SCREEN:uint = 1;
		public var MAIN_CONFERENCE_SCREEN:uint = 2;
		
		public var ROLE_AUTHOR:String = "author";
		public var ROLE_MEMBER:String = "member";
		
		// question box state
		[Bindable]
		public var enableQuestionBox:Boolean = true;
		[Bindable]
		public var questionText:String = "";
		
		public function Main()
		{
		}

	}
}