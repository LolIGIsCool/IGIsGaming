include('shared.lua')

function ENT:Draw()
	local dist = (LocalPlayer():GetShootPos() - self.Entity:GetPos()):Length()
	if (dist > 1000) then return end
    self:DrawModel()

	local scale = 0.21-- scale
	local d1 = Vector(-17.5,0,1) -- position offset
	local d2 = Vector(-17.5,0,1) -- position offset
	local d3 = Vector(-3.5,0.5,1) -- position offset
	local d11 = Angle(0,90,0) -- angle offset
	local mh2booking = globalmh2booking
	local scale2 = 0.4
	if string.len( mh2booking ) <= 16 then
		scale2 = 0.4
    elseif string.len( mh2booking ) >= 16 then
    	scale2 = 0.3
    else 
        scale2 = 0.4
	end

	

	cam.Start3D2D(self:LocalToWorld(d1), self:LocalToWorldAngles(d11), scale)
		draw.DrawText("Main Hangar 2 - Booked By", "Trebuchet24", 0,0, Color(255,255,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
		cam.Start3D2D(self:LocalToWorld(d2), self:LocalToWorldAngles(d11), scale)
		draw.DrawText("______________________", "Trebuchet24", 0,0, Color(255,255,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()
	cam.Start3D2D(self:LocalToWorld(d3), self:LocalToWorldAngles(d11), scale2)
		draw.DrawText(mh2booking, "Trebuchet24", 0,0, Color(255,255,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()

end