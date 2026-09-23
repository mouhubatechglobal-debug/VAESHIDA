local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraConfig = require(
    ReplicatedStorage
        :WaitForChild("VAESHIDA")
        :WaitForChild("Config")
        :WaitForChild("CameraConfig")
)

local CameraController = {}

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local humanoidRootPart

local function updateCharacterReferences(newCharacter)
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end

local function updateCamera()
    if not humanoidRootPart then
        return
    end

    local targetPosition =
        humanoidRootPart.Position
        + Vector3.new(0, CameraConfig.Height, 0)

    local cameraPosition =
        targetPosition
        + Vector3.new(0, 0, CameraConfig.Distance)

    local targetCFrame = CFrame.lookAt(
        cameraPosition,
        targetPosition
    )

    camera.CFrame = camera.CFrame:Lerp(
        targetCFrame,
        CameraConfig.Smoothness
    )
end

function CameraController.Initialize()
    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = CameraConfig.FieldOfView

    if player.Character then
        updateCharacterReferences(player.Character)
    end

    player.CharacterAdded:Connect(function(newCharacter)
        updateCharacterReferences(newCharacter)
    end)

    RunService:BindToRenderStep(
        "VAESHIDA_Camera",
        Enum.RenderPriority.Camera.Value,
        updateCamera
    )

    print("[VAESHIDA] CameraController initialisé.")
end

return CameraController
