/*Copyright: xX::Pro_PlayerDe_Fifa::Xx [ERAGON PL] [Free keys at keydrop.uk.gov]*/

AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Skybox Editor"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Category = "Jakub Baku"
ENT.Editable = true

if(SERVER) then
	util.AddNetworkString("update_skybox_editor")
	util.AddNetworkString("skybox_editor_openmenu")

	function ENT:SpawnFunction(ply, tr, class)
		if(!tr.Hit) then return nil end

		local ent = ents.Create(class)
		ent:SetPos(tr.HitPos + tr.HitNormal * 16)
		ent:Spawn()

		return ent
	end

	function ENT:Initialize()
		self:SetModel("models/maxofs2d/cube_tool.mdl")
		self:SetMaterial("editors/editor_skybox")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:SetNWVector("sky_pos", self:GetPos())

		self.Timer = 0

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self:SetUseType(SIMPLE_USE)
	end

	function ENT:Use(act, caller)
	    if !caller:IsAdmin() then return end
		net.Start("skybox_editor_openmenu")
			net.WriteEntity(self)
		net.Send(act)
	end

	duplicator.RegisterEntityClass("entity_tank_editable", function(ply, data)
		data.Timer = 0
		data.Refresh = 0
		data.LastTime = CurTime()
		data.Models = {}
		return duplicator.GenericDuplicatorFunction(ply, data)
	end, "Data")

	net.Receive("update_skybox_editor", function(len, ply)
		if !ply:IsAdmin() then return end
		local self = net.ReadEntity()
		if(!IsValid(self)) then return end
		self:SetSkyboxTexture(net.ReadString())
	end)
