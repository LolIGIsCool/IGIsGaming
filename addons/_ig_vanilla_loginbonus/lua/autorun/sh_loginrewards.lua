vanillaIGLoginRewards = {}

function CreateReward(day, logintbl)
    logintbl.Day = day
    logintbl.Reward1 = logintbl.Reward1 or "0 credits"
    logintbl.Reward2 = logintbl.Reward2 or "0 augment pts"

    local IDcount = table.Count(vanillaIGLoginRewards) + 1
    vanillaIGLoginRewards[IDcount] = logintbl
end

//Daily Rewards
CreateReward(1, {
    Reward1 = "1000 credits",
    Reward2 = "0 augment pts"
})
CreateReward(2, {
    Reward1 = "2000 credits",
    Reward2 = "0 augment pts"
})
CreateReward(3, {
    Reward1 = "3000 credits",
    Reward2 = "0 augment pts"
})
CreateReward(4, {
    Reward1 = "0 credits",
    Reward2 = "1 augment pts"
})
CreateReward(5, {
    Reward1 = "4000 credits",
    Reward2 = "0 augment pts"
})
CreateReward(6, {
    Reward1 = "5000 credits",
    Reward2 = "0 augment pts"
})
CreateReward(7, {
    Reward1 = "0 credits",
    Reward2 = "2 augment pts"
})
//Streak Rewards
CreateReward(14, {
    Reward1 = "10000 credits",
    Reward2 = "3 augment pts"
})
CreateReward(28, {
    Reward1 = "20000 credits",
    Reward2 = "4 augment pts"
})
CreateReward(35, {
    Reward1 = "50000 credits",
    Reward2 = "5 augment pts"
})
CreateReward(50, {
    Reward1 = "100000 credits",
    Reward2 = "6 augment pts"
})
CreateReward(75, {
    Reward1 = "250000 credits",
    Reward2 = "8 augment pts"
})
CreateReward(100, {
    Reward1 = "500000 credits",
    Reward2 = "10 augment pts"
})
CreateReward(150, {
    Reward1 = "750000 credits",
    Reward2 = "12 augment pts"
})
CreateReward(200, {
    Reward1 = "1000000 credits",
    Reward2 = "15 augment pts"
})
CreateReward(300, {
    Reward1 = "125000 credits",
    Reward2 = "18 augment pts"
})
CreateReward(365, {
    Reward1 = "150000 credits",
    Reward2 = "20 augment pts"
})
CreateReward(500, {
    Reward1 = "2000000 credits",
    Reward2 = "25 augment pts"
})
