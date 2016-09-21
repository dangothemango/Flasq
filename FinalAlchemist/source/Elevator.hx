package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Elevator extends InteractableObject
{
    var openDoor:ElevatorDoor;
    var closeDoor:ElevatorDoor;
    public var behind:ElevatorDoor;
    public var front:ElevatorDoor;

    public var type:String;

    public function new(s:String,?X:Float=0, ?Y:Float=0, ?W:Int=10,?H:Int=10)
    {
        super(X,Y,W,H);
        loadGraphic("assets/images/elevator.png");
        setGraphicSize(0,H);
        updateHitbox();
        behind=new ElevatorDoor(this,X,Y,Std.int(width),H);
        front=new ElevatorDoor(this,X,Y,Std.int(width),H);
        type=s;
        if (s=="start"){
            openDoor=front;
            closeDoor=behind;
        } else if (s=="end"){
            openDoor=behind;
            closeDoor=front;
        } else {
            trace ("THIS SHOULD NEVER PRINT, IF IT DOES YOU ARE NOT CONSTRUCTING Elevator PROPERLY");
        }
        openDoor.animation.frameIndex=0;
        closeDoor.animation.frameIndex=15;

    }

    public function centerPlayer(){
        Level.instance.player.y=y+75;
        Level.instance.player.x=x+30;
    }

    override public function interact(p:Player){
        p.inElevator=true;
        centerPlayer();
        open();

    }

    public function getBehindDoor():ElevatorDoor{
        trace(getBehindDoor);
        return behind;
    }

    public function getFrontDoor():ElevatorDoor{
        return front;
    }

    public function open(){
		FlxG.sound.play(AssetPaths.elevatoropen__wav);
        openDoor.open();
    }

    public function close(){
        closeDoor.close();
    }

    public function onClose(e:ElevatorDoor){
        trace("OnClose");
        if (type=="end"){
            Level.instance.nextLevel();
        } else {
            Level.instance.player.inElevator=false;
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}