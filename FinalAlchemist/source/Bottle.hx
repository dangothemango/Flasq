 package;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

 class Bottle extends PlayerAndBottle
 {

 	//this is THE bottle, the holy grail of recyclable plastic
 	//inherits some utility from Player and bottle, like replace color logic

 	public var attached=false;
 	public var contents:Potion;

 	public function new(X:Float, Y:Float, ?SimpleGraphic:FlxGraphicAsset){
 		super(X,Y,SimpleGraphic);
 		//similarly to in player, a static array is used to make load times that much faster, I could probably keep this in the bottle class, but i didnt and now its too late
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
 		height-=5;
 	}

 	//used to allow the bottle to follow the player, run from player update if bottle is attached
 	public function config(X:Float, Y:Float, animationFrame:Int, direction:Int):Void{
 		x=X;
 		y=Y;
 		animation.frameIndex=animationFrame;
 		facing=direction;
 	}

 	override function loadSprite(){
		loadGraphic("assets/images/bottle.png",true,122,200);
	}

	//resets the potion to an empty bottle with no effects
	public function empty(){
		replaceColorDriver(contents.color,Potion.WHITE);
		contents.kill();
		contents.destroy();
		contents=new PotionWhite();
	}

	//fills the potion with the appropriate drink
	public function fill(p:Potion){
		//the first time you see a potion, get a little hint
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