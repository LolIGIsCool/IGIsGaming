util.AddNetworkString("VANILLAAUGMENTS_net_OpenSkillMenu")
util.AddNetworkString("VANILLAAUGMENTS_net_OpenQuestMenu")

util.AddNetworkString("VANILLAAUGMENTS_net_PurchaseAttempt")
util.AddNetworkString("VANILLAAUGMENTS_net_PurchaseSuccess")
util.AddNetworkString("VANILLAAUGMENTS_net_PurchaseFailed")

util.AddNetworkString("VANILLAAUGMENTS_net_SendWeeklies")
util.AddNetworkString("VANILLAAUGMENTS_net_SendDailies")
util.AddNetworkString("VANILLAAUGMENTS_net_SendPlayerData")

util.AddNetworkString("VANILLAAUGMENTS_net_CollectionAttempt")
util.AddNetworkString("VANILLAAUGMENTS_net_CollectionSuccess")

util.AddNetworkString("VANILLAAUGMENTS_net_QuestComplete")
util.AddNetworkString("VANILLAAUGMENTS_net_WeekComplete")

util.AddNetworkString("VANILLAAUGMENTS_net_ResetTree")
util.AddNetworkString("VANILLAAUGMENTS_net_RerollQuests")

//stack overflow
local function my_random(t,from, to)
   local num = math.random(from, to)
   if t[num] then  num = my_random(t, from, to) end
   t[num] = num
   return num
end
t = {}

//Creates vanilla_augments folder
if not file.IsDir("vanilla_augments", "DATA") then
    file.CreateDir("vanilla_augments")
end
if not file.IsDir("vanilla_augments/dailies", "DATA") then
    file.CreateDir("vanilla_augments/dailies")
end
if not file.IsDir("vanilla_augments/weeklies", "DATA") then
    file.CreateDir("vanilla_augments/weeklies")
end

//Method to save player data
function SavePlayerData(id, data)
    if not file.Exists("vanilla_augments/" .. id .. ".json","DATA") then
        local augmentData = {}
        augmentData.Points = 0
        local converted = util.TableToJSON(augmentData,true)
        file.Write("vanilla_augments/" .. id ..  ".json",converted)
    else
        local converted = util.TableToJSON(data,true)
        file.Write("vanilla_augments/" .. id .. ".json", converted)
    end
end

//Quests this time
function SaveQuestData(ply, daily, weekly)
    local id = ply:SteamID64()

    if file.Exists("vanilla_augments/dailies/" .. id .. ".json","DATA") then
        if daily ~= nil then
            local converted = util.TableToJSON(daily,true)
            file.Write("vanilla_augments/dailies/" .. id .. ".json", converted)
        end
    else
        local questData = {}

        for i = 1, 4 do
            local number
            repeat
                number = my_random(t,1,table.Count(vanillaIGDailyQuests))
                if vanillaIGDailyQuests[number].Name == "Completed" then print("SYS!!!") end
            until (vanillaIGDailyQuests[number].Name ~= "Completed")
            table.insert(questData,vanillaIGDailyQuests[number])
        end
        t = {}

        local converted = util.TableToJSON(questData,true)
        file.Write("vanilla_augments/dailies/" .. id .. ".json", converted)
    end

    if file.Exists("vanilla_augments/weeklies/" .. id .. ".json","DATA") then
        if weekly ~= nil then
            local converted = util.TableToJSON(weekly,true)
            file.Write("vanilla_augments/weeklies/" .. id .. ".json", converted)
        end
    else
        local questData = {}

        for i = 1, 2 do
            local number
            repeat
                number = my_random(t,2,table.Count(vanillaIGWeeklyQuests))
            until (vanillaIGWeeklyQuests[number].Name ~= "Completed")
            table.insert(questData,vanillaIGWeeklyQuests[number])
        end
        t = {}

        table.insert(questData,vanillaIGWeeklyQuests[1])

        local converted = util.TableToJSON(questData,true)
        file.Write("vanilla_augments/weeklies/" .. id .. ".json", converted)
    end
end

//Method to read player data
function ReadPlayerData(id)
    if not file.Exists("vanilla_augments/" .. id .. ".json", "DATA") then return end
    local data = util.JSONToTable(file.Read("vanilla_augments/" .. id .. ".json"))

    return data
