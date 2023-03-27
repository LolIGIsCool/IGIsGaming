
hook.Add( "VehicleMove", "!!!!lvs_vehiclemove", function( ply, vehicle, mv )
	if not ply.lvsGetVehicle then return end

	local veh = ply:lvsGetVehicle()

	if not IsValid( veh ) then return end

	if ply:lvsKeyDown( "VIEWDIST" ) then
		local iWheel = ply:GetCurrentCommand():GetMouseWheel()
		if iWheel ~= 0 and vehicle.SetCameraDistance then
			local newdist = math.Clamp( vehicle:GetCameraDistance() - iWheel * 0.03 * ( 1.1 + vehicle:GetCameraDistance() ), -1, 10 )
			vehicle:SetCameraDistance( newdist )
		end
	end

	if CLIENT and not IsFirstTimePredicted() then return end
	
	local KeyThirdPerson = ply:lvsKeyDown("THIRDPERSON")

	if ply._lvsOldThirdPerson ~= KeyThirdPerson then
		ply._lvsOldThirdPerson = KeyThirdPerson

		if KeyThirdPerson and vehicle.SetThirdPersonMode then
			vehicle:SetThirdPersonMode( not vehicle:GetThirdPersonMode() )
		end
	end

	return true
end )

hook.Add( "PhysgunPickup", "!!!!lvs_disable_wheel_grab", function( ply, ent )
	if ent.lvsDoNotGrab then return false end
end )

hook.Add("CalcMainActivity", "!!!lvs_playeranimations", function(ply)
	if not ply.lvsGetVehicle then return end

	local Ent = ply:lvsGetVehicle()

	if IsValid( Ent ) then
		local A,B = Ent:CalcMainActivity( ply )

		if A and B then
			return A, B
		end
	end
end)

hook.Add("UpdateAnimation", "!!!lvs_playeranimations", function( ply, velocity, maxseqgroundspeed )
	if not ply.lvsGetVehicle then return end

	local Ent = ply:lvsGetVehicle()

	if not IsValid( Ent ) then return end

	return Ent:UpdateAnimation( ply, velocity, maxseqgroundspeed )
end)

hook.Add( "StartCommand", "!!!!LVS_grab_command", function( ply, cmd )
	if not ply.lvsGetVehicle then return end

	local veh = ply:lvsGetVehicle()

	if not IsValid( veh ) then return end

	veh:StartCommand( ply, cmd )
end )

if CLIENT then
	hook.Add( "CanProperty", "!!!!lvsEditPropertiesDisabler", function( ply, property, ent )
		if ent.LVS and not ply:IsAdmin() and property == "editentity" then return false end
	end )

	return
end

hook.Add( "EntityTakeDamage", "!!!_lvs_fix_vehicle_explosion_damage", function( target, dmginfo )
	if not target:IsPlayer() then return end

	local veh = target:lvsGetVehicle()

	if not IsValid( veh ) or dmginfo:IsDamageType( DMG_DIRECT ) then return end

	dmginfo:SetDamage( 0 )
end )