# nl_cmd

NL_CMD is an advanced papyrus framework created for the purpose of supporting the addition of new console commands to Skyrim SSE. \
From day one it was designed with accessibility in mind, providing easy-to-use functions to simplify console - papyrus communication. \
Registering and unregistering new commands is almost as easy as registering for plain old, vanilla papyrus events, and argument parsing is built-in from the get-go.

Notably the mod has no additional dependencies besides SKSE and should always be compatible with every game version that SKSE supports. 

## Main Features

* Actual support for new console commands
* In-game help documentation
    - Supports individual command descriptions
* Argument parsing support
    - Supports all the basic types: bool, int float, form, string
    - Parsing is done automatically, all you need to do is define the callback types!
* Built-in SendModEvent functionality
    - Ever wanted to send mod events directly from the console? Now you can.
* Built-in console API
    - Clear the console
    - Print to console
    - Get the last console command
    - Get the current console selection
    - All without any .dll dependencies!
* Advanced command registration
    - Register and unregister commands on the fly - in-game!

## Releases

**Latest release from master branch:**

[![](https://github.com/MrOctopus/nl_cmd/actions/workflows/ci.yml/badge.svg)](https://github.com/MrOctopus/nl_cmd/actions/workflows/ci.yml)

**Latest release on the Nexus:**

[Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/62497)

## Documentation

* The source documentation is available in the [Wiki](https://github.com/MrOctopus/nl_cmd/wiki/Home).

### Examples
Several uses of nl_cmd are demonstrated in the scripts present in the [examples folder](https://github.com/MrOctopus/nl_cmd/tree/master/examples).

### Compiling

**Pyro**
| Steps | Description                                                              |
|-------|--------------------------------------------------------------------------|
| 1.    | Import https://github.com/MrOctopus/nl_online/tree/main/skse64/source     |
| 2.    | Import https://github.com/MrOctopus/nl_cmd/tree/master/src/scripts/source |

### Distribution

| Method         | Description                                                              |
|----------------|--------------------------------------------------------------------------|
| Dependency     | Make nl_cmd a download requirement, and link users to the [Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/62497) page |
| Redistribution | Redistribute the nl_cmd mod files along with your mod  

## Licenses

All files in this repository are released under the [MIT License](LICENSE.md) with the following exceptions:
* If you are planning on releasing a nl_cmd mod through redistributing any of the mod files, I only require you to include my name as well as a link to the github repository or nexus page in your credits.