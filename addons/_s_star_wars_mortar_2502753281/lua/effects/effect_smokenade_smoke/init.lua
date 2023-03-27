function EFFECT:Init(data)

	local emitter = ParticleEmitter(data:GetOrigin())

		for i = 0, 128 do

			if !emitter then return end

			local Pos = (data:GetOrigin() + Vector( math.Rand(-32,32), math.Rand(-32,32), math.Rand(-32,32) ) + Vector(0,0,64))

			local particle = emitter:Add( "particle/particle_smokegrenade", Pos )
			if (particle) then

				particle:SetVelocity(VectorRand() * math.Rand(1420,5200))

				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(16, 18))

				local rand = math.random(242,255)
				if math.random(1,10) == 10 then rand = math.random(210,232) end
				particle:SetColor(rand,rand,rand)

				particle:SetStartAlpha(math.Rand(242,255))
				particle:SetEndAlpha(0)

				local Size = math.Rand(132,162)
				particle:SetStartSize(Size)
				particle:SetEndSize(Size)

				particle:SetRoll(math.Rand(-360, 360))
				particle:SetRollDelta(math.Rand(-0.21, 0.21))

				particle:SetAirResistance(math.Rand(520,620))

				particle:SetGravity( Vector(0, 0, math.Rand(-42, -82)) )

				particle:SetCollide(true)
				particle:SetBounce(0.42)

				particle:SetLighting(1)

			end

		end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end