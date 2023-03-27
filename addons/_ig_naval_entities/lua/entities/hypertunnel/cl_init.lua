include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	local tunnelspin = (CurTime()*30) % 360
	self:SetAngles(Angle(0,180,tunnelspin))
end