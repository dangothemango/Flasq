package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxSprite;
//import flixel.addons.display.shapes.FlxShapeLightning;
//import flixel.math.FlxRandom;
//import flixel.math.FlxPoint;

class IntroState extends FlxState
{

	//Timing Vars
	var lightningTime:Float=.75;
	var fadeToBlackTime:Float=1;
	var downTime:Float=1;

	var sPath = "assets/images/Slide_";

	var t:Float;

	var slide:FlxSprite;

	var slideNum:Int=-1;
	var slides:Int=6;

	var ready:Bool;

	//var lightning:FlxShapeLightning;

	//var rand:FlxRandom;

	override public function create():Void{
		super.create();
		FlxG.mouse.visible=false;
		//rand=new FlxRandom();
		getReady();
	}

	function getReady(){
		ready=true;
		slideNum+=1;
		t=0;
		remove(slide);
		
		if (slide!=null)slide.destroy();
		
		slide=null;

		if (slideNum>=slides){
			FlxG.switchState(new Level(0));
		}
	}

	function fadeOut(){
		/*remove(lightning);
		if (lightning!=null)lightning.destroy();
		lightning=null;*/
		FlxG.camera.fade(FlxColor.BLACK,fadeToBlackTime,false,getReady);
	}

	function nextSlide(){
		FlxG.camera.flash(FlxColor.WHITE,lightningTime,fadeOut);
		slide=new FlxSprite(0,0,sPath+Std.string(slideNum)+".png");
		trace(sPath+Std.string(slideNum)+".png");
		slide.setGraphicSize(FlxG.camera.width,FlxG.camera.height);
		slide.updateHitbox();
		/*lightning=new FlxShapeLightning(0,0,new FlxPoint(rand.int(0,Std.int(FlxG.camera.width/2)),rand.int(0,Std.int(FlxG.camera.height/2))),
											new FlxPoint(rand.int(Std.int(FlxG.camera.width/2),Std.int(FlxG.camera.width)),rand.int(Std.int(FlxG.camera.height/2),Std.int(FlxG.camera.height))),
											{thickness : 10, color: FlxColor.WHITE, displacement: 100, detail:100, halo_colors:[FlxColor.WHITE]}
											,true);*/
		add(slide);
		//add(lightning);
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		t+=elapsed;
		if (ready&&t>downTime){
			ready=false;
			nextSlide();
		}
	}
}