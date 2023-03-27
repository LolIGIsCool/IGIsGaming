IGCSKILLS = {}
IGPSKILLS = {}
IGUSKILLS = {}

function CreateSkill(name, skilltbl)
    skilltbl.Name = name
    skilltbl.Desc = skilltbl.Desc or "no description"
    skilltbl.Cost = skilltbl.Cost or 999999
    skilltbl.Type = skilltbl.Type or "C"

    if skilltbl.Type == "C" then
        local IDcount = table.Count(IGCSKILLS) + 1
        skilltbl.SkillNum = IDcount
        IGCSKILLS[IDcount] = skilltbl
    elseif skilltbl.Type == "P" then
        local IDcount = table.Count(IGPSKILLS) + 1
        skilltbl.SkillNum = IDcount
        IGPSKILLS[IDcount] = skilltbl
    else
        local IDcount = table.Count(IGUSKILLS) + 1
        skilltbl.SkillNum = IDcount
        IGUSKILLS[IDcount] = skilltbl
    end
end

-- 1 prestige (prestige and actual quest points) = 123 points
-- Combat 
CreateSkill("Health Boost 1", {
    Desc = "Your classes health is increased by 10%",
    Cost = 4,
    Type = "C"
})

CreateSkill("Healing 1", {
    Desc = "All forms of healing are increased by 10%",
    Cost = 5,
    Type = "C"
})

CreateSkill("Speed 1", {
    Desc = "Receive a 5% sprint speed buff",
    Cost = 5,
    Type = "C"
})

CreateSkill("Health Boost 2", {
    Desc = "Your classes health is increased by an additional 10%",
    Cost = 6,
    Type = "C"
})

CreateSkill("Healing 2", {
    Desc = "All forms of healing are increased by an additional 10%",
    Cost = 7,
    Type = "C"
})

CreateSkill("Speed 2", {
    Desc = "Receive an additional 5% sprint speed bonus",
    Cost = 8,
    Type = "C"
})

CreateSkill("Reserves", {
    Desc = "Spawn with bonus reserve ammo for your equipment",
    Cost = 15,
    Type = "C"
})

-- Profit
CreateSkill("XP Boost 1", {
    Desc = "All XP received is increased by 5%",
    Cost = 4,
    Type = "P"
})

CreateSkill("Mission Rewards", {
    Desc = "Credit rewards for completing missions are increased by 30%",
    Cost = 5,
    Type = "P"
})

CreateSkill("Event Rewards 1", {
    Desc = "Rewards for placing in an event are increased by 20%",
    Cost = 5,
    Type = "P"
})

CreateSkill("Pointshop Points", {
    Desc = "Your will receive 15% extra points for playtime rewards",
    Cost = 6,
    Type = "P"
})

CreateSkill("XP Boost 2", {
    Desc = "All XP received is increased by an additional 5%",
    Cost = 7,
    Type = "P"
})

CreateSkill("Event Rewards 2", {
    Desc = "Rewards for placing in an event are increased by an additional 30%",
    Cost = 8,
    Type = "P"
})

CreateSkill("Lottery Payout", {
    Desc = "Receive 25-75% extra points from the Imperial lottery.",
    Cost = 15,
    Type = "P"
})

-- Utility
CreateSkill("Swift Recovery", {
    Desc = "After getting healed by a friendly, receive 10-50 health over 5 seconds",
    Cost = 8,
    Type = "U"
})

CreateSkill("Pointshop Boosts", {
    Desc = "Pointshop Boosts give an additional 25% health",
    Cost = 9,
    Type = "U"
})

CreateSkill("Keycards", {
    Desc = "Keycard Scanners will recognise your card almost instantly",
    Cost = 10,
    Type = "U"
})

CreateSkill("Extra Gun", {
    Desc = "Spawn with a random high tier gun everytime you spawn.",
    Cost = 12,
    Type = "U"
})

CreateSkill("Steel Legs", {
    Desc = "You no longer break your legs from falling.",
    Cost = 13,
    Type = "U"
})

CreateSkill("Climb Swep", {
    Desc = "Receive an extra jump on climb swep, if you need it.",
    Cost = 15,
    Type = "U"
})

CreateSkill("Health Regeneration", {
    Desc = "Regenerate health slowly overtime.",
    Cost = 20,
    Type = "U"
})