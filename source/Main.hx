package;

import flixel.FlxGame;
import isometricvoxels.game.PlayState;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();

		addChild(new FlxGame(0, 0, PlayState, 60, 60, true, false));
		addChild(new FPS(5, 5, 0xFFFFFFFF));
	}
}
