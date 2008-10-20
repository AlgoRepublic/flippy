package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class AudioChatEvent extends CairngormEvent
	{
		public static const STATUS:String = "flippy.AudioChatEvent";
				
		public var started:Boolean = true;
				
		public function AudioChatEvent(started:Boolean):void
		{
			super(STATUS);
			this.started = started;
		}
		
		override public function clone():Event {
            return new AudioChatEvent(started);
        }
		
	}
}