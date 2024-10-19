package isometricvoxels.game.ui;

import flixel.addons.ui.FlxUINumericStepper;
import flixel.text.FlxText;
import isometricvoxels.engine.ui.Prompt;


/**
 * A `Prompt` class used for creating worlds ingame.
**/
class WorldPrompt extends Prompt {
    /**
     * A numeric stepper used for setting the width of a `VoxelWorld`.
    **/
    public var widthStepper:FlxUINumericStepper;

    /**
     * A numeric stepper used for setting the height of a `VoxelWorld`.
    **/
    public var heightStepper:FlxUINumericStepper;

    /**
     * A numeric stepper used for setting the length of a `VoxelWorld`.
    **/
    public var lengthStepper:FlxUINumericStepper;


    /**
     * Creates a new `WorldPrompt` object.
    **/
    override public function new() {
        super('World Creation', ['Create']);

        // Creates the stepper text
        var stepperText:FlxText = new FlxText(0, 0, 0, 'width / height / length', 15);
        stepperText.screenCenter(X);
        stepperText.y = bg.y + bg.height / 2.5;
        stepperText.active = false;
        add(stepperText);

        // Creates the steppers
        var minWorldSize:Int = 5;
        var maxWorldSize:Int = 10;

        widthStepper = new FlxUINumericStepper(0, 0, 1, 5, minWorldSize, maxWorldSize);
        widthStepper.x = bg.x + 50;
        widthStepper.y = stepperText.y + stepperText.height + 2;
        add(widthStepper);

        heightStepper = new FlxUINumericStepper(0, 0, 1, 5, minWorldSize, maxWorldSize);
        heightStepper.screenCenter(X);
        heightStepper.y = widthStepper.y;
        add(heightStepper);

        lengthStepper = new FlxUINumericStepper(0, 0, 1, 5, minWorldSize, maxWorldSize);
        lengthStepper.x = bg.x + bg.width - lengthStepper.width - 50;
        lengthStepper.y = widthStepper.y;
        add(lengthStepper);
    }
}