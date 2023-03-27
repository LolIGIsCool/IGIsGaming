ITEM = {}

ITEM.ClassName = "dhp200"
ITEM.Name = "40 Bonus Health"
ITEM.Description = "Spawn with 40 bonus Health when you equip this item."
ITEM.Model = "models/riddickstuff/bactagrenade/bactanade.mdl"

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 1000000

function ITEM:PlayerSpawn(ply, itm)
    timer.Simple(1.5, function()
        if (not IsValid(ply)) then return end
        local add = 0
        add = ply:GetMaxHealth() + 40
        -- Sets the Maximum Health of a Player so that they can be healed to their new MHP.
        ply:SetMaxHealth(add)
        -- Sets the Players Health
        ply:SetHealth(add)
    end)
end

--function ITEM:PlayerSpawn(ply, itm)
--	timer.Simple(0, function()
--		if (!IsValid(ply)) then
--			return end
		-- Additional Health for the Player
--		local add = 0
--		if ply:GetNWInt("igprogressu", 0 ) >= 2 then
--			add = ply:GetMaxHealth() + (40*1.25)
--		else
--			add = ply:GetMaxHealth() + 40
--		end
--		
		-- Sets the Maximum Health of a Player so that they can be healed to their new MHP.
--		ply:SetMaxHealth(add)
--		
		-- Sets the Players Health
--		ply:SetHealth(add)
--	end)
--end

SH_POINTSHOP:RegisterItem(ITEM)