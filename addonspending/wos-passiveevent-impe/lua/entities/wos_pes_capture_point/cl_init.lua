include("shared.lua")

surface.CreateFont( "wOS.PES.CapturePoint", {
	font = "Arial",
	extended = false,
	size = 35,
	weight = 1000,
    shadow = true,
    outline = false
} )

function ENT:Initialize()
    self:SharedInit()
    timer.Simple(0, function()
        local mins = self:OBBMins()
        local maxs = self:OBBMaxs()
        maxs.z = maxs.z + 30
        self:SetRenderBounds(mins, maxs)
    end)
end

function ENT:Draw()
    self:DrawModel()

    local p = self:GetPos()

    p.z = p.z + self:OBBMaxs().z

    local radS = self:GetCaptureRange()*self:GetCaptureRange()

    if LocalPlayer():GetPos():DistToSqr(p) < radS then

        local ang = self:GetAngles()
        ang:RotateAroundAxis( ang:Forward(), 90 )
        ang:RotateAroundAxis( ang:Up(), 90 )
        ang.y = LocalPlayer():EyeAngles().y - 90

        if !self.currentValue then self.currentValue = self:GetCaptureValue() end

        self.currentValue = math.Approach( self.currentValue, self:GetCaptureValue(), FrameTime() * 20 )

        local maxValue = self:GetMaxCaptureValue()

        local size = 400
        local height = 50

        cam.Start3D2D( p + Vector( 0, 0, 30 ), Angle( 0, ang.y, 90 ), .15 )
            draw.RoundedBox( 5, -size/2, 0, size, height, Color( 0, 0, 0, 230 ) )
            draw.RoundedBox( 5, - size/2 + 2, 2, math.Clamp( self.currentValue/maxValue , 0, 1 ) * (size-4), height -4, Color( 0, 0, 100, 230 ) )

            if self:GetCaptureValue() == self:GetMaxCaptureValue() then
                draw.DrawText( "Captured", "wOS.PES.CapturePoint", 0, 2, Color( 255, 255, 255, 255 ), 1, 1 )
            else
                draw.DrawText( "Capturing...", "wOS.PES.CapturePoint", 0, 2, Color( 255, 255, 255, 255 ), 1, 1 )
            end
        cam.End3D2D()
    end
end
