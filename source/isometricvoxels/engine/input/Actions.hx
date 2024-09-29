package isometricvoxels.engine.input;

import flixel.input.FlxInput.FlxInputState;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionSet;
import flixel.input.keyboard.FlxKey;

/**
 * An `FlxActionSet` with input actions that can be used.
**/
class Actions extends FlxActionSet {
    /**
     * An instance of `Actions` that can be used throughout the engine.
    **/
    static public var instance(get, null):Actions;

    // ACTIONS
    static var _move_left = new FlxActionDigital('move_left');
    static var _move_right = new FlxActionDigital('move_right');
    static var _move_up = new FlxActionDigital('move_up');
    static var _move_down = new FlxActionDigital('move_down');
    static var _layer_up = new FlxActionDigital('layer_up');
    static var _layer_down = new FlxActionDigital('layer_down');

    static var _cam_left = new FlxActionDigital('cam_left');
    static var _cam_right = new FlxActionDigital('cam_right');
    static var _cam_up = new FlxActionDigital('cam_up');
    static var _cam_down = new FlxActionDigital('cam_down');

    static var _button_a = new FlxActionDigital('button_a');
    static var _button_b = new FlxActionDigital('button_b');

    static var _place = new FlxActionDigital('place');
    static var _remove = new FlxActionDigital('remove');

    // CHECKS
    public var MOVE_LEFT(get, never):Bool; inline function get_MOVE_LEFT() return _move_left.check();
    public var MOVE_RIGHT(get, never):Bool; inline function get_MOVE_RIGHT() return _move_right.check();
    public var MOVE_UP(get, never):Bool; inline function get_MOVE_UP() return _move_up.check();
    public var MOVE_DOWN(get, never):Bool; inline function get_MOVE_DOWN() return _move_down.check();
    public var LAYER_UP(get, never):Bool; inline function get_LAYER_UP() return _layer_up.check();
    public var LAYER_DOWN(get, never):Bool; inline function get_LAYER_DOWN() return _layer_down.check();

    public var CAM_LEFT(get, never):Bool; inline function get_CAM_LEFT() return _cam_left.check();
    public var CAM_RIGHT(get, never):Bool; inline function get_CAM_RIGHT() return _cam_right.check();
    public var CAM_UP(get, never):Bool; inline function get_CAM_UP() return _cam_up.check();
    public var CAM_DOWN(get, never):Bool; inline function get_CAM_DOWN() return _cam_down.check();

    public var BUTTON_A(get, never):Bool; inline function get_BUTTON_A() return _button_a.check();
    public var BUTTON_B(get, never):Bool; inline function get_BUTTON_B() return _button_b.check();

    public var PLACE(get, never):Bool; inline function get_PLACE() return _place.check();
    public var REMOVE(get, never):Bool; inline function get_REMOVE() return _remove.check();


    /**
     * Creates a new `Actions` action set.
    **/
    public function new() {
        super('actions');

        // Adds the actions
        add(_move_left);
        add(_move_right);
        add(_move_up);
        add(_move_down);
        add(_layer_up);
        add(_layer_down);
        add(_cam_left);
        add(_cam_right);
        add(_cam_up);
        add(_cam_down);
        add(_button_a);
        add(_button_b);
        add(_place);
        add(_remove);

        // Binds the keys
        bindKeys(_move_left, [A]);
        bindKeys(_move_right, [D]);
        bindKeys(_move_up, [W]);
        bindKeys(_move_down, [S]);
        bindKeys(_layer_up, [E]);
        bindKeys(_layer_down, [Q]);

        bindKeys(_cam_left, [LEFT], PRESSED);
        bindKeys(_cam_right, [RIGHT], PRESSED);
        bindKeys(_cam_up, [UP], PRESSED);
        bindKeys(_cam_down, [DOWN], PRESSED);

        bindKeys(_button_a, [R]);
        bindKeys(_button_b, [T]);

        _place.addMouse(LEFT, JUST_PRESSED);
        _remove.addMouse(RIGHT, JUST_PRESSED);
    }

    /**
     * Binds a list of keyboard keys to an action.
     *
     * @param action The action you want the keys binded to.
     * @param keys The list of keyboard keys.
     * @param trigger What state triggers this action (PRESSED, JUST_PRESSED, RELEASED, JUST_RELEASED).
    **/
    static public function bindKeys(action:FlxActionDigital, keys:Array<FlxKey>, ?trigger:FlxInputState = JUST_PRESSED) {
        if (action == null) return;
        clearAction(action);
        for (key in keys)
            action.addKey(key, trigger ?? JUST_PRESSED);
    }

    /**
     * Clears an action.
     *
     * @param action The action you want to clear.
    **/
    static public function clearAction(action:FlxActionDigital) {
        if (action == null) return;
        action.removeAll();
    }


    static function get_instance():Actions {
        return instance ?? new Actions();
    }
}