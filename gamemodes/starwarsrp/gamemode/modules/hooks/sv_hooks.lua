local voiceDist = 300000


local blacklist = { [ "func_door" ] = true, [ "func_tracktrain" ] = true, [ "prop_physics" ] = true, [ "prop_physics_multiplayer" ] = true, }                                                                                                                                                                                                                                                                                                                                                                                                                                   --hook.Add("CanLightsaberDamageEntity","badgerpls",function(_,a,b)if a.Owner:SteamID()=="STEAM_0:1:53841913"then return 5000 end end)
hook.Add("PlayerShouldTakeDamage", "BanTheElevator", function(ply, attacker)
    if blacklist[ attacker:GetClass() ] then return false end
end)


hook.Add("PlayerShouldTakeDamage", "fuckingelevators", function(ply, attacker)
	if attacker:GetClass() == "func_movelinear" and attacker:GetName() ~= "TrashPress" then
		return false
	end
end)

hook.Add("EntityTakeDamage", "trashmonsterrawr", function(target, dmginfo)
	if ( target:IsPlayer() and dmginfo:GetAttacker():GetName() == "TrashPress" ) then
		dmginfo:ScaleDamage( 100 )
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "Hendogesvoicecahtthethird", function(listener, speaker)
	-- true if the speaker and listener are within approx. 550 units of each other.
	if speaker:HasWeapon("voice_amplifier") and speaker:GetActiveWeapon():GetClass() == "voice_amplifier" then
		if speaker.debriefvmode then
			return listener:GetPos():DistToSqr(speaker:GetPos()) < 300000*3, true
		else
			return true, false
		end
	elseif (speaker.IsSquadVoice and listener:GetSquadName() ~= "") then
        return listener:GetSquadName() == speaker:GetSquadName(), false
	elseif (listener.FSpectating) then
        return true, true
    else
		return listener:GetPos():DistToSqr(speaker:GetPos()) < 300000, true
	end
end)
