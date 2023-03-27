include("shared.lua")

function ENT:Draw()
    self:DrawModel()

    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 500) then
        local vecPos = self:GetPos()
        local vecAng = self:GetAngles()
        vecAng:RotateAroundAxis(vecAng:Up(), 90)
        vecAng:RotateAroundAxis(vecAng:Forward(), 90)
        local strTitle = "Food Vendor"
        surface.SetFont("Trebuchet24")
        cam.Start3D2D(vecPos + Vector(0, 0, 81), vecAng, .25)
        draw.WordBox(0, -surface.GetTextSize(strTitle) / 2, -3, strTitle, "Trebuchet24", Color(0, 0, 0, 200), color_white)
        cam.End3D2D()
    end
end
