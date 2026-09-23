local QuestConfig = {
    DefaultQuestId = "MAIN_001",

    Quests = {
        MAIN_001 = {
            Id = "MAIN_001",
            Name = "Un nouveau départ",

            Description = "Découvre la zone de départ et commence ton aventure dans VAESHIDA.",

            Type = "Main",

            LevelRequired = 1,

            Rewards = {
                XP = 100
            },

            Objectives = {
                {
                    Id = "MAIN_001_OBJECTIVE_01",
                    Type = "ReachLocation",
                    Description = "Atteindre la zone de départ",
                    Required = 1
                },

                {
                    Id = "MAIN_001_OBJECTIVE_02",
                    Type = "TalkToNPC",
                    Target = "Guide",
                    Description = "Parler au Guide",
                    Required = 1
                },

                {
                    Id = "MAIN_001_OBJECTIVE_03",
                    Type = "CollectItem",
                    Target = "RuptureFragment",
                    Description = "Trouver un fragment de la Rupture",
                    Required = 1
                },

                {
                    Id = "MAIN_001_OBJECTIVE_04",
                    Type = "DefeatEnemy",
                    Target = "RuptureCreature",
                    Description = "Vaincre une créature de la Rupture",
                    Required = 1
                }
            }
        }
    }
}

return QuestConfig