end

//Read quests
function ReadQuestData(id)
    local data, data2
    if file.Exists("vanilla_augments/dailies/" .. id .. ".json", "DATA") then
        data = util.JSONToTable(file.Read("vanilla_augments/dailies/" .. id .. ".json"))
    end
    if file.Exists("vanilla_augments/weeklies/" .. id .. ".json", "DATA") then
        data2 = util.JSONToTable(file.Read("vanilla_augments/weeklies/" .. id .. ".json"))
    end

    return data, data2
end

//Creates .json file for player
function CreatePlayerData(ply)
    if not file.Exists("vanilla_augments/" .. ply:SteamID64() .. ".json","DATA") then
        SavePlayerData(ply:SteamID64())
    end

    if not file.Exists("vanilla_augments/dailies/" .. ply:SteamID64() .. ".json","DATA") then
        SaveQuestData(ply)
    end

    if not file.Exists("vanilla_augments/weeklies/" .. ply:SteamID64() .. ".json","DATA") then
        SaveQuestData(ply)
    end

    timer.Simple(1.5,function()
        local dailyData, weeklyData = ReadQuestData(ply:SteamID64())
        local augmentData = ReadPlayerData(ply:SteamID64());

        ply.dailyQuests = dailyData
        ply.weeklyQuests = weeklyData

        ply.vanillaAugments = augmentData;
    end)
end
hook.Add("PlayerInitialSpawn", "VANILLAAUGMENTS_CreatePlayerData", CreatePlayerData)

//Function to advance quests (NOW OPTIMIZED!!!)
function AdvanceQuest(ply,typex,quest)
    local daily = ply.dailyQuests
    local weekly = ply.weeklyQuests

    //Do they have the quest
    if typex == "Daily" then
        if !daily then return end
        for k, v in pairs(daily) do
            if v.Name == quest then
                if v.Progress >= v.Amount then return end
                v.Progress = v.Progress + 1
                if v.Progress == v.Amount then
                    net.Start("VANILLAAUGMENTS_net_QuestComplete")
                    net.WriteString(quest)
                    net.WriteBool(false)
                    net.Send(ply)

                    //AdvanceQuest(ply,"Weekly","Reliable Trooper")
                end
                ply.dailyQuests = daily

                net.Start("VANILLAAUGMENTS_net_SendDailies")
                net.WriteTable(daily)
                net.Send(ply)
            end
        end
    else
		if !weekly then return end
        for k, v in pairs(weekly) do
            if v.Name == quest then
                if v.Progress >= v.Amount then return end
                v.Progress = v.Progress + 1
                if v.Progress == v.Amount then
                    net.Start("VANILLAAUGMENTS_net_QuestComplete")
                    net.WriteString(quest)
                    net.WriteBool(true)
                    net.Send(ply)
                end
                ply.weeklyQuests = weekly

                net.Start("VANILLAAUGMENTS_net_SendWeeklies")
                net.WriteTable(weekly)
                net.Send(ply)
            end
        end
    end
end

