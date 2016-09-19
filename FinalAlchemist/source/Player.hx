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
 import flixel.effects.particles.FlxParticle;

 class Player extends PlayerAndBottle
 {

 	//Movement Varables
 	var left:Bool=false;
 	var right:Bool=false;
 	var dragC:Float=1000;
 	public var defGravity:Float=1000;
 	var walking:Bool;
	var jumping:Bool;
	var falling:Bool;
	var drinking:Bool=false;

	//defaults
	public var defSpeed(default,never):Float=200;
 	public var defJumpSpeed(default,never):Float=500;
 	var jumpSpeed:Float;

	//flasq helpers
	public var colorCallback:UInt=null;

	public var hatColor:UInt=0xFF000000;

 	public var bottle:Bottle;

 	var status:String;

 	//Status helper objects
 	public var emitter:FlxTypedEmitter<FlxParticle>;


	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		animation.add("walk",[for (i in 1...24) i],30,true);
		animation.add("jump",[24,25,26,27,28],30,false);
		animation.add("drink",[for (i in 29...46) i],30,false);
		drag.x=dragC;
		setDefaults();
	}

	//Emitter Helpers
	function configRedEmit(){
		emitter = new FlxTypedEmitter<FlxParticle>(x+width/2,y+height/5);
		emitter.solid=true;
		emitter.loadParticles("assets/images/fire.png",500);
	}

	function configPurpleEmit(){

	}

	function configOrangeEmit(){

	}

	public function getStatus(){
		return status;
	}

	public function setStatus(s:String,c:UInt){
		clearEffects(c);
		status=s;
	}

	function clearEffects(c:UInt){
		setDefaults();
		if (emitter!=null){emitter.destroy(); emitter=null;}
		becomeVisible(c);
	}

	//Potion Helper Functions

	public function setHatColor(c:UInt){
		replaceColorDriver(hatColor,c,1/2);
		hatColor=c;
	}

	public function setGravity(g:Float){
		acceleration.y=g;
	}

	public function setSpeeds(j:Float,s:Float){
		jumpSpeed=j;
		maxVelocity.x=s;
	}

	public function setDefaults(){
		status="white";
		setSpeeds(defJumpSpeed,defSpeed);
 		setGravity(defGravity);
	}

	public function becomeVisible(c:UInt){
		tweenDriver(alpha,1.0);
		bottle.tweenDriver(alpha,1.0);
	}

	public function startEmitter(){
		switch (status){
			case "red":
				emitter.start(false,.01);
			case "purple":

			case "orange":

			default:
		}
	}

	public function lightFire(){
		configRedEmit();
	}

	override function loadSprite(){
		loadGraphic("assets/images/player.png",true,122,200);
	}

	override public function update(elapsed:Float):Void{
		if (colorCallback!=null && alpha==1.0){
			setHatColor(colorCallback);
			colorCallback=null;
		}
		super.update(elapsed);
		configBottle();
		emitterFollow();
	}

	function emitterFollow(){
		if (emitter==null) return;
		emitter.x=x+width/2;
		emitter.y=y+width/5;
	}

	public function fillBottle(p:Potion){
		if (bottle==null) return;
		bottle.fill(p);
	}

	override function handleMovement():Void
	{

		if (drinking){
			if (animation.finished) { 
				drinking=false; 
				if (bottle!=null) bottle.contents.drink(this);
			}
			return;
		}

		left=FlxG.keys.anyPressed([LEFT,A]);
		right=FlxG.keys.anyPressed([RIGHT,D]);

		if(left&&right){
			left=right=false;
		}
		if (left){
			acceleration.x=-dragC;
			facing=FlxObject.LEFT;
			walking=true;
		} else if (right){
			acceleration.x=dragC;
			facing=FlxObject.RIGHT;
			walking=true;
		} else {
			acceleration.x=0;
			if (velocity.x==0){
				walking=false;
			}
		}
		
		if ((FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP) && isTouching(FlxObject.DOWN)){
			velocity.y=-jumpSpeed;
			jumping=true;
		}
		if (!isTouching(FlxObject.DOWN)){
			falling=true;
		} else {falling=false;}
		if (!falling && FlxG.keys.justPressed.F){
			drink();
			return;
		}
		
		if (jumping){
			animation.play("jump");
			jumping=false;
		} else if (falling){
			if (animation.name != "jump" || animation.finished){
				animation.stop();
				animation.frameIndex=28;
			}
		} else if (walking){
			animation.play("walk");
		} else {
			animation.stop();
			animation.frameIndex=0;
		}
	}

	function configBottle(){
		if (bottle==null) return;
		var anim:Int=animation.frameIndex;
		if (status=="purple"){
			trace ("TODO: Purple Bottle Animation");
		}
		bottle.config(x,y,anim,facing);
	}

	public function drink(){
		animation.stop();
		animation.play("drink");
		drinking=true;
		acceleration.x=0;
	}

	override public function rCCallbackDriver(){
		switch (rCCallback){
			case "invisible":
				tweenDriver(alpha,0.4);
				bottle.tweenDriver(alpha,0.4);
			default:
		}
		super.rCCallbackDriver();
	}

 }