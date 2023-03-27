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
	
		for i = 1,5 do
			local smoke1 = Emitter:Add("particle/smokesprites_000"..math.random(1,9),self.Pos)
			if (smoke1) then
			smoke1:SetVelocity(Vector(math.random(-20,40),math.random(-10,30),math.random(20,50)))
			smoke1:SetDieTime(math.Rand(4,7)) -- How much time until it dies
			smoke1:SetStartAlpha( math.Rand( 90, 100 ) )		
			smoke1:SetStartSize(math.Rand(1150,220)) -- Size of the effect
			smoke1:SetEndSize(math.Rand(1280,1405)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
			smoke1:SetRoll( math.random( -500, 500 )/100 )
			smoke1:SetRollDelta(math.Rand(-1,2)) -- How fast it rolls
			smoke1:SetCollide(true)
			smoke1:SetBounce( 1 )
			smoke1:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
			smoke1:SetColor( 90,83,68 )
		end
		
		
		for i=1,2 do 
		local FlashS = self.Emitter:Add( "effects/energyball", self.Pos )
		if (FlashS) then	
		FlashS:SetVelocity( self.DirVec*100 )
		FlashS:SetAirResistance( 200 )
		FlashS:SetDieTime( 0.08 )
		FlashS:SetStartAlpha( 255 )
		FlashS:SetEndAlpha( 0 )
		FlashS:SetStartSize( math.Rand( 240, 260 ) );
		FlashS:SetEndSize( math.Rand( 360, 380 ) );
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
		FlashS1:SetDieTime( 0.1 )
		FlashS1:SetStartAlpha( 255 )
		FlashS1:SetEndAlpha( 0 )
		FlashS1:SetStartSize( 10,50 )
		FlashS1:SetEndSize( 300 )
		FlashS1:SetRoll( math.Rand(180,480) )
		FlashS1:SetRollDelta( math.Rand(-1,1) )
		FlashS1:SetColor(255,255,255)	
		end
		end
		
		for i = 1, 25 do
			local floatingP1 = self.Emitter:Add( "particles/flamelet1", self.Pos );
			floatingP1:SetVelocity ( self.DirVec * math.random(320,600)*self.Scale + VectorRand():GetNormalized() * math.random(720,300)*self.Scale );
			floatingP1:SetDieTime( math.Rand( 0.1, 4.5 ) );
			floatingP1:SetStartAlpha( 255 );
			floatingP1:SetEndAlpha( 0 );
			floatingP1:SetStartSize( math.Rand( 1, 8 ) );
			floatingP1:SetEndSize( 0 );
			floatingP1:SetRoll( math.random( -500, 500 ) );
			floatingP1:SetGravity( Vector( 0, 0, -790) );
			floatingP1:SetCollide( true );
			floatingP1:SetBounce( 0.4 );
			floatingP1:SetAirResistance( 100 );
			floatingP1:SetColor(255,230,230)	
		end	
		
		for i=1, 3*self.Scale do
		local Debris1 = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris1) then
		Debris1:SetVelocity ( self.DirVec * math.random(0,800)*self.Scale + VectorRand():GetNormalized() * math.random(0,800)*self.Scale )
		Debris1:SetDieTime( math.random( 1, 5) * self.Scale )
		Debris1:SetStartAlpha( 255 )
		Debris1:SetEndAlpha( 255 )
		Debris1:SetStartSize( math.random(15,20)*self.Scale)
		Debris1:SetRoll( math.Rand(0, 360) )
		Debris1:SetRollDelta( math.Rand(-5, 5) )	
		Debris1:SetCollide(true)		
		Debris1:SetAirResistance( 40 ) 			 			
		Debris1:SetColor( 60,60,60 )
		Debris1:SetGravity( Vector( 0, 0, -200) ) 	
		end
		end
		
		for i=1, 5*self.Scale do
		local flame = self.Emitter:Add( "particles/flamelet1", self.Pos )
		if (flame) then
		flame:SetVelocity ( self.DirVec * math.random(0,800)*self.Scale + VectorRand():GetNormalized() * math.random(0,800)*self.Scale )
		flame:SetDieTime( math.random( 0.01, 0.09) )
		flame:SetStartAlpha( 255,109,203 )
		flame:SetEndAlpha( 0 )
		flame:SetStartSize( math.random(15,20)*self.Scale)
		flame:SetEndSize( 300 )
		flame:SetRoll( math.Rand(0, 360) )
		flame:SetRollDelta( math.Rand(-5, 5) )	
		flame:SetCollide(true)		
		flame:SetAirResistance( 80 ) 			 			
		flame:SetColor(255,205,195)	
		flame:SetGravity( Vector( 0, 0, -1) ) 	
		end
		end

		
		for i = 1, 1 do
			local particleS1 = self.Emitter:Add( "particles/flamelet1", self.Pos );
			particleS1:SetVelocity( ( self.Normal + VectorRand() * 0.95 ):GetNormal() * math.Rand( 2, 3 ) );
			particleS1:SetDieTime( math.Rand( 0.1, 0.5 ) );
			particleS1:SetStartAlpha( 255 );
			particleS1:SetEndAlpha( 0 );
			particleS1:SetStartSize( math.Rand( 1, 16 ) );
			particleS1:SetEndSize( 520 );
			particleS1:SetRoll( math.random( -500, 500 ) );
			particleS1:SetGravity((VectorRand():GetNormalized()*math.Rand(20, 2)* self.Size) + Vector(0,0,-20));
			particleS1:SetCollide( true );
			particleS1:SetBounce( 0.4 );
			particleS1:SetAirResistance( 5555 );
			particleS1:SetColor(255,145,95)	
		end
		
		
			sound.Play( "vjks/explosions/0" .. math.random(1, 9) .. ".ogg", self.Pos, 100, 100 )
		

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

