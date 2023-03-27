AddCSLuaFile()
SWEP.PrintName = "Venom Gun"
SWEP.Slot = 2
SWEP.SlotPos = 1


if (file.Exists("../materials/weapons/weapon_mad_deagle.vmt", "GAME")) then
SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_deagle")
end


SWEP.HoldType = "pistol"
SWEP.Category = "Mito's Guns"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"


SWEP.Base = weapon_base

SWEP.Author			= "Mito"
SWEP.Contact		= "mitoqa@gmail.com"
SWEP.Purpose		= "Silently take down opponents."
SWEP.Instructions	= "Left click to shoot venom darts which slowly kill the target."

SWEP.Spawnable	= true
SWEP.AdminOnly = false
SWEP.Primary.Sound = Sound("")

SWEP.Primary.Cone = 1
SWEP.Primary.Delay = 3
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBowBolt"


SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo	= ""


function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound("")

	self:ShootBullet( 0.01, 1, 0.01 )

	self:TakePrimaryAmmo( 1 )

	self.Owner:ViewPunch( Angle( -3, -1, 0 ) )

end

function SWEP:CanPrimaryAttack()

	if ( self.Weapon:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 1 )
		self:Reload()
		return false

	end

	return true

end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
local bullet = {}

	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos()
	bullet.Dir 	= self.Owner:GetAimVector()
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )
	bullet.Tracer	= 0
	bullet.Force	= 0
	bullet.Damage	= damage
	bullet.AmmoType = "XBowBolt"
	bullet.Callback = function (attacker, trace, damageInfo)
	local tre = trace.Entity
	if IsValid(trace.Entity) then
	if trace.Entity:IsPlayer() then
	local timerName = "PoisonTimer_" .. tre:SteamID()

		 if (timer.Exists( "PoisonTimer_" .. tre:SteamID())  == false) then
	     --timer.Create( timerName, 3, 40, function() if tre:IsValid() then if tre:IsPlayer() then tre:SetHealth( tre:Health() - math.random( 3, 10 ) ) end end end )
		 timer.Create( timerName, 5, 12, function() if tre:IsValid() then if tre:IsPlayer() then if SERVER then tre:TakeDamage( math.random( 15, 50 ), self.Owner, self.Weapon:GetName() ) end end end end )
		 end

	elseif trace.Entity:IsNPC() then
	local npctimerName = "NPCPoisonTimer"

	     if (timer.Exists( "NPCPoisonTimer" )  == false) then
	     timer.Create( npctimerName, 3, 40, function() if tre:IsValid() then if SERVER then tre:TakeDamage( math.random( 3, 10 ), self.Owner, self.Weapon:GetName() ) end end end )
         end
  end
end
end

	self.Owner:FireBullets( bullet )

	self:ShootEffects()
	end

	function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:TakePrimaryAmmo( num )

	if ( self.Weapon:Clip1() <= 0 ) then

		if ( self:Ammo1() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self.Weapon:GetPrimaryAmmoType() )

	return end

	self.Weapon:SetClip1( self.Weapon:Clip1() - num )

end

function SWEP:Reload()

 self:DefaultReload( ACT_VM_RELOAD )

end


/********************************************************
	SWEP Construction Kit base code
		Created by Clavus
	Available for public use, thread at:
	   facepunch.com/threads/1032378


	DESCRIPTION:
		This script is meant for experienced scripters
		that KNOW WHAT THEY ARE DOING. Don't come to me
		with basic Lua questions.

		Just copy into your SWEP or SWEP base of choice
		and merge with your own code.

		The SWEP.VElements, SWEP.WElements and
		SWEP.ViewModelBoneMods tables are all optional
		and only have to be visible to the client.
********************************************************/

function SWEP:Initialize()



	if CLIENT then

		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels

		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)

				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")
				end
			end
		end

	end

end

