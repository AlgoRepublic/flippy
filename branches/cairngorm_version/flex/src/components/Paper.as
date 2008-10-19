package components
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	
	import mx.containers.Canvas;
	
	/**
	 * This is a paper. All drawing area is on the paper. We define tool to draw a paper such as:
	 * <ul>
	 * 	<li>Rectangle Tool</li>
	 *  <li>Oval Tool</li>
	 *  <li>Line Tool</li>
	 *  <li>Pen Tool</li>
	 * </ul>
	 * For a specified tool we can determine a property such line style (thickness, line color, fill color, etc).
	 *  
	 * @author uudashr
	 * 
	 */
	public class Paper extends Canvas 
	{
		private var dso:SharedObject;
		private var down:Boolean = false;
		private var rectangle:Rectangle = null;
		private var activeToolId:String = "rectangleTool";
		private var activeDrawObject:Object;
		private var strokeColorVal:uint = 0;
		private var strokeThicknessVal:Number = 1;
		private var fillColorVal:uint = 0;
		private var opaqueVal:Boolean = true;
		private var fillAlphaVal:Number = 1;
		private var seqNumber:int = 1;
		//private var timer:Timer = new Timer(500);
		// TODO uudashr: add different cursor based on the tools when entering the draw area
		private var loader:Loader = new Loader();
		private var bgImage:Bitmap = null;
		private var _backgroundImageUrl:String;
		
		private var _readOnly:Boolean = false;
		
		public function Paper()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			
		}
		
		public function set backgroundImageUrlRequest(urlReq:URLRequest):void
		{
			function completeLoaded(e:Event):void
			{
				trace("Loaded");
				bgImage = loader.contentLoaderInfo.content as Bitmap;
				
				width = bgImage.width;
				height = bgImage.height;
				
				repaintDrawables();
			}
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeLoaded);
			loader.load(urlReq);
		}
		
		public function set backgroundImageUrl(url:String):void
		{
			_backgroundImageUrl = url;
			
			backgroundImageUrlRequest = new URLRequest(url);
		}
		
		public function get backgroundImageUrl():String
		{
			return _backgroundImageUrl;
		}
		
		public function set readOnly(val:Boolean):void
		{
			_readOnly = val;
		}
		
		public function get readOnly():Boolean
		{
			return _readOnly;
		}
		
		public function set drawablesSharedObject(dso:SharedObject):void
		{
			this.dso = dso;
		}
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			if (_readOnly)
			{
				return;
			}
			var x:Number = event.localX;
			var y:Number = event.localY;
			if (x > width)
			{
				x = width;
			} 
			else if (x < 0)
			{
				x = 0;
			}
			
			if (y > height)
			{
				y = height;
			}
			else if (y < 0)
			{
				y = 0;
			}
			
			revalidateActiveDrawableObject(
					x, 
					y);
					
			repaintDrawables();
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			if (_readOnly)
			{
				return;
			}
			if (!event.buttonDown)
			{
				addAndRemoveActiveDrawObject();
				repaintDrawables();
			}
		}
		
		private function rollOutHandler(event:MouseEvent):void
		{
			//trace("Roll Out");
		}
		
		private function rollOverHandler(event:MouseEvent):void
		{
			//trace("Roll Over: " + event.buttonDown);
		}
		
		public function set tool(toolId:String):void
		{
			activeToolId = toolId;
		}
		
		public function get tool():String
		{
			return activeToolId;
		}
		
		public function set strokeColor(color:uint):void
		{
			strokeColorVal = color;
		}
		
		public function set fillColor(color:uint):void
		{
			fillColorVal = color;
		}
		
		public function set opaque(val:Boolean):void
		{
			opaqueVal = val;
		}
		
		public function set fillAlpha(val:Number):void
		{
			if (val > 1) {
				fillAlphaVal = 1;
			} else if (val < 0) {
				fillAlphaVal = 0;
			} else {
				fillAlphaVal = val;
			}
		}
		
		public function set strokeThickness(thickness:Number):void
		{
			strokeThicknessVal = thickness;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (_readOnly)
			{
				return;
			}
			if (activeToolId == "rectangleTool")
			{
				activeDrawObject = {
						type:"rectangle", 
						x:event.localX, 
						y:event.localY, 
						strokeColor:strokeColorVal, 
						strokeThickness:strokeThicknessVal, 
						opaque:opaqueVal, 
						fillColor:fillColorVal, 
						fillAlpha:fillAlphaVal};
						
			}
			else if (activeToolId == "lineTool")
			{
				activeDrawObject = {
						type:"line", 
						startX:event.localX, 
						startY:event.localY, 
						strokeColor:strokeColorVal, 
						strokeThickness:strokeThicknessVal};
			}
			else if (activeToolId == "ovalTool")
			{
				activeDrawObject = {
						type:"oval", 
						x:event.localX, 
						y:event.localY, 
						strokeColor:strokeColorVal, 
						strokeThickness:strokeThicknessVal, 
						opaque:opaqueVal, 
						fillColor:fillColorVal, 
						fillAlpha:fillAlphaVal};
			}
			else if (activeToolId == "penTool")
			{
				activeDrawObject = {
						type:"pen", 
						path:[{x:event.localX, y:event.localY}], 
						strokeColor:strokeColorVal, 
						strokeThickness:strokeThicknessVal};
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			if (_readOnly)
			{
				return;
			}
			revalidateActiveDrawableObject(event.localX, event.localY);
			repaintDrawables();
		}
		
		private function revalidateActiveDrawableObject(x:Number, y:Number):void
		{
			if (activeDrawObject == null) {
				return;
			}
			
			if (activeDrawObject.type == "rectangle")
			{
				activeDrawObject.width = x - activeDrawObject.x;
				activeDrawObject.height = y - activeDrawObject.y;
			}
			else if (activeDrawObject.type == "line")
			{
				activeDrawObject.endX = x;
				activeDrawObject.endY = y;
			}
			else if (activeDrawObject.type == "oval")
			{
				activeDrawObject.width = x - activeDrawObject.x;
				activeDrawObject.height = y - activeDrawObject.y;
			}
			else if (activeDrawObject.type == "pen")
			{
				activeDrawObject.path.push({x:x, y:y});
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void {
			if (_readOnly)
			{
				return;
			}
			revalidateActiveDrawableObject(event.localX, event.localY);
			addAndRemoveActiveDrawObject();
		}
		
		private function addAndRemoveActiveDrawObject():void
		{
			if (activeDrawObject != null)
			{
				if (dso.data["objects"] == undefined) 
				{
					dso.data["objects"] = new Array();
				}
				dso.data["objects"].push(activeDrawObject);
				activeDrawObject = null;
				dso.setDirty("objects");
			}
		}
		
		public function clear():void
		{
			/*
			for (var i:int = 0; i < seqNumber; i++)
			{
				delete dso.data[i];
			}
			*/
			if (!(dso.data["objects"] == undefined) && dso.data["objects"] is Array) {
				dso.data["objects"].splice(0, dso.data["objects"].length);
				dso.setDirty("objects");
			} else {
				trace("Not clearing objects");
			}
			
			//repaintDrawables();
		}
		
		public function repaintDrawables():void
		{
			graphics.clear();
			if (bgImage != null)
			{
				graphics.beginBitmapFill(bgImage.bitmapData);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
			
			if (dso == null)
			{
				return;
			}
			/*
			for (var i:int = 0; i < drawables.length; i++)
			{
				var item:Object = drawables[i];
				drawObject(drawables[i]);
			}
			*/
			for (var d:Object in dso.data["objects"])
			{
				drawObject(dso.data["objects"][d]);
			}
			if (activeDrawObject != null)
			{
				drawObject(activeDrawObject);
			}
		}
		
		private function drawObject(drawable:Object):void
		{
			if (drawable.type == "rectangle")
			{
				graphics.lineStyle(drawable.strokeThickness, drawable.strokeColor);
				graphics.moveTo(drawable.x, drawable.y);
				if (!drawable.opaque)
				{
					graphics.beginFill(drawable.fillColor, drawable.fillAlpha);
				}
				graphics.drawRect(drawable.x, drawable.y, drawable.width, drawable.height);
				if (!drawable.opaque)
				{
					graphics.endFill();
				}
			}
			else if (drawable.type == "line")
			{
				graphics.lineStyle(drawable.strokeThickness, drawable.strokeColor);
				graphics.moveTo(drawable.startX, drawable.startY);
				graphics.lineTo(drawable.endX, drawable.endY);
			}
			else if (drawable.type == "oval")
			{
				graphics.lineStyle(drawable.strokeThickness, drawable.strokeColor);
				graphics.moveTo(drawable.x, drawable.y);
				if (!drawable.opaque)
				{
					graphics.beginFill(drawable.fillColor, drawable.fillAlpha);
				}
				graphics.drawEllipse(drawable.x, drawable.y, drawable.width, drawable.height);
				if (!drawable.opaque)
				{
					graphics.endFill();
				}
			}
			else if (drawable.type == "pen")
			{
				graphics.lineStyle(drawable.strokeThickness, drawable.strokeColor);
				graphics.moveTo(drawable.path[0].x, drawable.path[0].y);
				/*
				for (var i:int = 1; i < drawable.path.length; i++)
				{
					var obj:Object = drawable.path[i];
					graphics.lineTo(obj.x, obj.y);
				}
				*/
				for (var p:Object in drawable.path)
				{
					var obj:Object = drawable.path[p];
					graphics.lineTo(obj.x, obj.y);
				}
			}
			else
			{
				trace("unknown drawable object");
			}
		}
	}
}