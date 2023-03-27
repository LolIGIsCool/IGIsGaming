include("shared.lua");

function ENT:Draw()
    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 800) then
        cam.Start3D2D( self:GetPos(), self:GetAngles(), 1 );
            for i = 45, 50 do
                surface.DrawCircle( 0, 0, i, Color( 80, 255, 80, 50 ) )
            end
        cam.End3D2D();
   end
end
