ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Author = "Tood. (modified by Goliath)"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.PrintName = "Gravity Generator"
ENT.Category = "Tood's SWRP Entities"

ENT.GenHealth = 1500 -- Grav Gen health.

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "PlayerRepairing" )
end
