
axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

TOOL.Category = "Movable door"
TOOL.Name = "Button"

TOOL.ClientConVar[ "model" ] = "models/maxofs2d/button_05.mdl"
TOOL.ClientConVar[ "id" ] = 0;
TOOL.ClientConVar[ "name" ] = "Button";

list.Set( "ButtonModels", "models/maxofs2d/button_01.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_02.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_03.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_04.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_05.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_06.mdl", {} );
list.Set( "ButtonModels", "models/maxofs2d/button_slider.mdl", {} );

TOOL.Information = {
	{ name = "left", stage = 0 }
}

local function IsValidButtonModel( model )
	for mdl, _ in pairs( list.Get( "ButtonModels" ) ) do
		if ( mdl:lower() == model:lower() ) then return true end
	end
	return false
end

function TOOL:LeftClick( trace )
	return self:RightClick( trace, true )
end

function TOOL:RightClick( trace )
	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	if ( CLIENT ) then return true end

	local model = self:GetClientInfo( "model" );
	local id = self:GetClientInfo( "id" );
	local name = self:GetClientInfo( "name" );
	local ply = self:GetOwner();

	-- If we shot a button change its settings
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "axl_movable_door_button" ) then
		trace.Entity:SetNWString("axl_id", id);
		trace.Entity:SetNWString("axl_name", name);

		return true
	end

	-- Check the model's validity
	if ( !util.IsValidModel( model ) || !util.IsValidProp( model ) || !IsValidButtonModel( model ) ) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local button = ents.Create( "axl_movable_door_button" )
	if ( !IsValid( button ) ) then return false end
	button:SetModel( model );
	button:SetAngles( Ang );
	button:SetPos( trace.HitPos );
	button:Spawn();

	button:SetIsToggle( false );
	button:SetNWString("axl_id", id);
	button:SetNWString("axl_name", name);
	button:CPPISetOwner(self:GetOwner());

	if ( nocollide == true ) then
		if ( IsValid( button:GetPhysicsObject() ) ) then button:GetPhysicsObject():EnableCollisions( false ) end
		button:SetCollisionGroup( COLLISION_GROUP_WORLD )
	end

	local min = button:OBBMins()
	button:SetPos( trace.HitPos - trace.HitNormal * min.z )

	ply:AddCount("buttons", button);
	ply:AddCleanup("buttons", button);

	return true
end

function TOOL:Reload( trace )
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
	language.Add( "tool.movable_door_button.name", "Movable Door - Button" );
	language.Add( "tool.movable_door_button.desc", "Create button for door." );
	language.Add( "tool.movable_door_button.left", "Click on an object to make it a moveable door." );
	language.Add( "Undone_movable_door_button", "Undone movable Door - button" );

	function TOOL:BuildCPanel()
		self:AddControl( "TextBox", { Label = "Door ID", Command = "movable_door_button_id" } );
		self:AddControl( "TextBox", { Label = "Button Name", Command = "movable_door_button_name" } );

		self:AddControl( "PropSelect", { Label = "#tool.button.model", ConVar = "movable_door_button_model", Height = 0, Models = list.Get( "ButtonModels" ) } )
	end;
end;
