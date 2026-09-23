local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local MovementController = require(
    VAESHIDA
        :WaitForChild("Controllers")
        :WaitForChild("MovementController")
)

local CameraController = require(
    VAESHIDA
        :WaitForChild("Controllers")
        :WaitForChild("CameraController")
)

print("================================")
print("[VAESHIDA] CLIENT INITIALISÉ")
print("================================")

MovementController.Initialize()
CameraController.Initialize()

print("[VAESHIDA] Systèmes client chargés.")
