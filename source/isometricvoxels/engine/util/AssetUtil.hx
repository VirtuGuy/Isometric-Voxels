package isometricvoxels.engine.util;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.utils.Assets;

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
        return Assets.getBitmapData('assets/images/$key.png');
    }

    /**
     * Gets a sound from the sounds folder.
     *
     * @param key The key name of the file excluding the extension.
     *
     * @return The sound asset.
    **/
    inline static public function getSound(key:String):FlxSoundAsset {
        return Assets.getSound('assets/sounds/$key.wav');
    }
}