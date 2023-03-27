AddCSLuaFile()

SWEP.PrintName = "Rangefinder"
SWEP.Base = "weapon_base"

SWEP.Author = "DolUnity"
SWEP.Purpose = "Get the Target Distance"
SWEP.Category = "DolUnity"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/maxofs2d/camera.mdl"
SWEP.HoldType = "camera"
SWEP.UseHands = true
SWEP.DrawAmmo = false

SWEP.Slot = 4

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClipSize = 0

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClipSize = 0

if (CLIENT) then
    SWEP.PreviewModel = ClientsideModel("models/dolunity/starwars/mortar.mdl")
    SWEP.PreviewModel:SetNoDraw(true)
    SWEP.PreviewModel:SetMaterial("models/wireframe")
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack() end

function SWEP:SecondaryAttack()
    if (not IsFirstTimePredicted()) then return end

    if (self.Zoom) then
        self.Owner:SetFOV(self.OldFOV, 0.5)
        self.Zoom = false
    else
        self.Zoom = true
        self.OldFOV = self.Owner:GetFOV()
        self.Owner:SetFOV(20, 0.5)
    end
end

function SWEP:ShouldDrawViewModel()
    return false
end

function SWEP:AdjustMouseSensitivity()
    if (self.Owner:GetFOV() == 20) then
        return 0.05
    end
    return 1
end

function SWEP:Deploy()
    self:SetHoldType(self.HoldType)
end

local laserPointer = Material("Sprites/light_glow02_add_noz")
hook.Add("PostDrawTranslucentRenderables", "swmRangeFinderLaser", function()
    if (LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "mortar_range_finder" and not LocalPlayer():InVehicle()) then
        local trace = LocalPlayer():GetEyeTrace()
        render.SetMaterial(laserPointer)
        render.DrawQuadEasy(trace.HitPos + trace.HitNormal, trace.HitNormal, 32, 32, Color(255,0,0),0)
    end
end)

local rangeTable = Material("models/dolunity/starwars/mortar_scale.png")
hook.Add("HUDPaint", "swmRangeFinderDistanceHUD", function ()
    if (LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "mortar_range_finder" and not LocalPlayer():InVehicle()) then
        local trace = LocalPlayer():GetEyeTrace()
        local dist = LocalPlayer():GetPos():Distance(trace.HitPos)

        surface.SetFont("swmFont")
        surface.SetTextColor(75, 255, 255)
        local mText = math.Round(dist / 40, 1) .. "m"
        local mWidth, mHeight = surface.GetTextSize(mText)
        surface.SetTextPos((ScrW() - mWidth) / 2, ScrH() / 2 + ScrH() * 0.03)
        surface.DrawText(mText)

        local rText = math.Round(math.abs((LocalPlayer():GetAngles().y + 360) % 360 - 360),2)
        local rWidth, rHeight = surface.GetTextSize(rText)
        surface.SetTextPos((ScrW() - rWidth) / 2, ScrH() / 2 + ScrH() * 0.03 + rHeight * 1.1)
        surface.DrawText(rText .. "°")

        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(rangeTable)
        local height = ScrH() * 0.462
        local width = height * 0.6
        surface.DrawTexturedRect(ScrW() * 0.02, (ScrH() - height) / 2, width, height)
    end
end)