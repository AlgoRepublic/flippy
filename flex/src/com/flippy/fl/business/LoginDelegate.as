package com.flippy.fl.business
{
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Main;
	
	import flash.net.Responder;
	
	public class LoginDelegate
	{
		private var responder:Responder;
		private var service:Object;
		
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();
		private var main:Main = model.main;
		
		public function LoginDelegate(responder:Responder):void
		{
			this.responder = responder;
		}
		
		public function validate(userName:String, password:String):void 
		{
			main.businessNc.call("login.login", responder, userName, password);
		}
				
	}
}