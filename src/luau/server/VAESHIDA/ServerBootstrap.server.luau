local Players = game:GetService("Players")

local PlayerService = require(
    script.Parent
        :WaitForChild("Services")
        :WaitForChild("PlayerService")
)

print("================================")
print("[VAESHIDA] SERVEUR INITIALISÉ")
print("================================")

for _, player in Players:GetPlayers() do
    PlayerService.InitializePlayer(player)
end

print("[VAESHIDA] PlayerService chargé.")
