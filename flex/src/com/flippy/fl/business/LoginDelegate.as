package com.flippy.fl.business
{
	import flash.net.Responder;
	
	import mx.rpc.IResponder;
	
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Main;
	
	public class LoginDelegate
	{
		private var responder:IResponder;
		private var service:Object;
		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		private var main:Main = model.main;
		
		public function LoginDelegate(responder:IResponder):void
		{
			this.responder = responder;
		}
		
		public function validate(userName:String, password:String):void 
		{
			var respWrapper:Responder = new Responder(onResult, onStatus);
			main.businessNc.call("login", respWrapper, userName, password);
		}
		
		/*********************
		 * RESPONDER WRAPPER 		 
		 *********************/
		
		private function onResult(object:Object):void {
			var obj:Object = new Object();
			obj.result = object;
			responder.result(obj);
		}

		private function onStatus(object:Object):void {			
			responder.fault(object);
		}
	}
}