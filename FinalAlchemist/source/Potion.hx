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

	static var RED(default,never):Int = 0xD50000;
	static var BLUE(default,never):Int = 0x005CD5;
	static var YELLOW(default,never):Int = 0xD5BC00;
	static var ORANGE(default,never):Int = 0xFF6600;
	static var PURPLE(default,never):Int = 0x99004D;
	static var GREEN(default,never):Int = 0x00D500;
	static var BROWN(default,never):Int = 0x442200;

	public var color:Int;
	//Type of potion:
	//0=black/water
	//1=basic - Red Yellow Blue
	//2=composite - Purple Green Orange
	//3=Brown, Bad Potion
	public var type:Int=0;

    public function new(){super(); color=0x000000;}

    public function drink(player:Player){
    	trace ("no effect, Black Potion");
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