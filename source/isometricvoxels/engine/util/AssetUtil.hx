package isometricvoxels.engine.util;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.system.System;
import openfl.utils.Assets;

using StringTools;


/**
 * A utility class for handling assets.
**/
class AssetUtil {
    /**
     * Gets an image from the images folder.
     *
     * @param key The key name of the file excluding the extension.
     *
     * @return The image graphic asset.
    **/
    inline static public function getImage(key:String):FlxGraphicAsset {
        var path:String = 'assets/images/$key.png';
        if (exists(path))
            return Assets.getBitmapData(path);
        else
            return null;
    }

    /**
     * Gets a sound from the sounds folder.
     *
     * @param key The key name of the file excluding the extension.
     *
     * @return The sound asset.
    **/
    inline static public function getSound(key:String):FlxSoundAsset {
        var path:String = 'assets/sounds/$key.wav';
        if (exists(path))
            return Assets.getSound(path);
        else
            return null;
    }

    /**
     * Gets the path to a file in the `data` folder.
     *
     * @param key The key name of the file.
     *
     * @return The path to the file.
    **/
    inline static public function getDataFile(key:String):String {
        return 'assets/data/$key';
    }


    /**
     * @return The text content of a file from `path`.
    **/
    inline static public function getText(path:String):String {
        var content:String = '';
        if (exists(path))
            content = Assets.getText(path);
        return content;
    }

    /**
     * Clears the asset cache from memory.
    **/
    static public function clearCache() {
        Assets.cache.clear();
        System.gc();
    }

    /**
     * @return Each line of text of a file from `path` as a string in an array.
    **/
    inline static public function getTextAsArray(path:String):Array<String> {
        var content:String = getText(path).trim();
        var lines:Array<String> = content.split('\n');
        
        // Line trimming
        for (i in 0...lines.length)
            lines[i] = lines[i].trim();

        return lines;
    }

    /**
     * @return Whether `path` exists or not.
    **/
    inline static public function exists(path:String):Bool {
        return Assets.exists(path);
    }
}