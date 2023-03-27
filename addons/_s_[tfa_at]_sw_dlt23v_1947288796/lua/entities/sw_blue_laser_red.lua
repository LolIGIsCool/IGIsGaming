if SERVER then AddCSLuaFile() end

ENT.Type = "anim"
ENT.PrintName = "Blue Red Blaster Bolt"
ENT.Author = "kev675243"
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true

ENT.doEffect = true
ENT.Damage = 25
ENT.Delay = 10
ENT.Radius = 3
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local MaterialMain			= Material( "effects/sw_laser_red_main" );
local MaterialFront			= Material( "effects/sw_laser_red_front" );

if SERVER then
	function ENT:Initialize()
		local mdl = self:GetModel()

		if mdl == "" or mdl == "models/error.mdl" then
			self:SetModel("models/weapons/w_eq_fraggrenade.mdl")
		end
		self.flightvector = self:GetForward() * 10
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInitSphere(self.Radius, "default_silent")
		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableDrag(false)
			phys:EnableGravity(false)
			phys:SetMass(1)
		end
		self.DieTime = CurTime() + self.Delay
		self:DrawShadow(false)
-----------------------------------------Light Code-------------------------------------------------------------------------
		self.lighteffect = ents.Create("light_dynamic")
		self.lighteffect:SetPos( self:GetPos() )
		self.lighteffect:SetOwner( self )
		self.lighteffect:SetParent(self)
		self.lighteffect:SetKeyValue( "_light", "255 0 0 0" )  
		self.lighteffect:SetKeyValue("distance", "96" )
		self.lighteffect:SetKeyValue( "brightness", "4" ) 
		self.lighteffect:Spawn()
----------------------------------------------------------------------------------------------------------------------------
	end

	function ENT:Think()
		self.flightvector = self:GetForward() * 10
		local trace = {}
		trace.start = self:GetPos()
		trace.endpos = self:GetPos() + self.flightvector
		trace.filter = self
		local tr = util.TraceLine( trace )
		if tr.HitSky then
			self.doEffect = false
		else
			self.doEffect = true
		end
		if CurTime() > self.DieTime then return false end
		self:NextThink(CurTime())

		return true
	end

	function ENT:PhysicsCollide(colData, collider)
		timer.Simple(0, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
			
		if self.doEffect then
			util.Decal( "fadingscorch", colData.HitPos + colData.HitNormal, colData.HitPos - colData.HitNormal );
		end
		if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then
			local soundToPlay = "effects/sw_impact/sw752_hit_24.wav"
			local randomSound = math.random(1,24)
			if randomSound == 1 then
				soundToPlay = "effects/sw_impact/sw752_hit_01.wav"
			elseif randomSound == 2 then
				soundToPlay = "effects/sw_impact/sw752_hit_02.wav"
			elseif randomSound == 3 then
				soundToPlay = "effects/sw_impact/sw752_hit_03.wav"
			elseif randomSound == 4 then
				soundToPlay = "effects/sw_impact/sw752_hit_04.wav"
			elseif randomSound == 5 then
				soundToPlay = "effects/sw_impact/sw752_hit_05.wav"
			elseif randomSound == 6 then
				soundToPlay = "effects/sw_impact/sw752_hit_06.wav"
			elseif randomSound == 7 then
				soundToPlay = "effects/sw_impact/sw752_hit_07.wav"
			elseif randomSound == 8 then
				soundToPlay = "effects/sw_impact/sw752_hit_08.wav"
			elseif randomSound == 9 then
				soundToPlay = "effects/sw_impact/sw752_hit_09.wav"
			elseif randomSound == 10 then
				soundToPlay = "effects/sw_impact/sw752_hit_10.wav"
			elseif randomSound == 11 then
				soundToPlay = "effects/sw_impact/sw752_hit_11.wav"
			elseif randomSound == 12 then
				soundToPlay = "effects/sw_impact/sw752_hit_12.wav"
			elseif randomSound == 13 then
				soundToPlay = "effects/sw_impact/sw752_hit_13.wav"
			elseif randomSound == 14 then
				soundToPlay = "effects/sw_impact/sw752_hit_14.wav"
			elseif randomSound == 15 then
				soundToPlay = "effects/sw_impact/sw752_hit_15.wav"
			elseif randomSound == 16 then
				soundToPlay = "effects/sw_impact/sw752_hit_16.wav"
			elseif randomSound == 17 then
				soundToPlay = "effects/sw_impact/sw752_hit_17.wav"
			elseif randomSound == 18 then
				soundToPlay = "effects/sw_impact/sw752_hit_18.wav"
			elseif randomSound == 19 then
				soundToPlay = "effects/sw_impact/sw752_hit_19.wav"
			elseif randomSound == 20 then
				soundToPlay = "effects/sw_impact/sw752_hit_20.wav"
			elseif randomSound == 21 then
				soundToPlay = "effects/sw_impact/sw752_hit_21.wav"
			elseif randomSound == 22 then
				soundToPlay = "effects/sw_impact/sw752_hit_22.wav"
			elseif randomSound == 23 then
				soundToPlay = "effects/sw_impact/sw752_hit_23.wav"
			elseif randomSound == 24 then
				soundToPlay = "effects/sw_impact/sw752_hit_24.wav"
			end
			
			local effect = EffectData();
			effect:SetOrigin( colData.HitPos );
			effect:SetNormal( colData.HitNormal );

			util.Effect( "effect_sw_impact_2", effect );
			sound.Play( soundToPlay, colData.HitPos, 75, 100, 1 );
			
			local trace = {}
			trace.start = self:GetPos()
			trace.endpos = self:GetPos() --+ self.flightvector
			trace.filter = self
			local tr = util.TraceLine( trace )
			local effect = EffectData();
			effect:SetOrigin( tr.HitPos );
			effect:SetStart( tr.StartPos );
			effect:SetDamageType( DMG_BULLET );

			util.Effect( "RagdollImpact", effect );
		end

		local ow = self:GetOwner()

		if IsValid(ow) then
				local d = DamageInfo()
				d:SetAttacker(ow)
				local inf = ow
				if ow.GetActiveWeapon and IsValid( ow:GetActiveWeapon() ) then inf = ow:GetActiveWeapon() end
				d:SetInflictor( inf )
				d:SetDamage(self.Damage)
				colData.Normal = colData.OurOldVelocity
				colData.Normal:Normalize()
				d:SetDamageForce( colData.Normal * self.Damage * 100)
				d:SetDamageType(DMG_BULLET)
				d:SetDamagePosition( colData.HitPos )
				if colData.HitEntity and colData.HitEntity:IsValid() then
					colData.HitEntity:DispatchTraceAttack(d,util.QuickTrace(colData.HitPos,-colData.HitNormal * 32,self),colData.Normal)
				end
		end
	end
end

if CLIENT then
	function ENT:Draw()
	end
	function ENT:DrawTranslucent()
		local vector = self:GetVelocity()
		vector:Div(101.5625)
		render.SetMaterial( MaterialFront );
		render.DrawSprite( self:GetPos() - vector, 8, 8, color_white );

		render.SetMaterial( MaterialMain );
		render.DrawBeam( self:GetPos(), self:GetPos() - vector, 10, 0, 1, color_white );
	end
end
