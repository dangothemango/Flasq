package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.tweens.FlxTween;
import flixel.effects.particles.FlxParticle;

class Burnable extends FlxSprite
{

    var emitter:FlxTypedEmitter<FlxParticle>;
    var tween:FlxTween;

    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super();
        x=X;
        y=Y;
        immovable=true;
        loadSprite();
        emitter = new FlxTypedEmitter<FlxParticle>(x+width/2,y+height/5);
        emitter.loadParticles("assets/images/fire.png",500);
    }

    function loadSprite(){

    }

    private function tweenFunction(s:FlxSprite, v:Float) { s.alpha = v; }

    function tweenDriver(s:Float,e:Float,?t:Float=1.0){
        if (tween!=null)tween.cancel();
        tween=FlxTween.num(s, e, t, {}, tweenFunction.bind(this));

    }


    public function burn(){
        solid=false;
        Level.instance.add(emitter);
        emitter.start(false,.01);
        tweenDriver(alpha,0);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (alpha==0){
            emitter.destroy();
            Level.instance.destroyBurnable(this);
        }
    }
}