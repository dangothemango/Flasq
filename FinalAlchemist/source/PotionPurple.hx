package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionPurple extends Potion
{

    public function new(){super(); color=Potion.PURPLE; type=2;colorString = "purple";}

    override public function drink(player:Player){
        super.drink(player);
        player.rCCallback="sublimate";
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