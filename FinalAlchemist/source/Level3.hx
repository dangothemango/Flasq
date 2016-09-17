package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class Level3 extends Level
{
	override public function create():Void
	{
		super.create();
		loadTiledData("Level03.tmx");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
