if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Blue Tibanna Stun Cartridges"
ATTACHMENT.ShortName = "BTSC" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = {
TFA.AttachmentColors["="],"Stun ammo. Uses charges to stop your target for 60 seconds.",
TFA.AttachmentColors["-"],"10 Charges",
TFA.AttachmentColors["-"],"75 RPM",
}
ATTACHMENT.Icon = "entities/stun_ammo.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.Damage = 8

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = 5,
		["ClipSize"] = 10,
		["DefaultClip"] = 10,
		["RPM"] = 75,
		["RPM_Burst"] = function( wep, val) return val * 0.75 end,
		["Spread"] = function( wep, val) return val * 2 end,
		["IronAccuracy"] = function( wep, val) return val * 10 end,
		["Force "] = 500,
		["AmmoConsumption"] = 1,
		["Ammo"] = "standard_battery",
		["Sound"] = "weapons/bf3/e11_stun.wav"
	},
	["MoveSpeed"] = 1,
	["TracerName"] = "e11_blue_stun",
}


function ATTACHMENT:MakeInvisible(player, invisible)
	player:SetNoDraw(invisible)
	player:SetNotSolid(invisible)

	player:DrawViewModel(!invisible)
	player:DrawWorldModel(!invisible)

	if (invisible) then
		player:GodEnable()
	else
		player:GodDisable()
	end
end

function ATTACHMENT:Ragdoll(target)

	target.sim_stun_Weapons = {}
	
	for k, weapon in pairs(target:GetWeapons()) do
		if IsValid(weapon) then
			table.insert(target.sim_stun_Weapons, weapon:GetClass())
		end
	end

	target.sim_stun_Ragdoll = ents.Create("prop_ragdoll")
	target.sim_stun_Ragdoll:SetPos(target:GetPos())
	target.sim_stun_Ragdoll:SetModel(target:GetModel())
	target.sim_stun_Ragdoll:SetAngles(target:GetAngles())
	target.sim_stun_Ragdoll:SetSkin(target:GetSkin())
	target.sim_stun_Ragdoll:SetMaterial(target:GetMaterial())
	target.sim_stun_Ragdoll:Spawn()

	target.sim_stun_Ragdoll:CallOnRemove("UnragdollPlayer", function(ragdoll)
		if IsValid(target) then
			self:MakeInvisible(target, false)

			local position = ragdoll:GetPos()

			target:SetParent(NULL)
			target:Spawn()
			timer.Simple(0.1, function()
				target:SetPos(position + Vector(0, 0, 5))
			end)

			if (target.sim_stun_Weapons) then
				for k, weapon in pairs(target.sim_stun_Weapons) do
					target:Give(weapon)
				end
			end

			target.sim_stun_Weapons = nil
		end
	end)

	target.sim_stun_Ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local velocity = target:GetVelocity()
	local physObjects = target.sim_stun_Ragdoll:GetPhysicsObjectCount() - 1

	for i = 0, physObjects do
		local bone = target.sim_stun_Ragdoll:GetPhysicsObjectNum(i)

		if IsValid(bone) then
			local position, angle = target:GetBonePosition(target.sim_stun_Ragdoll:TranslatePhysBoneToBone(i))

			if (position and angle) then
				bone:SetPos(position)
				bone:SetAngles(angle)
			end

			bone:AddVelocity(velocity)
		end
	end

	target:StripWeapons()
	target:SetMoveType(MOVETYPE_OBSERVER)
	target:Spectate(OBS_MODE_CHASE)
	target:SpectateEntity(target.sim_stun_Ragdoll)
	target:SetParent(target.sim_stun_Ragdoll)

	timer.Simple(1, function()
		if IsValid(self) and IsValid(target) then
			self:UnRagdoll(target)
		end
	end)

	self:MakeInvisible(target, true)
end

function ATTACHMENT:UnRagdoll(target)
	self:MakeInvisible(target, false)
    
	local position = target.sim_stun_Ragdoll:GetPos()

	target:UnSpectate()
	target.sim_stun_Ragdoll:Remove()

	target:SetParent(NULL)
	target:Spawn()
	timer.Simple(0.1, function()
		target:SetPos(position +Vector(0, 0, 5))
	end)

	for k, weapon in pairs(target.sim_stun_Weapons) do
		target:Give(weapon)
	end

	target.sim_stun_Weapons = nil
end

function ATTACHMENT:ShootBullet(damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)
	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
	num_bullets = 1
	aimcone = aimcone or 0

    local TracerName = "e11_blue_stun"

    local barrelPos = self.Owner:GetShootPos()

    -- Make bullet stun code
	local tr = self.Owner:GetEyeTrace()
	if SERVER then
		if tr.Entity and tr.Entity:IsPlayer() and IsValid(tr.Entity) then
			if IsValid(tr.Entity.sim_stun_Ragdoll) then
				self:UnRagdoll(tr.Entity)
			else
				self:Ragdoll(tr.Entity)
			end
		end
	end

    data = EffectData()
    data:SetEntity(self)
    data:SetStart(barrelPos)
    data:SetOrigin(self:GetOwner():GetEyeTrace().HitPos)
    util.Effect(TracerName, data)

    data = nil
end

function ATTACHMENT:Attach(wep)
	wep.ShootBullet = self.ShootBullet
	wep.UnRagdoll = self.UnRagdoll
	wep.Ragdoll = self.Ragdoll
	wep.MakeInvisible = self.MakeInvisible
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep.MuzzleFlashEffect = "rw_sw_muzzleflash_blue"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ShootBullet = baseclass.Get(wep.Base).ShootBullet
	wep.UnRagdoll = baseclass.Get(wep.Base).UnRagdoll
	wep.Ragdoll = baseclass.Get(wep.Base).Ragdoll
	wep.ImpactEffect = "rw_sw_impact_red"
	wep.MuzzleFlashEffect = "rw_sw_muzzleflash_red"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end