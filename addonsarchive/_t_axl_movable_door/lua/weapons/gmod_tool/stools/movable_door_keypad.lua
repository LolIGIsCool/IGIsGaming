
axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

TOOL.Category = "Movable door"
TOOL.Name = "Keypad"

TOOL.ClientConVar[ "id" ] = 0;
TOOL.ClientConVar[ "name" ] = "Keypad";
TOOL.ClientConVar[ "timeout" ] = 3;

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload"}
};

function TOOL:LeftClick( trace )
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end

	local id = self:GetClientInfo( "id" );
	local name = self:GetClientInfo( "name" );
	local timeout = self:GetClientInfo( "timeout" );
	local ply = self:GetOwner();


	-- If we shot a button change its settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "axl_movable_door_keypad" ) then
		trace.Entity:SetNWString("axl_id", id);
		trace.Entity:SetNWString("axl_name", name);
		trace.Entity:SetNWString("axl_timeout", timeout);

		return true;
	end

	local Ang = trace.HitNormal:Angle();

	local button = ents.Create( "axl_movable_door_keypad" )
	if ( !IsValid( button ) ) then return false end
	button:SetAngles( Ang );
	button:SetPos( trace.HitPos );
	button:Spawn();

	button:SetNWString("axl_id", id);
	button:SetNWString("axl_name", name);
	button:SetNWString("axl_timeout", timeout);
	button:CPPISetOwner(self:GetOwner());

	if ( nocollide == true ) then
		if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
		button:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end

	local min = button:OBBMins()
	button:SetPos( trace.HitPos - trace.HitNormal*-0.3);
	button:GetPhysicsObject():EnableMotion(false);

	ply:AddCount("keypads", button);
	ply:AddCleanup("keypads", button);
	return true
end

function TOOL:RightClick( trace )
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "axl_movable_door_keypad" && (trace.Entity:GetNWString("Mode") == "normal" or trace.Entity:GetNWString("Mode") == "install_required") ) then
		trace.Entity:SetNWString("Mode", "install");

		return true;
	end;
	return false;
	// Install mode
end

function TOOL:Reload( trace )
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end
	if ( !IsValid( trace.Entity ) or trace.Entity:GetClass() != "axl_movable_door_keypad") then return false; end;
	if (trace.Entity:GetNWString("Mode") == "normal" or trace.Entity:GetNWString("Mode") == "installing") then
		trace.Entity:EnterToProgrammMode();
		if (trace.Entity:GetNWString("Mode") == "installing") then
			netstream.Start(self:GetOwner(), "axl.movable_door.FingerprintMenu", {trace.Entity, trace.Entity.fingerStore});
		end;
	else
		trace.Entity:ErrorInstall();
	end;

	
	return true;
end

function TOOL:Think()

	if ( self:NumObjects() != 1 ) then return end

	self:UpdateGhostEntity()

end

function TOOL:Holster()
end

local ConVarsDefault = TOOL:BuildConVarList()

if CLIENT then
	language.Add( "tool.movable_door_keypad.name", "Movable Door - Keypad" );
	language.Add( "tool.movable_door_keypad.desc", "Create Keypad for door." );
	language.Add( "tool.movable_door_keypad.left", "Click for create or update keypad." );
	language.Add( "tool.movable_door_keypad.right", "Click for set install mode on keypad." );
	language.Add( "tool.movable_door_keypad.reload", "Click for enable fingerprint mode." );
	language.Add( "Undone_movable_door_keypad", "Undone movable Door - keypad" );

	function TOOL:BuildCPanel()
		self:AddControl( "TextBox", { Label = "Door ID", Command = "movable_door_keypad_id" } );
		self:AddControl( "TextBox", { Label = "Keypad Name", Command = "movable_door_keypad_name" } );
		self:AddControl( "Slider", { Label = "Keypad timeout", Command = "movable_door_keypad_timeout", Type = "Int", Min = 3, Max = 60 } );
	end;
end;
