package  {
	import com.greensock.TimelineLite
	import com.greensock.TweenLite
	import flash.display.CapsStyle
	import flash.display.Graphics
	import flash.display.Sprite
	import flash.display.MovieClip
	import flash.geom.Point
	import fl.motion.easing.Linear
	import flash.text.TextField
	import flash.text.TextFormat
	import flash.text.TextFormatAlign
	import flash.text.Font
	
	public class GraphingPro extends MovieClip
	{
		public function GraphingPro()
		{
			var examp:Array = [
				{Day:12, Month:4, Yr:2013, YVal:33},
				{Day:13, Month:4, Yr:2013, YVal:34},
				{Day:14, Month:4, Yr:2013, YVal:38},
				{Day:15, Month:4, Yr:2013, YVal:37},
				{Day:16, Month:4, Yr:2013, YVal:40},
				{Day:17, Month:4, Yr:2013, YVal:42},
				{Day:18, Month:4, Yr:2013, YVal:44},
				{Day:19, Month:4, Yr:2013, YVal:48},
				{Day:20, Month:4, Yr:2013, YVal:50},
				{Day:21, Month:4, Yr:2013, YVal:53},
				{Day:22, Month:4, Yr:2013, YVal:55},
				{Day:23, Month:4, Yr:2013, YVal:56},
			]
			GraphProfile(examp,100,300,350,200,true);
		}
		public function GraphProfile(PatData:Array, ch_xst:Number, ch_yst:Number, ch_xlen:Number, ch_ylen:Number, nrm:Boolean) 
		{
			
			var presetTimeline:TimelineLite = new TimelineLite();
 			var presetLines_mc = new Sprite();
			
			var ch_xincr:Number = ch_xlen/PatData.length;
			var ch_yincr:Number;
			
			var max_Y:Number = 0;
			
			if (nrm === true)
			{
				for each (var mxcnt:Object in PatData)
				{
					if (mxcnt.YVal > max_Y)
					{
						max_Y = mxcnt.YVal;
					}
				}
				
			}
			else
			{
				max_Y = 75;
			}
			
			ch_yincr = ch_ylen/max_Y;
			
			var axis:Sprite = new Sprite;
			axis.graphics.lineStyle(2);
			axis.graphics.moveTo(ch_xst,ch_yst);
			axis.graphics.lineTo(ch_xst,ch_yst - ch_ylen - 30);
			axis.graphics.moveTo(ch_xst,ch_yst);
			axis.graphics.lineTo(ch_xst + ch_xlen + 20,ch_yst);
			addChild(axis);
			
			var axisFont:mFont = new mFont();
			
			var xmarks:int = 5;
			var Fmtx:TextFormat = new TextFormat(axisFont.fontName, 12);
			Fmtx.align = TextFormatAlign.CENTER;
			var xmk_inc:Number = Math.floor(PatData.length/xmarks);
			for (var i:int=0; i < Math.floor(PatData.length/xmk_inc); i++)
			{
				var lblx:TextField = new TextField();
				lblx.defaultTextFormat = Fmtx;
				lblx.text = String(PatData[i*xmk_inc].Month) + "/" + String(PatData[i*xmk_inc].Day);
				lblx.x = ch_xst + i*xmk_inc*ch_xincr;
				lblx.y = ch_yst + 30;
				lblx.width = 30;
				lblx.height = 20;
				lblx.embedFonts = true;
				lblx.rotation = -90;
				addChild(lblx);
			}
			
			var ymarks:int = 5;
			var Fmty:TextFormat = new TextFormat(axisFont.fontName, 24);
			Fmty.align = TextFormatAlign.RIGHT;
			for (var j:int=0; j < (ymarks +2); j++)
			{
				var lbly:TextField = new TextField();
				lbly.defaultTextFormat = Fmty;
				lbly.text = String(j*Math.floor(max_Y/ymarks)) + " -";
				lbly.x = ch_xst - 90;
				lbly.y = ch_yst - 18 - j*Math.floor(max_Y/ymarks)*ch_yincr;
				addChild(lbly);
				
			}
			
			presetTimeline.pause();
			
 			var lp:Point;
 			var _idx:int=0;
 			for each (var obj:Object in PatData)
			{
				if (_idx===0)
				{
					lp = new Point(ch_xst + ch_xincr/2, ch_yst - obj.YVal*ch_yincr);
				}
				else
				{
					var dx:Number = ch_xst + ch_xincr/2 + ch_xincr*_idx - lp.x;
					var dy:Number = ch_yst - obj.YVal*ch_yincr - lp.y;
					var radians:Number = Math.atan2(dy ,dx);
					var angle:Number = (radians/Math.PI)*180;
					var leng:Number = Math.sqrt(dx * dx + dy * dy); // (a^2 + b^2 = c^2)
					var line_mc:Sprite = new Sprite();
					line_mc.graphics.lineStyle(3, 0x990000, 1, true, "none", CapsStyle.ROUND);
					line_mc.graphics.lineTo(leng, 0);
					line_mc.x = lp.x;
					line_mc.y = lp.y;
		 			line_mc.rotation = angle;
				 	presetLines_mc.addChild(line_mc);
		 			var time:Number = .3 * (leng/40);
		 			presetTimeline.append(TweenLite.from(line_mc, time, {scaleX: 0, ease:Linear.easeNone}));
		 			lp = new Point(ch_xst + ch_xincr/2 + ch_xincr*_idx, ch_yst - obj.YVal*ch_yincr);
				}
				_idx++
			}
			presetTimeline.play();
			addChild(presetLines_mc)
		}

	}
	
}
