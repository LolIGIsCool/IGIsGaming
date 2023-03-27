AddCSLuaFile()

SWEP.PrintName = "Mortar"
SWEP.Base = "weapon_base"

SWEP.Author = "DolUnity"
SWEP.Purpose = "Place a Mortar"
SWEP.Instructions = "Place the mortar with attack \nPick it up with duck and use"
SWEP.Category = "DolUnity"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
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

function SWEP:PrimaryAttack()
    if (SERVER) then
        local ply = self.Owner
        if (ply:Alive() and IsValid(ply:GetActiveWeapon()) and (ply:GetActiveWeapon():GetClass() or ""):StartWith("mortar_constructor")) then
            local trace = ply:GetEyeTrace()
            local hitAngle = trace.HitNormal:Angle()

            local ent = ents.Create("mortar")
            ent:SetPos(trace.HitPos)
            ent:SetAngles(Angle(0,0,0))

            ent:SetLocalAngles(ent:WorldToLocalAngles(hitAngle) + Angle(90,0,0))

            ent:Spawn()
            if (ent:GetLocalAngles().x > 45 or ent:GetLocalAngles().z > 45) then
                ent:Remove()
            else
                ply:StripWeapon(self:GetClass())
            end
            self:OnSpawn(ent)
        end
    end
end

function SWEP:OnSpawn(ent)
end

function SWEP:SecondaryAttack() end

function SWEP:ShouldDrawViewModel()
    return false
end

function SWEP:DrawWorldModel()
end

hook.Add("PostDrawOpaqueRenderables", "DrawMortarPreview", function ()
    local ply = LocalPlayer()
    if (ply:Alive()
            and IsValid(ply:GetActiveWeapon())
            and (ply:GetActiveWeapon():GetClass() or ""):StartWith("mortar_constructor")
            and not ply:InVehicle()) then
        local weapon = ply:GetActiveWeapon()
        local trace = LocalPlayer():GetEyeTrace()
        weapon.PreviewModel:SetPos(trace.HitPos)
        weapon.PreviewModel:SetAngles(Angle(0,0,0))

        local hitAngle = trace.HitNormal:Angle()
        weapon.PreviewModel:SetLocalAngles(weapon.PreviewModel:WorldToLocalAngles(hitAngle) + Angle(90,0,0))

        if (weapon.PreviewModel:GetLocalAngles().x > 45 or weapon.PreviewModel:GetLocalAngles().z > 45) then
            weapon.Placeable = false
            render.SetColorModulation(255/255,0,0)
        else
            weapon.Placeable = true
            render.SetColorModulation(0,180/255,25/255)
        end
        weapon.PreviewModel:DrawModel()
        render.SetColorModulation(0,0,0)
    end
end)