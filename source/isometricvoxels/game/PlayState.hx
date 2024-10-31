package isometricvoxels.game;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import isometricvoxels.engine.voxel.world.VoxelWorld;
import isometricvoxels.game.ui.GameState;
import isometricvoxels.game.ui.WorldPrompt;
#if DISCORD import isometricvoxels.game.discord.DiscordClient; #end


/**
 * `PlayState` is the main `GameState` used in the engine.
 * This state provides a `VoxelWorld` object and some debug info about the `VoxelWorld`.
**/
class PlayState extends GameState {
	/**
	 * The main `VoxelWorld` used in the state.
	**/
	public var world:VoxelWorld;

	#if DEBUG_INFO
	/**
	 * `FlxText` that shows debugging info such as world place voxel position.
	**/
	public var debugInfo:FlxText;
	#end


	override public function create() {
		// VOXEL WORLD
		var bgColor:FlxColor = 0xFF64B4FF;
		var date:Date = Date.now();
		
		// Halloween BG color
		#if HOLIDAY_THEMES
		if (date.getMonth() == 9 && date.getDate() == 31) // Halloween
			bgColor = 0xFFFA9C4F;
		#end
		world = new VoxelWorld(0, 5, 5, 5, bgColor);
		world.active = false;
		add(world);

		// DEBUG INFO
		#if DEBUG_INFO
		debugInfo = new FlxText(0, 16, 0, '', 18);
		debugInfo.alignment = RIGHT;
		debugInfo.cameras = [hudCam];
		debugInfo.active = false;
		add(debugInfo);
		#end

		// PROMPT
		var prompt:WorldPrompt = new WorldPrompt();
		showPrompt(prompt);

		// Prompt button pressed
		prompt.onButtonPressed = (id:Int) -> {
			prompt.close();

			// Sets the voxel world size
			world.worldWidth = Std.int(prompt.widthStepper.value);
			world.worldHeight = Std.int(prompt.heightStepper.value);
			world.worldLength = Std.int(prompt.lengthStepper.value);
			world.active = true;

			// Makes the mouse visible
			FlxG.mouse.visible = false;

			// Updates the Discord RPC
			#if DISCORD
			DiscordClient.changePresence('Building in a ${world.worldWidth}x${world.worldHeight}x${world.worldLength} world.');
			#end
		}

		// Discord starting presence
		#if DISCORD
		DiscordClient.changePresence('Creating a world.');
		#end

		super.create();
	}

	override public function update(elapsed:Float) {
		// DEBUG INFO
		#if DEBUG_INFO
		var placeX:Float = world.placeVoxel.tileX - world.worldX;
		var placeY:Float = world.placeVoxel.tileY - world.worldY;
		var placeZ:Float = world.placeVoxel.tileZ - world.worldZ;
		debugInfo.text = 'Position:\nX: $placeX\nY: $placeY\nZ: $placeZ\nTile: ${world.tiles[world.curTile]}\n\nZoom: ${world.camZoom}';
		debugInfo.x = FlxG.width - debugInfo.width;
		#end

		super.update(elapsed / 2);
	}
}
