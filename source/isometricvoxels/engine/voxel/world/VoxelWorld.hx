package isometricvoxels.engine.voxel.world;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import isometricvoxels.engine.input.Actions;
import isometricvoxels.engine.util.AssetUtil;
import isometricvoxels.engine.util.Constants;
import isometricvoxels.engine.util.MathUtil;
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
     * A list of tiles that can be placed in the `VoxelWorld`.
    **/
    public var tiles:Array<String> = [];

    /**
     * The index of the currently selected tile.
    **/
    public var curTile:Int = 0;

    /**
     * The intended zoom value of the `VoxelWorld` camera.
    **/
    public var camZoom:Float = 1;

    /**
     * The minimum zoom the `VoxelWorld` camera can be at.
    **/
    public var minZoom:Float = 1;

    /**
     * The maximum zoom the `VoxelWorld` camera can be at.
    **/
    public var maxZoom:Float = 1.5;

    /**
     * Whether you want the `VoxelWorld` camera zoom value to use linear interpolation for zooming.
     * This will make zooming in and out look fancier.
    **/
    public var lerpZoom:Bool = true;

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
     * The color that the voxels will appear as. This does not affect the grid.
    **/
    public var lightColor(default, set):FlxColor = 0xFFFFFFFF;


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
    worldLength:Int = 5, bgColor:FlxColor = 0xFF64B4FF, lightColor:FlxColor = 0xFFFFFFFF) {
        super();
        this.worldX = Constants.WINDOW_TILE_WIDTH - worldWidth;
        this.worldY = Constants.WINDOW_TILE_HEIGHT + 1;
        this.worldZ = worldZ;
        this.worldWidth = worldWidth;
        this.worldHeight = worldHeight;
        this.worldLength = worldLength;
        this.lightColor = lightColor;

        // TILE LIST
        var listPath:String = AssetUtil.getDataFile('tilesList.txt');
        if (AssetUtil.exists(listPath))
            tiles = AssetUtil.getTextAsArray(listPath);

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

        placeVoxel = new Voxel(worldX, worldY, worldZ, tiles[curTile]);
        placeVoxel.alpha = 0.5;
        placeVoxel.cameras = [worldCam];
        placeVoxel.color = lightColor;
        add(placeVoxel);
    }

    override public function update(elapsed:Float) {
        // MOVE KEYS
        var moveLeft:Bool = Actions.instance.MOVE_LEFT;
        var moveRight:Bool = Actions.instance.MOVE_RIGHT;
        var moveUp:Bool = Actions.instance.MOVE_UP;
        var moveDown:Bool = Actions.instance.MOVE_DOWN;
        var layerUp:Bool = Actions.instance.LAYER_UP;
        var layerDown:Bool = Actions.instance.LAYER_DOWN;
        var rotate:Bool = Actions.instance.BUTTON_A && !FlxG.keys.pressed.CONTROL && !FlxG.keys.pressed.ALT;

        // CAMERA KEYS
        var camLeft:Bool = Actions.instance.CAM_LEFT;
        var camRight:Bool = Actions.instance.CAM_RIGHT;
        var camUp:Bool = Actions.instance.CAM_UP;
        var camDown:Bool = Actions.instance.CAM_DOWN;
        var camReset:Bool = Actions.instance.BUTTON_A && !FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.ALT;

        // PLACEMENT KEYS
        var placeKey:Bool = Actions.instance.PLACE;
        var removeKey:Bool = Actions.instance.REMOVE;
        var clearKey:Bool = Actions.instance.BUTTON_A && FlxG.keys.pressed.CONTROL && !FlxG.keys.pressed.ALT;

        // TILE SELECTION AND CAMERA ZOOMING
        if (FlxG.mouse.wheel != 0) {
            var scroll:Int = FlxG.mouse.wheel;
            #if web
            scroll = Math.floor(scroll / 125);
            #end

            if (hasBuilding && !FlxG.keys.pressed.CONTROL) {
                curTile += scroll;
                if (curTile < 0) curTile = tiles.length - 1;
                if (curTile >= tiles.length) curTile = 0;
                placeVoxel.tileName = tiles[curTile];
            } else {
                camZoom += scroll * 0.1;
                if (camZoom < minZoom)
                    camZoom = minZoom;
                else if (camZoom > maxZoom)
                    camZoom = maxZoom;
            }
        }

        // CAMERA ZOOM
        var zoomValue:Float = camZoom;
        if (lerpZoom)
            zoomValue = MathUtil.lerp(worldCam.zoom, camZoom, 0.1);
        worldCam.zoom = zoomValue;

        // PLACE VOXEL MOVEMENT
        if (hasBuilding) {
            // Place voxel movement
            if (moveUp || moveDown)
                placeVoxel.tileX += moveUp ? -1 : 1;
            if (layerDown || layerUp)
                placeVoxel.tileY += layerDown ? 1 : -1;
            if (moveLeft || moveRight)
                placeVoxel.tileZ += moveLeft ? -1 : 1;

            // Move sound
            if (moveLeft || moveRight || moveUp || moveDown || layerUp || layerDown || (rotate && placeVoxel.hasDirections))
                FlxG.sound.play(AssetUtil.getSound('move'), 0.6);

            // Tile bound
            placeVoxel.tileX = FlxMath.bound(placeVoxel.tileX, worldX, worldX + (worldWidth - 1));
            placeVoxel.tileY = FlxMath.bound(placeVoxel.tileY, worldY - (worldHeight - 1), worldY);
            placeVoxel.tileZ = FlxMath.bound(placeVoxel.tileZ, worldZ, worldZ + (worldLength - 1));
    
            // Rotation
            if (rotate && placeVoxel.hasDirections)
                placeVoxel.direction += 90;
        }

        // VOXEL PLACEMENT
        if ((placeKey && canPlace) || (removeKey && canRemove))
            setVoxel(placeVoxel.tileX, placeVoxel.tileY, placeVoxel.tileZ, placeKey ? placeVoxel.tileName : '');
        if (clearKey)
            clearVoxels();

        // CAMERA MOVEMENT
        if (camLeft || camRight) {
            var dir:Float = camLeft ? -100 : 100;
            dir *= elapsed * 2;
            worldCamObject.x += dir;
        }
        if (camDown || camUp) {
            var dir:Float = camDown ? 100 : -100;
            dir *= elapsed * 2;
            worldCamObject.y += dir;
        }

        // CAMERA RESET
        if (camReset) {
            worldCamObject.screenCenter();
            camZoom = 1;
        }

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
        var changedVoxel:Bool = true;
        var hasVoxel:Bool = voxel != null;

        if (hasVoxel) {
            if (tileName == voxel.tileName)
                changedVoxel = false;

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
        } else if (tileName != '') {
            // Creates a new voxel if tileName isn't an empty string value
            var voxel:Voxel = new Voxel(tileX, tileY, tileZ, tileName);
            voxel.color = lightColor;
            if (voxel.hasDirections)
                voxel.direction = placeVoxel.direction;
            voxels.add(voxel);

            // Sorts the voxels
            VoxelUtil.sortVoxelsInGroup(voxels);
        }

        // Plays a placing/removing sound
        if ((changedVoxel && tileName != '') || (tileName == '' && hasVoxel)) {
            if (tileName == '')
                FlxG.sound.play(AssetUtil.getSound('remove'));
            else
                FlxG.sound.play(AssetUtil.getSound('place'));
        }

        // Updates the visibility of the voxels
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
        // Plays the "remove" sound
        if (voxels.length > 0)
            FlxG.sound.play(AssetUtil.getSound('clear'));

        // Removes the voxels
        VoxelUtil.clearVoxelsInGroup(voxels);
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

    private function set_lightColor(value:FlxColor):FlxColor {
        this.lightColor = value;

        // Sets the color of the voxels
        if (voxels != null) {
            for (voxel in voxels)
                voxel.color = value;
        }
        if (placeVoxel != null)
            placeVoxel.color = value;

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