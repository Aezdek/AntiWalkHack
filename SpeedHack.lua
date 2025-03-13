local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Configuration For Script
--// Modify this table
local config = {
	WalkSpeed = 16, --// Default WalkSpeed 
	JumpHeight = 50, --// Default JumpHeight
	MaxFlags = 5, --// Max Flags before Player is Kicked
	kickPlayer = true --// Kick Player or no.
}

--// Player Data 
local PlayerData = {
	Flags = {},
	bans = {},
	Positions = { Old = {}, New = {} },
	PlayerTasks = {}
}

function clearTables(uid)
	PlayerData.Flags[uid] = nil --// optional u can store them with a db to save them 
	PlayerData.Positions[uid] = nil
	PlayerData.PlayerTasks[uid] = nil
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local HRP = character:FindFirstChild("HumanoidRootPart")
		if not HRP then player:Kick("Rejoin Please") end --// Kick User as HRP not found

		--// Initialize the values
		PlayerData.Positions[player.UserId] = { Old = { X = 0, Y = 0, Z = 0 }, New = { X = 0, Y = 0, Z = 0 } }
		PlayerData.Flags[player.UserId] = 0

		--// Setup a new Task for each player!
		PlayerData.PlayerTasks[player.UserId] = task.spawn(function()
			while true do
				--// Check if Player is still in game.
				if not player and not Players:FindFirstChild(player.Name) then
					clearTables(player.UserId)
					break
				end

				--// Store Old Positions
				local currentPos = HRP.Position
				local old = PlayerData.Positions[player.UserId].Old
				old.X, old.Y, old.Z = currentPos.X, currentPos.Y, currentPos.Z

				--// Induce a 0.5 second delay to recheck positions 
				task.wait(0.5)

				local new = PlayerData.Positions[player.UserId].New
				currentPos = HRP.Position --// Update The Variable
				new.X, new.Y, new.Z = currentPos.X, currentPos.Y, currentPos.Z

				--// Find Change in Positions (delta)
				local deltaX, deltaY, deltaZ = math.abs(new.X - old.X), math.abs(new.Y - old.Y), math.abs(new.Z - old.Z)

				--// Check positions
				if deltaX > config.WalkSpeed + 2 then
					PlayerData.Flags[player.UserId] = PlayerData.Flags[player.UserId] + 1
					HRP.CFrame = CFrame.new(old.X, old.Y, old.Z)
				end

				if deltaY > config.JumpHeight + 2 then
					PlayerData.Flags[player.UserId] = PlayerData.Flags[player.UserId] + 1
					HRP.CFrame = CFrame.new(old.X, old.Y, old.Z)
				end

				if deltaZ > config.WalkSpeed + 2 then
					PlayerData.Flags[player.UserId] = PlayerData.Flags[player.UserId] + 1
					HRP.CFrame = CFrame.new(old.X, old.Y, old.Z)
				end

				--// Final Check to kick Player if Flags > allowedFlags
				if PlayerData.Flags[player.UserId] > config.MaxFlags then
					if config.kickPlayer then
						player:Kick("Exploit Detected!")
						clearTables(player.UserId)
					else
						HRP.Parent:FindFirstChild("Humanoid").Health = 0 --// Kill Player ;P
					end
				end
			end
		end)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	--// When the player is leaving the game. Clear their data
	--// One last check
	if not player then
		clearTables(player.UserId)
	end
end)
