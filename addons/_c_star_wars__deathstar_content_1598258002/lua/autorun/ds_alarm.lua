// Created by Airfox aka. Konsti and P4sca1
// Huge thanks to them!

if game.GetMap() ~= "rp_deathstar" then return end

-- Set default values (thats why it also resists a lua refresh)
local nextTick = 0

local material = Material("models/kingpommes/starwars/deathstar/white")
local defaultTexture = "lights/white"
local alarmTexture = "models/kingpommes/starwars/deathstar/red"

local alarmOn = false
local networkSend = false

material:SetTexture("$basetexture", defaultTexture)

if SERVER then
	util.AddNetworkString("DS_AlarmNet")

	-- Networks current alarm state to every new player that joins the server.
	hook.Add("PlayerInitialSpawn", "DS_AlarmConnectSync", function(ply)
		net.Start("DS_AlarmNet")
			net.WriteBool(alarmOn)
		net.Send(ply)
	end)
end

hook.Add("Think", "DS_AlarmThink", function()
	if nextTick > CurTime() then
		return
	end

	if SERVER then
		-- Finds all entities with this name.
		local entities = ents.FindByName("AlarmTrgOn")

		-- Checks if an entity has been found and alarm is on. Also if the network has already been sent.
		if #entities >= 1 and not networkSend and not alarmOn then
			net.Start("DS_AlarmNet")
				net.WriteBool(true)
			net.Broadcast()
			networkSend = true
			alarmOn = true
		elseif #entities == 0 and networkSend and alarmOn then
			net.Start("DS_AlarmNet")
				net.WriteBool(false)
			net.Broadcast()
			networkSend = false
			alarmOn = false
		end
	end
	
	-- Checks if alarm is on. 
	if alarmOn then
		-- Changes between textured.
		if material:GetTexture("$basetexture"):GetName() == defaultTexture then
			material:SetTexture("$basetexture", alarmTexture)
			
		elseif material:GetTexture("$basetexture"):GetName() == alarmTexture then
			material:SetTexture("$basetexture", defaultTexture)
		end
	else
		-- If the alarm is off and texture is not resetted, reset it.
		if material:GetTexture("$basetexture"):GetName() == alarmTexture then
			material:SetTexture("$basetexture", defaultTexture)
		end
	end
	nextTick = CurTime() + 0.5
end)

if CLIENT then
	-- Receives current alarm state.
	net.Receive("DS_AlarmNet", function(len)
		alarmOn = net.ReadBool()
	end)
end