function SWEP:Holster()

	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()

		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end

		if (!self.VElements) then return end

		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then


			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end

		end

		for k, name in ipairs( self.vRenderOrder ) do

			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (!v.bone) then continue end

			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )

			if (!pos) then continue end

			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end

				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end

			elseif (v.type == "Sprite" and sprite) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

			elseif (v.type == "Quad" and v.draw_func) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end

		end

	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()

		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end

		if (!self.WElements) then return end

		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end

		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else

			bone_ent = self
		end

		for k, name in pairs( self.wRenderOrder ) do

			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end

			local pos, ang

			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end

			if (!pos) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end

				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end

			elseif (v.type == "Sprite" and sprite) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)

			elseif (v.type == "Quad" and v.draw_func) then

				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end

		end

	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )

		local bone, pos, ang
		if (tab.rel and tab.rel != "") then

			local v = basetab[tab.rel]

			if (!v) then return end


			pos, ang = self:GetBoneOrientation( basetab, v, ent )

			if (!pos) then return end

			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

		else

			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end

			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			if (IsValid(self.Owner) and self.Owner:IsPlayer() and
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end

		end

		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end


		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then

				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end

			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite)
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then

				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }

				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)

			end
		end

	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)

		if self.ViewModelBoneMods then

			if (!vm:GetBoneCount()) then return end



			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end

				loopthrough = allbones
			end


			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end


				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms


				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end

	end

	function SWEP:ResetBonePositions(vm)

		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end

	end

	/**************************
		Global utility code
	**************************/

	function table.FullCopy( tab )

		if (!tab) then return nil end

		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end

		return res

	end

end

SWEP.VElements = {
	["supring"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(2.799, 0.125, 0), angle = Angle(90, 0, 0), size = Vector(0.035, 0.035, 0.035), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["sidesup"] = { type = "Model", model = "models/mechanics/robotics/claw2.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(0.699, 0, 2.15), angle = Angle(-73.637, 0, 90), size = Vector(0.039, 0.05, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["tanksupp+"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-6.5, 1.057, 1.149), angle = Angle(0, 0, -90), size = Vector(0.2, 0.2, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["belowsup"] = { type = "Model", model = "models/mechanics/roboticslarge/clawl.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(0, 3.135, 0), angle = Angle(0, -90, 0), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["tanksupp"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-8.832, 1.057, 1.149), angle = Angle(0, 0, -90), size = Vector(0.2, 0.2, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tank"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-8.832, -0.201, 1.157), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sidesup+"] = { type = "Model", model = "models/mechanics/robotics/claw2.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(0.699, 0, -2.151), angle = Angle(73.636, 0, -90), size = Vector(0.039, 0.05, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["poisonring"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(2.799, 0.125, 0), angle = Angle(90, 0, 0), size = Vector(0.034, 0.034, 0.034), color = Color(0, 255, 0, 255), surpresslightning = false, material = "models/shadertest/shader4", skin = 0, bodygroup = {} },
	["contai"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-2.597, 2.13, 0), angle = Angle(90, 0, 90), size = Vector(0.1, 0.25, 0.2), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tank+"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.muzzle", rel = "", pos = Vector(-6.5, -0.201, 1.157), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["suppring"] = { type = "Model", model = "models/hunter/tubes/tube2x2x025.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.5, -4.25, 10.809), angle = Angle(-0.051, -4, -5), size = Vector(0.035, 0.035, 0.035), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["poisonring"] = { type = "Model", model = "models/hunter/tubes/circle2x2.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.5, -4.211, 10.8), angle = Angle(-0.5, -5, -5), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/shadertest/shader4", skin = 0, bodygroup = {} },
	["sidesup"] = { type = "Model", model = "models/mechanics/robotics/claw2.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.54, -4.676, 8.85), angle = Angle(16.364, -5, 85), size = Vector(0.039, 0.05, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["tanksupp+"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.25, -2.701, 2.697), angle = Angle(0, -5, -95), size = Vector(0.2, 0.2, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tank+"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.158, -3.8, 2.596), angle = Angle(90, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tanksupp"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.351, -2.497, 0.619), angle = Angle(0, -5, -95), size = Vector(0.2, 0.2, 0.189), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["tank"] = { type = "Model", model = "models/props_combine/breentp_rings.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-1.259, -3.636, 0.518), angle = Angle(90, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(0, 255, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sidesup+"] = { type = "Model", model = "models/mechanics/robotics/claw2.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(2.55, -4.256, 8.85), angle = Angle(16.364, 175, 95), size = Vector(0.039, 0.05, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} },
	["container"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.25, -1.658, 5.714), angle = Angle(-0.5, -5, 85), size = Vector(0.1, 0.25, 0.2), color = Color(100, 100, 100, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["suppclaw"] = { type = "Model", model = "models/mechanics/roboticslarge/clawl.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(0.2, -1, 8.31), angle = Angle(5, -95, 90), size = Vector(0.059, 0.059, 0.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/v_stunbaton/w_shaft01a", skin = 0, bodygroup = {} }
}


SWEP.IronSightsPos = Vector(-5.829, -3.418, 3.819)
SWEP.IronSightsAng = Vector(0, -1, 0)
