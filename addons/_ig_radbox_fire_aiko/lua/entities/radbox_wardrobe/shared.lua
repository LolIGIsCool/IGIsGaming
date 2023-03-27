ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Hasmat Wardrobe"
ENT.Category = "Aiko's Entities"
ENT.Author = "Fire & Aiko"
ENT.Spawnable = true
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "HazmatSuits")
end