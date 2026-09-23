local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VAESHIDA = ReplicatedStorage:WaitForChild("VAESHIDA")

local QuestController = {}

local questEvent

local function printQuestObjectives(quest)
    if not quest then
        return
    end

    print("================================")
    print("[VAESHIDA] QUÊTE ACTIVE")
    print("ID : " .. quest.QuestId)
    print("État : " .. quest.Status)
    print("--------------------------------")

    for _, objective in ipairs(quest.Objectives) do
        local status = "[ ]"

        if objective.Completed then
            status = "[✓]"
        end

        print(
            status
                .. " "
                .. objective.Description
                .. " ("
                .. objective.Current
                .. "/"
                .. objective.Required
                .. ")"
        )
    end

    print("================================")
end

function QuestController.Initialize()
    local remotes = VAESHIDA:WaitForChild("Remotes")

    questEvent = remotes:WaitForChild("QuestEvent")

    questEvent.OnClientEvent:Connect(function(
        eventType,
        quest
    )
        print(
            "[VAESHIDA][QuestController] Événement reçu : "
                .. tostring(eventType)
        )

        if eventType == "QuestStarted" then
            print("[VAESHIDA] Nouvelle aventure commencée !")
            printQuestObjectives(quest)

        elseif eventType == "QuestProgress" then
            print("[VAESHIDA] Progression de quête mise à jour.")
            printQuestObjectives(quest)

        elseif eventType == "QuestCompleted" then
            print("[VAESHIDA] ★ QUÊTE TERMINÉE ★")
            printQuestObjectives(quest)
        end
    end)

    print("[VAESHIDA] QuestController initialisé.")
end

return QuestController
