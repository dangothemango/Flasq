package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionOrange extends Potion
{

    public function new(){super(); color=Potion.ORANGE; type=2;colorString = "orange";}

    override public function drink(player:Player){
    	super.drink(player);
        player.fusRohDah();
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