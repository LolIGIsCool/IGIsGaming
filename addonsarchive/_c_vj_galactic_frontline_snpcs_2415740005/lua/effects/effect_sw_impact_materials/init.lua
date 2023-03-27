
					//Sound,Impact

					// 1        2       3      4      5
					//Dirt, Concrete, Metal, Glass, Flesh

					// 1     2     3      4      5      6      7      8         9
					//Dust, Dirt, Sand, Metal, Smoke, Wood,  Glass, Blood, YellowBlood
local mats={				
	[MAT_ALIENFLESH]		={5,9},
	[MAT_ANTLION]			={5,9},
	[MAT_BLOODYFLESH]		={5,8},
	[45]				={5,8},	// Metrocop heads are a source glitch, they have no enumeration
	[MAT_CLIP]			={3,5},
	[MAT_COMPUTER]			={4,5},
	[MAT_FLESH]			={5,8},
	[MAT_GRATE]			={3,4},
	[MAT_METAL]			={3,4},
	[MAT_PLASTIC]			={2,5},
	[MAT_SLOSH]			={5,5},
	[MAT_VENT]			={3,4},
	[MAT_FOLIAGE]			={1,5},
	[MAT_TILE]			={2,5},
	[MAT_CONCRETE]			={2,1},
	[MAT_DIRT]			={1,2},
	[MAT_SAND]			={1,3},
	[MAT_WOOD]			={2,6},
	[MAT_GLASS]			={4,7},
}


function EFFECT:Init(data)
self.Entity 		= data:GetEntity()		// Entity determines what is creating the dynamic light			//

self.Pos 		= data:GetOrigin()		// Origin determines the global position of the effect			//

self.Scale 		= data:GetScale()		// Scale determines how large the effect is				//
self.Radius 		= data:GetRadius() or 1		// Radius determines what type of effect to create, default is Concrete	//

self.DirVec 		= data:GetNormal()		// Normal determines the direction of impact for the effect		//
self.PenVec 		= data:GetStart()		// PenVec determines the direction of the round for penetrations	//
self.Particles 		= data:GetMagnitude()		// Particles determines how many puffs to make, primarily for "trails"	//
self.Angle 		= self.DirVec:Angle()		// Angle is the angle of impact from Normal				//
self.DebrizzlemyNizzle 	= 10+data:GetScale()		// Debrizzle my Nizzle is how many "trails" to make			//
self.Size 		= 5*self.Scale			// Size is exclusively for the explosion "trails" size			//

self.Emitter 		= ParticleEmitter( self.Pos )	// Emitter must be there so you don't get an error			//



	self.Mat=math.ceil(self.Radius)


 
	if     mats[self.Mat][2]==8 then	self:Blood()	
	else 					self:Smoke()
	end

