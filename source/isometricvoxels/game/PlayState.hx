package isometricvoxels.game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import isometricvoxels.engine.util.ActionUtil;
import isometricvoxels.engine.util.ModUtil;
import isometricvoxels.engine.voxel.world.VoxelWorld;


/**
 * `PlayState` is the main `FlxState` used in the engine.
 * This state provides a `VoxelWorld` object and some debug info about the `VoxelWorld`.
**/
class PlayState extends FlxState {
	/**
	 * The main `VoxelWorld` used in the state.
	**/
	public var world:VoxelWorld;

	/**
	 * `FlxText` that shows debugging info such as world place voxel position.
	**/
	public var debugInfo:FlxText;

	/**
	 * An `FlxCamera` used for displaying UI.
	**/
	public var hudCam:FlxCamera;


	override public function create() {
		// INIT
		ModUtil.loadAllMods();
		ActionUtil.init();
		FlxG.mouse.visible = false;

		// VOXEL WORLD
		world = new VoxelWorld();
		add(world);

		// CAMERA
		hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;
		FlxG.cameras.add(hudCam, false);

		// DEBUG INFO
		debugInfo = new FlxText(0, 16, 0, '', 18);
		debugInfo.alignment = RIGHT;
		debugInfo.cameras = [hudCam];
		add(debugInfo);

		super.create();
	}

	override public function update(elapsed:Float) {
		// DEBUG INFO
		var placeX:Float = world.placeVoxel.tileX - world.worldX;
		var placeY:Float = world.placeVoxel.tileY - world.worldY;
		var placeZ:Float = world.placeVoxel.tileZ - world.worldZ;
		debugInfo.text = 'Position:\nX: $placeX\nY: $placeY\nZ: $placeZ\n\nZoom: ${world.camZoom}';
		debugInfo.x = FlxG.width - debugInfo.width;

		super.update(elapsed);
	}

	override public function destroy() {
		super.destroy();
		FlxG.cameras.remove(hudCam);
	}
}
