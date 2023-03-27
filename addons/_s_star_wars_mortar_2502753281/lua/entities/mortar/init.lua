AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/dolunity/starwars/mortar.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	self:InitGunnerSeat()

	self:SetHealth(500)
	self:SetMaxHealth(500)

	self:SetNWInt("ShellClassId", 2)
end

function ENT:InitGunnerSeat()
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	seat:SetModel("models/props_junk/sawblade001a.mdl")
	seat:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview", 0)
	seat:Spawn()
	seat:Activate()
	seat:SetPos(self:GetPos())
	seat:SetAngles(self:GetAngles())
	seat:SetParent(self)
	seat:SetLocalPos(Vector(-15,10,0))
	seat:SetLocalAngles(Angle(0,0,0))
	seat:DrawShadow(false)
	seat:SetNoDraw(true)
	seat:SetNotSolid(true)
	seat:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self.GunnerSeat = seat
end

function ENT:Use(activator, caller, useType, value)
	if (self:Health() <= 0) then
		return
	end

	if (activator:Crouching()) then
		if (self:GetSkin() == 1) then
			activator:Give("mortar_constructor_dark")
		else
			activator:Give("mortar_constructor")
		end
		self:Remove()
		return
	end
	activator:EnterVehicle(self.GunnerSeat)
end

function ENT:GetGunner()
	if (not IsValid(self.GunnerSeat)) then
		self:InitGunnerSeat()
	end

	return self.GunnerSeat:GetDriver()
end

function ENT:Think()
	if (self:Health() <= 0) then
		return
	end

	local gunner = self:GetGunner()
	local rot = 0
	local ang = 0
	if (IsValid(gunner)) then
		if (gunner:KeyDown(IN_MOVELEFT)) then
			rot = self.RotatingSteps
		elseif (gunner:KeyDown(IN_MOVERIGHT)) then
			rot = -self.RotatingSteps
		elseif (gunner:KeyDown(IN_FORWARD)) then
			ang = self.AnglingSteps
		elseif (gunner:KeyDown(IN_BACK)) then
			ang = -self.AnglingSteps
		elseif (gunner:KeyDown(IN_RELOAD)) then
			self:ChangeShell()
		elseif (gunner:KeyDown(IN_JUMP)) then
			self:FireShell()
		end
	end


	--self:SetLocalAngles(self:GetLocalAngles() + Angle(0,z,0))
	local barrelId = self:LookupBone("Barrel")
	local barrelAngle = self:GetManipulateBoneAngles(barrelId) + Angle(rot,0,ang)
	barrelAngle.z = math.Clamp(barrelAngle.z, self.AnglingMin, self.AnglingMax)

	self:ManipulateBoneAngles(barrelId, barrelAngle)
	self.GunnerSeat:SetLocalAngles(self.GunnerSeat:GetLocalAngles() + Angle(0,rot,0))
	local seatPos = self.GunnerSeat:GetLocalPos()
	seatPos:Rotate(Angle(0, rot , 0))
	self.GunnerSeat:SetPos(seatPos)

	local hipId = self:LookupBone("BipodHip")
	local hipAngle = 90 - barrelAngle.z
	self:ManipulateBoneAngles(hipId, Angle(0,0,hipAngle * 2 - 90))

	self.AnglePrc = (barrelAngle.z - self.AnglingMin) / self.AnglingMax
	local legL = self:LookupBone("BipodLegL")
	local legR = self:LookupBone("BipodLegR")
	self:ManipulateBoneAngles(legL, Angle(0,40 * self.AnglePrc,0))
	self:ManipulateBoneAngles(legR, Angle(0,-40 * self.AnglePrc,0))

	self:NextThink(CurTime())
	return true
end

function ENT:FireShell()
	if (self:GetNWInt("NextFire") > CurTime()) then return end

	local animTime = self:GetGunner():SequenceDuration(self:GetGunner():LookupSequence("gesture_item_give")) - 0.1
	self:GetGunner():DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
	self:SetNWInt("NextFire", CurTime() + self.FireRate + animTime)

	timer.Simple(animTime, function ()
		local muzzleId = self:LookupAttachment("Muzzle")
		local barrelId = self:LookupBone("Barrel")

		local shellPos = self:GetAttachment(muzzleId).Pos
		local shellAng = self:GetAttachment(muzzleId).Ang
		local shell = ents.Create(self.ShellClasses[table.GetKeys(self.ShellClasses)[self:GetNWInt("ShellClassId")]])
		if (not IsValid(shell)) then
			error("Could not create shell entity")
			return
		end
		shell:SetPos(shellPos)
		shell:SetAngles(shellAng)
		shell:SetOwner(self)
		shell:Spawn()
		shell:GetPhysicsObject():SetMass(100)
		local offset = Vector(math.random() * 100 - 50, math.random() * 100 - 50, math.random() * 100 - 50)
		offset = offset - offset:Angle():Right() / 2
		shell:GetPhysicsObject():SetVelocity((shellAng:Right() * -1 * 4000 * (self.AnglePrc + 0.3)) + offset)

		local effectdata = EffectData()
		effectdata:SetOrigin(shellPos)
		local eAngle = (shellAng:Right() * -1):Angle()
		effectdata:SetAngles(eAngle)
		util.Effect("MuzzleEffect", effectdata)

		self:EmitSound("weapons/mortarfiring.mp3")
	end)
end

function ENT:ChangeShell()
	if (self:GetNWInt("NextShell") > CurTime()) then return end

	self:SetNWInt("NextShell", CurTime() + self.ShellChangeRate)

	local id = self:GetNWInt("ShellClassId") + 1

	if (id > table.Count(self.ShellClasses)) then
		self:SetNWInt("ShellClassId", 1)
	else
		self:SetNWInt("ShellClassId", id)
	end
end

function ENT:OnTakeDamage(dmg)
	if (self:Health() <= 0) then
		return
	end

	self:SetHealth(self:Health() - dmg:GetDamage())

	if (self:Health() <= 0) then
		self:Destroy()
	end
end

function ENT:Destroy()
	if (self.GunnerSeat:GetDriver():IsPlayer()) then
		self.GunnerSeat:GetDriver():ExitVehicle()
	end

	local barrelId = self:LookupBone("Barrel")
	local hipId = self:LookupBone("BipodHip")
	local legL = self:LookupBone("BipodLegL")
	local legR = self:LookupBone("BipodLegR")

	local barrelAngle = self:GetManipulateBoneAngles(barrelId)
	barrelAngle.z = 83
	self:ManipulateBoneAngles(barrelId, barrelAngle)

	self:ManipulateBoneAngles(hipId, Angle(0,0,-90))
	self:ManipulateBoneAngles(legL, Angle(0,100,0))
	self:ManipulateBoneAngles(legR, Angle(0,-42,0))
end