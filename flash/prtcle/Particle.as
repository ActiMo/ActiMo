package prtcle {
	import flash.display.*
	
	public class Particle 
	{
		public var clip:DisplayObject;
		public var xvel:Number;
		public var yvel:Number;
		public var drag:Number = 0.99;
		public var gravity:Number = 0.4;
		public var shrink:Number = 1;
		public var fade:Number = 0.02;

		public function Particle(symbolclass:Class, target:DisplayObjectContainer, xpos:Number, ypos: Number) 
		{
			clip = new symbolclass;
			target.addChild(clip);
			clip.x = xpos;
			clip.y = ypos;
			
		}
		public function update():void
		{
			clip.x += xvel;
			clip.y += yvel;
			xvel *= drag;
			yvel *= drag;
			
			yvel += gravity;
			clip.scaleX *= shrink;
			clip.scaleY *= shrink;
			
			clip.alpha -= fade;
			
		}
		public function destroy():void
		{
			clip.parent.removeChild(clip);
		}

	}
	
}
