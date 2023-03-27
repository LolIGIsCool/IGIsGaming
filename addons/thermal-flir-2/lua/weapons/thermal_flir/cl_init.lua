include("shared.lua")

SWEP.WeaponFOV = 75


local FLIRf = {} -- Hold FLIR functions
local FLIRv = {} -- Hold FLIR variables

FLIRv.ColorTab =
{
	["$pp_colour_addr"]			= -.2,
	["$pp_colour_addg"]			= -.2,
	["$pp_colour_addb"]			= -.2,
	["$pp_colour_brightness"]	= .075,
	["$pp_colour_contrast"]		= 1,
	["$pp_colour_colour"]		= 0,
	["$pp_colour_mulr"]			= 0,
	["$pp_colour_mulg"]			= 0,
	["$pp_colour_mulb"]			= 0,
}

FLIRv.deathRefreshTab = {}

FLIRv.InThermal = false

FLIRv.nvgOn = Sound("nvg_on.wav")
FLIRv.nvgOff = Sound("nvg_off.wav")

FLIRv.LocalCenX = ScrW() / 2
FLIRv.LocalCenY = ScrH() / 2


FLIRf.DiscoverNewPlayers = function() end
FLIRf.SetReceivedRagMat = function() end
FLIRf.IsNotTeammate = function() end
FLIRf.RefreshInThermal = function(refMats)
	if (!FLIRv.InThermal) then return end
	if (refMats) then
		hook.Remove("PostPlayerDraw", "FLIR_DrawPlyMats")
		hook.Add("PostPlayerDraw", "FLIR_DrawPlyMats", MakeHot)
	else
		hook.Remove("HUDPaint", "FLIR_DrawRangefinder")
		hook.Add("HUDPaint", "FLIR_DrawRangefinder", FLIRf.CreateRangeFinder)
	end
end

FLIRf.IsNotTeammate = function(locPly, newPly)
	return team.GetColor(locPly:Team()) != team.GetColor(newPly:Team())
end

FLIRf.DefMatFuncs = function()

	FLIRf.DiscoverNewPlayers = function(ply)
		print(ply)
		ply:SetMaterial("flir/player")
	end

	FLIRf.SetReceivedRagMat = function(newPly)
		if (FLIRv.InThermal and FLIRf.IsNotTeammate(LocalPlayer(), newPly)) then
			newPly:GetRagdollEntity():SetMaterial("flir/player")
		end
	end
	FLIRf.RefreshInThermal(true)
end

FLIRf.CreateRangeFinder = function()
	surface.SetTextColor(255, 255, 255)
	surface.SetFont("TargetIDSmall")
	surface.SetTextPos(FLIRv.LocalCenX + 7.5, FLIRv.LocalCenY + 7.5)
	surface.DrawText(string.gsub(LocalPlayer():GetPos():Distance(LocalPlayer():GetEyeTraceNoCursor().HitPos) / 52.49, "%p%d*", "m"))
end

FLIRf.DefMatFuncs()

FLIRv.__oldLight = 0
FLIRv.__newLight = 0
FLIRv.__brightInterval = 0
FLIRv.__colorInterval = 0
FLIRv.__lightCount = 101

FLIRf.FilterSmooth = function()
	if (FLIRv.__lightCount <= 100) then
		FLIRv.ColorTab["$pp_colour_brightness"] = FLIRv.ColorTab["$pp_colour_brightness"] + FLIRv.__brightInterval
		FLIRv.ColorTab["$pp_colour_addr"] = (FLIRv.ColorTab["$pp_colour_addr"] + FLIRv.__colorInterval)
		FLIRv.ColorTab["$pp_colour_addg"], FLIRv.ColorTab["$pp_colour_addb"] = FLIRv.ColorTab["$pp_colour_addr"], FLIRv.ColorTab["$pp_colour_addr"]
		FLIRv.__lightCount = FLIRv.__lightCount + 1
	end
end
function MakeHot()
	for _, ply in pairs(player.GetAll()) do
		if ply:GetMoveType() != 8 then
			ply:SetMaterial("flir/player")
			ply:SetNoDraw(false)
		end
		if ply:GetNWBool("CamoEnabled") then
			ply:SetColor(Color(255,255,0,255))
		end
	end
end
FLIRf.FLIRToggle = function()
	FLIRv.InThermal = !FLIRv.InThermal
	net.Start("ToggleFLIR")
	net.WriteBool(FLIRv.InThermal)
	net.SendToServer()
	if FLIRv.InThermal then
		hook.Add("PostPlayerDraw", "FLIR_DrawPlyMats", MakeHot)
		FLIRf.RefreshInThermal(true)
		hook.Add("HUDPaint", "FLIR_DrawRangefinder", FLIRf.CreateRangeFinder)
		hook.Add("RenderScreenspaceEffects", "FLIR_RenderModify", function()
			FLIRv.__newLight = render.GetLightColor(LocalPlayer():GetPos())
			FLIRv.__newLight = (FLIRv.__newLight.x + FLIRv.__newLight.y + FLIRv.__newLight.z) ^ 0.1
			if (FLIRv.__newLight != FLIRv.__oldLight) then
				FLIRv.__brightInterval = ((0.135 * FLIRv.__newLight) - FLIRv.ColorTab["$pp_colour_brightness"]) / 100
				FLIRv.__colorInterval = (((FLIRv.__newLight / 5.0) + FLIRv.ColorTab["$pp_colour_addr"]) / 100) * -1
				FLIRv.__lightCount = 0
				FLIRv.__oldLight = FLIRv.__newLight
			end
			FLIRf.FilterSmooth()
			DrawColorModify(FLIRv.ColorTab)
			return false
		end)
		surface.PlaySound(FLIRv.nvgOn)
	else
		hook.Remove("PostPlayerDraw", "FLIR_DrawPlyMats")
		hook.Remove("HUDPaint", "FLIR_DrawRangefinder")
		hook.Remove("RenderScreenspaceEffects", "FLIR_RenderModify")
		FLIRf.RefreshInThermal(false)
		local allPlayers = player.GetAll()
		for _, ply in pairs(allPlayers) do
			if ply:GetNWBool("CamoEnabled") then
				ply:SetNoDraw(true)
			end
			if ply:GetMoveType() == 8 then
				ply:SetNoDraw(true)
			end
			ply:SetNoDraw(false)
			ply:SetColor(Color(255,255,255,255))
			ply:SetMaterial("")
		end
		surface.PlaySound(FLIRv.nvgOff)
	end
