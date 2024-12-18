package isometricvoxels.engine.util;

/**
 * A class with constant variables that can be used across the engine.
**/
class Constants {
    /**
     * The size used for the tiles.
    **/
    inline static public final TILE_SIZE = 64;

    /**
     * The width of the window in tiles.
     * This needs to be updated if the game's window size was modified.
    **/
    inline static public final WINDOW_TILE_WIDTH = Math.floor(640 / TILE_SIZE);

    /**
     * The height of the window in tiles.
     * This needs to be updated if the game's window size was modified.
    **/
    inline static public final WINDOW_TILE_HEIGHT = Math.floor(480 / TILE_SIZE);

    /**
     * The width of every prompt in pixels.
    **/
    inline static public final PROMPT_WIDTH = 400;

    /**
     * The height of every prompt in pixels.
    **/
    inline static public final PROMPT_HEIGHT = 350;

    /**
     * The amount of pixels applied between buttons in a prompt.
    **/
    inline static public final PROMPT_BUTTON_SPACING = 5;

    #if DISCORD
    /**
     * The Discord Application ID used for the Discord Rich Presence.
    **/
    inline static public final DISCORD_APPLICATION_ID:String = '1301274930041851985';
    #end
}