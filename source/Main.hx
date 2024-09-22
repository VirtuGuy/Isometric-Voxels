package;

import flixel.FlxGame;
import isometricvoxels.game.PlayState;
import openfl.display.MemFPS;
import openfl.display.Sprite;

/**
 * The main class of the engine.
 * This is the class that starts the game and adds an FPS counter to it.
**/
class Main extends Sprite {
	/**
	 * Creates a new `Main` sprite.
	 * This will start the game and implement an FPS counter to it.
	**/
	override public function new() {
		super();

		// GAME
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true, false));

		// FPS COUNTER
		#if !mobile
		addChild(new MemFPS(5, 5, 0xFFFFFFFF));
		#end
	}
}
