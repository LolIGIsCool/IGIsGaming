function EFFECT:Init(data)
	--print("bourne bourne bourne yes ur gonna bourne")
	self.PartName = "flamethrower_halloween_crit_blue"
	self.EntityV = data:GetEntity()
	self.Attachment = data:GetAttachment()
	if not IsValid(self.EntityV) then return end
	if not self.Attachment then return end
	--[[if IsValid(self.EntityV) and self.EntityV:IsFirstPerson() then
		self.EntityV = self.EntityV.OwnerViewModel
	end]]
	if self.EntityV:GetOwner() == LocalPlayer() then
		self.EntityV = self.EntityV.OwnerViewModel
	end

	ParticleEffectAttach(self.PartName, PATTACH_POINT_FOLLOW, self.EntityV, self.Attachment)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end