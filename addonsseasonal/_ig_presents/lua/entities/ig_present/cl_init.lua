include("shared.lua")

function ENT:Initialize()
    self.Rotation = 0
end

function ENT:Draw()
        if LocalPlayer():GetNWFloat("forcejumptime",0) >= CurTime() then return end
        self:DrawModel()
        self.Rotation = self.Rotation + 0.35

        if (self.Rotation >= 359) then
            self.Rotation = 0
        end

        local vecPos = self:GetPos()
        local vecAng = self:GetAngles()
        local strTitle = "PRESENT"
        vecAng:RotateAroundAxis(vecAng:Up(), self.Rotation)
        vecAng:RotateAroundAxis(vecAng:Up(), self.Rotation + 180)
        vecAng:RotateAroundAxis(vecAng:Forward(), 90)
        surface.SetFont("QUEST_SYSTEM_ItemTitle")
        cam.Start3D2D(vecPos + Vector(0, 0, 20), vecAng, .25)
        draw.WordBox(2, -surface.GetTextSize(strTitle) / 2, -30, strTitle, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
        cam.End3D2D()
end