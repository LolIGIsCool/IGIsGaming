AddCSLuaFile()

ENT.PrintName = "Artillery Camera"
ENT.Author = "Ordo Redactus"
ENT.Information = "Don't touch"
ENT.Category = "OR's stuff"

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = false

function ENT:SpawnFunction(ply, tr, ClassName)

    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos + tr.HitNormal * 25)
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Draw()
end

function ENT:Initialize()
    if (CLIENT) then return end

    self:SetModel("models/dav0r/camera.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_FLY)
    self:SetSolid(SOLID_NONE)
    self:GetPhysicsObject():EnableGravity(false)
    self:DrawShadow(false)

end

function ENT:Think()
    self:SetNWVector("CameraPos", self:GetPos())
end

function ENT:ControlCamera( Gunner1 )
    if Gunner1:KeyDown( IN_FORWARD ) then 
        self:SetVelocity( Vector(10,0,0) )
    elseif Gunner1:KeyDown(IN_BACK) then
        self:SetVelocity( Vector(-10,0,0) )
    elseif Gunner1:KeyDown(IN_MOVELEFT) then
        self:SetVelocity( Vector(0,10,0) )
    elseif Gunner1:KeyDown(IN_MOVERIGHT) then
        self:SetVelocity( Vector(0,-10,0) )
    elseif Gunner1:KeyDown(IN_SPEED) then
        self:SetVelocity( Vector(0,0,10) )
    elseif Gunner1:KeyDown(IN_DUCK) then
        self:SetVelocity( Vector(0,0,-10) )
    else self:SetVelocity( -self:GetVelocity()/10 ) 
    end
end

function ENT:NextMode()
end