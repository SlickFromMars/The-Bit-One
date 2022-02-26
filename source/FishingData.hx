package;

import openfl.Assets;
import flixel.FlxG;
import haxe.Json;
#if sys
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;s
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef FishClass =
{
    name:String,
    poolWeight:Int,
    rodLevel:Int,
    fishList:Array<FishData>
}

typedef FishData =
{
    name:String,
    image:String,
    rarity:Int,
    poolWeight:Int
}

class FishingData
{
    public static var groupList:Array<String>;
    public static var classList:Map<String, FishClass> = new Map<String, FishClass>();

    public static function reloadFishList() {
        groupList = [];
        classList.clear();

        var hitList:Array<String> = CoolUtil.coolTextFile('assets/fish/groupList.txt');

        #if sys
        for(file in FileSystem.readDirectory('assets/fish/')) {
            if(file != 'groupList.txt' && !hitList.contains(file.split('.')[0])) {
                hitList.push(file.split('.')[0]);
            }
        }
        #end

        for(item in hitList) {
            var fileToCheck:String = 'assets/fish/' + item;

            var data = parseClass(fileToCheck);
            if(data != null) {
                groupList.push(item);
                classList.set(item, data);
            }
        }

        trace('Fish classes loaded! ' + groupList);
    }

    static function parseClass(path:String):FishClass {
        var data:FishClass = {
            name: 'Unknown',
            fishList: [],
            poolWeight: 1,
            rodLevel: 1
        };

        if(Path.fileExists(path + '.txt')) {
            var rawTextData:Array<String> = CoolUtil.coolTextFile(path + '.txt');
            var myList:Array<FishData> = [];
            var tagThing:Array<String>;

            for(line in 0...rawTextData.length) {
                if(rawTextData[line].startsWith('grp_')) {
                    tagThing = rawTextData[line].split(" # ");
                    switch(tagThing[0]) {
                        case 'grp_name':
                            data.name = tagThing[1];
                        case 'grp_weight': 
                            data.poolWeight = Std.parseInt(tagThing[1]);
                        case 'grp_rodLevel':
                            data.rodLevel = Std.parseInt(tagThing[1]);
                    }
                } else if(rawTextData[line].contains('::')) {
                    var dummyFish:FishData = {
                        name: "Unknown",
                        image: "flipper_or",
                        rarity: 1,
                        poolWeight: 0
                    };
                    var sillyData:Array<String> = rawTextData[line].split('::');

                    dummyFish.name = sillyData[0];
                    dummyFish.image = sillyData[1];
                    dummyFish.rarity = Std.parseInt(sillyData[2]);
                    dummyFish.poolWeight = Std.parseInt(sillyData[3]);

                    myList.push(dummyFish);
                }
            }

            data.fishList = myList;

            formatToJson(data);

            return data;
        } else if(Path.fileExists(path + '.json')){
            data = Json.parse(Assets.getText(path + '.json'));

            if(data.name != null && data.fishList.length > 0) {
                return data;
            }
        }

        return null;
    }

    #if sys private static var _file:FileReference; #end

    static function formatToJson(data:FishClass):Void {
        trace('The file for ' + data.name + ' was stored as a text file. It will be reformatted.');
        #if sys
        var rawJson:String = Json.stringify(data, "\t");

        if (rawJson.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(rawJson, data.name.toLowerCase() + ".json");
		}

        FileSystem.deleteFile('assets/fish/' + data.name.toLowerCase() + ".txt");
        #end
    }

    #if sys
    private static function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
		private static function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	private static function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}
    #end
}