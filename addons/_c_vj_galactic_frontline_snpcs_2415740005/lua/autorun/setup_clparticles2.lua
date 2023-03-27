-- precache section
game.AddParticles( "particles/effects/blaster_impact_FX.pcf" )
PrecacheParticleSystem("sk_blaster_hit_02")


if (CLIENT) then 
	game.AddParticles( "particles/effects/blaster_impact_FX.pcf" )

end

if ( SERVER ) then
	-- A test console command to see if the particle works, spawns the particle where the player is looking at.
	concommand.Add( "particleitup2", function( ply, cmd, args )
		ParticleEffect( "sk_blast_hit_01", ply:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
	end )
end
--
