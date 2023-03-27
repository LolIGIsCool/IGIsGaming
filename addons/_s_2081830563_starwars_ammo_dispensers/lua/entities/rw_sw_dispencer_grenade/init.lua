AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


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
	self:SetSkin(2)
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
	local dispencer_timer = GetConVar("rw_sw_dispencer_timer"):GetInt()
	if activator:IsPlayer() then
		if delay1 == true then
			self:EmitSound("npc/roller/code2.wav")
			return false
		else 
			self:SetSkin(3)
			self:EmitSound("buttons/button6.wav")
			activator:GiveAmmo(2,"grenade",false)
			delay1 = true
			timer.Simple( dispencer_timer, function()
			self:SetSkin(2)
			delay1 = false
			end)
		end
	end	
end

function ENT:Think()
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if (self:Health() <= 0) then
		self:EmitSound("ambient/explosions/explode_3.wav")
		self:Remove()
	end
end