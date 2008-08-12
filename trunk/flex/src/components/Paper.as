package components
{
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	
	public class Paper extends Canvas 
	{
		private var drawables:ArrayCollection = new ArrayCollection();
		private var down:Boolean = false;
		private var rectangle:Rectangle = null;
		private var activeToolId:String = "rectangleTool";
		private var activeDrawObject:Object;
		private var strokeColorVal:uint = 0;
		private var strokeThicknessVal:Number = 1;
		private var fillColorVal:uint = 0;
		private var opaqueVal:Boolean = true;
		private var fillAlphaVal:Number = 1;
		
		// TODO uudashr: add different cursor based on the tools when entering the draw area
		
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
		
		private function mouseOutHandler(event:MouseEvent):void
		{
			trace("Mouse Out");
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
			trace("Mouse Over");
			if (!event.buttonDown)
			{
				addAndRemoveActiveDrawObject();
				repaintDrawables();
			}
		}
		
		private function rollOutHandler(event:MouseEvent):void
		{
			trace("Roll Out");
		}
		
		private function rollOverHandler(event:MouseEvent):void
		{
			trace("Roll Over: " + event.buttonDown);
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
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			trace("mouseDown(" + event.localX + "," + event.localY + ") - " + activeToolId);
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
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			//trace("mouseMove(" + event.localX + "," + event.localY + ") - " + activeToolId);
			/*
			if (activeDrawObject == null) {
				return;
			}
			
			if (activeDrawObject.type == "rectangle")
			{
				activeDrawObject.width = event.localX - activeDrawObject.x;
				activeDrawObject.height = event.localY - activeDrawObject.y;
			}
			else if (activeDrawObject.type == "line")
			{
				activeDrawObject.endX = event.localX;
				activeDrawObject.endY = event.localY;
			}
			*/
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
		}
		
		protected function mouseUpHandler(event:MouseEvent):void {
			trace("mouseUp(" + event.localX + "," + event.localY + ") - " + activeToolId);
			//trace("Release Object: " + activeDrawObject.x + ", " + activeDrawObject.y + ", " + activeDrawObject.width + ", " + activeDrawObject.height);
			revalidateActiveDrawableObject(event.localX, event.localY);
			addAndRemoveActiveDrawObject();
		}
		
		private function addAndRemoveActiveDrawObject():void
		{
			if (activeDrawObject != null)
			{
				drawables.addItem(activeDrawObject);
				repaintDrawables();
				activeDrawObject = null;
			}
		}
		
		public function clear():void
		{
			drawables.removeAll();
			repaintDrawables();
		}
		
		private function repaintDrawables():void
		{
			graphics.clear();
			
			var arr:Array = drawables.source;
			for (var i:int = 0; i < arr.length; i++)
			{
				var item:Object = arr[i];
				/*
				graphics.lineStyle(item.strokeThickness, item.strokeColor);
				graphics.drawRect(item.x, item.y, item.width, item.height);
				*/
				drawObject(arr[i]);
			}
			if (activeDrawObject != null)
			{
				/*
				graphics.lineStyle(activeDrawObject.strokeThickness, activeDrawObject.strokeColor);
				graphics.drawRect(activeDrawObject.x, activeDrawObject.y, 
						activeDrawObject.width, activeDrawObject.height);
						*/
				drawObject(activeDrawObject);
			}
		}
		
		private function drawObject(drawable:Object):void
		{
			if (drawable.type == "rectangle")
			{
				graphics.lineStyle(drawable.strokeThickness, drawable.strokeColor);
				if (!drawable.opaque)
				{
					graphics.beginFill(drawable.fillColor, drawable.fillAlpha);
				}
				graphics.drawRect(drawable.x, drawable.y, drawable.width, drawable.height);
				graphics.endFill();
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
				if (!drawable.opaque)
				{
					graphics.beginFill(drawable.fillColor, drawable.fillAlpha);
				}
				graphics.drawEllipse(drawable.x, drawable.y, drawable.width, drawable.height);
				graphics.endFill();
			}
			else
			{
				trace("unknown drawable object");
			}
		}
	}
}