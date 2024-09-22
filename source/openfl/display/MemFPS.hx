package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;


/**
 * FPS class extension to display memory usage.
 *
 * @author Kirill Poletaev
**/
class MemFPS extends TextField {
	/**
	 * An array of stamped times used to calculate FPS.
	**/
	private var times:Array<Float>;

	/**
	 * The maximum amount of memory reached.
	**/
	private var memPeak:Float = 0;


	/**
	 * Creates a new `MemFPS` text field.
	 *
	 * @param inX The initial X position of the `MemFPS` text field.
	 * @param inY The initial Y position of the `MemFPS` text field.
	 * @param inCol The initial text color of the `MemFPS` text field.
	**/
	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000) {
		super();
		this.x = inX;
		this.y = inY;

		selectable = false;
		defaultTextFormat = new TextFormat("_sans", 12, inCol);
		text = "FPS: ";

		times = [];
		width = 150;
		height = 70;

        addEventListener(Event.ENTER_FRAME, onEnter);
	}
	

	/**
	 * Runs when the `MemFPS` text field enters a new frame.
	**/
	private function onEnter(_) {
		// FPS
		var now = Timer.stamp();
		times.push(now);
		while (times[0] < now - 1)
			times.shift();

		// MEMORY
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100)/100;
		if (mem > memPeak) memPeak = mem;

		// TEXT DISPLAY
		if (visible)
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";	
	}
}