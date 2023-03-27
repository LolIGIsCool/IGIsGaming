-- YOU CAN EDIT AND REUPLOAD THIS FILE.
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName ) -- called by garry
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 20 ) -- spawn 20 units above ground
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick() -- use this instead of "think"
end

function ENT:RunOnSpawn() -- called when the vehicle is spawned
	local F1 = self:AddPassengerSeat(Vector(110,20,100), Angle(0,-90,0))
	local R1 = self:AddPassengerSeat(Vector(10,-22.5,13.5),Angle(0,180,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	R1.ExitPos = Vector(10,-30,13.5)  -- assigns an exit pos for SpawnedPod
	local R2 = self:AddPassengerSeat(Vector(-20,-22.5,13.5),Angle(0,180,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	R2.ExitPos = Vector(-20,-22.5,13.5)  -- assigns an exit pos for SpawnedPod
	local R3 = self:AddPassengerSeat(Vector(-50,-22.5,13.5),Angle(0,180,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	R3.ExitPos = Vector(-50,-22.5,13.5)  -- assigns an exit pos for SpawnedPod
	local R4 = self:AddPassengerSeat(Vector(-80,-22.5,13.5),Angle(0,180,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	R4.ExitPos = Vector(-80,-22.5,13.5)  -- assigns an exit pos for SpawnedPod
	local L1 = self:AddPassengerSeat(Vector(10,22.5,13.5),Angle(0,0,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	L1.ExitPos = Vector(10,22.5,13.5)  -- assigns an exit pos for SpawnedPod
	local L1 = self:AddPassengerSeat(Vector(-20,22.5,13.5),Angle(0,0,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	L1.ExitPos = Vector(-20,22.5,13.5)  -- assigns an exit pos for SpawnedPod
	local L1 = self:AddPassengerSeat(Vector(-50,22.5,13.5),Angle(0,0,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	L1.ExitPos = Vector(-50,22.5,13.)  -- assigns an exit pos for SpawnedPod
	local L1 = self:AddPassengerSeat(Vector(-80,22.5,13.5),Angle(0,0,0)) -- add a passenger seat, store it inside "SpawnedPod" local variable
	L1.ExitPos = Vector(-80,22.5,13.5)  -- assigns an exit pos for SpawnedPod
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:SetNextPrimary( 0.15 )

	--[[ do primary attack code here ]]--

	self:EmitSound( "VANILLA_UWING_FIRE" )

	local Driver = self:GetDriver()

	local fP = { Vector(420,53,96),Vector(420,-53,96) }

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	= self:GetForward()
	bullet.Spread 	= Vector( 0.015,  0.015, 0 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_red"
	bullet.Force	= 10
	bullet.HullSize 	= 5
	bullet.Damage	= 65
	bullet.Attacker 	= Driver
	bullet.AmmoType = "Pistol"

	self:FireBullets( bullet )

	self:TakePrimaryAmmo()
end

function ENT:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondary( 0.15 )

	--[[ do secondary attack code here ]]--

	self:TakeSecondaryAmmo()
end

function ENT:CreateAI() -- called when the ai gets enabled
end

function ENT:RemoveAI() -- called when the ai gets disabled
end

function ENT:OnKeyThrottle( bPressed )
	if self:CanSound() then -- makes sure the player cant spam sounds
		if bPressed then -- if throttle key is pressed
			--self:EmitSound( "buttons/button3.wav" )
			--self:DelayNextSound( 1 ) -- when the next sound should be allowed to be played
		else
			--self:EmitSound( "buttons/button11.wav" )
			--self:DelayNextSound( 0.5 )
		end
	end
end

--[[
function ENT:ApplyThrustVtol( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetElevatorPos() )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetWingPos() )
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce, self:GetRotorPos() )
end
]]--

function ENT:OnEngineStarted()
	--[[ play engine start sound? ]]--
end

function ENT:OnEngineStopped()
	--[[ play engine stop sound? ]]--
end

function ENT:OnVtolMode( IsOn )
	--[[ called when vtol mode is activated / deactivated ]]--
end

function ENT:OnLandingGearToggled( bOn )
	self:EmitSound( "vehicles/tank_readyfire1.wav" )

	if bOn then
		self:SetModel("models/starwars/syphadias/ships/u_wing/u_wing_fly_open.mdl")
	else
		self:SetModel("models/starwars/syphadias/ships/u_wing/u_wing_landed.mdl")
	end
end
