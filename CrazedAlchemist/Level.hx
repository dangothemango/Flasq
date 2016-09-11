package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class Level extends FlxState
{

	var player:Player;
	var tileMap:FlxTilemap;

	override public function create():Void
	{
		super.create();
	}

	function addPlayer(?pX:Float=0, ?pY:Float=0){
		player=new Player(pX,pY);
		add(player);
		FlxG.camera.follow(player);
	}

	function loadTileMap(mapData:String, mapTiles:String){
		tileMap=new FlxTilemap();
		tileMap.loadMapFromCSV(Assets.getText(mapData),mapTiles,16,16);
		add(tileMap);
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(player,tileMap);
		super.update(elapsed);
	}
}