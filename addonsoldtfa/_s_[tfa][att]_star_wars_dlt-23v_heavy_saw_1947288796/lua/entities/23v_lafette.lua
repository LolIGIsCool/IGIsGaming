AddCSLuaFile()

ENT.Type 				= "anim"
ENT.Base 				= "gred_emp_base"

ENT.Category			= "Star Wars Emplacements"
ENT.PrintName 			= "DLT-23V Emplacement"
ENT.Author				= "Venator"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.MuzzleEffect		= "tfa_muzzleflash_rifle"
ENT.ExtractAngle		= Angle(0,0,0)
ENT.AmmunitionType		= "ar2"
ENT.ShotInterval		= .035
ENT.TracerColor			= "Red"

ENT.Recoil				= 4.4
ENT.RecoilRate			= 4
ENT.OnlyShootSound		= true
ENT.ShootSound			= Sound ("Weapon_DLT23V.Single");
ENT.ReloadSound			= "weapons/bf3/pistols.wav"
ENT.ReloadEndSound		= "gred_emp/dhsk/dhsk_reloadend.wav"

ENT.EmplacementType		= "MG"
ENT.HullModel			= "models/weapons/ven_riddick/dlt23v_tripod.mdl"
ENT.TurretModel			= "models/weapons/ven_riddick/dlt23v_turret.mdl"

ENT.Spread				= .9
ENT.Ammo				= 150
ENT.ReloadTime			= 2.7
ENT.TurretMass			= 200
ENT.MaxRotation			= Angle(50,85)
ENT.PitchRate			= 15
ENT.YawRate				= 15
------------------------

ENT.TurretPos			= Vector(0,-11.72407,34.5)
ENT.SightPos			= Vector(0.07,-30,8)
ENT.MaxViewModes		= 1

function ENT:SpawnFunction( ply, tr, ClassName )
	if (  !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 7
	local ent = ents.Create(ClassName)
 	ent.Owner = ply
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	ent:SetBodygroup(1,math.random(0,1))
	return ent
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
	if SERVER and (!self:GetIsReloading() or (self:GetIsReloading() and self.MagIn)) then
		self:SetBodygroup(1,0)
		if self:GetAmmo() <= 0 then 
			self:SetBodygroup(2,1)
		else
			self:SetBodygroup(2,0)
		end
	end
end

function ENT:ViewCalc(ply, pos, angles, fov)
	if self:GetShooter() != ply then return end
	if self:GetViewMode() == 1 then
		angles = ply:EyeAngles()
		angles.p = angles.p - (self:GetRecoil())*0.8
		local view = {}
		view.origin = self:LocalToWorld(self.SightPos)
		view.angles = angles
		view.fov = 30
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


function ENT:FireMG(ply,ammo,muzzle)
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
    bullet.TracerName = "effect_sw_laser_red"
    bullet.Force    = 1
    bullet.Damage    = 25

    self:FireBullets( bullet )
end