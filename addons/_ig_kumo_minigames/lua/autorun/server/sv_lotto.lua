IGLOTTO = IGLOTTO or {
    Players = {},
    Pot = 0
}

local jackpots = util.JSONToTable(file.Read("lottojackpotlog.txt", "DATA"))
util.AddNetworkString("LOTTERY_OpenDialogue")
util.AddNetworkString("BuyLottoTicket")

if file.Exists("lottopotsave.txt", "DATA") then
    IGLOTTO.Pot = tonumber(file.Read("lottopotsave.txt", "DATA"))
end

local function GenerateLottoNumbers()
    local lottonumberspick = {}

    for i = 1, 25 do
        table.insert(lottonumberspick, i, i)
    end

    local num1 = table.Random(lottonumberspick)
    table.RemoveByValue(lottonumberspick, num1)
    local num2 = table.Random(lottonumberspick)
    table.RemoveByValue(lottonumberspick, num2)
    local num3 = table.Random(lottonumberspick)
    table.RemoveByValue(lottonumberspick, num3)

    local lottopick = {num1, num2, num3}

    return lottopick
end

local function UpdatePotFile()
    file.Write("lottopotsave.txt", IGLOTTO.Pot)
end

local function CheckNumbers(ply, lotto)
    local tier = 0

    if ply[1] == lotto[1] or ply[1] == lotto[2] or ply[1] == lotto[3] then
        tier = tier + 1
    end

    if ply[2] == lotto[1] or ply[2] == lotto[2] or ply[2] == lotto[3] then
        tier = tier + 1
    end

    if ply[3] == lotto[1] or ply[3] == lotto[2] or ply[3] == lotto[3] then
        tier = tier + 1
    end

    return tier
end

local function CalcLottoPot(amt, clear)
    local playercounter = 1 - (player.GetCount() / 100)
    local playercountmulti = math.Clamp(playercounter, 0.1, 1)

    if amt == IGLOTTO.Pot or clear then
        IGLOTTO.Pot = 0
    else
        IGLOTTO.Pot = IGLOTTO.Pot - ((amt / 5) * playercountmulti) // testing
        file.Append("lottocalclog.txt", "[" .. os.date("%d-%m-%Y - %I:%M:%S %p", os.time()) .. "] " .. player.GetCount() .. " before: " .. amt .. " - after: " .. ((amt / 4) * playercountmulti) .. " \n")
    end

    if IGLOTTO.Pot <= 0 then
        IGLOTTO.Pot = math.random(1, 250)
    end

    IGLOTTO.Pot = math.Round(IGLOTTO.Pot)
    UpdatePotFile()
end

