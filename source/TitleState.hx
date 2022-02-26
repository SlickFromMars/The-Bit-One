package;

import flixel.FlxState;

class TitleState extends FlxState
{
	override public function create()
	{
		#if MODS_ALLOWED
		var modList = FileSystem.readDirectory('mods');
		var newList:Array<String> = [];

		for(file in modList) {
			if(FileSystem.isDirectory('mods/$file')) {
				newList.push(file);
			}
		}

		var errors = (error:PolymodError) ->
		{
			trace(error.severity + ": " + error.code + " - " + error.message + " - ORIGIN: " + error.origin);
		};

		var modMetadata = polymod.Polymod.init({
			modRoot: "mods/",
			dirs: newList,
			errorCallback: errors,
			framework: OPENFL,
			ignoredFiles: polymod.Polymod.getDefaultIgnoreList(),
			frameworkParams: {
				assetLibraryPaths: [
					"data" => "data", "images" => "images", "music" => "music",
					"sounds" => "sounds", "dynamic" => "dynamic", "fonts" => "fonts", "config" => "config"
				]
			}
		});
		#end
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
