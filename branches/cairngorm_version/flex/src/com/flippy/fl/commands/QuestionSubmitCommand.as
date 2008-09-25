package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;
	
	import com.flippy.fl.business.*;	
	import com.flippy.fl.commands.*;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.*;
	
	public class QuestionSubmitCommand implements ICommand, IResponder
	{		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		private var qvent:QuestionSubmitEvent;
		
		public function QuestionSubmitCommand()
		{
		}

		public function execute(event:CairngormEvent):void
		{
			model.logger.logMessage("About to execute QuestionSubmitCommand", "QuestionSubmitCommand");
			
			this.qvent = QuestionSubmitEvent (event);
			
			model.logger.logMessage("username: " + qvent.userName + "; sessionId: " + qvent.sessionId + "; role:" + qvent.role + "; q:" + qvent.question, "QuestionSubmitCommand");
				
			
			// update question text
			model.main.questionText += "<b>"+qvent.userName+": </b>" + qvent.question + "<br/>";
			// log question
			new QuestionDelegate(this).submit(qvent.sessionId, qvent.userName, qvent.question);
			
		}
		
		public function result(event:Object):void
		{
			model.logger.logMessage( "Got result", "SubmitQuestionCommand");
			
			model.logger.logMessage( "result: " + event, "SubmitQuestionCommand");
			
			model.logger.logMessage( "result.result: " + event.result, "SubmitQuestionCommand");
									
			if (event.result == "ok") {
			    // success
				model.logger.logMessage( "Success logging SubmittedQuestion", "SubmitQuestionCommand");
			} else {
				model.logger.logMessage( "Failed logging SubmittedQuestion", "SubmitQuestionCommand");
			}			
			
		}
		
		public function fault(event:Object):void 
		{
			model.logger.logMessage( "Got fault " + event, "SubmitQuestionCommand");
		}
		
	}
}