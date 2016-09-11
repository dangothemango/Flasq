package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class Level extends FlxState
{

	var player:Player;

	override public function create():Void
	{
		super.create();
	}

	function addPlayer(?pX:Float=0, ?pY:Float=0){
		player=new Player(pX,pY);
		add(player);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}