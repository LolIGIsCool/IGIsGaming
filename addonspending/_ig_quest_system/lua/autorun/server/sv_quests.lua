util.AddNetworkString("NetworkQuestStuff")
util.AddNetworkString("NetworkQuestSound")
util.AddNetworkString("OpenF7Quest")
util.AddNetworkString("OpenSkillQuest")
util.AddNetworkString("RequestPrestiging")
util.AddNetworkString("RequestSkillProgress")
util.AddNetworkString("openedpointshop")
util.AddNetworkString("NetworkVoiceChange")
QUESTPRESTIGES = {}
resource.AddFile("sound/questvictory.mp3")
local plymetar = FindMetaTable("Player")

if not file.IsDir("igquests", "DATA") then
    file.CreateDir("igquests")
end

if not file.IsDir("igquestslog", "DATA") then
    file.CreateDir("igquestslog")
end

if not file.Exists("igquestslog/prestiges.txt", "DATA") then
    file.Write("igquestslog/prestiges.txt", util.TableToJSON({}, false))
else
    QUESTPRESTIGES = util.JSONToTable(file.Read("igquestslog/prestiges.txt", "DATA"))
end

if (not sql.TableExists("igquestpoints")) then
    sql.Query("CREATE TABLE IF NOT EXISTS igquestpoints ( steamid TEXT NOT NULL PRIMARY KEY, points INTEGER, progressc INTEGER, progressp INTEGER, progressu INTEGER );")
end

function NetworkQuestStuff(ply)
    net.Start("NetworkQuestStuff")
    net.WriteTable(ply.questprogress)
    net.Send(ply)
end

function WriteQuestStuff(ply)
    if istable(ply.questprogress) and ply.questprogress ~= {} then
        local queststuff = util.TableToJSON(ply.questprogress, false)
        file.Write("igquests/" .. ply:SteamID64() .. ".txt", queststuff)
    end
end

function IGAddQuestPoints(ply, points)
    if not ply or not points then return end
    local pointslol = sql.QueryValue("SELECT points FROM igquestpoints WHERE steamid = " .. sql.SQLStr(ply:SteamID64()) .. " LIMIT 1") or 0
    pointslol = pointslol + points

    if pointslol < 0 then
        pointslol = 0
    end

    sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(ply:SteamID64()) .. ", " .. sql.SQLStr(pointslol) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressc", 0)) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressp", 0)) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressu", 0)) .. " )")
    ply:SetNWInt("igquestpoints", pointslol)
end

function IGRemoveQuestPoints(ply, points)
    if not ply or not points then return end
    local pointslol = sql.QueryValue("SELECT points FROM igquestpoints WHERE steamid = " .. sql.SQLStr(ply:SteamID64()) .. " LIMIT 1") or 0
    pointslol = pointslol - points

    if pointslol < 0 then
        pointslol = 0
    end

    sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(ply:SteamID64()) .. ", " .. sql.SQLStr(pointslol) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressc", 0)) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressp", 0)) .. ", " .. sql.SQLStr(ply:GetNWInt("igprogressu", 0)) .. " )")
    ply:SetNWInt("igquestpoints", pointslol)
end

function IGHasQuestPoints(ply, points)
    local pointslol = sql.QueryValue("SELECT points FROM igquestpoints WHERE steamid = " .. sql.SQLStr(ply:SteamID64()) .. " LIMIT 1") or 0
    if tonumber(pointslol) >= tonumber(points) then return true end

    return false
end

function plymetar:ProgressQuest(quest, lvl, progey)
    if not self.questprogress or not self.questprogress[quest] or not IGCATEGORYQUESTS[quest] then return end
    if self.questprogress[quest].Completed then return end
    if self.questprogress[quest].Level ~= lvl then return end
    local progamnt = progey or 1
    self.questprogress[quest].Progress = self.questprogress[quest].Progress + progamnt

    if self.questprogress[quest].Progress >= IGCATEGORYQUESTS[quest][self.questprogress[quest].Level].Amount then
        self.questprogress[quest].Level = self.questprogress[quest].Level + 1
        self.questprogress[quest].Progress = 0

        if self.questprogress[quest].Level >= 4 then
            self:SendQuestMessage("questfin", quest, self.questprogress[quest].Level)
            self.questprogress[quest].Completed = true
        else
            self:SendQuestMessage("levelprog", quest, self.questprogress[quest].Level - 1)
        end
    end

    WriteQuestStuff(self)
    NetworkQuestStuff(self)
end

