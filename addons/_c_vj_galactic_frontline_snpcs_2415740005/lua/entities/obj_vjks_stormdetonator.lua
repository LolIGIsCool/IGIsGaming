/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "[VJKS] Stormtrooper Detonator"
ENT.Author 			= "Krieg"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.VJ_IsDetectableDanger = true
ENT.VJ_IsPickupableDanger = true

if CLIENT then
	local Name = "Detonator"
	local LangName = "obj_vjks_stormdetonator"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/krieg/galacticempire/props/storm_grenade.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = nil -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = nil -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_VPHYSICS -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 250 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 80 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 90 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_OnCollide = {"weapons/grenade_bounce_1.ogg","weapons/grenade_bounce_2.ogg","weapons/grenade_bounce_3.ogg"}
ENT.SoundTbl_Idle = {"weapons/detonator_warning.wav"}

-- Custom
ENT.FussTime = 3
ENT.TimeSinceSpawn = 0



local trail_lifetime = 1.5
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetBuoyancyRatio(0)
end

function ENT:CustomOnInitialize()
    self:SetNoDraw(true)

    self.grenadeprop = ents.Create("prop_dynamic")
    self.grenadeprop:SetModel("models/krieg/galacticempire/props/storm_grenade.mdl")
    self.grenadeprop:SetPos(self:GetPos())
    self.grenadeprop:SetAngles(self:GetAngles())
    self.grenadeprop:SetParent(self)
    self.grenadeprop:Spawn()

    util.SpriteTrail(self.grenadeprop, 0, Color(255,0,0), true, 12, 0, trail_lifetime, 0.008, "trails/laser")
	
	timer.Simple(self.FussTime,function() if IsValid(self) then self:DeathEffects() end end)
end



function ENT:DeathEffects()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
--	util.Effect( "HelicopterMegaBomb", effectdata )
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "Explosion", effectdata )
	util.Effect( "WheelDust", effectdata )
	util.Effect( "ManhackSparks", effectdata )
	util.Effect( "vjks_sw_effect_explosion_big", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self:GetPos())
	self.ExplosionLight1:SetLocalAngles( self:GetAngles() )
	self.ExplosionLight1:Fire("Color", "255 150 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
	start = self:GetPos(),
	endpos = self:GetPos() - Vector(0, 0, 100),
	filter = self })
	util.Decal(VJ_PICK(self.DecalTbl_DeathDecals),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	
	self:DoDamageCode()
	self:SetDeathVariablesTrue(nil,nil,false)
	self:Remove()
end