export type ObjectiveDefinition = {
    Id: string,
    Type: string,
    Target: string?,
    Description: string,
    Required: number
}

export type QuestDefinition = {
    Id: string,
    Name: string,
    Description: string,
    Type: string,
    LevelRequired: number,
    Rewards: {
        XP: number
    },
    Objectives: { ObjectiveDefinition }
}

export type ObjectiveProgress = {
    Id: string,
    Type: string,
    Target: string?,
    Description: string,
    Current: number,
    Required: number,
    Completed: boolean
}

export type QuestProgress = {
    QuestId: string,
    Status: string,
    Objectives: { ObjectiveProgress },
    StartedAt: number,
    CompletedAt: number?
}

export type PlayerQuestData = {
    ActiveQuest: QuestProgress?,
    CompletedQuests: { [string]: boolean }
}

return {}
