local NPCConfig = {
    Guide = {
        Id = "Guide",

        Name = "Le Guide",

        DisplayName = "Le Guide",

        Position = Vector3.new(0, 3, -15),

        Dialogue = {
            {
                Speaker = "Guide",

                Text = "Enfin... quelqu'un est arrivé."
            },

            {
                Speaker = "Guide",

                Text = "Depuis la Rupture, cette région n'est plus la même."
            },

            {
                Speaker = "Guide",

                Text = "Si tu veux comprendre ce qui s'est passé, tu devras commencer par explorer les environs."
            },

            {
                Speaker = "Guide",

                Text = "Trouve un fragment de la Rupture. Il pourrait nous révéler ce que nous cherchons."
            }
        }
    }
}

return NPCConfig
