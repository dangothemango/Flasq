 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class Player extends FlxSprite
 {

 	//Movement Varables
 	var left:Bool=false;
 	var right:Bool=false;
 	var dragC:Float=1000;
 	var gravity:Float=1000;

 	var speed:Float=200;
 	var jumpSpeed:Float=500;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(100,114,FlxColor.RED);
		drag.x=drag.y=dragC;
		acceleration.y=gravity;
		maxVelocity.x=speed;
	}

	override public function update(elapsed:Float):Void{
		handleMovement();
		super.update(elapsed);
	}

	function handleMovement():Void
	{
		left=FlxG.keys.anyPressed([LEFT,A]);
		right=FlxG.keys.anyPressed([RIGHT,D]);

		if(left&&right){
			left=right=false;
		}
		if (left){
			acceleration.x=-dragC;
		} else if (right){
			acceleration.x=dragC;
		} else {
			acceleration.x=0;
		}
		if ((FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) && isTouching(FlxObject.DOWN)){
			velocity.y=-jumpSpeed;
		}
	}

 }