package isometricvoxels.engine.util;

import flixel.FlxG;


/**
 * A utility class used for math.
**/
class MathUtil {
    /**
     * Gets a linear-interpolated value with framerate-independency.
     *
     * @param base The start value of the lerp.
     * @param target The goal value of the lerp.
     * @param rate How fast the value reaches its goal in the lerp.
     *
     * @return The value of the framerate-independent lerp.
    **/
    inline static public function lerp(base:Float, target:Float, rate:Float):Float {
        return base + (target - base) * (1 - Math.exp(-rate * (FlxG.elapsed * 60)));
    }
}