AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	//self:SetModel("models/player/female/trooper_v2.mdl")
    self:SetModel("models/nada/pms/female/trooper.mdl")
    self:SetBodygroup(2, 14)
    self:SetBodygroup(6, 5)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(90)
	self:DropToFloor()
end

function ENT:OnTakeDamage( dmg )
	return 0
end

local delay = CurTime()
function ENT:Think() //11
    self:SetSequence( 13 )
    if delay <= CurTime() then

	self:EmitSound("vanilla/foodlines/random_" .. math.random(1,3) .. ".wav",75,100,1,CHAN_VOICE);
        delay = CurTime() + 600;
    end
end

function ENT:AcceptInput(strName, activator, caller)
	if (strName == "Use" and caller:IsPlayer() and caller:Alive() and caller:GetPos():Distance(self:GetPos()) < 100 and caller:GetEyeTrace().Entity == self) then
		local stock = ReadPlayerStock(caller:SteamID64())
		net.Start("VANILLAFOOD_net_OpenBuyMenu")
		net.WriteTable(stock)
		net.Send(caller)
	end
end
