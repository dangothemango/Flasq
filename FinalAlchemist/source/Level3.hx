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
		loadTiledData("Level03.tmx");
		addPlayer(0,0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
