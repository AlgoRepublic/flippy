﻿package com.flippy.fl.events{	/**	 */	 	import com.adobe.cairngorm.control.CairngormEvent;		/**	 * @author Hendra	 */		public class StartConnectionEvent extends CairngormEvent 	{				public static var START_CONNECTION:String = "flippy.startConnection";				public var uri:String;				/**		 * 		 */				public function StartConnectionEvent(uri:String):void		{			super( START_CONNECTION );			this.uri = uri;		}	}}