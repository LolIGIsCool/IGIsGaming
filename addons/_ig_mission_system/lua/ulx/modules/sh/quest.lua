function ulx.abortmission( calling_ply, target_ply )
	if (target_ply.QUEST_SYSTEM_ActiveQuest) then
		target_ply:QUEST_SYSTEM_Quest_Abort()
		ulx.fancyLogAdmin( calling_ply, "#A aborted #T's mission", target_ply)
	else
		ulx.fancyLogAdmin( calling_ply, "#T does not have an active mission", target_ply )
	end
end

local abortmission = ulx.command( "Imperial Gaming", "ulx abortmission", ulx.abortmission, "!abortmission" )
abortmission:addParam{ type = ULib.cmds.PlayerArg }
abortmission:defaultAccess( ULib.ACCESS_ADMIN )
abortmission:help( "Aborts the players mission" )

function ulx.finishmission( calling_ply, target_ply )
	if (target_ply.QUEST_SYSTEM_ActiveQuest) then
		local amount = QUEST_SYSTEM.Quests[target_ply.QUEST_SYSTEM_ActiveQuest]["Amount"]
		target_ply:QUEST_SYSTEM_Quest_UpdateProgress(amount)
		target_ply:QUEST_SYSTEM_Quest_Finish()
		ulx.fancyLogAdmin( calling_ply, "#A finished #T's mission", target_ply)
	else
		ulx.fancyLogAdmin( calling_ply, "#T does not have an active mission", target_ply )
	end
end

local finishmission = ulx.command( "Imperial Gaming", "ulx finishmission", ulx.finishmission, "!finishmission" )
finishmission:addParam{ type = ULib.cmds.PlayerArg }
finishmission:defaultAccess( ULib.ACCESS_ADMIN )
finishmission:help( "Finishes the players mission" )

ulx_mission_table = {}

function ulx.givemission( calling_ply, target_ply, missionname )
	if not (target_ply.QUEST_SYSTEM_ActiveQuest) then
		QUEST_SYSTEM.Quests[missionname]:OnStarted(target_ply, missionname, false)
		ulx.fancyLogAdmin( calling_ply, "#A has given mission #s to #T", missionname, target_ply)
	else
		ulx.fancyLogAdmin( calling_ply, "#T already has an active mission", target_ply )
	end
end

local givemission = ulx.command( "Imperial Gaming", "ulx givemission", ulx.givemission, "!givemission" )
givemission:addParam{ type = ULib.cmds.PlayerArg }
givemission:addParam{ type = ULib.cmds.StringArg, hint = "Quest ID", completes = ulx_mission_table, ULib.cmds.restrictToCompletes }
givemission:defaultAccess( ULib.ACCESS_ADMIN )
givemission:help( "Finishes the players mission" )

