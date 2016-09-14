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

	var player:Player;
	var tileMap:FlxTilemap;
	var interactables:FlxTypedGroup<InteractableObject>;

	override public function create():Void
	{
		super.create();
		interactables=new FlxTypedGroup<InteractableObject>();
	}

	function addPlayer(?pX:Float=0, ?pY:Float=0){
		player=new Player(pX,pY);
		add(player);
		FlxG.camera.follow(player);
		FlxG.camera.setScrollBoundsRect(0,0,1000,800);
	}

	function loadTileMap(mapData:String, mapTiles:String){
		tileMap=new FlxTilemap();
		tileMap.loadMapFromCSV(Assets.getText(mapData),mapTiles,16,16);
		add(tileMap);
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
		FlxG.collide(player,tileMap);
		if (FlxG.keys.justPressed.C){
			interact();
		}
		super.update(elapsed);
	}
}