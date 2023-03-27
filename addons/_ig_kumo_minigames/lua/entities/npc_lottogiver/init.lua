AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/imperial_officer/npc_officer.mdl")
	--self:SetHealth(1e7)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetSchedule(SCHED_NPC_FREEZE)
	self:SetMaxYawSpeed(90)
	self:DropToFloor()
end

function ENT:OnTakeDamage( dmg )
	return 0
end

local delay = 0;

function ENT:Think()
    if delay <= CurTime() then
        local voice = {
		"vanilla/lottery/Augment.wav",
		"vanilla/lottery/CreamCheese.wav",
		"vanilla/lottery/Duties.wav",
		"vanilla/lottery/Massiff.wav",
		"vanilla/lottery/NewCasino.wav",
		"vanilla/lottery/YouAgain.wav"
	}
	self:EmitSound(voice[math.random(1,6)],60,100,1,CHAN_VOICE);
        delay = CurTime() + 900;
    end
end

function ENT:AcceptInput(strName, activator, caller)
    if (strName == "Use" and caller:IsPlayer() and caller:Alive() and caller:GetPos():Distance(self:GetPos()) < 75 and caller:GetEyeTrace().Entity == self) then
		if globaldefconn == 5 then
			net.Start("LOTTERY_OpenDialogue")
			net.Send(caller)
		else
			caller:ChatPrint("Shouldn't you be doing your duties?")
		end
    end
end
