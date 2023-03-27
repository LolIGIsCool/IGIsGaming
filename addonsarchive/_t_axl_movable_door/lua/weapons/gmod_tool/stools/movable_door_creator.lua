
axl = axl or {};
axl.movable_door = axl.movable_door or {};
axl.movable_door.cfg = axl.movable_door.cfg or {};
local cfg = axl.movable_door.cfg;

TOOL.Category = "Movable door"
TOOL.Name = "Creator"

TOOL.ClientConVar[ "health" ] = 1000;
TOOL.ClientConVar[ "start_open" ] = 0;
TOOL.ClientConVar[ "autopos" ] = 1;
TOOL.ClientConVar[ "moveDistance" ] = 0;
TOOL.ClientConVar[ "door_id" ] = 0;
TOOL.ClientConVar[ "autoclose" ] = 1;
TOOL.ClientConVar[ "autoclose_time" ] = 5;
TOOL.ClientConVar[ "open_on_use" ] = 0;
TOOL.ClientConVar[ "direction" ] = 0;
TOOL.ClientConVar[ "sound" ] = 0;
TOOL.ClientConVar[ "use_timeout" ] = 3;
TOOL.ClientConVar[ "speed" ] = 0;
TOOL.ClientConVar[ "door_name" ] = "Door";

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload" }
}

function TOOL:LeftClick( trace )
	local ent = trace.Entity;
	if (!ent or !IsValid(ent) or ent:GetClass() != "prop_physics") then return false; end;
	if (SERVER) then
		if (cfg["enable_health"]) then
			local price = cfg["hp_price"]*math.ceil(math.Clamp(self:GetClientNumber( "health", 0 ), 0, cfg["max_hp"])/cfg["hp_count"]);
			if (!self:GetOwner():canAfford(price)) then return; end;
			self:GetOwner():addMoney(-price);
		end;
		
		local door = ents.Create("axl_movable_door_main");
		if (!door or !IsValid(door)) then return; end;

		door.axl_door_id = self:GetClientInfo( "door_id", 0 );
		door.axl_autopos = self:GetClientNumber( "autopos", 0 );
		door.axl_moveDistance = self:GetClientNumber( "moveDistance", 0 );
		door.axl_direction = self:GetClientNumber( "direction", 0 );
		door.axl_sound = self:GetClientNumber( "sound", 0 );
		door.axl_open_on_use = self:GetClientNumber( "open_on_use", 0 );
		door.axl_autoclose = self:GetClientNumber( "autoclose", 0 );
		door.axl_autoclose_time = self:GetClientNumber( "autoclose_time", 0 );
		door.axl_use_timeout = self:GetClientNumber( "use_timeout", 0 );
		door.axl_speed = self:GetClientNumber( "speed", 0 );
		door:SetNWString("axl_door_name", string.sub(self:GetClientInfo( "door_name", 0 ), 0, 30));
		door:SetNWString("axl_door_id", string.sub(self:GetClientInfo( "door_id", 0 ), 0, 30));
		door:SetNWString("axl_door_health", math.Clamp(self:GetClientNumber( "health", 0 ), 0, cfg["max_hp"]));

		door:Spawn();
		door:SetPos(ent:GetPos());
		door:SetAngles(ent:GetAngles());
		door:SetModel(ent:GetModel());
		door:SetColor(ent:GetColor());
		door:SetMaterial(ent:GetMaterial());
		door:Activate();
		ent:Remove();
		door:CPPISetOwner(self:GetOwner());

		if (self:GetClientNumber( "start_open", 0 ) == 1) then
			timer.Simple(1, function()
				if (!IsValid(door)) then return; end;
				door:ToggleOpen();
			end);
		end;
	end;

	return true;
end

function TOOL:RightClick( trace )
	local ent = trace.Entity;
	if (!ent or !IsValid(ent) or ent:GetClass() != "axl_movable_door_main") then return false; end;
	if (SERVER) then
		ent.axl_door_id = self:GetClientInfo( "door_id", 0 );
		ent.axl_autopos = self:GetClientNumber( "autopos", 0 );
		ent.axl_moveDistance = self:GetClientNumber( "moveDistance", 0 );
		ent.axl_direction = self:GetClientNumber( "direction", 0 );
		ent.axl_sound = self:GetClientNumber( "sound", 0 );
		ent.axl_open_on_use = self:GetClientNumber( "open_on_use", 0 );
		ent.axl_autoclose = self:GetClientNumber( "autoclose", 0 );
		ent.axl_autoclose_time = self:GetClientNumber( "autoclose_time", 0 );
		ent.axl_use_timeout = self:GetClientNumber( "use_timeout", 0 );
		ent.axl_speed = self:GetClientNumber( "speed", 0 );
		ent:SetNWString("axl_door_name", string.sub(self:GetClientInfo( "door_name", 0 ), 0, 30));
		ent:SetNWString("axl_door_id", string.sub(self:GetClientInfo( "door_id", 0 ), 0, 30));
	end;

	return true;