else
	function ENT:Initialize() //proplayer de fifa
		self:ChangeSkyTexture("pro player de fifa", "pro player de fifa", (self:GetSkyboxTexture() or "skybox/sky_day02_07"))
		hook.Add("PostDraw2DSkyBox", self, self.PostDraw2DSkyBox)
		hook.Add("SetupWorldFog", self, self.SetupWorldFog)
		hook.Add("SetupSkyboxFog", self, self.SetupSkyboxFog)

		self.Refresh = 0

		self.Rotation = 0
		self.LastTime = CurTime()

		self.Models = {}
	end

	function ENT:Think()
		if(self.Refresh < CurTime() && !self:GetDisableSkyUpdate()) then
			local props = ents.FindInSphere(self:GetPos(), self:GetSkyboxRadius())
			local table1 = {}

			for k, v in pairs(props) do
				if(v:GetClass() == "prop_physics" or v:GetClass() == "prop_dynamic") then
					table.insert(table1, v)
				end
			end

			local len = math.max(#table1, #self.Models)
			local i = len
			while(i > 0) do
				if(!self.Models[i] && table1[i]) then
					local clent = ClientsideModel("models/props_junk/PropaneCanister001a.mdl")
					clent:SetNoDraw(true)
					self.Models[i] = {ent = clent, model = table1[i]:GetModel(), pos = table1[i]:GetPos() - self:GetPos(), ang = table1[i]:GetAngles()}
				elseif(self.Models[i] && !table1[i]) then
					self.Models[i].ent:Remove()
					self.Models[i] = nil
				else
					self.Models[i].model = table1[i]:GetModel()
					self.Models[i].pos = table1[i]:GetPos() - self:GetPos()
					self.Models[i].ang = table1[i]:GetAngles()
				end

				i = i - 1
			end

			self.Refresh = CurTime() + 0.3
		end
	end

	local colorRT = GetRenderTarget("skybox_color_rt", 8, 8)
	local greenscreen = CreateMaterial("greenscreen_skybox2", "UnlitGeneric", {
		["$basetexture"] = colorRT:GetName(),
		["$nofog"] = 1,
		["$ignorez"] = 1
	})
	function ENT:PostDraw2DSkyBox()
		local color2 = Color(255, 255, 255, 255)
		local size = 16

		self.Rotation = self.Rotation + self:GetSkyboxRotation() * (CurTime() - self.LastTime)
		self.LastTime = CurTime()
		local mat = Matrix()
		mat:SetAngles(Angle(0, self.Rotation, 0))
		mat:SetTranslation(EyePos())
		//mat:SetAngles(Angle(0, self.Rotation, 0))

		local materials

		if(self:GetSkyboxGreenscreen()) then
			materials = {greenscreen, greenscreen, greenscreen, greenscreen, greenscreen, greenscreen}
			color2 = self:GetSkyboxColor():ToColor()
			
			render.PushRenderTarget(colorRT)
			render.Clear(color2.r, color2.g, color2.b, 255)
			render.PopRenderTarget()
		else
			materials = self.CubemapMats
		end

		cam.Start3D(EyePos(), RenderAngles())
			cam.PushModelMatrix(mat)

			render.OverrideDepthEnable(false, true)
			render.SetMaterial(materials[1])
			render.DrawQuadEasy(Vector(1, 0, 0) * size, Vector(-1, 0, 0), size * 2, size * 2, color2, 180)

			render.SetMaterial(materials[4])
			render.DrawQuadEasy(Vector(0, -1, 0) * size, Vector(0, 1, 0), size * 2, size * 2, color2, 180)

			render.SetMaterial(materials[3])
			render.DrawQuadEasy(Vector(-1, 0, 0) * size, Vector(1, 0, 0), size * 2, size * 2, color2, 180)

			render.SetMaterial(materials[2])
			render.DrawQuadEasy(Vector(0, 1, 0) * size, Vector(0, -1, 0), size * 2, size * 2, color2, 180)

			render.SetMaterial(materials[5])
			render.DrawQuadEasy(Vector(0, 0, 1) * size, Vector(0, 0, -1), size * 2, size * 2, color2, 270)

			render.SetMaterial(materials[6])
			render.DrawQuadEasy(Vector(0, 0, -1) * size, Vector(0, 0, 1), size * 2, size * 2, color2, 90)

			render.OverrideDepthEnable(false, false)

			cam.PopModelMatrix()
		cam.End3D()

		if(self:GetEnableSkyCamera() ) then
			local camera = self

			if(self:GetUseSkyCamera() && IsValid(self:GetNWEntity("sky_camera", nil))) then
				camera = self:GetNWEntity("sky_camera", nil)
			end

			mat = Matrix()
			mat:SetTranslation(camera:GetPos())
			mat:Scale(Vector(1, 1, 1) * self:GetSkyboxScale())

			cam.Start3D(EyePos(), RenderAngles())

				for k, v in pairs(self.Models) do
					local mat2 = Matrix()
					mat2:SetTranslation(v.pos)
					mat2:SetAngles(v.ang)

					mat2 = mat * mat2
					v.ent:EnableMatrix("RenderMultiply", mat2)
					render.Model({model = v.model}, v.ent)
				end

			cam.End3D()
		end
	end

	function ENT:SetupSkyboxFog(skyboxscale)
		if(self:GetSkyboxFogEnable()) then
			render.FogMode( MATERIAL_FOG_LINEAR )
			render.FogStart( self:GetFogStart() * skyboxscale )
			render.FogEnd( self:GetFogEnd() * skyboxscale )
			render.FogMaxDensity( self:GetDensity() )

			local col = self:GetFogColor()

			if(self:GetSkyboxFogAuto()) then
				col = self.AutoFog:ToVector()
			end

			render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

			return true
		end
	end

	function ENT:SetupWorldFog(scale)
		if(self:GetSkyboxFogEnable()) then
			render.FogMode( MATERIAL_FOG_LINEAR )
			render.FogStart( self:GetFogStart() )
			render.FogEnd( self:GetFogEnd() )
			render.FogMaxDensity( self:GetDensity() )

			local col = self:GetFogColor()

			if(self:GetSkyboxFogAuto()) then
				col = self.AutoFog:ToVector()
			end
			render.FogColor( col.x * 255, col.y * 255, col.z * 255 )

			return true
		end
	end

	function ENT:OnRemove()
		hook.Remove("PostDraw2DSkyBox", self)
		hook.Remove("SetupWorldFog", self)
		hook.Remove("SetupSkyboxFog", self)

		for k, v in pairs(self.Models) do
			v.ent:Remove()
		end
	end

	function ENT:ChangeSkyTexture(name, old, new)
		if(old != new) then
			local skybox = new

			self.CubemapMats = {
				Material(skybox .. "ft"),
				Material(skybox .. "rt"),
				Material(skybox .. "bk"),
				Material(skybox .. "lf"),
				Material(skybox .. "up"),
				Material(skybox .. "dn"),
			}

			local rt = GetRenderTarget("skybox_foggation_renderation", ScrW(), ScrH())

			render.PushRenderTarget(rt)
			render.Clear(0, 0, 0, 0)

			cam.Start2D()
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(self.CubemapMats[1])
				surface.DrawTexturedRect(0,0, ScrW() * 0.25, ScrH())

				surface.SetMaterial(self.CubemapMats[2])
				surface.DrawTexturedRect(ScrW() * 0.25,0, ScrW() * 0.25, ScrH())

				surface.SetMaterial(self.CubemapMats[3])
				surface.DrawTexturedRect(ScrW() * 0.5,0, ScrW() * 0.25, ScrH())

				surface.SetMaterial(self.CubemapMats[4])
				surface.DrawTexturedRect(ScrW() * 0.75,0, ScrW() * 0.25, ScrH())
			cam.End2D()

			render.CapturePixels()

			local w = math.min(ScrW(), 16843009)
			local avgcol = {
				r = 0, g = 0, b = 0
			}

			for i = 1, w do
				local r, g, b = render.ReadPixel(i, math.random(ScrH() * 0.5 - ScrH() * 0.2), ScrH() * 0.5)
				avgcol.r = avgcol.r + r
				avgcol.b = avgcol.b + b
				avgcol.g = avgcol.g + g
			end

			avgcol.r = avgcol.r / w
			avgcol.g = avgcol.g / w
			avgcol.b = avgcol.b / w

			self.AutoFog = Color(avgcol.r, avgcol.g, avgcol.b, 255)

			render.PopRenderTarget()
		end
	end

	net.Receive("update_skybox_editor", function(len, ply)
		if !LocalPlayer():IsAdmin() then return end
		local ent = net.ReadEntity()
		local x = net.ReadString()

		if(ent.ChangeSkyTexture) then
			ent:ChangeSkyTexture("Pro_PlayerDe_Fifa", "Pro_PlayerDe_Fifa", x)
		end
	end)

	net.Receive("skybox_editor_openmenu", function(len, ply)
		if !LocalPlayer():IsAdmin() then return end
		local self = net.ReadEntity()
		local temp = file.Find("materials/skybox/*.vtf", "GAME")
		local skylist = {}
		
		for k, v in pairs(temp) do
			local split = string.Explode("/", v)

			if(string.find(split[#split], ".ft%.vtf")) then
				local x = {path = "skybox/"..split[#split], name = "skybox/" .. string.gsub(split[#split], "ft%.vtf", "")}
				table.insert(skylist, x)
			end
		end

		local frame = vgui.Create("DFrame")
		frame:SetSize(300, 600)
		frame:Center()
		frame:SetTitle("Sky Textures")
		frame:MakePopup()

		local panel = vgui.Create("DScrollPanel", frame)
		panel:Dock(FILL)
		panel:DockMargin( 0, 0, 0, 0 )

		for k, v in pairs(skylist) do
			local img = vgui.Create("DImageButton")
			img:SetImage(v.path)
			img:Dock(TOP)
			img:DockMargin(10, 10, 10, 0)
			img:SetSize(200,200)
			img.DoClick = function()
				net.Start("update_skybox_editor")
				net.WriteEntity(self)
				net.WriteString(v.name)
				net.SendToServer()
			end

			local label = vgui.Create("DTextEntry")
			label:SetValue(v.name)
			label:Dock(TOP)
			label:DockMargin(10, 10, 10, 0)
			label:SetEditable(false)
			label.AllowInput = function(char)
				return true
			end

			panel:Add(img)
			panel:Add(label)
		end
	end)
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "SkyboxTexture", {
		KeyName = "skybox_texture",
		Edit = { type = "Generic", order = 10, title = "Skybox Texture", category = "General"}
	})
	self:NetworkVar("Float", 0, "SkyboxRotation", {
		KeyName = "skybox_rotation",
		Edit = { type = "Float", order = 20, min = -10, max = 10, title = "Skybox Rotation speed", category = "General"}
	})
	self:NetworkVar("Bool", 5, "SkyboxGreenscreen", {
		KeyName = "skybox_greenscreen",
		Edit = { type = "Boolean", order = 25, title = "Greenscreen Skybox", category = "General"}
	})
	self:NetworkVar( "Vector", 1, "SkyboxColor", { KeyName = "skyboxcolor", Edit = { type = "VectorColor", order = 26, category = "General" } } )
	self:NetworkVar("Bool", 0, "SkyboxFogEnable", {
		KeyName = "skybox_fog",
		Edit = { type = "Boolean", order = 30, title = "Override Fog", category = "Fog"}
	})
	self:NetworkVar("Bool", 1, "SkyboxFogAuto", {
		KeyName = "skybox_fog_auto",
		Edit = { type = "Boolean", order = 40, title = "Auto Fog Color", category = "Fog"}
	})
	self:NetworkVar( "Float", 3, "FogStart", { KeyName = "fogstart", Edit = { type = "Float", min = 0, max = 1000000, order = 50, category = "Fog" } } )
	self:NetworkVar( "Float", 4, "FogEnd", { KeyName = "fogend", Edit = { type = "Float", min = 0, max = 1000000, order = 60, category = "Fog" } } )
	self:NetworkVar( "Float", 5, "Density", { KeyName = "density", Edit = { type = "Float", min = 0, max = 1, order = 70, category = "Fog" } } )

	self:NetworkVar( "Vector", 0, "FogColor", { KeyName = "fogcolor", Edit = { type = "VectorColor", order = 80, category = "Fog" } } )

	self:NetworkVar("Bool", 2, "EnableSkyCamera", {
		KeyName = "enable_skycamera",
		Edit = { type = "Boolean", order = 80, title = "Enable Sky camera", category = "Sky Camera (Advanced!)"}
	})

	self:NetworkVar("Bool", 4, "DisableSkyUpdate", {
		KeyName = "disableskyupdate",
		Edit = { type = "Boolean", order = 85, title = "Disable updating skybox", category = "Sky Camera (Advanced!)"}
	})

	self:NetworkVar( "Float", 6, "SkyboxScale", { KeyName = "skybox_scale", Edit = { type = "Float", min = 0, max = 64, order = 95, category = "Sky Camera (Advanced!)", title="Skybox scale" } } )

	self:NetworkVar("Float", 7, "SkyboxRadius", {
		KeyName = "skybox_radius",
		Edit = { type = "Float", order = 100, min = 0, max = 65535 * 0.0625, title = "Skybox Radius", category = "Sky Camera (Advanced!)"}
	})

	self:NetworkVar("Bool", 3, "UseSkyCamera", {
		KeyName = "use_skycamera",
		Edit = { type = "Boolean", order = 110, title = "SkyCamera as origin", category = "Sky Camera (Advanced!)"}
	})

	if(SERVER) then
		self:SetSkyboxTexture("skybox/sky_day02_07")
		self:SetSkyboxRotation(0.3)
		self:SetSkyboxFogEnable(true)
		self:SetSkyboxFogAuto(true)

		self:SetFogStart( 0.0 )
		self:SetFogEnd( 10000 )
		self:SetDensity( 0.9 )
		self:SetFogColor( Vector( 0.6, 0.7, 0.8 ) )

		self:SetEnableSkyCamera(false)
		self:SetSkyboxScale(16)

		self:SetSkyboxRadius(256)
		self:SetDisableSkyUpdate(false)

		self:NetworkVarNotify("SkyboxTexture", function(self, name, old, new)
			if(old != new) then
				net.Start("update_skybox_editor")
				net.WriteEntity(self)
				net.WriteString(new)
				net.Broadcast()
			end
		end)

		self:NetworkVarNotify("UseSkyCamera", function(self, name, old, new)
			if(new) then
				local cameras = ents.FindByClass("sent_skycamera_editor")
				local camera = nil

				for k, v in pairs(cameras) do
					camera = v
				end

				self:SetNWEntity("sky_camera", camera)
			end
		end)
	end
end