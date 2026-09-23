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

local QuestController = require(
    VAESHIDA
        :WaitForChild("Controllers")
        :WaitForChild("QuestController")
)

local DialogueController = require(
    VAESHIDA
        :WaitForChild("Controllers")
        :WaitForChild("DialogueController")
)

print("================================")
print("[VAESHIDA] CLIENT INITIALISÉ")
print("================================")

MovementController.Initialize()
CameraController.Initialize()
QuestController.Initialize()
DialogueController.Initialize()

print("[VAESHIDA] Systèmes client chargés.")
