if CLIENT then
	SWEP.PrintName = "Active Camouflage"
	SWEP.Author = "Master Pro11™"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.WepSelectIcon = surface.GetTextureID("camo/camo_wepselecticon.vmt")
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.DrawAmmo = false

SWEP.HoldType = "normal"
SWEP.Category = "Master's Weapons"
SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic= false

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

local CamoActivate = Sound("camo/camo_on.wav")
local CamoDeactivate = Sound("camo/camo_off.wav")

local CamoMat = "camo/camo_shade.vmt"
local CamoOverlayMat = "camo/camo_overlay.vmt"
local CamoIconMat = "camo/camo_icon.vmt"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

local camoplayers = {}

-- A list of weapons to be hidden when a player enters cloak
local cloakableWeapons = {
	"rw_sw_e11sp",
	"rw_sw_t21",
	"rw_sw_t21b"
}

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)

	local CamoIsOn = self.Owner:GetNWBool("CamoEnabled")

	if SERVER then
		self.Owner:SetNWBool("CamoEnabled",!CamoIsOn)
		if CamoIsOn then
			table.remove( camoplayers, self.Owner:EntIndex() )
			self.Owner:SetNoDraw( false )

			for k, v in pairs(cloakableWeapons) do -- Unhide weapons
				if (self.Owner:HasWeapon(v)) then
					self.Owner:GetWeapon(v):SetNoDraw(false)
				end
			end
		else
			camoplayers[ self.Owner:EntIndex() ] = self.Owner
			self.Owner:SetNoDraw( true )

			for k, v in pairs(cloakableWeapons) do -- Hide Weapons
				if (self.Owner:HasWeapon(v)) then
					self.Owner:GetWeapon(v):SetNoDraw(true)
				end
			end
		end
	end
end

if CLIENT then
	local colorMofify = {
		["$pp_colour_addr"] = 0,
		["$pp_colour_addg"] = 0,
		["$pp_colour_addb"] = 0,
		["$pp_colour_brightness"] = 0,
		["$pp_colour_contrast"] = 1,
		["$pp_colour_colour"] = 0,
		["$pp_colour_mulr"] = 0,
		["$pp_colour_mulg"] = 0,
		["$pp_colour_mulb"] = 0,
	}

	local function DrawCamoEffects()
		if LocalPlayer():GetNWBool("CamoEnabled") then
			DrawColorModify(colorMofify)
			DrawMotionBlur(0.1, 0.5, 0.01)
			DrawToyTown(2,ScrH()/2)
		end
	end
	hook.Add("RenderScreenspaceEffects","ShowCamoEffects",DrawCamoEffects)

	local CamoOverlayID = surface.GetTextureID(CamoOverlayMat)
	local CamoIconID = surface.GetTextureID(CamoIconMat)
	local CamoIconSize = ScrH()/5
	local CamoIconY = (ScrH()/2)+(ScrH()/5)
	local CamoIconX = (ScrW()/2)-(CamoIconSize/2)

	local function DrawCamoItems()
	end
	hook.Add("HUDPaint","DrawActiveCamoItems",DrawCamoItems)

	local function DrawPlayerMaterial(ply)
		if ply:GetNWBool("CamoEnabled") then
			  ply:SetMaterial(CamoMat)
			  ply:DrawShadow(false)
		end
	end
	hook.Add("PrePlayerDraw","DrawPlayerCamo",DrawPlayerMaterial)

	local function UndoPlayerMaterial(ply)
		ply:SetMaterial("")
		ply:DrawShadow(true)
	end
	hook.Add("PostPlayerDraw","UndoPlayerCamo",UndoPlayerMaterial)
end

hook.Add( "PlayerFootstep", "MuteCamouflagedFootsteps", function( ply, pos, foot, sound, volume, rf )
	if ply:GetNWBool("CamoEnabled") then
		return true
	end
end)

if SERVER then
	local nextrun = 0
	local function CheckPlayerStill()
		if nextrun > CurTime() then return end
		nextrun = CurTime() + 1
		for k,v in next, camoplayers do
			if !IsValid( v ) then
				table.remove( camoplayers, k )
			continue end
			if !v:GetNWBool("CamoEnabled") then
				table.remove( camoplayers, k )
			continue end
			if v:GetVelocity():LengthSqr() < 12100 or v:Crouching() then
				v:SetNoDraw(true)
				v:GetActiveWeapon():SetNoDraw(true)
			else
				v:SetNoDraw(false)
				v:GetActiveWeapon():SetNoDraw(false)
			end
		end
	end
	hook.Add("Think","SetPlayerCamoAlpha",CheckPlayerStill)

	local function CheckPlayerDead(ply)
		if ply:GetNWBool("CamoEnabled") then
			ply:SetNWBool("CamoEnabled",false)
		end
	end
	hook.Add("PlayerDeath","RemoveDeadPlayerCamo",CheckPlayerDead)

	local function TakeDoubleDamage(ply, dmginfo)
		if ply:GetNWBool("CamoEnabled") then
			dmginfo:ScaleDamage( 1.25 )
		end
		--Moose
	end
	hook.Add("EntityTakeDamage","CamoTakeDoubleDamage",TakeDoubleDamage)
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + .2)
	self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
	return false
end

function SWEP:Reload()
	return
end
