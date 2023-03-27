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
		FlashS1:SetStartSize( 2,290 )
		FlashS1:SetEndSize( 0 )
		FlashS1:SetRoll( math.Rand(180,480) )
		FlashS1:SetRollDelta( math.Rand(-1,1) )
		FlashS1:SetColor(255,255,255)	
		end
		end
		
		
		
		
	sound.Play( "weapons/grenadelauncher/grenadelauncher_fire.wav", self.Pos, 80, 80 )
		
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
