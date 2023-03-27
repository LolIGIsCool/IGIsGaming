ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/props_combine/combine_generator01.mdl"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "Electric Fence End Point"
ENT.Category = "Zeros GenLab"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Main")
    self:NetworkVar("Bool", 0, "IsLeft")

    if (SERVER) then
        self:SetMain(NULL)
        self:SetIsLeft(true)
    end
end

function ENT:GetBoxData(main)

    local self_pos = self:GetPos()
    local parent_pos = main:GetPos()
    local self_ang = self:GetAngles()


    debugoverlay.Axis(self_pos,self_ang,15,0.1,true)


    if self:GetIsLeft() then
        parent_pos = parent_pos + main:GetRight() * 40
    else
        parent_pos = parent_pos - main:GetRight() * 40
    end


    local dist = math.Distance( self_pos.x,self_pos.y, parent_pos.x,parent_pos.y )

    if self:GetIsLeft() == false then
        dist = -dist
    end

    local w,l,h = dist,20,160

    local min = Vector(0, -l / 2, 0)
    local max = Vector(w, l, h)

    local rot = 90
    if self:GetIsLeft() then
        rot = -90
    end

    max:Rotate(Angle(0,rot,0))
    min:Rotate(Angle(0,rot,0))

    return min,max
end
