package isometricvoxels.engine.modding;

import isometricvoxels.engine.util.AssetUtil;
#if (MODDING && hscript)
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
#end

/**
 * A class for implementing HScript functionally to something.
**/
class HScriptHandler {
    /**
     * A map of all the HScript handlers.
    **/
    static public var instances:Map<String, HScriptHandler> = [];


    #if (MODDING && hscript)
    /**
     * The identifier of the HScript handler.
    **/
    public var id:String;

    /**
     * The name of the HScript file as it appears in the scripts folder.
    **/
    public var file:String;

    /**
     * A parser used to convert strings to scripts.
    **/
    public var parser:Parser;

    /**
     * The program of the script.
    **/
    public var program:Expr;

    /**
     * An interpeter used for understanding code.
    **/
    public var interp:Interp;
    #end


    /**
     * Removes an instance from the `instances` map.
     * The instance will also stop running!
     *
     * @param id The identifier of the instance.
    **/
    static public function removeInstance(id:String) {
        if (instances.exists(id)) {
            var handler:HScriptHandler = instances.get(id);
            handler.parser = null;
            handler.program = null;
            handler.interp = null;
            instances.remove(id);
        } else
            trace('HScriptHandler with an id of $id does NOT exist!');
    }


    /**
     * Creates a new HScript handler.
     *
     * @param id An identifier for the handler.
     * @param file The name of the HScript file as it appears in the scripts folder.
    **/
    public function new(id:String, file:String, autoExecute:Bool = true) {
        if (instances.exists(id))
            trace('An HScriptHandler with the id of $id already exists! Replacing...');
        instances.set(id, this);
        this.id = id;
        this.file = file;

        #if (MODDING && hscript)
        // Creates the parser
        parser = new Parser();
        parser.allowJSON = true;
        parser.allowMetadata = true;
        parser.allowTypes = true;
        parser.resumeErrors = true;

        // Gets the script
        var scriptPath:String = AssetUtil.getScript(file);
        if (!AssetUtil.exists(scriptPath)) {
            trace('$scriptPath was not found!');
            return;
        }

        // Creates the program and interpreter
        program = parser.parseString(AssetUtil.getText(scriptPath));
        interp = new Interp();

        // Defines the variables & functions
        defineVars();
        defineFuncs();

        // Executes the script
        if (autoExecute)
            execute();
        #end
    }

    /**
     * Defines a variable to to the interpreter.
    **/
    public function setVar(key:String, value:Dynamic) {
        #if (MODDING && hscript)
        if (interp != null)
            interp.variables.set(key, value);
        #end
    }

    /**
     * Defines the variables that the interpreter can understand.
    **/
    public function defineVars() {
        #if (MODDING && hscript)
        if (interp != null) {
            // Misc
            setVar('Math', Math);

            // Flixel
            setVar('FlxG', flixel.FlxG);
            setVar('FlxMath', flixel.math.FlxMath);
            setVar('FlxSprite', flixel.FlxSprite);
            setVar('FlxObject', flixel.FlxObject);
            setVar('FlxState', flixel.FlxState);

            // Isometric Voxels
            setVar('Voxel', isometricvoxels.engine.voxel.Voxel);
            setVar('VoxelGrid', isometricvoxels.engine.voxel.world.VoxelGrid);
            setVar('VoxelWorld', isometricvoxels.engine.voxel.world.VoxelWorld);
            setVar('AssetUtil', isometricvoxels.engine.util.AssetUtil);
            setVar('MathUtil', isometricvoxels.engine.util.MathUtil);
            setVar('VoxelUtil', isometricvoxels.engine.util.VoxelUtil);
            setVar('Constants', isometricvoxels.engine.util.Constants);
            setVar('Actions', isometricvoxels.engine.input.Actions);
            setVar('HScriptHandler', isometricvoxels.engine.modding.HScriptHandler);
            setVar('ModHandler', isometricvoxels.engine.modding.ModHandler);
            setVar('PlayState', isometricvoxels.game.PlayState);
        }
        #end
    }

    /**
     * Defines functions that the interpreter can understand.
    **/
    public function defineFuncs() {
        #if (MODDING && hscript)
        if (interp != null) {
            // CALLBACKS
            setVar('onCreate', function() {});
            setVar('onUpdate', function(elapsed:Float) {});
            setVar('onDestroy', function() {});

            // FUNCTIONS
            setVar('import', function(libPath:String) {
                var splitPath:Array<String> = libPath.split('.');
                var libName = splitPath[splitPath.length - 1];
                setVar(libName, Type.resolveClass(libPath));
            });
        }
        #end
    }

    /**
     * Calls a function from the script.
     *
     * @param func The name of the function to run.
     * @param args A list of arguments for the function.
    **/
    public function call(func:String, ?args:Array<Dynamic>) {
        #if (MODDING && hscript)
        if (interp != null && interp.variables.exists(func))
            Reflect.callMethod(null, interp.variables.get(func), args?.copy() ?? []);
        #end
    }

    /**
     * Executes the script and runs the code in it.
    **/
    public function execute() {
        #if (MODDING && hscript)
        if (interp != null && program != null)
            interp.execute(program);
        #end
    }
}