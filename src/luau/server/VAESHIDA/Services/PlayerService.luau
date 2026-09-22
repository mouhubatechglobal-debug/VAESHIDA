local Players = game:GetService("Players")

local PlayerConfig = require(
    game:GetService("ReplicatedStorage")
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

    playerData[player] = createPlayerData()

    print(
        "[VAESHIDA] Joueur initialisé : "
            .. player.Name
            .. " | Niveau : "
            .. playerData[player].Level
    )
end

function PlayerService.RemovePlayer(player)
    playerData[player] = nil
end

Players.PlayerAdded:Connect(function(player)
    PlayerService.InitializePlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerService.RemovePlayer(player)
end)

return PlayerService
