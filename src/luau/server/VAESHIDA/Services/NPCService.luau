local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local NPCConfig = require(
    VAESHIDA
        :WaitForChild("Config")
        :WaitForChild("NPCConfig")
)

local QuestService = require(
    script.Parent:WaitForChild("QuestService")
)

local NPCService = {}

local NPC_FOLDER_NAME = "VAESHIDA_NPCs"

local DIALOGUE_EVENT_NAME = "DialogueEvent"

local dialogueEvent

local function getOrCreateRemote()
    local remotesFolder = VAESHIDA:FindFirstChild("Remotes")

    if not remotesFolder then
        remotesFolder = Instance.new("Folder")
        remotesFolder.Name = "Remotes"
        remotesFolder.Parent = VAESHIDA
    end

    local existingEvent = remotesFolder:FindFirstChild(
        DIALOGUE_EVENT_NAME
    )

    if existingEvent and existingEvent:IsA("RemoteEvent") then
        return existingEvent
    end

    if existingEvent then
        existingEvent:Destroy()
    end

    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = DIALOGUE_EVENT_NAME
    remoteEvent.Parent = remotesFolder

    return remoteEvent
end

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

local function createNameTag(head, displayName)
    local billboard = Instance.new("BillboardGui")

    billboard.Name = "NameTag"
    billboard.Size = UDim2.fromOffset(220, 50)

    billboard.StudsOffset = Vector3.new(0, 2.5, 0)

    billboard.AlwaysOnTop = true

    billboard.Parent = head

    local label = Instance.new("TextLabel")

    label.Name = "Name"

    label.Size = UDim2.fromScale(1, 1)

    label.BackgroundTransparency = 1

    label.Text = displayName

    label.TextScaled = true

    label.Font = Enum.Font.GothamBold

    label.TextColor3 = Color3.fromRGB(255, 255, 255)

    label.TextStrokeTransparency = 0.25

    label.Parent = billboard
end

local function createGuide()
    local config = NPCConfig.Guide

    local npcFolder = Workspace:FindFirstChild(
        NPC_FOLDER_NAME
    )

    if npcFolder then
        npcFolder:Destroy()
    end

    npcFolder = Instance.new("Folder")

    npcFolder.Name = NPC_FOLDER_NAME

    npcFolder.Parent = Workspace

    local guide = Instance.new("Model")

    guide.Name = config.Id

    guide:SetAttribute("NPCId", config.Id)

    guide.Parent = npcFolder

    local torsoPosition = config.Position

    local torso = createPart(
        guide,
        "Torso",
        Vector3.new(2, 3, 1),
        torsoPosition,
        Color3.fromRGB(70, 80, 100)
    )

    local headPosition =
        torsoPosition
        + Vector3.new(0, 2.2, 0)

    local head = createPart(
        guide,
        "Head",
        Vector3.new(2, 2, 2),
        headPosition,
        Color3.fromRGB(220, 180, 140)
    )

    createPart(
        guide,
        "LeftArm",
        Vector3.new(0.7, 2.8, 0.7),
        torsoPosition + Vector3.new(-1.35, 0, 0),
        Color3.fromRGB(70, 80, 100)
    )

    createPart(
        guide,
        "RightArm",
        Vector3.new(0.7, 2.8, 0.7),
        torsoPosition + Vector3.new(1.35, 0, 0),
        Color3.fromRGB(70, 80, 100)
    )

    createPart(
        guide,
        "LeftLeg",
        Vector3.new(0.8, 2, 0.8),
        torsoPosition + Vector3.new(-0.55, -2.5, 0),
        Color3.fromRGB(35, 40, 55)
    )

    createPart(
        guide,
        "RightLeg",
        Vector3.new(0.8, 2, 0.8),
        torsoPosition + Vector3.new(0.55, -2.5, 0),
        Color3.fromRGB(35, 40, 55)
    )

    guide.PrimaryPart = torso

    createNameTag(
        head,
        config.DisplayName
    )

    local prompt = Instance.new("ProximityPrompt")

    prompt.Name = "TalkPrompt"

    prompt.ActionText = "Parler"

    prompt.ObjectText = config.DisplayName

    prompt.KeyboardKeyCode = Enum.KeyCode.E

    prompt.HoldDuration = 0

    prompt.MaxActivationDistance = 10

    prompt.RequiresLineOfSight = false

    prompt.Parent = head

    prompt.Triggered:Connect(function(player)
        print(
            "[VAESHIDA][NPCService] "
                .. player.Name
                .. " parle au Guide."
        )

        dialogueEvent:FireClient(
            player,
            "OpenDialogue",
            config.Id,
            config.DisplayName,
            config.Dialogue
        )

        QuestService.ProgressObjective(
            player,
            "TalkToNPC",
            config.Id,
            1
        )
    end)

    return guide
end

function NPCService.Create()
    createGuide()

    print(
        "[VAESHIDA][NPCService] Guide créé."
    )
end

function NPCService.Initialize()
    dialogueEvent = getOrCreateRemote()

    NPCService.Create()

    print(
        "[VAESHIDA][NPCService] Système de PNJ initialisé."
    )
end

return NPCService