end

function TOOL:Reload( trace )
	local ent = trace.Entity;
	if (!ent or !IsValid(ent) or ent:GetClass() != "axl_movable_door_main") then return false; end;

	if (SERVER) then
		local prop = ents.Create("prop_physics");
		if (!prop or !IsValid(prop)) then return; end;

		prop:SetPos(ent:GetPos());
		prop:SetAngles(ent:GetAngles());
		prop:SetModel(ent:GetModel());
		prop:SetColor(ent:GetColor());
		prop:SetMaterial(ent:GetMaterial());
		prop:Spawn();
		prop:Activate();
		ent:Remove();
		prop:CPPISetOwner(self:GetOwner());
		prop:GetPhysicsObject():EnableMotion(false);
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
	language.Add( "tool.movable_door_creator.name", "Movable Door" );
	language.Add( "tool.movable_door_creator.desc", "Makes an object moveable doors." );
	language.Add( "tool.movable_door_creator.left", "Click on an object to make it a moveable door." );
	language.Add( "tool.movable_door_creator.right", "Click on an object to reload settings." );
	language.Add( "tool.movable_door_creator.reload", "Click on an object for remove door." );
	language.Add( "Undone_movable_door_creator", "Undone movable Door" );

	function TOOL:BuildCPanel()
		self:AddControl( "ComboBox", { MenuButton = 1, Folder = "door_creator", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

		local combo = self:AddControl( "ListBox", { Label = "Sound preset" } );
		combo:AddOption( "Default", { movable_door_creator_sound = 0 } );
		combo:AddOption( "Metal fence", { movable_door_creator_sound = 1 } );
		combo:AddOption( "Metal gate", { movable_door_creator_sound = 2 } );
		combo:AddOption( "Rusty metal gate", { movable_door_creator_sound = 3 } );
		combo:AddOption( "Thin metal gate", { movable_door_creator_sound = 4 } );
		combo:AddOption( "Small metal door", { movable_door_creator_sound = 5 } );

		self:AddControl( "TextBox", { Label = "Door ID", Command = "movable_door_creator_door_id" } );
		self:AddControl( "TextBox", { Label = "Door Name", Command = "movable_door_creator_door_name" } );

		local combo = self:AddControl( "ListBox", { Label = "Move direction" } );
		combo:AddOption( "Left", { movable_door_creator_direction = 0 } );
		combo:AddOption( "Right", { movable_door_creator_direction = 1 } );
		combo:AddOption( "Up", { movable_door_creator_direction = 2 } );
		combo:AddOption( "Down", { movable_door_creator_direction = 3 } );
		combo:AddOption( "Forward", { movable_door_creator_direction = 4 } );
		combo:AddOption( "Back", { movable_door_creator_direction = 5 } );

		self:AddControl( "CheckBox", { Label = "Open after create", Command = "movable_door_creator_start_open" } );
		self:AddControl( "CheckBox", { Label = "Auto move Distance", Command = "movable_door_creator_autopos" } );
		self:AddControl( "CheckBox", { Label = "Auto close", Command = "movable_door_creator_autoclose" } );
		self:AddControl( "CheckBox", { Label = "Open by `E`", Command = "movable_door_creator_open_on_use" } );
		if (cfg["enable_health"]) then
			self:AddControl( "Label", { Text = "Price "..cfg["hp_price"].."$ per "..cfg["hp_count"].." hp" } );
			self:AddControl( "Slider", { Label = "Door health", Command = "movable_door_creator_health", Type = "Int", Min = 1000, Max = cfg["max_hp"] } )
		end;
		self:AddControl( "Slider", { Label = "Open speed", Command = "movable_door_creator_speed", Type = "Int", Min = 0, Max = 2 } );
		self:AddControl( "Slider", { Label = "Move Distance", Command = "movable_door_creator_moveDistance", Type = "Int", Min = 0, Max = 1000 } );
		self:AddControl( "Slider", { Label = "Auto close time", Command = "movable_door_creator_autoclose_time", Type = "Int", Min = 5, Max = 60 } );
		self:AddControl( "Slider", { Label = "Use `E` Timeout", Command = "movable_door_creator_use_timeout", Type = "Int", Min = 3, Max = 10 } );
		if (cfg["enable_health"]) then
			local lb = self:AddControl( "Label", { Text = "" } );
			lb.Think = function(self)
				self:SetText("Total price: "..cfg["hp_price"]*math.ceil(math.Clamp(GetConVar("movable_door_creator_health"):GetInt(), 0, cfg["max_hp"])/cfg["hp_count"]).."$");
				self:SetFont("Trebuchet18");
				self:SetColor(cfg["color"]);
			end;
		end;
	end;
end;
