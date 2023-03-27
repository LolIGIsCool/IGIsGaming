ITEM = {}

ITEM.ClassName = "fhp300"
ITEM.Name = "60 Bonus Health"
ITEM.Description = "Spawn with 60 bonus Health when you equip this item."
ITEM.Model = "models/riddickstuff/bactagrenade/bactanade.mdl"

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 3000000

function ITEM:PlayerSpawn(ply, itm)
    timer.Simple(1.5, function()
        if (not IsValid(ply)) then return end
        local add = 0
        add = ply:GetMaxHealth() + 60
        -- Sets the Maximum Health of a Player so that they can be healed to their new MHP.
        ply:SetMaxHealth(add)
        -- Sets the Players Health
        ply:SetHealth(add)
    end)
end

SH_POINTSHOP:RegisterItem(ITEM)