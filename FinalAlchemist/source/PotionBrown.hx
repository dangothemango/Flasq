package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionBrown extends Potion
{

    public function new(){super(); color=Potion.BROWN; type=3;}

    override public function drink(player:Player){
    	trace ("poop, Brown Potion");
    	super.drink(player);
    }

    override public function mix(o:Potion):Potion{
    	return this;
    }

}