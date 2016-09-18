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
	public var bottle:Bottle;
	public var interactables:FlxTypedGroup<InteractableObject>;

	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible=false;
		interactables=new FlxTypedGroup<InteractableObject>();
	}

	public function addPlayer(?pX:Float=0, ?pY:Float=0):Player{
		player=new Player(pX,pY);
		FlxG.camera.follow(player);
		return player;
	}

	public function addBottleAttached(?pX:Float=0, ?pY:Float=0){
		bottle=new Bottle(pX,pY);
		bottle.attached=true;
		bottle.config(player.velocity.x,player.velocity.y,
						player.animation.frameIndex,
				    	player.animation.name,player.facing);
		add(bottle);
	}

	function loadTiledData(mapData:String){
		level = new TiledLevel("assets/data/"+mapData,this);
		trace("G");
		add(level.backgroundLayer);

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		add (level.foregroundTiles);


		add (level.objectsLayer);

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
		if (FlxG.keys.justPressed.B && bottle==null){
			addBottleAttached(player.x,player.y);
		}

		level.collideWithLevel(player);
		level.collideWithLevel(bottle);
		super.update(elapsed);
	}
}