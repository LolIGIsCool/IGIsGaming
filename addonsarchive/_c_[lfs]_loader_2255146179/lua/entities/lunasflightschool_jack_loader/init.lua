AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 60 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:RunOnSpawn()
	local cpd = "lava_skiff_stand"
	self:GetChildren()[1]:SetVehicleClass(cpd)
	self:SetAutomaticFrameAdvance(true)

	local Pod
	for i=0, 3 do
		for j=0, 2 do
			Pod = self:AddPassengerSeat( Vector(80-40*i,40-40*j,25), Angle(0,-90,0) )
			Pod:SetVehicleClass(cpd)
		end
	end
end

function ENT:PrimaryAttack()
	self.HeightOffset = 250
end

function ENT:SecondaryAttack()
	self.HeightOffset = 30
end

function ENT:MainGunPoser( EyeAngles )
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	self.HeightOffset = 30
	--local holod = self.GetDriver()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial("models/props_combine/stasisshield_sheet")
	-- else
		-- Driver:SetMaterial()
	-- end
end

function ENT:OnEngineStopped()
	self.HeightOffset = 0
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial()
	-- end
end

function ENT:OnRemove()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	local Driver = Pod:GetDriver()
	-- if IsValid( Driver ) then
		-- Driver:SetMaterial()
	-- end
end