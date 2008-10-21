package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.business.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.*;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.IResponder;
	
	public class QuestionSubmitCommand implements ICommand, IResponder
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		private var logger:Logger = model.logger;
		private var qvent:QuestionSubmitEvent;
		
		public function QuestionSubmitCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			logger.logMessage("About to execute QuestionSubmitCommand", "QuestionSubmitCommand");
			
			this.qvent = QuestionSubmitEvent (event);
			
			logger.logMessage("username: " + qvent.userName + "; sessionId: " + qvent.sessionId + "; role:" + qvent.role + "; q:" + qvent.question, getQualifiedClassName(this));
				
			
			// update shared object
			if (model.main.questionTextRSO != null) {
				var date:String = logger.iso(new Date());
				var formattedQuestion:String = "<b>"+qvent.userName+" ("+date+"): </b>" + qvent.question + "<br/>";
				model.main.questionTextRSO.setProperty("questionText", formattedQuestion);
				
				// member does not listen onSync event of the shared object
				// so we manually update the question text here
				if (model.main.role == model.main.ROLE_MEMBER) {
					// update question text
					model.main.questionText += formattedQuestion;
				}
			} else {
				logger.logMessage("ERROR: null questionTextRSO", getQualifiedClassName(this));
			}
			
			// log question
			new QuestionDelegate(this).submit(String(qvent.sessionId), qvent.userName, qvent.question);
			
		}
		
		public function result(event:Object):void
		{
			logger.logMessage( "Got result", "SubmitQuestionCommand");
			
			logger.logMessage( "result: " + event, "SubmitQuestionCommand");
			
			logger.logMessage( "result.result: " + event.result, "SubmitQuestionCommand");
									
			if (event.result == "ok") {
			    // success
				logger.logMessage( "Success logging SubmittedQuestion", "SubmitQuestionCommand");
			} else {
				logger.logMessage( "Failed logging SubmittedQuestion", "SubmitQuestionCommand");
			}			
			
		}
		
		public function fault(event:Object):void 
		{
			logger.logMessage( "Got fault " + event, "SubmitQuestionCommand");
		}
		
	}
}