/*--------------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_projectile_base"
ENT.PrintName		= "[VJKS] Flechette Detonator"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Information		= "Projectiles for my addons"
ENT.Category		= "VJ Base"

ENT.Spawnable = true
ENT.AdminOnly = false

if (CLIENT) then
	local Name = "Imperial Stormtrooper Grenade"
	local LangName = "obj_vjks_stormgrenade"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

ENT.Model = {"models/KriegSyntax/imperial/stormtroopers/storm_items/storm_grenade.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.MoveCollideType = nil -- Move type | Some examples: MOVECOLLIDE_FLY_BOUNCE, MOVECOLLIDE_FLY_SLIDE
ENT.CollisionGroupType = nil -- Collision type, recommended to keep it as it is
ENT.SolidType = SOLID_VPHYSICS -- Solid type, recommended to keep it as it is
ENT.RemoveOnHit = false -- Should it remove itself when it touches something? | It will run the hit sound, place a decal, etc.
ENT.DoesRadiusDamage = true -- Should it do a blast damage when it hits something?
ENT.RadiusDamageRadius = 1 -- How far the damage go? The farther away it's from its enemy, the less damage it will do | Counted in world units
ENT.RadiusDamage = 0 -- How much damage should it deal? Remember this is a radius damage, therefore it will do less damage the farther away the entity is from its enemy
ENT.RadiusDamageUseRealisticRadius = true -- Should the damage decrease the farther away the enemy is from the position that the projectile hit?
ENT.RadiusDamageType = DMG_BLAST -- Damage type
ENT.RadiusDamageForce = 0 -- Put the force amount it should apply | false = Don't apply any force
ENT.DecalTbl_DeathDecals = {"Scorch"}
ENT.SoundTbl_OnCollide = {"weapons/grenade_bounce_1.ogg","weapons/grenade_bounce_2.ogg","weapons/grenade_bounce_3.ogg"}
ENT.SoundTbl_Idle = {"weapons/detonator_warning.wav"}

-- Custom
ENT.FussTime = 7
ENT.TimeSinceSpawn = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomPhysicsObjectOnInitialize(phys)
	phys:Wake()
	phys:EnableGravity(true)
	phys:SetBuoyancyRatio(0)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	//if self:GetOwner():IsValid() && (self:GetOwner().GrenadeAttackFussTime) then
	//timer.Simple(self:GetOwner().GrenadeAttackFussTime,function() if IsValid(self) then self:DeathEffects() end end) else
	timer.Simple(self.FussTime,function() if IsValid(self) then self:DeathEffects() end end)
	//end
	ParticleEffectAttach("vj_rpg2_smoke1", PATTACH_POINT_FOLLOW, self, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	self.TimeSinceSpawn = self.TimeSinceSpawn + 0.2
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage(dmginfo)
	if IsValid(self:GetPhysicsObject()) then
		self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.1)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPhysicsCollide(data,phys)
	getvelocity = phys:GetVelocity()
	velocityspeed = getvelocity:Length()
	//print(velocityspeed)
	if velocityspeed > 500 then -- Or else it will go flying!
		phys:SetVelocity(getvelocity * 0.9)
	end
	
	if velocityspeed > 10 then -- If the grenade is going faster than 100, then play the touch sound
		self:OnCollideSoundCode("weapons/detonator_warning.wav")
	end
	
	for i=1,5 do
		local nadeSplit = ents.Create("obj_vjks_flechette")
		nadeSplit:Spawn()
		if (IsValid(self:GetOwner())) then nadeSplit:SetOwner(self:GetOwner()) end
		nadeSplit:SetPos(data.HitPos + Vector(0,0,1))
		nadeSplit:SetAngles(data.HitNormal:Angle())
		nadeSplit:GetPhysicsObject():SetVelocity((-data.HitNormal + Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))):GetNormalized()*350)
	end

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	//effectdata:SetScale( 500 )
	util.Effect( "vjks_sw_effect_flechette", effectdata )
	util.Effect( "cball_explode", effectdata )


	self:Remove()
	
end
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.DaddyNade = true
ENT.FirstCollide = false
/*-----------------------------------------------
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/