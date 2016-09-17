package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.FlxG;
import flixel.system.scaleModes.FillScaleMode;


class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(1900, 1080, MenuState, 1, 60,60,false, true));
	}
}
