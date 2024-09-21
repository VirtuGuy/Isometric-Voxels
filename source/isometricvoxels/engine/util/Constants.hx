package isometricvoxels.engine.util;

import flixel.FlxG;

/**
 * A class with constant variables that can be used across the engine.
**/
class Constants {
    /**
     * The size used for the tiles.
    **/
    inline static public var TILE_SIZE = 64;

    /**
     * The width of the window in tiles.
     * This needs to be updated if the game's window size was modified.
    **/
    inline static public var WINDOW_TILE_WIDTH = Math.floor(640 / TILE_SIZE);

    /**
     * The height of the window in tiles.
     * This needs to be updated if the game's window size was modified.
    **/
    inline static public var WINDOW_TILE_HEIGHT = Math.floor(480 / TILE_SIZE);
}