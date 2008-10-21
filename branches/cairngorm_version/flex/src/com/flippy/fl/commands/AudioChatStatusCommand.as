package com.flippy.fl.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.flippy.fl.events.*;
	import com.flippy.fl.model.FlippyModelLocator;
	import com.flippy.fl.model.Logger;
	import com.flippy.fl.model.Main;
	
	import flash.events.ActivityEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.system.Security;

	public class AudioChatStatusCommand implements ICommand
	{	
		[Bindable]	
		private var model:FlippyModelLocator = FlippyModelLocator.getInstance();		
		private var logger:Logger = model.logger;
		[Bindable]
		private var main:Main = model.main;
		private var aChatEvent:AudioChatEvent;		
		
		public function AudioChatStatusCommand()
		{
			
		}

		public function execute(event:CairngormEvent):void
		{
			aChatEvent = event as AudioChatEvent;
			
			logger.logMessage( "audio chat status command.. started: " + aChatEvent.started, this);												
			
			if (model.main.role == model.main.ROLE_AUTHOR) {			
				// event should be generated by StartAudioChat button! 
				
				// update model
				logger.logMessage("about to set start chat button to: " + (!aChatEvent.started), this);
				main.audioChatStarted = aChatEvent.started;
				
				logger.logMessage("started: " + main.audioChatStarted, this);
				
				// update things
				if (aChatEvent.started) {
					// start
					initMicrophone();
					
					logger.logMessage("mic: " + main.microphone, this);
					
					main.audioStream = new NetStream(main.businessNc);
					main.audioStream.attachAudio(main.microphone);
					main.audioStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
					main.audioStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					
					logger.logMessage("publishing..", this);
					main.audioStream.publish(String(main.sessionId), "live");
				} else {
					// stop
					logger.logMessage("Stopping audio stream: ", this);
					if (main.audioStream != null) {
						main.audioStream.close();
						main.audioStream = null;		
					}		
					// mute mic	
					main.microphone.setSilenceLevel(100);
				}
				
				// update RSO
				main.stateRSO.data["audioChatStarted"] = aChatEvent.started;
				main.stateRSO.setDirty("audioChatStarted");
				
			} else {
				if (aChatEvent.started) {
					logger.logMessage("New Stream available", this);
					// play stream
					main.audioStream = new NetStream(main.businessNc);
					main.audioStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
					main.audioStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
					
					logger.logMessage("playing stream", this);
					main.audioStream.play(String(main.sessionId));
				} else {
					logger.logMessage("Stream stopped", this);
				}
			}
		}
		
		/*** HANDLER ****/
		public function onAsyncError(event:AsyncErrorEvent):void {
			logger.logMessage("async err: " + event, this);
		}
		
		public function onNetStatus(event:NetStatusEvent):void {
			var statusCode : String = event.info.code;
				
				model.logger.logMessage("onNetStatus: " + statusCode, this) ;
				
				switch ( statusCode ) 
				{
					case "NetStream.Play.StreamNotFound":
						
						model.logger.logMessage(statusCode, this) ;
						break;
						
					default :
					   // statements
					   break;
				}
		}
		
		/** other */
		public function initMicrophone():void {
			if (main.microphone == null) {
				main.microphone = Microphone.getMicrophone();
				Security.showSettings("2");
				
				var mic:Microphone = main.microphone;
				if(mic == null){
					logger.logMessage("No available microphone", this);
				} else {
					logger.logMessage("initializing microphone", this);
					mic.setUseEchoSuppression(true);
					// unmute
//					main.microphone.setSilenceLevel(10);
//					mic.gain = 80;
//					mic.setLoopBack(true);
					mic.addEventListener(ActivityEvent.ACTIVITY, micActivityHandler);
					mic.addEventListener(StatusEvent.STATUS, micStatusHandler);
				}
			} else {
				// unmute
				main.microphone.setSilenceLevel(10);
			}		
		}
			
		private function micActivityHandler(event:ActivityEvent):void {
			logger.logMessage("activityHandler: " + event + " level="+main.microphone.activityLevel, this);
		}
			
		private function micStatusHandler(event:StatusEvent):void {
			switch(event.code) {
				case "Microphone.Muted":
				logger.logMessage("mic MUTED", this);
				break;
				case "Microphone.Unmuted":
				logger.logMessage("mic UNMUTED", this);
				break;
				default:
				logger.logMessage("unknown micStatusHandler event: " + event, this);
			}
		}
		
	}
}