//Receive Purchase Attempt
net.Receive("VANILLAAUGMENTS_net_PurchaseAttempt",function(len,ply)
    local augment = net.ReadString()
    local plyData = ReadPlayerData(ply:SteamID64())
    local augCost

    local hasPoints, hasPrevious = false, false

    //Do they already have the augment
    if table.HasValue(plyData,augment) then return end

    //Do they have enough points
    for k, v in pairs(vanillaIGAugmentTree) do
        if (v.Name == augment) and (tonumber(plyData.Points) >= tonumber(v.Cost)) then
            hasPoints = true
            augCost = tonumber(v.Cost)
        end
    end

    //Do they have the previous augments
    for k, v in pairs(vanillaIGAugmentTree) do
        if (v.Name == augment) then
            local req = string.Explode(" + ",v.Req)
            if req[1] == "" then
                //If no requirement
                hasPrevious = true
            elseif (table.Count(req) == 1) and not (req[1] == "") and (table.HasValue( plyData, req[1] )) then
                //If one requirement
                hasPrevious = true
            elseif (table.Count(req) == 2) and (table.HasValue(plyData,req[1])) and (table.HasValue(plyData,req[2])) then
                //If two requirements
                hasPrevious = true
            end
        end
    end

    //Ace up the sleeve
    if string.StartWith(augment,"Ace") and (table.HasValue(plyData,"Ace up the Sleeve [PRIMARY]") or table.HasValue(plyData,"Ace up the Sleeve [SPECIALIST]")) then return end

    //Complete the purchase.
    if hasPoints == true and hasPrevious == true then
        table.insert( plyData, augment )
        local newPoints = tonumber(plyData.Points) - augCost
        plyData.Points = newPoints

        //All Survival Mythics
        if table.HasValue(plyData,"Swift Recovery") and table.HasValue(plyData,"Heal Intake II") and table.HasValue(plyData,"Health Booster III") and table.HasValue(plyData,"Passive Recovery") and not table.HasValue(plyData,"All Survival Augments") then table.insert( plyData, "All Survival Augments" ) end
        //All Offense Mythics
        if table.HasValue(plyData,"Inspiring Aura") and table.HasValue(plyData,"Zenith Potential") and table.HasValue(plyData,"Bloodlust") and not table.HasValue(plyData,"All Offense Augments") then table.insert( plyData, "All Offense Augments" ) end
        //All Profit Mythics
        if table.HasValue(plyData,"Lady Luck III") and table.HasValue(plyData,"Experience Accumulator II") and not table.HasValue(plyData,"All Profit Augments") then table.insert( plyData, "All Profit Augments" ) end
        //All Utility Mythics
        if table.HasValue(plyData,"Starship Overdrive") and table.HasValue(plyData,"Faster Than Light III") and not table.HasValue(plyData,"All Utility Augments") then table.insert( plyData, "All Utility Augments" ) end
        //All Mobility
        if table.HasValue(plyData,"Tauntaun Legs II") and table.HasValue(plyData, "Skilled Crawler III") then table.insert( plyData, "All Mobility Augments" ) end
        //All Specialty
        if table.HasValue(plyData,"Steadfast Presence II") and table.HasValue(plyData, "Efficient Discharge") and table.HasValue(plyData, "Slow Metabolism") and table.HasValue(plyData, "Stimulant Addict") and table.HasValue(plyData, "Personal Resentment") and table.HasValue(plyData, "Wookie Arms") then table.insert( plyData, "All Specialty Augments" ) end

        SavePlayerData(ply:SteamID64(),plyData)

        timer.Simple(1.5, function()
            ply.vanillaAugments = plyData;
        end)

        net.Start("VANILLAAUGMENTS_net_PurchaseSuccess")
        net.WriteTable(plyData)
        net.Send(ply)
    else
        net.Start("VANILLAAUGMENTS_net_PurchaseFailed")
        net.Send(ply)
    end
end)

//does exactly what it says
net.Receive("VANILLAAUGMENTS_net_ResetTree",function(len,ply)
    if not ply:SH_CanAffordPremium(100000) then
        ply:ChatPrint("You do not have 100,000 credits.")
        return
    end

    local data = ReadPlayerData(ply:SteamID64())

    //adds the price of all augments owned
    local counter = 0
    for k, v in pairs(data) do
        if v ~= "All Profit Augments" or "All Utility Augments" or "All Survival Augments" or "All Offense Augments" or "All Mobility Augments" or "All Specialty Augments" then
            for k2, v2 in pairs(vanillaIGAugmentTree) do
                if v2.Name == v then
                    counter = counter + v2.Cost
                end
            end
        end
    end

    //end if they have no augments
    if counter == 0 then
        ply:ChatPrint("You have no augments to refund.")
        return
    end

    //take credits
    ply:SH_AddPremiumPoints(-100000, nil, false, false)

    //give points
    local value = tonumber(data.Points) + tonumber(counter)
    local newTable = {
        Points = value
    }
    SavePlayerData(ply:SteamID64(),newTable)
    ply:ChatPrint("Your augments have been refunded and you have gained: " .. counter .. " augment points.")

    timer.Simple(1.5, function()
        ply.vanillaAugments = newTable;
    end)
end)

