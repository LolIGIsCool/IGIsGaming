// Created by Airfox aka. Konsti
// Huge thanks to him!

if game.GetMap() ~= "rp_venator_extensive_v1_4" then return end

local nextTick = nextTick or 0
local material = Material("kingpommes/map_borders/red_opacity3")
local defaultTexture = "kingpommes/map_borders/red_opacity3"
local invisibleTexture = "kingpommes/starwars/venator/invis"
local borderVisible = true
material:SetTexture("$basetexture", defaultTexture)

if SERVER then
	util.AddNetworkString("Venator_Ext_BorderNet")

	-- Networks current state to every new player that joins the server.
	hook.Add("PlayerInitialSpawn", "Venator_Ext_BorderConnectSync", function(ply)
		net.Start("Venator_Ext_BorderNet")
			net.WriteBool(borderVisible)
		net.Send(ply)
	end)
end

hook.Add("Think", "Venator_Ext_BorderThink", function()
	if nextTick > CurTime() then return end

	nextTick = CurTime() + 1
	
	if SERVER then
		-- Finds all entities with this name.
		local entities = ents.FindByName("border_target")

		-- Checks if an entity has been found and alarm is on. Also if the network has already been sent.
		if #entities >= 1 and borderVisible then
			borderVisible = false
			net.Start("Venator_Ext_BorderNet")
				net.WriteBool(borderVisible)
			net.Broadcast()
			
			if material:GetTexture("$basetexture"):GetName() == defaultTexture then
				material:SetTexture("$basetexture", invisibleTexture)
			end
		elseif #entities == 0 and not borderVisible then
			borderVisible = true
			net.Start("Venator_Ext_BorderNet")
				net.WriteBool(borderVisible)
			net.Broadcast()

			if material:GetTexture("$basetexture"):GetName() == invisibleTexture then
				material:SetTexture("$basetexture", defaultTexture)
			end
		end
	elseif CLIENT then
		-- Checks if alarm is on. 
		if not borderVisible then
			-- Changes between textured.
			if material:GetTexture("$basetexture"):GetName() == defaultTexture then
				material:SetTexture("$basetexture", invisibleTexture)
			end
		else
			-- Resets the texture to default, when the border should be visible.
			if material:GetTexture("$basetexture"):GetName() == invisibleTexture then
				material:SetTexture("$basetexture", defaultTexture)
			end
		end
	end
end)

if CLIENT then
	-- Receives current state.
	net.Receive("Venator_Ext_BorderNet", function(len)
		borderVisible = net.ReadBool()
	end)
end