package isometricvoxels.game;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import isometricvoxels.engine.input.Actions;
import isometricvoxels.engine.modding.ModHandler;
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
		ModHandler.loadAllMods();
		Actions.init();
		FlxG.mouse.visible = false;
		FlxG.stage.showDefaultContextMenu = false;

		// VOXEL WORLD
		var bgColor:FlxColor = 0xFF64B4FF;
		var date:Date = Date.now();
		
		// Halloween BG color
		#if HOLIDAY_THEMES
		if (date.getMonth() == 9 && date.getDate() == 31) // Halloween
			bgColor = 0xFFFA9C4F;
		#end
		world = new VoxelWorld(0, 5, 5, 5, bgColor);
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
		debugInfo.text = 'Position:\nX: $placeX\nY: $placeY\nZ: $placeZ\nTile: ${world.tiles[world.curTile]}\n\nZoom: ${world.camZoom}';
		debugInfo.x = FlxG.width - debugInfo.width;

		super.update(elapsed);
	}

	override public function destroy() {
		super.destroy();

		// Removes the HUD camera
		FlxG.cameras.remove(hudCam);
	}
}
