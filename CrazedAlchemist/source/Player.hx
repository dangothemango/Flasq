 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class Player extends FlxSprite
 {

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
	}

	override public function update(elapsed:Float):Void{
		super.update(elapsed);
	}
 }