package com.flippy.fl.model
{
	import com.flippy.fl.business.NetConnectionDelegate;
	import com.flippy.fl.view.ChatPanel;
	
	import flash.media.Microphone;
	import flash.net.*;
	
	import mx.collections.GroupingCollection;
		
	public class Main
	{
		
		// public vars
		public var businessNc:NetConnection;
		public var bncDelegate:NetConnectionDelegate;
		//public var RTMP_URL:String = "rtmp://202.158.39.178:1935/flippy";
		public var RTMP_URL:String = "rtmp://server.asianbrain.com:1935/flippy";
		//public var RTMP_URL:String = "rtmp://localhost:1935/flippy";
		public var IMAGE_UPLOAD_URL:String = "http://server.asianbrain.com:8182/Flimage/upload.htm";
		//public var IMAGE_UPLOAD_URL:String = "http://localhost:8080/Flimage/upload.htm";
		public var IMAGE_URL:String = "http://server.asianbrain.com:8182/Flimage/image.htm";
		//public var IMAGE_URL:String = "http://localhost:8080/Flimage/image.htm";
		
		/**
		* Flag to check if there's a connection with the RTMP server.
		*/		
		[Bindable]	
		public var bncConnected : Boolean;	
		public var streamNc:NetConnection; 
		
		// credential model
		[Bindable]	
		public var sessionId:int;
		[Bindable]	
		public var role:String;
		[Bindable]	
		public var userName:String;
		[Bindable]	
		public var password:String;
		[Bindable]
		public var learningAge:int;
		[Bindable]
		public var city:String;
		
		// view state
		[Bindable]
		public var mainScreenState:uint = MAIN_WAIT_SCREEN;
		[Bindable]
		public var authorScreenState:uint = AUTHOR_ROOM_SELECTION;
		[Bindable]
		public var roomManagementScreenState:uint = ROOMMANAGEMENT_ROOM_LIST;
		
		// const
		public var MAIN_LOGIN_SCREEN:uint = 0;
		public var MAIN_ROOM_SCREEN:uint = 1;
		public var MAIN_CONFERENCE_SCREEN:uint = 2;
		public var MAIN_AUTHOR_SCREEN:uint = 3;
		public var MAIN_WAIT_SCREEN:uint = 4;
		
		public var AUTHOR_ROOM_SELECTION:uint = 0;
		public var AUTHOR_ROOM_MANAGEMENT:uint = 1;
		
		public var ROOMMANAGEMENT_ROOM_LIST:uint = 0;
		public var ROOMMANAGEMENT_ROOM_FORM:uint = 1;
		
		public var ROLE_AUTHOR:String = "author";
		public var ROLE_MEMBER:String = "member";
		
		// question box state
		[Bindable]
		public var questionEnabled:Boolean = false;
		[Bindable]
		public var questionTextRSO:SharedObject = null;
		[Bindable]
		public var questionText:String = "";
		
		// room
		[Bindable]
		public var rooms:Array = new Array();
		[Bindable]
		public var roomFormTitle:String = "";
		[Bindable]
		public var roomName:String;
		[Bindable]
		public var roomDescription:String;
		[Bindable]
		public var roomLearningAgeSelectedIndex:int = -1;
		public var roomToEdit:Object;
		
		// chat
		public var chatWindows:Array = new Array();
		[Bindable]
		public var userList:GroupingCollection = new GroupingCollection();
		public var chatPanel:ChatPanel;
		[Bindable]
		public var userListRSO:SharedObject = null;
		
		// audio chat		
		[Bindable]
		public var audioChatStarted:Boolean = false;
		public var audioStream:NetStream;
		public var microphone:Microphone;
		
		// state RSO
		public var stateRSO:SharedObject = null;
		[Bindable]
		public var publicChatEnabled:Boolean = true;		
		
		
		public function Main()
		{
		}

	}
}
