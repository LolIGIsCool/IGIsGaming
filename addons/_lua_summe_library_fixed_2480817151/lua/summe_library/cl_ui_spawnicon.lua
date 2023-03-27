local function MakeCirclePoly( _x, _y, _r, _points )
    local _u = ( _x + _r * 320 ) - _x;
    local _v = ( _y + _r * 320 ) - _y;
 
    local _slices = ( 2 * math.pi ) / _points;
    local _poly = { };
    for i = 0, _points - 1 do
        local _angle = ( _slices * i ) % _points;
        local x = _x + _r * math.cos( _angle );
        local y = _y + _r * math.sin( _angle );
        table.insert( _poly, { x = x, y = y, u = _u, v = _v } )
    end
 
    return _poly;
end
 
local CircularSpawnIcon = {}
 
function CircularSpawnIcon:Init()
    self.SpawnIcon = vgui.Create("DModelPanel", self)
    self.SpawnIcon:SetPaintedManually(true)
    self.material = Material( "effects/flashlight001" )
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end
 
function CircularSpawnIcon:PerformLayout()
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end
 
function CircularSpawnIcon:SetModel(...)
    self.SpawnIcon:SetModel(...)

    function self.SpawnIcon:LayoutEntity( Entity ) return end	-- Disable cam rotation

    local headpos = self.SpawnIcon.Entity:GetBonePosition(self.SpawnIcon.Entity:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 5)
    self.SpawnIcon:SetLookAt(headpos)

    self.SpawnIcon:SetCamPos(headpos-Vector(-17, 0, 0))
end
 
function CircularSpawnIcon:OnSizeChanged(w, h)
    self.SpawnIcon:SetSize(self:GetWide(), self:GetTall())
    self.points = math.Max((self:GetWide()/4), 32)
    self.poly = MakeCirclePoly(self:GetWide()/2, self:GetTall()/2, self:GetWide()/2, self.points)
end
 
function CircularSpawnIcon:DrawMask(w, h)
    --draw.RoundedBox(w/4, 0, 0, w, h, color_white)
    draw.NoTexture();
    surface.SetMaterial(self.material); 
    surface.SetDrawColor(Color(255,100,100));
    surface.DrawPoly(self.poly);
end
 
function CircularSpawnIcon:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)
 
    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)
 
    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )
 
    self:DrawMask(w, h)
 
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
 
    self.SpawnIcon:SetPaintedManually(false)
    self.SpawnIcon:PaintManual()
    self.SpawnIcon:SetPaintedManually(true)
 
    render.SetStencilEnable(false)
    render.ClearStencil()
end
vgui.Register("SummeLibrary.SpawnIcon", CircularSpawnIcon)