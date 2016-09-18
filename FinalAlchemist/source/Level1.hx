package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class Level1 extends Level
{
	override public function create():Void
	{
		super.create();
		loadTiledData("testlevel.tmx");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
