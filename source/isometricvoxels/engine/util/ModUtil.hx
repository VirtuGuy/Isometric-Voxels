package isometricvoxels.engine.util;

#if (MODDING && polymod)
import polymod.Polymod;
#end

/**
 * A utility class for handling mod support.
 * `ModUtil` is only compatible for desktop. There's no need for `MODDING` define checks.
**/
class ModUtil {
    /**
     * Initializes the modding system.
    **/
    static public function init() {
        #if (MODDING && polymod)
        Polymod.init({ modRoot: 'mods', framework: OPENFL });
        #end
    }
}