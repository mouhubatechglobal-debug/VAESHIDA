local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local TestWorldConfig = require(
    ReplicatedStorage
        :WaitForChild("VAESHIDA")
        :WaitForChild("Config")
        :WaitForChild("TestWorldConfig")
)

local TestWorldService = {}

local WORLD_NAME = "VAESHIDA_TestWorld"

local function createPart(
    parent,
    name,
    size,
    position
)
    local part = Instance.new("Part")

    part.Name = name
    part.Size = size
    part.Position = position

    part.Anchored = true
    part.CanCollide = true

    part.Parent = parent

    return part
end

local function createSpawn(parent)
    local spawn = Instance.new("SpawnLocation")

    spawn.Name = "PlayerSpawn"
    spawn.Size = Vector3.new(8, 1, 8)
    spawn.Position = TestWorldConfig.SpawnPosition

    spawn.Anchored = true
    spawn.CanCollide = true

    spawn.Neutral = true
    spawn.Enabled = true

    spawn.Parent = parent
end

function TestWorldService.Create()
    local existingWorld = Workspace:FindFirstChild(WORLD_NAME)

    if existingWorld then
        existingWorld:Destroy()
    end

    local world = Instance.new("Folder")
    world.Name = WORLD_NAME
    world.Parent = Workspace

    createPart(
        world,
        "Ground",
        TestWorldConfig.GroundSize,
        TestWorldConfig.GroundPosition
    )

    createSpawn(world)

    for index, position in ipairs(
        TestWorldConfig.PlatformPositions
    ) do
        createPart(
            world,
            "Platform_" .. index,
            TestWorldConfig.PlatformSize,
            position
        )
    end

    print("[VAESHIDA] Zone de test créée.")
    print(
        "[VAESHIDA] Plateformes : "
            .. #TestWorldConfig.PlatformPositions
    )
end

return TestWorldService
