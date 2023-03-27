local CATEGORY_NAME = "Rcon"

function ulx.ent_fire( calling_ply, classname, input, param )
	if not calling_ply:IsValid() then
		Msg( "Can't fire entities from dedicated server console.\n" )
		return
	end

	for k, v in pairs( ents.GetAll() ) do
		if v:GetClass() == classname or v:GetName() == classname then
			v:Input( input, calling_ply, calling_ply, param )
		end
	end
end
local ent_fire = ulx.command( CATEGORY_NAME, "ulx ent_fire", ulx.ent_fire )
ent_fire:addParam{ type=ULib.cmds.StringArg, hint="classname (or) targetname" }
ent_fire:addParam{ type=ULib.cmds.StringArg, hint="input" }
ent_fire:addParam{ type=ULib.cmds.StringArg, hint="param", ULib.cmds.optional }
ent_fire:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_fire:help( "Fire an input on an entity." )

function ulx.ent_keyvalue( calling_ply, classname, key, value )
	if not calling_ply:IsValid() then
		Msg( "Can't set keyvalues from dedicated server console.\n" )
		return
	end

	for k, v in pairs( ents.GetAll() ) do
		if v:GetClass() == classname or v:GetName() == classname then
			v:SetKeyValue( key, value )
		end
	end
end
local ent_keyvalue = ulx.command( CATEGORY_NAME, "ulx ent_keyvalue", ulx.ent_keyvalue )
ent_keyvalue:addParam{ type=ULib.cmds.StringArg, hint="classname (or) targetname" }
ent_keyvalue:addParam{ type=ULib.cmds.StringArg, hint="key" }
ent_keyvalue:addParam{ type=ULib.cmds.StringArg, hint="value" }
ent_keyvalue:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_keyvalue:help( "Set a keyvalue of an entity." )

function ulx.ent_rotate( calling_ply )
	if not calling_ply:IsValid() then
		Msg( "Can't rotate entities from dedicated server console.\n" )
		return
	end

	local tr = calling_ply:GetEyeTrace()
	local ent = tr.Entity

	tr.Entity:SetNWAngle( "ENT_ROTATE", tr.Entity:GetAngles() )
	tr.Entity:SetAngles( Angle( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ) )
end
local ent_rotate = ulx.command( CATEGORY_NAME, "ulx ent_rotate", ulx.ent_rotate )
ent_rotate:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_rotate:help( "Rotate an entity you're looking at." )

function ulx.ent_unrotate( calling_ply )
	if not calling_ply:IsValid() then
		Msg( "Can't unrotate entities from dedicated server console.\n" )
		return
	end

	local tr = calling_ply:GetEyeTrace()
	local ent = tr.Entity

	tr.Entity:SetAngles( tr.Entity:GetNWAngle( "ENT_ROTATE", Angle( 0, 0 ,0 ) ) )
end
local ent_unrotate = ulx.command( CATEGORY_NAME, "ulx ent_unrotate", ulx.ent_unrotate )
ent_unrotate:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_unrotate:help( "Unrotate the entity you're looking at." )

function ulx.ent_teleport( calling_ply, targetname )
	if not calling_ply:IsValid() then
		Msg( "Can't teleport entities from dedicated server console.\n" )
		return
	end
	
	local tr = calling_ply:GetEyeTrace()
	
	for k, v in pairs( ents.GetAll() ) do
		if IsValid( v ) and v:GetName() == targetname then
			v:SetNWAngle( "ENT_TELEPORT", v:GetPos() )
			v:SetPos( tr.HitPos )
		end
	end
end
local ent_teleport = ulx.command( CATEGORY_NAME, "ulx ent_teleport", ulx.ent_teleport )
ent_teleport:addParam{ type=ULib.cmds.StringArg, hint="targetname" }
ent_teleport:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_teleport:help( "Teleport an entity." )

function ulx.ent_unteleport( calling_ply, targetname )
	if not calling_ply:IsValid() then
		Msg( "Can't unteleport entities from dedicated server console.\n" )
		return
	end
	
	local tr = calling_ply:GetEyeTrace()

	for k, v in pairs( ents.GetAll() ) do
		if IsValid( v ) and v:GetName() == targetname then
			v:SetPos( v:GetNWVector( "ENT_TELEPORT", v:GetPos() ) )
		end
	end
end
local ent_unteleport = ulx.command( CATEGORY_NAME, "ulx ent_unteleport", ulx.ent_unteleport )
ent_unteleport:addParam{ type=ULib.cmds.StringArg, hint="targetname" }
ent_unteleport:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_unteleport:help( "Returns an entity to its original spot after being teleported." )

function ulx.ent_setname( calling_ply, targetname )
	if not calling_ply:IsValid() then
		Msg( "Can't name entities from dedicated server console.\n" )
		return
	end

	local tr = calling_ply:GetEyeTrace()
	local ent = tr.Entity
	
	if IsValid(ent) then
		ent:SetKeyValue( "targetname", targetname )
		ent:SetName( targetname )
		
		calling_ply:PrintMessage( HUD_PRINTCONSOLE, ent:GetClass() .. " name set to " .. targetname )
	end
end
local ent_setname = ulx.command( CATEGORY_NAME, "ulx ent_setname", ulx.ent_setname )
ent_setname:addParam{ type=ULib.cmds.StringArg, hint="targetname" }
ent_setname:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_setname:help( "Set the targetname of an entity." )

function ulx.ent_name( calling_ply )
	if not calling_ply:IsValid() then
		Msg( "Can't get the name of entities from dedicated server console.\n" )
		return
	end

	local tr = calling_ply:GetEyeTrace()
	local ent = tr.Entity
	
	if IsValid(ent) then
		calling_ply:PrintMessage( HUD_PRINTCONSOLE, ent:GetName() )
	end
end
local ent_name = ulx.command( CATEGORY_NAME, "ulx ent_name", ulx.ent_name )
ent_name:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_name:help( "Set the targetname of the entity on your crosshair." )

function ulx.ent_remove( calling_ply )
	if not calling_ply:IsValid() then
		Msg( "Can't remove entities from dedicated server console.\n" )
		return
	end

	local tr = calling_ply:GetEyeTrace()
	local ent = tr.Entity

	if IsValid( ent ) then
		ent:Remove()
	end
end
local ent_remove = ulx.command( CATEGORY_NAME, "ulx ent_remove", ulx.ent_remove )
ent_remove:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_remove:help( "Remove the entity on your crosshair." )

function ulx.ent_remove_all( calling_ply, classname )
	if not calling_ply:IsValid() then
		Msg( "Can't remove entities from dedicated server console.\n" )
		return
	end

	for k, v in pairs( ents.GetAll() ) do
		if v:GetClass() == classname or v:GetName() == classname then
			v:Remove()
		end
	end
end
local ent_remove_all = ulx.command( CATEGORY_NAME, "ulx ent_remove_all", ulx.ent_remove_all )
ent_remove_all:addParam{ type=ULib.cmds.StringArg, hint="classname (or) targetname" }
ent_remove_all:defaultAccess( ULib.ACCESS_SUPERADMIN )
ent_remove_all:help( "Remove all entities of a classname or targetname from the map." )