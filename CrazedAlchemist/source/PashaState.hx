package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PashaState extends Level
{

	var floor:ImmutableObject;

	override public function create():Void
	{
		super.create();
		addPlayer(0,0);
		loadTileMap("assets/tilemaps/pashamap.csv","assets/tilemaps/pashamap.png");
		floor=new ImmutableObject(0,400);
		add(floor);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
