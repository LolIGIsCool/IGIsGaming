AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("IG_Squad_Heal_ChatPrint")

hook.Add("PlayerInitialSpawn", "IG_SET_SQUAD_INT", function(ply)
	ply:SetNWInt("IG_Squad_Shield_Cooldown", 0)
end)

function ENT:Initialize()
	self:SetModel('models/squadshield/squad_shield.mdl')
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:AddEffects(EF_NOSHADOW)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local phys = self:GetPhysicsObject()
	
	self.SoundLoop = CreateSound(self,'ambient/levels/citadel/field_loop2.wav') --'ambient/machines/combine_shield_loop3.wav'
	self.SoundLoop:SetSoundLevel(80)

	if (phys:IsValid()) then
		phys:Wake()
	end
	self:ToggleShield(true)
end

function ENT:Think()
	for k, v in ipairs( ents.FindInSphere(self:GetPos(),180) ) do
    	if v:GetClass() == "player" then
    		if v:Health() < v:GetMaxHealth() then
    			v:SetHealth(v:Health()+1)
    		end
		end
	end
end

function ENT:ToggleShield(bool)
	if bool then
		self.SoundLoop:PlayEx(0.32,64)
		self:EmitSound('ambient/machines/thumper_hit.wav',80,64,.64)
		self:EmitSound('npc/scanner/scanner_siren1.wav',80,88,.64)
		self:EmitSound('ambient/levels/citadel/pod_open1.wav',80,100,.64)
	else
		self.SoundLoop:Stop()
		self:EmitSound('ambient/levels/canals/headcrab_canister_open1.wav',80,120,.64)
		self:EmitSound('ambient/levels/citadel/pod_close1.wav',80,100,.64)
		self.Destructable = CurTime()
	end
end



function ENT:OnRemove()
	self.SoundLoop:Stop()
end