if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.PrintName = "DLT-23V Replacement Barrel"
	SWEP.Author = "Stryker & Venator"
	SWEP.ViewModelFOV = 70
	SWEP.Slot = 1
	SWEP.SlotPos = 3
end

DEFINE_BASECLASS("tfa_gun_base")
SWEP.HoldType = "melee2"
SWEP.Category = "Star Wars Emplacement Ammo"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.Primary.Sound = Sound("items/ammo_pickup.wav")
SWEP.Primary.ReloadSound = Sound ("weapons/shared/standard_reload.ogg");
SWEP.Weight = 2
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.ClipSize = 2
SWEP.Primary.RPM = 500
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SMG1_Grenade"

SWEP.Secondary.Damage = 10
SWEP.DamageType = DMG_SLASH
SWEP.data = {}
SWEP.data.ironsights = 0
SWEP.WeaponLength = 1
SWEP.IsMelee = true
SWEP.UseHands         = true
SWEP.ShowWorldModel = false
SWEP.WElements = {
    ["tube"] = { type = "Model", model = "models/weapons/ven_riddick/dlt23v_tube.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.3, 3), angle = Angle(6, -28, -90), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Secondary.Automatic = true
SWEP.Secondary.RPM = 60 --Secondary stabs per minute
SWEP.Secondary.Delay = 0.33 --Delay for hull (secondary)
SWEP.Secondary.Length = 48
SWEP.Primary.Sound = Sound("Weapon_Crowbar.Single") --Sounds
SWEP.KnifeShink = "npc/combine_soldier/vo/fist.wav" --Sounds
SWEP.KnifeSlash = "npc/combine_soldier/vo/fist.wav" --Sounds
SWEP.KnifeStab = "npc/combine_soldier/vo/fist.wav" --Sounds
SWEP.SlashTable = {"midslash1", "midslash2"} --Table of possible hull sequences
SWEP.StabTable = {"stab"} --Table of possible hull sequences
SWEP.StabMissTable = {"stab_miss"} --Table of possible hull sequences
SWEP.DisableIdleAnimations = true


SWEP.HullData = {
	hullMin = Vector(-16, -16, -16),
	hullMax = Vector(16, 16, 16)
}

SWEP.SlashCounter = 1
SWEP.StabCounter = 1

function SWEP:Deploy()
	return BaseClass.Deploy(self)
end

SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2

function SWEP:PrimaryAttack()
if self:Clip1() <= 0 then return end
self:TakePrimaryAmmo( 1 )
self.Weapon:EmitSound( "items/ammo_pickup.wav" )
if SERVER then
	local ent = ents.Create("prop_physics")
	ent:SetPos(self:GetPos() + Vector(0,50,30))
	ent:SetModel("models/weapons/ven_riddick/dlt23v_tube.mdl")
	ent.gredGunEntity = "23v_lafette"
	ent:SetBodygroup(1,1)
	ent:Spawn()
	timer.Simple(35, function() if IsValid(ent) then ent:Remove() end end )
	ent:Activate()	
	local p=ent:GetPhysicsObject()
	if IsValid(p) then
		p:SetMass(35)
	end
	constraint.NoCollide(self,ent,0,0)
	

end


end

function SWEP:ApplyForce(ent, force, posv, now)
	if not IsValid(ent) or not ent.GetPhysicsObjectNum then return end

	if now then
		if ent.GetRagdollEntity then
			ent = ent:GetRagdollEntity() or ent
		end

		if not IsValid(ent) then return end
		local phys = ent:GetPhysicsObjectNum(0)

		if IsValid(phys) then
			if ent:IsPlayer() or ent:IsNPC() then
				ent:SetVelocity( force * 0.1 * lim_up_vec )
				phys:SetVelocity(phys:GetVelocity() + force * 0.1 * lim_up_vec )
			else
				phys:ApplyForceOffset(force, posv)
			end
		end
	end
end


function SWEP:SlashSound(tr)
	if IsFirstTimePredicted() then
		if tr.Hit then
			if tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH then
				self:EmitSound(self.KnifeSlash)
			else
				self:EmitSound(self.KnifeShink)
			end
		else
			self:EmitSound(self.Primary.Sound)
		end
	end
end

function SWEP:GetSlashTrace(tbl, fwd)
	local ow = self:GetOwner()
	ow:LagCompensation(true)

	local traceRes = util.TraceLine(tbl)

	if (not traceRes.Hit) then
		if not self.HullData.Radius then
			self.HullData.Radius = self.HullData.hullMin:Distance(self.HullData.hullMax) / 2
		end

		local hd = self.HullData
		tbl.mins = -hd.hullMin
		tbl.maxs = hd.hullMax
		tbl.endpos = tbl.endpos - fwd * hd.Radius
		traceRes = util.TraceHull(tbl)
	end
	ow:LagCompensation(false)

	return traceRes
end

function SWEP:SmackDamage(tr, fwd, Secondary)
	if not tr.Entity:IsValid() then return end
	local dmg, force

	if Secondary then
		dmg = self:GetStat("Secondary.Damage")
	end

	force = 40 * 25
	local dmginfo = DamageInfo()
	dmginfo:SetAttacker(self:GetOwner())
	dmginfo:SetInflictor(self)
	dmginfo:SetDamage(40)
	dmginfo:SetDamageType(self.DamageType)
	dmginfo:SetDamagePosition(tr.HitPos)
	dmginfo:SetReportedPosition(tr.StartPos)
	dmginfo:SetDamageForce(fwd * force)
	tr.Entity:DispatchTraceAttack(dmginfo, tr, fwd)
	self:ApplyForce( tr.Entity, dmginfo:GetDamageForce(), tr.HitPos )
end

function SWEP:SmackEffect(tr)
	local vSrc = tr.StartPos
	local bFirstTimePredicted = IsFirstTimePredicted()
	local bHitWater = bit.band(util.PointContents(vSrc), MASK_WATER) ~= 0
	local bEndNotWater = bit.band(util.PointContents(tr.HitPos), MASK_WATER) == 0

	local trSplash = bHitWater and bEndNotWater and util.TraceLine({
		start = tr.HitPos,
		endpos = vSrc,
		mask = MASK_WATER
	}) or not (bHitWater or bEndNotWater) and util.TraceLine({
		start = vSrc,
		endpos = tr.HitPos,
		mask = MASK_WATER
	})

	if (trSplash and bFirstTimePredicted) then
		local data = EffectData()
		data:SetOrigin(trSplash.HitPos)
		data:SetScale(1)

		if (bit.band(util.PointContents(trSplash.HitPos), CONTENTS_SLIME) ~= 0) then
			data:SetFlags(1) --FX_WATER_IN_SLIME
		end

		util.Effect("watersplash", data)
	end

	self:DoImpactEffect(tr, self.DamageType)

	if (tr.Hit and bFirstTimePredicted and not trSplash) then
		local data = EffectData()
		data:SetOrigin(tr.HitPos)
		data:SetStart(vSrc)
		data:SetSurfaceProp(tr.SurfaceProps)
		data:SetDamageType(self.DamageType)
		data:SetHitBox(tr.HitBox)
		data:SetEntity(tr.Entity)
		util.Effect("Impact", data)
	end
end

local tracedata = {}

function SWEP:Slash(bSecondary)
	local ow, gsp, ea, fw, tr, rpm, delay

	if bSecondary == nil then
		bSecondary = true
	end

	ow = self:GetOwner()
	gsp = ow:GetShootPos()
	ea = ow:EyeAngles()
	fw = ea:Forward()
	tracedata.start = gsp
	tracedata.endpos = gsp + fw * (bSecondary and self.Secondary.Length or self.Secondary.Length)
	tracedata.filter = ow

	tr = self:GetSlashTrace(tracedata, fw)
	rpm = self:GetStat("Secondary.RPM")
	delay = self:GetStat("Secondary.Delay")
	self:SlashSound(tr)
	self:SmackDamage(tr, fw, bSecondary)
	self:SmackEffect(tr, fw, bSecondary)
	self:SetStatus(TFA.Enum.STATUS_SHOOTING)
	self:SetStatusEnd(CurTime() + 60 / rpm - delay)
end

function SWEP:CanAttack()
	--if not TFA.Enum.ReadyStatus[self:GetStatus()] then return false end
	if CurTime() < self:GetNextSecondaryFire() then return false end
	return true
end

function SWEP:SecondaryAttack()
	if not self:CanAttack() then return end

	if self:GetNextSecondaryFire() < CurTime() and self:GetOwner():IsPlayer() and not self:GetOwner():KeyDown(IN_RELOAD) then
		self.SlashCounter = self.SlashCounter + 1

		if self.SlashCounter > #self.SlashTable then
			self.SlashCounter = 1
		end

		--self:SendViewModelSeq(self.SlashTable[self.SlashCounter])

		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		self:SetNextSecondaryFire(CurTime() + 1 / (self.Secondary.RPM / 60))
		--self:SetStatus(TFA.Enum.STATUS_SILENCER_TOGGLE)
		--self:SetStatusEnd(CurTime() + self.Secondary.Delay)
	end
end

function SWEP:Think2()
	--[[if self:GetStatus() == TFA.Enum.STATUS_SILENCER_TOGGLE and CurTime() > self:GetStatusEnd() then
		self:Slash(false)
	elseif self:GetStatus() == TFA.Enum.STATUS_SILENCER_TOGGLE and CurTime() > self:GetStatusEnd() then
		self:Slash(false)
	end]]

	BaseClass.Think2(self)
end

SWEP.IsKnife = true
SWEP.WeaponLength = 8