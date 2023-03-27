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
	
		for i = 1,2 do
			local smoke1 = Emitter:Add("particle/smokesprites_000"..math.random(1,9),self.Pos)
			if (smoke1) then
			smoke1:SetVelocity(Vector(math.random(-20,40),math.random(-10,30),math.random(20,50)))
			smoke1:SetDieTime(math.Rand(3,10)) -- How much time until it dies
			smoke1:SetStartAlpha( math.Rand( 10, 70 ) )		
			smoke1:SetEndAlpha( math.Rand( 0, 1 ) )		
			smoke1:SetStartSize(math.Rand(10,20)) -- Size of the effect
			smoke1:SetEndSize(math.Rand(80,260)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
			smoke1:SetRoll( math.random( -500, 500 )/100 )
			smoke1:SetRollDelta(math.Rand(-1,2)) -- How fast it rolls
			smoke1:SetCollide(true)
			smoke1:SetBounce( 1 )
			smoke1:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
			smoke1:SetColor(150,150,150)
		end
		end
		
		for i=1,2 do 
		local FlashS = self.Emitter:Add( "effects/energyball", self.Pos )
		if (FlashS) then	
		FlashS:SetVelocity( self.DirVec*100 )
		FlashS:SetAirResistance( 200 )
		FlashS:SetDieTime( 0.08 )
		FlashS:SetStartAlpha( 255 )
		FlashS:SetEndAlpha( 0 )
		FlashS:SetStartSize( math.Rand( 40, 60 ) );
		FlashS:SetEndSize( math.Rand( 60, 80 ) );
		FlashS:SetRoll( math.Rand(180,480) )
		FlashS:SetRollDelta( math.Rand(-1,1) )
		FlashS:SetColor(255,0,0)	
		end
		end

		for i=1,2 do 
		local FlashS1 = self.Emitter:Add( "effects/energyball", self.Pos )
		if (FlashS1) then
		FlashS1:SetVelocity( self.DirVec*100 )
		FlashS1:SetAirResistance( 200 )
		FlashS1:SetDieTime( 0.15 )
		FlashS1:SetStartAlpha( 255 )
		FlashS1:SetEndAlpha( 0 )
		FlashS1:SetStartSize( self.Scale*20 )
		FlashS1:SetEndSize( 0 )
		FlashS1:SetRoll( math.Rand(180,480) )
		FlashS1:SetRollDelta( math.Rand(-1,1) )
		FlashS1:SetColor(255,255,255)	
		end
		end

		
		for i = 1, 1 do
			local particleS1 = self.Emitter:Add( "particles/flamelet1", self.Pos );
			particleS1:SetVelocity( ( self.Normal + VectorRand() * 0.95 ):GetNormal() * math.Rand( 2, 3 ) );
			particleS1:SetDieTime( math.Rand( 0.5, 2 ) );
			particleS1:SetStartAlpha( 255 );
			particleS1:SetEndAlpha( 0 );
			particleS1:SetStartSize( math.Rand( 1, 6 ) );
			particleS1:SetEndSize( 0 );
			particleS1:SetRoll( math.random( -500, 500 ) );
			particleS1:SetGravity((VectorRand():GetNormalized()*math.Rand(20, 2)* self.Size) + Vector(0,0,-20));
			particleS1:SetCollide( true );
			particleS1:SetBounce( 0.4 );
			particleS1:SetAirResistance( 5555 );
			particleS1:SetColor(255,145,95)	
		end
		
		
		for i = 1, 10 do
			local particleS2 = self.Emitter:Add( "particles/flamelet1", self.Pos );
			particleS2:SetVelocity ( self.DirVec * math.random(0,400)*self.Scale + VectorRand():GetNormalized() * math.random(0,400)*self.Scale );
			particleS2:SetDieTime( math.Rand( 0.1, 3.5 ) );
			particleS2:SetStartAlpha( 255 );
			particleS2:SetEndAlpha( 0 );
			particleS2:SetStartSize( math.Rand( 0.5, 1.5 ) );
			particleS2:SetEndSize( 0 );
			particleS2:SetRoll( math.random( -500, 500 ) );
			particleS2:SetGravity( Vector( 0, 0, -900) );
			particleS2:SetCollide( true );
			particleS2:SetBounce( 0.4 );
			particleS2:SetAirResistance( 10 );
			particleS2:SetColor(255,200,200)	
		end	


		for i = 1, 10 do
			local floatingP1 = self.Emitter:Add( "particles/flamelet1", self.Pos );
			floatingP1:SetVelocity ( self.DirVec * math.random(120,200)*self.Scale + VectorRand():GetNormalized() * math.random(220,100)*self.Scale );
			floatingP1:SetDieTime( math.Rand( 0.1, 1.5 ) );
			floatingP1:SetStartAlpha( 255 );
			floatingP1:SetEndAlpha( 0 );
			floatingP1:SetStartSize( math.Rand( 0.5, 1 ) );
			floatingP1:SetEndSize( 0 );
			floatingP1:SetRoll( math.random( -500, 500 ) );
			floatingP1:SetGravity( Vector( 0, 0, -10) );
			floatingP1:SetCollide( true );
			floatingP1:SetBounce( 0.4 );
			floatingP1:SetAirResistance( 1 );
			floatingP1:SetColor(255,230,230)	
		end	
		
		
		sound.Play( "krieg/weapons/impacts/blaster_impact_" .. math.random(1, 26) .. ".ogg", self.Pos, 80, 80 )
		
		local Angle = self.DirVec:Angle()

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


	return self.LifeTime > 0
end
