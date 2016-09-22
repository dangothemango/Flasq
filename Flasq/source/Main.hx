package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.FlxG;
import lime.ui.Window;
import flixel.system.scaleModes.PixelPerfectScaleMode;


class Main extends Sprite
{
	//basic setup
	
	public function new()
	{
		super();
		addChild(new FlxGame(960, 720, MenuState, 1, 60,60,true, false));
		stage.resize(960,720);
		FlxG.scaleMode =new PixelPerfectScaleMode();
		
	}
}
