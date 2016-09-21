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

	//this is the player super class, it handles all of the input and most of the color funcitonality

 	//Movement Varables
 	var left:Bool=false;
 	var right:Bool=false;
 	var walking:Bool;
	var jumping:Bool;
	var falling:Bool;
	var drinking:Bool=false;

	//defaults movement constaants
 	var dragC:Float=1000;
 	public var defGravity:Float=1000;
	public var defSpeed(default,never):Float=200;
 	public var defJumpSpeed(default,never):Float=500;
 	var jumpSpeed:Float;

	//flasq helpers
	public var colorCallback:UInt=null;
	public var hatColor:UInt=0xFF000000;
 	public var bottle:Bottle;

 	//current color
 	var status:String;

 	//if the player is in the elevator they cant move
 	public var inElevator:Bool=true;

 	//Status helper objects
 	public var emitter:FlxTypedEmitter<FlxParticle>;
 	public var emitterGroup:FlxTypedGroup<FlxTypedEmitter<FlxParticle>>;


	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);
		//performance array preload for replace color
		if (Level.PRCPreloadedArray==null){
			coloredPixels=replaceColor(Potion.BLACK,Potion.BLACK,true);
			Level.PRCPreloadedArray=coloredPixels;
		}
		else {
			coloredPixels=Level.PRCPreloadedArray;
		}
		rCPreloaded=true;
		animation.add("walk",[for (i in 1...24) i],30,true);
		animation.add("jump",[24,25,26,27,28],30,false);
		animation.add("drink",[for (i in 29...46) i],30,false);
		drag.x=dragC;
		emitterGroup= new FlxTypedGroup<FlxTypedEmitter<FlxParticle>>();
		setDefaults();
	}

	//YOU HAVE TO ADD THE EMITTER BEFORE THE BOTTLE BUT AFTER THE PLAYER SO THE DRAW ORDER IS CORRECT
	public function addBottle():Bottle{
		bottle=new Bottle(x,y);
		Level.instance.add(emitterGroup);
		return bottle;
	}

	public function attachBottle(b:Bottle):Bottle{
		HUD.instance.updateHUD("You pick up the bottle. It is full of water.\nPress F to drink");
		bottle=b;
		Level.instance.add(emitterGroup);

		return bottle;
	}

	//Emitter Helpers
	function configRedEmit(){
		emitter = new FlxTypedEmitter<FlxParticle>(x+width/2,y+height/5);
		emitter.solid=true;
		emitter.loadParticles("assets/images/fire.png",500);
		startEmitter();
	}


	function configPurpleEmit(){
		emitter=new FlxTypedEmitter<FlxParticle>(x+width/2,y+height/5);
		emitter.solid=true;
		emitter.loadParticles("assets/images/gas.png",200);
		emitter.velocity.set(-5,-5,5,5);
		startEmitter();
	}

	function configOrangeEmit(){
		trace("hello");
		emitter=new FlxTypedEmitter<FlxParticle>(x+width/2+height/5);
		emitter.solid=true;
		emitter.loadParticles("assets/images/fire.png",200);
		emitter.launchMode == FlxEmitterMode.SQUARE;
		emitter.scale.set(1, 1, 1, 1, 4, 4, 8, 8);
		emitter.velocity.set(50, 40, 60, 80, -400, -600, 400, 600);
		emitter.frequency=100;
		startEmitter();
	}

	public function getStatus(){
		return status;
	}

	public function setStatus(s:String,c:UInt){
		clearEffects(c);
		status=s;
	}

	//reset the player to the defaults
	function clearEffects(c:UInt){
		setDefaults();
		if (emitter!=null){ emitterGroup.remove(emitter); emitter.destroy(); emitter=null;}
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
		maxVelocity.y=10000;
	}

	public function setDefaults(){
		status="white";
		setSpeeds(defJumpSpeed,defSpeed);
 		setGravity(defGravity);
 		updateHitbox();
 		height-=5;
 		drag.y=0;
	}

	public function becomeVisible(c:UInt){
		tweenDriver(alpha,1.0);
		bottle.tweenDriver(bottle.alpha,1.0);
	}

	public function startEmitter(){
		emitterGroup.add(emitter);
		switch (status){
			case "red":
				emitter.start(false,.01);
			case "purple":
				emitter.start(false,.03);
			default:
				emitter.start(false,100);
		}
	}

	//setup red potion
	public function lightFire(){
		configRedEmit();
	}

	//setup purple potion
	public function sublimate(){
		configPurpleEmit();
		drag.y=dragC;
		setGravity(0);
		maxVelocity.y=defSpeed;
		height=height/2;
	}

	//setup orange potion
	public function fusRohDah(){
		configOrangeEmit();
	}

	override function loadSprite(){
		loadGraphic("assets/images/player.png",true,122,200);
	}

	override public function update(elapsed:Float):Void{
		//colorcallback it the color is should change to after it has faded back in from being invisible under the blue potion
		if (colorCallback!=null && alpha==1.0){
			setHatColor(colorCallback);
			colorCallback=null;
		}
		super.update(elapsed);
		//attached objects follow logic
		configBottle();
		emitterFollow();
	}

	function emitterFollow(){
		if (emitter==null) return;
		emitter.x=x+width/2;
		emitter.y=y+width/5;
		if (status=="orange"){
			if (facing==FlxObject.RIGHT){

		emitter.launchAngle.set(-45, 45);
			} else {

		emitter.launchAngle.set(135, 225);
			}
		}
	}

	public function fillBottle(p:Potion){
		if (bottle==null) return;
		bottle.fill(p);
	}

	override function handleMovement():Void
	{

		//if in elevator dont move
		if (inElevator) {			
			animation.stop();
			animation.frameIndex=0;
			velocity.set(0,0);
			return;
		}

		if(FlxG.keys.justPressed.E){
			bottle.empty();
		}

		if(status=="orange"){

			if (FlxG.keys.justPressed.SPACE){
				FlxG.sound.play(AssetPaths.dragonbreathFire__wav);
			} else if (FlxG.keys.pressed.SPACE){
				emitter.frequency=.01;
			} else if (status=="orange") {
				emitter.frequency=100;
			}
		}

		if (FlxG.keys.justPressed.C){
			Level.instance.interact();
		}

		if (status=="purple"){
			handleFlight();
			return;
		}

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

	function handleFlight(){

		//used for movement when the player is purple
		
		if (drinking){
			drinking=false; 
			if (bottle!=null) bottle.contents.drink(this);
		}

		left=FlxG.keys.anyPressed([LEFT,A]);
		right=FlxG.keys.anyPressed([RIGHT,D]);
		var up=FlxG.keys.anyPressed([UP,W]);
		var down=FlxG.keys.anyPressed([DOWN,S]);

		if(left&&right){
			left=right=false;
		}
		if (up&&down){
			up=down=false;
		}
		if (left){
			acceleration.x=-dragC;
			facing=FlxObject.LEFT;
		} else if (right){
			acceleration.x=dragC;
			facing=FlxObject.RIGHT;
		} else {
			acceleration.x=0;
		}
		if (status=="purple")
		{if (down){
					acceleration.y=dragC;
				} else if (up){
					acceleration.y=-dragC;
				} else {
					acceleration.y=0;
				}}

		if (FlxG.keys.justPressed.F){
			drink();
		}
	}

	function configBottle(){
		if (bottle==null) return;
		var anim:Int=animation.frameIndex;
		if (status=="purple"){
			anim=47;
		}
		bottle.config(x,y,anim,facing);
	}

	public function drink(){
		animation.stop();
		animation.play("drink");
		drinking=true;
		acceleration.x=0;
	}

	//this is the player version of the callback for replace color, useful for some of the more intense effects
	//where you need to replace the color before changing somthing else
	override public function rCCallbackDriver(){
		switch (rCCallback){
			case "invisible":
				tweenDriver(alpha,0.4);
				bottle.tweenDriver(bottle.alpha,0.4);
			case "sublimate":
				tweenDriver(alpha,0,0.3);
				sublimate();
			default:
		}
		super.rCCallbackDriver();
	}

}