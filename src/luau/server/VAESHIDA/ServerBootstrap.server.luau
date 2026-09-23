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

local QuestService = require(
    script.Parent
        :WaitForChild("Services")
        :WaitForChild("QuestService")
)

local NPCService = require(
    script.Parent
        :WaitForChild("Services")
        :WaitForChild("NPCService")
)

print("================================")
print("[VAESHIDA] SERVEUR INITIALISÉ")
print("================================")

TestWorldService.Create()

for _, player in Players:GetPlayers() do
    PlayerService.InitializePlayer(player)
end

QuestService.Initialize()

NPCService.Initialize()

print("[VAESHIDA] Services serveur chargés.")
print("[VAESHIDA] Système de quêtes chargé.")
print("[VAESHIDA] Système de PNJ chargé.")
