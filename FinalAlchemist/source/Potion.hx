package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxBasic;

class Potion extends FlxBasic
{

	//we probably dont need a separate class for each one, but its the best way i know how to do it off the top of my head.
	//Im not super worried about memory rn, but if it proves to be a problem, we can create a static variable with instances 
	//of all potions

	public static var RED(default,never):Int = 0xFFD50000;
	public static var BLUE(default,never):Int = 0xFF005CD5;
	public static var YELLOW(default,never):Int = 0xFFD5BC00;
	public static var ORANGE(default,never):Int = 0xFFFF6600;
	public static var PURPLE(default,never):Int = 0xFF99004D;
	public static var GREEN(default,never):Int = 0xFF00D500;
	public static var BROWN(default,never):Int = 0xFF804000;
	public static var BLACK(default,never):Int = 0xFF000000;
	public static var WHITE(default,never):Int = 0xFFFFFFFF;

	public var color:Int;
	//Type of potion:
	//0=black/water
	//1=basic - Red Yellow Blue
	//2=composite - Purple Green Orange
	//3=Brown, Bad Potion
	public var type:Int=0;

    public function new(){super(); color=Potion.BLACK;}

    public function drink(player:Player){
    	player.bottle.empty();
		var colorString = Std.string(color);
		if (!Level.firsts.get(colorString)){
			HUD.instance.updateHUD("nice!");
			Level.firsts.set(colorString,true);
		}
    	player.setHatColor(color);
    	if (color==Potion.BLACK || color==Potion.WHITE){
    		player.setStatus("white",color);
    	}
    }

    public function mix(o:Potion):Potion{
    	switch (o.type){
    		case 0:
    			return this;
    		default:
    			return o;
    	}
    }

}