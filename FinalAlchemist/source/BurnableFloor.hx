package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxRandom;

class BurnableFloor extends Burnable
{

    static var sprites=["burnfloor1.png","burnfloor2.png"];
    static var rand:FlxRandom;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        if (rand==null){
            rand=new FlxRandom();
        }
        super(X,Y,W,H);
    }

    override function loadSprite(){
        var p="assets/images/"+sprites[rand.int(0,sprites.length-1)];
        trace(p);
        loadGraphic(p);
    }
}