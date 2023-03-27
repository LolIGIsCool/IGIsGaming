include("shared.lua");

function ENT:Draw()
    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 800) then
        cam.Start3D2D( self:GetPos(), self:GetAngles(), 1 );
            for i = 45, 50 do
                surface.DrawCircle( 0, 0, i, Color( 255, 80, 80, 80 ) )
            end
        
        surface.SetDrawColor(Color(255,80,80,80));
        surface.DrawLine(0,-11,11,0)
        surface.DrawLine(0,-10,10,0)
        surface.DrawLine(0,-9,9,0)
        
        surface.DrawLine(0,11,11,0)
        surface.DrawLine(0,10,10,0)
        surface.DrawLine(0,9,9,0)
        cam.End3D2D();
   end
end