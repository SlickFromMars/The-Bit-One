package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
#end


class LoadingScreen extends FrameSubstate
{
    public static var finishCallback:Void->Void;
    var fadeTime = 0.5;
    public var artThing:String;

    var text:Array<String>;

    var remember:Bool;

    public function new(?minTime:Float = 7.0)
    {
        remember = FlxG.mouse.visible;
        FlxG.mouse.visible = false;

        super();

        if(minTime != 0.0) {
            FlxG.camera.flash(FlxColor.BLACK, 1);

            /*var art:FlxSprite = new FlxSprite(0, 0);
            art.loadGraphic(Path.getPath('', 'image'));
            art.scrollFactor.set(0, 0);
		    art.setGraphicSize(FlxG.width, FlxG.height);
		    art.updateHitbox();
            art.screenCenter();
            add(art); */
        
            new FlxTimer().start(fadeTime + minTime, function(balls:FlxTimer){
                loadComplete();
                trace('load complete!!');
            });
        } else {
            loadComplete();
            trace('load skipped!!');
        }
    }

    override function update(elapsed:Float)
    {
        //UPDATE
    }

    override function destroy() {
        super.destroy();
	}

    function loadComplete() {
        
        if(FlxG.sound.music != null) {
            FlxG.sound.music.fadeOut(fadeTime * 2, 0, function(balls:FlxTween) {
                FlxG.mouse.visible = remember;
                finishCallback();
            });
        } else {
            FlxG.mouse.visible = remember;
            finishCallback();
        }
    }
}