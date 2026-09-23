local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local EnemyConfig = require(
    VAESHIDA
        :WaitForChild("Config")
        :WaitForChild("EnemyConfig")
)

local QuestService = require(
    script.Parent:WaitForChild("QuestService")
)

local EnemyService = {}

local ENEMY_FOLDER_NAME = "VAESHIDA_Enemies"

local enemies = {}

local function createPart(
    parent,
    name,
    size,
    position,
    color
)
    local part = Instance.new("Part")

    part.Name = name
    part.Size = size
    part.Position = position

    part.Anchored = true
    part.CanCollide = true

    part.Color = color

    part.Parent = parent

    return part
end

local function createHealthBar(head, maxHealth)
    local billboard = Instance.new("BillboardGui")

    billboard.Name = "HealthBar"
    billboard.Size = UDim2.fromOffset(160, 32)

    billboard.StudsOffset = Vector3.new(0, 3.2, 0)

    billboard.AlwaysOnTop = true

    billboard.Parent = head

    local background = Instance.new("Frame")

    background.Name = "Background"

    background.Size = UDim2.new(1, 0, 0, 12)

    background.Position = UDim2.fromOffset(0, 16)

    background.BackgroundColor3 =
        Color3.fromRGB(35, 35, 35)

    background.BorderSizePixel = 0

    background.Parent = billboard

    local backgroundCorner = Instance.new("UICorner")

    backgroundCorner.CornerRadius =
        UDim.new(0, 5)

    backgroundCorner.Parent = background

    local fill = Instance.new("Frame")

    fill.Name = "Fill"

    fill.Size = UDim2.fromScale(1, 1)

    fill.BackgroundColor3 =
        Color3.fromRGB(190, 60, 70)

    fill.BorderSizePixel = 0

    fill.Parent = background

    local fillCorner = Instance.new("UICorner")

    fillCorner.CornerRadius =
        UDim.new(0, 5)

    fillCorner.Parent = fill

    local label = Instance.new("TextLabel")

    label.Name = "Label"

    label.Size = UDim2.new(1, 0, 0, 16)

    label.Position = UDim2.fromOffset(0, 0)

    label.BackgroundTransparency = 1

    label.Text = "100 / " .. maxHealth

    label.TextSize = 12

    label.Font = Enum.Font.GothamBold

    label.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    label.Parent = billboard

    return billboard, fill, label
end

local function updateHealthBar(
    enemyData
)
    if not enemyData.HealthBar then
        return
    end

    local healthRatio =
        math.clamp(
            enemyData.Health / enemyData.MaxHealth,
            0,
            1
        )

    enemyData.HealthFill.Size =
        UDim2.new(
            healthRatio,
            0,
            1,
            0
        )

    enemyData.HealthLabel.Text =
        math.floor(enemyData.Health)
        .. " / "
        .. enemyData.MaxHealth
end

local function findNearestPlayer(position)
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for _, player in Players:GetPlayers() do
        local character = player.Character

        if character then
            local rootPart =
                character:FindFirstChild(
                    "HumanoidRootPart"
                )

            local humanoid =
                character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if rootPart
                and humanoid
                and humanoid.Health > 0
            then
                local distance =
                    (
                        rootPart.Position
                        - position
                    ).Magnitude

                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end

    return nearestPlayer, nearestDistance
end

local function destroyEnemy(enemyData)
    if not enemyData.Model then
        return
    end

    enemies[enemyData.Model] = nil

    enemyData.Model:Destroy()
end

local function defeatEnemy(
    enemyData,
    killerPlayer
)
    if enemyData.Defeated then
        return
    end

    enemyData.Defeated = true
    enemyData.Health = 0

    updateHealthBar(enemyData)

    print(
        "[VAESHIDA][EnemyService] "
            .. enemyData.Name
            .. " vaincue."
    )

    if killerPlayer then
        print(
            "[VAESHIDA][EnemyService] "
                .. killerPlayer.Name
                .. " a vaincu "
                .. enemyData.Name
        )

        QuestService.ProgressObjective(
            killerPlayer,
            "DefeatEnemy",
            enemyData.Id,
            1
        )
    end

    task.delay(0.5, function()
        if enemyData.Model then
            destroyEnemy(enemyData)
        end
    end)
end

