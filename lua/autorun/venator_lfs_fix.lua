--[[
This is a workaround for LFS not being able to be teleported
It disables the ships engines and enables them again shortly after
dont know if this works well on low tick servers
Luna plz fix
]]



-- This has to match the map Name
if not (game.GetMap() == "rp_venator_extensive_v1_4") then return end

local function startEngine(ship)
	if ship:GetEngineActive() or ship:IsDestroyed() or ship:InWater() or ship:GetRotorDestroyed() then return end

	ship:SetEngineActive( true )
	ship:OnEngineStarted()

	ship:InertiaSetNow()
end

function LFSEnter()
	local ship = ACTIVATOR
	if IsValid(ship) and ship.LFS then
		if ship:GetEngineActive() then
			ship:StopEngine()
			timer.Simple(0.1, function() startEngine(ship) end)
		end
	end
end
