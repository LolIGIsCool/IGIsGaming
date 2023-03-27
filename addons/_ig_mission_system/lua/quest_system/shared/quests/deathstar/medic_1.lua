QUEST.Name = "Medical Saviour"
QUEST.Instruction = "Use a defibrilator and save someone from death." -- %s will equal the amount
QUEST.Info = ""
QUEST.Reward = 250 -- credit reward
QUEST.Time = 600 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 1 -- how many actions required to complete quest
QUEST.Penalty = 250 -- penalty reward

function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    if (acceptedOnline) then
    QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
    net.Start("QUEST_SYSTEM_Quest_Remove")
    net.WriteString(strQuest_ID)
    net.Broadcast()
        end
	player:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
	player:QUEST_SYSTEM_Quest_UpdateProgress(0)
	player:QUEST_SYSTEM_ChatNotify("Quest", "You have begun your quest, best of luck. Type !abort to abort and !questinfo for more information.")
	if (QUEST_SYSTEM.Quests[strQuest_ID]["Time"] > 0) then
		timer.Create(player.QUEST_SYSTEM_ActiveQuest.."_"..player:SteamID64(), QUEST_SYSTEM.Quests[strQuest_ID]["Time"], 1, function()
			if (IsValid(player)) then
				player:QUEST_SYSTEM_Quest_Abort()
			end
		end)
	end
end


function QUEST:OnFinished(player) -- called when a player finishes the quest
	if (player.QUEST_SYSTEM_QuestProgress < QUEST_SYSTEM.Quests[player.QUEST_SYSTEM_ActiveQuest]["Amount"]) then return end
	if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest.."_"..player:SteamID64())) then
		timer.Remove(player.QUEST_SYSTEM_ActiveQuest.."_"..player:SteamID64())
	end
	
	-- REWARD FUNCTION GOES HERE ^^^^
	player.QUEST_SYSTEM_ActiveQuest = nil
	player:QUEST_SYSTEM_Quest_UpdateProgress(0)
	net.Start("QUEST_SYSTEM_Quest_Finish")
	net.Send(player)
	player:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
	player:QUEST_SYSTEM_ChatNotify("Quest", "You have completed the quest, enjoy your reward.")
end

function QUEST:OnAborted(player) -- called when a player aborts(or time runs out) the quest
	if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest.."_"..player:SteamID64())) then
		timer.Remove(player.QUEST_SYSTEM_ActiveQuest.."_"..player:SteamID64())
	end
	player.QUEST_SYSTEM_ActiveQuest = nil
	player:QUEST_SYSTEM_Quest_UpdateProgress(0)
	net.Start("QUEST_SYSTEM_Quest_Finish")
	net.Send(player)
	player:QUEST_SYSTEM_ChatNotify("Quest", "Quest Aborted, better luck next time.")
end

if (SERVER) then
	hook.Add("customhq.defib.onPlayerInteraction", "QUEST_Medic", function(ply, otherPlayer, isRevive)
		if isRevive and ply:IsPlayer() then
			ply:QUEST_SYSTEM_Quest_UpdateProgress(ply.QUEST_SYSTEM_QuestProgress + 1)
			ply:QUEST_SYSTEM_ChatNotify("Quest", "You revived someone and completed your quest, good job.")
			ply:QUEST_SYSTEM_Quest_Finish()
		end
	end)
end