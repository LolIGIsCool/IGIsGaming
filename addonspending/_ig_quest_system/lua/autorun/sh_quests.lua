IGQUESTS = {}
IGCATEGORYQUESTS = {}

function CreateQuest(name, questtbl)
    questtbl.Name = name
    questtbl.Category = questtbl.Category or "Extra"
    questtbl.LVL = questtbl.LVL or 1
    questtbl.Amount = questtbl.Amount or 69
    questtbl.Instructions = questtbl.Instructions or "None"
    questtbl.Tips = questtbl.Tips or "None"

    local IDcount = table.Count(IGQUESTS)
    questtbl.ID = IDcount
    IGQUESTS[IDcount] = questtbl
    IGCATEGORYQUESTS[questtbl.Category] = IGCATEGORYQUESTS[questtbl.Category] or {}
    IGCATEGORYQUESTS[questtbl.Category][questtbl.LVL] = questtbl
end

-- PLAY TIME

CreateQuest("Play Time (Part 1)", {
    Category = "Play Time",
    LVL = 1,
    Amount = 1,
    Instructions = "Play the server for 12 hours",
    Tips = "No tip needs to be given"
})

CreateQuest("Play Time (Part 2)", {
    Category = "Play Time",
    LVL = 2,
    Amount = 1,
    Instructions = "Play the server for 24 hours",
    Tips = "No tip needs to be given"
})

CreateQuest("Play Time (Part 3)", {
    Category = "Play Time",
    LVL = 3,
    Amount = 1,
    Instructions = "Play the server for 7 days",
    Tips = "No tip needs to be given"
})

CreateQuest("Play Time (Completed)", {
    Category = "Play Time",
    LVL = 4,
    Amount = 1,
    Instructions = "Play the server for 7 days",
    Tips = "No tip needs to be given"
})

-- LEVELS

CreateQuest("Levels (Part 1)", {
    Category = "Levels",
    LVL = 1,
    Amount = 1,
    Instructions = "Reach LVL 10",
    Tips = "TIP: You can get XP to level up by playing or killing npc's"
})

CreateQuest("Levels (Part 2)", {
    Category = "Levels",
    LVL = 2,
    Amount = 1,
    Instructions = "Reach LVL 25",
    Tips = "TIP: You can get XP to level up by playing or killing npc's"
})

CreateQuest("Levels (Part 3)", {
    Category = "Levels",
    LVL = 3,
    Amount = 1,
    Instructions = "Reach LVL 50",
    Tips = "TIP: You can get XP to level up by playing or killing npc's"
})

CreateQuest("Levels (Completed)", {
    Category = "Levels",
    LVL = 4,
    Amount = 50,
    Instructions = "Reach LVL 50",
    Tips = "TIP: You can get XP to level up by playing or killing npc's"
})


-- EVENT KILLS

CreateQuest("Event Kills (Part 1)", {
    Category = "Event Kills",
    LVL = 1,
    Amount = 3,
    Instructions = "Kill 3 event characters",
    Tips = "TIP: Getting the final blow on an event character progresses this quest"
})

CreateQuest("Event Kills (Part 2)", {
    Category = "Event Kills",
    LVL = 2,
    Amount = 5,
    Instructions = "Kill 5 event characters",
    Tips = "TIP: Getting the final blow on an event character progresses this quest"
})

CreateQuest("Event Kills (Part 3)", {
    Category = "Event Kills",
    LVL = 3,
    Amount = 10,
    Instructions = "Kill 10 event characters",
    Tips = "TIP: Getting the final blow on an event character progresses this quest"
})

CreateQuest("Event Kills (Completed)", {
    Category = "Event Kills",
    LVL = 4,
    Amount = 10,
    Instructions = "Kill 10 event characters",
    Tips = "TIP: Getting the final blow on an event character progresses this quest"
})

-- FIRING RANGE

CreateQuest("Firing Range (Part 1)", {
    Category = "Firing Range",
    LVL = 1,
    Amount = 200,
    Instructions = "Hit the middle target in the firing range 200 times",
    Tips = "TIP: Practice your aim, progress this quest"
})

CreateQuest("Firing Range (Part 2)", {
    Category = "Firing Range",
    LVL = 2,
    Amount = 300,
    Instructions = "Hit the middle target in the firing range 300 times",
    Tips = "TIP: Practice your aim, progress this quest"
})

CreateQuest("Firing Range (Part 3)", {
    Category = "Firing Range",
    LVL = 3,
    Amount = 400,
    Instructions = "Hit the middle target in the firing range 400 times",
    Tips = "TIP: Practice your aim, progress this quest"
})

CreateQuest("Firing Range (Completed)", {
    Category = "Firing Range",
    LVL = 4,
    Amount = 400,
    Instructions = "Hit the middle target in the firing range 400 times",
    Tips = "TIP: Practice your aim, progress this quest"
})

