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

local initialized = false

local function configureCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = MovementConfig.WalkSpeed

    if MovementConfig.EnableJump then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = MovementConfig.JumpPower
    else
        humanoid:SetStateEnabled(
            Enum.HumanoidStateType.Jumping,
            false
        )
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
    if initialized then
        warn(
            "[VAESHIDA][MovementController] "
                .. "Initialize() appelé plusieurs fois. "
                .. "Initialisation ignorée."
        )

        return
    end

    initialized = true

    if player.Character then
        configureCharacter(player.Character)
    end

    player.CharacterAdded:Connect(function(character)
        configureCharacter(character)
    end)

    print("[VAESHIDA] MovementController initialisé.")
end

return MovementController
