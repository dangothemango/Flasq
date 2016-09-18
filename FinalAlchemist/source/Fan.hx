package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;

class Fan extends InteractableObject
{

    var emitter:FlxEmitter;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
        loadGraphic("assets/images/fan.png",true,50,50);
        animation.add("blow",[0,1],3);
        turnOn();
    }

    public function turnOn(){
        animation.play("blow");
    }

    public function turnOff(){
        animation.stop();
    };

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}