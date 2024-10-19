package isometricvoxels.engine.voxel;

import flixel.FlxSprite;
import haxe.Json;
import isometricvoxels.engine.util.AssetUtil;
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
     * Data used for the current tile.
    **/
    public var data:VoxelData;


    /**
     * Whether the `Voxel` has directions or not.
     * This value is determined by if the tile name is a stair, or anything else that can rotate.
    **/
    public var hasDirections(get, never):Bool;

    /**
     * Whether the `Voxel` occludes neighboring voxels from being visible on screen.
     * This should be disabled for stairs and transparent blocks.
    **/
    public var occludes(get, never):Bool;


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
    }

    /**
     * Sets the XYZ position of the `Voxel` object in the isometric view.
     *
     * @param tileX The X position in tiles.
     * @param tileY The Y position in tiles.
     * @param tileZ The Z position in tiles.
    **/
    public function setIsometricPosition(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0) {
        var w:Float = Constants.TILE_SIZE / 2;
        x = (tileX * w) + (tileZ * w);
        y = (w / 2 * tileX) + (w * tileY - (w / 2 * tileZ));
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

    private function set_tileName(value:Null<String>):String {
        if (this.tileName == value || value == null) return value;
        this.tileName = value;
        this.active = false;

        // Gets the voxel data for the tile
        var dataPath:String = AssetUtil.getDataFile('tiles/$value.json');
        if (AssetUtil.exists(dataPath))
            data = Json.parse(AssetUtil.getText(dataPath));
        else
            data = {
                occludes: true,
                directional: false
            }

        // Clears the cache
        AssetUtil.clearCache();

        // Loads the tile graphic
        loadGraphic(AssetUtil.getImage('tiles/$value'), hasDirections, Std.int(Constants.TILE_SIZE / 2), 0);

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
        if (animation.exists('direction$value') && hasDirections)
            animation.play('direction$value');

        return value;
    }


    private function get_hasDirections():Bool {
        return data?.directional ?? false;
    }

    private function get_occludes():Bool {
        return data?.occludes ?? true;
    }
}

typedef VoxelData = {
    occludes:Null<Bool>,
    directional:Null<Bool>
}