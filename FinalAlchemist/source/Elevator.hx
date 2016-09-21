package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class Elevator extends InteractableObject
{

	//the elevator class is a little funky. Due to the nature of flx handling draw order based on order of addition
	//the elevator needs two sets of doors, one that is in front of the player and one that is behind


	//behind and front are the two door sets, openDoor and closeDoor are pointers for useablitly
    var openDoor:ElevatorDoor;
    var closeDoor:ElevatorDoor;
    public var behind:ElevatorDoor;
    public var front:ElevatorDoor;

    //type is start or end depending on whether its the beginning or end of the level
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
        //assign the usability pointers
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

    //keeps the player in the elevator so they cant slide out of it when they interact while moving
    public function centerPlayer(){
        Level.instance.player.y=y+75;
        Level.instance.player.x=x+30;
    }

    //only the end elevator is interactable because why would go back into the first one this is handled in TiledLevel.hx
    override public function interact(p:Player){
        p.inElevator=true;
        centerPlayer();
        open();
    }

    public function getBehindDoor():ElevatorDoor{
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

    //animation callback
    public function onClose(e:ElevatorDoor){
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