--    __           _        _______        _      __   
--   / /     /\   | |      |__   __|      | |     \ \  
--  / /     /  \  | |_ __ ___ | | ___  ___| |__    \ \ 
-- < <     / /\ \ | | '_ ` _ \| |/ _ \/ __| '_ \    > >
--  \ \   / ____ \| | | | | | | |  __/ (__| | | |  / / 
--   \_\ /_/    \_\_|_| |_| |_|_|\___|\___|_| |_| /_/  

            Quantum.Server.Settings = {}

Quantum.Server.Settings.VoiceChatRange = 400

Quantum.Server.Settings.MaxHealth = 100

Quantum.Server.Settings.StarterMoney = 0

Quantum.Server.Settings.Inventory = {
    Height = 5,
    Width = 5
}

--- Features to be added ---
Quantum.Server.Settings.MaxJobLevel = 250
Quantum.Server.Settings.MaxJobSlots = 2
Quantum.Server.Settings.MaxSkillLevel = 100

Quantum.Server.Settings.SpawnLocations = {

    ["rp_truenorth_v1a_livin"] = {
        ["Hospital"] = { pos = Vector( 13583, 13189, 128 ), ang = Angle( 1, 115, 0 ) },
        ["Lake"] = { pos = Vector( 10812, -8319, 5388 ), ang = Angle( 5, -40, 0 ) }
    }

}

Quantum.Server.Settings.Licenses = {
    Driving = { title = "Driving License", desc = "This permits you to operate and pilot any motorized vehicle in a public area.", cost = 1000 }
}

Quantum.Server.Settings.Titles = {
    dev = "Developer,"
}

Quantum.Server.Settings.DamageScale = { -- The scale of the damage for each hitgroup 
    [HITGROUP_HEAD] = 10,
    [HITGROUP_CHEST] = 4,
    [HITGROUP_STOMACH] = 2,
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,
    [HITGROUP_LEFTLEG] = 1,
    [HITGROUP_RIGHTLEG] = 1
}

Quantum.Server.Settings.PainSounds = {}
Quantum.Server.Settings.PainSounds.Male = {
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/pain08.wav",
    "vo/npc/male01/pain09.wav"
}

Quantum.Server.Settings.DamageHurtSoundRepeatChance = 90

Quantum.Server.Settings.IdlePainSounds = {}
Quantum.Server.Settings.IdlePainSounds.Male = {
    "vo/npc/male01/moan01.wav",
    "vo/npc/male01/moan02.wav",
    "vo/npc/male01/moan03.wav",
    "vo/npc/male01/moan04.wav",
    "vo/npc/male01/moan05.wav"
}

