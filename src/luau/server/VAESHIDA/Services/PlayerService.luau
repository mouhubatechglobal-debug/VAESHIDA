local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerConfig = require(
    ReplicatedStorage
        :WaitForChild("VAESHIDA")
        :WaitForChild("Config")
        :WaitForChild("PlayerConfig")
)

local PlayerService = {}

local playerData = {}

local function createPlayerData()
    return {
        Level = PlayerConfig.StartingLevel,
        XP = PlayerConfig.StartingXP,

        Stats = {
            Health = PlayerConfig.BaseHealth,
            Energy = PlayerConfig.BaseEnergy
        }
    }
end

function PlayerService.GetData(player)
    return playerData[player]
end

function PlayerService.InitializePlayer(player)
    if playerData[player] then
        return
    end

    local data = createPlayerData()

    playerData[player] = data

    print(
        "[VAESHIDA] Joueur initialisé : "
            .. player.Name
            .. " | Niveau : "
            .. data.Level
            .. " | HP : "
            .. data.Stats.Health
            .. " | Énergie : "
            .. data.Stats.Energy
    )
end

function PlayerService.RemovePlayer(player)
    playerData[player] = nil
end

function PlayerService.GetLevel(player)
    local data = playerData[player]

    if not data then
        return nil
    end

    return data.Level
end

function PlayerService.GetXP(player)
    local data = playerData[player]

    if not data then
        return nil
    end

    return data.XP
end

function PlayerService.GetHealth(player)
    local data = playerData[player]

    if not data then
        return nil
    end

    return data.Stats.Health
end

function PlayerService.GetEnergy(player)
    local data = playerData[player]

    if not data then
        return nil
    end

    return data.Stats.Energy
end

Players.PlayerAdded:Connect(function(player)
    PlayerService.InitializePlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerService.RemovePlayer(player)
end)

return PlayerService
