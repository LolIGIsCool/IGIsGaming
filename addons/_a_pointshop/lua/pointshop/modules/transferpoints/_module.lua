MODULE = {}

MODULE.ClassName = "transferpoints"
MODULE.Name = "Points Transfer"
MODULE.Description = "Allows connected players to transfer points to other players."

MODULE.Config = {
	Enable = true,

	-- Admins are now affected by the below options.
	AllowStandardTransfer = false,
	MinimumStandardPoints = 0,
	MaximumStandardPoints = 0, -- Set to 0 for no limit.

	AllowPremiumTransfer = true,
	MinimumPremiumPoints = 1,
	MaximumPremiumPoints = 1000000, -- Set to 0 for no limit.

	TransferCooldown = 0
}

local easynet = SH_POINTSHOP.easynet

easynet.Start("SH_POINTSHOP.TransferPoints")
	easynet.Add("target", EASYNET_PLAYER)
	easynet.Add("standard", EASYNET_UINT32)
	easynet.Add("premium", EASYNET_UINT32)
easynet.Register()

-- Hooks to be used for developers
function MODULE:CanTransferTo(sender, recipient)
	--if (SH_POINTSHOP:IsAdmin(sender)) then
	--	return true
	--end

	local can, reason = hook.Run("SH_POINTSHOP.TransferPoints.CanTransferTo", sender, recipient)
	if (can ~= nil) then
		return can, reason
	end

	return true, "error message"
end

function MODULE:CanStandardTransfer(ply, amount)
	--if (SH_POINTSHOP:IsAdmin(ply)) then
	--	return true
	--end

	local b = hook.Run("SH_POINTSHOP.TransferPoints.CanStandardTransfer", ply, amount)
	if (b ~= nil) then
		return b
	end

	return self.Config.AllowStandardTransfer
end

function MODULE:CanPremiumTransfer(ply, amount)
	--if (SH_POINTSHOP:IsAdmin(ply)) then
	--	return true
	--end

	local b = hook.Run("SH_POINTSHOP.TransferPoints.CanPremiumTransfer", ply, amount)
	if (b ~= nil) then
		return b
	end

	return self.Config.AllowPremiumTransfer
end

if (SERVER) then
	AddCSLuaFile("cl_transferpoints.lua")
	include("sv_transferpoints.lua")
else
	include("cl_transferpoints.lua")
end

SH_POINTSHOP:RegisterModule(MODULE)
MODULE = nil