AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Star Wars Emplacements"
ENT.PrintName 			= "DLT-23V Emplacement"
ENT.Author				= "Venator"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.MuzzleEffect		= ""
ENT.AmmunitionType		= "wac_base_7mm"
ENT.ShotInterval		= .045
ENT.TracerColor			= "Red"

ENT.Recoil				= 2
ENT.RecoilRate			= 1
ENT.OnlyShootSound		= true
ENT.ShootSound			= Sound("Weapon_DLT23V.Single")
ENT.ReloadSound			= "weapons/bf3/pistols.wav"
ENT.ReloadEndSound		= "gred_emp/dhsk/dhsk_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/weapons/ven_riddick/dlt23v_tripod.mdl"
ENT.TurretModel			= "models/weapons/ven_riddick/dlt23v_turret.mdl"

ENT.Spread				= 0.25
ENT.Ammo				= 150
ENT.ReloadTime			= 2.7
ENT.TurretMass			= 200
--[[
ENT.MaxRotation			= Angle(-90, 90)
]]

ENT.OffsetAngle             = Angle(0, 0, 0)

ENT.TurretPos				= Vector(0,0,0)
ENT.WheelsPos				= Vector(0,0,0)
ENT.SeatAngle				= Angle(0,-90,0)
ENT.ShootAngleOffset		= Angle(0,-90,0)
--ENT.ExtractAngle		    = Angle(0,0,0)


--ENT.MaxRotation			= Angle(15,30)
--ENT.MinRotation			= Angle(0, 0)
------------------------
ENT.TurretPos			= Vector(0,-11.72407,34.5)
ENT.SightPos			= Vector(-30,-0.09,9)
ENT.MaxViewModes		= 2

DEFINE_BASECLASS( ENT.Base )

function ENT:AddDataTables()
    self:NetworkVar("Float", 15, "Heat")
	if SERVER then
		self:SetHeat(0)
    end
end

local mat = Material("models/ven-rid/dlt23v/base")

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1, math.random(0, 1))
	return ent
end

function ENT:OnInit()
    self:SetAngles(Angle(0, 90, 0))
end

function ENT:OnThinkCL(ct, ply)
    mat:SetFloat("$detailblendfactor", tostring(self:GetHeat() ) )
end

function ENT:Reload(ply)

	self:ResetSequence(self:LookupSequence("reload"))
	self.sounds.reload:Stop()
	self.sounds.reload:Play()
	self:SetIsReloading(true)

	timer.Simple(2.1, function()
		if !IsValid(self) then return end
		-- local att = self:GetAttachment(self:LookupAttachment("mageject"))
		local prop = ents.Create("prop_physics")
		prop:SetModel("models/weapons/ven_riddick/dlt23v_tube.mdl")
		prop:SetPos(self:LocalToWorld(Vector(30,0,0)))
		prop:SetAngles(self:LocalToWorldAngles(Angle(0,0,0)))
		prop:Spawn()
		prop:Activate()
		self.MagIn = false
		local t = GetConVar("gred_sv_shell_remove_time"):GetInt()
		if t > 0 then
			timer.Simple(t,function()
				if IsValid(prop) then prop:Remove() end
			end)
		end

		if self:GetAmmo() <= 0 then prop:SetBodygroup(1,1) end
		self:SetBodygroup(1,1)
		self:SetBodygroup(2,1)
	end)

	if GetConVar("gred_sv_manual_reload_mgs"):GetInt() == 0 then
		timer.Simple(3.2,function()
			if !IsValid(self) then return end
			self:SetBodygroup(1,0)
			self:SetBodygroup(2,0)
			self.MagIn = true
		end)
		timer.Simple(self:SequenceDuration(),function()
			if !IsValid(self) then return end
			self:SetAmmo(self.Ammo)
			self:SetIsReloading(false)
			self:SetCurrentTracer(0)
		end)
	else
		timer.Simple(3,function()
			if !IsValid(self) then return end
			self.sounds.reload:Stop()
			self:SetPlaybackRate(0)
		end)
	end
end

function ENT:OnTick()
    if self:GetHeat() != 0 then
        if (self:GetNextShot() || 0 ) < CurTime() then
			self:SetHeat( math.max(self:GetHeat() - 1/5 * FrameTime(), 0) )
		end
    end

	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		self:SetBodygroup(1,0)
		if self:GetAmmo() <= 0 then
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
	end
end

function ENT:FireMG(ply, ammo, muzzle)
    local formula = self:GetHeat() + 1/2200 * 200/15

    local rand = math["Rand"]
    local spread  = self["GetSpread"]
    local pos = self:LocalToWorld(muzzle["Pos"])
    local ang = self:LocalToWorldAngles(muzzle["Ang"]) + self["ShootAngleOffset"] + Angle(rand(spread,-spread),rand(spread,-spread)+90,rand(spread,-spread))

    local bullet = {}
    bullet.Num     = 1
    bullet.Src     = pos
    bullet.Dir     =  (ang):Forward()
    bullet.Spread     = vector_zero
    bullet.Tracer    = 1
    bullet.TracerName = "rw_sw_laser_red"
    bullet.Force    = 1
    bullet.Damage    = 25

    self:SetHeat( math.min( formula, 1 ) )
    self:FireBullets( bullet )
end

function ENT:ViewCalc(ply, pos, angles, fov)
    if self:GetViewMode() == 1 then
        local view = {}
        view.origin = self:LocalToWorld(self.SightPos)
        view.angles = ply:EyeAngles()
        view.angles.p = view.angles.p - (self:GetRecoil()) * 0.2
        view.angles.r = self:GetAngles().r
        view.fov = 40
        view.drawviewer = false

        return view
    end
end

hook.Add("VenAmmoBoxAddAmmo","ammotubebox",function(DScrollPanel,self,ply,frame,EmplacementsMounted)
	if !EmplacementsMounted then return end

	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("DLT-23V Replacement barrel")
	DButton:Dock( TOP )
	DButton:DockMargin( 1, 1, 1, 1 )
	DButton.DoClick = function()
		local d = DermaMenu()
		d:AddOption("DLT-23V Replacement barrel",function()
			net.Start("ven_net_ammobox_sv_createammo")
				net.WriteString("models/weapons/ven_riddick/dlt23v_tube.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("23v_lafette")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
end)