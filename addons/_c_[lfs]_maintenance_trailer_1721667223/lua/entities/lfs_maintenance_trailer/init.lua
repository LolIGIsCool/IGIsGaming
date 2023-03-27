AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Radius = 500
ENT.RepairAmount = 50

function ENT:Initialize()
	self.Entity:SetModel("models/props_vehicles/generatortrailer01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:NextThink(CurTime())
end

function ENT:Think()
	for _, e in pairs(ents.FindInSphere(self:GetPos(), self.Radius)) do
		if e.LFS then
			if IsValid( e ) then
			
			
				local lfsHP = e:GetHP()
				local lfsMHP = e:GetMaxHP()
				if lfsHP < lfsMHP then
					e:SetHP( lfsHP + self.RepairAmount )
					e:EmitSound("lfs/repair_loop.wav", 100, 100)
				end
				
				local lfsAP = e:GetAmmoPrimary()
				local lfsMAP = e:GetMaxAmmoPrimary()
				local lfsAS = e:GetAmmoSecondary()
				local lfsMAS = e:GetMaxAmmoSecondary()
				if lfsAP < lfsMAP then
					e:SetAmmoPrimary ( lfsAP + math.ceil( lfsMAP / 10 ) )
					e:EmitSound("items/ammo_pickup.wav", 100, 100)
				end
				if lfsAS < lfsMAS then
					e:SetAmmoSecondary( lfsAS + math.ceil( lfsMAS / 10 ) )
					e:EmitSound("items/ammo_pickup.wav", 100, 100)
				end
				
			
			end
		end
	end
	self:NextThink(CurTime()+1)
	return true
end