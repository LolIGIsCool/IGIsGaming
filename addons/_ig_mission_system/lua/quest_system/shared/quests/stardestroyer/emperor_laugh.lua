QUEST.Name = "Don't mess with the Emperor"
QUEST.Instruction = "Laugh at the Emperor or Vader, I'll give you some credits if you can make it back here before he cuts you down" -- %s will equal the amount
QUEST.Info = "Although this is dumb, laugh at the emperor or vader and make it back in time without dying."
QUEST.Reward = 1000 -- credit reward
QUEST.Time = 600 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 1 -- how many actions required to complete quest
QUEST.Penalty = 0 -- penalty reward

function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    player:SetNWVector("questvendorpos", player:GetPos())
    player:SetNWBool("emperorquestlaughed", false)


    if (SERVER) then
        hook.Add("PlayerDeath", "DeadOnEmperorQuest", function(victim, inflictor, attacker)
            if (victim:IsPlayer() and victim.QUEST_SYSTEM_ActiveQuest == "emperor_laugh") then
                player:QUEST_SYSTEM_Quest_Abort()
            end
        end)
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
    player:QUEST_SYSTEM_ChatNotify("Quest", "That was a close one, I suggest hiding out for a few days.")
    hook.Remove("PlayerDeath", "DeadOnEmperorQuest")
    player:SetNWBool("emperorquestlaughed", false)

    if (timer.Exists("isbackatvendor" .. player:SteamID())) then
        timer.Remove("isbackatvendor" .. player:SteamID())
    end
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
    player:QUEST_SYSTEM_ChatNotify("Quest", "I warned you it would be dangerous!")
    hook.Remove("PlayerDeath", "DeadOnEmperorQuest")
    player:SetNWBool("emperorquestlaughed", false)

    if (timer.Exists("isbackatvendor" .. player:SteamID())) then
        timer.Remove("isbackatvendor" .. player:SteamID())
    end
end


if (SERVER) then
    hook.Add("PlayerStartTaunt", "laughatemperor", function(ply, act)
        if not (ply:IsPlayer() and ply.QUEST_SYSTEM_ActiveQuest == "emperor_laugh" and act == 1618) then return end
        local player123 = ply:GetEyeTrace().Entity

        if (player123) and (player123:IsPlayer()) and (player123:IsValid()) and player123:GetRankName() == "Galactic Emperor" or player123:GetJobTable().RealName == "Darth Vader" then
            ply:SetNWBool("emperorquestlaughed", true)
            ply:QUEST_SYSTEM_ChatNotify("Quest", "I would start running if I was you.")
            player123:QUEST_SYSTEM_ChatNotify("Military AI", ply:Nick() .. " just laughed at you, cut him down as you will my lord!")

            timer.Create("isbackatvendor" .. ply:SteamID(), 1, 0, function()
                for k, v in pairs(ents.FindInSphere(Vector(ply:GetNWVector("questvendorpos")), 300)) do
                    if (v:IsPlayer() and v:GetNWBool("emperorquestlaughed", false)) then
                        v:QUEST_SYSTEM_Quest_UpdateProgress(v.QUEST_SYSTEM_QuestProgress + 1)

                        if (v.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[v.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                            v:QUEST_SYSTEM_Quest_Finish()
                        end
                    end
                end
            end)
        elseif not (player123) and (player123:IsPlayer()) and (player123:IsValid()) and player123:GetRankName() == "Galactic Emperor" or player123:GetJobTable().RealName == "Darth Vader" then
            ply:QUEST_SYSTEM_ChatNotify("Quest", "That is not the emperor or vader!")
        end
    end)
end
