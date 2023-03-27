ENT.Type = "anim";
ENT.Base = "base_gmodentity";

ENT.PrintName		= "Vehicle Spawn";
ENT.Author			= "Vanilla";
ENT.Contact			= "Please don't";
ENT.Purpose			= "To satisfy Alystair";
ENT.Instructions	= "Walk inside of it";

ENT.Editable = true;

ENT.Spawnable = true;
ENT.AdminOnly = true;

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "SpawnerID", { KeyName = "zone_id", Edit = { type = "Generic", waitforenter = true } } );
	self:NetworkVar( "String", 1, "PoolID", { KeyName = "spawner_id", Edit = { type = "Generic", waitforenter = true } } );
end
