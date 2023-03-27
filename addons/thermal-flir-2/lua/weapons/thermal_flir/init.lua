AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("ToggleFLIR")

local InThermal = {}

net.Receive("ToggleFLIR", function(_, ply)
	local bool = net.ReadBool()
	if bool then
		InThermal[ply:SteamID()] = true
	else
		InThermal[ply:SteamID()] = nil
	end
end)

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime())
end

function SWEP:Reload()
	if (!IsFirstTimePredicted()) then return end
	local reloadPly = self:GetOwner()

	if (!self.PrevZoom) then
		self.PrevZoom = reloadPly:GetCanZoom()
		reloadPly:StopZooming()
		reloadPly:SetCanZoom(false)
	end

	if (reloadPly:GetFOV() < 60) then
		reloadPly:SetDSP(55, false)
	else
		reloadPly:SetDSP(0, false)
	end

	reloadPly:SetFOV(math.Clamp(reloadPly:GetFOV() - (reloadPly:GetCurrentCommand():GetMouseWheel() * 6), 5, 120))
end

function SWEP:ResetZoom(ply)
	ply:SetFOV(0, 0.1)
	ply:SetDSP(0, false)
end


function SWEP:Think()
	local ply = self:GetOwner()
	if (ply:KeyReleased(IN_RELOAD)) then
		ply:SetCanZoom(self.PrevZoom)
		self.PrevZoom = nil
		self:ResetZoom(ply)
	end

	if ( ( self.NextBatteryPercent or 0 ) < CurTime() ) then
		if InThermal[self.Owner:SteamID()] then
			self:SetBattery( math.min( self:GetBattery() - 1.6, 100 ) )
		else
			self:SetBattery( math.min( self:GetBattery() + 2.2, 100 ) )
		end
		self.NextBatteryPercent = CurTime() + 1
	end

end

function SWEP:CanBePickedUpByNPCs() return false end

function SWEP:OnRemove()
	if (!self:GetOwner():IsValid()) then return end
	self:ResetZoom(self:GetOwner())
end

function SWEP:Holster()
	self:ResetZoom(self:GetOwner())
	return true
end

function SWEP:Deploy()
	return true
end