net.Receive("VANILLAAUGMENTS_net_RerollQuests",function(len,ply)
    SaveQuestData(ply, ply.dailyQuests, ply.weeklyQuests)

    local weekly = net.ReadBool()
    local dQuests = ply.dailyQuests
    local wQuests = ply.weeklyQuests
    if weekly == true then
        if not ply:SH_CanAffordPremium(10000) then
            ply:ChatPrint("You do not have 10,000 credits.")
            return
        end

        local counter = 0
        local toRoll = {}
        for k, v in pairs(wQuests) do
            if v.Name == "Completed" or v.Name == "Reliable Trooper" then
                counter = counter + 1
            else
                table.insert(toRoll,k)
            end
        end

        if counter == 3 then
            ply:ChatPrint("You do not have any eligible quests to reroll.")
            return
        end

        ply:SH_AddPremiumPoints(-10000, nil, false, false)

        for k, v in pairs(toRoll) do
            local number
            repeat
                number = my_random(t,2,table.Count(vanillaIGWeeklyQuests))
            until (vanillaIGWeeklyQuests[number].Name ~= "Completed")
            wQuests[v] = vanillaIGWeeklyQuests[number]
        end
        t = {}
        ply:ChatPrint("Your eligible weekly quests have been rerolled.")
    else
        if not ply:SH_CanAffordPremium(5000) then
            ply:ChatPrint("You do not have 5,000 credits.")
            return
        end

        local counter = 0
        local toRoll = {}
        for k, v in pairs(dQuests) do
            if v.Name == "Completed" then
                counter = counter + 1
            else
                table.insert(toRoll,k)
            end
        end

        if counter == 4 then
            ply:ChatPrint("You do not have any eligible quests to reroll.")
            return
        end

        ply:SH_AddPremiumPoints(-5000, nil, false, false)

        for k, v in pairs(toRoll) do
            local number
            repeat
                number = my_random(t,1,table.Count(vanillaIGDailyQuests))
            until (vanillaIGDailyQuests[number].Name ~= "Completed")
            dQuests[v] = vanillaIGDailyQuests[number]
        end
        t = {}
        ply:ChatPrint("Your eligible daily quests have been rerolled.")
    end
    ply.dailyQuests = dQuests
    ply.weeklyQuests = wQuests
    SaveQuestData(ply, dQuests, wQuests)
end)

net.Receive("VANILLAAUGMENTS_net_CollectionAttempt",function(len, ply)
    local daily = ply.dailyQuests
    local weekly = ply.weeklyQuests
    local hasQuest = false
    local tbl = net.ReadTable()
    local quest = tbl.Name
    local reward

    local emptTbl = {}
    emptTbl.Name = "Completed"
    emptTbl.Type = ""
    emptTbl.Reward = ""
    emptTbl.Info = ""
    emptTbl.Progress = 0
    emptTbl.Amount = 0

    local counter = 0

    //Do they have the quest
    if tbl.Type == "Daily" then
        for k, v in pairs(daily) do
            if v.Name == quest then
                if v.Progress ~= v.Amount then return end
                reward = v.Reward
                hasQuest = true
                AdvanceQuest(ply,"Weekly","Reliable Trooper")

                table.Merge(v,emptTbl)
            end
        end
    else
        for k, v in pairs(weekly) do
            if v.Name == quest then
                if v.Progress ~= v.Amount then return end
                reward = v.Reward
                hasQuest = true

                table.Merge(v,emptTbl)
            end
            if v.Name == "Completed" then
                counter = counter + 1
            end
        end
    end

    if hasQuest == false then return end

    local rewardTable, creds, xp, points
    local plyData = ReadPlayerData(ply:SteamID64())

    if counter == 3 then
        local newPoints = tonumber(plyData.Points) + 5
        plyData.Points = newPoints

        SimpleXPAddXP(ply,5000)
        ply:SH_AddPremiumPoints(5000, nil, false, false)
        SavePlayerData(ply:SteamID64(),plyData)

        timer.Simple(1.5, function()
            ply.vanillaAugments = plyData;
        end)

        net.Start("VANILLAAUGMENTS_net_WeekComplete")
        net.Send(ply)
    end

    rewardTable = string.Explode(", ",reward)
    creds = string.Explode(" ",rewardTable[1])
    xp = string.Explode(" ",rewardTable[2])
    if rewardTable[3] ~= nil then
        points = string.Explode(" ",rewardTable[3])

        local newPoints = tonumber(plyData.Points) + points[1]
        plyData.Points = newPoints

        SavePlayerData(ply:SteamID64(),plyData)

        timer.Simple(1.5, function()
            ply.vanillaAugments = plyData;
        end)
    end

    SimpleXPAddXP(ply,tonumber(xp[1]))
    ply:SH_AddPremiumPoints(creds[1], nil, false, false)

    SaveQuestData(ply, daily, weekly)

    net.Start("VANILLAAUGMENTS_net_SendDailies")
    net.WriteTable(daily)
    net.Send(ply)

    net.Start("VANILLAAUGMENTS_net_SendWeeklies")
    net.WriteTable(weekly)
    net.Send(ply)

    net.Start("VANILLAAUGMENTS_net_SendPlayerData")
    net.WriteTable(plyData)
    net.Send(ply)
end)

