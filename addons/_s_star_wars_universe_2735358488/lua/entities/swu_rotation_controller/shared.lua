ENT.Type        = "anim"
ENT.PrintName   = "[SWU] Rotation Controller"
ENT.Author      = "The Coding Ducks"
ENT.Information = ""
ENT.Category    = "[SWU] Universe"

ENT.Spawnable	= false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "CurrentRotation")
end