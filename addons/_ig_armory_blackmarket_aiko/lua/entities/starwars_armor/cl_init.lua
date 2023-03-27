include("shared.lua")

function ENT:Draw()
	if (LocalPlayer():GetPos():Distance(self:GetPos()) > 2000) then return end

	self:DrawModel()

	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Right(),90)
	ang:RotateAroundAxis(ang:Up(),-90)

	cam.Start3D2D(self:GetPos() + Vector(0,0,70), ang,0.15)
		surface.SetFont("DermaLarge")
		local dX, _ = surface.GetTextSize("Armory")

		surface.SetDrawColor(32,32,32,125)
		surface.DrawRect(-(dX + 32) / 2,-24,dX + 32,-40)
		draw.SimpleTextOutlined("Armoury","DermaLarge",0,-60,Color(235,235,235),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(25,25,25))
	cam.End3D2D()
end