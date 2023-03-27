AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
local lightCost = 0
local standardCost = 0
local heavyCost = 0
local highCost = 10
local grenadeCost = 50
local rocketCost = 100

function ENT:Initialize()
	self:SetModel("models/cs574/objects/ammo_container.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DropToFloor()

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()

	if(IsValid(phys)) then
		phys:Wake()
	end

	self:SetHealth(self.BaseHealth)
	self:SetSkin(7)
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if(!tr.Hit) then return end

	local SpawnPos = ply:GetShootPos() + ply:GetForward() * 50

	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Use(activator, caller)
	if !activator:GetActiveWeapon().IsTFAWeapon then return end
	local dispencer_timer = GetConVar("rw_sw_dispencer_timer"):GetInt()
	local ammoType = activator:GetActiveWeapon():GetPrimaryAmmoType()
	local ammoName = game.GetAmmoName(ammoType)
	local clip = activator:GetActiveWeapon():GetMaxClip1()
	local mul = GetConVar("rw_sw_dispencer_allammo_multiplier"):GetInt()
	local maxAmmo = game.GetAmmoMax(ammoType)
	local toGive = clip*mul
	local canAfford = false
	local paid = 0
	local delay4 = false
	if activator:IsPlayer() then
		if delay4 == true then
			self:EmitSound("npc/roller/code2.wav")
			return false
		else 
			if activator:GetAmmoCount(ammoType)+toGive > maxAmmo then
				toGive = maxAmmo - activator:GetAmmoCount(ammoType)
			end
			if toGive <= 0 then
				activator:ChatPrint("You cant carry anymore ".. ammoName .. " ammo!")
				self:EmitSound("npc/roller/code2.wav")
				delay4 = true
				timer.Simple( dispencer_timer, function()
				self:SetSkin(7)
				delay4 = false
				end)
			else
				print(ammoName)
				if ammoName == "Grenade" or ammoName =="RPG_Round" then
					toGive = 1
				end
				if ammoName == "light_battery" and activator:SH_CanAffordPremium(toGive*lightCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*lightCost)
					paid = toGive*lightCost
				elseif ammoName == "standard_battery" and activator:SH_CanAffordPremium(toGive*standardCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*standardCost)
					paid = toGive*standardCost
				elseif ammoName == "heavy_battery" and activator:SH_CanAffordPremium(toGive*heavyCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*heavyCost)
					paid = toGive*heavyCost
				elseif ammoName == "high_power_battery" and activator:SH_CanAffordPremium(toGive*highCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*highCost)
					paid = toGive*highCost
				elseif ammoName == "Grenade" and activator:SH_CanAffordPremium(toGive*grenadeCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*grenadeCost)
					paid = toGive*grenadeCost
				elseif ammoName == "RPG_Round" and activator:SH_CanAffordPremium(toGive*rocketCost) then
					canAfford = true
					activator:SH_AddPremiumPoints(-toGive*rocketCost)
					paid = toGive*rocketCost
				end
				if canAfford == true then
					self:SetSkin(3)
					self:EmitSound("buttons/button6.wav")
					activator:ChatPrint("You have bought ".. toGive .. " " .. ammoName .. " ammo for ".. paid .. " credits.")
					activator:GiveAmmo(toGive, ammoType, false)
					delay4 = true
					timer.Simple( dispencer_timer, function()
					self:SetSkin(7)
					delay4 = false
					end)
				else
					activator:ChatPrint("You cant afford that much ammo!")
				end
			end
		end
	end	
end

function ENT:Think()
end