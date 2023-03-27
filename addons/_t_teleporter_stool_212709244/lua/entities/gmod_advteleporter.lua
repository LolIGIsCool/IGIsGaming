//Adv. Teleporter
//By Slade Xanthas

AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "base_anim"
ENT.PrintName		= "Teleporter"

function ENT:SetupDataTables() //DTVars.
	self:NetworkVar( "Int", 0, "Beam", {KeyName = "beam"} ) //The beam destination.
	self:NetworkVar( "Bool", 1, "TeleShowBeam", {KeyName = "teleshowbeam"} ) //Whether to show the beam or not.
	self:NetworkVar( "Bool", 2, "TeleShowRadius", {KeyName = "teleshowradius"} ) //Whether to show the teleportation radius or not.
	self:NetworkVar( "Int", 3, "TeleDTRadius", {KeyName = "teledtradius"} ) //The teleportation radius.
end

if CLIENT then

	function ENT:Initialize()

		self.Mat = Material("sprites/tp_beam001")
		self.Sprite = Material("sprites/blueglow2")
		self.LinkedColor = Color(0,255,0,255)
		self.UnlinkedColor = Color(255,0,0,255)
		
		self.RadiusSphere = ClientsideModel("models/dav0r/hoverball.mdl", RENDERGROUP_OPAQUE)
		
		if IsValid(self.RadiusSphere) then
			self.RadiusSphere:SetNoDraw(true)
			self.RadiusSphere:SetPos(self:LocalToWorld(self:OBBCenter()))
			self.RadiusSphere:SetParent(self)
		end
		
	end

	function ENT:Draw()

		self:DrawModel()

		local Destination = Entity(self:GetBeam()) //The entity in self.dt.Beam, set by the server.  This is a DTVar.
		
		if IsValid(self) && IsValid(self.RadiusSphere) then
		
			if self:GetTeleDTRadius() && self:GetTeleShowRadius() then
			
				render.SuppressEngineLighting(true)	
				
				if IsValid(Destination) then
					render.SetColorModulation(0, 1, 0)
				else
					render.SetColorModulation(1, 0, 0)
				end

				render.SetBlend(1)
				self.RadiusSphere:DrawModel()
				render.SuppressEngineLighting(false)
				render.SetBlend(1)
				render.SetColorModulation(1,1,1)
				self.RadiusSphere:SetModelScale(self:GetTeleDTRadius()/5,0)
				self.RadiusSphere:SetMaterial("models/props_combine/portalball001_sheet")
				
			end
		
		end

		--[[if IsValid(self) && IsValid(Destination) && (self:EntIndex() == Destination:GetBeam()) && self:GetTeleShowBeam() && Destination:GetTeleShowBeam() then
			render.SetMaterial(self.Mat)
			render.DrawBeam(self:LocalToWorld(self:OBBCenter()), Destination:LocalToWorld(Destination:OBBCenter()), 4, 2, 0, self.LinkedColor) //omg beam
			render.SetMaterial(self.Sprite)
			local rand = math.random(-2,2)
			render.DrawSprite(self:LocalToWorld(self:OBBCenter()), 6 + rand, 6 + rand, self.LinkedColor)
			render.DrawSprite(Destination:LocalToWorld(Destination:OBBCenter()), 6 + rand, 6 + rand, Destination.LinkedColor)
			self:SetRenderBoundsWS(self:GetPos(), Destination:GetPos()) //Set the render bounds so that the beam doesnt disappear when you look at only one of the teles.
		elseif IsValid(self) then			
			self:SetRenderBoundsWS(self:GetPos()+self:OBBMins(),self:GetPos()+self:OBBMaxs()) //Standard renderbounds.
		end]]--

	end

	function ENT:OnRemove()
		if IsValid(self.RadiusSphere) then
			self.RadiusSphere:Remove()
			self.RadiusSphere = nil
		end
	end

end

