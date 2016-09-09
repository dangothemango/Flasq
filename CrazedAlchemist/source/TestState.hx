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

	override public function create():Void
	{
		super.create();
		player=new Player();
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
