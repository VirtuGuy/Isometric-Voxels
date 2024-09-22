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
    **/
    static public var WINDOW_TILE_WIDTH(default, never) = Math.floor(FlxG.width / TILE_SIZE);

    /**
     * The height of the window in tiles.
    **/
    static public var WINDOW_TILE_HEIGHT(default, never) = Math.floor(FlxG.height / TILE_SIZE);

    /**
     * A list of tiles that can be placed in a `VoxelWorld`.
    **/
    static public var TILES(default, never) = [
        'tile',
        'grass',
        'dirt',
        'wood',
        'tile-stair',
        'grass-stair',
        'dirt-stair',
        'wood-stair'
    ];
}