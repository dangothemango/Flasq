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

	static public var instance:Level;

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
	public var burnables:FlxTypedGroup<Burnable>;
	public var elevators:FlxTypedGroup<Elevator>;

	public function new(l:Int){
		super();
		levelNum=l;
	}	
	override public function create():Void
	{
		super.create();
		instance=this;
		FlxG.mouse.visible=false;
		interactables=new FlxTypedGroup<InteractableObject>();
		burnables=new FlxTypedGroup<Burnable>();
		elevators=new FlxTypedGroup<Elevator>();
		loadTiledData(levelMaps[levelNum]);
		for (e in elevators){
			if (e.type=="start"){
				e.open();
			}
		}
	}

	public function killPlayer(s:String) : Void {
		FlxG.switchState(new DeathState(false, s, levelNum));
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

	public function addInteractable(i:InteractableObject){
		interactables.add(i);
	}

	public function addBurnable(b:Burnable){
		burnables.add(b);
	}

	public function addElevator(e:Elevator){
		elevators.add(e);
	}

	public function burn(A:FlxObject, B:FlxObject){
		try {
			cast(A, Burnable).burn();
		} catch ( e:String ){
			cast(B, Burnable).burn();
		}

	}

	public function destroyBurnable(b:Burnable){
		trace("Kill");
		burnables.remove(b);
		level.foregroundTiles.remove(b);
		b.destroy();

	}

	function loadTiledData(mapData:String){
		level = new TiledLevel("assets/data/"+mapData,this);
		add(level.backgroundLayer);

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		add (level.foregroundTiles);

		for (e in elevators){
			add(e);
			add(e.getBehindDoor());
		}
		add (level.objectsLayer);


		if (levelNum!=0){
			add(player.addBottle());
		} else{
			player.inElevator=false;
		}
		for (e in elevators){
			add(e.getFrontDoor());
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

	public function interact():Void{
		FlxG.overlap(player,interactables,interaction);
	}

	override public function update(elapsed:Float):Void
	{
		//FlxG.collide(player,wallsMap);

		if (FlxG.keys.justPressed.N){
			nextLevel();
		}

		doAsyncLoops(player);
		doAsyncLoops(player.bottle);

		if (player.emitter!=null){
			FlxG.collide(player.emitterGroup, level.foregroundTiles);
			if (player.getStatus()=="red"){
				FlxG.overlap(player.emitterGroup, burnables,burn);
			}
		}
		level.collideWithLevel(player);
		FlxG.collide(burnables,player);
		super.update(elapsed);
		FlxG.watch.add(this, "player");
		if (player.velocity.y > 2000){
			killPlayer("You fell to your death...Good Job");
		}
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