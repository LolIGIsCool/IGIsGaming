AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:ReceiveNetAction()
    if (not IsValid(SWU.Controller) or SWU.Controller:GetHyperspace() ~= SWU.Hyperspace.OUT) then return end

    local goUp = net.ReadBool()
    local modifier = -20
    if (goUp) then
        modifier = 20
    end

    SWU.Controller:SetTargetShipAcceleration(math.Clamp(SWU.Controller:GetTargetShipAcceleration() + modifier, 0, self:GetParent():GetMaxPower()))
end