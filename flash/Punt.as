package  {
	import flash.desktop.NativeProcess;
	import flash.events.*
    import flash.desktop.NativeProcessStartupInfo;
	import flash.desktop.InteractiveIcon;
	import flash.events.NativeProcessExitEvent;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.display.*
	import prtcle.puntObject;
	import com.coreyoneil.collision.CollisionList;
	
	public class Punt extends MovieClip{
		public var pump:pumpkin;
		public var grav:int = 1;
		public var pground:puntBground;
		public var pground2:puntBground;
		public var Power:int = 25;
		public var container1:Sprite = new Sprite();
		public var yspeed:int;
		public var xspeed:int;
		public var objects:Array = new Array();
		private var _collisionList:CollisionList;
		public var bgroundArray:Array = new Array();
		public var noNewBground:int = 0;
		
		public function Punt() 
		{
			genbground();
			addChild(container1);
			genPumpkin();
			addEventListener(Event.ENTER_FRAME, genObject);
		}
		
		public function randomNumbers(min:Number, max:Number)
		{
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		public function destroyMe(object:*):void 
		{
			if(object.parent != null)
			{
				var parent:DisplayObjectContainer = object.parent;
				parent.removeChild(object);
			}
		}
		
		public function genObject(e:Event):void
		{
			var pObject:puntObject;
			var chance:int = 2500;
			var ifNewObject:int = randomNumbers(1,chance/xspeed);
			
			if (ifNewObject < 5 && xspeed > 0 && objects)
			{
				var type:int = randomNumbers(1,3);
				
				if (type == 1)
				{
					pObject = new puntObject(Trampoline, this, 1700, 800, type);
					pObject.xvel = -xspeed;
					objects.push(pObject);
					addEventListener(Event.ENTER_FRAME, updateObject);
					_collisionList.addItem(pObject.clippy);
				}
				else if (type == 4)
				{
					pObject = new puntObject(Spikes, this, 1700, 900, type);
					pObject.xvel = -xspeed;
					objects.push(pObject);
					addEventListener(Event.ENTER_FRAME, updateObject);
					_collisionList.addItem(pObject.clippy);
				}
				else if (type == 3)
				{
					pObject = new puntObject(Oil, this, 1700, 750, type);
					pObject.xvel = -xspeed;
					objects.push(pObject);
					addEventListener(Event.ENTER_FRAME, updateObject);
					_collisionList.addItem(pObject.clippy);
				}
			}
		}
		
		public function updateObject(e:Event):void
		{
			var xdist:Array = new Array();
			var whichObj:Array = new Array();
			for (var i:int = 0; i < objects.length; i++)
			{

				objects[i].xvel = -xspeed;
				objects[i].update();
				
				if (objects[i].clippy.x < -20)
				{
					//objects[i].destroy();
				}
				
				xdist[i] = Math.abs(objects[i].clippy.x - 100);
				whichObj[i] = objects[i].typer;
				
			}

			var collisions:Array = _collisionList.checkCollisions();
			
			for (i = 0; i < collisions.length; i++)
			{
				var collision:Object = collisions[i];
				var xmin:int;
				var xminpos:int;
				if (collision)
				{
					xmin = Math.min.apply(null, xdist);
					xminpos = xdist.indexOf(xmin,0);
					
					if (whichObj[xminpos] == 3)
					{
						xspeed += 1.5;
					}
					else if (whichObj[xminpos] == 2)
					{
						xspeed = 0;
						yspeed = 0;
					} 
					else if (whichObj[xminpos] == 1)
					{
						yspeed += 5;
					}
				}
			}
		}
		
		public function genbground():void
		{
			pground = new puntBground();
			pground.width = 3200;
			pground.height = 900;
			pground.x = 1600;
			pground.y = 450;
			xspeed = 0;
			container1.addChild(pground);
			bgroundArray[0] = pground;
		}
		
		public function genPumpkin():void
		{
			pump = new pumpkin();
			pump.x = 100;
			pump.y = 600;
			addChild(pump);
			addEventListener(MouseEvent.CLICK, hitPumpkin);
			yspeed = 0;
			_collisionList = new CollisionList(pump);
		}
		
		public function hitPumpkin(e:Event):void
		{
			yspeed = Power;
			xspeed = Power;
			addEventListener(Event.ENTER_FRAME, movePumpkin);
			addEventListener(Event.ENTER_FRAME, movebground);
		}
		public function movePumpkin(e:Event):void
		{
			pump.y += -yspeed;
			yspeed -= grav;
			

			if (pump.y > 600)
			{
				pump.y = 600;
				yspeed /= 1.2;
				yspeed *= -1;
				xspeed /= 1.2;
			}
		}
		public function movebground(e:Event):void
		{
			
			bgroundArray[0].x -= xspeed;
			if (bgroundArray[1] != null)
			{
				bgroundArray[1].x -= xspeed;
				bgroundArray[1].x = bgroundArray[0].x + 3200;
			}
			
			if (bgroundArray[0].x <= 0 && noNewBground == 0)
			{
				var pground2 = new puntBground();
				pground2.x = pground.x + 3200;
				pground2.width = 3200;
				pground2.height = 900;
				pground2.y = 450;
				container1.addChild(pground2);
				bgroundArray[1] = pground2;
				noNewBground = 1;
			}
			else if (bgroundArray[0].x <= -3200)
			{
				bgroundArray[0] = bgroundArray[1];
				pground = new puntBground();
				pground.x = pground.x + 3200;
				pground.width = 3200;
				pground.height = 900;
				pground.y = 450;
				container1.addChild(pground);
				bgroundArray[1] = pground;
			}
		}
	}
}
