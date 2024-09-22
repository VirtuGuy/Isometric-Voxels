package isometricvoxels.engine.voxel.world;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import isometricvoxels.engine.util.Constants;
import isometricvoxels.engine.util.VoxelUtil;

/**
 * `VoxelWorld` is a group of voxels that are made into a world.
 * This provides a background and camera movement.
**/
class VoxelWorld extends FlxGroup {
    /**
     * A group that stores voxels.
    **/
    public var voxels:FlxTypedGroup<Voxel>;

    /**
     * The `FlxCamera` used for the `VoxelWorld`.
    **/
    public var worldCam:FlxCamera;

    /**
     * An `FlxObject` that `worldCam` will follow.
    **/
    public var worldCamObject:FlxObject;

    /**
     * A grid used to show where voxels can be placed.
    **/
    public var grid:VoxelGrid;

    /**
     * A `Voxel` that can be moved across the `VoxelWorld` and can also place and remove tiles.
    **/
    public var placeVoxel:Voxel;

    /**
     * The index of the currently selected tile.
    **/
    public var curTile:Int = 0;

    /**
     * The world X position in tiles.
    **/
    public var worldX(default, set):Float = 5;

    /**
     * The world Y position in tiles.
    **/
    public var worldY(default, set):Float = 5;

    /**
     * The world Z position in tiles.
    **/
    public var worldZ(default, set):Float = 5;

    /**
     * How many blocks wide the world is.
    **/
    public var worldWidth(default, set):Int = 0;

    /**
     * How many blocks tall the world is.
    **/
    public var worldHeight(default, set):Int = 0;

    /**
     * How many blocks long the world is.
    **/
    public var worldLength(default, set):Int = 0;

    /**
     * Whether the player can place voxels or not.
     * Disabling both `canPlace` and `canRemove` will completely disable building.
    **/
    public var canPlace(default, set):Bool = true;

    /**
     * Whether the player can remove voxels or not.
     * Disabling both `canPlace` and `canRemove` will completely disable building.
    **/
    public var canRemove(default, set):Bool = true;


    /**
     * If the `VoxelWorld` supports building and removing voxels.
    **/
    public var hasBuilding(get, never):Bool;


    /**
     * Creates a new `VoxelWorld` object.
     *
     * @param worldZ The initial world Z position in tiles.
     * @param worldWidth How many blocks wide the world is.
     * @param worldHeight How many blocks tall the world is.
     * @param worldLength How many blocks long the world is.
     * @param bgColor The `FlxColor` used for the `worldCam` background color.
    **/
    override public function new(worldZ:Float = 0, worldWidth:Int = 5, worldHeight:Int = 5,
    worldLength:Int = 5, bgColor:FlxColor = 0xFF64B4FF) {
        super();
        this.worldX = Constants.WINDOW_TILE_WIDTH - worldWidth;
        this.worldY = Constants.WINDOW_TILE_HEIGHT + 1;
        this.worldZ = worldZ;
        this.worldWidth = worldWidth;
        this.worldHeight = worldHeight;
        this.worldLength = worldLength;

        // CAMERA
        worldCam = new FlxCamera();
        worldCam.bgColor = bgColor;
        FlxG.cameras.add(worldCam, false);

        worldCamObject = new FlxObject(0, 0, 50, 50);
        worldCamObject.screenCenter();
        worldCam.follow(worldCamObject, LOCKON);

        // GRID
        grid = new VoxelGrid(worldX, worldY, worldZ, worldWidth, worldLength);
        grid.cameras = [worldCam];
        add(grid);

        // VOXELS
        voxels = new FlxTypedGroup<Voxel>();
        voxels.cameras = [worldCam];
        add(voxels);

        placeVoxel = new Voxel(worldX, worldY, worldZ, Constants.TILES[curTile]);
        placeVoxel.alpha = 0.5;
        placeVoxel.cameras = [worldCam];
        add(placeVoxel);
    }

