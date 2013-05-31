package  {
	import flash.events.*;
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fl.display.ProLoader;
	import flash.net.URLRequest;
	import flash.desktop.NativeProcess;
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
	import prtcle.Particle;
	import flash.display.Shape;
	
	public class ArmGames extends MovieClip{
	
		public var process:NativeProcess;
		public var oLine:String;
		public var handDir:int = 2;     //assign for loop/click
		public var Power:int = 5;       //assign for loop/click
		public var stk:stick;
		public var breakFactor:int = 1 ;
		public var bambooPos:int;
		public var Panda:panda;
		public var bar:healthBar = new healthBar();
		public var score:int = 0;
		public var scoreText:TextField;
		public var scoreName:TextField;
		public var powerFactor:int;
		public var pinata = new Pinata1();
		public var pinataTween1:Tween;
		public var pinataTween2:Tween;
		public var pinataTween3:Tween;
		public var pinataTween4:Tween;
		public var pinataTween5:Tween;
		public var pinataTween6:Tween;
		public var prevxspeed:int;
		public var prevyspeed:int;
		public var forward:int;
		public var swit:int = 0;
		public var particles:Array = new Array();
		public var whichSideLast:int = 2;
		public var created:int = 0;
		public var string:Shape = new Shape();
		public var HPText:TextField;
		public var stkTween1:Tween;
		public var stkTween2:Tween;
		public var stkTween3:Tween;
		
		public function explosion(e:Event):void
		{
			var particle:Particle;
			
			for (var i:int = 0; i < particles.length; i++)
			{
				particles[i].update();
			}
			
			if (created == 0)
			{
				for (i = 0; i < 200; i++)
				{
					particle = new Particle(Spark, this, pinata.x, pinata.y);
					particle.yvel = randomNumbers(-20,20);
					particle.xvel = randomNumbers(-20,20);
					particle.shrink = 1.05;
					particle.drag = randomNumbers(.95,1);
					particles.push(particle);
					created = 1;
				}
			}
		}
		
		public function confetti(e:Event):void
		{
			var particle:Particle;
			
			for (var i:int = 0; i < particles.length; i++)
			{
				particles[i].update();
			}
			
			if (particles.length < 200)
			{
				particle = new Particle(Spark, this, pinata.x, pinata.y);
				particle.yvel = randomNumbers(0,5);
				particle.xvel = randomNumbers(-5,5);
				particle.shrink = 1.05;
				particles.push(particle);
			}
			else if (particles.length == 200)
			{
				removeEventListener(Event.ENTER_FRAME, confetti);
				for (i = 0; i < particles.length; i++)
				{
					particles[i].destroy();
				}
				particles = new Array();
			}
		}

		public function ArmGames() 
		{
			playPinata();
			//playBamboo();
			
		}
		
		public function destroyMe(object:*):void 
		{
			if(object.parent != null)
			{
				var parent:DisplayObjectContainer = object.parent;
				parent.removeChild(object);
			}
		}
		
		public function playBamboo():void
		{
			if(NativeProcess.isSupported)
            {
                setupAndLaunch();
            }
            else
            {
                trace("NativeProcess not supported.");
			}
			genStick();
			//genSword();                     //loop for sword, comment out
			HPBar();
			timer();
			scoreFunc();
		}
		
		public function HPBar():void
		{
			HPText = new TextField();
			var Vineta = new vineta();
			var HPFormat:TextFormat = new TextFormat();
			HPFormat.size = 45;
			HPFormat.align = TextFormatAlign.CENTER;
			HPFormat.font = Vineta.fontName;
			
			
			HPText.defaultTextFormat = HPFormat;
			HPText.text = ("Health");
			HPText.textColor = 0xFFFFFF;
			HPText.x = 1100;
			HPText.y = 10;
			HPText.autoSize = TextFieldAutoSize.LEFT;
			addChild(HPText);
			
			bar.x = 1100;
			bar.y = 100;
			if (bar.width > 10)
			{
				bar.width = 200 - 2*breakFactor;
			}
			bar.height = 50;
			addChild(bar);
		}
		public function scoreFunc():void
		{
			scoreText = new TextField();
			scoreName = new TextField();
			var Vineta = new vineta();
			var scoreFormat:TextFormat = new TextFormat();
			scoreFormat.size = 45;
			scoreFormat.align = TextFormatAlign.CENTER;
			scoreFormat.font = Vineta.fontName;
			
			scoreName.defaultTextFormat =  scoreFormat;
			scoreName.text = ("Score");
			scoreName.x = 680;
			scoreName.y = 10;
			scoreName.autoSize = TextFieldAutoSize.LEFT;
			scoreName.textColor = 0xFFFFFF;
			addChild(scoreName);
			
			scoreText.defaultTextFormat = scoreFormat;
			scoreText.text = score.toString();
			scoreText.x = 775;
			scoreText.y = 75;
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			addChild(scoreText);
		}
		public function timer():void
		{
			var timerName:TextField = new TextField();
			var Vineta = new vineta();
			var timerFormat:TextFormat = new TextFormat();
			timerFormat.size = 45;
			timerFormat.align = TextFormatAlign.CENTER;
			timerFormat.font = Vineta.fontName;
			
			timerName.defaultTextFormat =  timerFormat;
			timerName.text = ("Time Left");
			timerName.x = 200;
			timerName.y = 10;
			timerName.autoSize = TextFieldAutoSize.LEFT;
			timerName.textColor = 0xFFFFFF;
			addChild(timerName);
			
			var timer:Timer = new Timer(1000,120);
			var timerText:TextField = new TextField();
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, timerListener)
			var timeLeft:int = 120;
			function timerListener(event:TimerEvent):void
			{
				if (timeLeft > 0)
				{
					var Vineta = new vineta();
					var myFormat:TextFormat = new TextFormat();
					myFormat.size = 45;
					myFormat.align = TextFormatAlign.CENTER;
					myFormat.font = Vineta.fontName;
					
					timerText.defaultTextFormat = myFormat;
					timerText.text = timeLeft.toString();
					timerText.x = 350;
					timerText.y = 75;
					timerText.autoSize = TextFieldAutoSize.LEFT;
					addChild(timerText);
					timeLeft--;
				}
				else
				{
					//end game code or function
				}
			}
		}
		
		public function setupAndLaunch():void
        {     
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var file:File = File.applicationDirectory.resolvePath("python.exe");
			var bBackground:bambooBground = new bambooBground();
			var forestMusic:forestmusic = new forestmusic();
			Panda = new panda();
			forestMusic.play();
			addEventListener(MouseEvent.CLICK,genSword)               //click listener
            nativeProcessStartupInfo.executable = file;
            var processArgs:Vector.<String> = new Vector.<String>();
            processArgs[0] = "-u";
			processArgs[1] = "C:\\SeniorDesignProgram\\Driver.py";
            nativeProcessStartupInfo.arguments = processArgs;
            process = new NativeProcess();
            process.start(nativeProcessStartupInfo);
			trace("Program started");
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);   //process listener
			addChild(bBackground);
			addChild(Panda);
			bBackground.x = 800;
			bBackground.y = 450;
			Panda.x = 200;
			Panda.y = 200;
			
        }
        public function onOutputData(event:ProgressEvent):void
        {
			oLine = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
            trace("Got: ", oLine);
			var a1:int;
			var a2:int;
			var endLine:int;
			a1 = oLine.indexOf("d");
			a2 = oLine.indexOf("p");
			endLine = oLine.indexOf("end");
			trace("A1 is: ", a1);
			trace("A2 is: ", a2);
			handDir = Number(oLine.substring(a1+1,a2));
			trace("handDir is: ", handDir);
			Power = Number(oLine.substring(a2+1,endLine));
			trace("Power is: ", Power);
			//genSword();
        }
		public function randomNumbers(min:Number, max:Number)
		{
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		public function genStick():void
		{
			stk = new stick();
			HPBar();
			bar.width = 200;
			addChild(stk);
			setChildIndex(stk,3);
			bambooPos = randomNumbers(1,4);
			stk.x = 800;
			stk.y = 450;
			stk.width = 400;
			stk.height = 960;

			switch(bambooPos)
			{
				case 1:
				stk.rotation = 90;
				break;
				case 3:
				stk.rotation = 0;
				break;
				case 4:
				stk.rotation = 45;
				break;
				case 2:
				stk.rotation = 135;
			}
			
			stkPhase1();
			addEventListener("stopStick", stopStickTween);
			
			function stopStickTween(e:Event):void
			{
				stkTween2.removeEventListener(TweenEvent.MOTION_FINISH, stkPhase3);
				stkTween3.removeEventListener(TweenEvent.MOTION_FINISH, stkPhase2);
			}
			function stkPhase1():void
			{
				stkTween1 = new Tween(stk, "rotation", Regular.easeInOut, stk.rotation, stk.rotation + 10, 1, true);
				stkTween1.addEventListener(TweenEvent.MOTION_FINISH, stkPhase2);
			}
			function stkPhase2(e:Event):void
			{
				stkTween2 = new Tween(stk, "rotation", Regular.easeInOut, stk.rotation, stk.rotation - 20, 2, true);
				stkTween2.addEventListener(TweenEvent.MOTION_FINISH, stkPhase3);
			}
			function stkPhase3(e:Event):void
			{
				stkTween3 = new Tween(stk, "rotation", Regular.easeInOut, stk.rotation, stk.rotation + 20, 2, true);
				stkTween3.addEventListener(TweenEvent.MOTION_FINISH, stkPhase2);
			}
		}
		public function genSword(event:MouseEvent):void
		{
			var sword1:sword; 
			var sword2:sword;
			var sword3:sword;
			var sword4:sword;
			var sword5:sword;
			var sword6:sword;
			var sword7:sword;
			var sword8:sword;
			var whichSword:int;
			
			powerFactor = 3*(0.5 + Math.pow(Power,-1));
			destroyMe(Panda);
			
			function removeSword():void
			{
				if (whichSword == 1)
				{
					removeChild(sword1);
				}
				else if (whichSword == 2)
				{
					removeChild(sword2);
				}
				else if (whichSword == 3)
				{
					removeChild(sword3);
				}
				else if (whichSword == 4)
				{
					removeChild(sword4);
				}
				else if (whichSword == 5)
				{
					removeChild(sword5);
				}
				else if (whichSword == 6)
				{
					removeChild(sword6);
				}
				else if (whichSword == 7)
				{
					removeChild(sword7);
				}
				else if (whichSword == 8)
				{
					removeChild(sword8);
				}
			}
			
			
			if (bambooPos == handDir)
			{
				breakFactor += 2*Power;
				HPBar();
			}
			else if ((bambooPos+3) == handDir)
			{
				breakFactor += 2*Power;
				HPBar();
			}
			else if (bambooPos == 1 && (handDir == 2 || handDir == 4 || handDir == 6 || handDir == 8))
			{
				breakFactor += Power;
				HPBar();
			}
			else if (bambooPos == 2 && (handDir == 1 || handDir == 3 || handDir == 5 || handDir == 7))
			{
				breakFactor += Power;
				HPBar();
			}
			else if (bambooPos == 3 && (handDir == 2 || handDir == 4 || handDir == 6 || handDir == 8))
			{
				breakFactor += Power;
				HPBar();
			}
			else if (bambooPos == 4 && (handDir == 1 || handDir == 3 || handDir == 5 || handDir == 7))
			{
				breakFactor += Power;
				HPBar();
			}
			
			function tweenDone(event:TweenEvent):void
			{
				removeSword();
			}
			
			switch(Number(handDir))
			{
				case 5:
				sword5 = new sword();
				var sword5Tween:Tween = new Tween(sword5, "y", Strong.easeOut, 200, 700, powerFactor, true);
				sword5Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 5;
				sword5.x = 900;
				sword5.y = 200;
				sword5.width = 390;
				sword5.height = 200;
				addChild(sword5);
				break;
				
				case 3:
				sword3 = new sword();
				var sword3Tween:Tween = new Tween(sword3, "x", Strong.easeOut, 200, 1400, powerFactor, true);
				sword3Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 3;
				sword3.x = 200;
				sword3.y = 400;
				sword3.width = 390;
				sword3.height = 200;
				addChild(sword3);
				break;
				
				case 4:
				sword4 = new sword();
				var sword4Tween:Tween = new Tween(sword4, "y", Strong.easeOut, 200, 700, powerFactor, true);
				var sword4Tween2:Tween = new Tween(sword4, "x", Strong.easeOut, 500, 1400, powerFactor, true);
				sword4Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 4;
				sword4.x = 500;
				sword4.y = 200;
				sword4.width = 390;
				sword4.height = 200;
				addChild(sword4);
				break;
				
				case 1:
				sword1 = new sword();
				var sword1Tween:Tween = new Tween(sword1, "y", Strong.easeOut, 700, 200, powerFactor, true);
				sword1Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 1;
				sword1.x = 900;
				sword1.y = 700;
				sword1.width = 390;
				sword1.height = 200;
				sword1.rotation = 180;
				addChild(sword1);
				break;
				
				case 7:
				sword7 = new sword();
				var sword7Tween:Tween = new Tween(sword7, "x", Strong.easeOut, 1400, 200, powerFactor, true);
				sword7Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 7;
				sword7.rotation = 180;
				sword7.x = 1400;
				sword7.y = 400;
				sword7.width = 390;
				sword7.height = 200;
				addChild(sword7);
				break;
				
				case 8:
				sword8 = new sword();
				var sword8Tween:Tween = new Tween(sword8, "y", Strong.easeOut, 700, 200, powerFactor, true);
				var sword8Tween2:Tween = new Tween(sword8, "x", Strong.easeOut, 1400, 500, powerFactor, true);
				sword8Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 6;
				sword8.rotation = 180;
				sword8.x = 1400;
				sword8.y = 700;
				sword8.width = 390;
				sword8.height = 200;
				addChild(sword8);
				break;
				
				case 6:
				sword6 = new sword();
				var sword6Tween:Tween = new Tween(sword6, "y", Strong.easeOut, 200, 700, powerFactor, true);
				var sword6Tween2:Tween = new Tween(sword6, "x", Strong.easeOut, 1400, 500, powerFactor, true);
				sword6Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 6;
				sword6.rotation = 180;
				sword6.x = 1400;
				sword6.y = 200;
				sword6.width = 390;
				sword6.height = 200;
				addChild(sword6);
				break;
				
				case 2:
				sword2 = new sword();
				var sword2Tween:Tween = new Tween(sword2, "y", Strong.easeOut, 700, 200, powerFactor, true);
				var sword2Tween2:Tween = new Tween(sword2, "x", Strong.easeOut, 500, 1400, powerFactor, true);
				sword2Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDone);
				whichSword = 2;
				sword2.x = 500;
				sword2.y = 700;
				sword2.width = 390;
				sword2.height = 200;
				sword2.scaleY = -0.7;
				sword2.scaleX = 0.5;
				addChild(sword2);
				break;
			}
			
			if (breakFactor > 99)
			{
				stk.gotoAndStop(53);
				dispatchEvent(new Event("stopStick"));
				score++;
				removeEventListener(MouseEvent.CLICK,genSword)
				var snapsound:snapSound = new snapSound();
				snapsound.play();
				var stickRise:Tween = new Tween(stk, "y", Regular.easeOut, 450, 350, 1, true);
				stickRise.addEventListener(TweenEvent.MOTION_FINISH, stickDropFunc);
				function stickDropFunc(event:TweenEvent):void
				{
					var stickDrop:Tween = new Tween(stk, "y", Regular.easeIn, 350, 1600, 1, true);
					stickDrop.addEventListener(TweenEvent.MOTION_FINISH, newStick);
				}
				function newStick(event:TweenEvent):void
				{
					destroyMe(stk);
					destroyMe(scoreText);
					genStick();
					scoreFunc();
					breakFactor = 1;
					HPBar();
					addEventListener(MouseEvent.CLICK,genSword)
				}
			}
		}
		
		public function playPinata():void
		{
			genPinataBground();
			genPinata();
			var mariachiMusic:MariachiMusic = new MariachiMusic();
			mariachiMusic.play();
			timer();
			scoreFunc();
		}
		
		public function genPinata():void
		{
			pinata["KE"] = 0;
			pinata["yspeed"] = 0;
			pinata["xspeed"] = 0;
			pinata["xLoop"] = 0;
			pinata["yLoop"] = 0;
			pinata["angl"] = 0;
			pinata["speedTot"] = 0;
			pinata["prevx"] = 800;
			pinata["prevy"] = 450;
			pinata["friction"] = 1;
			pinata["angvel"] = 0;
			pinata["angfriction"] = 1;
			pinata["PE"] = 0;
			pinata.x = 800;
			pinata.y = 450;
			pinata.rotation = 0;
			addChild(pinata);
			addEventListener(MouseEvent.CLICK, hitPinata);
			addEventListener(MouseEvent.CLICK, genBat);
			
			string.graphics.clear();
			string.graphics.beginFill(0x990000);
			string.graphics.lineStyle(4, 0x990000, 1);
			string.graphics.moveTo(800,0);
			string.graphics.lineTo(800,322.5);
			addChild(string)
		}
		
		public function movePinata(event:Event):void
		{
			var grav:int = 5;
			pinata.angl = Math.atan((pinata.x-800)/pinata.y);
			pinata.speedTot = Math.sqrt(Math.pow(pinata.xspeed,2)+Math.pow(pinata.yspeed,2));
			
			if (Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)) > 449.95)
			{
				if (pinata.angl < 0)
				{
					pinata.rotation = -50*(pinata.angl);
					
					if (pinata.y < 20)
					{
						pinata.yspeed = 5;
						pinata.xspeed = 10;
						pinata.x += pinata.xspeed;
						pinata.y += pinata.yspeed;
					}
					if (Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)) > 450)
					{
						pinata.y = Math.sqrt(202500 - Math.pow((800 - pinata.x),2));
					}
					
					if (Math.abs(pinata.xspeed)/pinata.xspeed > 0)
					{
						pinata.yspeed = (Math.sqrt(2*pinata.KE)*Math.abs(Math.sin(pinata.angl)));
						pinata.prevy = pinata.y;
						pinata.y += pinata.yspeed;
						pinata.xspeed = (Math.sqrt(2*pinata.KE)*Math.abs(Math.cos(pinata.angl)));
						pinata.x += pinata.xspeed;
						
						pinata.KE += grav*Math.abs(pinata.prevy-pinata.y);
						pinata.PE -= grav*Math.abs(pinata.prevy-pinata.y);
						pinata.friction += 1;
					}
					else if (Math.abs(pinata.xspeed)/pinata.xspeed < 0)
					{
						if (whichSideLast == 1 && pinata.yspeed > 0)
						{
							pinata.yspeed *= -1;
						}
						
						pinata.xspeed = (Math.sqrt(2*pinata.KE)*(Math.abs(pinata.yspeed)/pinata.yspeed)*Math.abs(Math.cos(pinata.angl)));
						pinata.yspeed = -(Math.sqrt(2*pinata.KE)*(Math.abs(pinata.yspeed)/pinata.yspeed)*(Math.sin(pinata.angl)));
						pinata.prevy = pinata.y;
						pinata.y += pinata.yspeed;
						pinata.x += pinata.xspeed;
						
						pinata.KE -= grav*Math.abs(pinata.prevy-pinata.y);
						pinata.PE += grav*Math.abs(pinata.prevy-pinata.y);
						pinata.friction += 2;
						pinata.KE -= pinata.friction;
						if (pinata.KE <= 0)
						{
							pinata.KE = 1;
							pinata.xspeed *= -1;
							pinata.yspeed *= -1;
						}
					}
					whichSideLast = 0;
				}
				
				else if (pinata.angl > 0)
				{
					
					pinata.rotation = -50*(pinata.angl);
					
					if (pinata.y < 20)
					{
						pinata.yspeed = 5;
						pinata.xspeed = -10;
						pinata.x += pinata.xspeed;
						pinata.y += pinata.yspeed;
					}
					if (Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)) > 450)
					{
						pinata.y = Math.sqrt(202500 - Math.pow((800 - pinata.x),2));
						//trace(Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)))
					}
					
					if (Math.abs(pinata.xspeed)/pinata.xspeed < 0)
					{
						pinata.yspeed = (Math.sqrt(2*pinata.KE)*Math.abs(Math.sin(pinata.angl)));
						pinata.prevy = pinata.y;
						pinata.y += pinata.yspeed;
						pinata.xspeed = -(Math.sqrt(2*pinata.KE)*Math.abs((Math.cos(pinata.angl))));
						pinata.x += pinata.xspeed;
						
						pinata.KE += grav*Math.abs(pinata.prevy-pinata.y);
						pinata.PE -= grav*Math.abs(pinata.prevy-pinata.y);
						pinata.friction += 1;
					}
					else if (Math.abs(pinata.xspeed)/pinata.xspeed > 0)
					{
						if (whichSideLast == 0 && pinata.yspeed > 0)
						{
							pinata.yspeed *= -1;
						}
						
						pinata.xspeed = -(Math.sqrt(2*pinata.KE)*(Math.abs(pinata.yspeed)/pinata.yspeed)*Math.abs(Math.cos(pinata.angl)));
						pinata.yspeed = (Math.sqrt(2*pinata.KE)*(Math.abs(pinata.yspeed)/pinata.yspeed)*(Math.sin(pinata.angl)));
						
						pinata.prevy = pinata.y;
						pinata.y += pinata.yspeed;
						pinata.x += pinata.xspeed;
						
						pinata.KE -= grav*Math.abs(pinata.prevy-pinata.y);
						pinata.PE += grav*Math.abs(pinata.prevy-pinata.y);
						pinata.friction += 2;
						pinata.KE -= pinata.friction;
						
						if (pinata.KE <= 0)
						{
							pinata.KE = 1;
							pinata.xspeed *= -1;
							pinata.yspeed *= -1;
						}
					}
					else 
					{
						pinata.yspeed = 5;
						pinata.xspeed = -10;
					}
					whichSideLast = 1;
				}
				else if (pinata.angl == 0)
				{
					pinata.x += pinata.xspeed;
					pinata.y += pinata.yspeed;
				}
			}
			
			else
			{
				//pinata.rotation += pinata.angvel;
				trace(pinata.x)
				pinata.rotation = -50*(pinata.angl);
				pinata.yspeed += grav;
				pinata.prevx = pinata.x;
				pinata.prevy = pinata.y;
				pinata.y += pinata.yspeed;
				pinata.x += pinata.xspeed;
				pinata.KE =(Math.pow(pinata.xspeed,2)+Math.pow(pinata.yspeed,2))/2;
				whichSideLast = 2;
				if (pinata.y < 20)
				{
					pinata.yspeed = 0;
					pinata.xspeed = 0;
				}
				if (Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)) > 450)
				{
					pinata.y = Math.sqrt(202500 - Math.pow((800 - pinata.x),2));
					//trace(Math.sqrt(Math.pow(pinata.y,2) + Math.pow((800-pinata.x),2)))
				}
			}
			
			if (pinata.KE < 6 && pinata.x > 799.5 && pinata.x < 800.5 && pinata.y > 450)
			{
				removeEventListener(Event.ENTER_FRAME, movePinata);
			}
			string.graphics.clear();
			string.graphics.beginFill(0x990000);
			string.graphics.lineStyle(4, 0x990000, 1);
			string.graphics.moveTo(800,0);
			string.graphics.lineTo(pinata.x - 127.5*Math.sin(-pinata.rotation/57.29577), pinata.y - 127.5*Math.cos(-pinata.rotation/57.29577));
			addChild(string)
		}
		
		public function hitPinata(event:Event):void
		{
			powerFactor = 3*(0.5 + Math.pow(Power,-1));
			breakFactor += 2*Power;
			HPBar();
			
			var crashSound:crash1 = new crash1();
			crashSound.play();
			
			pinata.friction = 1;
			trace("hit")
			if (handDir == 1)
			{
				pinata.yspeed = -20;
				pinata.prevy = pinata.y;
				pinata.y += pinata.yspeed;
			}
			else if (handDir == 2)
			{
				pinata.angvel = 10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = 14.14;
				pinata.yspeed = -14.14;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.y += pinata.yspeed;
				pinata.x += pinata.xspeed;
			}
			else if (handDir == 3)
			{
				pinata.angvel = 10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = 20;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.x += pinata.xspeed;
			}
			else if (handDir == 4)
			{
				pinata.angvel = 10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = 14.14;
				pinata.yspeed = 14.14;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.y += pinata.yspeed;
				pinata.x += pinata.xspeed;
			}
			else if (handDir == 5)
			{
				pinata.yspeed = 20;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.y += pinata.yspeed;
			}
			else if (handDir == 6)
			{
				pinata.angvel = -10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = -14.14;
				pinata.yspeed = 14.14;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.y += pinata.yspeed;
				pinata.x += pinata.xspeed;
			}
			else if (handDir == 7)
			{
				pinata.angvel = -10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = -20;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.x += pinata.xspeed;
			}
			else if (handDir == 8)
			{
				pinata.angvel = -10;
				pinata.rotation += pinata.angvel;
				pinata.xspeed = -14.14;
				pinata.yspeed = -14.14;
				pinata.prevy = pinata.y;
				pinata.prevx = pinata.x;
				pinata.y += pinata.yspeed;
				pinata.x += pinata.xspeed;
			}
			addEventListener(Event.ENTER_FRAME, movePinata);
			if (breakFactor > 70 && breakFactor <= 99)
			{
				addEventListener(Event.ENTER_FRAME, confetti);
			}
			else if (breakFactor > 99)
			{
				removeEventListener(MouseEvent.CLICK, hitPinata);
				removeEventListener(MouseEvent.CLICK,genBat);
				removeEventListener(Event.ENTER_FRAME, movePinata);
				removeEventListener(Event.ENTER_FRAME, confetti);
				
				var scream:grito = new grito();
				scream.play();
				destroyMe(scoreText);
				score++;
				scoreFunc();
				
				addEventListener(Event.ENTER_FRAME, explosion);
				
				var pinataRise:Tween = new Tween(pinata, "y", Regular.easeOut, pinata.y, pinata.y - 100, 1, true);
				pinataRise.addEventListener(TweenEvent.MOTION_FINISH, pinataDropFunc);
				
				function pinataDropFunc(event:TweenEvent):void
				{
					var pinataDrop:Tween = new Tween(pinata, "y", Regular.easeIn, pinata.y, 1600, 1, true);
					pinataDrop.addEventListener(TweenEvent.MOTION_FINISH, newPinata);
				}
				function newPinata(event:TweenEvent):void
				{
					for (var i:int = 0; i < particles.length; i++)
					{
						particles[i].destroy();
					}
					particles = new Array();
					destroyMe(woodenBat);
					genPinata();
					created = 0;
					breakFactor = 1;
					HPBar();
					removeEventListener(Event.ENTER_FRAME, explosion);
					addEventListener(MouseEvent.CLICK,genBat);
				}
			}
		}
		
		public function genBat(event:MouseEvent):void
		{
			var bat1:woodenBat; 
			var bat2:woodenBat;
			var bat3:woodenBat;
			var bat4:woodenBat;
			var bat5:woodenBat;
			var bat6:woodenBat;
			var bat7:woodenBat;
			var bat8:woodenBat;
			var whichBat:int;
			
			
			powerFactor = 3*(0.5 + Math.pow(Power,-1));
			
			
			
			function removeBat():void
			{
				if (whichBat == 1)
				{
					removeChild(bat1);
				}
				else if (whichBat == 2)
				{
					removeChild(bat2);
				}
				else if (whichBat == 3)
				{
					removeChild(bat3);
				}
				else if (whichBat == 4)
				{
					removeChild(bat4);
				}
				else if (whichBat == 5)
				{
					removeChild(bat5);
				}
				else if (whichBat == 6)
				{
					removeChild(bat6);
				}
				else if (whichBat == 7)
				{
					removeChild(bat7);
				}
				else if (whichBat == 8)
				{
					removeChild(bat8);
				}
			}
			
			function tweenDoneBat(event:TweenEvent):void
			{
				removeBat();
			}
			
			switch(Number(handDir))
			{
				case 5:
				bat5 = new woodenBat();
				var bat5Tween:Tween = new Tween(bat5, "y", Strong.easeOut, 200, 700, powerFactor, true);
				bat5Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 5;
				bat5.x = 900;
				bat5.y = 200;
				bat5.width = 390;
				bat5.height = 200;
				addChild(bat5);
				break;
				
				case 3:
				bat3 = new woodenBat();
				var bat3Tween:Tween = new Tween(bat3, "x", Strong.easeOut, 200, 1400, powerFactor, true);
				bat3Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 3;
				bat3.x = 200;
				bat3.y = 400;
				bat3.width = 390;
				bat3.height = 200;
				addChild(bat3);
				break;
				
				case 4:
				bat4 = new woodenBat();
				var bat4Tween:Tween = new Tween(bat4, "y", Strong.easeOut, 200, 700, powerFactor, true);
				var bat4Tween2:Tween = new Tween(bat4, "x", Strong.easeOut, 500, 1400, powerFactor, true);
				bat4Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 4;
				bat4.x = 500;
				bat4.y = 200;
				bat4.width = 390;
				bat4.height = 200;
				addChild(bat4);
				break;
				
				case 1:
				bat1 = new woodenBat();
				var bat1Tween:Tween = new Tween(bat1, "y", Strong.easeOut, 700, 200, powerFactor, true);
				bat1Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 1;
				bat1.x = 900;
				bat1.y = 700;
				bat1.width = 390;
				bat1.height = 200;
				bat1.rotation = 180;
				addChild(bat1);
				break;
				
				case 7:
				bat7 = new woodenBat();
				var bat7Tween:Tween = new Tween(bat7, "x", Strong.easeOut, 1400, 200, powerFactor, true);
				bat7Tween.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 7;
				bat7.rotation = 180;
				bat7.x = 1400;
				bat7.y = 400;
				bat7.width = 390;
				bat7.height = 200;
				addChild(bat7);
				break;
				
				case 8:
				bat8 = new woodenBat();
				var bat8Tween:Tween = new Tween(bat8, "y", Strong.easeOut, 700, 200, powerFactor, true);
				var bat8Tween2:Tween = new Tween(bat8, "x", Strong.easeOut, 1400, 500, powerFactor, true);
				bat8Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 6;
				bat8.rotation = 180;
				bat8.x = 1400;
				bat8.y = 700;
				bat8.width = 390;
				bat8.height = 200;
				addChild(bat8);
				break;
				
				case 6:
				bat6 = new woodenBat();
				var bat6Tween:Tween = new Tween(bat6, "y", Strong.easeOut, 200, 700, powerFactor, true);
				var bat6Tween2:Tween = new Tween(bat6, "x", Strong.easeOut, 1400, 500, powerFactor, true);
				bat6Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 6;
				bat6.rotation = 180;
				bat6.x = 1400;
				bat6.y = 200;
				bat6.width = 390;
				bat6.height = 200;
				addChild(bat6);
				break;
				
				case 2:
				bat2 = new woodenBat();
				var bat2Tween:Tween = new Tween(bat2, "y", Strong.easeOut, 700, 200, powerFactor, true);
				var bat2Tween2:Tween = new Tween(bat2, "x", Strong.easeOut, 500, 1400, powerFactor, true);
				bat2Tween2.addEventListener(TweenEvent.MOTION_FINISH, tweenDoneBat);
				whichBat = 2;
				bat2.x = 500;
				bat2.y = 700;
				bat2.width = 390;
				bat2.height = 200;
				bat2.scaleY = -0.7;
				bat2.scaleX = 0.5;
				addChild(bat2);
				break;
			}
		}
		public function genPinataBground():void
		{
			var pinataBground = new PinataBackground();
			pinataBground.x = 0;
			pinataBground.y = 0;
			pinataBground.height = 900;
			pinataBground.width = 1600;
			addChild(pinataBground)
		}
	}
}
	
