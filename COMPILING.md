# Compiling the Engine

This is a guide on how to properly compile the engine's source code. Follow the steps carefully, so you don't experience any issues.

## Dependencies

- Install [Haxe 4.3.2](https://haxe.org/download/version/4.3.2/)
- Open command prompt and run the commands `haxelib install hmm` and `haxelib run hmm setup`.
- From the source code directory, run the command `hmm install`.

## Platforms

### Windows

- Install the [Visual Studio 2022 Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe).
- Once you get the option, click `Individual components`.
- Download `MSVC v143 VS 2022 C++ x64/x86 build tools` and `Windows 10/11 SDK`.

### MacOS

- Install the latest version of Xcode from the MacOS App Store.

### Linux

- Install g++. If you want to compile the engine in 32-bit, you will also need `gcc-multilib` and `g++-multilib`.

## Commands

Congratulations on managing to complete the previous steps. Now you can finally compile the engine! From the source code directory, run `lime test [target]` in command prompt.
Replace `[target]` with the platform you're compiling for. The platforms the engine can compile for would be `windows`, `mac`, `linux`, and `html5`. To compile the engine in debug mode, add `-debug` at the end of the command line.

## Conclusion

I hope this was helpful and that everything went well. If you've had any issues, please report them.
