AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Tibanna Charge Pack"
ENT.Category = "Osmonium Armory"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.UseTimer = CurTime()

ENT.Model = "models/cs574/objects/ammo_box.mdl"

function ENT:SpawnFunction( ply, tr, ClassName )
if ( !tr.Hit ) then return end
    local SpawnPos = tr.HitPos + tr.HitNormal * 10
    pAngle = ply:GetAngles()
    pAngle.pitch = pAngle.pitch
    pAngle.roll = pAngle.roll 
    pAngle.yaw = pAngle.yaw + 180
    local ent = ents.Create( ClassName ) 
    ent:SetPos( SpawnPos - Vector(0,0,-10) )
    ent:SetAngles( pAngle )
    ent:Spawn()
    ent:Activate()
    return ent	
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    if SERVER then
        self:SetModel( "models/cs574/objects/ammo_box.mdl" )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:DrawShadow( true )

        local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end
        self:SetTrigger(true)
        
    end
end

function ENT:Use( activator, caller )
    if self.UseTimer <= CurTime() and activator:IsPlayer() then
		local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType()
		local ammoName = game.GetAmmoName(ammoType)
        local ammoAmount = activator:GetAmmoCount(ammoType)
		if activator:GetActiveWeapon().IsTFAWeapon then
			if ammoName == "light_battery" then
				activator:GiveAmmo(200, ammoType, false )
			elseif ammoName == "standard_battery" then
				activator:GiveAmmo(400, ammoType, false )
			elseif ammoName == "heavy_battery" then
				activator:GiveAmmo(750, ammoType, false )
			elseif ammoName == "high_power_battery" then
				activator:GiveAmmo(50, ammoType, false )
			elseif ammoName == "Grenade" then
				activator:GiveAmmo(2, ammoType, false )
			elseif ammoName == "RPG_Round" and ammoAmount < 4 then
				activator:GiveAmmo(1, ammoType, false )
			end
			
			self:Remove()
		end
    end
end

function ENT:PhysicsCollide( data, phys )
end