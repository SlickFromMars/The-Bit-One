package;

import flixel.FlxG;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class CoolUtil
{
    public static function coolTextFile(path:String):Array<String>
    {
        var daList:Array<String> = [];
        #if sys
        if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
        #else
        if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
        #end
    
        for (i in 0...daList.length)
        {
            daList[i] = daList[i].trim();
        }
    
        return daList;
    }
}