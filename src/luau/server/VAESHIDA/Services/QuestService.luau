local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local QuestConfig = require(
    VAESHIDA
        :WaitForChild("Config")
        :WaitForChild("QuestConfig")
)

local PlayerService = require(
    script.Parent:WaitForChild("PlayerService")
)

local QuestService = {}

local playerQuestData = {}

local REMOTES_FOLDER_NAME = "Remotes"
local QUEST_EVENT_NAME = "QuestEvent"

local questEvent

local function getOrCreateRemote()
    local remotesFolder = VAESHIDA:FindFirstChild(REMOTES_FOLDER_NAME)

    if not remotesFolder then
        remotesFolder = Instance.new("Folder")
        remotesFolder.Name = REMOTES_FOLDER_NAME
        remotesFolder.Parent = VAESHIDA
    end

    local existingEvent = remotesFolder:FindFirstChild(QUEST_EVENT_NAME)

    if existingEvent and existingEvent:IsA("RemoteEvent") then
        return existingEvent
    end

    if existingEvent then
        existingEvent:Destroy()
    end

    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = QUEST_EVENT_NAME
    remoteEvent.Parent = remotesFolder

    return remoteEvent
end

local function createObjectiveProgress(objectiveDefinition)
    return {
        Id = objectiveDefinition.Id,
        Type = objectiveDefinition.Type,
        Target = objectiveDefinition.Target,
        Description = objectiveDefinition.Description,

        Current = 0,
        Required = objectiveDefinition.Required,

        Completed = false
    }
end

local function createQuestProgress(questDefinition)
    local objectives = {}

    for _, objectiveDefinition in ipairs(questDefinition.Objectives) do
        table.insert(
            objectives,
            createObjectiveProgress(objectiveDefinition)
        )
    end

    return {
        QuestId = questDefinition.Id,
        Status = "Active",
        Objectives = objectives,
        StartedAt = os.time(),
        CompletedAt = nil
    }
end

local function sendQuestUpdate(player, eventType)
    if not questEvent then
        return
    end

    local data = playerQuestData[player]

    if not data then
        return
    end

    questEvent:FireClient(
        player,
        eventType,
        data.ActiveQuest
    )
end

local function getQuestDefinition(questId)
    return QuestConfig.Quests[questId]
end

local function allObjectivesCompleted(questProgress)
    for _, objective in ipairs(questProgress.Objectives) do
        if not objective.Completed then
            return false
        end
    end

    return true
end

local function giveRewards(player, questDefinition)
    local xpReward = questDefinition.Rewards.XP or 0

    if xpReward <= 0 then
        return
    end

    local data = PlayerService.GetData(player)

    if not data then
        warn(
            "[VAESHIDA][QuestService] Impossible de donner "
                .. "la récompense : données joueur absentes."
        )

        return
    end

    data.XP += xpReward

    print(
        "[VAESHIDA][QuestService] Récompense donnée à "
            .. player.Name
            .. " : +"
            .. xpReward
            .. " XP"
    )
end

function QuestService.InitializePlayer(player)
    if playerQuestData[player] then
        return
    end

    playerQuestData[player] = {
        ActiveQuest = nil,
        CompletedQuests = {}
    }

    print(
        "[VAESHIDA][QuestService] Données de quêtes initialisées pour "
            .. player.Name
    )
end

function QuestService.StartQuest(player, questId)
    local data = playerQuestData[player]

    if not data then
        QuestService.InitializePlayer(player)
        data = playerQuestData[player]
    end

    local questDefinition = getQuestDefinition(questId)

    if not questDefinition then
        warn(
            "[VAESHIDA][QuestService] Quête inconnue : "
                .. tostring(questId)
        )

        return false
    end

    if data.CompletedQuests[questId] then
        return false
    end

    if data.ActiveQuest then
        warn(
            "[VAESHIDA][QuestService] "
                .. player.Name
                .. " possède déjà une quête active."
        )

        return false
    end

    local playerLevel = PlayerService.GetLevel(player)

    if playerLevel and playerLevel < questDefinition.LevelRequired then
        warn(
            "[VAESHIDA][QuestService] Niveau insuffisant pour "
                .. questDefinition.Name
        )

        return false
    end

    data.ActiveQuest = createQuestProgress(questDefinition)

    print(
        "[VAESHIDA][QuestService] Nouvelle quête pour "
            .. player.Name
            .. " : "
            .. questDefinition.Name
    )

    sendQuestUpdate(player, "QuestStarted")

    return true
end

function QuestService.ProgressObjective(
    player,
    objectiveType,
    target,
    amount
)
    local data = playerQuestData[player]

    if not data or not data.ActiveQuest then
        return false
    end

    local questProgress = data.ActiveQuest

    if questProgress.Status ~= "Active" then
        return false
    end

    local progressAmount = amount or 1

    if progressAmount <= 0 then
        return false
    end

    local objectiveChanged = false

    for _, objective in ipairs(questProgress.Objectives) do
        if not objective.Completed
            and objective.Type == objectiveType
            and (
                objective.Target == nil
                or objective.Target == target
            )
        then
            objective.Current = math.min(
                objective.Current + progressAmount,
                objective.Required
            )

            objectiveChanged = true

            if objective.Current >= objective.Required then
                objective.Completed = true

                print(
                    "[VAESHIDA][QuestService] Objectif terminé : "
                        .. objective.Description
                        .. " | Joueur : "
                        .. player.Name
                )
            end

            break
        end
    end

    if not objectiveChanged then
        return false
    end

    sendQuestUpdate(player, "QuestProgress")

    if allObjectivesCompleted(questProgress) then
        QuestService.CompleteQuest(player)
    end

    return true
end

function QuestService.CompleteQuest(player)
    local data = playerQuestData[player]

    if not data or not data.ActiveQuest then
        return false
    end

    local questProgress = data.ActiveQuest

    if not allObjectivesCompleted(questProgress) then
        return false
    end

    local questDefinition = getQuestDefinition(
        questProgress.QuestId
    )

    if not questDefinition then
        return false
    end

    questProgress.Status = "Completed"
    questProgress.CompletedAt = os.time()

    data.CompletedQuests[questProgress.QuestId] = true

    giveRewards(player, questDefinition)

    print(
        "[VAESHIDA][QuestService] QUÊTE TERMINÉE : "
            .. questDefinition.Name
            .. " | Joueur : "
            .. player.Name
    )

    sendQuestUpdate(player, "QuestCompleted")

    data.ActiveQuest = nil

    return true
end

function QuestService.GetActiveQuest(player)
    local data = playerQuestData[player]

    if not data then
        return nil
    end

    return data.ActiveQuest
end

function QuestService.HasCompletedQuest(player, questId)
    local data = playerQuestData[player]

    if not data then
        return false
    end

    return data.CompletedQuests[questId] == true
end

function QuestService.RemovePlayer(player)
    playerQuestData[player] = nil
end

function QuestService.Initialize()
    questEvent = getOrCreateRemote()

    Players.PlayerAdded:Connect(function(player)
        QuestService.InitializePlayer(player)

        task.defer(function()
            QuestService.StartQuest(
                player,
                QuestConfig.DefaultQuestId
            )
        end)
    end)

    Players.PlayerRemoving:Connect(function(player)
        QuestService.RemovePlayer(player)
    end)

    for _, player in Players:GetPlayers() do
        QuestService.InitializePlayer(player)

        task.defer(function()
            QuestService.StartQuest(
                player,
                QuestConfig.DefaultQuestId
            )
        end)
    end

    print("[VAESHIDA][QuestService] Système de quêtes initialisé.")
end

return QuestService
