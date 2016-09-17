package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;

class Level extends FlxState
{

	public var level:TiledLevel;

	public var player:Player;
	public var interactables:FlxTypedGroup<InteractableObject>;

	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible=false;
		interactables=new FlxTypedGroup<InteractableObject>();
	}

	function addPlayer(?pX:Float=0, ?pY:Float=0){
		player=new Player(pX,pY);
		add(player);
		FlxG.camera.follow(player);
	}

	function loadTiledData(mapData:String){
		level = new TiledLevel("assets/data/"+mapData,this);
		trace("G");
		add(level.backgroundLayer);

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		add (level.objectsLayer);

		add (level.foregroundTiles);

	}

	private function interaction(A:FlxObject, B:FlxObject):Void
	{
		if (A == player){
			cast(B,InteractableObject).interact();
		} else if (B == player){
			cast(A,InteractableObject).interact();
		}
	}

	function interact():Void{
		FlxG.overlap(player,interactables,interaction);
	}

	override public function update(elapsed:Float):Void
	{
		//FlxG.collide(player,wallsMap);
		if (FlxG.keys.justPressed.C){
			interact();
		}
		
		level.collideWithLevel(player);
		super.update(elapsed);
	}
}