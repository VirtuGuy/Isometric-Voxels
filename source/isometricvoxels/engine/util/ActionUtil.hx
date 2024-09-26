package isometricvoxels.engine.util;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionDigital;

/**
 * A utility class for handling action input.
**/
class ActionUtil {
    /**
     * An instance of `ActionUtil` that can be used for getting action inputs.
    **/
    static public var instance(get, default):ActionUtil;

    // ACTIONS
    static var _move_left:FlxActionDigital;
    static var _move_right:FlxActionDigital;
    static var _move_up:FlxActionDigital;
    static var _move_down:FlxActionDigital;
    static var _layer_up:FlxActionDigital;
    static var _layer_down:FlxActionDigital;
    static var _rotate:FlxActionDigital;

    static var _cam_left:FlxActionDigital;
    static var _cam_right:FlxActionDigital;
    static var _cam_up:FlxActionDigital;
    static var _cam_down:FlxActionDigital;
    static var _cam_reset:FlxActionDigital;

    static var _place:FlxActionDigital;
    static var _remove:FlxActionDigital;
    static var _clear:FlxActionDigital;

    // CHECKS
    public var MOVE_LEFT(get, never):Bool;
    private function get_MOVE_LEFT():Bool {
        return _move_left?.check() ?? false;
    }

    public var MOVE_RIGHT(get, never):Bool;
    private function get_MOVE_RIGHT():Bool {
        return _move_right?.check() ?? false;
    }

    public var MOVE_UP(get, never):Bool;
    private function get_MOVE_UP():Bool {
        return _move_up?.check() ?? false;
    }

    public var MOVE_DOWN(get, never):Bool;
    private function get_MOVE_DOWN():Bool {
        return _move_down?.check() ?? false;
    }

    public var LAYER_UP(get, never):Bool;
    private function get_LAYER_UP():Bool {
        return _layer_up?.check() ?? false;
    }

    public var LAYER_DOWN(get, never):Bool;
    private function get_LAYER_DOWN():Bool {
        return _layer_down?.check() ?? false;
    }

    public var ROTATE(get, never):Bool;
    private function get_ROTATE():Bool {
        return _rotate?.check() ?? false && !FlxG.keys.pressed.CONTROL && !FlxG.keys.pressed.ALT;
    }

    public var CAM_LEFT(get, never):Bool;
    private function get_CAM_LEFT():Bool {
        return _cam_left?.check() ?? false;
    }

    public var CAM_RIGHT(get, never):Bool;
    private function get_CAM_RIGHT():Bool {
        return _cam_right?.check() ?? false;
    }

    public var CAM_UP(get, never):Bool;
    private function get_CAM_UP():Bool {
        return _cam_up?.check() ?? false;
    }

    public var CAM_DOWN(get, never):Bool;
    private function get_CAM_DOWN():Bool {
        return _cam_down?.check() ?? false;
    }

    public var CAM_RESET(get, never):Bool;
    private function get_CAM_RESET():Bool {
        return _cam_reset?.check() ?? false && FlxG.keys.pressed.ALT && !FlxG.keys.pressed.CONTROL;
    }

    public var PLACE(get, never):Bool;
    private function get_PLACE():Bool {
        return _place?.check() ?? false;
    }

    public var REMOVE(get, never):Bool;
    private function get_REMOVE():Bool {
        return _remove?.check() ?? false;
    }

    public var CLEAR(get, never):Bool;
    private function get_CLEAR():Bool {
        return _clear?.check() ?? false && FlxG.keys.pressed.CONTROL && !FlxG.keys.pressed.ALT;
    }

    // HANDLER

    /**
     * Creates a new `ActionUtil` instance.
    **/
    public function new() {}
    
    /**
     * Initializes the `ActionUtil` class and its actions.
    **/
    static public function init() {
        instance = new ActionUtil();

        // ACTION INIT
        _move_left = new FlxActionDigital('move_left');
        _move_right = new FlxActionDigital('move_right');
        _move_up = new FlxActionDigital('move_up');
        _move_down = new FlxActionDigital('move_down');
        _layer_up = new FlxActionDigital('layer_up');
        _layer_down = new FlxActionDigital('layer_down');
        _rotate = new FlxActionDigital('rotate');

        _cam_left = new FlxActionDigital('cam_left');
        _cam_right = new FlxActionDigital('cam_right');
        _cam_up = new FlxActionDigital('cam_up');
        _cam_down = new FlxActionDigital('cam_down');
        _cam_reset = new FlxActionDigital('cam_reset');

        _place = new FlxActionDigital('place');
        _remove = new FlxActionDigital('remove');
        _clear = new FlxActionDigital('clear');

        // INPUT
        _move_left.addKey(A, JUST_PRESSED);
        _move_right.addKey(D, JUST_PRESSED);
        _move_up.addKey(W, JUST_PRESSED);
        _move_down.addKey(S, JUST_PRESSED);
        _layer_up.addKey(E, JUST_PRESSED);
        _layer_down.addKey(Q, JUST_PRESSED);
        _rotate.addKey(R, JUST_PRESSED);

        _cam_left.addKey(LEFT, PRESSED);
        _cam_right.addKey(RIGHT, PRESSED);
        _cam_up.addKey(UP, PRESSED);
        _cam_down.addKey(DOWN, PRESSED);
        _cam_reset.addKey(R, JUST_PRESSED);

        _place.addMouse(LEFT, JUST_PRESSED);
        _remove.addMouse(RIGHT, JUST_PRESSED);
        _clear.addKey(R, JUST_PRESSED);
    }


    static function get_instance():ActionUtil {
        return instance ?? new ActionUtil();
    }
}