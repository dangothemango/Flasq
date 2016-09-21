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
 		if (Level.BRCPreloadedArray==null){
			coloredPixels=replaceColor(Potion.BLACK,Potion.BLACK,true);
			Level.BRCPreloadedArray=coloredPixels;
		}
		else {
			coloredPixels=Level.BRCPreloadedArray;
		}
		rCPreloaded=true;
 		contents=new PotionWhite();
 		replaceColorDriver(Potion.BLACK,Potion.WHITE);
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
		replaceColorDriver(contents.color,Potion.WHITE);
		contents.kill();
		contents.destroy();
		contents=new PotionWhite();
	}

	public function fill(p:Potion){
		if (Level.firsts.get("FILL") != null){
			HUD.instance.updateHUD(Level.firsts.get("FILL"));
			Level.firsts.set("FILL",null);
		}
		var tmp:Potion = contents.mix(p);
		if (tmp==contents){ return; }
		replaceColorDriver(contents.color,tmp.color);
		contents.kill();
		contents.destroy();
		contents=tmp;
	}

 }