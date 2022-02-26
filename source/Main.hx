package;

#if MODS_ALLOWED
import polymod.Polymod.Framework;
import polymod.Polymod.PolymodError;
#end

#if sys
import sys.ssl.Key;
#end
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import lime.app.Application;
import lime.utils.Assets;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsVar:FPS;

	var initState:Class<FlxState> = TitleState;

	public function new()
	{
		super();

		setupGame();
	}

	function setupGame():Void
	{
		addChild(new FlxGame(0, 0, initState, 1, 60, 60, true, true));

		trace('Running version: ' + Application.current.meta.get('version'));

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		if (fpsVar != null)
		{
			fpsVar.visible = true;
		}
		#end
		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
	}
}
