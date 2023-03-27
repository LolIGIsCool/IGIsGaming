include("shared.lua")

net.Receive("ven_net_ammobox_cl_gui",function()
	local ply = LocalPlayer()
	local function AddShellMenu(caliber,self,ply,frame,shelltypes)
		local d = DermaMenu()
		for k,v in pairs(shelltypes) do
			d:AddOption(k,function()
				net.Start("ven_net_ammobox_sv_createshell")
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
	local function AddVenCalMenu(self,ply,frame)
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
		--[[d:AddOption("Ammo Type HERE",function()
			net.Start("ven_net_ammobox_sv_createammo")
				net.WriteString("Ammo_Model_Here")
				net.WriteEntity(self)
				net.WriteEntity(ply)
				net.WriteString("entity_code")
				net.WriteInt(0,1)
				net.WriteInt(0,1)
			net.SendToServer()
			frame:Close()
		end) ]]--

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
	frame:SetTitle("Ammo box - Star Wars")
	function frame:Think()
		if !IsValid(frame.ply) or !frame.ply:Alive() then frame:Close() end
	end
	function frame:OnClose()
		net.Start("ven_net_ammobox_sv_close")
			net.WriteEntity(frame.ent)
		net.SendToServer()
	end
	local DScrollPanel = vgui.Create("DScrollPanel",frame)
	DScrollPanel:Dock(FILL)


	local VenEmplacementsMounted = steamworks.ShouldMountAddon(1234567890)
	hook.Run("VenAmmoBoxAddAmmo",DScrollPanel,self,ply,frame,VenEmplacementsMounted)

	if !VenEmplacementsMounted then return end

end)