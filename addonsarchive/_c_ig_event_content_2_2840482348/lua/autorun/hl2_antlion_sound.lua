CreateConVar( "player_antlion_sounds", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY } ) 
CreateConVar( "player_antlion_footsteps", "1", { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY } ) 

sound.AddSoundOverrides( "lua/antlion4_sounds.lua" )

antlion4_sound = "models/hl2_antlion_pm.mdl"

hook.Add("PlayerDeathSound","antlion4_PlayerDeathSound",function(ply,velocity)
	if GetConVarNumber( "player_antlion_sounds" ) == 1 then
	if(ply:GetModel() == antlion4_sound)then
		ply:EmitSound("playermodel_antlion4.die")
		return true
	end
	end
end)

hook.Add("PlayerHurt","antlion4_PlayerHurt",function(ply,velocity)
	if GetConVarNumber( "player_antlion_sounds" ) == 1 then	
	if(ply:GetModel() == antlion4_sound)then
		ply:EmitSound("playermodel_antlion4.pain")
		return true
	end
	end
end)

hook.Add("PlayerFootstep","antlion4_PlayerFootstep",function(ply,velocity)
	if GetConVarNumber( "player_antlion_footsteps" ) == 1 then
if(ply:GetModel () == antlion4_sound)then
ply:EmitSound("playermodel_antlion4.footsteps")
return true
end
end
end)

antlion3_sound = "models/antlion_worker_pm.mdl"

hook.Add("PlayerDeathSound","antlion3_PlayerDeathSound",function(ply,velocity)
	if GetConVarNumber( "player_antlion_sounds" ) == 1 then
	if(ply:GetModel() == antlion3_sound)then
		ply:EmitSound("playermodel_antlion3.die")
		return true
	end
	end
end)

hook.Add("PlayerHurt","antlion3_PlayerHurt",function(ply,velocity)
	if GetConVarNumber( "player_antlion_sounds" ) == 1 then	
	if(ply:GetModel() == antlion3_sound)then
		ply:EmitSound("playermodel_antlion3.pain")
		return true
	end
	end
end)

hook.Add("PlayerFootstep","antlion3_PlayerFootstep",function(ply,velocity)
	if GetConVarNumber( "player_antlion_footsteps" ) == 1 then
if(ply:GetModel () == antlion3_sound)then
ply:EmitSound("playermodel_antlion3.footsteps")
return true
end
end
end)