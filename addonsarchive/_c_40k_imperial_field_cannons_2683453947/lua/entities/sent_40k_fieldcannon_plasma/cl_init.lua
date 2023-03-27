include("shared.lua")

local function RandVector(min,max)
	min = min or -1
	max = max or 1
	
	local vec = Vector(math.Rand(min,max),math.Rand(min,max),math.Rand(min,max))
	return vec
end

function ENT:Initialize()	
	self.PixVis = util.GetPixelVisibleHandle()
	
	self.Materials = {
		"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	"particle/muzzle_flame_01",
	}
	
	self.OldPos = self:GetPos()

end

local mat = Material( "particle/muzzle_flame_01" )
function ENT:Draw()
end

function ENT:Think()
	local curtime = CurTime()
	local pos = self:GetPos()
	
	if pos ~= self.OldPos then
		self:doFX( pos, self.OldPos )
		self.OldPos = pos
	end
	return true
end

function ENT:doFX( newpos, oldpos )
	local Sub = (newpos - oldpos)
	local Dir = Sub:GetNormalized()
	local Len = Sub:Length()
	
	for i = 1, Len, 2 do
		local pos = oldpos + Dir * i
		local emitter = ParticleEmitter(pos, false )
		if emitter then
			local particle = emitter:Add( self.Materials[math.random(1, table.Count(self.Materials) )], pos )
			
			if particle then
				particle:SetGravity( Vector(0,0,600) + RandVector() * 500 ) 
				particle:SetVelocity( -self:GetForward() * 1000  )
				particle:SetAirResistance( 1500 ) 
				particle:SetDieTime( math.Rand(0.03,0.06) )
				particle:SetStartAlpha( 40 )
				particle:SetStartSize( (math.Rand(10,20) / 20) * self:GetSize() )
				particle:SetEndSize( (math.Rand(60,80) / 10) * self:GetSize() )
				particle:SetRoll( math.Rand( -1, 1 ) )
				particle:SetColor ( 0,0,255 )
				particle:SetCollide( false )
			end
			
			emitter:Finish()
		end
		
		local emitter = ParticleEmitter( pos, false )
		if emitter then
			local particle = emitter:Add( mat, pos )
			if particle then
				particle:SetVelocity( -self:GetForward() * 1000 + self:GetVelocity())
				particle:SetDieTime( 0.1 )
				particle:SetAirResistance( 0 ) 
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( self:GetSize() )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(-1,1) )
				particle:SetColor(0,100,255 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
				particle:SetCollide( false )
			end
			
			emitter:Finish()
		end
	end
end

function ENT:OnRemove()
	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
	util.Effect( self:GetBlastEffect(), effectdata )
end

function ENT:Explosion( pos )
	local emitter = ParticleEmitter( pos, false )
end