package;

 import flixel.FlxSprite;
 import flixel.addons.util.FlxAsyncLoop;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.util.FlxColor;
 import flixel.FlxObject;
 import flixel.math.FlxPoint;
 import flixel.FlxG;
 import flash.display.BitmapData;
 import flixel.tweens.FlxTween;
 import flixel.group.FlxGroup;
 import flixel.effects.particles.FlxEmitter;

 class PlayerAndBottle extends FlxSprite
 {

 	//This is a utility class for player and bottle, it handles fades and color changes

 	//Helper variables used for Asyncronous color replacement
 	var rCRow:UInt;
 	var rCColumn:UInt;
 	//The color being replaced
 	var rCOrig:UInt;
 	//The new color
 	var rCNew:UInt;
 	public var rCLoop:FlxAsyncLoop;
 	var rCPixels:BitmapData;
 	public var rCCallback:String="none";
 	var coloredPixels:Array<FlxPoint>;
 	var rCPreloaded:Bool=false;

 	var tween:FlxTween;


	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		loadSprite();
		setGraphicSize(0,125);
		updateHitbox();
		setFacingFlip(FlxObject.RIGHT,false,false);
		setFacingFlip(FlxObject.LEFT,true,false);
		
	}


	//a callback for replace color Kinda weird how its implented but it works
	public function rCCallbackDriver(){

		rCCallback="none";
		rCPreloaded=true;
		
	}

	private function tweenFunction(s:FlxSprite, v:Float) { s.alpha = v; }

	function tweenDriver(s:Float,e:Float,?t:Float=2.0){
		if (tween!=null)tween.cancel();
		tween=FlxTween.num(s, e, t, {}, tweenFunction.bind(this));

	}

	function loadSprite(){

	}

	override public function update(elapsed:Float):Void{
		handleMovement();
		super.update(elapsed);
	}

	//this function should be overrided by the player and bottle, which eack do movement differently
	function handleMovement():Void
	{

	}

	//if something isnt preloaded correctly, this will preload it, else it will run the preloaded call asynchronously for speedy color changes
	//its basically just a refactor of replaceColor() but with support for a FlxAsyncLoop()
	public function replaceColorDriver(Color:UInt,NewColor:UInt,mult:Float=(2/3)){
		if (rCLoop != null){
			rCLoop.kill();
			rCLoop.destroy();
		}
		rCColumn=0;
		rCOrig=Color;
		rCNew=NewColor;
		rCPixels=get_pixels();
		if (!rCPreloaded){
			rCRow=Std.int(rCPixels.height*mult);
			rCLoop=new FlxAsyncLoop(rCRow, replaceColorAsync,1);
		}
		else{
			rCRow=0;
			rCLoop=new FlxAsyncLoop(coloredPixels.length, replaceColorPreloaded,500);
		}
	}

	public function replaceColorPreloaded(){
		var pix:FlxPoint=coloredPixels[rCRow];
		rCPixels.setPixel32(Std.int(pix.x),Std.int(pix.y),rCNew);
		rCRow++;
	}

	public function replaceColorAsync():Void
	{
		if (coloredPixels==null){
			coloredPixels=new Array<FlxPoint>();
		}


		var columns:UInt = rCPixels.width;
		var column:UInt = 0;
		while(column < columns)
		{
			if(rCPixels.getPixel32(column,rCRow) == rCOrig)
			{
				rCPixels.setPixel32(column,rCRow,rCNew);
				coloredPixels.push(new FlxPoint(column,rCRow));
			}
			column++;
		}
		rCRow--;
	}

 }