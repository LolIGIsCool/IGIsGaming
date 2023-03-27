QUEST.Name = "Patrol"
QUEST.Instruction = "Patrol the ship for a small reward." -- %s will equal the amount
QUEST.Info = "Find the blue sphere, this will mark the start of your patrol point, then follow the rest of the spheres."
QUEST.Reward = 400 -- credit reward
QUEST.Time = 240 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 25 -- how many actions required to complete quest
QUEST.Penalty = 40 -- penalty reward

local pos = Vector(-2392, -830.57, -6015.97)
local pos2 = Vector(-2814.81, -935.64, -6015.97)
local pos3 = Vector(-2687.73, -1759.38, -6015.97)
local pos4 = Vector(-1799.64, -1752.2, -6015.97)
local pos5 = Vector(-633.24, -1746.32, -5727.97)
local pos6 = Vector(567.38, -1731.93, -5567.97)
local pos7 = Vector(-379.82, -1749.88, -5567.97)
local pos8 = Vector(1039.5, -1792.63, -5567.97)
local pos9 = Vector(3124.96, -1798.72, -5567.97)
local pos10 = Vector(4121.56, -1659.35, -5567.97)
local pos11 = Vector(3937.28, -1133.22, -5567.97)
local pos12 = Vector(3970.9, -825.82, -5375.97)
local pos13 = Vector(5547.06, -961.94, -5375.97)
local pos14 = Vector(5947.21, -1448.38, -5375.97)
local pos15 = Vector(5366.62, -1300.32, -5375.97)
local pos16 = Vector(5547.06, -961.94, -5375.97)
local pos17 = Vector(3970.9, -825.82, -5375.97)
local pos18 = Vector(3937.28, -1133.22, -5567.97)
local pos19 = Vector(4121.56, -1659.35, -5567.97)
local pos20 = Vector(3124.96, -1798.72, -5567.97)
local pos21 = Vector(1039.5, -1792.63, -5567.97)
local pos22 = Vector(-379.82, -1749.88, -5567.97)
local pos23 = Vector(567.38, -1731.93, -5567.97)
local pos24 = Vector(-633.24, -1746.32, -5727.97)
local pos25 = Vector(-1799.64, -1752.2, -6015.97)
local postions = {pos, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11, pos12, pos13, pos14, pos15, pos16, pos17, pos18, pos19, pos20, pos21, pos22, pos23, pos24, pos25}

-- called when a player accepts the quest
function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    player:SetNWInt("patrolposition", 1)

    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    player:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    player:QUEST_SYSTEM_ChatNotify("Mission", "You have begun your mission, best of luck. Type !abort to abort and !missioninfo for more information.")

    if SERVER then
        timer.Create("ispatrolquest" .. player:SteamID64(), 1, 0, function()
            local postion = player:GetNWInt("patrolposition", 1)

            for k, v in pairs(ents.FindInSphere(postions[postion], 150)) do
                if (v == player and v.QUEST_SYSTEM_ActiveQuest == "trooper_patrol") then
                    v:QUEST_SYSTEM_Quest_UpdateProgress(v.QUEST_SYSTEM_QuestProgress + 1)

                    if (postion == 25) then
                        v:SetNWInt("patrolpostion", 1)
                    else
                        v:SetNWInt("patrolposition", postion + 1)
                    end

                    if (v.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[v.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                        v:QUEST_SYSTEM_Quest_Finish()
                    end
                end
            end
        end)
    end

    if (QUEST_SYSTEM.Quests[strQuest_ID]["Time"] > 0) then
        timer.Create(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64(), QUEST_SYSTEM.Quests[strQuest_ID]["Time"], 1, function()
            if (IsValid(player)) then
                player:QUEST_SYSTEM_Quest_Abort()
            end
        end)
    end
end

-- called when a player finishes the quest
function QUEST:OnFinished(player)
    if (player.QUEST_SYSTEM_QuestProgress < QUEST_SYSTEM.Quests[player.QUEST_SYSTEM_ActiveQuest]["Amount"]) then return end

    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    if (timer.Exists("ispatrolquest" .. player:SteamID64())) then
        timer.Remove("ispatrolquest" .. player:SteamID64())
    end
    player:SetNWInt("patrolposition", 1)

    -- REWARD FUNCTION GOES HERE ^^^^
    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
    player:QUEST_SYSTEM_ChatNotify("Missions", "You have completed the mission, enjoy your reward.")
end

-- called when a player aborts(or time runs out) the quest
function QUEST:OnAborted(player)
    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    if (timer.Exists("ispatrolquest" .. player:SteamID64())) then
        timer.Remove("ispatrolquest" .. player:SteamID64())
    end
    player:SetNWInt("patrolposition", 1)

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:QUEST_SYSTEM_ChatNotify("Missions", "Mission Aborted, better luck next time.")
end

if (CLIENT) then
    local pos = Vector(-2392, -830.57, -6015.97)
    local pos2 = Vector(-2814.81, -935.64, -6015.97)
    local pos3 = Vector(-2687.73, -1759.38, -6015.97)
    local pos4 = Vector(-1799.64, -1752.2, -6015.97)
    local pos5 = Vector(-633.24, -1746.32, -5727.97)
    local pos6 = Vector(567.38, -1731.93, -5567.97)
    local pos7 = Vector(-379.82, -1749.88, -5567.97)
    local pos8 = Vector(1039.5, -1792.63, -5567.97)
    local pos9 = Vector(3124.96, -1798.72, -5567.97)
    local pos10 = Vector(4121.56, -1659.35, -5567.97)
    local pos11 = Vector(3937.28, -1133.22, -5567.97)
    local pos12 = Vector(3970.9, -825.82, -5375.97)
    local pos13 = Vector(5547.06, -961.94, -5375.97)
    local pos14 = Vector(5947.21, -1448.38, -5375.97)
    local pos15 = Vector(5366.62, -1300.32, -5375.97)
    local pos16 = Vector(5547.06, -961.94, -5375.97)
    local pos17 = Vector(3970.9, -825.82, -5375.97)
    local pos18 = Vector(3937.28, -1133.22, -5567.97)
    local pos19 = Vector(4121.56, -1659.35, -5567.97)
    local pos20 = Vector(3124.96, -1798.72, -5567.97)
    local pos21 = Vector(1039.5, -1792.63, -5567.97)
    local pos22 = Vector(-379.82, -1749.88, -5567.97)
    local pos23 = Vector(567.38, -1731.93, -5567.97)
    local pos24 = Vector(-633.24, -1746.32, -5727.97)
    local pos25 = Vector(-1799.64, -1752.2, -6015.97)
    local postions = {pos, pos2, pos3, pos4, pos5, pos6, pos7, pos8, pos9, pos10, pos11, pos12, pos13, pos14, pos15, pos16, pos17, pos18, pos19, pos20, pos21, pos22, pos23, pos24, pos25}

    hook.Add("PostDrawTranslucentRenderables", "DrawSpherePartol", function(bDepth, bSkybox)
        if (bSkybox) then return end
        if not (LocalPlayer().QUEST_SYSTEM_ActiveQuest == "trooper_patrol") then return end
        local playerposition = LocalPlayer():GetNWInt("patrolposition")
        render.SetColorMaterial()
        render.DrawSphere(postions[playerposition], 150, 30, 30, Color(0, 144, 238, 100))
    end)
end
