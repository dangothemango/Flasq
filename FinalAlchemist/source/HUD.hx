package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxAxes;

class HUD extends FlxTypedGroup<FlxSprite>
{
	static public var instance:HUD;
	
	private var _infoBox:FlxSprite;
	private var _infoText:FlxText;
	private var _continueText:FlxText;

	public function new()
	{
		super();
		instance=this;
		var sixthWidth = Std.int(FlxG.width / 6);
		var sixthHeight = Std.int(FlxG.height / 6);
		
		_infoBox = new FlxSprite(sixthWidth, 4 * sixthHeight).makeGraphic(4 * sixthWidth, sixthHeight, FlxColor.WHITE);
		_infoBox.drawRect(5, 5, 4 * sixthWidth - 10, sixthHeight - 10, FlxColor.GRAY);
		
		_infoText = new FlxText(sixthWidth + 10, 4 * sixthHeight + 5, 0, "WELCOME PLAYER", 12);
		_infoText.setBorderStyle(SHADOW, FlxColor.BLACK, 1, 1);
		_infoText.alignment = CENTER;
		_infoText.screenCenter(FlxAxes.X);
		
		_continueText = new FlxText(4*sixthWidth, 5 * sixthHeight - 30, 0, "Press Enter to Continue", 8);
		
		add(_infoBox);
		add(_infoText);
		add(_continueText);
		forEach(function(spr:FlxSprite){
			spr.scrollFactor.set(0, 0);
			spr.alpha = 0;
		});
	}

	public function hideHUD():Void{
		forEach(function(spr:FlxSprite){
			spr.alpha = 0;
		});
	}
	
	public function updateHUD(infoText:String):Void{
		_infoText.text = infoText;
		_infoText.alignment = CENTER;
		_infoText.screenCenter(FlxAxes.X);
		forEach(function(spr:FlxSprite){
			spr.alpha = 1;
		});
    }
}