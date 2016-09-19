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

	static public var levelMaps=[	"Level00.tmx",
									"Level01.tmx",
									"Level02.tmx",
									"Level03.tmx"
								];

	//We definitely dont need classes for specific levels, we can create a list of levels in order
	//and iterate through that instead
	//TODO:
	//FlxGroup[levels];

	public var level:TiledLevel;

	public var levelNum:Int;
	public var player:Player;
	public var interactables:FlxTypedGroup<InteractableObject>;

	public function new(l:Int){
		super();
		levelNum=l;
	}	
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible=false;
		interactables=new FlxTypedGroup<InteractableObject>();
		loadTiledData(levelMaps[levelNum]);
	}

	public function nextLevel(){
		var n=levelNum+1;
		if (n>=levelMaps.length){
			FlxG.switchState(new DeathState(true));
			return;
		}
		FlxG.switchState(new Level(n));
	}

	public function addPlayer(?pX:Float=0, ?pY:Float=0):Player{
		player=new Player(pX,pY);
		FlxG.camera.follow(player);
		return player;
	}

	public function addBottleAttached(?pX:Float=0, ?pY:Float=0){
		var bottle=new Bottle(pX,pY);
		bottle.attached=true;
		player.bottle=bottle;
		add(bottle);
	}

	public function addInteractable(i:InteractableObject){
		interactables.add(i);
	}

	function loadTiledData(mapData:String){
		level = new TiledLevel("assets/data/"+mapData,this);
		add(level.backgroundLayer);

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		add (level.foregroundTiles);

		add (level.objectsLayer);

		if (levelNum!=0){
			addBottleAttached();
		}

	}

	private function interaction(A:FlxObject, B:FlxObject):Void
	{
		if (A == player){
			cast(B,InteractableObject).interact(cast(A,Player));
		} else if (B == player){
			cast(A,InteractableObject).interact(cast(B,Player));
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
		if (FlxG.keys.justPressed.B && player.bottle==null){
			addBottleAttached(player.x,player.y);
		}
		if (FlxG.keys.justPressed.N){
			nextLevel();
		}

		doAsyncLoops(player);
		doAsyncLoops(player.bottle);

		if (player.emitter!=null){
			if (!player.emitter.exists) { add(player.emitter); player.startEmitter(); }
			FlxG.collide(player.emitter, level.foregroundTiles);
		}
		level.collideWithLevel(player);
		level.collideWithLevel(player.bottle);
		super.update(elapsed);


	}

	function doAsyncLoops(p:PlayerAndBottle){
		if (p==null) return;
		if (p.rCLoop==null){}
			else if (p.rCLoop.finished){
				p.rCLoop.kill();
				p.rCLoop.destroy();
				p.rCCallbackDriver();
			} else if (!p.rCLoop.started){
				add(p.rCLoop);
				p.rCLoop.start();
		}
	}
}