function plymetar:ProgressSkill(line)
    local pointslol = self:GetNWInt("igquestpoints", 0)
    local prog = self:GetNWInt("igprogress" .. string.lower(line), 0) + 1
    self:SetNWInt("igprogress" .. string.lower(line), tonumber(prog))
    sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(self:SteamID64()) .. ", " .. sql.SQLStr(pointslol) .. ", " .. sql.SQLStr(self:GetNWInt("igprogressc", 0)) .. ", " .. sql.SQLStr(self:GetNWInt("igprogressp", 0)) .. ", " .. sql.SQLStr(self:GetNWInt("igprogressu", 0)) .. " )")
end

function plymetar:SendQuestMessage(txt, quest, lvl)
    if txt == "levelprog" and lvl == 1 then
        net.Start("NetworkQuestSound")
        net.Send(self)

        timer.Simple(1, function()
            file.Append("igquestslog/questlog.txt", "\n[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. self:Nick() .. " (" .. self:SteamID() .. ") has progressed the quest: " .. quest .. " from level 1")
            self:ChatPrint("You have completed level " .. lvl .. " of the " .. quest .. " quest and received 1 quest points.")
            IGAddQuestPoints(self, 1)
        end)
    elseif txt == "levelprog" and lvl == 2 then
        net.Start("NetworkQuestSound")
        net.Send(self)

        timer.Simple(1, function()
            file.Append("igquestslog/questlog.txt", "\n[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. self:Nick() .. " (" .. self:SteamID() .. ") has progressed the quest: " .. quest .. " from level 2")
            self:ChatPrint("You have completed level " .. lvl .. " of the " .. quest .. " quest and received 2 quest points.")
            IGAddQuestPoints(self, 2)
        end)
    elseif txt == "questfin" then
        net.Start("NetworkQuestSound")
        net.Send(self)

        timer.Simple(1, function()
            file.Append("igquestslog/questlog.txt", "\n[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. self:Nick() .. " (" .. self:SteamID() .. ") has progressed the quest: " .. quest .. " from level 3")
            self:ChatPrint("You have fully completed the " .. quest .. " quest, and received 3 quest points good job!")
            IGAddQuestPoints(self, 3)
        end)
    end
end

function plymetar:GetQuestLevel(quest)
    return self.questprogress[quest].Level or 0
end

function IGQUEST_PlayerInitSpawn(ply)
    if file.Exists("igquests/" .. ply:SteamID64() .. ".txt", "DATA") then
        local queststuff = file.Read("igquests/" .. ply:SteamID64() .. ".txt", "DATA")
        ply.questprogress = util.JSONToTable(queststuff)
        local playerdata = sql.QueryRow("SELECT * FROM igquestpoints WHERE steamid = " .. sql.SQLStr(ply:SteamID64()) .. " LIMIT 1") or 0
        ply:SetNWInt("igquestpoints", tonumber(playerdata.points))
        ply:SetNWInt("igprogressc", tonumber(playerdata.progressc))
        ply:SetNWInt("igprogressp", tonumber(playerdata.progressp))
        ply:SetNWInt("igprogressu", tonumber(playerdata.progressu))
        NetworkQuestStuff(ply)
    else
        ply.questprogress = {}

        for k, v in pairs(IGCATEGORYQUESTS) do
            ply.questprogress[k] = {}
            ply.questprogress[k].Level = 1
            ply.questprogress[k].Progress = 0
            ply.questprogress[k].Completed = false
        end

        WriteQuestStuff(ply)
        NetworkQuestStuff(ply)
        local nopoints = 0
        sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(ply:SteamID64()) .. ", " .. sql.SQLStr(nopoints) .. ", " .. nopoints .. ", " .. nopoints .. ", " .. nopoints .. " )")
        ply:SetNWInt("igquestpoints", nopoints)
        ply:SetNWInt("igprogressc", nopoints)
        ply:SetNWInt("igprogressp", nopoints)
        ply:SetNWInt("igprogressu", nopoints)
    end
end

function IGQUEST_PlayerDisconnected(ply)
    WriteQuestStuff(ply)
    ply.questprogress = {}
end

hook.Add("PlayerInitialSpawn", "IGQUEST_PlayerInitSpawner", IGQUEST_PlayerInitSpawn)
hook.Add("PlayerDisconnected", "IGQUEST_PlayerDisconnecteder", IGQUEST_PlayerDisconnected)

hook.Add("PlayerButtonDown", "OpenF7Menu", function(ply, key)
    if key == KEY_F7 then
        NetworkQuestStuff(ply)
        net.Start("OpenF7Quest")
        net.Send(ply)
    end
end)

hook.Add("PlayerButtonDown", "OpenF8Menu", function(ply, key)
    if key == KEY_F8 then
        net.Start("OpenSkillQuest")
        net.Send(ply)
    end
end)

hook.Add("IGPlayerSay", "OpenF7Menur", function(ply, text, team)
    if (string.lower(text) == "!quests") then
        NetworkQuestStuff(ply)
        net.Start("OpenF7Quest")
        net.Send(ply)
    end
end)

hook.Add("IGPlayerSay", "OpenF8Menur", function(ply, text, team)
    if (string.lower(text) == "!skills") then
        net.Start("OpenSkillQuest")
        net.Send(ply)
    end
end)

local prestigeprettyprints = {
    [1] = "first",
    [2] = "second",
    [3] = "third",
    [4] = "fourth or more",
    [5] = "fourth or more"
}

net.Receive("RequestPrestiging", function(len, ply)
    local canprestige = true

    for k, v in pairs(ply.questprogress) do
        if v.Completed == false then
            canprestige = false
        end
    end

    if canprestige then
        net.Start("NetworkQuestSound")
        net.Send(ply)
        ply:ChatPrint("Good work, you have prestiged and earned 25000 points, 7500 credits and 20 quest points!")
        IGAddQuestPoints(ply, 20)
        ply:SH_AddStandardPoints(25000, nil, false, false)
        ply:SH_AddPremiumPoints(7500, nil, false, false)
        QUESTPRESTIGES[ply:SteamID()] = QUESTPRESTIGES[ply:SteamID()] or {}

        if not QUESTPRESTIGES[ply:SteamID()]["PrestigeAmount"] then
            QUESTPRESTIGES[ply:SteamID()]["PrestigeAmount"] = 0
        end

        QUESTPRESTIGES[ply:SteamID()]["PrestigeAmount"] = QUESTPRESTIGES[ply:SteamID()]["PrestigeAmount"] + 1 or 1
        QUESTPRESTIGES[ply:SteamID()]["Nick"] = ply:Nick()
        local prestigecount = QUESTPRESTIGES[ply:SteamID()]["PrestigeAmount"]

        if prestigecount >= 4 then
            prestigecount = 4
        end

        RunConsoleCommand("ulx", "tsay", ply:Nick(), "has", "prestiged", "their", "quest", "line", "for", "the", prestigeprettyprints[prestigecount], "time.")
        ply.questprogress = {}

        for k, v in pairs(IGCATEGORYQUESTS) do
            ply.questprogress[k] = {}
            ply.questprogress[k].Level = 1
            ply.questprogress[k].Progress = 0
            ply.questprogress[k].Completed = false
        end

        WriteQuestStuff(ply)
        NetworkQuestStuff(ply)
        file.Write("igquestslog/prestiges.txt", util.TableToJSON(QUESTPRESTIGES))
    else
        ply:EmitSound("buttons/button11.wav")
        ply:ChatPrint("Finish all your quests first before trying to prestige!")
    end
end)

hook.Add("MooseSetPlayerName", "PrestigeNameChange", function(ply, name)
    if QUESTPRESTIGES[ply:SteamID()] then
        QUESTPRESTIGES[ply:SteamID()]["Nick"] = name
        file.Write("igquestslog/prestiges.txt", util.TableToJSON(QUESTPRESTIGES))
    end
end)

hook.Add("PlayerInitialSpawn", "PrestigeNameChangeSpawn", function(ply)
    if QUESTPRESTIGES[ply:SteamID()] then
        QUESTPRESTIGES[ply:SteamID()]["Nick"] = ply:Nick()
        file.Write("igquestslog/prestiges.txt", util.TableToJSON(QUESTPRESTIGES))
    end
end)

net.Receive("RequestSkillProgress", function(len, ply)
    local line = net.ReadString()
    if line ~= "C" and line ~= "P" and line ~= "U" then return end
    local skilltoprogress = ply:GetNWInt("igprogress" .. string.lower(line), 0) + 1

    if line == "C" then
        if not IGCSKILLS[skilltoprogress] then return end
        local skillcost = IGCSKILLS[skilltoprogress].Cost

        if not IGHasQuestPoints(ply, skillcost) then
            ply:ChatPrint("You cannot afford this skill")

            return
        end

        ply:ProgressSkill(line)
        IGRemoveQuestPoints(ply, skillcost)
        ply:ChatPrint("You have progressed the skill " .. IGCSKILLS[skilltoprogress].Name)
    elseif line == "P" then
        if not IGPSKILLS[skilltoprogress] then return end
        local skillcost = IGPSKILLS[skilltoprogress].Cost

        if not IGHasQuestPoints(ply, skillcost) then
            ply:ChatPrint("You cannot afford this skill")

            return
        end

        ply:ProgressSkill(line)
        IGRemoveQuestPoints(ply, skillcost)
        ply:ChatPrint("You have progressed the skill " .. IGPSKILLS[skilltoprogress].Name)
    else
        if not IGUSKILLS[skilltoprogress] then return end
        local skillcost = IGUSKILLS[skilltoprogress].Cost

        if not IGHasQuestPoints(ply, skillcost) then
            ply:ChatPrint("You cannot afford this skill")

            return
        end

        ply:ProgressSkill(line)
        IGRemoveQuestPoints(ply, skillcost)
        ply:ChatPrint("You have progressed the skill " .. IGUSKILLS[skilltoprogress].Name)
    end

    net.Start("NetworkQuestSound")
    net.Send(ply)
end)

net.Receive("openedpointshop", function(len, ply)
    ply:ProgressQuest("Extra", 2)
end)

concommand.Add("testprestiger", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsSuperAdmin() then
        ply:ChatPrint("Your not kumo -_-")

        return
    end

    if not args[1] then
        ply:ChatPrint("No steamid found wtf bro")

        return
    end

    local plyr = player.GetBySteamID64(args[1])
    IGAddQuestPoints(plyr, args[2])
end)

concommand.Add("quests_wipe", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsSuperAdmin() then
        ply:ChatPrint("Your not superadmin -_-")

        return
    end

    if not args[1] then
        ply:ChatPrint("No steamid found wtf bro")

        return
    end

    local plyr = player.GetBySteamID64(args[1])

    if not plyr or not plyr:IsPlayer() then
        ply:ChatPrint("No player found for steamid: " .. args[1] .. " if they are offline use quests_wipe2")

        return
    end

    plyr.questprogress = {}

    for k, v in pairs(IGCATEGORYQUESTS) do
        plyr.questprogress[k] = {}
        plyr.questprogress[k].Level = 1
        plyr.questprogress[k].Progress = 0
        plyr.questprogress[k].Completed = false
    end

    if QUESTPRESTIGES[args[1]] then
        QUESTPRESTIGES[args[1]] = nil
        file.Write("igquestslog/prestiges.txt", util.TableToJSON(QUESTPRESTIGES))
    end

    WriteQuestStuff(plyr)
    NetworkQuestStuff(plyr)
    local nopoints = 0
    sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(plyr:SteamID64()) .. ", " .. sql.SQLStr(nopoints) .. ", " .. nopoints .. ", " .. nopoints .. ", " .. nopoints .. " )")
    plyr:SetNWInt("igquestpoints", nopoints)
    plyr:SetNWInt("igprogressc", nopoints)
    plyr:SetNWInt("igprogressp", nopoints)
    plyr:SetNWInt("igprogressu", nopoints)
    plyr:ChatPrint("Your quest progress and points have been wiped, think before you act next time.")
    ply:ChatPrint(plyr:Nick() .. " quests progress have been successfully wiped.")
end)

concommand.Add("quests_wipe2", function(ply, cmd, args)
    if not ply:IsValid() or not ply:IsSuperAdmin() then
        ply:ChatPrint("Your not superadmin -_-")

        return
    end

    if not args[1] then
        ply:ChatPrint("No steamid found wtf bro")

        return
    end

    local plyr = player.GetBySteamID64(args[1])

    if plyr and plyr:IsPlayer() then
        ply:ChatPrint("A player is found, use quest_wipe instead")

        return
    end

    local queststuff = util.JSONToTable(file.Read("igquests/" .. args[1] .. ".txt", "DATA"))

    if not queststuff then
        ply:ChatPrint("Player not found")

        return
    end

    for k, v in pairs(IGCATEGORYQUESTS) do
        queststuff[k] = {}
        queststuff[k].Level = 1
        queststuff[k].Progress = 0
        queststuff[k].Completed = false
    end

    local queststuff2 = util.TableToJSON(queststuff, false)
    file.Write("igquests/" .. args[1] .. ".txt", queststuff2)

    if QUESTPRESTIGES[args[1]] then
        QUESTPRESTIGES[args[1]] = nil
        file.Write("igquestslog/prestiges.txt", util.TableToJSON(QUESTPRESTIGES))
    end

    local nopoints = 0
    sql.Query("REPLACE INTO igquestpoints ( steamid, points, progressc, progressp, progressu ) VALUES ( " .. sql.SQLStr(args[1]) .. ", " .. sql.SQLStr(nopoints) .. ", " .. nopoints .. ", " .. nopoints .. ", " .. nopoints .. " )")
    ply:ChatPrint(args[1] .. " quests progress have been successfully wiped.")
end)

concommand.Add("questfolderclean", function(ply)
    if ply:IsPlayer() then
        print("fuck off")

        return
    end

    local files, directories = file.Find("igquests/*", "DATA")

    for k, v in pairs(files) do
        local questprogress = util.JSONToTable(file.Read("igquests/" .. v, "DATA"))
        local shouldclear = true

        for k, v in pairs(questprogress) do
            if v.Completed or v.Progress ~= 0 or v.Level ~= 1 then
                shouldclear = false
            end
        end

        if shouldclear then
            print("[IG-QUESTS] Deleting File " .. "igquests/" .. v)
            file.Delete("igquests/" .. v)
        end
    end
end)

hook.Add("IGPlayerSay", "PrestigeListHeHe", function(ply, text, team)
    if (string.lower(text) == "!prestiges") then
        if table.Empty(QUESTPRESTIGES) then
            ply:ChatPrint("No one has prestiged yet")
        else
            ply:ChatPrint("Here is a list of people that have prestiged:")

            for k, v in pairs(QUESTPRESTIGES) do
                ply:ChatPrint(v["Nick"] .. " - " .. v["PrestigeAmount"])
            end
        end
    end
end)

local function networkvoicequick(ply, dist)
    net.Start("NetworkVoiceChange")
    net.WriteString(tostring(dist))
    net.Send(ply)
end

hook.Add("IGPlayerSay", "VoiceVolumeChange", function(ply, text, team)
    if (string.lower(text) == "!voice") then
        if not ply.voicelevel then
            ply.voicelevel = "normal"
        end

        if ply.voicelevel == "normal" then
            ply.voicelevel = "yelling"
            ply:ChatPrint("You are now yelling!")
        elseif ply.voicelevel == "yelling" then
            ply.voicelevel = "whisper"
            ply:ChatPrint("You are now whispering!")
        elseif ply.voicelevel == "whisper" then
            ply.voicelevel = "normal"
            ply:ChatPrint("You are now speaking normally!")
        end

        if ply.voicelevel == "normal" then
            networkvoicequick(ply, 300000)
        elseif ply.voicelevel == "yelling" then
            networkvoicequick(ply, 300000 * 1.3)
        elseif ply.voicelevel == "whisper" then
            networkvoicequick(ply, 300000 * 0.1)
        end
    end
end)

hook.Add("PlayerButtonDown", "VoiceVolumeChange", function(ply, key)
    if key == KEY_EQUAL then
        if not ply.voicelevel then
            ply.voicelevel = "normal"
        end

        if ply.voicelevel == "normal" then
            ply.voicelevel = "yelling"
            ply:ChatPrint("You are now yelling!")
        elseif ply.voicelevel == "yelling" then
            ply.voicelevel = "whisper"
            ply:ChatPrint("You are now whispering!")
        elseif ply.voicelevel == "whisper" then
            ply.voicelevel = "normal"
            ply:ChatPrint("You are now speaking normally!")
        end

        if ply.voicelevel == "normal" then
            networkvoicequick(ply, 300000)
        elseif ply.voicelevel == "yelling" then
            networkvoicequick(ply, 300000 * 1.3)
        elseif ply.voicelevel == "whisper" then
            networkvoicequick(ply, 300000 * 0.1)
        end
    end
end)

local QuestConvertRate = 250 -- How many credits you get for a quest point

local function ConvertQuestPoints(ply, amnt)
  if IGHasQuestPoints(ply, amnt) then
    IGRemoveQuestPoints(ply, amnt)
    ply:SH_AddPremiumPoints(amnt * QuestConvertRate, "you have converted " .. amnt .. " quest points into " .. amnt * QuestConvertRate .. " points", false, false)
  else
    ply:PrintMessage(HUD_PRINTTALK, "You have not inputted a positive whole number or you do not have enough quest points")
    end
  end

  hook.Add("IGPlayerSay", "QuestConvert", function(ply, txt)
    string.lower(txt)
    local StringTable = string.Explode(" ", txt)

    if StringTable[1] == "!qpointconvert" then
      if not StringTable[2] then
        StringTable[2] = "help"
      end
      
      if StringTable[2] == "help" then
        ply:PrintMessage(HUD_PRINTTALK, "type '!qpointconvert #' to convert # quest points to points at a ratio of 1:" .. QuestConvertRate)
      else
        tonumber(StringTable[2])
      end
      if isnumber(StringTable[2]) and StringTable[2] > 0 then
        ConvertQuestPoints(ply, StringTable[2])
      end
    end
  end)