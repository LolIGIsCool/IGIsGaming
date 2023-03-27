ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Rebel gear"
ENT.Author = ""
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Radius = 2000
function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ItemName")
    self:NetworkVar("String", 1, "QuestID")
end