package isometricvoxels.engine.voxel;

import flixel.FlxG;
import flixel.FlxSprite;
import isometricvoxels.engine.util.Constants;

using StringTools;


/**
 * A `Voxel` is an `FlxSprite` that appears as a tile in an isometric view.
**/
class Voxel extends FlxSprite {
    /**
     * The X position in tiles.
    **/
    public var tileX(default, set):Float;

    /**
     * The Y position in tiles.
    **/
    public var tileY(default, set):Float;

    /**
     * The Z position in tiles.
    **/
    public var tileZ(default, set):Float;

    /**
     * The name of the image file used for the tile from `assets/images/tiles`.
    **/
    public var tileName(default, set):String;

    /**
     * The direction that the `Voxel` is facing. 0 = Front, 90 = Right, 180 = Back, 270 = Left.
     * The direction value also resets when going over 360.
    **/
    public var direction(default, set):Int = 0;


    /**
     * Whether the `Voxel` has directions or not.
     * This value is determined by if the tile name is a stair, or anything else that can rotate.
    **/
    public var hasDirections(get, null):Bool;

    /**
     * Whether the `Voxel` occludes neighboring voxels from being visible on screen.
     * This should be disabled for stairs and transparent blocks.
    **/
    public var occludes(get, null):Bool;


    /**
     * Creates a new `Voxel` object.
     *
     * @param tileX The initial X position in tiles.
     * @param tileY The initial Y position in tiles.
     * @param tileZ The initial Z position in tiles.
     * @param tileName The name of the image file that should be used for the tile from `assets/images/tiles`.
    **/
    override public function new(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0, tileName:String = 'tile') {
        super();
        this.tileName = tileName;
        this.tileX = tileX;
        this.tileY = tileY;
        this.tileZ = tileZ;

        // Updating isn't necessary
        active = false;
    }

    /**
     * Sets the XYZ position of the `Voxel` object in the isometric view.
     *
     * @param tileX The X position in tiles.
     * @param tileY The Y position in tiles.
     * @param tileZ The Z position in tiles.
    **/
    public function setIsometricPosition(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0) {
        x = (tileX * frameWidth) + (tileZ * frameWidth);
        y = (frameWidth / 2 * tileX) + (frameWidth * tileY - (frameWidth / 2 * tileZ));
    }

    override public function draw() {
        if (!isOnScreen(cameras[0])) return;
        super.draw();
    }


    private function set_tileX(value:Float):Float {
        this.tileX = value;
        setIsometricPosition(value, tileY, tileZ);
        return value;
    }

    private function set_tileY(value:Float):Float {
        this.tileY = value;
        setIsometricPosition(tileX, value, tileZ);
        return value;
    }

    private function set_tileZ(value:Float):Float {
        this.tileZ = value;
        setIsometricPosition(tileX, tileY, value);
        return value;
    }

    private function set_tileName(value:String):String {
        this.tileName = value;

        // Loads the graphic
        var path:String = 'assets/images/tiles/$value.png';
        var isAnimated:Bool = false;

        // Checks if the graphic is animated
        if (hasDirections)
            isAnimated = true;
        loadGraphic(path, isAnimated, Std.int(Constants.TILE_SIZE / 2), 0);

        // Adds directional animations if the voxel has directions
        if (hasDirections) {
            animation.add('direction0', [0], 12);
            animation.add('direction90', [1], 12);
            animation.add('direction180', [1], 12, true, true);
            animation.add('direction270', [0], 12, true, true);
        }

        // Scales the graphic
        setGraphicSize(Constants.TILE_SIZE, Constants.TILE_SIZE);
        updateHitbox();

        // Resets direction
        if (!hasDirections)
            direction = 0;
        else
            set_direction(direction);

        return value;
    }

    private function set_direction(value:Int):Int {
        // Resets the value if it goes over 270
        if (value > 270)
            value = 0;
        this.direction = value;

        // Plays the animation for the set direction
        if (animation.exists('direction$value'))
            animation.play('direction$value');

        return value;
    }


    private function get_hasDirections():Bool {
        if (tileName.endsWith('-stair'))
            return true;
        return false;
    }

    private function get_occludes():Bool {
        if (tileName.endsWith('-stair'))
            return false;
        return true;
    }
}