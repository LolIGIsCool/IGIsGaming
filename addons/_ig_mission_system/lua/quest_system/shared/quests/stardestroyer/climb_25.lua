QUEST.Name = "Very High Climber"
QUEST.Instruction = "Practice your skills with Climb Swep by climbing 25 times." -- %s will equal the amount
QUEST.Info = "If you dont know how to climbswep ask your commanding officer to teach you."
QUEST.Reward = 300 -- credit reward
QUEST.Time = 180 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 25 -- how many actions required to complete quest
QUEST.Penalty = 30 -- penalty reward

-- called when a player accepts the quest
function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    timer.Create("isonground" .. player:SteamID(), 0.5, 0, function()
        if (player:IsOnGround() or player:GetNWBool("ClimbFalling")) then
            player:QUEST_SYSTEM_Quest_UpdateProgress(0)
        end
    end)

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

    if (timer.Exists("isonground" .. player:SteamID())) then
        timer.Remove("isonground" .. player:SteamID())
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

    if (timer.Exists("isonground" .. player:SteamID())) then
        timer.Remove("isonground" .. player:SteamID())
    end

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:QUEST_SYSTEM_ChatNotify("Missions", "Mission Aborted, better luck next time.")
end

if (SERVER) then
    hook.Add("playerclimbjump", "registerjumpquest25", function(player, jumps)
        if (player:IsPlayer() and player.QUEST_SYSTEM_ActiveQuest == "climb_25") and jumps ~= 0 then
            player:QUEST_SYSTEM_Quest_UpdateProgress(player.QUEST_SYSTEM_QuestProgress + 1)

            if (player.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[player.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                player:QUEST_SYSTEM_Quest_Finish()
            end
        end
    end)
end
