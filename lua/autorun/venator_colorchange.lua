// Created by Airfox aka. Konsti
// Huge thanks to him!

if game.GetMap() ~= "rp_venator_extensive_v1_4" then return end

local nextTick = nextTick or 0
local materialHull = Material("kingpommes/starwars/venator/hull_red")
local materialHullPanel = Material("kingpommes/starwars/venator/hull_panels_red")
local materialPropperHull = Material("kingpommes/starwars/venator/hull_red")
local materialPropperHullPanel = Material("models/kingpommes/starwars/venator/propper/hull_red")
local materialPropperInsignia = Material("models/kingpommes/starwars/venator/propper/venator_insignia")
local republicLook = true

materialHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
materialHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
materialPropperHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
materialPropperHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
materialPropperInsignia:SetTexture("$basetexture", "kingpommes/starwars/venator/venator_insignia")

if SERVER then
	util.AddNetworkString("Venator_Ext_ColorNet")

	-- Networks current state to every new player that joins the server.
	hook.Add("PlayerInitialSpawn", "Venator_Ext_ColorConnectSync", function(ply)
		net.Start("Venator_Ext_ColorNet")
			net.WriteBool(republicLook)
		net.Send(ply)
	end)
end

hook.Add("Think", "Venator_Ext_ColorThink", function()
	if nextTick > CurTime() then return end

	nextTick = CurTime() + 1
	
	if SERVER then
		-- Finds all entities with this name.
		local entities = ents.FindByName("colorchange_target")

		-- Checks if an entity has been found and alarm is on. Also if the network has already been sent.
		if #entities >= 1 and republicLook then
			republicLook = false
			net.Start("Venator_Ext_ColorNet")
				net.WriteBool(republicLook)
			net.Broadcast()

			if materialHull:GetTexture("$basetexture"):GetName() == "kingpommes/starwars/venator/hull_red" then
				materialHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull")
				materialHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels")
				materialPropperHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull")
				materialPropperHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels")
				materialPropperInsignia:SetTexture("$basetexture", "kingpommes/starwars/venator/invis")
			end
		elseif #entities == 0 and not republicLook then
			republicLook = true
			net.Start("Venator_Ext_ColorNet")
				net.WriteBool(republicLook)
			net.Broadcast()

			if materialHull:GetTexture("$basetexture"):GetName() == "kingpommes/starwars/venator/hull" then
				materialHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
				materialHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
				materialPropperHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
				materialPropperHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
				materialPropperInsignia:SetTexture("$basetexture", "kingpommes/starwars/venator/venator_insignia")
			end
		end
	elseif CLIENT then
		-- Checks if alarm is on. 
		if not republicLook then
			-- Changes between textured.
			if materialHull:GetTexture("$basetexture"):GetName() == "kingpommes/starwars/venator/hull_red" then
				materialHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull")
				materialHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels")
				materialPropperHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull")
				materialPropperHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels")
				materialPropperInsignia:SetTexture("$basetexture", "kingpommes/starwars/venator/invis")
			end
		else
			-- Resets the texture to default, when the border should be visible.
			if materialHull:GetTexture("$basetexture"):GetName() == "kingpommes/starwars/venator/hull" then
				materialHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
				materialHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
				materialPropperHull:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_red")
				materialPropperHullPanel:SetTexture("$basetexture", "kingpommes/starwars/venator/hull_panels_red")
				materialPropperInsignia:SetTexture("$basetexture", "kingpommes/starwars/venator/venator_insignia")
			end
		end
	end
end)

if CLIENT then
	-- Receives current state.
	net.Receive("Venator_Ext_ColorNet", function(len)
		republicLook = net.ReadBool()
	end)
end