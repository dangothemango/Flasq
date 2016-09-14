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
	var wallsMap:FlxTilemap;
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
		wallsMap=new FlxTilemap();
		wallsMap.loadMapFromCSV(Assets.getText(mapData),mapTiles,16,16);
		add(willsMap);
	}

	function loadTileMap(LevelNumber:Int){
		mapData="Level" + LevelNumber.toString() + ".tmx";

		//Load the tmx file
		var tiledLevel:TiledMap = new TiledMap(mapData);

		//get world size information
		var tileSize = tiledLevel.tileWidth;
		var mapW = tiledLevel.width;
		var mapH = tiledLevel.height;

		for (layer in tiledLevel.layers){
			var layerData:Array<Int> = layer.tileArray;
			//If ^that doesnt work, use this
			//var layerData:String = layer.csvData;

			//get the tilesheet
			var tilesheetName:String =layer.properties.get("tilesheet");
			var tilesheetPath:String="assets/images/"+tilesheetName;

			//TODO::get the right tilemap for now, make one up
			var tileMap:FlxTilemap = new FlxTilemap();

			tileMap.widthInTiles=mapW;
			tileMap.heightInTiles=mapH;

			//TODO::Actually just use this one and attach later

			var tileGID:Int = getStartGid(tiledLevel,tilesheetName);

			tileMap.loadMap(layer.tileArray, tilesheetPath, tileSize, tileSize, FlxTilemap.OFF, tileGID);


		}

	}

    function getStartGid (tiledLevel:TiledMap, tilesheetName:String):Int
    {
        // This function gets the starting GID of a tilesheet
 
        // Note: "0" is empty tile, so default to a non-empty "1" value.
        var tileGID:Int = 1;
 
        for (tileset in tiledLevel.tilesets)
        {
            // We need to search the tileset's firstGID -- to do that,
            // we compare the tilesheet paths. If it matches, we
            // extract the firstGID value.
            var tilesheetPath:Path = new Path(tileset.imageSource);
            var thisTilesheetName = tilesheetPath.file + "." + tilesheetPath.ext;
            if (thisTilesheetName == tilesheetName)
            {
                tileGID = tileset.firstGID;
            }
        }
 
        return tileGID;
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
		FlxG.collide(player,wallsMap);
		if (FlxG.keys.justPressed.C){
			interact();
		}
		super.update(elapsed);
	}
}