AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/imperial_officer/npc_officer.mdl")
	self:SetBodygroup(10, 2)
	self:SetBodygroup(7, 1)
    --self:SetHealth(1e7)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(90)
	self:DropToFloor()
end

function ENT:OnTakeDamage( dmg )
	return 0
end

function ENT:AcceptInput(strName, activator, caller)
    if (strName == "Use" and caller:IsPlayer() and caller:Alive() and caller:GetPos():Distance(self:GetPos()) < 100 and caller:GetEyeTrace().Entity == self) then
        net.Start("QUEST_SYSTEM_OpenDialogue")
        net.Send(caller)
    end
end