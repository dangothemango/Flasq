 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class Bottle extends PlayerAndBottle
 {

 	public var attached=false;
 	public var contents:Potion;

 	public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset){
 		super(X,Y,SimpleGraphic);
 		contents=new Potion();
 	}

 	public function config(X:Float, Y:Float, animationFrame:Int, direction:Int):Void{
 		x=X;
 		y=Y;
 		animation.frameIndex=animationFrame;
 		facing=direction;
 	}

 	override function loadSprite(){
		loadGraphic("assets/images/bottle.png",true,122,200);
	}

	public function empty(){
		replaceColorDriver(contents.color,Potion.BLACK);
		contents.kill();
		contents.destroy();
		contents=new Potion();
	}

	public function fill(p:Potion){
		var tmp:Potion = contents.mix(p);
		if (tmp==contents){ return; }
		replaceColorDriver(contents.color,tmp.color);
		contents.kill();
		contents.destroy();
		contents=tmp;
	}

 }