QUEST.Name = "Show some Respect"
QUEST.Instruction = "Salute your higher ups, they have earned it." -- %s will equal the amount
QUEST.Info = "Use your salute bind to salute a higher up (must be looking at them)"
QUEST.Reward = 200 -- credit reward
QUEST.Time = 120 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 3 -- how many actions required to complete quest
QUEST.Penalty = 20 -- penalty reward

function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
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
    player:QUEST_SYSTEM_ChatNotify("Quest", "Quest Complete, enjoy your reward.")
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
    player:QUEST_SYSTEM_ChatNotify("Quest", "Quest Aborted. Better luck next time!")
end

if (SERVER) then
    hook.Add("PlayerStartTaunt", "salutehigherup", function(ply, act)
        if not (ply:IsPlayer() and ply.QUEST_SYSTEM_ActiveQuest == "trooper_salute" and act == 1614) then return end
        local player123 = ply:GetEyeTrace().Entity

        if (player123 and player123:IsPlayer() and player123:IsValid() and player123:GetJobTable().Clearance == "3" or player123:GetJobTable().Clearance == "4" or player123:GetJobTable().Clearance == "5" or player123:GetJobTable().Clearance == "6" or player123:GetJobTable().Clearance == "ALL ACCESS" and not ply.salutelist[player123:SteamID()]) then
            --player123:GetRank() >= 10
            ply:QUEST_SYSTEM_Quest_UpdateProgress(ply.QUEST_SYSTEM_QuestProgress + 1)
            ply.salutelist = ply.salutelist or {}
            ply.salutelist[player123:SteamID()] = true

            if (ply.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[ply.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                ply:QUEST_SYSTEM_Quest_Finish()

                ply.salutelist = nil
            end
    elseif (player123 and player123:IsPlayer() and player123:GetJobTable().Clearance == "2" or player123:GetJobTable().Clearance == "1" or player123:GetJobTable().Clearance == "0" or player123:GetJobTable().Clearance == "AREA ACCESS" or player123:GetJobTable().Clearance == "CLASSIFIED" or player123:GetJobTable().Clearance == "Imperial Citizen" ) then
        --player123:GetRank() <= 9
            ply:QUEST_SYSTEM_ChatNotify("Quest", "That is not a CL3+")
        elseif (player123 and player123:IsPlayer() and ply.salutelist[player123:SteamID()]) then
            ply:QUEST_SYSTEM_ChatNotify("Quest", "You already saluted this CL3+!")
        else
            ply:QUEST_SYSTEM_ChatNotify("Quest", "That is not a CL3+!")
        end
    end)
end
