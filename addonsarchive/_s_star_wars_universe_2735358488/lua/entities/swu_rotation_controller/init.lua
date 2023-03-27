AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

SWU = SWU or {}

function ENT:Initialize()
    self:SetModel("models/lordtrilobite/starwars/isd/imp_console_medium03.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSubMaterial(3, "the-coding-ducks/swu/screens/rotation-controls")
    self:SetCurrentRotation("")

    self.KeypadPanel = ents.Create("prop_physics")
    self.KeypadPanel:SetModel("models/hunter/plates/plate025x025.mdl")
    self.KeypadPanel:SetParent(self)
    self.KeypadPanel:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self.KeypadPanel:SetMaterial("the-coding-ducks/swu/rotation_control")
    self.KeypadPanel:SetAngles(self:GetAngles())
    self.KeypadPanel:ManipulateBoneScale(0, Vector(0.695,0.47,0.01))
    self.KeypadPanel:SetLocalPos(Vector(15.3,9.4,32.1))
    self.KeypadPanel:SetLocalAngles(Angle(15,0,0))
    self.KeypadPanel:Spawn()

    table.insert(SWU.Terminals, self)
end

function ENT:ReceiveNetAction()
    if (not IsValid(SWU.Controller)) then return end

    local input = net.ReadUInt(4)
    local currentRotation = self:GetCurrentRotation()
    if input == 15 and SWU.Controller:GetHyperspace() == SWU.Hyperspace.OUT then
        SWU.Controller:SetTargetShipAngles(Angle(0, currentRotation, 0))
        self:SetCurrentRotation("")
        return
    end
    if input == 14 then
        if currentRotation == "" or currentRotation == nil then return end
        currentRotation = string.sub(currentRotation, 1, string.len(currentRotation) - 1)
        self:SetCurrentRotation(currentRotation)
        return
    end
    if input == 13 then
        if currentRotation == "" or currentRotation == nil then return end
        if tonumber(currentRotation) >= 360 then return end
        if not string.find(currentRotation, ".", 1, true) then
            if tonumber(currentRotation) > 360 then
                return
            end
            currentRotation = currentRotation .. "."
            self:SetCurrentRotation(currentRotation)
        end
        return
    end
    if input == 12 then
        if currentRotation == "" or currentRotation == nil then return end
        if string.find(currentRotation, "-", 1, true) then
            currentRotation = string.sub(currentRotation, 2, string.len(currentRotation))
        else
            currentRotation = "-" .. currentRotation
        end
        self:SetCurrentRotation(currentRotation)
        return
    end
    if currentRotation ~= "" and (tonumber(currentRotation .. input) > 360 or string.len(currentRotation .. input) > 7) then
        return
    end
    currentRotation = currentRotation .. input
    self:SetCurrentRotation(currentRotation)
end