package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class TestState extends FlxState
{

	var player:Player;
	var floor:ImmutableObject;

	override public function create():Void
	{
		super.create();
		player=new Player();
		add(player);
		floor = new ImmutableObject(0,400);
		add(floor);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
