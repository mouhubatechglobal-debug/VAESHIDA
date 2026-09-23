local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local DialogueController = {}

local dialogueEvent

local screenGui

local dialogueFrame

local speakerLabel

local dialogueText

local continueButton

local dialogueLines = {}

local currentLine = 0

local function createInterface()
    screenGui = Instance.new("ScreenGui")

    screenGui.Name = "DialogueUI"

    screenGui.ResetOnSpawn = false

    screenGui.IgnoreGuiInset = true

    screenGui.Parent = player:WaitForChild("PlayerGui")

    dialogueFrame = Instance.new("Frame")

    dialogueFrame.Name = "DialogueFrame"

    dialogueFrame.Size = UDim2.new(
        0.75,
        0,
        0,
        180
    )

    dialogueFrame.Position = UDim2.new(
        0.125,
        0,
        1,
        -210
    )

    dialogueFrame.BackgroundColor3 =
        Color3.fromRGB(15, 18, 28)

    dialogueFrame.BackgroundTransparency = 0.05

    dialogueFrame.BorderSizePixel = 0

    dialogueFrame.Visible = false

    dialogueFrame.Parent = screenGui

    local corner = Instance.new("UICorner")

    corner.CornerRadius = UDim.new(0, 12)

    corner.Parent = dialogueFrame

    speakerLabel = Instance.new("TextLabel")

    speakerLabel.Name = "Speaker"

    speakerLabel.Size = UDim2.new(
        1,
        -30,
        0,
        35
    )

    speakerLabel.Position = UDim2.fromOffset(
        15,
        10
    )

    speakerLabel.BackgroundTransparency = 1

    speakerLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    speakerLabel.Text = ""

    speakerLabel.TextSize = 22

    speakerLabel.Font = Enum.Font.GothamBold

    speakerLabel.TextColor3 =
        Color3.fromRGB(190, 210, 255)

    speakerLabel.Parent = dialogueFrame

    dialogueText = Instance.new("TextLabel")

    dialogueText.Name = "Text"

    dialogueText.Size = UDim2.new(
        1,
        -30,
        0,
        80
    )

    dialogueText.Position = UDim2.fromOffset(
        15,
        48
    )

    dialogueText.BackgroundTransparency = 1

    dialogueText.TextXAlignment =
        Enum.TextXAlignment.Left

    dialogueText.TextYAlignment =
        Enum.TextYAlignment.Top

    dialogueText.TextWrapped = true

    dialogueText.Text = ""

    dialogueText.TextSize = 18

    dialogueText.Font = Enum.Font.Gotham

    dialogueText.TextColor3 =
        Color3.fromRGB(235, 235, 240)

    dialogueText.Parent = dialogueFrame

    continueButton = Instance.new("TextButton")

    continueButton.Name = "Continue"

    continueButton.Size = UDim2.fromOffset(
        130,
        38
    )

    continueButton.Position = UDim2.new(
        1,
        -145,
        1,
        -48
    )

    continueButton.BackgroundColor3 =
        Color3.fromRGB(65, 90, 150)

    continueButton.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    continueButton.Text = "Continuer"

    continueButton.TextSize = 16

    continueButton.Font = Enum.Font.GothamBold

    continueButton.Parent = dialogueFrame

    local buttonCorner = Instance.new("UICorner")

    buttonCorner.CornerRadius = UDim.new(0, 8)

    buttonCorner.Parent = continueButton

    continueButton.Activated:Connect(function()
        DialogueController.NextLine()
    end)
end

local function showCurrentLine()
    local line = dialogueLines[currentLine]

    if not line then
        DialogueController.Close()

        return
    end

    speakerLabel.Text = line.Speaker or "???"

    dialogueText.Text = line.Text or ""

    if currentLine >= #dialogueLines then
        continueButton.Text = "Fermer"
    else
        continueButton.Text = "Continuer"
    end
end

function DialogueController.Open(
    npcId,
    displayName,
    lines
)
    if type(lines) ~= "table" then
        return
    end

    dialogueLines = lines

    currentLine = 1

    speakerLabel.Text = displayName or npcId

    dialogueFrame.Visible = true

    showCurrentLine()
end

function DialogueController.NextLine()
    if not dialogueFrame.Visible then
        return
    end

    if currentLine >= #dialogueLines then
        DialogueController.Close()

        return
    end

    currentLine += 1

    showCurrentLine()
end

function DialogueController.Close()
    dialogueFrame.Visible = false

    dialogueLines = {}

    currentLine = 0
end

function DialogueController.Initialize()
    createInterface()

    local remotes = VAESHIDA:WaitForChild("Remotes")

    dialogueEvent = remotes:WaitForChild(
        "DialogueEvent"
    )

    dialogueEvent.OnClientEvent:Connect(
        function(
            eventType,
            npcId,
            displayName,
            lines
        )
            if eventType == "OpenDialogue" then
                DialogueController.Open(
                    npcId,
                    displayName,
                    lines
                )
            end
        end
    )

    print(
        "[VAESHIDA] DialogueController initialisé."
    )
end

return DialogueController
