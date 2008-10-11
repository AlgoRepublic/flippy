package com.flippy.fl.business
{
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
			model.logger.logMessage("Getting room list with learningAge " + learningAge, "RoomDelegate");
			model.main.businessNc.call("getRoomsWithRequiredLearningAge", responder, learningAge);
		}
	}
	
	
}