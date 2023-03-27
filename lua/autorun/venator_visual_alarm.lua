// Created by Airfox aka. Konsti
// Huge thanks to him!

if game.GetMap() ~= "rp_venator_extensive_v1_4" then return end

-- Set default values (thats why it also resists a lua refresh)
local nextTick = 0

local materialWallLamp = Material("kingpommes/starwars/venator/corridor_wall_lamps")
local materialCorridorLamp = Material("kingpommes/starwars/venator/corridor_lights")
local materialCorridorLampb = Material("kingpommes/starwars/venator/corridor_lightsb")
local materialLightDecal = Material("kingpommes/starwars/venator/lights_decal")

local defaultTextureWallLamp = "kingpommes/starwars/venator/corridor_wall_lamps"
local defaultTextureCorridorLamp = "kingpommes/starwars/venator/corridor_lights"
local defaultTextureCorridorLampb = "kingpommes/starwars/venator/corridor_lightsb"
local defaultTextureLightDecal = "kingpommes/starwars/venator/lights_decal"

local redAlarmTextureWallLamp = "kingpommes/starwars/venator/corridor_wall_lamps_red"
local redAlarmTextureCorridorLamp = "kingpommes/starwars/venator/corridor_lights_red"
local redAlarmTextureCorridorLampb = "kingpommes/starwars/venator/corridor_lightsb_red"
local redAlarmTextureLightDecal = "kingpommes/starwars/venator/lights_decal_red"

local alarmOn = false
local networkSend = false

materialWallLamp:SetTexture("$basetexture", defaultTextureWallLamp)
materialCorridorLamp:SetTexture("$basetexture", defaultTextureCorridorLamp)
materialCorridorLampb:SetTexture("$basetexture", defaultTextureCorridorLampb) 
materialLightDecal:SetTexture("$basetexture", defaultTextureLightDecal)

if SERVER then
	util.AddNetworkString("Venator_Ext_AlarmNet")

	-- Networks current alarm state to every new player that joins the server.
	hook.Add("PlayerInitialSpawn", "Venator_Ext_AlarmConnectSync", function(ply)
		net.Start("Venator_Ext_AlarmNet")
			net.WriteBool(alarmOn)
		net.Send(ply)
	end)
end

function EnableVisualAlarm()
	net.Start("Venator_Ext_AlarmNet")
	net.WriteBool(true)
	net.Broadcast()
	
	alarmOn = true
	networkSend = true
end

function DisableVisualAlarm()
	net.Start("Venator_Ext_AlarmNet")
	net.WriteBool(false)
	net.Broadcast()
	networkSend = false
	alarmOn = false
end

hook.Add("Think", "Venator_Ext_AlarmThink", function()
	if CurTime() > nextTick then
		nextTick = CurTime() + 0.56
		
		-- Checks if alarm is on.
		if CLIENT and alarmOn then
			-- Changes between textured.
			if materialWallLamp:GetTexture("$basetexture"):GetName() == defaultTextureWallLamp then
				materialWallLamp:SetTexture("$basetexture", redAlarmTextureWallLamp)
				materialCorridorLamp:SetTexture("$basetexture", redAlarmTextureCorridorLamp)
				materialCorridorLampb:SetTexture("$basetexture", redAlarmTextureCorridorLampb) 
				materialLightDecal:SetTexture("$basetexture", redAlarmTextureLightDecal)
				
			elseif materialWallLamp:GetTexture("$basetexture"):GetName() == redAlarmTextureWallLamp then
				materialWallLamp:SetTexture("$basetexture", defaultTextureWallLamp)
				materialCorridorLamp:SetTexture("$basetexture", defaultTextureCorridorLamp)
				materialCorridorLampb:SetTexture("$basetexture", defaultTextureCorridorLampb) 
				materialLightDecal:SetTexture("$basetexture", defaultTextureLightDecal)
			end
		elseif CLIENT and not alarmOn then
			-- If the alarm is off and texture is not resetted, reset it.
			if materialWallLamp:GetTexture("$basetexture"):GetName() == redAlarmTextureWallLamp then
				materialWallLamp:SetTexture("$basetexture", defaultTextureWallLamp)
				materialCorridorLamp:SetTexture("$basetexture", defaultTextureCorridorLamp)
				materialCorridorLampb:SetTexture("$basetexture", defaultTextureCorridorLampb) 
				materialLightDecal:SetTexture("$basetexture", defaultTextureLightDecal)
			end
		end
	end
end)

hook.Add("PostCleanupMap", "Venator_Ext_AlarmCleanup", function()
	alarmOn = false
end)

if CLIENT then
	-- Receives current alarm state.
	net.Receive("Venator_Ext_AlarmNet", function(len)
		alarmOn = net.ReadBool()
	end)
end