//Opens the skill menu on client side
function OpenMenu(ply, key)
    if key == KEY_F8 then
        local plyData = ReadPlayerData(ply:SteamID64())

        net.Start("VANILLAAUGMENTS_net_OpenSkillMenu")
        net.WriteTable(plyData)
        net.Send(ply)
    end

    if key == KEY_F7 then
        local plyData = ReadPlayerData(ply:SteamID64())

        net.Start("VANILLAAUGMENTS_net_OpenQuestMenu")
        net.Send(ply)

        net.Start("VANILLAAUGMENTS_net_SendDailies")
        net.WriteTable(ply.dailyQuests)
        net.Send(ply)

        net.Start("VANILLAAUGMENTS_net_SendWeeklies")
        net.WriteTable(ply.weeklyQuests)
        net.Send(ply)

        net.Start("VANILLAAUGMENTS_net_SendPlayerData")
        net.WriteTable(plyData)
        net.Send(ply)
    end
    //if key == KEY_F6 then
    //    local delTable = file.Find( "vanilla_augments/dailies/*.json", "DATA")
    //    for k, v in pairs(delTable) do
    //        file.Delete("vanilla_augments/dailies/" .. v)
    //    end
    //    for k, v in pairs(player.GetAll()) do
    //        CreatePlayerData(v)
    //        v:ChatPrint("[QUEST] Dailies have been reset!")
    //    end
    //end
    //if key == KEY_F5 then
    //    for k, v in pairs(player.GetAll()) do
    //        PrintTable(v.dailyQuests)
    //    end
    //end
end
hook.Add("PlayerButtonDown", "VANILLAAUGMENTS_hook_OpenMenu", OpenMenu)

concommand.Add("vanilla_reset_dailies", function(ply)
    if not IsValid(ply) then
        local delTable = file.Find( "vanilla_augments/dailies/*.json", "DATA")
        for k, v in pairs(delTable) do
            file.Delete("vanilla_augments/dailies/" .. v)
        end
        for k, v in pairs(player.GetAll()) do
            CreatePlayerData(v)
            v:ChatPrint("[QUEST] Dailies have been reset!")
        end
    end
end)
concommand.Add("vanilla_reset_weeklies", function(ply)
    if not IsValid(ply) then
        local delTable = file.Find( "vanilla_augments/weeklies/*.json", "DATA")
        for k, v in pairs(delTable) do
            file.Delete("vanilla_augments/weeklies/" .. v)
        end
        for k, v in pairs(player.GetAll()) do
            CreatePlayerData(v)
            v:ChatPrint("[QUEST] Weeklies have been reset!")
        end
    end
end)

//save quest data via leave
hook.Add("PlayerDisconnected", "VANILLAAUGMENTS_hook_PlayerDisconnected", function(ply)
    SaveQuestData(ply,ply.dailyQuests,ply.weeklyQuests)
end)

local delay = 0
hook.Add( "Think", "VANILLAAUGMENTS_Hook_SaveData", function()
    if CurTime() < delay then return end
    for k, v in pairs(player.GetAll()) do
        SaveQuestData(v,v.dailyQuests,v.weeklyQuests)
    end

    MsgN("[ ♡ | VANILLA AUGMENT SYSTEM ] Saved quest data!")
    delay = CurTime() + 300
end)
