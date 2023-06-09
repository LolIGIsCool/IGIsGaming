EFFECT.Offset = Vector(-8, 0, 0)
EFFECT.mat = Material("sprites/light_glow02_add")
EFFECT.Materials = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

function EFFECT:Init( data )
	self.Entity = data:GetEntity()

	if IsValid( self.Entity ) then
		self.OldPos = self.Entity:LocalToWorld( self.Offset )

		self.Emitter = ParticleEmitter( self.Entity:LocalToWorld( self.OldPos ), false )
	end
end

function EFFECT:doFX( pos )
	if not IsValid(self.Entity) then return end

	if self.Emitter then
		local emitter = self.Emitter
        local particle = emitter:Add(self.Materials[math.random(1, table.Count(self.Materials))], pos)
        
        if particle then
            particle:SetGravity(Vector(0, 0, 100) + VectorRand() * 50) 
            particle:SetVelocity(-self.Entity:GetForward() * 500)
            particle:SetAirResistance(600) 
            particle:SetDieTime(math.Rand(2,3))
            particle:SetStartAlpha(150)
            particle:SetStartSize(math.Rand(6,12))
            particle:SetEndSize(math.Rand(40,90))
            particle:SetRoll(math.Rand( -1, 1 ))
            particle:SetColor(50, 50, 50)
            particle:SetCollide(false)
        end

        local particle = emitter:Add("particles/flamelet"..math.random(1 ,5), pos)
        if particle then
            particle:SetVelocity(-self.Entity:GetForward() * 300 + self.Entity:GetVelocity())
            particle:SetDieTime(0.1)
            particle:SetAirResistance(0) 
            particle:SetStartAlpha(255)
            particle:SetStartSize(4)
            particle:SetEndSize(0)
            particle:SetRoll(math.Rand(-1,1))
            particle:SetColor(255, 255, 255)
            particle:SetGravity(Vector(0, 0, 0))
            particle:SetCollide(false)
        end
	end
end


function EFFECT:doFXbroken( pos )
	if not IsValid( self.Entity ) then return end

	if self.Emitter then
		local emitter = self.Emitter

		local particle = emitter:Add(self.Materials[math.random(1, table.Count(self.Materials))], pos)
		if particle then
			particle:SetGravity(Vector(0, 0, 100) + VectorRand() * 50) 
			particle:SetVelocity(-self.Entity:GetForward() * 500)
			particle:SetAirResistance(600) 
			particle:SetDieTime(math.Rand(2, 3))
			particle:SetStartAlpha(150 )
			particle:SetStartSize(math.Rand(6, 12))
			particle:SetEndSize(math.Rand(40, 90))
			particle:SetRoll(math.Rand(-1, 1))
			particle:SetColor(50, 50, 50)
			particle:SetCollide(false)
		end

		local particle = emitter:Add("particles/flamelet"..math.random(1, 5), pos)
		if particle then
			particle:SetVelocity(-self.Entity:GetForward() * 500 + VectorRand() * 50)
			particle:SetDieTime(0.25)
			particle:SetAirResistance(600) 
			particle:SetStartAlpha(255)
			particle:SetStartSize(math.Rand(25,40))
			particle:SetEndSize(math.Rand(10,15))
			particle:SetRoll(math.Rand(-1,1))
			particle:SetColor(255, 255, 255)
			particle:SetGravity(Vector(0, 0, 0))
			particle:SetCollide(false)
		end
	end
end

function EFFECT:Think()
	if IsValid( self.Entity ) then
		self.nextDFX = self.nextDFX or 0
		
		if self.nextDFX < CurTime() then
			self.nextDFX = CurTime() + 0.02

			self.Disabled = self.Entity:GetDisabled()

			local oldpos = self.OldPos
			local newpos = self.Entity:LocalToWorld( self.Offset )
			self:SetPos( newpos )

			local Sub = (newpos - oldpos)
			local Dir = Sub:GetNormalized()
			local Len = Sub:Length()

			self.OldPos = newpos

			for i = 0, Len, 45 do
				local pos = oldpos + Dir * i

				if self.Disabled then
					self:doFXbroken( pos )
				else
					self:doFX( pos )
				end
			end
		end

		return true
	end

	if self.Emitter then
		self.Emitter:Finish()
	end

	return false
end

local effectcolor = Color(0, 127, 255, 255)
function EFFECT:Render()
	if self.Disabled then return end

	local ent = self.Entity
	local pos = ent:LocalToWorld(self.Offset)

	render.SetMaterial(self.mat)
        
    for i =0,10 do
        local Size = (10 - i) * 25.6
        render.DrawSprite(pos - ent:GetForward() * i * 5, Size, Size, effectcolor)
    end

	render.DrawSprite(pos, 256, 256, effectcolor)
end
