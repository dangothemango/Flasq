package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionGreen extends Potion
{

    public function new(){super(); color=Potion.GREEN; type=2;colorString = "green";}

    override public function drink(player:Player){
        super.drink(player);
    }

    override public function mix(o:Potion):Potion{
    	switch (o.type){
    		case 0:
    			return this;
    		default:
                return new PotionBrown();
    	}
    }

}