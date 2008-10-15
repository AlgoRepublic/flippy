package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
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
	
	import mx.rpc.IResponder;

	public class LoginCommand implements ICommand, IResponder
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		private var loginEvent:LoginEvent;		
		
		public function LoginCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			logger.logMessage("About to execute loginCommand", getQualifiedClassName(this));
			
			loginEvent = LoginEvent (event);
			
			logger.logMessage("userName: " + loginEvent.userName + "; pwd: " + loginEvent.password, getQualifiedClassName(this));
						
			new LoginDelegate(this).validate(loginEvent.userName, loginEvent.password);			
			
		}
		
		public function result(event:Object):void
		{
			logger.logMessage( "Got result in loginCommand", getQualifiedClassName(this));
			
			logger.logMessage( "result: " + event, getQualifiedClassName(this));
			
			logger.logMessage( "result.result: " + event.result, getQualifiedClassName(this));
			
			var loginVO:LoginVO = null;
			
			if (event.result != "") {
			    loginVO = new LoginVO(loginEvent.userName, loginEvent.password, event.result.roleName);
			}						
			
			if (loginVO != null) {
				
				logger.logMessage( "valid user", getQualifiedClassName(this));												
				
				model.main.userName = loginVO.userName;
				model.main.password = loginVO.password;				
				model.main.role = loginVO.role;
				
				function resultHandler(data:Object):void
				{
					model.main.rooms = data as Array;
					model.logger.logMessage("Got result as list of room: size " + model.main.rooms.length, "LoginCommand");
					
					model.main.mainScreenState = model.main.MAIN_ROOM_SCREEN; // use this for member
					//model.main.mainScreenState = model.main.MAIN_AUTHOR_SCREEN; // use this for author
					model.main.authorScreenState = model.main.AUTHOR_ROOM_SELECTION;
				}
				
				function faultHandler(info:Object):void
				{
					model.logger.logMessage("Got fault in getRoomList", getQualifiedClassName(this));
				}
				new RoomDelegate(new Responder(resultHandler, faultHandler)).getRoomList(3);
				
				// init shared object
				initRSO();
			} else {
				// animate login failed
				if (loginEvent.loginBox != null) {
					Login(loginEvent.loginBox).doInvalid("Invalid UserName or Password");
				}
			}
			
		}
		
		public function fault(event:Object):void 
		{
			logger.logMessage( "Got fault in loginCommand", getQualifiedClassName(this));
		}
		
		/** Question Shared Object */
		public function initRSO():void {
	      	// init shared object
			logger.logMessage("init so", "SetupConnectionCommand");
			
	      	var so:SharedObject = null;
	      	
	      	so = SharedObject.getRemote("com.flippy.question", model.main.businessNc.uri);
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
