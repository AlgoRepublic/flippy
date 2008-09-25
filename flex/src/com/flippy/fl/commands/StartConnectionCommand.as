﻿package com.flippy.fl.commands {		/**	 */	 	import com.adobe.cairngorm.commands.ICommand;	import com.adobe.cairngorm.control.CairngormEvent;		import com.flippy.fl.business.NetConnectionDelegate;	import com.flippy.fl.events.StartConnectionEvent;	import com.flippy.fl.model.FlippyModelLocator;	import com.flippy.fl.model.Main;			/**	 * Connect to the RTMP server with the <code>nc</code> NetConnection.	 */		public class StartConnectionCommand implements ICommand 	{		/**		* 		*/					private var model : FlippyModelLocator = FlippyModelLocator.getInstance();	 		 	/**	 	* 	 	*/	 		 	private var main : Main = model.main;	 		 	/**	 	* 	 	*/	 		 	private var netConnectionDelegate : NetConnectionDelegate = main.bncDelegate;	 	 	/**	 	 * 	 	 * @param cgEvent	 	 */	 	 		 	public function execute ( cgEvent : CairngormEvent ) : void	    { 			var event : StartConnectionEvent = StartConnectionEvent( cgEvent );			var uri : String = event.uri;			// Use Delegate to create a connection to the RTMP server.			model.logger.logMessage("About to connect to: " + uri, "StartConnectionCommand");	      	netConnectionDelegate.connect(uri);		}			}}