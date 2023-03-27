

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "A280C"			
	SWEP.Author				= "Imperial Gaming Dev's"
	SWEP.ViewModelFOV		= 50
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.WepSelectIcon 		= surface.GetTextureID("HUD/killicons/A280")
	
	killicon.Add( "weapon_752bf3_A280", "HUD/killicons/A280", Color( 255, 80, 0, 255 ) )

end

SWEP.HoldType				= "ar2"
SWEP.Base					= "tfa_swsft_base"

SWEP.Category = "TFA Star Wars"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.UseHands = true

SWEP.ViewModel				= "models/weapons/synbf3/c_a280.mdl"
SWEP.WorldModel				= "models/weapons/synbf3/w_a280.mdl"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Sound = Sound ("weapons/synbf3/a280_fire.wav");
SWEP.Primary.ReloadSound = Sound ("weapons/synbf3/a280_reload.wav");

SWEP.Primary.Recoil			= 0.25
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.0125
SWEP.Primary.ClipSize			= 35
SWEP.Primary.Delay			= 0.17
SWEP.Primary.DefaultClip		= 60
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.TracerName = "effect_sw_laser_red"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"



--IRON SIGHT SETTINGS
SWEP.IronSightsPos = Vector(-4.75, -8.612, 1.267)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.IronSightTime = 0.3 --The time to enter ironsights/exit it.
SWEP.Scoped				= true  --Draw a scope overlay?
SWEP.Secondary.IronFOV			= 30					-- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_thompson.root5", rel = "", pos = Vector(-9.931, -2.225, 0.28), angle = Angle(0, -180, 0), size = Vector(0.18, 0.18, 0.18), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}

local function  drawFilledCircle( x, y, radius, seg )
	local kirkle = {}

	table.insert(kirkle, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert(kirkle, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert(kirkle, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly(kirkle)
end
	
local weaponcol = Color(0.435*255,0.10*255,0.7*255,255)

local ceedee = {}

SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment

SWEP.RTOpaque = true

local g36
if surface then
	g36 = surface.GetTextureID("scope/gdcw_nvgilluminatedduplex") --the texture you vant to use
end

SWEP.RTCode = function( self, mat )
	
	render.OverrideAlphaWriteEnable( true, true)
	surface.SetDrawColor(color_white)
	surface.DrawRect(-256,-256,512,512)
	render.OverrideAlphaWriteEnable( true, true)
	
	local ang = self.Owner:EyeAngles()
	
	local AngPos = self.Owner:GetViewModel():GetAttachment(1)
	
	if AngPos then
	
		ang = AngPos.Ang
		
		ang:RotateAroundAxis(ang:Right(), 0)
		ang:RotateAroundAxis(ang:Up(), 0.1)

	end
	

	
	ceedee.angles = ang
	ceedee.origin = self.Owner:GetShootPos()
	
	ceedee.x = 0
	ceedee.y = 0
	ceedee.w = 512	
	ceedee.h = 512
	ceedee.fov = 6
	ceedee.drawviewmodel = false
	ceedee.drawhud = false
	
	
	if self.CLIronSightsProgress>0.01 then
		render.RenderView(ceedee)
	end
		
	render.OverrideAlphaWriteEnable( false, true)
	
	
	cam.Start2D()
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(color_black,0))
		surface.DrawTexturedRect(0,0,512,512)
		surface.SetDrawColor(color_white)
		surface.SetTexture(g36)
		surface.DrawTexturedRect(-256,-256,1024,1024)
		draw.NoTexture()
		surface.SetDrawColor(ColorAlpha(color_black,(1-self.CLIronSightsProgress)*255))
		surface.DrawTexturedRect(0,0,512,512)
	cam.End2D()
	
end


SWEP.IronSightsSensitivity = 0.25 --Useful for a RT scope.  Change this to 0.25 for 25% sensitivity.  This is if normal FOV compenstaion isn't your thing for whatever reason, so don't change it for normal scopes.
SWEP.BlowbackVector = Vector(0,-1,0.05)