if SERVER then

	function ENT:Initialize()

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:DrawShadow(false)
		self:SetUseType(SIMPLE_USE)
		
		self.TeleModel = "models/Items/combine_rifle_ammo01.mdl"
		self.TeleSound = "ambient/levels/citadel/weapon_disintegrate2.wav"
		self.TeleEffect = "sparks"
		self.TeleRadius = 100
		self.TelePlayers = true
		self.TeleProps = true
		self.TeleOnTouch = true
		self.TeleOnUse = true
		self.LastTeleport = CurTime()
		self.NextTeleport = CurTime()
		self:SetTeleShowBeam(false)
		self:SetTeleShowRadius(false)
		
		if Wire_CreateInputs then
			self.Inputs = Wire_CreateInputs(self, {"Teleport","Lock"})
		end
		
		self.tEnts = {}
		
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:LinkUp(ply)

		if IsValid(ply) then
		
			if IsValid(self) //This ent is valid
			&& IsValid(self.DestinationID) //and so is that one
			&& self.Owner == ply //you own this ent
			&& self.DestinationID.Owner == ply then //and that one
				self.Destination = self.DestinationID //YOU ARE WINNER
				self.DestinationID.Destination = self //YOU ARE WINNER TOO		
			end

			for _,v in pairs(ents.FindByClass(self:GetClass())) do	
				
				if IsValid(self) //This ent is valid
				&& IsValid(v) //and so is that one
				&& !self.DestinationID //Our DestinationID isnt already set			
				&& v ~= self //The ent found isnt this one
				&& self.TeleKey //This ents TeleKey exists (always should exist)
				&& v.TeleKey //That ents exists.
				&& v.TeleKey == self.TeleKey //The keys are the same
				&& !self.Destination //This ents Destination doesnt exist
				&& !v.Destination //or that ones
				&& self.Owner == ply //you own this ent
				&& v.Owner == ply then //and that one
					self.Destination = v //YOU ARE WINNER
					v.Destination = self //YOU ARE WINNER TOO
					self.NextTeleport = CurTime() + 1
					v.NextTeleport = CurTime() + 1
					break
				end
				
			end
			
		end

	end

	function ENT:SetTeleporterID(ply,d_ID)
		if d_ID then
			self.DestinationID = d_ID //Set the referenced destination entity
		end
		self:LinkUp(ply) //Link up the teleporters
	end

	function ENT:PreEntityCopy()
		local dupeInfo = {}
		if IsValid(self) && IsValid(self.Destination) then
			dupeInfo.DestinationID = self.Destination:EntIndex() //Grab the destinations entity index
			duplicator.StoreEntityModifier(self, "DestinationDupeInfo", dupeInfo) //store it
		end
	end
		
	function ENT:PostEntityPaste(pl, Ent, CreatedEntities) //Called after the entity is pasted, to properly get the reference IDs the teleporters will use to link up
		self:SetTeleporterID(pl,CreatedEntities[Ent.EntityMods.DestinationDupeInfo.DestinationID])
	end

	function ENT:Setup(model, sound, effect, radius, players, props, ontouch, onuse, showbeam, showradius, key, ply) //Setup all of the values for the teleporter, both the first time and when you update it.

		self.Owner = ply
		self.TeleModel = model
		self.TeleSound = sound
		self.TeleEffect = effect
		self.TeleRadius = radius
		self.TelePlayers = players
		self.TeleProps = props
		self.TeleOnTouch = ontouch
		self.TeleOnUse = onuse
		self:SetTeleShowBeam(showbeam)
		self:SetTeleShowRadius(showradius)
		
		if !self.TeleKey then 
			self.TeleKey = key
		end
		
		if !self:GetModel() then
			self:SetModel(model)
		end
		
		if !IsValid(self.Destination) then
			self:LinkUp(ply) //if the Destination isnt valid, link them up
		end
		
		local Destination = self.Destination
		if IsValid(Destination) && self:GetTeleShowBeam() ~= Destination:GetTeleShowBeam() then
			Destination:SetTeleShowBeam(self:GetTeleShowBeam())
		end
		
	end

	function ENT:CheckValidTeleportEntity(ent)
		return (ent:IsPlayer() && self.TelePlayers) || ent:IsNPC() || (!IsValid(ent:GetParent()) && ent:GetClass() ~= self:GetClass() && ent:GetClass() ~= "prop_ragdoll" && ent:GetMoveType() == MOVETYPE_VPHYSICS && self.TeleProps)
	end

	function ENT:Teleport(ent) //Teleport!

		local Destination = self.Destination
		if !IsValid(Destination) || !IsValid(ent) then return end
		
		if self:CheckValidTeleportEntity(ent) then
			
			ent:SetPos(Destination:GetPos()+Destination:GetUp()*50) 

			table.insert(self.tEnts,ent)
			table.insert(Destination.tEnts,ent)
		
		end

	end

	function ENT:Use(activator,caller)
		if IsValid(activator) && activator:IsPlayer() then
			self.Activator = activator
			self.IsBeingUsed = true
		end
	end

	function ENT:Think()

		if !IsValid(self) then return end
		
		local Destination = self.Destination
		
		if self:GetTeleShowRadius() then
			if self:GetTeleDTRadius() && self:GetTeleDTRadius() ~= self.TeleRadius then
				self:SetTeleDTRadius(self.TeleRadius)
			end
		end
		
		if IsValid(Destination) then

			self:SetBeam(Destination:EntIndex())
			Destination:SetBeam(self:EntIndex())

			local area = ents.FindInSphere(self:GetPos(),self.TeleRadius)

			for i,ent in pairs(area) do
			
				local ConstrainedEntities = constraint.GetAllConstrainedEntities(ent)

				if IsValid(ent) 
				&& ent ~= self
				&& ent ~= Destination
				&& Destination.NextTeleport < CurTime() then
					self:Teleport(ent)
					self.NextTeleport = CurTime() + 2
				end
				
			end	

			self.IsBeingUsed = false
			
		else
			
			self.Destination = nil
			
		end

		self:NextThink(CurTime())
		return true

	end

	local function On(pl, ent)
		if !IsValid(ent) then return end
		ent.KeyOn = true
		return true
	end

	local function Off(pl, ent)
		if !IsValid(ent) then return end
		ent.KeyOn = false
		return true
	end

	numpad.Register("Teleporter_On", On)
	numpad.Register("Teleporter_Off", Off)

	function ENT:TriggerInput(iname, value)

		if (iname == "Teleport") then
		
			if value == 1 then 
				self.WireTeleport = true 
			end
			
			if value == 0 && self.WireTeleport then 
				self.WireTeleport = false 
			end
			
		end
		
		if (iname == "Lock") then
		
			if value == 1 && !self.Locked then 
				self.Locked = true 
			end
			
			if value == 0 && self.Locked then 
				self.Locked = false 
			end

		end
		
	end

end