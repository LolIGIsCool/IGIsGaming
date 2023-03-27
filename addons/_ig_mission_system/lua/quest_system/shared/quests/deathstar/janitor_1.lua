QUEST.Name = "Janitorial Duties"
QUEST.Instruction = "Clean up the mess around the ship" -- %s will equal the amount
QUEST.Info = ""
QUEST.Reward = 250 -- credit reward
QUEST.Time = 480 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 3 -- how many actions required to complete quest
QUEST.Penalty = 250 -- penalty reward
QUEST.Item = {
	["Name"] = "Garbage", -- name of the item
	["Model"] = "models/props_junk/garbage128_composite001a.mdl", -- model of the item
	["Respawn"] = 10 -- ask kumo about this.
}

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