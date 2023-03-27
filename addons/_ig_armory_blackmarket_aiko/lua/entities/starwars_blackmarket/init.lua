AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()

	self:SetModel("models/imperial_officer/npc_officer.mdl")
	self:SetSolid(SOLID_BBOX);
	self:SetSequence( 1 );
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:DrawShadow(true);
	self:SetUseType(SIMPLE_USE);
	self:ResetSequenceInfo();
	self.locationIndex = 1
end

function ENT:Use(activator)
	if not activator then return end
	if not activator:IsPlayer() then return end
	net.Start("Blackmarket_OpenMenu")
	net.Send(activator)
end

function ENT:Think()
	if not self.serverSpawned then return end
	if not SBlackmarket.BlackmaketDealer or not IsValid(SBlackmarket.BlackmaketDealer) then
		SBlackmarket.BlackmaketDealer = self
	end

	if not SBlackmarket.Config.Locations then
		self:NextThink(CurTime() + 1)
		return true
	end

	if SBlackmarket.Config.LocationSelectorMode == 1 then
		self.locationIndex = math.random(SBlackmarket.Config.Locations[0])
	else
		self.locationIndex = self.locationIndex + 1
	end

	if self.locationIndex > SBlackmarket.Config.Locations[0] then
		self.locationIndex = 1
	end

	local locationData = SBlackmarket.Config.Locations[self.locationIndex]
	if SBlackmarket.BlackmaketDealer:GetPos() != locationData.pos then
		SBlackmarket.BlackmaketDealer:SetPos(locationData.pos)
	end

	if SBlackmarket.BlackmaketDealer:GetAngles() != locationData.angle then
		SBlackmarket.BlackmaketDealer:SetAngles(locationData.angle)
	end

	self:NextThink(CurTime() + SBlackmarket.Config.LocationChangeDelay)
	return true
end

function ENT:OnRemove()
	if self.severSpawned then
		SBlackmarket.BlackmaketDealer = nil
	end
end