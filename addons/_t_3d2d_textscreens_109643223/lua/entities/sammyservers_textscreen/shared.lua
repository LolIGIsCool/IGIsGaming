ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SammyServers Textscreen"
ENT.Author = "SammyServers"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "IsPersisted")
end