package;

import flixel.addons.transition.Transition;
import haxe.Json;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxState;
#if sys
import sys.FileSystem;
#end
import openfl.Assets;

class FrameState extends FlxState
{
    var inTheThing:Bool = false;

    override function create()
    {
		super.create();
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

   public static function switchState(nextState:FlxState, ?minTime:Float = 5.0) {
		var curState:Dynamic = FlxG.state;
		var leState:FrameState = curState;

		if(minTime == 0.0) {
			if(nextState == FlxG.state) {
				FlxG.resetState();
			} else {
				FlxG.switchState(nextState);
			}

		} else {
			leState.openSubState(new LoadingScreen(minTime));

			if(nextState == FlxG.state) {
				LoadingScreen.finishCallback = function() {
				FlxG.resetState();
				}
			} else {
				LoadingScreen.finishCallback = function() {
				FlxG.switchState(nextState);
				}
			}

			leState.closeSubState();
		}
		return;
	}

    public static function resetState() {
		FrameState.switchState(FlxG.state);
	}

    public static function getState():FrameState {
		var curState:Dynamic = FlxG.state;
		var leState:FrameState = curState;
		return leState;
	}
}