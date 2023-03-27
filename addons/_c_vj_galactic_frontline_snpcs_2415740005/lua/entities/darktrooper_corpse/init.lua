if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/
ENT.Model = {"models/weapons/w_missile_launch.mdl"}
ENT.BloodType = "Red"
ENT.Collide_Decal = "Default"
ENT.Collide_DecalChance = 3
ENT.CollideSound = "Default" -- Make it a table to use custom sounds!
ENT.CollideSoundLevel = 60
ENT.CollideSoundPitch1 = 80
ENT.CollideSoundPitch2 = 100

ENT.IsVJBaseCorpse = true
ENT.theflyingcorpse = NULL
ENT.ExplodeNextT = 0
ENT.ExplodeNexttime = 2.5
ENT.CorpseVelUpmax = 240
ENT.CorpseVelUpmin = 180
ENT.CorpseVelR = 180
ENT.CorpseVelF = 200
ENT.CorpseVelMax = 1600
ENT.CorpseFlySound = {"kstrudel/imps/jetpack_death_01.wav",
					"kstrudel/imps/jetpack_death_02.wav",
					"kstrudel/imps/jetpack_death_03.wav",
					"kstrudel/imps/jetpack_death_04.wav",
					"kstrudel/imps/jetpack_death_05.wav",
					"kstrudel/imps/jetpack_death_06.wav",
					"kstrudel/imps/jetpack_death_07.wav",
					"kstrudel/imps/jetpack_death_08.wav",
					"kstrudel/imps/jetpack_death_09.wav",
					"kstrudel/imps/jetpack_death_10.wav",
					"kstrudel/imps/jetpack_death_11.wav",
					"kstrudel/imps/jetpack_death_12.wav"}
ENT.CorpseSoundNextT = 0
ENT.CorpseSoundNexttime = 20
ENT.CorpseOriginalZ = nil
ENT.CorpseOriginalZLimit = 600
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Initialize()
	//self:SetModel("models/spitball_medium.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetMaterial("models/effects/vol_light001.mdl")
	self:DrawShadow(false)
	
	self.ExplodeNextT = CurTime() + self.ExplodeNexttime
	self.ExplodeCollideNextT = CurTime() + 1.25
	
	if GetConVarNumber("vj_npc_gibcollidable") == 0 then self:SetCollisionGroup(1) end

	-- Physics Functions
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		//phys:EnableGravity(false)
		//phys:EnableDrag(false)
		//phys:SetBuoyancyRatio(0)
	end

	-- Misc
	self:SetUpInitializeBloodType()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpInitializeBloodType()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Think()

	if IsValid(self.theflyingcorpse) then

	if self.CorpseOriginalZ == nil then
		self.CorpseOriginalZ = self.theflyingcorpse:GetPos().z
	end
	
	local velocityspeed = 0
	local physc = self.theflyingcorpse:GetPhysicsObject()
	if (physc:IsValid()) then
		--phys:Wake()
		velocityspeed = physc:GetVelocity():Length()
		local xvel = math.random(-self.CorpseVelF,self.CorpseVelF)*10*physc:GetMass()
		local yvel = math.random(-self.CorpseVelR,self.CorpseVelR)*10*physc:GetMass()
		local zvel = math.random(self.CorpseVelUpmin,self.CorpseVelUpmax)*10*physc:GetMass()
		
		local forcevel = Vector(xvel,yvel,zvel)
		if self.theflyingcorpse:GetPos().z-self.CorpseOriginalZ >= self.CorpseOriginalZLimit then forcevel = Vector(xvel*1.2,yvel*1.2,zvel*-0.1) end
		
		if velocityspeed < self.CorpseVelMax then
			physc:ApplyForceCenter( forcevel ) 
		end
		
		if CurTime() > self.ExplodeCollideNextT then
		
			if velocityspeed < 320 then
				self:CorpseExplode(self.theflyingcorpse)
			end
			
		end
		
	end
		if CurTime() > self.CorpseSoundNextT then
		if self.HasSounds != false then
		local soundtbl = self.CorpseFlySound
			if VJ_PICKRANDOMTABLE(soundtbl) != false then
				self.CurrentMeleeAttackSound = VJ_CreateSound(self.theflyingcorpse,soundtbl,95,100)
			end
		self.CorpseSoundNextT = CurTime() + self.CorpseSoundNexttime
		end
		end
		
		
	end
	
	
	
	if CurTime() > self.ExplodeNextT then
		self:CorpseExplode(self.theflyingcorpse)
	end
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	-- Effects
	local velocityspeed = phys:GetVelocity():Length()
	--local pickcollidesd = VJ_PICK(self.CollideSound)
	if velocityspeed > 18 then
		--self.collidesd = CreateSound(self,pickcollidesd)
		--self.collidesd:SetSoundLevel(self.CollideSoundLevel)
		--self.collidesd:PlayEx(1,math.random(self.CollideSoundPitch1,self.CollideSoundPitch2))
		
		
	end
	
	
	
	if GetConVarNumber("vj_npc_nogibdecals") == 0 && velocityspeed > 18 then
		//local start = data.HitPos + data.HitNormal
		//local endpos = data.HitPos - data.HitNormal
		if !data.Entity && math.random(1,self.Collide_DecalChance) == 1 then
			self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self:GetPos() - (data.HitNormal * -30),
				filter = self //function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			})
			if self.Collide_Decal != "" then
				util.Decal(self.Collide_Decal,tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
				//util.Decal(self.Collide_Decal,start,endpos)
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnTakeDamage(dmginfo)
	--self:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce()*0.1)
end

function ENT:CorpseExplode(Corpse)
	
	if IsValid(self.theflyingcorpse) then
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self.theflyingcorpse:GetPos())
	effectdata:SetScale( 0.3 )
	util.Effect( "HelicopterMegaBomb", effectdata )
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "Explosion", effectdata )
	util.Effect( "vjks_sw_effect_explosion_jumppack", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self.theflyingcorpse:GetPos())
	self.ExplosionLight1:SetLocalAngles(self:GetAngles())
	self.ExplosionLight1:Fire("Color", "255 150 0")
--	self.ExplosionLight1:SetParent(self.theflyingcorpse:GetPos())
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
	
	self.theflyingcorpse:Remove()
	
	
	end
	
	
	self:Remove()
	
end




/*--------------------------------------------------
	=============== Gib Base ===============
	*** Copyright (c) 2012-2020 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used as a base for gibs
--------------------------------------------------*/