local function GiveLottoReward(ply, tier)
    if tier == 0 then
        ply:QUEST_SYSTEM_ChatNotify("Lotteries", "Better luck next time, you matched none of the lottery numbers.")
    elseif tier == 1 then
        //IGHALLOWEEN:UpdatePoints(ply:GetNWString("halloweenteam", "none"), 5, ply, "winning the lottery")
        local tier1reward = math.Round(IGLOTTO.Pot * 0.03)
        local bonus = 0
        _G.AdvanceQuest(ply,"Weekly","Chances: Calculated")

        if _G.HasAugment(ply, "Lady Luck I") and not _G.HasAugment(ply, "Lady Luck II") then
            bonus = math.Round(tier1reward * (math.random(0, 5) / 100))
            tier1reward = math.Round(tier1reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck I",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won first tier by matching 1/3 numbers, good work, you will receive " .. tier1reward .. " credits ( " .. math.Round(tier1reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck I)")
        elseif _G.HasAugment(ply, "Lady Luck II") and not _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier1reward * (math.random(2, 10) / 100))
            tier1reward = math.Round(tier1reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck II",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won first tier by matching 1/3 numbers, good work, you will receive " .. tier1reward .. " credits ( " .. math.Round(tier1reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck II)")
        elseif _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier1reward * (math.random(4, 15) / 100))
            _G.ActivateAugment(ply,"Lady Luck III",5)
            tier1reward = math.Round(tier1reward + bonus)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won first tier by matching 1/3 numbers, good work, you will receive " .. tier1reward .. " credits ( " .. math.Round(tier1reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck III)")
        else
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won first tier by matching 1/3 numbers, good work, you will receive " .. tier1reward .. " credits")
        end

        ply:SH_AddPremiumPoints(tier1reward, false, false)
        //ply:ProgressQuest("Lotto", 3, tier1reward)
        //ply:ProgressQuest("Lotto", 2, tier1reward)
        //ply:ProgressQuest("Lotto", 1)
        file.Append("lottolog.txt", "[" .. os.date("%d-%m-%Y - %I:%M:%S %p", os.time()) .. "] " .. ply:Nick() .. " has won first tier and received " .. tier1reward .. " credits \n")

        timer.Simple(5, function()
            CalcLottoPot(tier1reward)
        end)
    elseif tier == 2 then
        //IGHALLOWEEN:UpdatePoints(ply:GetNWString("halloweenteam", "none"), 20, ply, "winning the lottery")
        local tier2reward = math.Round(IGLOTTO.Pot * 0.15)
        local bonus = 0
        _G.AdvanceQuest(ply,"Weekly","Chances: Calculated")

        if _G.HasAugment(ply, "Lady Luck I") and not _G.HasAugment(ply, "Lady Luck II") then
            bonus = math.Round(tier2reward * (math.random(0, 5) / 100))
            tier2reward = math.Round(tier2reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck I",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won second tier by matching 2/3 numbers, good work, you will receive " .. tier2reward .. " credits ( " .. math.Round(tier2reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck I)")
        elseif _G.HasAugment(ply, "Lady Luck II") and not _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier2reward * (math.random(2, 10) / 100))
            tier2reward = math.Round(tier2reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck II",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won second tier by matching 2/3 numbers, good work, you will receive " .. tier2reward .. " credits ( " .. math.Round(tier2reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck II)")
        elseif _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier2reward * (math.random(4, 15) / 100))
            tier2reward = math.Round(tier2reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck III",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won second tier by matching 2/3 numbers, good work, you will receive " .. tier2reward .. " credits ( " .. math.Round(tier2reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck III)")
        else
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You won second tier by matching 2/3 numbers, good work, you will receive " .. tier2reward .. " credits")
        end

        ply:SH_AddPremiumPoints(tier2reward, false, false)
        //ply:ProgressQuest("Lotto", 3, tier2reward)
        //ply:ProgressQuest("Lotto", 2, 10000)
        //ply:ProgressQuest("Lotto", 1)
        file.Append("lottolog.txt", "[" .. os.date("%d-%m-%Y - %I:%M:%S %p", os.time()) .. "] " .. ply:Nick() .. " has won second tier and received " .. tier2reward .. " credits \n")

        timer.Simple(5, function()
            CalcLottoPot(tier2reward)
        end)
    elseif tier == 3 then
        //IGHALLOWEEN:UpdatePoints(ply:GetNWString("halloweenteam", "none"), 100, ply, "winning the jackpot")
        local tier3random = math.random(10, 13)
        local tier3reward = math.Round(IGLOTTO.Pot * (tier3random / 10))
        local bonus = 0
        _G.AdvanceQuest(ply,"Weekly","Chances: Calculated")

        if _G.HasAugment(ply, "Lady Luck I") and not _G.HasAugment(ply, "Lady Luck II") then
            bonus = math.Round(tier3reward * (math.random(0, 5) / 100))
            tier3reward = math.Round(tier3reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck I",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "YOU WON THE JACKPOT!!!!!!!, good work, you will receive " .. tier3reward .. " credits ( " .. math.Round(tier3reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck I)")
        elseif _G.HasAugment(ply, "Lady Luck II") and not _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier3reward * (math.random(2, 10) / 100))
            tier3reward = math.Round(tier3reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck II",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "YOU WON THE JACKPOT!!!!!!!, good work, you will receive " .. tier3reward .. " credits ( " .. math.Round(tier3reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck II)")
        elseif _G.HasAugment(ply, "Lady Luck III") then
            bonus = math.Round(tier3reward * (math.random(4, 15) / 100))
            tier3reward = math.Round(tier3reward + bonus)
            _G.ActivateAugment(ply,"Lady Luck III",5)
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "YOU WON THE JACKPOT!!!!!!!, good work, you will receive " .. tier3reward .. " credits ( " .. math.Round(tier3reward - bonus) .. " + " .. bonus .. " credits bonus from Lady Luck III)")
        else
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "YOU WON THE JACKPOT!!!!!!!, good work, you will receive " .. tier3reward .. " credits")
        end

        local stringcsay = ply:Nick() .. " has won the lottery jackpot of " .. tier3reward .. " credits!"
        RunConsoleCommand("ulx", "csay", stringcsay)
        ply:SH_AddPremiumPoints(tier3reward, false, false)
        //ply:ProgressQuest("Lotto", 3, 15000)
        //ply:ProgressQuest("Lotto", 2, 10000)
        //ply:ProgressQuest("Lotto", 1)
        file.Append("lottolog.txt", "!!!-!!! [" .. os.date("%d-%m-%Y - %I:%M:%S %p", os.time()) .. "] " .. ply:Nick() .. " HAS WON THE JACKPOT OF " .. tier3reward .. " credits !!!-!!! \n")

        table.insert(jackpots, {ply:Nick(), tier3reward, os.date("%d-%m-%Y", os.time())})

        file.Write("lottojackpotlog.txt", util.TableToJSON(jackpots))

        timer.Simple(5, function()
            CalcLottoPot(tier3reward, true)
        end)
    end

    ply.lottonumbers = nil
end

