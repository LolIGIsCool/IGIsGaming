AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom    = false

util.AddNetworkString("ClimbRoll")
local flags = {FCVAR_REPLICATED, FCVAR_ARCHIVE}
CreateConVar("climbswep2_necksnaps", "0", flags)
CreateConVar("climbswep2_wallrun_minheight", "250", flags)
CreateConVar("climbswep2_roll_allweps", "0", flags)
CreateConVar("climbswep2_slide_allweps", "0", flags)
CreateConVar("climbswep2_maxjumps", "3", flags)

local function GetWeaponClass(ply)
    if !IsValid(ply) or !IsValid(ply:GetActiveWeapon()) then return "" end
    return ply:GetActiveWeapon():GetClass()
end
hook.Add("OnPlayerHitGround", "ClimbRoll", function(ply, inWater, idc, fallSpeed)
    if !IsValid(ply) or ply:Health() <= 0 then return end
	if (GetWeaponClass(ply) == "climb_swep2" or GetConVarNumber("climbswep2_roll_allweps") > 0) and !ply:GetNWBool("ClimbFalling") and !inWater and fallSpeed > 300 and ply:Crouching() then

		net.Start("ClimbRoll")
		net.WriteInt(math.Round(ply:EyeAngles().p), 16)
		net.Send(ply)
		ply:EmitSound("physics/cardboard/cardboard_box_break1.wav", 100, 100)
		--ply:SetVelocity(ply:GetVelocity() + ply:GetForward() *  (10 + fallSpeed))
	end

end)
hook.Add("PlayerSpawn", "ClimbPlayerSpawn", function(ply)
    ply.ClimbLastVel = Vector(0, 0, 0)
	ply:SetNWBool("ClimbSlide", false)
	ply.ClimbSlideSound = CreateSound(ply, Sound("physics/body/body_medium_scrape_smooth_loop1.wav"))

    if _G.HasAugment(ply, "The Mountaineer") then ply:SetNWBool("Mountaineer",true) else ply:SetNWBool("Mountaineer",false) end
end)

hook.Add("PlayerDisconnected", "ClimbPlayerSpawn", function(ply)
    hook.Remove("Think", "ClimbGrab"..ply:UniqueID())
end)

hook.Add("GetFallDamage", "ClimbRollPD", function(ply, fallSpeed)
	if ply:GetNWBool("ClimbFalling") then
		sound.Play("physics/body/body_medium_break"..math.random(2, 4)..".wav", ply:GetPos())
		ply:SetNWBool("ClimbFalling", false)
	elseif fallSpeed < 900 and ply:Crouching() and (ply:GetActiveWeapon():GetClass() == "climb_swep2" or GetConVarNumber("climbswep2_roll_allweps") > 0) then
		return 0
	end

end)
