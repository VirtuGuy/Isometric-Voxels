package isometricvoxels.engine.util;

import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import isometricvoxels.engine.voxel.Voxel;

/**
 * A utility class for your voxel related needs!
**/
class VoxelUtil {
    /**
     * Sorts voxels contained in a group to make it look visually correct.
     *
     * @param group The group that contains the voxels to sort.
    **/
    static public function sortVoxelsInGroup(group:FlxTypedGroup<Voxel>) {
        // Sorts the voxels
        group.sort((i, voxel1, voxel2) -> return FlxSort.byValues(i, voxel1.tileX, voxel2.tileX), FlxSort.ASCENDING);
        group.sort((i, voxel1, voxel2) -> return FlxSort.byValues(i, voxel1.tileY, voxel2.tileY), FlxSort.DESCENDING);
        group.sort((i, voxel1, voxel2) -> return FlxSort.byValues(i, voxel1.tileZ, voxel2.tileZ), FlxSort.DESCENDING);
    }

    /**
     * Completely removes all voxels in a group. This fully kills the voxels and destroys them.
    **/
    static public function clearVoxelsInGroup(group:FlxTypedGroup<Voxel>) {
        for (voxel in group) {
            voxel.kill();
            voxel.destroy();
        }
        group.clear();
    }
}