net.Receive("BuyLottoTicket", function(len, ply)
    if table.HasValue(IGLOTTO.Players, ply) then
        ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You already own a lottery ticket!")

        return
    end

    if not ply:SH_CanAffordPremium(100) then
        ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You cannot afford a lottery ticket!")

        return
    end

    ply:SH_SetPremiumPoints(ply:SH_GetPremiumPoints() - 100, false, false)
    IGLOTTO.Pot = IGLOTTO.Pot + (100 + math.random(1, 20))
    UpdatePotFile()
    table.insert(IGLOTTO.Players, ply)
    ply.lottonumbers = GenerateLottoNumbers()
    ply:QUEST_SYSTEM_ChatNotify("Lotteries", "Your lottery numbers are: " .. ply.lottonumbers[1] .. ", " .. ply.lottonumbers[2] .. ", " .. ply.lottonumbers[3])
end)

if not timer.Exists("LotteryDraw") then
    timer.Create("LotteryDraw", 1800, 0, function()
        if IGLOTTO.Pot == 0 or table.IsEmpty(IGLOTTO.Players) then return end
        local thelottonumbers = GenerateLottoNumbers()
        file.Append("lottolog.txt", "\n")

        for k, v in pairs(IGLOTTO.Players) do
            if not v or not v.lottonumbers then continue end
            v:QUEST_SYSTEM_ChatNotify("Lotteries", "Get ready, the lottery is commencing, the current pot is: " .. IGLOTTO.Pot .. " credits!")
            v:QUEST_SYSTEM_ChatNotify("Lotteries", "Your lottery numbers are: " .. v.lottonumbers[1] .. ", " .. v.lottonumbers[2] .. ", " .. v.lottonumbers[3])

            timer.Simple(1, function()
                v:QUEST_SYSTEM_ChatNotify("Lotteries", "Lottery numbers: (??,??,??)")
            end)

            timer.Simple(3, function()
                v:QUEST_SYSTEM_ChatNotify("Lotteries", "Lottery numbers: (" .. thelottonumbers[1] .. ",??,??)")
            end)

            timer.Simple(5, function()
                v:QUEST_SYSTEM_ChatNotify("Lotteries", "Lottery numbers: (" .. thelottonumbers[1] .. "," .. thelottonumbers[2] .. ",??)")
            end)

            timer.Simple(7, function()
                v:QUEST_SYSTEM_ChatNotify("Lotteries", "Lottery numbers: (" .. thelottonumbers[1] .. "," .. thelottonumbers[2] .. "," .. thelottonumbers[3] .. ")")
            end)

            timer.Simple(8, function()
                local tier = CheckNumbers(v.lottonumbers, thelottonumbers)
                GiveLottoReward(v, tier)
            end)
        end

        IGLOTTO.Players = {}
    end)
end

hook.Add("PlayerDisconnected", "LottoDisconnect", function(ply)
    if table.HasValue(IGLOTTO.Players, ply) then
        table.RemoveByValue(IGLOTTO.Players, ply)
    end
end)

hook.Add("PlayerSay", "PotViewer", function(ply, txt)
    if string.lower(txt) == "!lottery" or string.lower(txt) == "!lotto" then
        ply:QUEST_SYSTEM_ChatNotify("Lotteries", "The current pot for the lottery is: " .. IGLOTTO.Pot .. " credits!")

        if ply.lottonumbers then
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "Your lottery numbers are: " .. ply.lottonumbers[1] .. ", " .. ply.lottonumbers[2] .. ", " .. ply.lottonumbers[3])
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "The lottery draw will happen in roughly: " .. string.ToMinutesSeconds(timer.TimeLeft("LotteryDraw")))
        else
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "You do not own a ticket, head to the Imperial Lotteries vendor to purchase one.")
            ply:QUEST_SYSTEM_ChatNotify("Lotteries", "The lottery draw will happen in roughly: " .. string.ToMinutesSeconds(timer.TimeLeft("LotteryDraw")) .. " minutes")
        end
    end
end)

if not file.Exists("lottojackpotlog.txt", "DATA") then
    file.Write("lottojackpotlog.txt", util.TableToJSON({}))
end

hook.Add("PlayerSay", "JackPotsViewer", function(ply, txt)
    if string.lower(txt) == "!jackpots" then
        jackpots = util.JSONToTable(file.Read("lottojackpotlog.txt", "DATA"))

        if table.ToString(jackpots) == "{}" then
            ply:QUEST_SYSTEM_ChatNotify("Jackpots", "No jackpots have been won yet!")
        else
            ply:QUEST_SYSTEM_ChatNotify("Jackpots", "Here is a list of all the jackpots that have been won:")

            for k, v in pairs(jackpots) do
                ply:QUEST_SYSTEM_ChatNotify("Jackpots - " .. k, v[1] .. " won a jackpot of " .. v[2] .. " credits on " .. v[3])
            end
        end
    end
end)