-- CLIMB SWEP

CreateQuest("Climbing (Part 1)", {
    Category = "Climbing",
    LVL = 1,
    Amount = 200,
    Instructions = "Utilize climb swep to gain height, 200 times!",
    Tips = "TIP: See a senior officer for tips on climb swep"
})

CreateQuest("Climbing (Part 2)", {
    Category = "Climbing",
    LVL = 2,
    Amount = 400,
    Instructions = "Utilize climb swep to gain height, 400 times!",
    Tips = "TIP: See a senior officer for tips on climb swep"
})

CreateQuest("Climbing (Part 3)", {
    Category = "Climbing",
    LVL = 3,
    Amount = 750,
    Instructions = "Utilize climb swep to gain height, 750 times!",
    Tips = "TIP: See a senior officer for tips on climb swep"
})

CreateQuest("Climbing (Completed)", {
    Category = "Climbing",
    LVL = 4,
    Amount = 750,
    Instructions = "Utilize climb swep to gain height, 750 times!",
    Tips = "TIP: See a senior officer for tips on climb swep"
})


-- NPC KILLS

CreateQuest("NPC Kills (Part 1)", {
    Category = "NPC Kills",
    LVL = 1,
    Amount = 50,
    Instructions = "Participate in an NPC Event and kill 50 of them!",
    Tips = "TIP: Press LMB to shoot"
})

CreateQuest("NPC Kills (Part 2)", {
    Category = "NPC Kills",
    LVL = 2,
    Amount = 100,
    Instructions = "Participate in an NPC Event and kill 100 of them!",
    Tips = "TIP: Press LMB to shoot"
})

CreateQuest("NPC Kills (Part 3)", {
    Category = "NPC Kills",
    LVL = 3,
    Amount = 150,
    Instructions = "Participate in an NPC Event and kill 150 of them!",
    Tips = "TIP: Press LMB to shoot"
})

CreateQuest("NPC Kills (Completed)", {
    Category = "NPC Kills",
    LVL = 4,
    Amount = 150,
    Instructions = "Participate in an NPC Event and kill 100 of them!",
    Tips = "TIP: Press LMB to shoot"
})


-- MISSIONS

