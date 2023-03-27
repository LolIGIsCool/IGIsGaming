ENT.Type            = "anim"


ENT.PrintName = "nuk projectile"
ENT.Author = ""
ENT.Information = ""
ENT.Category = "OR's Explosives"

ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar( "String",1, "BlastEffect" )
	self:NetworkVar( "Float",1, "Size" )
end

