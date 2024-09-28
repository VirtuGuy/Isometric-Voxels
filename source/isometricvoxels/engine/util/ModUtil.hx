package isometricvoxels.engine.util;

#if (MODDING && polymod)
import polymod.Polymod;
#end


/**
 * A utility class for handling mod support. `ModUtil` is only compatible for desktop!
**/
class ModUtil {
    /**
     * The directory where mod folders can be located.
    **/
    inline static public var MOD_DIR = './mods/';

    /**
     * The current version of the modding system.
     * Mods that use the incorrect version will not be loaded in!
    **/
    inline static public var API_VER = '1.0.0';

    /**
     * A list of mod ids that are currently loaded.
    **/
    static public var mods:Array<String> = [];


    /**
     * Initializes and reloads the modding system.
    **/
    static public function init() {
        #if (MODDING && polymod)
        Polymod.init({
            modRoot: MOD_DIR,
            dirs: mods,
            framework: OPENFL,
            apiVersionRule: API_VER,
            errorCallback: _onError
        });
        Polymod.clearCache();
        #end
    }

    /**
     * Loads a mod into the modding system.
     *
     * @param modId The string id of the mod.
    **/
    static public function loadMod(modId:String) {
        if (!mods.contains(modId))
            mods.push(modId);
        init();
    }

    /**
     * Unloads a mod that's loaded in the modding system.
     *
     * @param modId The string id of the mod.
    **/
    static public function unloadMod(modId:String) {
        if (mods.contains(modId))
            mods.remove(modId);
        init();
    }

    /**
     * Loads every mod located in the mods folder.
    **/
    static public function loadAllMods() {
        #if (MODDING && polymod)
        for (mod in Polymod.scan({apiVersionRule: API_VER}))
            loadMod(mod.id);
        #end
    }

    /**
     * Unloads every mod that's already loaded in the modding system.
    **/
    static public function unloadAllMods() {
        for (mod in mods)
            unloadMod(mod);
    }


    #if (MODDING && polymod)
    static function _onError(error:PolymodError) {
        switch (error.code) {
            case FRAMEWORK_INIT | FRAMEWORK_AUTODETECT:
                return;
            default:
                trace(error.message);
        }
    }
    #end
}