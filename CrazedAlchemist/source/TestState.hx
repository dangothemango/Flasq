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
	var blech:TestObject;

	override public function create():Void
	{
		super.create();
		loadTileMap("assets/tilemaps/testmap.csv","assets/tilemaps/testmap.png");
		floor=new ImmutableObject(0,400);
		add(floor);
		blech=new TestObject(26*16,10*16,4*16,4*16);
		interactables.add(blech);
		add(blech);
		addPlayer(0,0);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
