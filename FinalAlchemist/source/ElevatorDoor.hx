package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class ElevatorDoor extends FlxSprite
{

	//an elevator door, each elevator has 2 of these has some basic animations and thats all

    var elevator:Elevator;

    public function new(e:Elevator,?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y);
        trace(X,Y,W,H);
        elevator=e;
        loadGraphic("assets/images/elevatordoor.png",true,440,713);
        setGraphicSize(Std.int(W/6.6*6),H);
        updateHitbox();
        animation.add("open",[for (i in 0...17) i],30,false);
        animation.add("close",[for (i in 16...32) i],30,false);
        animation.finishCallback=callback;
    }

    public function callback(s:String){
        if (s=="open"){
            elevator.close();
            destroy();
        } else if (s=="close"){
            elevator.onClose(this);
        }
    }

    public function open(){
        animation.play("open");
    }

    public function close(){
        animation.play("close");
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}