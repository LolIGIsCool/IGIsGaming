ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = ""
ENT.Author = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Reward")
    self:NetworkVar("Bool", 0, "Opened")
end