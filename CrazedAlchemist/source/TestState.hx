package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class TestState extends Level
{

	var floor:ImmutableObject;

	override public function create():Void
	{
		super.create();
		addPlayer(0,0);
		loadTileMap("assets/tilemaps/testmap.csv","assets/tilemaps/testmap.png");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
