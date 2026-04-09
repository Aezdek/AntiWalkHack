# AntiWalkHack - Roblox Speed & Jump Exploit Detection

A lightweight, server-sided anticheat for Roblox that detects and punishes speed hacking and fly hacking by comparing player positions over time.

## How It Works

1. Every 0.5 seconds, the player's position is sampled
2. The delta (change in position) is calculated
3. If horizontal movement or vertical movement exceeds the configured thresholds, the player is flagged and teleported back
4. Once a player hits the flag limit, they are kicked or killed depending on config

## Setup

1. Create a **Script** in `ServerScriptService` (not a LocalScript)
2. Paste the contents of `SpeedHack.lua` into it
3. Adjust the `config` table at the top to match your game:

```lua
local config = {
    WalkSpeed  = 16,   -- Match your game's default WalkSpeed
    JumpHeight = 50,   -- Match your game's JumpHeight
    MaxFlags   = 5,    -- How many violations before action is taken
    kickPlayer = true  -- true = kick, false = kill
}
```

## Features

- Per-player task-based position tracking
- Teleports exploiter back to last safe position on detection
- Configurable thresholds, flag limit, and punishment
- Automatic cleanup on player leave — no memory leaks
- Handles respawns correctly (cancels and restarts task on CharacterAdded)
- Horizontal movement checked as combined X+Z vector (more accurate than checking axes separately)

## Notes

> ⚠️ If your game has a **sprint or speed boost system**, temporarily disable the anticheat or raise `WalkSpeed` during those states — otherwise legitimate players will be flagged.

> ⚠️ Custom characters without a `HumanoidRootPart` are not supported.

> Please do not rely on this anticheat, this is just a prototype!

> This script runs **server-sided only**

## What It Doesn't Catch
(The title literally says AntiSpeedHack) so it ofcourse does not do the following
- Teleport hacks (single large position jump, it is detectable but needs tuning)
- Noclip
- Aim hacks, ESP, or any client-side visual exploits

## License

MIT — credit to [Aezdek](https://github.com/Aezdek) appreciated in derivative projects.
