package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class QuestionSubmitEvent extends CairngormEvent
	{
		public static const SUBMIT_QUESTION:String = "flippy.questionSubmit";
		
		public var userName:String;		
		public var sessionId:int;
		public var role:String;
		public var question:String;
		
		public function QuestionSubmitEvent(sessionId:int, userName:String, question:String, role:String)
		{
			super(SUBMIT_QUESTION);
			this.sessionId = sessionId;
			this.userName = userName;						
			this.question = question;
			this.role = role;
		}
		
		override public function clone():Event {
            return new QuestionSubmitEvent(sessionId,userName,question,role);
        }
		
	}
}