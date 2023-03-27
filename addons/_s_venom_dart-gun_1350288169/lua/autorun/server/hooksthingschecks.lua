hook.Add( "PlayerDeath", "RemovePoisonOnDeath", function(victim)
     if (timer.Exists( "PoisonTimer_" .. victim:SteamID())) then
	     timer.Remove( "PoisonTimer_" .. victim:SteamID())
		 end
end)

hook.Add( "OnPlayerChangedTeam", "RemovePoisonOnJobChange", function(ply)
     if (timer.Exists( "PoisonTimer_" .. ply:SteamID())) then
	     timer.Remove( "PoisonTimer_" .. ply:SteamID())
		 end
end)

hook.Add( "OnNPCKilled", "RemovePoisonFromNPC", function(npc)
if (timer.Exists("NPCPoisonTimer")) then
	     timer.Remove("NPCPoisonTimer")
		 end
end)

hook.Add( "EntityRemoved", "RemovePoisonFromNPCWhenUndo", function(ent)
if (timer.Exists("NPCPoisonTimer")) then
	     timer.Remove("NPCPoisonTimer")
		 end
end)     