package  {
	import flash.events.*;
	import flash.display.*;
	import flash.filesystem.*;
	import flash.text.*;
	import fl.display.ProLoader;
	import flash.net.URLRequest;
	import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
	import flash.desktop.InteractiveIcon;
	import flash.events.NativeProcessExitEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.media.Sound;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
	
	public class menuNav extends MovieClip{
		public function menuNav()
		{
			loadMenus();
			createBackground();
		}
		
		public var mmButton1:normalbutton = new normalbutton();
		public var mmButton2:normalbutton = new normalbutton();
		public var mmButton3:normalbutton = new normalbutton();
		public var backbutton:backBtn = new backBtn();
		public var bground:menuBground;
		public var numberOfGames:int = 4;
		public var Game0:String = ("Fish");
		public var Game1:String = ("Bamboo");
		public var Game2:String = ("Pinata");
		public var Game3:String = ("Punting");
		public var whichGame:int;
		
		
		public function destroyMe(object:*):void 
		{
			if(object.parent != null)
			{
				var parent:DisplayObjectContainer = object.parent;
				parent.removeChild(object);
			}
		}
		
		public function createBackground():void
		{
			bground = new menuBground();
			addChild(bground)
			bground.x = 800;
			bground.y = 450;
			setChildIndex(bground,0)
			addEventListener("unloadMainBground", unloadMainBground)
		}
		
		public function unloadMainBground(event:Event):void
		{
			 removeChild(bground)
			 removeEventListener("unloadMainBground", unloadMainBground)
		}
		
		public function mainMenu():void
		{
			var profilesTxt:profilesText = new profilesText();
			var playTxt:playText = new playText();
			var settingsTxt:settingsText = new settingsText();
			addChild(profilesTxt)
			addChild(settingsTxt)
			addChild(playTxt)
			profilesTxt.x = 350;
			profilesTxt.y = 400;
			settingsTxt.x = 800;
			settingsTxt.y = 400;
			playTxt.x = 1250;
			playTxt.y = 400;
			setChildIndex(profilesTxt,2);
			setChildIndex(settingsTxt,2);
			setChildIndex(playTxt,2);
			mmButton1.addEventListener(MouseEvent.CLICK, removeMain)
			mmButton2.addEventListener(MouseEvent.CLICK, removeMain)
			mmButton3.addEventListener(MouseEvent.CLICK, removeMain)
			function removeMain(event:MouseEvent):void
			{
				destroyMe(profilesTxt)
				destroyMe(settingsTxt)
				destroyMe(playTxt)
				mmButton1.removeEventListener(MouseEvent.CLICK, removeMain)
				mmButton2.removeEventListener(MouseEvent.CLICK, removeMain)
				mmButton3.removeEventListener(MouseEvent.CLICK, removeMain)
			}
		}
		public function setsMenu():void
		{
			var videoTxt:videoText = new videoText();
			var soundTxt:soundText = new soundText();
			var preferencesTxt:preferencesText = new preferencesText();
			addChild(videoTxt)
			addChild(soundTxt)
			addChild(preferencesTxt)
			videoTxt.x = 350;
			videoTxt.y = 400;
			soundTxt.x = 800;
			soundTxt.y = 400;
			preferencesTxt.x = 1250;
			preferencesTxt.y = 400;
			setChildIndex(videoTxt,2)
			setChildIndex(soundTxt,2)
			setChildIndex(preferencesTxt,2)
			mmButton1.addEventListener(MouseEvent.CLICK, removeSets)
			mmButton2.addEventListener(MouseEvent.CLICK, removeSets)
			mmButton3.addEventListener(MouseEvent.CLICK, removeSets)
			backbutton.addEventListener(MouseEvent.CLICK, removeSets)
			function removeSets(event:MouseEvent):void
			{
				destroyMe(videoTxt);
				destroyMe(soundTxt);
				destroyMe(preferencesTxt);
				mmButton1.removeEventListener(MouseEvent.CLICK, removeSets)
				mmButton2.removeEventListener(MouseEvent.CLICK, removeSets)
				mmButton3.removeEventListener(MouseEvent.CLICK, removeSets)
				backbutton.removeEventListener(MouseEvent.CLICK, removeSets)
			}
		}
		public function playMenu():void
		{
			var CGothic = new CGothic();
			var playTextFormat:TextFormat = new TextFormat();
			playTextFormat.size = 20;
			playTextFormat.align = TextFormatAlign.CENTER;
			playTextFormat.font = CGothic.fontName;
			
			var textArray:Array = new Array();
			var buttonArray:Array = new Array();
			
			for (var i:int = 0; i < numberOfGames; i++)
			{
				var tempText = new TextField();
				var tempBut:normalbutton = new normalbutton();
				
				tempText.defaultTextFormat = playTextFormat;
				tempText.text = (this["Game" + i.toString()]);
				
				if (i < 3)
				{
					tempText.x = 400 * (i+1);
					tempText.y = 225;
					
					tempBut.x = 400 * (i+1);
					tempBut.y = 225;
				}
				else if (i >= 3 && i < 6)
				{
					tempText.x = 400 * (i-2);
					tempText.y = 450;
					
					tempBut.x = 400 * (i-2);
					tempBut.y = 450;
				}
				else if (i >=6 && i < 10)
				{
					tempText.x = 400 * (i-5);
					tempText.y = 675;
					
					tempBut.x = 400 * (i-5);
					tempBut.y = 675;
				}

				tempText.autoSize = TextFieldAutoSize.LEFT;
				tempBut.addEventListener(MouseEvent.CLICK, removePlay);
				
				addChild(tempText);
				addChild(tempBut);
				
				setChildIndex(tempBut,2);
				setChildIndex(tempText,1);
				
				textArray[i] = tempText;
				buttonArray[i] = tempBut;
				
				buttonArray[i].addEventListener(MouseEvent.CLICK, whichGame = i);
				buttonArray[i].addEventListener(MouseEvent.CLICK, gameOptionsMenu);
			}
			
			function removePlay(event:MouseEvent):void
			{
				for (var i:int = 0; i < numberOfGames; i++)
				{
					tempBut.removeEventListener(MouseEvent.CLICK, removePlay);
					destroyMe(textArray[i]);
					destroyMe(buttonArray[i]);
				}
			}
		}
		
		public function gameOptionsMenu(event:MouseEvent):void
		{
			var CGothic = new CGothic();
			var gameOptionsFormat:TextFormat = new TextFormat();
			gameOptionsFormat.size = 20;
			gameOptionsFormat.align = TextFormatAlign.CENTER;
			gameOptionsFormat.font = CGothic.fontName;
			
			switch (whichGame)
			{
				case 1: //Bamboo Game
				var optionsArray:Array = new Array();
				optionsArray = [0, 0, 0, 0];
				
				var specialOptions:Shape = new Shape;
				specialOptions.graphics.beginFill(0xFF0000); 
				specialOptions.graphics.drawRect(200, 200, 100,100);
				specialOptions.graphics.endFill();
				addChild(specialOptions); 
				
				var specialOptionsText = new TextField();
				specialOptionsText.defaultTextFormat = gameOptionsFormat;
				specialOptionsText.text = ("Special Game Options");
				specialOptionsText.autoSize = TextFieldAutoSize.LEFT;
				addChild(specialOptionsText);
				
				var whichSide:Shape = new Shape;
				whichSide.graphics.beginFill(0xFF0000); 
				whichSide.graphics.drawRect(500, 200, 100,100); 
				whichSide.graphics.endFill();
				addChild(whichSide);
				
				var whichSideText = new TextField();
				whichSideText.defaultTextFormat = gameOptionsFormat;
				whichSideText.text = ("Which Side of the Body?");
				whichSideText.autoSize = TextFieldAutoSize.LEFT;
				addChild(whichSideText);
				
				specialOptions.addEventListener(MouseEvent.MOUSE_OVER, optionsDropdown);
				
				
				function optionsDropdown(e:Event):void
				{
					var left:Shape = new Shape;
					left.graphics.beginFill(0xFF0000); 
					left.graphics.drawRect(200, 300, 100,100);
					left.graphics.endFill();
					addChild(left);
					left.addEventListener(MouseEvent.CLICK, selectLeft);
					function selectLeft(e:Event):void
					{
						left.graphics.beginFill(0xFFFFFF); 
						left.graphics.endFill();
						optionsArray[0] = 1;
					}
					
					var leftText = new TextField();
					leftText.defaultTextFormat = gameOptionsFormat;
					leftText.text = ("Movement to the Left");
					leftText.autoSize = TextFieldAutoSize.LEFT;
					leftText.x = 200;
					leftText.y = 300;
					addChild(leftText);
					
					var right:Shape = new Shape;
					right.graphics.beginFill(0xFF0000); 
					right.graphics.drawRect(200, 400, 100,100);
					right.graphics.endFill();
					addChild(right);
					right.addEventListener(MouseEvent.CLICK, selectRight);
					function selectRight(e:Event):void
					{
						right.graphics.beginFill(0xFFFFFF); 
						right.graphics.endFill();
						optionsArray[1] = 1;
					}
					
					var rightText = new TextField();
					rightText.defaultTextFormat = gameOptionsFormat;
					rightText.text = ("Movement to the Right");
					rightText.autoSize = TextFieldAutoSize.LEFT;
					rightText.x = 200;
					rightText.y = 400;
					addChild(rightText);
					
					var up:Shape = new Shape;
					up.graphics.beginFill(0xFF0000); 
					up.graphics.drawRect(200, 500, 100,100);
					up.graphics.endFill();
					addChild(up);
					up.addEventListener(MouseEvent.CLICK, selectUp);
					function selectUp(e:Event):void
					{
						up.graphics.beginFill(0xFFFFFF); 
						up.graphics.endFill();
						optionsArray[2] = 1;
					}
					
					var upText = new TextField();
					upText.defaultTextFormat = gameOptionsFormat;
					upText.text = ("Upward Movement");
					upText.autoSize = TextFieldAutoSize.LEFT;
					upText.x = 200;
					upText.y = 500;
					addChild(upText);
					
					var down:Shape = new Shape;
					down.graphics.beginFill(0xFF0000); 
					down.graphics.drawRect(200, 600, 100,100);
					down.graphics.endFill();
					addChild(down);
					down.addEventListener(MouseEvent.CLICK, selectDown);
					function selectDown(e:Event):void
					{
						down.graphics.beginFill(0xFFFFFF); 
						down.graphics.endFill();
						optionsArray[3] = 1;
					}
					
					
					var downText = new TextField();
					downText.defaultTextFormat = gameOptionsFormat;
					downText.text = ("Downward Movement");
					downText.autoSize = TextFieldAutoSize.LEFT;
					downText.x = 200;
					downText.y = 600;
					addChild(downText);

					var normal:Shape = new Shape;
					normal.graphics.beginFill(0xFF0000); 
					normal.graphics.drawRect(200, 700, 100,100);
					normal.graphics.endFill();
					addChild(normal);
					normal.addEventListener(MouseEvent.CLICK, selectNormal);
					function selectNormal(e:Event):void
					{
						normal.graphics.beginFill(0xFFFFFF); 
						normal.graphics.endFill();
						down.graphics.beginFill(0xFF0000); 
						down.graphics.endFill();
						up.graphics.beginFill(0xFF0000); 
						up.graphics.endFill();
						left.graphics.beginFill(0xFF0000); 
						left.graphics.endFill();
						right.graphics.beginFill(0xFF0000); 
						right.graphics.endFill();
						optionsArray[3] = 0;
						optionsArray[2] = 0;
						optionsArray[1] = 0;
						optionsArray[0] = 0;
					}
					
					var normalText = new TextField();
					normalText.defaultTextFormat = gameOptionsFormat;
					normalText.text = ("Movement in all Directions");
					normalText.autoSize = TextFieldAutoSize.LEFT;
					normalText.x = 200;
					normalText.y = 700;
					addChild(normalText);
					
				}
				
				break;
				
				case 2:
				break;
			}
			
		}
		
		public function playFish():void
		{
			
			var fishLoader:ProLoader;
			fishLoader = new ProLoader();
			fishLoader.load(new URLRequest("FishGame.swf"));
			fishLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fishListener);
			addChild(fishLoader);
			
			function fishListener(event:Event)
			{
				MovieClip(event.currentTarget.content).addEventListener("eventTriggered", fishUnloader);
			}
			
			function fishUnloader(event:Event):void
			{
				fishLoader.unload();
				removeChild(fishLoader);
				fishLoader = null;
				loadMenus();
				createBackground();
			}
			
		}
		public function createProf():void
		{
			var enterNameText:TextField = new TextField();
			enterNameText.text = ("Enter Name Here:")
			enterNameText.x = 700;
			enterNameText.y = 450;
			addChild(enterNameText);
			
			var enterName:TextField = new TextField();
			enterName.border = true;
			enterName.width = 200;
			enterName.height = 40;
			enterName.x = 700;
			enterName.y = 540;

			enterName.type = "input";
			enterName.background = true;
			enterName.backgroundColor = 155;
			addChild(enterName);
			
			var enterAbilityLevel:TextField = new TextField();
			enterAbilityLevel.border = true;
			enterAbilityLevel.width = 200;
			enterAbilityLevel.height = 40;
			enterAbilityLevel.x = 100;
			enterAbilityLevel.y = 540;
			enterAbilityLevel.type = "input";
			enterAbilityLevel.background = true;
			enterAbilityLevel.backgroundColor = 155;
			addChild(enterAbilityLevel);
			
			var enterNameDoneBtn:enterNameDone = new enterNameDone();
			addChild(enterNameDoneBtn);
			enterNameDoneBtn.x = 1250;
			enterNameDoneBtn.y = 540;
			enterNameDoneBtn.addEventListener(MouseEvent.CLICK,fl_WriteFileHandler_2);
			
			function fl_WriteFileHandler_2(event:Event):void
			{
				var Name:String = enterName.text;
				var abLevel:int = Number(enterAbilityLevel.text);
				var fl_FileDataToSave_2:String = (Name+"\n"+abLevel);
				var fl_SaveFileStream_2:FileStream = new FileStream();
				var profilesTextFile:File = File.documentsDirectory;
				profilesTextFile = profilesTextFile.resolvePath("PTF"+Name+".txt")
				fl_SaveFileStream_2 = new FileStream();
				fl_SaveFileStream_2.openAsync(profilesTextFile, FileMode.WRITE);
				fl_SaveFileStream_2.writeMultiByte(fl_FileDataToSave_2, File.systemCharset);
			
				fl_SaveFileStream_2.close();
			}

		}
		public function editProfs():void
		{
			
		}
		public function checkProgress():void
		{
			
		}
		public function loadProfile():void
		{
			
		}
		public function profsMenu():void
		{
			var editProfilesTxt:editProfilesText = new editProfilesText();
			var checkProgressTxt:checkProgressText = new checkProgressText();
			var createProfileTxt:createProfileText = new createProfileText();
			addChild(editProfilesTxt)
			addChild(checkProgressTxt)
			addChild(createProfileTxt)
			editProfilesTxt.x = 350;
			editProfilesTxt.y = 400;
			checkProgressTxt.x = 800;
			checkProgressTxt.y = 400;
			createProfileTxt.x = 1250;
			createProfileTxt.y = 400;
			setChildIndex(editProfilesTxt,2);
			setChildIndex(checkProgressTxt,2);
			setChildIndex(createProfileTxt,2);
			mmButton1.addEventListener(MouseEvent.CLICK, removeProfs)
			mmButton2.addEventListener(MouseEvent.CLICK, removeProfs)
			mmButton3.addEventListener(MouseEvent.CLICK, removeProfs)
			backbutton.addEventListener(MouseEvent.CLICK, removeProfs)
			function removeProfs():void
			{
				destroyMe(editProfilesTxt)
				destroyMe(checkProgressTxt)
				destroyMe(createProfileTxt)
				mmButton1.removeEventListener(MouseEvent.CLICK, removeProfs)
				mmButton2.removeEventListener(MouseEvent.CLICK, removeProfs)
				mmButton3.removeEventListener(MouseEvent.CLICK, removeProfs)
				backbutton.removeEventListener(MouseEvent.CLICK, removeProfs)
			}
		}
		
		public function loadMenus():void
		{
			var whichMenu:Array = [1,1,1];
			var whichClicked:int = 1;
			var menuCloud:cloud = new cloud();
			
			mmButton1.addEventListener(MouseEvent.CLICK,clicked1)
			
			mmButton2.addEventListener(MouseEvent.CLICK,clicked2)
			
			mmButton3.addEventListener(MouseEvent.CLICK,clicked3)
			
			backbutton.addEventListener(MouseEvent.CLICK,back)
			
			mainMenu();
			
			addChild(mmButton1);
			mmButton1.x = 350;
			mmButton1.y = 400;
			
			addChild(mmButton2);
			mmButton2.x = 800;
			mmButton2.y = 400;
			
			addChild(backbutton);
			backbutton.x = 800;
			backbutton.y = 600;
		
			addChild(mmButton3);
			mmButton3.x = 1250;
			mmButton3.y = 400;
				
			setChildIndex(mmButton1,3);
			setChildIndex(mmButton2,3);
			setChildIndex(mmButton3,3);
			setChildIndex(backbutton,3);
			
			addChild(menuCloud);
			menuCloud.x = 800;
			menuCloud.y = 450;
			setChildIndex(menuCloud,1);
			
			function exitMenu():void
			{
				removeChild(mmButton3);
				removeChild(mmButton2);
				removeChild(mmButton1);
				removeChild(menuCloud);
				removeChild(backbutton);
				dispatchEvent(new Event("unloadMainBground"));
			}
			
			function clicked1(event:MouseEvent):void
			{
				if (whichMenu[0] < 3)
				{
					whichMenu[0]++;
					whichClicked = 1;
					genMenu();
				}
			}
			
			function clicked2(event:MouseEvent):void
			{
				if (whichMenu[1] < 3)
				{
					whichMenu[1]++;
					whichClicked = 2;
					genMenu();
				}
			}
			function clicked3(event:MouseEvent):void
			{
				if (whichMenu[2] < 3)
				{
					whichMenu[2]++;
					whichClicked = 3;
					genMenu();
				}
			}
			
			function back(event:MouseEvent):void
			{
				if (whichMenu[0] == 1 && whichMenu[1] == 1 && whichMenu[2] == 2)
				{
					whichMenu = [1,1,1];
					dispatchEvent(new Event("removeBack"));
					genMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 1)
				{
					whichMenu = [1,1,1];
					dispatchEvent(new Event("removeBack"));
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 1)
				{
					whichMenu = [1,1,1];
					dispatchEvent(new Event("removeBack"));
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 2 && whichClicked == 3)
				{
					whichMenu = [2,1,1];
					whichClicked = 1;
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 2 && whichClicked == 1)
				{
					whichMenu = [1,1,2];
					whichClicked = 3;
					genMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 2 && whichClicked == 2)
				{
					whichMenu = [1,1,2];
					whichClicked = 3;
					genMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 2 && whichClicked == 3)
				{
					whichMenu = [1,2,2];
					whichClicked = 2;
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 2 && whichMenu[2] == 1 && whichClicked == 1)
				{
					whichMenu = [1,2,1];
					whichClicked = 2;
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 2 && whichMenu[2] == 1 && whichClicked == 2)
				{
					whichMenu = [2,1,1];
					whichClicked = 1;
					genMenu();
				}
			}

			function genMenu():void
			{
				trace(whichMenu)
				if (whichMenu[0] == 1 && whichMenu[1] == 1 && whichMenu[2] == 1)
				{
					mainMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 1)
				{
					profsMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 1)
				{
					setsMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 1 && whichMenu[2] == 2)
				{
					playMenu();
					removeChild(mmButton3);
					removeChild(mmButton2);
					removeChild(mmButton1);
				}
				else if (whichMenu[0] == 3 && whichMenu[1] == 1 && whichMenu[2] == 1)
				{
					editProfs();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 1 && whichMenu[2] == 3)
				{
					exitMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 3 && whichMenu[2] == 1)
				{
					whichMenu[1]--;
					genMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 2 && whichClicked == 1)
				{
					playFish();
					exitMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 1 && whichMenu[2] == 2 && whichClicked == 3)
				{
					createProf();
					exitMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 2 && whichMenu[2] == 1 && whichClicked == 2)
				{
					checkProgress();
					exitMenu();
				}
				else if (whichMenu[0] == 2 && whichMenu[1] == 2 && whichMenu[2] == 1 && whichClicked == 1)
				{
					whichMenu[0]--;
					genMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 2 && whichClicked == 3)
				{
					whichMenu[2]--;
					genMenu();
				}
				else if (whichMenu[0] == 1 && whichMenu[1] == 2 && whichMenu[2] == 2 && whichClicked == 2)
				{
					whichMenu[1]--;
					genMenu();
				}
			}
		}
	}
}
