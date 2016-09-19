package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flash.system.System;
import flixel.util.FlxAxes;

class MenuState extends FlxState {
	
	private var _gameTitle:FlxText;
	private var _playButton:FlxButton;
	private var _optionButton:FlxButton;
	#if desktop
	private var _exitButton:FlxButton;
	#end
	
	
	override public function create():Void {
		_gameTitle = new FlxText(0, 200, 0, "FLASQ", 40);
		_gameTitle.alignment = CENTER;
		_gameTitle.screenCenter(FlxAxes.X);
		add(_gameTitle);
		
		_playButton = new FlxButton(0, _gameTitle.y + _gameTitle.height + 10, "Play", clickPlay);
		_playButton.screenCenter(FlxAxes.X);
		add(_playButton);
		
		_optionButton = new FlxButton(0, 0, "Options", clickOption);
		_optionButton.screenCenter(FlxAxes.X);
		_optionButton.y = _playButton.y + 25;
		add(_optionButton);

		#if desktop
		_exitButton = new FlxButton(0, 0, "Exit", clickExit);
		_exitButton.screenCenter(FlxAxes.X);
		_exitButton.y = _optionButton.y + 25;
		add(_exitButton);
		#end
		
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
	
	function clickPlay(): Void {
		//switch to play scene
		FlxG.switchState(new Level(3));
	}
	
	function clickOption(): Void {
		FlxG.switchState(new OptionState());
	}
	
	#if desktop
	function clickExit() : Void {
		System.exit(0);
	}
	#end
}
