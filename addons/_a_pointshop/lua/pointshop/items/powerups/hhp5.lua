ITEM = {}

ITEM.ClassName = "hhp5"
ITEM.Name = "5 Bonus Health"
ITEM.Description = "Spawn with 5 bonus Health when you equip this item."
ITEM.Model = "models/riddickstuff/bactagrenade/bactanade.mdl"

ITEM.PointsCost = 0
ITEM.PremiumPointsCost = 10000

function ITEM:PlayerSpawn(ply, itm)
    timer.Simple(1.5, function()
        if (not IsValid(ply)) then return end
        local add = 0
        add = ply:GetMaxHealth() + 5
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
--			add = ply:GetMaxHealth() + (20*1.25)
--		else
--			add = ply:GetMaxHealth() + 20
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