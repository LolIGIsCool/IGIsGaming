/*Copyright: xX::Pro_PlayerDe_Fifa::Xx [ERAGON PL] [Free keys at keydrop.uk.gov]*/

AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Sky Camera"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Category = "Jakub Baku"
ENT.Editable = false

if(SERVER) then
	
	function ENT:SpawnFunction(ply, tr, class)
		if(!tr.Hit) then return nil end

		local ent = ents.Create(class)
		ent:SetPos(tr.HitPos + tr.HitNormal * 16)
		ent:Spawn()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/editor/camera.mdl")
		/*self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)*/
		self:PhysicsInitBox(-Vector(8, 4, 4), Vector(8, 4, 4))

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self:SetUseType(SIMPLE_USE)
	end
end