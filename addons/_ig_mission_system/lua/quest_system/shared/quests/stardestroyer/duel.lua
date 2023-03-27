QUEST.Name = "Duel of the Fates"
QUEST.Instruction = "Win a duel against another Sith as training." -- %s will equal the amount
QUEST.Info = "Mutually agree to duel a sith, win the duel and you will get a reward"
QUEST.Reward = 600 -- credit reward
QUEST.Time = 600 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 1 -- how many actions required to complete quest
QUEST.Penalty = 60 -- penalty reward

-- called when a player accepts the quest
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
    hook.Add("DoPlayerDeath", "sithduelquest", function(victim, attacker)
        local victimweapon = "noweapon"
        local attackerweapon = "noweapon"

        if (attacker) and (attacker:IsPlayer()) and (attacker:GetActiveWeapon():IsValid()) then
            attackerweapon = attacker:GetActiveWeapon():GetClass()
        end

        if (victim) and (victim:IsPlayer()) and (victim:GetActiveWeapon():IsValid()) then
            victimweapon = victim:GetActiveWeapon():GetClass()
        end

        if (attacker:IsPlayer() and attacker.QUEST_SYSTEM_ActiveQuest == "duel" and attackerweapon == "weapon_lightsaber" and victimweapon == "weapon_lightsaber") then
            attacker:QUEST_SYSTEM_Quest_UpdateProgress(attacker.QUEST_SYSTEM_QuestProgress + 1)

            if (attacker.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[attacker.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                attacker:QUEST_SYSTEM_Quest_Finish()
            end
        elseif (victim:IsPlayer() and victim.QUEST_SYSTEM_ActiveQuest == "duel" and attackerweapon == "weapon_lightsaber" and victimweapon == "weapon_lightsaber") then
            attacker:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
            attacker:QUEST_SYSTEM_ChatNotify("Quest", "You have won the duel, enjoy your reward.")
            attacker:SH_AddPremiumPoints(QUEST_SYSTEM.Quests[victim.QUEST_SYSTEM_ActiveQuest]["Penalty"], nil, false, false)
            victim:QUEST_SYSTEM_Quest_Abort()
            victim:QUEST_SYSTEM_ChatNotify("Quest", "You have lost the duel, you are a disgrace.")
        end
    end)
end
