include("shared.lua")

function ENT:CalcViewOverride( ply, pos, angles, fov, pod )

	if self:GetGunnerSeat() == ply:GetVehicle() then
		if pod:GetThirdPersonMode() then
			return pos + self:GetUp() * 100, angles, fov
		end
	end

	return pos, angles, fov
end

function ENT:OnSpawn()
end

function ENT:OnFrame()
end

function ENT:PostDrawTranslucent()
end

function ENT:EngineEffects()
end

function ENT:AnimGunner()
end

function ENT:AnimAstromech()
end

function ENT:AnimCockpit()
end

function ENT:OnStartBoost()
end

function ENT:OnStopBoost()
end