    override public function update(elapsed:Float) {
        // MOVE KEYS
        var leftPress:Bool = FlxG.keys.justPressed.A;
        var rightPress:Bool = FlxG.keys.justPressed.D;
        var upPress:Bool = FlxG.keys.justPressed.W;
        var downPress:Bool = FlxG.keys.justPressed.S;
        var qPress:Bool = FlxG.keys.justPressed.Q;
        var ePress:Bool = FlxG.keys.justPressed.E;
        var rotatePress:Bool = FlxG.keys.justPressed.R;

        // CAMERA KEYS
        var camLeftPress:Bool = FlxG.keys.pressed.LEFT;
        var camRightPress:Bool = FlxG.keys.pressed.RIGHT;
        var camUpPress:Bool = FlxG.keys.pressed.UP;
        var camDownPress:Bool = FlxG.keys.pressed.DOWN;
        var camPosResetPress:Bool = rotatePress && FlxG.keys.pressed.ALT;

        // PLACE KEYS
        var placePress:Bool = FlxG.mouse.justPressed;
        var removePress:Bool = FlxG.mouse.justPressedRight;
        var clearPress:Bool = rotatePress && FlxG.keys.pressed.CONTROL;

        // TILE SELECTION
        if (FlxG.mouse.wheel != 0 && hasBuilding) {
            curTile += FlxG.mouse.wheel;
            if (curTile < 0) curTile = Constants.TILES.length - 1;
            if (curTile >= Constants.TILES.length) curTile = 0;
            placeVoxel.tileName = Constants.TILES[curTile];
        }

        // PLACE VOXEL MOVEMENT
        if (hasBuilding) {
            if (upPress || downPress)
                placeVoxel.tileX += upPress ? -1 : 1;
            if (qPress || ePress)
                placeVoxel.tileY += qPress ? 1 : -1;
            if (leftPress || rightPress)
                placeVoxel.tileZ += leftPress ? -1 : 1;
            placeVoxel.tileX = FlxMath.bound(placeVoxel.tileX, worldX, worldX + (worldWidth - 1));
            placeVoxel.tileY = FlxMath.bound(placeVoxel.tileY, worldY - (worldHeight - 1), worldY);
            placeVoxel.tileZ = FlxMath.bound(placeVoxel.tileZ, worldZ, worldZ + (worldLength - 1));
    
            if (rotatePress && placeVoxel.hasDirections && !clearPress && !camPosResetPress)
                placeVoxel.direction += 90;
        }

        // VOXEL PLACEMENT
        if ((placePress && canPlace) || (removePress && canRemove))
            setVoxel(placeVoxel.tileX, placeVoxel.tileY, placeVoxel.tileZ, placePress ? placeVoxel.tileName : '');
        if (clearPress)
            clearVoxels();

        // CAMERA MOVEMENT
        if (camLeftPress || camRightPress) {
            var dir:Float = camLeftPress ? -100 : 100;
            dir *= elapsed * 2;
            worldCamObject.x += dir;
        }
        if (camDownPress || camUpPress) {
            var dir:Float = camUpPress ? -100 : 100;
            dir *= elapsed * 2;
            worldCamObject.y += dir;
        }
        if (camPosResetPress)
            worldCamObject.screenCenter();

        super.update(elapsed);
    }


    /**
     * Sets a `Voxel` at the specified tile position.
     *
     * @param tileX The X position in tiles of where the tile should be set.
     * @param tileY The Y position in tiles of where the tile should be set.
     * @param tileZ The Z position in tiles of where the tile should be set.
     * @param tileName The name of the image file used for the tile.
     * If the value is an empty string, the tile in that position will be removed.
    **/
    public function setVoxel(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0, tileName:String = 'tile') {
        var voxel:Voxel = getVoxel(tileX, tileY, tileZ);
        if (voxel != null) {
            // Either removes or changes the tile name of the already existing voxel
            if (tileName == '') {
                voxel.kill();
                voxels.remove(voxel, true);
                voxel.destroy();
            } else {
                voxel.tileName = tileName;
                if (voxel.hasDirections)
                    voxel.direction = placeVoxel.direction;
            }
        }
        else if (tileName != '') {
            // Creates a new voxel is tileName isn't an empty string value
            var voxel:Voxel = new Voxel(tileX, tileY, tileZ, tileName);
            if (voxel.hasDirections)
                voxel.direction = placeVoxel.direction;
            voxels.add(voxel);

            // Sorts the voxels
            VoxelUtil.sortVoxelsInGroup(voxels);
        }
        updateVoxelVisibility();
    }