end

 function EFFECT:Blood()
 
	local emitter = ParticleEmitter( self.Position );
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	if( emitter ) then
		

		emitter:Finish();
	end
	

		local Angle = self.DirVec:Angle()

		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 7) + (DustRing*math.Rand(1, 6))
		
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
		
		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 5) + (DustRing*math.Rand(1, 3))

			for k = 3, self.Particles do
			local Rcolor = math.random(10)

			local particle1 = self.Emitter:Add( "particle/particle_smokegrenade", self.Pos )
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(.1, 1) * self.Size) + (RanVec*self.Size*k*math.Rand(0.01, 0.1)))	
			particle1:SetDieTime( math.Rand( 0.5, 0.8 )*self.Scale )	

			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(1, 2)* self.Size) + Vector(0,0,-100))
			particle1:SetAirResistance( math.Rand(100, 200) ) 		
			particle1:SetStartSize( 4 )
			particle1:SetEndSize( 14 )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetCollide(true)
			particle1:SetBounce( 1 )
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor(200, 200, 200, 200)
			end
			
		  for i = 1,4 do
			local EffectCode = Emitter:Add("effects/yellowflare",self.Pos)
			EffectCode:SetVelocity((data:GetNormal() + VectorRand() * 0.5) * math.Rand(150, 200))
			EffectCode:SetDieTime(math.Rand(0.5, 0.8))
			EffectCode:SetStartAlpha(255)
			EffectCode:SetStartSize(.5)
			EffectCode:SetEndSize(2)
			EffectCode:SetRoll(0)
			EffectCode:SetGravity(Vector(0, 0, -1))
			EffectCode:SetBounce(.8)
			EffectCode:SetAirResistance(400)
			EffectCode:SetStartLength(0.01)
			EffectCode:SetEndLength(0)
			EffectCode:SetVelocityScale(true)
			EffectCode:SetCollide(false)
			end
		end
		
		for i = 1,2 do
			local EffectCode = Emitter:Add("particle/particle_smokegrenade",self.Pos)
			EffectCode:SetVelocity(Vector(math.random(-20,40),math.random(-10,30),math.random(20,50)))
			EffectCode:SetDieTime(math.Rand(3,5)) -- How much time until it dies
			EffectCode:SetStartAlpha(math.Rand(225,200)) -- Transparency
			EffectCode:SetStartSize(math.Rand(10,20)) -- Size of the effect
			EffectCode:SetEndSize(math.Rand(60,160)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
			EffectCode:SetRoll(math.Rand(280,540))
			EffectCode:SetRollDelta(math.Rand(-1,2)) -- How fast it rolls
			EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
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
		

		for i = 1, 4 do
			local particleS1 = self.Emitter:Add( "effects/energysplash", self.Pos );
			particleS1:SetVelocity( ( self.Normal + VectorRand() * 0.95 ):GetNormal() * math.Rand( 40, 24 ) );
			particleS1:SetDieTime( math.Rand( 0.5, 1.25 ) );
			particleS1:SetStartAlpha( 255 );
			particleS1:SetEndAlpha( 0 );
			particleS1:SetStartSize( math.Rand( 1, 3 ) );
			particleS1:SetEndSize( 0 );
			particleS1:SetRoll( math.random( -500, 500 ) );
			particleS1:SetGravity((VectorRand():GetNormalized()*math.Rand(20, 2)* self.Size) + Vector(0,0,-20));
			particleS1:SetCollide( true );
			particleS1:SetBounce( 0.4 );
			particleS1:SetAirResistance( 55 );
			particleS1:SetColor(255,145,95)	
		end

		sound.Play( "effects/sw_impact/sw752_hit_" .. math.random(1, 33) .. ".wav", self.Pos, 80, 80 )
		
		local Angle = self.DirVec:Angle()
 
 end

---------------------------------------------------------------------------------------------------------------------------- 
 
  function EFFECT:Smoke()

	local emitter = ParticleEmitter( self.Position );
	self.Pos = data:GetOrigin()
	local Emitter = ParticleEmitter(self.Pos)
	if Emitter == nil then return end
	if( emitter ) then
		

		emitter:Finish();
	end
	

		local Angle = self.DirVec:Angle()

		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 7) + (DustRing*math.Rand(1, 6))
		
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
		
		for i = 1, self.DebrizzlemyNizzle do 					/// This part makes the trailers ///
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 5) + (DustRing*math.Rand(1, 3))

			for k = 3, self.Particles do
			local Rcolor = math.random(10)

			local particle1 = self.Emitter:Add( "particle/particle_smokegrenade", self.Pos )
			particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(.1, 1) * self.Size) + (RanVec*self.Size*k*math.Rand(0.01, 0.1)))	
			particle1:SetDieTime( math.Rand( 0.5, 0.8 )*self.Scale )	

			particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
			particle1:SetEndAlpha(0)	
			particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(1, 2)* self.Size) + Vector(0,0,-100))
			particle1:SetAirResistance( math.Rand(100, 200) ) 		
			particle1:SetStartSize( 4 )
			particle1:SetEndSize( 14 )
			particle1:SetRoll( math.random( -500, 500 )/100 )	
			particle1:SetCollide(true)
			particle1:SetBounce( 1 )
			particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
			particle1:SetColor(200, 200, 200, 200)
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
		
		for i = 1,2 do
			local EffectCode = Emitter:Add("particle/particle_smokegrenade",self.Pos)
			EffectCode:SetVelocity(Vector(math.random(-20,40),math.random(-10,30),math.random(20,50)))
			EffectCode:SetDieTime(math.Rand(3,5)) -- How much time until it dies
			EffectCode:SetStartAlpha(math.Rand(225,200)) -- Transparency
			EffectCode:SetStartSize(math.Rand(10,20)) -- Size of the effect
			EffectCode:SetEndSize(math.Rand(60,160)) -- Size of the effect at the end (The effect slowly trasnsforms to this size)
			EffectCode:SetRoll(math.Rand(280,540))
			EffectCode:SetRollDelta(math.Rand(-1,2)) -- How fast it rolls
			EffectCode:SetGravity(Vector(0,0,math.random(-30,-10))) -- The Gravity
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
		

		for i = 1, 4 do
			local particleS1 = self.Emitter:Add( "effects/energysplash", self.Pos );
			particleS1:SetVelocity( ( self.Normal + VectorRand() * 0.95 ):GetNormal() * math.Rand( 40, 24 ) );
			particleS1:SetDieTime( math.Rand( 0.5, 1.25 ) );
			particleS1:SetStartAlpha( 255 );
			particleS1:SetEndAlpha( 0 );
			particleS1:SetStartSize( math.Rand( 1, 3 ) );
			particleS1:SetEndSize( 0 );
			particleS1:SetRoll( math.random( -500, 500 ) );
			particleS1:SetGravity((VectorRand():GetNormalized()*math.Rand(20, 2)* self.Size) + Vector(0,0,-20));
			particleS1:SetCollide( true );
			particleS1:SetBounce( 0.4 );
			particleS1:SetAirResistance( 55 );
			particleS1:SetColor(255,145,95)	
		end

		sound.Play( "effects/sw_impact/sw752_hit_" .. math.random(1, 33) .. ".wav", self.Pos, 80, 80 )
		
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