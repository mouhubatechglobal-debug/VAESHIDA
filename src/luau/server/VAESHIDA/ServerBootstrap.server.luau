local Players = game:GetService("Players")

local PlayerService = require(
    script.Parent
        :WaitForChild("Services")
        :WaitForChild("PlayerService")
)

local TestWorldService = require(
    script.Parent
        :WaitForChild("Services")
        :WaitForChild("TestWorldService")
)

print("================================")
print("[VAESHIDA] SERVEUR INITIALISÉ")
print("================================")

TestWorldService.Create()

for _, player in Players:GetPlayers() do
    PlayerService.InitializePlayer(player)
end

print("[VAESHIDA] Services serveur chargés.")
