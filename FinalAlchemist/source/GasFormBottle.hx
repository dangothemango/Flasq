 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class GasFormBottle extends Bottle
 {

 	public var done:Bool=false;

 	public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset){
 		super(X,Y,SimpleGraphic);
 		contents=new Potion();
 	}

 	override public function config(X:Float, Y:Float, animationFrame:Int, direction:Int):Void{
 		x=X;
 		y=Y;
 	}

 	override public function update(elapsed:Float){
 		super.update(elapsed);
 		if (done && alpha==0){
 			done=false;
 			Level.instance.remove(this,true);
 		}
 	}

 	override function loadSprite(){
		loadGraphic("assets/images/gasbottle.png",true,122,200);
	}

 }