local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local MovementController = require(
    VAESHIDA
        :WaitForChild("Controllers")
        :WaitForChild("MovementController")
)

print("================================")
print("[VAESHIDA] CLIENT INITIALISÉ")
print("================================")

print("[VAESHIDA] Architecture client chargée.")

MovementController.Initialize()
