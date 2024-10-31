package isometricvoxels.game.discord;

import isometricvoxels.engine.util.Constants;
#if DISCORD
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import openfl.Lib;
import sys.thread.Thread;


/**
 * A Discord Rich Presence client class.
 * This class should only be used for cpp targets.
 * 
 * @see https://discord.com/developers/docs/rich-presence/overview
 */
class DiscordClient {
    /**
     * Whether the Discord RPC client is initialized or not.
     */
    static public var initialized:Bool = false;


    /**
     * Initializes the Discord RPC client.
     */
    static public function init() {
        if (initialized) return;

        trace('Initializing Discord RPC...');

        // Creates the Discord event handlers
        var handlers:DiscordEventHandlers = DiscordEventHandlers.create();
        handlers.ready = cpp.Function.fromStaticFunction(onReady);
        handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
        handlers.errored = cpp.Function.fromStaticFunction(onError);
        Discord.Initialize(Constants.DISCORD_APPLICATION_ID, cpp.RawPointer.addressOf(handlers), 1, null);

        // Creates the client update thread
        Thread.create(() -> {
            while (true) {
                #if DISCORD_DISABLE_IO_THREAD
                Discord.UpdateConnection();
                #end
                Discord.RunCallbacks();
                Sys.sleep(2);
            }
        });

        Lib.application.onExit.add((code:Int) -> Discord.Shutdown());
        initialized = true;
    }

    /**
     * Changes the Rich Presence to have new details and info.
     */
    static public function changePresence(details:String, ?state:String) {
        var presence:DiscordRichPresence = DiscordRichPresence.create();
        presence.details = details;
        if (state != null)
            presence.state = state;

        Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
    }


    static private function onReady(request:cpp.RawConstPointer<DiscordUser>) {
        trace('Discord RPC initialized successfully!');
    }

    static private function onDisconnected(code:Int, message:cpp.ConstCharStar) {
        trace('Discord RPC disconnected! ($code:$message)');
    }

    static private function onError(code:Int, message:cpp.ConstCharStar) {
        trace('Discord RPC error! ($code:$message)');
    }
}
#end