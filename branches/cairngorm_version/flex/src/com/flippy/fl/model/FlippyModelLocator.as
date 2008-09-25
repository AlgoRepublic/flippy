package com.flippy.fl.model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.model.IModelLocator;	

	[Bindable]
	public class FlippyModelLocator implements IModelLocator
	{
		
		private static var instance:FlippyModelLocator;
				
		public var main:Main;		
		public var logger:Logger;
		
		public function FlippyModelLocator()
		{
			if (instance != null) {
					throw new CairngormError(
					   CairngormMessageCodes.SINGLETON_EXCEPTION, "ModelLocator" );
			} else {
				main = new Main();
				logger = new Logger();
			}
		}
		
		public static function getInstance():FlippyModelLocator {
			if (instance != null) {
				return instance;
			} else {
				instance = new FlippyModelLocator();
				return instance;
			}
		}

	}
	
}