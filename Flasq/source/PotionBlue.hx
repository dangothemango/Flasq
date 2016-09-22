package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionBlue extends Potion
{

    public function new(){super(); color=Potion.BLUE; type=1;colorString = "blue";}

    override public function drink(player:Player){
        super.drink(player);
        //requires a replace color callback because of the way alpha interacts with RC
        player.rCCallback="invisible";
    }

    override public function mix(o:Potion):Potion{
    	switch (o.type){
    		case 0:
    			return this;
    		case 1:
                switch (o.color){
                    case Potion.YELLOW:
                        return new PotionGreen();
                    case Potion.RED:
                        return new PotionPurple();
                    case Potion.BLUE:
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