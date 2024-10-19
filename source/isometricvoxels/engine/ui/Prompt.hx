package isometricvoxels.engine.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import isometricvoxels.engine.util.Constants;


/**
 * An `FlxGroup` used to be a prompt.
**/
class Prompt extends FlxGroup {
    /**
     * The title of the prompt.
    **/
    public var title:String;

    /**
     * An array of strings that are loaded in as buttons.
    **/
    public var options:Array<String> = [];

    /**
     * The black, translucent background sprite.
    **/
    public var bg:FlxSprite;

    /**
     * `FlxText` used for displaying the title of the prompt.
    **/
    public var titleText:FlxText;

    /**
     * A group of buttons that display each string in `options`.
    **/
    public var buttons:FlxTypedGroup<FlxButton>;


    /**
     * A callback that will run when the prompt closes.
    **/
    public var onPromptClose:Void->Void;

    /**
     * A callback that will run when an option button is pressed.
    **/
    public var onButtonPressed:Int->Void;
    

    /**
     * Creates a new `Prompt` object.
     *
     * @param title The title of the prompt that will appear at the top of the prompt.
     * @param options An array of strings that are loaded in as buttons that appear at the bottom of the prompt.
    **/
    override public function new(?title:String, ?options:Array<String>) {
        super();
        this.title = title ?? '';
        this.options = options ?? [];

        // Creates the background
        bg = new FlxSprite();
        bg.makeGraphic(Constants.PROMPT_WIDTH, Constants.PROMPT_HEIGHT, 0xFF000000);
        bg.screenCenter();
        bg.alpha = 0.7;
        bg.active = false;
        add(bg);

        // Creates the title text
        titleText = new FlxText(0, 0, 0, title, 32);
        titleText.screenCenter(X);
        titleText.y = bg.y + titleText.height;
        titleText.active = false;
        add(titleText);

        // Creates the buttons
        buttons = new FlxTypedGroup<FlxButton>();
        add(buttons);

        var totalWidth:Float = 0;

        for (i in 0...options.length) {
            var button:FlxButton = new FlxButton(0, 0, options[i], () -> {
                if (onButtonPressed != null)
                    onButtonPressed(i);
            });
            button.ID = i;
            button.y = bg.y + bg.height - button.height - 24;
            buttons.add(button);

            totalWidth += button.width;
        }
        
        buttons.forEach(button -> {
            button.x = bg.x + (bg.width - totalWidth) / 2;
            if (options.length > 1)
                button.x -= Constants.PROMPT_BUTTON_SPACING * 1.5;
            button.x += button.ID * (button.width + Constants.PROMPT_BUTTON_SPACING);
        });
    }

    /**
     * Closes the prompt.
    **/
    public function close() {
        if (onPromptClose != null)
            onPromptClose();
        kill();
        destroy();
    }
}