end

FLIRv.CenterY20 = FLIRv.LocalCenY - 20

function SWEP:ResetZoom()
	hook.Remove("HUDShouldDraw", "FLIR_HideWeaponSwitch")
	FLIRv.IsZooming = false
end

function SWEP:Holster()
	if (self:GetOwner() == LocalPlayer()) then
		FLIRv.Equipped = false
		self:ResetZoom()
	end
	return true
end

function SWEP:Deploy()
	if (self:GetOwner() == LocalPlayer()) then
		self:GetOwner():SetFOV(0)
		self.WeaponFOV = self:GetOwner():GetFOV()
	end
	return true
end

function SWEP:DoDrawCrosshair(x, y)

	surface.SetDrawColor(Color(255,255,255,50))
	surface.DrawLine(x - 10, y, x + 11, y)
	surface.DrawLine(x, y - 10, x, y + 11)
	FLIRv.Equipped = true
	if (!FLIRv.IsZooming) then return true end
	local DZscale = math.abs(90 - LocalPlayer():GetFOV())
	local SegmentDist = 114.65 * DZscale^-1
	local DZForCond1 = 360 - SegmentDist
	surface.SetDrawColor(255, 255, 255, 100)
	for i = 0, DZForCond1, SegmentDist do
		local radI = math.rad(i)
		local radISegment = math.rad(i + SegmentDist)
		surface.DrawLine(FLIRv.LocalCenX + math.cos(radI) * DZscale,
			FLIRv.LocalCenY - math.sin(radI) * DZscale,
			FLIRv.LocalCenX + math.cos(radISegment) * DZscale,
			FLIRv.LocalCenY - math.sin(radISegment) * DZscale)
	end
	local DZForCond2 = ScrW() / (SegmentDist * 2)
	local DZLine2 = ScrW() - DZForCond2
	local DZForInc = SegmentDist * 12.56
	for a = 0, DZForCond2, DZForInc do
		surface.DrawLine(a, FLIRv.LocalCenY, a, FLIRv.CenterY20)
		surface.DrawLine(DZLine2 + a, FLIRv.LocalCenY, DZLine2 + a, FLIRv.CenterY20)
	end
	return true
end

function SWEP:PrimaryAttack()
	if (IsFirstTimePredicted()) then
		if self:GetBattery() < 50 and !FLIRv.InThermal then self:GetOwner():ChatPrint("Your thermals need to charge to atleast 50% before using them again.") return end
		FLIRf.FLIRToggle()
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if (!IsFirstTimePredicted() or FLIRv.IsZooming or !FLIRv.Equipped) then return end
	FLIRv.IsZooming = true

	hook.Add("HUDShouldDraw", "FLIR_HideWeaponSwitch", function(name)
		if (name == "CHudWeaponSelection") then
			return false
		end
	end)
end

function SWEP:Think()
	local ply = self:GetOwner()
	if (ply:KeyReleased(IN_RELOAD)) then
		self:ResetZoom(ply)
	end
	if self:GetBattery() <= 0 and FLIRv.InThermal then
		FLIRf.FLIRToggle()
	end
end

function SWEP:OnRemove()
	if (self:GetOwner() != LocalPlayer() or !LocalPlayer():IsValid()) then return end
	self:ResetZoom()
	FLIRv.IsZooming = false
	if (FLIRv.InThermal and !LocalPlayer():HasWeapon("thermal_flir")) then
		FLIRf.FLIRToggle()
	end
end

function SWEP:OnReloaded()
	if (self:GetOwner() != LocalPlayer()) then return end
	FLIRv.InThermal = true
	FLIRf.FLIRToggle()
	self:GetOwner():SetFOV(0)
	self.WeaponFOV = self:GetOwner():GetFOV()
end

net.Receive("ToggleFLIR", function()
	local bool = net.ReadBool()
	if FLIRv.InThermal != bool then
		FLIRf.FLIRToggle()
	end
end)


local BatteryBar = 100
function SWEP:DrawHUD()

	if ( !IsValid( self.Owner ) ) then return end

	BatteryBar = math.min( 100, Lerp( 1, BatteryBar, math.floor( self:GetBattery() ) ) )

	local w = 416
	local h = 18
	local x = math.floor( ScrW() / 2 - w / 2 )
	local y  = h * 1.2

	local barW = math.ceil( w * ( BatteryBar / 100 ) )
	if ( self:GetBattery() <= 1 and barW <= 1 ) then barW = 0 end
	draw.RoundedBox( 0, x, y, barW, h, Color( 92, 92, 92) )

	draw.SimpleText( "Battery: " .. math.floor( self:GetBattery() ) .. "%", "TargetIDSmall", x + w / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )

end