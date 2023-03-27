ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.AutomaticFrameAdvance = true
ENT.Model = "models/zerochain/props_bloodlab/zbl_gate.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.PrintName = "Electric Fence"
ENT.Category = "Zeros GenLab"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "TurnedOn")
    self:NetworkVar("Entity", 0, "LeftWall")
    self:NetworkVar("Entity", 1, "RightWall")
    self:NetworkVar("Int", 1, "ScanResult")

    if (SERVER) then
        self:SetTurnedOn(false)
        self:SetScanResult(-1)
    end
end
