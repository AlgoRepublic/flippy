package com.flippy.fl.model
{
	
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Logger 
	{
				
		
		[Bindable]
		/**
		 * Flash Player version number inc. debugger flag.
		*/		
		public var flashVersion : String;
		
		[Bindable]
		/**
		 * Log text displayed in the TextArea.
		*/		
		public var statusText : String = "";
				
		
		/**
		* 
		*/		
		public const infoMessage : String = "Info";

		/**
		* 
		*/		
		public const serverMessage : String = "NetConnection";
		
		/**
		* 
		*/		
		public const audioMessage : String = "Audio";
		
		/**
		* 
		*/		
		public const videoMessage : String = "Video";
		
		/**
		* 
		*/		
		public const debugMessage : String = "Debug";
		
		/**
		* 
		*/		
		public const streamMessage : String = "NetStream";
				
		/**
		 * 
		 * @param env
		 * @return 
		 */			
		public function Logger()
		{
			var platformVersion : String = Capabilities.version.substr( String( Capabilities.version ).lastIndexOf(" ") + 1 );
			var manufacturer : String = Capabilities.manufacturer;
			// Get Flash Player version info.
			flashVersion = "Using " + manufacturer + " Flash Player " + platformVersion;
			//
			if ( Capabilities.isDebugger ) 
			{
				// Add debugger info.
				flashVersion += " (Debugger)";
			}
			// Display Flash Player version.
			logMessage( flashVersion, infoMessage );
		}
		
		/**
		 * 
		 * @param msg Status message to display.
		 * @param msgType Status message type.
		 */		
		public function logMessage( msg : String, 
									loggerName : String ) : void 
		{			
			var statusMessage : String = iso( new Date() ) + " - " + "["+loggerName+"] " + msg;
			//
			statusText += statusMessage + "<br>";			
		}					
		
		/**
		 * 
		 * @param value
		 * @return 
		 */		
		private function doubleDigits( value : Number ) : String 
		{
			if ( value > 9 ) 
			{
				return String( value );
			} 
			else 
			{ 
				return "0" + value;
			}
		}
		
		/**
		 * 
		 * @param value
		 * @return 
		 */		
		private function tripleDigits( value : Number ) : String 
		{
			var newStr : String = "";
			if ( value > 9 && value < 100 ) 
			{
				newStr = String( value ) + "0";
			} 
			else 
			{ 
				newStr = String( value ) + "00";
			}
			return newStr.substr( 0, 3 );
		}
		
		/**
		 * 
		 * @param date
		 * @return 
		 */		
		public function iso( date : Date ) : String 
		{
			return  doubleDigits( date.getFullYear() )
					+ "/"
					+ doubleDigits( date.getMonth() )
					+ "/"
					+ doubleDigits( date.getDate() )
					+ " "
					+ doubleDigits( date.getHours() )
					+ ":"
					+ doubleDigits( date.getMinutes() )
					+ ":"
					+ doubleDigits( date.getSeconds() )
					+ "."
					+ tripleDigits( date.getMilliseconds() );
		}			
		
	}
	
}