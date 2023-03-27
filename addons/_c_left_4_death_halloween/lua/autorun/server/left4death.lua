/*
Made by StealthPaw: http://steamcommunity.com/id/stealthpaw ]]--
 Sound credits to Left 4 Dead. */
resource.AddWorkshop( "894320790" ) //-- Make clients download the sounds/materials.
resource.AddFile("sound/ig/deadsound.mp3")
resource.AddFile("materials/ig/ig_logo_halloween.png")

hook.Add( "PlayerSpawn", "PlayerSpawn_L4D", function( ply )
	ply:ConCommand( "PlayerSpawn_L4D" )
end )
hook.Add( "PlayerDeath", "PlayerDeath_L4D", function( ply, i, killer )
	ply:ConCommand( "PlayerDeath_L4D" )

	ply.nextspawn = CurTime() + 5;
end )
hook.Add( "PlayerDeathSound", "PlayerDeathSound_L4D", function( ply) return true end )

// enable respawn after amount of time has passed
hook.Add("PlayerDeathThink", "VANILLA_HOOK_DEATHTIMER", function(ply)
	ply:SetNWInt("VANILLA_DEATHTIMER", ply.nextspawn - CurTime());

	if (CurTime() < ply.nextspawn) then
		return false
	end
end)