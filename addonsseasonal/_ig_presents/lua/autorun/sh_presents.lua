IGPresentTable = {}

IGRandomTable = {
    ["points"] = {},
    ["credits"] = {},
    ["xp"] = {},
    ["special"] = {}
}

local chancetablol = {
    ["1"] = 40,
    ["2"] = 30,
    ["3"] = 20,
    ["4"] = 15,
    ["5"] = 5,
    ["6"] = 1,
}

local colortablol = {
    ["points"] = Color(29, 0, 255),
    ["credits"] = Color(0, 255, 63),
    ["xp"] = Color(255, 0, 0),
    ["special"] = Color(255, 191, 0)
}

function CreateIGReward(id, rewardtbl)
    if not istable(rewardtbl) then
        ErrorNoHalt("FAILED CREATING REWARD:" .. (name or "nil"))

        return
    end

    rewardtbl.ID = id
    rewardtbl.Type = rewardtbl.Type or "none"
    rewardtbl.Colour = colortablol[rewardtbl.Type] or Color(0, 0, 0)
    rewardtbl.Text = rewardtbl.Text or "none"
    rewardtbl.Amount = rewardtbl.Amount or 0
    rewardtbl.Chance = rewardtbl.Chance or chancetablol[string.sub(id, string.len(id), string.len(id))]
    IGPresentTable[id] = rewardtbl
    table.insert(IGRandomTable[rewardtbl.Type], {rewardtbl.Chance, id})
end

-- Reward NAME
-- UNIQUE ID for reward
CreateIGReward("credit1", {
    Type = "credits", -- Type of reward Current Available: {credits, points, xp}
    Text = "250 credits.", -- Text to appear in chat that fits into this: X has found a present and won Text)
    Amount = 250 -- Amount of reward to give
})

CreateIGReward("credit2", {
    Type = "credits",
    Text = "500 credits.",
    Amount = 500
})

CreateIGReward("credit3", {
    Type = "credits",
    Text = "750 credits.",
    Amount = 750
})

CreateIGReward("credit4", {
    Type = "credits",
    Text = "1000 credits.",
    Amount = 1000
})

CreateIGReward("credit5", {
    Type = "credits",
    Text = "5000 credits.",
    Amount = 5000
})

CreateIGReward("credit6", {
    Type = "credits",
    Text = "20000 credits.",
    Amount = 20000
})

CreateIGReward("point1", {
    Type = "points",
    Text = "1000 credits.",
    Amount = 1000
})

CreateIGReward("point2", {
    Type = "points",
    Text = "2000 credits.",
    Amount = 2000
})

CreateIGReward("point3", {
    Type = "points",
    Text = "3000 credits.",
    Amount = 3000
})

CreateIGReward("point4", {
    Type = "points",
    Text = "5000 credits.",
    Amount = 5000
})

CreateIGReward("point5", {
    Type = "points",
    Text = "10000 credits.",
    Amount = 10000
})

CreateIGReward("point6", {
    Type = "points",
    Text = "25000 credits.",
    Amount = 25000
})

CreateIGReward("xp1", {
    Type = "xp",
    Text = "5000 xp.",
    Amount = 5000
})

CreateIGReward("xp2", {
    Type = "xp",
    Text = "7500 xp.",
    Amount = 7500
})

CreateIGReward("xp3", {
    Type = "xp",
    Text = "10000 xp.",
    Amount = 10000
})

CreateIGReward("xp4", {
    Type = "xp",
    Text = "15000 xp.",
    Amount = 15000
})

CreateIGReward("xp5", {
    Type = "xp",
    Text = "30000 xp.",
    Amount = 30000
})

CreateIGReward("xp6", {
    Type = "xp",
    Text = "100000 xp.",
    Amount = 100000
})

CreateIGReward("special1", {
    Type = "special",
    Chance = 1,
    Text = "limited edition Candy Cane E-11 (PointShop).",
    Amount = 1
})

if CLIENT then
    function playchristmassound()
        sound.PlayURL("http://imperialgaming.net/kumo/bells.ogg", "", function(station,xxd,xdd)
            if (IsValid(station)) then
                station:SetPos(LocalPlayer():GetPos())
                station:Play()
            end
        end)
    end

    net.Receive("christmassoundmeme", playchristmassound)
end