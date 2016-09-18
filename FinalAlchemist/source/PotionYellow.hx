package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class PotionYellow extends Potion
{

    public function new(){super(); color=Potion.YELLOW; type=1;}

    override public function drink(player:Player){
    	player.status="yellow";
        player.setSpeeds(player.defJumpSpeed*1.75,player.defSpeed*2);
    }

    override public function mix(o:Potion):Potion{
    	switch (o.type){
    		case 0:
    			return this;
    		case 1:
                switch (o.color){
                    case Potion.BLUE:
                        return new PotionGreen();
                    case Potion.RED:
                        return new PotionOrange();
                    case Potion.YELLOW:
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