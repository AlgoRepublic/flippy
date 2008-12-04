package com.flippy.fl.business
{
	import com.flippy.fl.events.SetupConnectionEvent;
	import com.flippy.fl.events.StartConnectionEvent;
	import com.flippy.fl.model.FlippyModelLocator;
	
	import flash.net.Responder;
	
	
	
	public class RoomDelegate
	{
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		
		private var responder:Responder;
		
		public function RoomDelegate(responder:Responder)
		{
			this.responder = responder;
		}
		
		public function getRoomList(learningAge:int):void
		{			
			if (!model.main.bncConnected) {
				model.logger.logMessage("Opening new connection..", this);
				new SetupConnectionEvent().dispatch();
				new StartConnectionEvent(model.main.RTMP_URL).dispatch();
			}
			
			model.logger.logMessage("Getting room list with learningAge " + learningAge, "RoomDelegate");
			model.main.businessNc.call("getRoomsWithRequiredLearningAge", responder, learningAge);
		}
	}
	
	
}