AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/lordtrilobite/starwars/isd/imp_console_medium03.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSubMaterial(3, "the-coding-ducks/swu/screens/sublight-controls")
    self:SetMaxPower(100)

    self:SharedInitialize()

    self.Lever = ents.Create("swu_lever_speed")
    self.Lever:SetParent(self)
    self.Lever:SetLocalPos(self.StartLever)
    self.Lever:SetModelScale(0.5)
    self.Lever:SetAngles(self:GetAngles())
    self.Lever:Spawn()

    table.insert(SWU.Terminals, self)
end