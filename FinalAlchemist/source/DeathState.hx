package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class DeathState extends FlxState
{
	
	private var _pageTitle:FlxText;
	private var _win:Bool;
	private var _deathType:String;
	private var _lastLevel:Int;
	private var _deathMessage:FlxText;
	private var _mainMenuBtn:FlxButton;
	private var _retryBtn:FlxButton;
	
	//take in whether the player has died, how they died and what level they died
	public function new(Win:Bool,? Death:String ,? FromLevel:Int) {
		_win = Win;
		_deathType = Death;
		_lastLevel = FromLevel;
		super();
	}
	
	override public function create():Void{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		_pageTitle = new FlxText(0, 200, 0, _win ? "You Win!\n" + _deathType : "Game Over!", 30);
		_pageTitle.alignment = CENTER;
		_pageTitle.screenCenter(FlxAxes.X);
		add(_pageTitle);
		
		if (!_win) {
			_deathMessage = new FlxText(0, (FlxG.height / 2) - 18, 0, _deathType, 16);
			_deathMessage.alignment = CENTER;
			_deathMessage.screenCenter(FlxAxes.X);
			add(_deathMessage);
		}
		
		_mainMenuBtn = new FlxButton(0, FlxG.height - 32, "Main Menu", goMainMenu);
		_mainMenuBtn.screenCenter(FlxAxes.X);
		add(_mainMenuBtn);
		
		_retryBtn = new FlxButton(0, FlxG.height - 64, "Retry", retryLevel);
		_retryBtn.screenCenter(FlxAxes.X);
		add(_retryBtn);
		
		super.create();
	}

	override public function update(elapsed:Float):Void{
		if (FlxG.keys.justPressed.R){
			retryLevel();
		}
		super.update(elapsed);
	}
	
	//will return to main menu
	function goMainMenu() : Void {
		FlxG.switchState(new MenuState());
	}
	
	//will return to where you came from
	function retryLevel() : Void {
		if (_lastLevel == -1){
			FlxG.switchState(new OptionState());
		}
		else {
			FlxG.switchState(new Level(_lastLevel));
		}
	}
}
