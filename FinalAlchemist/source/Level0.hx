package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class Level0 extends FlxState
{

	var t:Float=0;

	override public function create():Void
	{
		super.create();
		FlxG.switchState(new Level3());
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

}
