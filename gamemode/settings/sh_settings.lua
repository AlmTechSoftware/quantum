--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

Quantum.Models = {
    NPC = {},
    Player = {
        Citizen = {
            Male = {
                "models/player/Group01/male_01.mdl",
                "models/player/Group01/male_02.mdl",
                "models/player/Group01/male_03.mdl",
                "models/player/Group01/male_04.mdl",
                "models/player/Group01/male_05.mdl",
                "models/player/Group01/male_06.mdl",
                "models/player/Group01/male_07.mdl",
                "models/player/Group01/male_08.mdl",
                "models/player/Group01/male_09.mdl"
            },

            Female = {
                "models/player/group01/female_01.mdl",
                "models/player/group01/female_02.mdl",
                "models/player/group01/female_03.mdl",
                "models/player/group01/female_04.mdl",
                "models/player/group01/female_05.mdl",
                "models/player/group01/female_06.mdl"
            }
        }
    }
}

Quantum.Classes = {
    Commoner = { -- id
        Name = "Commoner",
        Desc = "Someone who lives in a city.",
        Models = Quantum.Models.Player.Citizen
    },
    Nobleman = {
        Name = "Nobleman",
        Desc = "A nobleman is someone who originates from a family of wealth and power and tend to look down upon those who are not 'fit' in their eyes. They often expects everyone to do their bidding without question.",
        Models = Quantum.Models.Player.Citizen -- change this to better models
    },
    Worker = {
        Name = "Worker",
        Desc = "A worker is someone who is in the working-class and come from a poor family but has learned the secret of life; how to work hard and earn what you want.",
        Models = Quantum.Models.Player.Citizen -- change this to better models
    }
}