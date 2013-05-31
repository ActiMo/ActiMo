package  prtcle {
	import flash.display.*
	public class puntObject {

		public var clippy:DisplayObject;
		public var xvel:Number;
		public var xpos:Number;
		public var typer:Number;
		
		public function puntObject(symbolclass:Class, target:DisplayObjectContainer, xpos:Number, ypos:Number, type:Number) 
		{
			clippy = new symbolclass;
			target.addChild(clippy);
			clippy.x = xpos;
			clippy.y = ypos;
			typer = type;
		}
		
		public function update():void
		{
			clippy.x += xvel;			
		}
		
		public function destroy():void
		{
			clippy.parent.removeChild(clippy);
		}
	}
}
