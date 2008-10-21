package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class QuestionStatusEvent extends CairngormEvent
	{
		public static const STATUS:String = "flippy.QuestionStatus";
				
		public var enabled:Boolean = true;
				
		public function QuestionStatusEvent(started:Boolean):void
		{
			super(STATUS);
			this.enabled = started;
		}
		
		override public function clone():Event {
            return new QuestionStatusEvent(enabled);
        }
		
	}
}