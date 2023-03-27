include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    local name = self:GetNWString("carryentname", nil)

    if not (name) then
        name = "Carry Item"
    end

    self:DrawModel()
    local vecPos = self:GetPos()
    local vecAng = self:GetAngles()
    vecAng:RotateAroundAxis(vecAng:Up(), 180)
    vecAng:RotateAroundAxis(vecAng:Forward(), 90)
    surface.SetFont("QUEST_SYSTEM_ItemTitle")
    cam.Start3D2D(vecPos + Vector(0, 0, 20), vecAng, .25)
    draw.WordBox(2, -surface.GetTextSize(name) / 2, -30, name, "QUEST_SYSTEM_ItemTitle", Color(0, 0, 0, 100), Color(255, 255, 255, 255))
    cam.End3D2D()
end