CreateQuest("Missions (Part 1)", {
    Category = "Missions",
    LVL = 1,
    Amount = 25,
    Instructions = "Complete 25 missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Missions (Part 2)", {
    Category = "Missions",
    LVL = 2,
    Amount = 30,
    Instructions = "Complete 30 missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Missions (Part 3)", {
    Category = "Missions",
    LVL = 3,
    Amount = 35,
    Instructions = "Complete 35 missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Missions (Completed)", {
    Category = "Missions",
    LVL = 4,
    Amount = 35,
    Instructions = "Complete 35 missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})


-- CARRY MISSIONS

CreateQuest("Carry Missions (Part 1)", {
    Category = "Carry Missions",
    LVL = 1,
    Amount = 15,
    Instructions = "Complete 15 carry-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Carry Missions (Part 2)", {
    Category = "Carry Missions",
    LVL = 2,
    Amount = 20,
    Instructions = "Complete 20 carry-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Carry Missions (Part 3)", {
    Category = "Carry Missions",
    LVL = 3,
    Amount = 25,
    Instructions = "Complete 25 carry-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Carry Missions (Completed)", {
    Category = "Carry Missions",
    LVL = 4,
    Amount = 25,
    Instructions = "Complete 25 carry-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})


-- COLLECTION MISSIONS

CreateQuest("Collection Missions (Part 1)", {
    Category = "Collection Missions",
    LVL = 1,
    Amount = 15,
    Instructions = "Complete 15 collection-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Collection Missions (Part 2)", {
    Category = "Collection Missions",
    LVL = 2,
    Amount = 20,
    Instructions = "Complete 20 collection-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Collection Missions (Part 3)", {
    Category = "Collection Missions",
    LVL = 3,
    Amount = 25,
    Instructions = "Complete 25 collection-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

CreateQuest("Collection Missions (Completed)", {
    Category = "Collection Missions",
    LVL = 4,
    Amount = 25,
    Instructions = "Complete 25 collection-based missions at the Logistics Centre",
    Tips = "TIP: Head over to the Imperial Logistics Centre, and interact with the mission vendor."
})

-- IMPERIAL ARCADE

CreateQuest("Imperial Arcade (Part 1)", {
    Category = "Imperial Arcade",
    LVL = 1,
    Amount = 5,
    Instructions = "Win 5 games of checkers.",
    Tips = "TIP: The Arcade is found on the 3rd floor, approach the checkers board and press E to start playing"
})

CreateQuest("Imperial Arcade (Part 2)", {
    Category = "Imperial Arcade",
    LVL = 2,
    Amount = 5,
    Instructions = "Win 5 games of chess.",
    Tips = "TIP: The Arcade is found on the 3rd floor, approach the chess board and press E to start playing"
})

CreateQuest("Imperial Arcade (Part 3)", {
    Category = "Imperial Arcade",
    LVL = 3,
    Amount = 10,
    Instructions = "Win 10 games of chess/checkers.",
    Tips = "TIP: The Arcade is found on the 3rd floor, approach the checkers or chess board and press E to start playing"
})  

CreateQuest("Imperial Arcade (Completed)", {
    Category = "Imperial Arcade",
    LVL = 4,
    Amount = 10,
    Instructions = "Win 10 games of chess/checkers.",
    Tips = "TIP: The Arcade is found on the 3rd floor, approach the checkers or chess board and press E to start playing"
})  

-- EVENT PARTICIPATON

CreateQuest("Event Participation (Part 1)", {
    Category = "Event Participation",
    LVL = 1,
    Amount = 3,
    Instructions = "Help out with 3 events.",
    Tips = "TIP: Events are constantly happening, play the server and you will encounter them, and the event masters will ask for help"
})

CreateQuest("Event Participation (Part 2)", {
    Category = "Event Participation",
    LVL = 2,
    Amount = 5,
    Instructions = "Help out with 5 events.",
    Tips = "TIP: Events are constantly happening, play the server and you will encounter them, and the event masters will ask for help"
})

CreateQuest("Event Participation (Part 3)", {
    Category = "Event Participation",
    LVL = 3,
    Amount = 10,
    Instructions = "Help out with 10 events.",
    Tips = "TIP: Events are constantly happening, play the server and you will encounter them, and the event masters will ask for help"
})

CreateQuest("Event Participation (Completed)", {
    Category = "Event Participation",
    LVL = 4,
    Amount = 10,
    Instructions = "Help out with 10 events.",
    Tips = "TIP: Events are constantly happening, play the server and you will encounter them, and the event masters will ask for help"
})

-- SECRET AREAS

CreateQuest("Secret Areas (Part 1)", {
    Category = "Secret Areas",
    LVL = 1,
    Amount = 1,
    Instructions = "Find secret area number 1.",
    Tips = "TIP: ????"
})

CreateQuest("Secret Areas (Part 2)", {
    Category = "Secret Areas",
    LVL = 2,
    Amount = 1,
    Instructions = "Find secret area number 2.",
    Tips = "TIP: ????"
})

CreateQuest("Secret Areas (Part 3)", {
    Category = "Secret Areas",
    LVL = 3,
    Amount = 1,
    Instructions = "Find secret area number 3.",
    Tips = "TIP: ????"
})

CreateQuest("Secret Areas (Completed)", {
    Category = "Secret Areas",
    LVL = 4,
    Amount = 1,
    Instructions = "Find secret area number 3.",
    Tips = "TIP: ????"
})


-- SECRET AREAS

CreateQuest("Extra (Part 1)", {
    Category = "Extra",
    LVL = 1,
    Amount = 1,
    Instructions = "Use the FPS Command.",
    Tips = "TIP: Type !fps in chat to improve your FPS"
})


CreateQuest("Extra (Part 2)", {
    Category = "Extra",
    LVL = 2,
    Amount = 1,
    Instructions = "Open the Pointshop.",
    Tips = "TIP: You can open the pointshop by pressing F3"
})


CreateQuest("Extra (Part 3)", {
    Category = "Extra",
    LVL = 3,
    Amount = 1,
    Instructions = "Open the F4 Menu.",
    Tips = "TIP: Through the F4 menu you can see all the roles the server has to offer."
})

CreateQuest("Extra (Completed)", {
    Category = "Extra",
    LVL = 4,
    Amount = 1,
    Instructions = "Open the F4 Menu.",
    Tips = "TIP: Through the F4 menu you can see all the roles the server has to offer."
})

-- SECRET AREAS

CreateQuest("Lotto (Part 1)", {
    Category = "Lotto",
    LVL = 1,
    Amount = 1,
    Instructions = "Win any tier in the lottery.",
    Tips = "TIP: Head to the imperial arcade to buy a lottery ticket."
})

CreateQuest("Lotto (Part 2)", {
    Category = "Lotto",
    LVL = 2,
    Amount = 25000,
    Instructions = "Win second tier or 25000 total points.",
    Tips = "TIP: Head to the imperial arcade to buy a lottery ticket."
})

CreateQuest("Lotto (Part 3)", {
    Category = "Lotto",
    LVL = 3,
    Amount = 75000,
    Instructions = "Win the jackpot or 75000 total points",
    Tips = "TIP: Head to the imperial arcade to buy a lottery ticket."
})

CreateQuest("Lotto (Completed)", {
    Category = "Lotto",
    LVL = 4,
    Amount = 75000,
    Instructions = "Win the jackpot or 75000 total points",
    Tips = "TIP: Head to the imperial arcade to buy a lottery ticket."
})