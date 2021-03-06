package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionRed extends Potion
{

    public function new(){super(); color=Potion.RED; type=1;colorString = "red";}

    override public function drink(player:Player){
        super.drink(player);
        player.lightFire();
    }

    override public function mix(o:Potion):Potion{
    	switch (o.type){
    		case 0:
    			return this;
    		case 1:
                switch (o.color){
                    case Potion.YELLOW:
                        return new PotionOrange();
                    case Potion.BLUE:
                        return new PotionPurple();
                    case Potion.RED:
                        return this;
                    default:
                        trace("Mix Error");
                        return this;
                }
            case 2:
                return new PotionBrown();
            default:
                trace("Mix Error");
                return this;

    	}
    }

}