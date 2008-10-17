package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.ChatDelegate;
	import com.flippy.fl.business.LoginDelegate;
	import com.flippy.fl.business.RoomDelegate;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.view.Login;
	import com.flippy.fl.vo.LoginVO;
	
	import flash.events.SyncEvent;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Grouping;
	import mx.collections.GroupingCollection;
	import mx.collections.GroupingField;
	import mx.rpc.IResponder;

	public class ChatSetupCommand implements ICommand
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function ChatSetupCommand()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			logger.logMessage( "setting up chat..", this);												
											
			// init chat room
			function cResultHandler(data:Object):void
			{
				model.logger.logMessage("Got result in Chat Room Login: " + data, this);				
				
				// init user list RSO
				initUserRSO();
				
				// init question RSO
				initRSO();
				
				model.main.mainScreenState = model.main.MAIN_CONFERENCE_SCREEN;
			}
			
			function cFaultHandler(info:Object):void
			{
				model.logger.logMessage("Got fault in Chat Room Login", this);
			}
			new ChatDelegate(new Responder(cResultHandler, cFaultHandler)).login(model.main.sessionId, model.main.userName, model.main.city);			

		}
		
		/**************** RESPONDERs ******************/
		
		/**************** SERVER CALLBACKs *************/
		public function onBroadcastMessage(sessionId:int, userName:String, msg:String, date:Date):void {
			logger.logMessage("Incoming broadcast message: " + userName + ">" + msg, this);
			model.main.chatPanel.onBroadcastMessage(sessionId, userName, msg, date);			
		}
		
		/**************** RSOs ***********************/
		public function initUserRSO():void {
			// init shared object
			logger.logMessage("init userList so", this);
			
	      	var so:SharedObject = null;
	      	so = SharedObject.getRemote(model.main.sessionId+"users", model.main.businessNc.uri);
	      	so.client = this;
	      	// only add listener for author
			so.addEventListener(SyncEvent.SYNC, userListSync);
			so.connect(model.main.businessNc);
			
			model.main.userListRSO = so;      
		}
		
		
		public function userListSync(event:SyncEvent):void {
			logger.logMessage("userListSO SYNC", this);
			
			var question:String = "";
			
			var list:GroupingCollection = model.main.userList;
			list.source = new ArrayCollection();
			
			var groupingInst:Grouping = new Grouping();
            groupingInst.fields = [new GroupingField("city")];
            list.grouping = groupingInst;
            list.refresh(false);

			
			for (var u:Object in model.main.userListRSO.data)
			{
				var userName:String = String(u);
				var city:String = String(model.main.userListRSO.data[u].city);

				var obj:Object = new Object();
				obj["userName"] = userName;
				obj["city"] = city;

				(list.source as ArrayCollection).addItem(obj);

				logger.logMessage("slotName='" + userName + "', slotValue='" + city+ "'", this);
				
			}
			
			logger.logMessage("list:"+list, this);
			
		}
		
		/** Question Shared Object */
		public function initRSO():void {
	      	// init shared object
			logger.logMessage("init so", this);
			
	      	var so:SharedObject = null;
	      	so = SharedObject.getRemote("com.flippy.question", model.main.businessNc.uri);
	      	so.client = this;
	      	// only add listener for author
	      	if (model.main.role == model.main.ROLE_AUTHOR) {
	      		logger.logMessage("author, listen to question changes", "SetupConnectionCommand");
				so.addEventListener(SyncEvent.SYNC, questionSync);
	      	} else {
	      		logger.logMessage("role: " + model.main.role, "SetupConnectionCommand");
	      	}
			so.connect(model.main.businessNc);
			
			model.main.questionTextRSO = so;      	
		}
		
		public function questionSync(event:SyncEvent):void {
			logger.logMessage("question so SYNC", "SetupConnectionCommand");
			
			if (model.main.role == model.main.ROLE_AUTHOR) {
			
				var question:String = "";
				
				if (model.main.questionTextRSO.data.questionText != undefined || model.main.questionTextRSO.data.questionText != null) {
					question = model.main.questionTextRSO.data.questionText;
				}
				
				if (question != "") {
					logger.logMessage("question so SYNC, data: " + model.main.questionTextRSO.data.questionText, "SetupConnectionCommand");
					model.main.questionText += question;
				} else {
					logger.logMessage("null/undefined SYNC data", "SetupConnectionCommand");
				}
			} else {
				// not author, can't view other question
				logger.logMessage("not author, can't view other questions", "SetupConnectionCommand");
			}
		}
		
	}
}
