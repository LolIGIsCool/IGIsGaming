CreateConVar( "player_antlion_viewheight", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE } )

hook.Add("PlayerSpawn",  "player_antlion_hl2_Viewheight_Offset", function(ply)
	if not ply or not ply:IsValid() then return end
	e = ents.Create("gmod_hands")
	e:SetOwner(ply)
	e:Spawn()
	e:SetOwner(ply)
	ply:SetHands( e )
	if (ply:GetModel() == "models/hl2_antlion_pm.mdl") then
	timer.Simple(0.1, function()
	if GetConVarNumber( "player_antlion_viewheight" ) == 1 then
	ply:SetViewOffset( Vector(0,0,27) )
	ply:SetViewOffsetDucked( Vector(0,0,10) )
	ply:SetHull( Vector( -14, -14, 0 ), Vector( 14, 14, 64 ) )
	ply:SetHullDuck( Vector( -14, -14, 0 ), Vector( 14, 14, 30 ) )
	end
	end)
	else
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 70 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 34 ) )
	end
end)

hook.Add("PlayerSpawn",  "player_antlion_worker_Viewheight_Offset", function(ply)
	if not ply or not ply:IsValid() then return end
	e = ents.Create("gmod_hands")
	e:SetOwner(ply)
	e:Spawn()
	e:SetOwner(ply)
	ply:SetHands( e )
	if (ply:GetModel() == "models/antlion_worker_pm.mdl") then
	timer.Simple(0.1, function()
	if GetConVarNumber( "player_antlion_viewheight" ) == 1 then
	ply:SetViewOffset( Vector(0,0,27) )
	ply:SetViewOffsetDucked( Vector(0,0,10) )
	ply:SetHull( Vector( -14, -14, 0 ), Vector( 14, 14, 64 ) )
	ply:SetHullDuck( Vector( -14, -14, 0 ), Vector( 14, 14, 30 ) )
	end
	end)
	else
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 70 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 34 ) )
	end
end)