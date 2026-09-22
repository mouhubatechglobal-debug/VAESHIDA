local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovementConfig = require(
    ReplicatedStorage
        :WaitForChild("VAESHIDA")
        :WaitForChild("Config")
        :WaitForChild("MovementConfig")
)

local MovementController = {}

local player = Players.LocalPlayer

local function configureCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = MovementConfig.WalkSpeed

    if MovementConfig.EnableJump then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = MovementConfig.JumpPower
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    end

    print(
        "[VAESHIDA] Mouvement configuré : "
            .. "WalkSpeed="
            .. humanoid.WalkSpeed
            .. " | JumpPower="
            .. humanoid.JumpPower
    )
end

function MovementController.Initialize()
    if player.Character then
        configureCharacter(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        configureCharacter(character)
    end)

    print("[VAESHIDA] MovementController initialisé.")
end

MovementController.Initialize()