    /**
     * Gets the `Voxel` at the specified tile position.
     *
     * @param tileX The X position in tiles of where the tile should be set.
     * @param tileY The Y position in tiles of where the tile should be set.
     * @param tileZ The Z position in tiles of where the tile should be set.
     *
     * @returns The voxel found. If no voxel was found at the specified position, null will be returned.
    **/
    public function getVoxel(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0):Voxel {
        for (voxel in voxels) {
            if (voxel.tileX == tileX && voxel.tileY == tileY && voxel.tileZ == tileZ)
                return voxel;
        }
        return null;
    }

    /**
     * Removes all the voxels from the world.
    **/
    public function clearVoxels() {
        for (voxel in voxels) {
            voxel.kill();
            voxel.destroy();
        }
        voxels.clear();
    }


    /**
     * Updates the visibility of all voxels. If a `Voxel` is covered by full `Voxel` objects, it will be invisible.
    **/
    public function updateVoxelVisibility() {
        for (voxel in voxels) {
            var x:Float = voxel.tileX;
            var y:Float = voxel.tileY;
            var z:Float = voxel.tileZ;

            // Hides the voxel is it is completely surrounded by voxels
            var vox1:Voxel = getVoxel(x + 1, y, z);
            var vox2:Voxel = getVoxel(x, y - 1, z);
            var vox3:Voxel = getVoxel(x, y, z - 1);
            var surrounded:Bool = vox1 != null && vox2 != null && vox3 != null && vox1.occludes && vox2.occludes && vox3.occludes;
            voxel.visible = !surrounded;
        }
    }


    private function set_worldX(value:Float):Float {
        this.worldX = value;
        if (grid != null)
            grid.tileX = value;
        if (placeVoxel != null)
            placeVoxel.tileX = value;
        return value;
    }

    private function set_worldY(value:Float):Float {
        this.worldY = value;
        if (grid != null)
            grid.tileY = value;
        if (placeVoxel != null)
            placeVoxel.tileY = value;
        return value;
    }

    private function set_worldZ(value:Float):Float {
        this.worldZ = value;
        if (grid != null)
            grid.tileZ = value;
        if (placeVoxel != null)
            placeVoxel.tileZ = value;
        return value;
    }

    private function set_worldWidth(value:Int):Int {
        this.worldWidth = value;
        if (grid != null)
            grid.gridWidth = value;
        return value;
    }

    private function set_worldHeight(value:Int):Int {
        this.worldHeight = value;
        return value;
    }

    private function set_worldLength(value:Int):Int {
        this.worldLength = value;
        if (grid != null)
            grid.gridLength = value;
        return value;
    }

    private function set_canPlace(value:Bool):Bool {
        this.canPlace = value;

        // Place voxel toggling
        if (placeVoxel != null) {
            placeVoxel.active = hasBuilding;
            placeVoxel.visible = hasBuilding;
        }
        return value;
    }

    private function set_canRemove(value:Bool):Bool {
        this.canRemove = value;

        // Place voxel toggling
        if (placeVoxel != null) {
            placeVoxel.active = hasBuilding;
            placeVoxel.visible = hasBuilding;
        }
        return value;
    }


    private function get_hasBuilding():Bool {
        return canPlace || canRemove;
    }


    override public function destroy() {
        super.destroy();
        FlxG.cameras.remove(worldCam);
    }
}