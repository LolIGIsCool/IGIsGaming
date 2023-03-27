include('shared.lua')

do

	local EFF = {}
	
	function EFF:Init(d)
		local ply = d:GetEntity()
		if not IsValid(ply) then return end
		
		self:SetPos(ply:GetPos())
		
		self.DieTime = CurTime()+1
		self.Emitter = ParticleEmitter(ply:GetPos())
		self.Player = ply
	end

	function EFF:Render()
	
	end
	
	effects.Register(EFF,"jetsmoke")

end

function SWEP:Draw()
end