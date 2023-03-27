include("shared.lua")

net.Receive("gred_net_ammobox_cl_gui",function()
	local ply = LocalPlayer()
	local function AddShellMenu(caliber,self,ply,frame,shelltypes)
		local d = DermaMenu()
		for k,v in pairs(shelltypes) do
			d:AddOption(k,function()
				net.Start("gred_net_ammobox_sv_createshell")
					net.WriteEntity(self)
					net.WriteEntity(ply)
					net.WriteInt(caliber,10)
					net.WriteString(k)
				net.SendToServer()
				frame:Close()
			end)
		end
		d:Open()
	end
	local function Add30CalMenu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption("30. cal M1919 Belt",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/m1919/m1919_belt.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_m1919")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("30. cal M1918 Bar Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/bar/bar_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_bar")
				net.WriteInt(1,1)
				net.WriteInt(1,1)
			net.SendToServer()
			frame:Close()
		end)
	
		d:AddOption("7.62mm M240B Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/fnmag/m240b_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_m240b")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
	
		d:AddOption("7.62mm FN MAG Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/fnmag/fnmag_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_fnmag")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("7.62mm M60 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/m60/m60_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mg3")
				net.WriteInt(0,0)
				net.WriteInt(1,0)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("7.62mm MG3 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/mg3/mg3_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mg3")
				net.WriteInt(1,1)
				net.WriteInt(1,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("7.62mm RPK Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/rpk/rpk_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_rpk")
				net.WriteInt(1,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:Open()
	end
	local function Add75mmMenu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption("7.5mm MAC-31 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/mac31/mac31_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mac31")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
	local function Add7mmMenu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption("7.92mm MG34 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/mg34/mg34_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mg34")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:AddOption("7.92mm MG15 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/mg15/mg15_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mg15")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:AddOption("7.92mm MG42 Belt",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/mg42/mg42_belt.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_mg42")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
	local function Add303Menu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption(".303 Vickers Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/vickers/vickers_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_vickers")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:AddOption(".303 Bren Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/bren/bren_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_bren")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
	local function Add8mmMenu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption("8mm Hotchkiss M1914 Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/hk1914/hk1914_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_hk1914")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
	local function Add50calMenu(self,ply,frame)
		local d = DermaMenu()
		d:AddOption("12.7mm M2 Browning Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/m2browning/m2_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_m2")
				net.WriteInt(1,1)
				net.WriteInt(1,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("12.7mm DShK Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/dhsk/dhsk_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_dshk")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		
		d:AddOption("12.7mm Kord Mag",function()
			net.Start("gred_net_ammobox_sv_createammo")
				net.WriteString("models/gredwitch/kord/kord_mag.mdl")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("gred_emp_kord")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end)
		d:Open()
	end
	
	local self = net.ReadEntity()
	local shell = nil
	local smoke = nil
	local ap = nil
	
	local frame = vgui.Create("DFrame")
	frame:SetSize(300, 360)
	frame:Center()
	frame:MakePopup()
	frame.ent = self
	frame.ply = ply
	frame:SetTitle("Ammo box - Shell selection")
	function frame:Think()
		if !IsValid(frame.ply) or !frame.ply:Alive() then frame:Close() end
	end
	function frame:OnClose()
		net.Start("gred_net_ammobox_sv_close")
			net.WriteEntity(frame.ent)
		net.SendToServer()
	end
	local DScrollPanel = vgui.Create("DScrollPanel",frame)
	DScrollPanel:Dock(FILL)
	
	--[[local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("56mm shell")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		AddShellMenu(56,self,ply,frame)
	end]]
	local SHELLS = {
		["37"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["45"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["APHEBC"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["47"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["50"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["57"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["75"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["76"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["APHEBC"] = true,
			 ["Smoke"] = true,
		},
		["81"] = {
			 ["HE"] = true,
			 ["WP"] = true,
			 ["Smoke"] = true,
		},
		["82"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["Smoke"] = true,
		},
		["88"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["90"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["APHE"] = true,
			 ["APC"] = true,
			 ["APCBC"] = true,
			 ["APCR"] = true,
			 ["HEAT"] = true,
			 ["Smoke"] = true,
		},
		["100"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["Smoke"] = true,
		},
		["105"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["WP"] = true,
			 ["Smoke"] = true,
		},
		["120"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["Smoke"] = true,
		},
		["128"] = {
			 ["HE"] = true,
			 ["AP"] = true,
			 ["Smoke"] = true,
		},
		["152"] = {
			 ["HE"] = true,
			 -- ["AP"] = true,
			 ["Smoke"] = true,
		},
		["155"] = {
			 ["HE"] = true,
			 -- ["AP"] = true,
			 ["Smoke"] = true,
		},
	}
	hook.Run("GredAmmoBoxAddShell",SHELLS)
	--[[
		This is a piece of code you can take to make your own shell entities
		The currently available shell types are:
		- HE
		- AP
		- WP
		- Gas
		
		hook.Add("GredAmmoBoxAddShell","UNIQUE HOOK ID GOES HERE",function(SHELLS)
			SHELLS["CALIBER IN MILLIMETERS GOES HERE"] = {
				["SHELLTYPE #1"] = true,
				["SHELLTYPE #2"] = true,
			}
		end)
	]]
	local DButton
	for k,v in SortedPairs(SHELLS) do
		DButton = DScrollPanel:Add("DButton")
		DButton:SetText(k.."mm shell")
		DButton:Dock(TOP)
		DButton:DockMargin( 0, 0, 0, 5 )
		DButton.DoClick = function()
			AddShellMenu(tonumber(k),self,ply,frame,v)
		end
	end
	
	-- local DButton = DScrollPanel:Add("DButton")
	-- DButton:SetText("150mm Nebelwerfer rocket")
	-- DButton:Dock( TOP )
	-- DButton:DockMargin( 0, 0, 0, 5 )
	-- DButton.DoClick = function()
		-- AddMortarShellMenu("gb_rocket_nebel",self,ply,frame)
	-- end
	
	local EmplacementsMounted = steamworks.ShouldMountAddon(1391460275) or file.Exists("autorun/gred_emp_autorun.lua","lsv")
	hook.Run("GredAmmoBoxAddAmmo",DScrollPanel,self,ply,frame,EmplacementsMounted)
	--[[
		This is a piece of code you can take to make your own magazine entities
		
		hook.Add("GredAmmoBoxAddAmmo","UNIQUE HOOK ID GOES HERE",function(DScrollPanel,self,ply,frame,EmplacementsMounted)
			if !EmplacementsMounted then return end
			
			local DButton = DScrollPanel:Add("DButton")
			DButton:SetText("YOUR CALIBER GOES HERE")
			DButton:Dock( TOP )
			DButton:DockMargin( 0, 0, 0, 5 )
			DButton.DoClick = function()
				local d = DermaMenu()
				d:AddOption("YOUR MAG NAME GOES HERE (E.g. 7.5mm MAC-31 Mag)",function()
					net.Start("gred_net_ammobox_sv_createammo")
						net.WriteString("YOUR MAG MODEL GOES HERE")
						net.WriteEntity(self)
						net.WriteEntity(ply)
						net.WriteString("YOUR EMPLACEMENT CLASS NAME GOES HERRE")
						net.WriteInt(0,1)
						net.WriteInt(0,1)
					net.SendToServer()
					frame:Close()
				end)
				d:Open()
			end
		end)
	]]
	if !EmplacementsMounted then return end
	
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("7.5mm")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add75mmMenu(self,ply,frame)
	end
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("7.62mm / 30. cal")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add30CalMenu(self,ply,frame)
	end
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("7.92mm")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add7mmMenu(self,ply,frame)
	end
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("7.7mm / .303 British")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add303Menu(self,ply,frame)
	end
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("8mm")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add8mmMenu(self,ply,frame)
	end
	
	local DButton = DScrollPanel:Add("DButton")
	DButton:SetText("12.7mm / .50 cal")
	DButton:Dock( TOP )
	DButton:DockMargin( 0, 0, 0, 5 )
	DButton.DoClick = function()
		Add50calMenu(self,ply,frame)
	end
end)