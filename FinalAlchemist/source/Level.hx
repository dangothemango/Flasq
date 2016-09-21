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
import flixel.math.FlxPoint;

class Level extends FlxState
{

	static public var firsts:Map<String,String> = [
													"red" => "The red liquid tastes like Tabasco sauce mixed with liquor.\nFire wreaths your form.",
													"blue" => "Your palate cannot detect any taste.\nAll of a sudden, you can see right through yourself!",
													"yellow" => "You slug the fluid too quickly to determine what it tastes like.\nTime seems to slow to a crawl as you speed up.",
													"orange" => "This tastes like the inside of a nuclear reactor!\nYour guts boil with voracious flames, and you can barely hold back.\n(Press C to release)",
													"purple" => "The purple fluid tastes like lemon juice, but somehow, you taste it with your whole body, and not just your mouth.\nYour form dissolves into a loose cloud.",
													"green" => "This tastes gritty and tart, like an energy drink mixed with protein powder.\nYour arms and legs feel fortified.",
													"black" => "The water tastes stale, and is warm from the sun.\nSince you see no recycle bin nearby, you decide to hold onto the bottle. ",
													"white" => "You try to drink to from an empty bottle, It tastes like air....",
													"FILL" => "You fill your bottle with a liquid from the cooler.",
													"BURN" => "The wood chars and crumbles away at your touch.",
													"EXPLODE" => "The sentry explodes in a shower of sparks."
												];
	static public var instance:Level;

	static public var PRCPreloadedArray:Array<FlxPoint>;
	static public var BRCPreloadedArray:Array<FlxPoint>;

	static public var levelMaps=[	
									"Level00.tmx",
									"Level01-01.tmx",
									"Level01-02.tmx",
									"Level01-03.tmx",
									"Level01-04.tmx",
									"Level01-05.tmx",
									"Level01.tmx",
									"Level02.tmx",
									"Level03.tmx"
								];

	//We definitely dont need classes for specific levels, we can create a list of levels in order
	//and iterate through that instead
	//TODO:
	//FlxGroup[levels];

	public var level:TiledLevel;
	private var _floorhit:Bool;
	public var levelNum:Int;
	private var _hud:HUD;
	public var player:Player;
	public var interactables:FlxTypedGroup<InteractableObject>;
	public var burnables:FlxTypedGroup<Burnable>;
	public var elevators:FlxTypedGroup<Elevator>;
	public var sentries:FlxTypedGroup<Sentry>;
	public var boxes:FlxTypedGroup<Box>;
	public var fans:FlxTypedGroup<Fan>;

	public function new(l:Int){
		super();
		levelNum = l;
	}	
	override public function create():Void
	{
		super.create();
		instance=this;
		FlxG.mouse.visible = false;
		_floorhit = false;
		interactables=new FlxTypedGroup<InteractableObject>();
		elevators=new FlxTypedGroup<Elevator>();
		burnables = new FlxTypedGroup<Burnable>();
		sentries = new FlxTypedGroup<Sentry>();
		boxes = new FlxTypedGroup<Box>();
		fans = new FlxTypedGroup<Fan>();
		//lifts = new FlxTypedGroup<Lift>();
		
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
			FlxG.switchState(new DeathState(true, "I'm...impressed",0));
			return;
		}
		FlxG.switchState(new Level(n));
	}

		public function nextLevel(){
		var n=levelNum-1;
		if (n<=0){
			n++;
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
	
	public function addSentry(turret:Sentry){
		sentries.add(turret);
	}

	public function addFan(f:Fan){
		fans.add(f);
	}
	
	public function addBoxes(b:Box){
		boxes.add(b);
	}
	
	public function destroySentry(turret:Sentry){
		sentries.remove(turret);
		level.foregroundTiles.remove(turret);
		turret.destroy();
	}

	public function explode(A:FlxObject, B:FlxObject){
		try {
			cast(A, Sentry).explode();
		} catch ( e:String ){
			cast(B, Sentry).explode();
		}

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
		burnables.remove(b);
		level.foregroundTiles.remove(b);
		b.destroy();
	}

	function loadTiledData(mapData:String){
		level = new TiledLevel("assets/data/"+mapData,this);
		if (levelNum!=0){
			add(level.backgroundLayer);
			add(level.decorationsLayer);
		} else {
			var back=new FlxSprite(0,0,"assets/images/sky.png");
			back.setGraphicSize(level.fullWidth,level.fullHeight);
			add(level.decorationsLayer);
			add(level.backgroundLayer);
		}

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		for (s in sentries){
			add(s.getRadius());
		}
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
		for (f in fans){
			add(f);
			add(f.emitter);
			f.startEmitter();
		}
		for (e in elevators){
			add(e.getFrontDoor());
		}
		_hud = new HUD();
		add(_hud);
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

	function boxesCollide(A:FlxObject, B:FlxObject){
		if (player.getStatus() == "green"){
			FlxObject.separate(A,B);
		}else{
			player.velocity.set(0,0);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		//FlxG.collide(player,wallsMap);

		if (FlxG.keys.justPressed.N){
			nextLevel();
		}
		if (FlxG.keys.justPressed.B){
			prevLevel();
		}

		if (FlxG.keys.justPressed.ENTER){
			_hud.hideHUD();
		}
		
		doAsyncLoops(player);
		doAsyncLoops(player.bottle);

		if (player.emitter!=null){
			FlxG.collide(player.emitterGroup, level.foregroundTiles);
			if (player.getStatus()=="red"){
				FlxG.overlap(player.emitterGroup, burnables, burn);
			}
			if (player.getStatus()=="orange"){
				FlxG.overlap(player.emitterGroup, sentries, explode);
			}
		}
		level.collideWithLevel(player);
		//FlxG.overlap(boxes, player, boxesCollide);
		if (player.getStatus()!="green"){
			for (b in boxes){
				b.immovable=true;
			}
		}
		FlxG.collide(boxes,player);
		if (player.getStatus()!="green"){
			for (b in boxes){
				b.immovable=false;
			}
		}
		FlxG.collide(boxes, level.foregroundTiles);
		/*for (l in lifts){
			FlxG.collide(l, player);
		}*/
		FlxG.collide(burnables, player);
		FlxG.collide(sentries, player);
		if (player.justTouched(FlxObject.DOWN) && _floorhit){
			killPlayer("You slam into the ground a little too quickly\nYou black out.\nForever.");
		}
		super.update(elapsed);
		FlxG.watch.add(this, "player");
		if (player.velocity.y > 1500 && player.getStatus() != "green"){
			_floorhit = true;
		}
		if (player.velocity.y > 2500){
			killPlayer("You forget that you are no longer wearing a	parachute, and spread yourself thinly over the distant pavement.\nWhy did you do that?");
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