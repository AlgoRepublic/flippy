package com.flippy.fl.business
{
	import com.flippy.fl.vo.SessionInfoVO;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class SessionDelegate
	{
		private var sessionId:String;
		
		public function SessionDelegate(sessionId:String)
		{
			this.sessionId = sessionId;
		}
		public function getInfo(result:Function, fault:Function):void
		{
			var loader:URLLoader = new URLLoader()
			var request:URLRequest = new URLRequest("http://localhost:8080/glippy/session/info");
			var variables:URLVariables = new URLVariables();
			variables.sessionId = sessionId;
			request.data = variables;
			
			function handleComplete(event:Event):void
			{
				trace("Comppleted: " + loader.data);
				var xmlObj:XML = XML(loader.data);
				if (xmlObj.session != undefined)
				{
					trace("Result found");
					var sessionObj:Object = xmlObj.session[0].user;
					var sessionVo:SessionInfoVO = new SessionInfoVO(sessionObj.@id, 
												sessionObj.@type, sessionObj.@learningAge, 
												sessionObj.@city);
					result(sessionVo);
				}
				else
				{
					trace("Exception found");
					fault(xmlObj.msg);
				}
			}
			
			loader.addEventListener(Event.COMPLETE, handleComplete);
			trace("Loading session info for " + sessionId);
			loader.load(request);
		}
	}
}