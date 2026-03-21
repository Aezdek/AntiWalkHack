local Players = game:GetService("Players")

--// Configuration
local config = {
	WalkSpeed = 16,   -- Default WalkSpeed
	JumpHeight = 50,  -- Default JumpHeight
	MaxFlags  = 5,    -- Flags before action is taken
	kickPlayer = true -- true = kick, false = kill
}

--// Player Data
local PlayerData = {
	Flags       = {},
	Positions   = {},
	PlayerTasks = {}
}

local function clearTables(uid)
	PlayerData.Flags[uid]       = nil
	PlayerData.Positions[uid]   = nil
	PlayerData.PlayerTasks[uid] = nil
end

local function handleDetection(player, hrp, oldPos)
	PlayerData.Flags[player.UserId] += 1

	-- Teleport back to last safe position
	hrp.CFrame = CFrame.new(oldPos)

	-- Take action if flags exceeded
	if PlayerData.Flags[player.UserId] >= config.MaxFlags then
		clearTables(player.UserId)

		if config.kickPlayer then
			player:Kick("Exploit Detected.")
		else
			local humanoid = hrp.Parent:FindFirstChildOfClass("Humanoid")
			if humanoid then humanoid.Health = 0 end
		end

		return true -- signal to break the loop
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local hrp = character:WaitForChild("HumanoidRootPart", 5)

		if not hrp then
			player:Kick("Character failed to load. Please rejoin.")
			return
		end

		-- Initialise player data
		PlayerData.Flags[player.UserId]     = 0
		PlayerData.Positions[player.UserId] = hrp.Position

		-- Cancel any existing task for this player (respawn case)
		if PlayerData.PlayerTasks[player.UserId] then
			task.cancel(PlayerData.PlayerTasks[player.UserId])
		end

		PlayerData.PlayerTasks[player.UserId] = task.spawn(function()
			while player and player.Parent do
				local oldPos = hrp.Position
				task.wait(0.5)

				-- Player may have left during the wait
				if not player.Parent then break end

				local newPos = hrp.Position
				local delta  = (newPos - oldPos)

				local dx = math.abs(delta.X)
				local dy = math.abs(delta.Y)
				local dz = math.abs(delta.Z)

				-- Combined X+Z horizontal check
				local horizontalDelta = math.sqrt(dx^2 + dz^2)

				if horizontalDelta > config.WalkSpeed + 2 then
					if handleDetection(player, hrp, oldPos) then break end
				end

				if dy > config.JumpHeight + 2 then
					if handleDetection(player, hrp, oldPos) then break end
				end
			end

			clearTables(player.UserId)
		end)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if PlayerData.PlayerTasks[player.UserId] then
		task.cancel(PlayerData.PlayerTasks[player.UserId])
	end
	clearTables(player.UserId)
end)
