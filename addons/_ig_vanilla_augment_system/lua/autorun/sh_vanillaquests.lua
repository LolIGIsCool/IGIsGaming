vanillaIGDailyQuests = {}
vanillaIGWeeklyQuests = {}

function CreateQuest(name, questtbl)
    questtbl.Name = name
    questtbl.Type = questtbl.Type or "Daily"
    questtbl.Reward = questtbl.Reward or "0"
    questtbl.Info = questtbl.Info or "no information"
    questtbl.Amount = questtbl.Amount or "N/A"
    questtbl.Progress = 0

    if questtbl.Type == "Daily" then
        local IDcount = table.Count(vanillaIGDailyQuests) + 1
        vanillaIGDailyQuests[IDcount] = questtbl
    else
        local IDcount = table.Count(vanillaIGWeeklyQuests) + 1
        vanillaIGWeeklyQuests[IDcount] = questtbl
    end
end

// Daily Quests
CreateQuest("Climbing Expert I", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Use climbswep to jump 100 times.",
    Amount = 100
})
CreateQuest("Climbing Expert II", {
    Type = "Daily",
    Reward = "200 Credits, 200 XP",
    Info = "Use climbswep to jump 200 times.",
    Amount = 200
})
CreateQuest("Success Takes Strategy", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Play a game of chess/checkers",
    Amount = 1
})
CreateQuest("Take a Picture", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Take a screenshot using F12",
    Amount = 1
})
CreateQuest("Gifted with Legs I", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Walk or run 1000 metres.",
    Amount = 1000
})
CreateQuest("Gifted with Legs II", {
    Type = "Daily",
    Reward = "200 Credits, 200 XP",
    Info = "Walk or run 2000 metres.",
    Amount = 2000
})
CreateQuest("Gifted with Legs III", {
    Type = "Daily",
    Reward = "300 Credits, 300 XP",
    Info = "Walk or run 3000 metres.",
    Amount = 3000
})
CreateQuest("Communication is Key", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Use your communications device to comms in a message.",
    Amount = 1
})
CreateQuest("Memento Mori", {
    Type = "Daily",
    Reward = "300 Credits, 300 XP",
    Info = "Die 3 times.",
    Amount = 3
})
CreateQuest("The One and Only", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Get someone else to say your whole name in chat.",
    Amount = 1
})
CreateQuest("OUR Credits", {
    Type = "Daily",
    Reward = "0 Credits, 500 XP",
    Info = "Donate any amount of credits to another player.",
    Amount = 1
})
CreateQuest("Not Just a Stormtrooper", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Shoot any gun 500 times.",
    Amount = 500
})
CreateQuest("Up to Date", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Check for new content using !content.",
    Amount = 1
})
CreateQuest("Let There Be Light", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Turn your flashlight on and off 30 times.",
    Amount = 30
})
CreateQuest("Thunder Thighs I", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Crouch 50 times.",
    Amount = 50
})
CreateQuest("Thunder Thighs II", {
    Type = "Daily",
    Reward = "200 Credits, 200 XP",
    Info = "Crouch 100 times.",
    Amount = 100
})
CreateQuest("I've Got You In My Sights", {
    Type = "Daily",
    Reward = "200 Credits, 200 XP",
    Info = "Aim down the sights of your gun 200 times.",
    Amount = 200
})
CreateQuest("The Other Side", {
    Type = "Daily",
    Reward = "500 Credits, 1000 XP",
    Info = "Become an event character.",
    Amount = 1
})
CreateQuest("The Follower", {
    Type = "Daily",
    Reward = "300 Credits, 300 XP",
    Info = "Say 'Yes, sir.' 3 times.",
    Amount = 3
})
CreateQuest("Redemption I", {
    Type = "Daily",
    Reward = "100 Credits, 100 XP",
    Info = "Get healed for 100 health. (Bacta Injector, Bacta Bomb, or Healing Droid)",
    Amount = 100
})
CreateQuest("Redemption II", {
    Type = "Daily",
    Reward = "200 Credits, 200 XP",
    Info = "Get healed for 200 health. (Bacta Injector, Bacta Bomb, or Healing Droid)",
    Amount = 200
})
CreateQuest("Redemption III", {
    Type = "Daily",
    Reward = "300 Credits, 300 XP",
    Info = "Get healed for 300 health. (Bacta Injector, Bacta Bomb, or Healing Droid)",
    Amount = 300
})

// Weekly Quests
CreateQuest("Reliable Trooper", {
    Type = "Weekly",
    Reward = "2000 Credits, 5000 XP, 3 Augment Points",
    Info = "Complete 12 daily quests.",
    Amount = 12
})
CreateQuest("Cleanup Crew", {
    Type = "Weekly",
    Reward = "1000 Credits, 2500 XP, 1 Augment Point",
    Info = "Kill 10 hostile event characters.",
    Amount = 10
})
CreateQuest("Chances: Calculated", {
    Type = "Weekly",
    Reward = "1000 Credits, 2500 XP, 1 Augment Point",
    Info = "Win any tier in the lottery.",
    Amount = 1
})
CreateQuest("Never Skip Leg Day", {
    Type = "Weekly",
    Reward = "2500 Credits, 2500 XP, 1 Augment Point",
    Info = "Jump 4000 times.",
    Amount = 4000
})
CreateQuest("The REAL Event Master", {
    Type = "Weekly",
    Reward = "2500 Credits, 2500 XP, 3 Augment Point",
    Info = "Become an event character 5 times.",
    Amount = 5
})
CreateQuest("Run Like You Mean It", {
    Type = "Weekly",
    Reward = "2500 Credits, 3000 XP, 1 Augment Point",
    Info = "Run for 30,000 metres.",
    Amount = 30000
})
CreateQuest("Sky's the Limit", {
    Type = "Weekly",
    Reward = "2500 Credits, 2500 XP, 1 Augment Point",
    Info = "Use Climb SWEP 1500 times.",
    Amount = 1500
})
