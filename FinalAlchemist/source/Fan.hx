package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxObject;

class Fan extends InteractableObject
{

    public var emitter:FlxEmitter;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
        loadGraphic("assets/images/fan.png",true,50,50);
        animation.add("blow",[0,1],5,true);
        emitter=new FlxEmitter(x,y+15);
        emitter.width=width;
        emitter.makeParticles(2,2,FlxColor.WHITE,200);
        emitter.launchMode == FlxEmitterMode.SQUARE;
        emitter.scale.set(1, 1, 1, 1, 4, 4, 8, 8);
        emitter.velocity.set(10000,10000,10000,10000);
        emitter.launchAngle.set(90 , 80);
        emitter.solid=true;
        emitter.immovable=true;
        turnOn();
    }

    public function turnOn(){
        animation.play("blow");
    }

    public function turnOff(){
        animation.stop();
    };

    override public function interact(p:Player){

    }

    public function startEmitter(){
        emitter.start(false,.03);
    }

    function callback(a:FlxObject,b:FlxObject){
        Level.instance.killPlayer("Your body is dispersed into a million tiny clouds");
    }

    override public function update(elapsed:Float):Void
    {
        if (Level.instance.player.emitter!=null && Level.instance.player.getStatus() == "purple"){
            FlxG.collide(Level.instance.player,emitter,callback);
        }
        super.update(elapsed);
    }
}