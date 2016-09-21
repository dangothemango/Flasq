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
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.math.FlxPoint;


class Level extends FlxState
{

	//This is the playstate super class that handles most if not all of the inter object interactions


	//a static list of text prompts for the first time certain actions are performed in game
	static public var firsts:Map<String,String> = [
													"red" => "The red liquid tastes like Tabasco sauce mixed with liquor.\nFire wreaths your form.",
													"blue" => "Your palate cannot detect any taste.\nAll of a sudden, you can see right through yourself!",
													"yellow" => "You slug the fluid too quickly to determine what it tastes like.\nTime seems to slow to a crawl as you speed up.",
													"orange" => "This tastes like the inside of a nuclear reactor!\nYour guts boil with voracious flames, and you can barely hold back.\n(Press SPACE to belch)",
													"purple" => "The purple fluid tastes like lemon juice, but somehow, you taste it with your whole body, and not just your mouth.\nYour form dissolves into a loose cloud.",
													"green" => "This tastes gritty and tart, like an energy drink mixed with protein powder.\nYour arms and legs feel fortified.",
													"black" => "The water tastes stale, and is warm from the sun.\nSince you see no recycle bin nearby, you decide to hold onto the bottle. ",
													"white" => "You try to drink to from an empty bottle, It tastes like air....",
													"FILL" => "You fill your bottle with a liquid from the cooler.",
													"BURN" => "The wood chars and crumbles away at your touch.",
													"EXPLODE" => "The sentry explodes in a shower of sparks."
												];
	
	//used as a static reference of the current level
	static public var instance:Level;

	//static arrays for preloading replace color pixels for player and bottle and haivng them persist across levels
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
	//Good job, we did this

	public var level:TiledLevel;
	private var _floorhit:Bool;
	public var levelNum:Int;
	private var _hud:HUD;
	public var player:Player;

	//various lists of objects in the scene of different types, used mostly for collision and adding logic
	public var interactables:FlxTypedGroup<InteractableObject>;
	public var burnables:FlxTypedGroup<Burnable>;
	public var elevators:FlxTypedGroup<Elevator>;
	public var sentries:FlxTypedGroup<Sentry>;
	public var boxes:FlxTypedGroup<Box>;
	public var fans:FlxTypedGroup<Fan>;

	var bottle:Bottle;

	public function new(l:Int){
		super();
		levelNum = l;
	}	

	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
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
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new DeathState(false, s, levelNum));
		});
	}
	
	public function nextLevel(){
		var n = levelNum + 1;
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function(){
			if (n >= levelMaps.length){
				FlxG.switchState(new DeathState(true, "I'm...impressed",0));
				return;
			}
			FlxG.switchState(new Level(n));
		});
	}

	public function prevLevel(){
		var n=levelNum-1;
		if (n<0){
			n=0;
		}
		FlxG.switchState(new Level(n));
	}

	public function addPlayer(?pX:Float=0, ?pY:Float=0):Player{
		player=new Player(pX,pY);
		FlxG.camera.follow(player);
		return player;
	}

	public function addBottle(b:Bottle){
		bottle=b;
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
		_hud = new HUD();
		level = new TiledLevel("assets/data/" + mapData, this);
		if (levelNum == 1){
			FlxG.sound.playMusic(AssetPaths.SoulBoat14__wav, 1, true);
		}
		if (levelNum != 0){
			add(level.backgroundLayer);
			add(level.decorationsLayer);
		} else {
			var back=new FlxSprite(0,0,"assets/images/sky.png");
			back.setGraphicSize(level.fullWidth,level.fullHeight);
			back.updateHitbox();
			add(back);
			add(level.decorationsLayer);
			add(level.backgroundLayer);
			FlxG.sound.destroy(true);
			FlxG.sound.play(AssetPaths.Slide1__wav, 1, true);
			HUD.instance.updateHUD("It seems you’ve landed here.\nYou feel thirsty.\nIronic really. The fight attendant was JUST about to pour your drink...");
		}

		//I dont think we need this, uncomment it if something is missing
		//add(level.imagesLayer);

		//add sentry targetting radii to draw order
		for (s in sentries){
			add(s.getRadius());
		}
		add (level.foregroundTiles);

		//have to add one set of elevator doors before objects because player is in there
		for (e in elevators){
			add(e);
			add(e.getBehindDoor());
		}
		add (level.objectsLayer);


		if (bottle==null){
			add(player.addBottle());
		} else {
			add(bottle);
			player.inElevator=false;
		}
		//start emitters on fans
		for (f in fans){
			add(f);
			add(f.emitter);
			f.startEmitter();
		}
		//as secnd set of elevator doors
		for (e in elevators){
			add(e.getFrontDoor());
			if (e.type=="start"){
				e.centerPlayer();
			}
		}
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

		#if debug
		if (FlxG.keys.justPressed.N){
			nextLevel();
		}
		if (FlxG.keys.justPressed.B){
			prevLevel();
		}
		#end
		if (FlxG.keys.justPressed.R){
			FlxG.switchState(new Level(levelNum));
		}

		if (FlxG.keys.justPressed.ENTER){
			_hud.hideHUD();
		}
		
		//Logic to handle starting async loops created in player and bottle
		doAsyncLoops(player);
		doAsyncLoops(player.bottle);

		//logic for player emitter collisions with appropriate callbacks
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
		//Enable or disable movablitly based on whether or not the player is green
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

		//for picking up the bottle on level 0
		if (player.bottle==null){
			FlxG.overlap(bottle,player,bottleCollisionCallback);
		}
		if (player.justTouched(FlxObject.DOWN) && _floorhit){
			FlxG.sound.play(AssetPaths.fallDeath__wav);
			killPlayer("You slam into the ground a little too quickly\nYou black out.\nForever.");
		}

		super.update(elapsed);
		FlxG.watch.add(this, "player");

		//fallDamage
		if (player.velocity.y > 1100 && player.getStatus() != "green"){
			_floorhit = true;
		}

		if (player.velocity.y > 2200){
			killPlayer("You forget that you are no longer wearing a	parachute, and spread yourself thinly over the distant pavement.\nWhy did you do that?");
		}
	}

	function bottleCollisionCallback(A:FlxObject, B:FlxObject){
		HUD.instance.updateHUD("Press C to interact");
		if (FlxG.keys.justPressed.C){
			try {
				player.attachBottle(cast(A,Bottle));
			} catch ( e :String){
				player.attachBottle(cast (B,Bottle));
			}
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