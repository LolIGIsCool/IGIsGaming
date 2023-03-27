QUEST.Name = "Stardestroyer Patrol"
QUEST.Instruction = "Patrol the stardestroyer and do 16 laps." -- %s will equal the amount
QUEST.Info = "Take a dropship and complete 16 laps around the stardestroyer, following the blue spheres."
QUEST.Reward = 800 -- credit reward
QUEST.Time = 600 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 16 -- how many actions required to complete quest
QUEST.Penalty = 80 -- penalty reward

-- called when a player accepts the quest
function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    player:SetNWInt("sendpostionpilotquest", 1)

    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    player:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    player:QUEST_SYSTEM_ChatNotify("Mission", "You have begun your mission, best of luck. Type !abort to abort and !missioninfo for more information.")

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

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:QUEST_SYSTEM_ChatNotify("Missions", "Mission Aborted, better luck next time.")
end


if (SERVER) then
    local pos = Vector(13499.54, 166.67, -2152.64)
    local pos2 = Vector(3691.54, -8674.72, -1980.29)
    local pos3 = Vector(-14633.38, -818.1, -565.72)
    local pos4 = Vector(-558.6, 7433, -1866.36)
    local postions = {pos, pos2, pos3, pos4}
    local postion = 1
    timer.Create("ispilotflying", 0.75, 0, function()
        for k, v in pairs(ents.FindInSphere(postions[postion], 1000)) do
            if (v.IsSWVehicle) then
                ply = v.Pilot

                if (ply:IsPlayer() and ply.QUEST_SYSTEM_ActiveQuest == "pilot_flying") then
                    ply:QUEST_SYSTEM_Quest_UpdateProgress(ply.QUEST_SYSTEM_QuestProgress + 1)

                    if (postion == 4) then
                        postion = 1
                        ply:SetNWInt("sendpostionpilotquest", postion)
                    else
                        postion = postion + 1
                        ply:SetNWInt("sendpostionpilotquest", postion)
                    end

                    if (ply.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[ply.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                        ply:QUEST_SYSTEM_Quest_Finish()
                    end
                end
            end
        end
    end)
end

if (CLIENT) then
    local pos = Vector(13499.54, 166.67, -2152.64)
    local pos2 = Vector(3691.54, -8674.72, -1980.29)
    local pos3 = Vector(-14633.38, -818.1, -565.72)
    local pos4 = Vector(-558.6, 7433, -1866.36)
    local postions = {pos, pos2, pos3, pos4}
    local postion = 1
    hook.Add("PostDrawTranslucentRenderables", "drawthingpilot", function(bDepth, bSkybox)
        if (bSkybox) then return end
        if not (LocalPlayer().QUEST_SYSTEM_ActiveQuest == "pilot_flying") then return end
        render.SetColorMaterial()
        render.DrawSphere(postions[LocalPlayer():GetNWInt("sendpostionpilotquest")], 500, 30, 30, Color(0, 144, 238, 144))
    end)
end
