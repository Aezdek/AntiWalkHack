# Player Anticheat System

## Overview
This script is designed to detect and prevent player movement exploits in a Roblox game. It monitors player positions and flags excessive movement speeds or jumps. If a player exceeds the allowed thresholds, they are flagged, and upon reaching a maximum number of flags, they are either kicked or eliminated based on configuration settings.

## Features
- Monitors player movement for excessive speed and jump height.
- Flags players who exceed the allowed speed/height.
- Configurable maximum flag count before taking action.
- Configurable maximum speed and jumpHeight.
- Option to kick or eliminate flagged players.
- Automatically clears player data upon leaving to prevent memory leaks.

## How it works
1. A new task is created for each player.
2. Player Position is Saved
3. After a 0.5 second delay, New Positions are saved
4. Positions are compared and action is taken.

## Configuration
1. Create a [SERVER SIDED](https://devforum.roblox.com/t/what%E2%80%99s-the-difference-between-a-local-script-and-a-server-script/2452614) Script In ServerScriptService
2. Paste [Speedhack Script]([Speedhack.lua](https://github.com/Aezdek/AntiWalkHack/blob/main/SpeedHack.lua)) into the new script.
3. Modify the `config` table in the script to customize the anticheat settings:

```lua
local config = {
    WalkSpeed = 16, -- Default WalkSpeed 
    JumpHeight = 50, -- Default JumpHeight
    MaxFlags = 5, -- Max Flags before Player is Kicked
    kickPlayer = true -- Kick Player or no.
}
```

## Notes
- Modify the script If you have a **Teleport/Sprint** System as this script **will** interfere with it.
- Use DataStoreService to save the bans or use your own Ban System.
- Custom Models **without** __HumanoidRootPart__ are not supported, as this script heavily relies on it.
