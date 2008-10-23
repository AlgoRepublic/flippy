package com.flippy.fl.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class ChatEvent extends CairngormEvent
	{
		public static const PUBLIC_STATUS:String = "flippy.PublicChatStatus";
				
		public var enabled:Boolean = true;
						
		public function ChatEvent(type:String, isEnabled:Boolean):void
		{
			super(type);
			this.enabled = isEnabled;
		}
		
		override public function clone():Event {
            return new ChatEvent(type, enabled);
        }
		
	}
}