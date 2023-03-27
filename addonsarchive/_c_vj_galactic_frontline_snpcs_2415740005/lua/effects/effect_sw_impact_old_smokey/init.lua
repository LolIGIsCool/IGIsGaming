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

	-- particles
	local emitter = ParticleEmitter( self.Position );
	if( emitter ) then
		
		for i = 1, 5 do

			local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos );
			particle:SetVelocity( ( self.Normal + VectorRand() * 0.75 ):GetNormal() * math.Rand( 40, 500 ) );
			particle:SetDieTime( math.Rand( 0.5, 1.25 ) );
			particle:SetStartAlpha( 255 );
			particle:SetEndAlpha( 0 );
			particle:SetStartSize( math.Rand( 1, 5 ) );
			particle:SetEndSize( 0 );
			particle:SetRoll( math.random( -500, 500 )/100 );
			particle:SetGravity( Vector( 0, 0, -250 ) );
			particle:SetCollide( true );
			particle:SetBounce( 0.3 );
			particle:SetAirResistance( 1 );

		end
		emitter:Finish();
	end

		local Angle = self.DirVec:Angle()

		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 7) + (DustRing*math.Rand(1, 6))

			for k = 3, self.Particles do
			local Rcolor = math.random(10)

			local particle1 = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(.1, 1) * self.Size) + (RanVec*self.Size*k*math.Rand(0.01, 0.1)))	
			particle1:SetDieTime( math.Rand( 0.5, 1 )*self.Scale )	

			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(1, 2)* self.Size) + Vector(0,0,-100))
			particle1:SetAirResistance( math.Rand(100, 200) ) 		
			particle1:SetStartSize( 1 )
			particle1:SetEndSize( 10 )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetCollide(true)
			particle1:SetBounce( 1 )
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor(100, 100, 100, 100)
			end
			
			for k = 3, self.Particles do
			local Rcolor = math.random(10)

			local particle1 = self.Emitter:Add( "effects/yellowflare", self.Pos )
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(.1, 5) * self.Size) + (RanVec*self.Size*k*math.Rand(0.01, .05)))	
			particle1:SetDieTime( math.Rand( 0.5, 1 )*self.Scale )	

			particle1:SetStartAlpha( 255 )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(50, 2)* self.Size) + Vector(0,0,-100))
			particle1:SetAirResistance( math.Rand(200, 400) ) 		
			particle1:SetStartSize( 3 )
			particle1:SetEndSize( 0 )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetCollide(true)
			particle1:SetBounce( 1 )
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor(100, 100, 100, 100)
			end
		end

 		for i=0, 10*self.Scale do 
 		local Sparks = self.Emitter:Add( "effects/yellowflare", self.Pos ) 
 		if (Sparks) then 
 		Sparks:SetVelocity( ((self.DirVec*0.75)+VectorRand()) * math.Rand(40, 200)*self.Scale ) 
 		Sparks:SetDieTime( math.Rand(0.3, 1) ) 				 
 		Sparks:SetStartAlpha( 255 )  				 
 		Sparks:SetStartSize( math.Rand(1, 10) ) 
 		Sparks:SetEndSize( 0 ) 				 
 		Sparks:SetRoll( math.Rand(0, 360) ) 
 		Sparks:SetRollDelta( math.Rand(-5, 5) ) 				 
 		Sparks:SetAirResistance( 20 ) 
 		Sparks:SetGravity( Vector( 0, 0, -600 ) ) 
 		end 	
		end 
	
		
		for i=1,5 do 
		local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.15 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*50 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end
		
		sound.Play( "effects/sw_impact/sw752_hit_" .. math.random(1, 33) .. ".wav", self.Pos, 80, 80 )
		
		local Angle = self.DirVec:Angle()
	
	local emitter_s = ParticleEmitter( self.Position );
	if( emitter_s ) then
		for i = 1, 4 do
			
			local particle_s = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos );
			particle_s:SetVelocity((self.Normal+VectorRand()*10):GetNormal()*math.Rand(250, 5500));
			particle_s:SetDieTime(math.Rand(1, 20));
			particle_s:SetStartAlpha( 100 );
			particle_s:SetEndAlpha(0);
			particle_s:SetStartSize(math.Rand(20, 70));
			particle_s:SetEndSize(math.Rand(75, 80));
			particle_s:SetGravity(Vector(math.Rand(0, 100), math.Rand(250, 1000), math.Rand(-250, 250)));
			particle_s:SetRoll(math.Rand(0, 360));
			particle_s:SetRollDelta(math.Rand(-0.5, 0.5));
			local colour = math.Rand(50, 150);
			particle_s:SetColor(100, 100, 100, 100);
			particle_s:SetCollide(false);
			particle_s:SetAirResistance(2000);
		end
		emitter_s:Finish();
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


function EFFECT:Think()
	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()

	if DynamicTracer:GetBool() then
		local spawn = util.CRC(tostring(self:GetPos()))
		local dlight = DynamicLight(self:EntIndex() + spawn)
		local endDistance = self.Speed * self.StartTime
		local endPos = self.StartPos + self.Normal * endDistance

		if (dlight) then
			dlight.pos = endPos
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.brightness = 5
			dlight.Decay = 1000
			dlight.Size = 200
			dlight.nomodel = 1
			dlight.style = 6
			dlight.DieTime = CurTime() + 3
		end
	end

	return self.LifeTime > 0
end