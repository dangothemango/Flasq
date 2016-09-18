package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;


class OptionState extends FlxState
{
	private var _pageTitle:FlxText;
	private var _volumeText:FlxText;
	#if desktop
	private var _resolutionText:FlxButton;
	#end
	private var _volumeDown:FlxButton;
	private var _volumeUp:FlxButton;
	private var _volumeBar:FlxBar;
	private var _volumeLevel:FlxText;
	private var _backButton:FlxButton;

	
	override public function create() : Void {
		_pageTitle = new FlxText(0, 20, 0, "Options", 22);
		_pageTitle.alignment = CENTER;
		_pageTitle.screenCenter(FlxAxes.X);
		add(_pageTitle);
		
		_volumeText = new FlxText(0, _pageTitle.y + _pageTitle.height + 10, 0, "Volume");
		_volumeText.alignment = CENTER;
		_volumeText.screenCenter(FlxAxes.X);
		add(_volumeText);
		
		_volumeDown = new FlxButton(8, _volumeText.y + _volumeText.height + 2, "-", clickVolumeDown);
		add(_volumeDown);
		
		_volumeUp = new FlxButton((FlxG.width - _volumeDown.width - 8), _volumeDown.y, "+", clickVolumeUp);
		add(_volumeUp);
		
		_volumeBar = new FlxBar(_volumeDown.x + _volumeDown.width + 4, _volumeDown.y, LEFT_TO_RIGHT, Std.int(FlxG.width - 2*_volumeUp.width -24), Std.int(_volumeDown.height));
		_volumeBar.createFilledBar(0xff464646, FlxColor.WHITE, true);
		add(_volumeBar);
		
		_volumeLevel = new FlxText(0, 0, 200, (FlxG.sound.volume * 100) + "%", 8);
		_volumeLevel.alignment = CENTER;
		_volumeLevel.y = _volumeBar.y + (_volumeBar.height / 2) - (_volumeLevel.height / 2);
		_volumeLevel.screenCenter(FlxAxes.X);
		add(_volumeLevel);
		
		#if desktop
		_resolutionText = new FlxButton(0, _volumeBar.y + _volumeBar.height + 8, FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED", clickResolution);
		_resolutionText.screenCenter(FlxAxes.X);
		add(_resolutionText);
		#end
		
		_backButton = new FlxButton(0, FlxG.height - 28, "Back", clickBack);
		_backButton.screenCenter(FlxAxes.X);
		add(_backButton);
		
		updateVolume();
		
		super.create();
	}

	override public function update(elapsed:Float) : Void {
		super.update(elapsed);
	}
	
	#if desktop
	private function clickResolution():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		_resolutionText.text = FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED";
	}
	#end
	
	function clickVolumeDown() : Void {
		FlxG.sound.volume -= 0.1;
		updateVolume();
	}
	
	function clickVolumeUp() : Void {
		FlxG.sound.volume += 0.1;
		updateVolume();
	}
	
	function updateVolume() : Void {
		var vol:Int = Math.round(FlxG.sound.volume * 100);
		_volumeBar.value = vol;
		_volumeLevel.text = vol + "%";
	}
	
	function clickBack() : Void {
		FlxG.switchState(new MenuState());
	}
}
