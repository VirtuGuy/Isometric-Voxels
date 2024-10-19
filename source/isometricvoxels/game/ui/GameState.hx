package isometricvoxels.game.ui;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import isometricvoxels.engine.input.Actions;
import isometricvoxels.engine.ui.Prompt;
import isometricvoxels.game.modding.ModHandler;


/**
 * An `FlxState` used as the base class for all states in the game.
**/
class GameState extends FlxState {
    /**
     * Whether the game is initialized or not.
    **/
    static public var initialized:Bool = false;


    /**
	 * An `FlxCamera` used for displaying UI.
	**/
	public var hudCam:FlxCamera;

    /**
     * An `FlxCamera` used for displaying prompts.
    **/
    public var promptCam:FlxCamera;

    /**
     * The currently active `Prompt` object in the state.
    **/
    public var curPrompt:Prompt;


    /**
     * Creates a new `GameState` state.
    **/
    override public function new() {
        super();

        // INIT
        if (!initialized) {
            initialized = true;

            ModHandler.loadAllMods();
            Actions.init();

            FlxG.stage.showDefaultContextMenu = false;
            FlxG.stage.quality = LOW;
        }

        // CAMERA
		hudCam = new FlxCamera();
		hudCam.bgColor = 0x00000000;

        promptCam = new FlxCamera();
        promptCam.bgColor = 0x00000000; 
    }

    override public function create() {
        super.create();

        // Adds the cameras
        FlxG.cameras.add(hudCam, false);
        FlxG.cameras.add(promptCam, false);
    }

    /**
     * Displays a new `Prompt` object.
     *
     * @param prompt The `Prompt` object to show.
    **/
    public function showPrompt(prompt:Prompt) {
        hidePrompt();

        curPrompt = prompt;
        curPrompt.cameras = [promptCam];
        add(curPrompt);

        return curPrompt;
    }

    /**
     * Removes and destroys the current prompt.
    **/
    public function hidePrompt() {
        if (curPrompt != null) {
            curPrompt.close();
            remove(curPrompt, true);
        }
    }
    
    override public function destroy() {
		super.destroy();

		// Removes the cameras
		FlxG.cameras.remove(hudCam);
        FlxG.cameras.remove(promptCam);
	}
}