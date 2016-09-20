package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.tweens.FlxTween;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxMath;

class Sentry extends RangedObject
{
	
	private var _viewRange = 300;
	private var _withinViewRange = false;
	private var _turnDirection = 10;
	private var _waitShoot = 0.0;
	private var _reFocus = 0.0;
	private var emitter:FlxTypedEmitter<FlxParticle>;
    private var tween:FlxTween;
	
    public function new(?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X-50,Y+50,W,H);
        loadSentry();
        range = 150;
        animation.add("fire", [0, 1, 2, 3, 4, 5, 6], 10, false);
		emitter = new FlxTypedEmitter<FlxParticle>(x+width/2,y+height/5);
        emitter.loadParticles(AssetPaths.fire__png,500);
    }

	function inRangeHelper(_done:String){
		if (player.getStatus() != "purple"){
			Level.instance.killPlayer("Shot To Death");
		}
	}
	
    override function inRange(elapsed:Float){
		_waitShoot -= 6 * elapsed;
		if (player.getStatus() != "blue" && _waitShoot <= 0){
			_waitShoot = 2;
			animation.play("fire");
			FlxG.sound.play(AssetPaths.turretshoot__wav);
			animation.finishCallback = inRangeHelper;
		}
        if (withinRange){
            return;
        }
        withinRange=true;
    }
	
    override function outOfRange(){
        if (!withinRange){
            return;
        }
        withinRange=false;
    }

	function inViewRange(){
		var _triangle = new FlxPoint(pt.x -player.x + 50, pt.y - player.y);
		if (_triangle.y > 0){
			if (_triangle.x <= 0){
				angle = 180;
			} else {
				angle = 360;
			}
		}else {
			var _tempAngle = 270 - (180 / (Math.PI * Math.atan((pt.y - player.y) / (pt.x - player.x)))) / 2;
			if (_tempAngle < 180){
				angle = 180;
			}else if (_tempAngle>360){
				angle = 360;
			}else{
				angle = _tempAngle;
			}
		}
		
		angularVelocity = 0;
		if (_withinViewRange){
            return;
        }
		FlxG.sound.play(AssetPaths.turretDetect__wav);
		_withinViewRange = true;
	}
	
	function outOfViewRange(){
		if (angularVelocity == 0){
			angularVelocity = _turnDirection;
		}
		else if (angle >= 360){
			_turnDirection = -10;
			angularVelocity = _turnDirection;
		}
		else if (angle <= 180){
			_turnDirection = 10;
			angularVelocity = _turnDirection;
		}
		if (!_withinViewRange){
            return;
        }
		_withinViewRange = false;
	}

	function loadSentry(){
		loadGraphic(AssetPaths.sentry__png, true, 150, 39);
		
		angle = 270;
	}
	
	private function tweenFunction(s:FlxSprite, v:Float) { s.alpha = v; }

    function tweenDriver(s:Float,e:Float,?t:Float=1.0){
        if (tween!=null)tween.cancel();
        tween=FlxTween.num(s, e, t, {}, tweenFunction.bind(this));
		}


    public function explode(){
        solid=false;
        Level.instance.add(emitter);
        emitter.start(false,.01);
        tweenDriver(alpha,0);
    }
	
    override public function update(elapsed:Float):Void
    {
		if (isOnScreen()){
			super.update(elapsed);
			if (pt.distanceTo(new FlxPoint(player.x, player.y)) <= _viewRange && player.getStatus() != "blue"){
				_reFocus -= 6 * elapsed;
				if (_reFocus <= 0){
					inViewRange();
					_reFocus = 1;
				}
			}else {
				outOfViewRange();
			}
		}
		else {
			angularVelocity = 0;
		}
		if (alpha == 0){
			FlxG.sound.play(AssetPaths.turretDestroy__wav);
            emitter.destroy();
            Level.instance.destroySentry(this);
        }
    }
}