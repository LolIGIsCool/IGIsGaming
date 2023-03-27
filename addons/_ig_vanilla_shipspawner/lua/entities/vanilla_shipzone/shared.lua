ENT.Type = "anim";
ENT.Base = "base_gmodentity";

ENT.PrintName		= "Vehicle Zone";
ENT.Author			= "Vanilla";
ENT.Contact			= "Please don't";
ENT.Purpose			= "To satisfy Alystair";
ENT.Instructions	= "just ask me if you need help";

ENT.Editable = true;

ENT.Spawnable = true;
ENT.AdminOnly = true;

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "ZoneID", { KeyName = "zone_id", Edit = { type = "Generic", waitforenter = true } } );
end
