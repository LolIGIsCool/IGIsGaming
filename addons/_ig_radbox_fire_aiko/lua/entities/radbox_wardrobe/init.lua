AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/cire992/props4/kitchen09.mdl")
    --self:SetModel("models/props_borealis/bluebarrel001.mdl")

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if (activator:IsPlayer()) then
        if self:GetHazmatSuits() <= 0 then
            return activator:ChatPrint( "This wardrobe needs to be restocked." )
        end
        if activator:GetModel() == "models/zerochain/props_bloodlab/zbl_hazmat.mdl" then
            activator:ChatPrint( "You put your hasmat suit back." )
            activator:SetModel(activator:GetJobTable().Model)
            self:SetHazmatSuits( self:GetHazmatSuits() + 1 )
            return
        end
        activator:ChatPrint( "You equipped your hazmat suit." )
        activator:SetModel("models/zerochain/props_bloodlab/zbl_hazmat.mdl")
        self:SetHazmatSuits( self:GetHazmatSuits() - 1 )
    end
end