local function createRuptureCreature()
    local config =
        EnemyConfig.RuptureCreature

    local enemyFolder =
        Workspace:FindFirstChild(
            ENEMY_FOLDER_NAME
        )

    if not enemyFolder then
        enemyFolder = Instance.new("Folder")

        enemyFolder.Name =
            ENEMY_FOLDER_NAME

        enemyFolder.Parent = Workspace
    end

    local existing =
        enemyFolder:FindFirstChild(
            config.Id
        )

    if existing then
        existing:Destroy()
    end

    local model = Instance.new("Model")

    model.Name = config.Id

    model:SetAttribute(
        "EnemyId",
        config.Id
    )

    model:SetAttribute(
        "DisplayName",
        config.Name
    )

    model.Parent = enemyFolder

    local torso = createPart(
        model,
        "Torso",
        Vector3.new(3, 4, 2),
        config.SpawnPosition,
        Color3.fromRGB(95, 45, 120)
    )

    local head = createPart(
        model,
        "Head",
        Vector3.new(2.5, 2.5, 2.5),
        config.SpawnPosition
            + Vector3.new(0, 3.2, 0),
        Color3.fromRGB(130, 55, 155)
    )

    createPart(
        model,
        "LeftArm",
        Vector3.new(0.9, 3.5, 0.9),
        config.SpawnPosition
            + Vector3.new(-1.9, 0, 0),
        Color3.fromRGB(80, 35, 105)
    )

    createPart(
        model,
        "RightArm",
        Vector3.new(0.9, 3.5, 0.9),
        config.SpawnPosition
            + Vector3.new(1.9, 0, 0),
        Color3.fromRGB(80, 35, 105)
    )

    createPart(
        model,
        "LeftLeg",
        Vector3.new(1, 2.5, 1),
        config.SpawnPosition
            + Vector3.new(-0.7, -3.2, 0),
        Color3.fromRGB(55, 25, 75)
    )

    createPart(
        model,
        "RightLeg",
        Vector3.new(1, 2.5, 1),
        config.SpawnPosition
            + Vector3.new(0.7, -3.2, 0),
        Color3.fromRGB(55, 25, 75)
    )

    model.PrimaryPart = torso

    local healthBar, healthFill, healthLabel =
        createHealthBar(
            head,
            config.MaxHealth
        )

    local enemyData = {
        Id = config.Id,
        Name = config.Name,

        Model = model,

        Health = config.MaxHealth,
        MaxHealth = config.MaxHealth,

        WalkSpeed = config.WalkSpeed,
        DetectionRange = config.DetectionRange,
        AttackRange = config.AttackRange,

        Defeated = false,

        HealthBar = healthBar,
        HealthFill = healthFill,
        HealthLabel = healthLabel
    }

    enemies[model] = enemyData

    print(
        "[VAESHIDA][EnemyService] "
            .. config.Name
            .. " créé."
    )

    print(
        "[VAESHIDA][EnemyService] PV : "
            .. enemyData.Health
            .. "/"
            .. enemyData.MaxHealth
    )

    print(
        "[VAESHIDA][EnemyService] "
            .. "Zone de détection : "
            .. enemyData.DetectionRange
            .. " studs."
    )

    return enemyData
end

function EnemyService.DamageEnemy(
    enemy,
    amount,
    attackingPlayer
)
    local enemyData = enemies[enemy]

    if not enemyData then
        return false
    end

    if enemyData.Defeated then
        return false
    end

    if type(amount) ~= "number"
        or amount <= 0
    then
        return false
    end

    enemyData.Health =
        math.max(
            enemyData.Health - amount,
            0
        )

    updateHealthBar(enemyData)

    print(
        "[VAESHIDA][EnemyService] "
            .. enemyData.Name
            .. " reçoit "
            .. amount
            .. " dégâts. PV restants : "
            .. enemyData.Health
    )

    if enemyData.Health <= 0 then
        defeatEnemy(
            enemyData,
            attackingPlayer
        )
    end

    return true
end

function EnemyService.GetEnemyData(enemy)
    return enemies[enemy]
end

function EnemyService.GetEnemies()
    return enemies
end

function EnemyService.Initialize()
    createRuptureCreature()

    task.spawn(function()
        while true do
            task.wait(0.5)

            for enemy, enemyData in pairs(enemies) do
                if enemy
                    and enemy.Parent
                    and not enemyData.Defeated
                then
                    local root =
                        enemy.PrimaryPart

                    if root then
                        local nearestPlayer,
                            distance =
                            findNearestPlayer(
                                root.Position
                            )

                        if nearestPlayer
                            and distance
                                <= enemyData.DetectionRange
                        then
                            enemy:SetAttribute(
                                "TargetPlayer",
                                nearestPlayer.UserId
                            )

                            if distance
                                <= enemyData.AttackRange
                            then
                                enemy:SetAttribute(
                                    "CombatState",
                                    "AttackRange"
                                )
                            else
                                enemy:SetAttribute(
                                    "CombatState",
                                    "Chasing"
                                )
                            end
                        else
                            enemy:SetAttribute(
                                "TargetPlayer",
                                0
                            )

                            enemy:SetAttribute(
                                "CombatState",
                                "Idle"
                            )
                        end
                    end
                end
            end
        end
    end)

    print(
        "[VAESHIDA][EnemyService] "
            .. "Système d'ennemis initialisé."
    )
end

return EnemyService
