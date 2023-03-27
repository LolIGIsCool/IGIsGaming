EFFECT.Duration			= 0.1;
EFFECT.Size				= 20;
EFFECT.Speed 				= 6500;



local MaterialGlow		= Material( "effects/sw_laser_bit" );
local DynamicTracer 		= GetConVar("cl_dynamic_tracer")

function EFFECT:GetTracerOrigin(data)
	-- this is almost a direct port of GetTracerOrigin in fx_tracer.cpp
	local start = data:GetStart()

	-- use attachment?
	if (bit.band(data:GetFlags(), TRACER_FLAG_USEATTACHMENT) == TRACER_FLAG_USEATTACHMENT) then
		local entity = data:GetEntity()
		if (not IsValid(entity)) then return start end
		if (not game.SinglePlayer() and entity:IsEFlagSet(EFL_DORMANT)) then return start end

		if (entity:IsWeapon() and entity:IsCarriedByLocalPlayer()) then
			-- can't be done, can't call the real function
			-- local origin = weapon:GetTracerOrigin()
			-- if( origin ) then
			-- 	return origin, angle, entity
			-- end
			-- use the view model
			local pl = entity:GetOwner()

			if (IsValid(pl)) then
				local vm = pl:GetViewModel()

				if (IsValid(vm) and not LocalPlayer():ShouldDrawLocalPlayer()) then
					entity = vm
					-- HACK: fix the model in multiplayer
				else
					if (entity.WorldModel) then
						entity:SetModel(entity.WorldModel)
					end
				end
			end
		end

		local attachment = entity:GetAttachment(data:GetAttachment())

		if (attachment) then
			start = attachment.Pos
		end
	end

	return start
end



function EFFECT:Init( data )


	self.StartPos = self:GetTracerOrigin(data)
	self.Position = data:GetOrigin();
	self.Normal = data:GetNormal();
	self.LifeTime = self.Duration;
	self.StartTime = 0;

	self.DebrizzlemyNizzle 	= math.Rand( 0, 2 )+data:GetScale()		// Debrizzle my Nizzle is how many "trails" to make						//
	self.Particles 		= data:GetMagnitude()		// Particles determines how many puffs to make, primarily for "trails"	//
	self.Entity 		= data:GetEntity()			// Entity determines what is creating the dynamic light					//

	self.Pos 		= data:GetOrigin()				// Origin determines the global position of the effect					//

	self.Scale 		= data:GetScale()				// Scale determines how large the effect is								//
	self.Radius 		= data:GetRadius() or 1		// Radius determines what type of effect to create, default is Concrete	//

	self.DirVec 		= data:GetNormal()			// Normal determines the direction of impact for the effect				//
	self.PenVec 		= data:GetStart()			// PenVec determines the direction of the round for penetrations		//
	self.Angle 		= self.DirVec:Angle()			// Angle is the angle of impact from Normal								//

	self.Emitter 	= ParticleEmitter( self.Pos )	// Emitter must be there so you don't get an error						//



	local emitter = ParticleEmitter( self.Position );
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	if( emitter ) then
		

		emitter:Finish();
	end
	
		for i = 1,4 do
			local smoke1 = Emitter:Add("particle/smokesprites_000"..math.random(1,9),self.Pos)
			if (smoke1) then
			smoke1:SetVelocity(Vector(math.random(-20,40),math.random(-10,30),math.random(20,50)))
			smoke1:SetDieTime(math.Rand(10,17)) -- How much time until it dies
			smoke1:SetStartAlpha( math.Rand( 90, 255 ) )		
			smoke1:SetStartSize(math.Rand(310,720)) -- Size of the effect
			smoke1:SetEndSize(math.Rand(720,805)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
			smoke1:SetRoll( math.random( -500, 500 )/100 )
			smoke1:SetRollDelta(math.Rand(-1,2)) -- How fast it rolls
			smoke1:SetCollide(true)
			smoke1:SetBounce( 1 )
			smoke1:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
			smoke1:SetColor( 90,83,68 )
		end
		
		for i=0, 5*self.Scale do		// This is the main plume
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity(Vector(math.random(-1220,1240),math.random(-1210,1230),math.random(-1320,1350)))
		Smoke:SetDieTime( math.Rand( 1 , 5 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 100, 120 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 50*self.Scale )
		Smoke:SetEndSize( 120*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-1, 1) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( 0, 0, math.Rand(-20, -100) ) ) 			
		Smoke:SetColor( 90,83,68 )
		end
		end
		
		for i=1, 8*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(0,800)*self.Scale + VectorRand():GetNormalized() * math.random(0,800)*self.Scale )
		Debris:SetDieTime( math.random( 1, 7) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 255 )
		Debris:SetStartSize( math.random(5,12)*self.Scale)
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )	
		Debris:SetCollide(true)		
		Debris:SetAirResistance( 40 ) 			 			
		Debris:SetColor( 60,60,60 )
		Debris:SetGravity( Vector( 0, 0, -200) ) 	
		end
		end
		
		
		for i=1,2 do 
		local FlashS = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (FlashS) then	
		FlashS:SetVelocity( self.DirVec*100 )
		FlashS:SetAirResistance( 200 )
		FlashS:SetDieTime( 0.08 )
		FlashS:SetStartAlpha( 255 )
		FlashS:SetEndAlpha( 0 )
		FlashS:SetStartSize( math.Rand( 112, 3150 ) );
		FlashS:SetEndSize( math.Rand( 10, 28 ) );
		FlashS:SetRoll( math.Rand(180,480) )
		FlashS:SetRollDelta( math.Rand(-1,1) )
		FlashS:SetColor(255,255,255)	
		end
		end
		
		
		sound.Play( "vjks_ww2/explosions/explosion_large_far-0" .. math.random(1, 4) .. ".ogg", self.Pos, 100, 180, 1 )

		local Angle = self.DirVec:Angle()

end
end

function EFFECT:Think()

	self.LifeTime = self.LifeTime - FrameTime();
	return self.LifeTime > 0;

end


function EFFECT:Render()

	local frac = math.max( 0, self.LifeTime / self.Duration );
	local rgb = 255 * frac;
	local color = Color( rgb, rgb, rgb, 255 );

	render.SetMaterial( MaterialGlow );
	render.DrawQuadEasy( self.Position + self.Normal, self.Normal, self.Size, self.Size, color );

end

