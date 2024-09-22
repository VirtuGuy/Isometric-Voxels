package isometricvoxels.engine.voxel.world;

import flixel.group.FlxGroup.FlxTypedGroup;
import isometricvoxels.engine.util.VoxelUtil;

/**
 * A voxel grid that goes in the X and Z directions.
**/
class VoxelGrid extends FlxTypedGroup<Voxel> {
    /**
     * The X position offset in tiles.
    **/
    public var tileX(default, set):Float = 0;

    /**
     * The Y position offset in tiles.
    **/
    public var tileY(default, set):Float = 0;

    /**
     * The Z position offset in tiles.
    **/
    public var tileZ(default, set):Float = 0;

    /**
     * The width of the `Grid` object in tiles.
    **/
    public var gridWidth(default, set):Int;

    /**
     * The length of the `Grid` object in tiles.
    **/
    public var gridLength(default, set):Int;


    /**
     * Creates a new `VoxelGrid` object.
     *
     * @param tileX The X position offset in tiles.
     * @param tileY The Y position offset in tiles.
     * @param tileZ The Z position offset in tiles.
     * @param gridWidth How many voxels there should be on the X axis.
     * @param gridHeight How many voxels there should be on the Z axis.
    **/
    override public function new(tileX:Float = 0, tileY:Float = 0, tileZ:Float = 0, gridWidth:Int = 5, gridLength:Int = 5) {
        super();
        this.tileX = tileX;
        this.tileY = tileY;
        this.tileZ = tileZ;
        this.gridWidth = Std.int(Math.abs(gridWidth));
        this.gridLength = Std.int(Math.abs(gridLength));
    }

    /**
     * Completely reloads the grid.
    **/
    public function reloadGrid() {
        // Clears the grid
        for (voxel in members) {
            voxel.kill();
            voxel.destroy();
        }
        clear();

        // GRID VOXEL CREATION
        for (w in 0...gridWidth) {
            for (l in 0...gridLength) {
                var voxel:Voxel = new Voxel(tileX + w, tileY, tileZ + l, 'grid');
                add(voxel);
            }
        }

        // VOXEL SORTING
        VoxelUtil.sortVoxelsInGroup(this);
    }


    private function set_tileX(value:Float):Float {
        this.tileX = value;
        reloadGrid();
        return value;
    }

    private function set_tileY(value:Float):Float {
        this.tileY = value;
        reloadGrid();
        return value;
    }

    private function set_tileZ(value:Float):Float {
        this.tileZ = value;
        reloadGrid();
        return value;
    }

    private function set_gridWidth(value:Int):Int {
        this.gridWidth = value;
        reloadGrid();
        return value;
    }

    private function set_gridLength(value:Int):Int {
        this.gridLength = value;
        reloadGrid();
        return value;
    }
}