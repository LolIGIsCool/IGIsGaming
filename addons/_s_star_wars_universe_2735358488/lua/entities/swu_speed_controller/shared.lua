ENT.Type        = "anim"
ENT.PrintName   = "[SWU] Speed Controller"
ENT.Author      = "The Coding Ducks"
ENT.Information = ""
ENT.Category    = "[SWU] Universe"

ENT.Spawnable	= false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MaxPower")
end

function ENT:SharedInitialize()
    self.StartLever = Vector(18.5, -2.8, 30)
    self.StopLever = Vector(12, -3, 32)
end