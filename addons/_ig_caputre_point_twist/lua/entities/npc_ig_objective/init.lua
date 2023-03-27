AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local meta = FindMetaTable( "Entity" )

function meta:GetRegiment()
	if self:SteamID() == "STEAM_0:1:45778562" then
		return "Event"
	else
		return "Event"
	end
end

IG_OBJECT_TIMER = 0

util.AddNetworkString("IG_OBJECT_NAME_OPEN")
util.AddNetworkString("IG_OBJECT_NAME_EDIT")
util.AddNetworkString("IG_OBJECT_SPAWN_MENU_OPEN")
util.AddNetworkString("IG_OBJECT_SPAWN_MENU_CONF")
util.AddNetworkString("IG_OBJECT_SPAWN_MENU_CONF_DEF")
util.AddNetworkString("IG_OBJECT_SPAWN_MENU_CAM")
util.AddNetworkString("IG_OBJECT_SPAWN_MENU_CAM_DEF")
util.AddNetworkString("IG_OBJECT_SOUND_CAPTURE")
util.AddNetworkString("IG_OBJECT_EDIT_MENU")
util.AddNetworkString("IG_OBJECT_EDIT_MENU_SEND")

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "IG_OBJECTIVE_NAME" )
    self:NetworkVar( "Int", 0, "IG_OBJECTIVE_ALLY" )
    self:NetworkVar( "Int", 1, "IG_OBJECTIVE_HOSTILE" )
end

function ENT:Initialize()
	--self:SetModel("models/KingPommes/starwars/playermodels/gnk.mdl")
	self:SetModel("models/capturepoint/twist/base.mdl")
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
	local count = 0 
	for _ in pairs(ents.FindByClass("npc_ig_objective")) do count = count + 1 end
	self:SetIG_OBJECTIVE_NAME(tostring(count))
end

function ENT:Think()
	local playertableobj = {}
	for k, v in ipairs( ents.FindInSphere(self:GetPos(),180) ) do
    	if v:GetClass() == "player" then
    		if v:Alive() then
	    		if v:GetRegiment() == "Event" or v:GetRegiment() == "Rebel Alliance" then
	    			table.insert(playertableobj, "Event")
	    		elseif v:GetRegiment() == "Civilian" then
	    		else
	    			table.insert(playertableobj, "Imperial")
	    		end
	    	end
    	end
    end
	for k, v in ipairs( ents.FindInSphere(self:GetPos(),180) ) do
		if table.HasValue(playertableobj, "Event") and table.HasValue(playertableobj, "Imperial") then
			if self:GetIG_OBJECTIVE_HOSTILE() == 100 then
    			self:SetIG_OBJECTIVE_HOSTILE(self:GetIG_OBJECTIVE_HOSTILE() - 10)
    		elseif
    		 	self:GetIG_OBJECTIVE_ALLY() == 100 then
    			self:SetIG_OBJECTIVE_ALLY(self:GetIG_OBJECTIVE_ALLY() - 10)
    		end
		else
	    	if v:GetClass() == "player" then
	    		if v:Alive() then
		    		if v:GetRegiment() == "Event" or v:GetRegiment() == "Rebel Alliance" then
		    			if self:GetIG_OBJECTIVE_ALLY() > 0 then
		    				if self:GetIG_OBJECTIVE_ALLY() == 100 then
			    				net.Start("IG_OBJECT_SOUND_CAPTURE")
			    					net.WriteString("IMP LOSS")
			    				net.Broadcast()
			    			end
			    			self:SetIG_OBJECTIVE_ALLY(self:GetIG_OBJECTIVE_ALLY() - 1)
			    		elseif self:GetIG_OBJECTIVE_HOSTILE() < 100 then
			    			self:SetIG_OBJECTIVE_HOSTILE(self:GetIG_OBJECTIVE_HOSTILE() + 1)
			    		end
			    	elseif v:GetRegiment() == "Civilian" then
		    		else
			    		if self:GetIG_OBJECTIVE_HOSTILE() > 0 then
			    			self:SetIG_OBJECTIVE_HOSTILE(self:GetIG_OBJECTIVE_HOSTILE() - 1)
			    		elseif self:GetIG_OBJECTIVE_ALLY() < 100 then
			    			if (self:GetIG_OBJECTIVE_ALLY() + 1) == 100 then
			    				net.Start("IG_OBJECT_SOUND_CAPTURE")
			    					net.WriteString("IMP CAPTURE")
			    				net.Broadcast()
			    			end
			    			self:SetIG_OBJECTIVE_ALLY(self:GetIG_OBJECTIVE_ALLY() + 1)
			    		end
			    	end
			    end
			end
		end
	end
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		if caller:IsAdmin() then
			net.Start( "IG_OBJECT_NAME_OPEN" )
				net.WriteString(self:GetIG_OBJECTIVE_NAME())
				net.WriteEntity(self)
			net.Send( caller )
		end
	end
end

function ENT:SendToEntity(object_name)
	self:SetIG_OBJECTIVE_NAME(object_name)
end

net.Receive("IG_OBJECT_NAME_EDIT", function(len, ply)
	local object_name = net.ReadString()
	local EntityPort = net.ReadEntity()
	RunConsoleCommand("ulx", "asay", ply:Nick().." has changed objective "..EntityPort:GetIG_OBJECTIVE_NAME().." name to ".. object_name)
	if ply:IsAdmin() then
		EntityPort:SendToEntity(object_name)
	end
end)

hook.Add("PlayerSpawn", "IG_Objective_Spawn", function(ply)
	if ents.FindByClass("npc_ig_objective")[1] then
		if timer.Exists(ply:SteamID() .. "objective_spawn") then else
			local object_table = ents.FindByClass("npc_ig_objective")
			local playerec = false
			if ply:GetRegiment() == "Event" or ply:GetRegiment() == "Rebel Alliance" then
				playerec = true
			end
			net.Start("IG_OBJECT_SPAWN_MENU_OPEN")
				net.WriteTable(object_table)
				net.WriteBool(playerec)
			net.Send(ply)
			timer.Create(ply:SteamID() .. "objective_spawn", IG_OBJECT_TIMER, 1, function()
				timer.Remove(ply:SteamID() .. "objective_spawn")
				ply:PrintMessage(HUD_PRINTTALK, "Your Capture Point respawn timer has finished")
			end)
		end
		
	end
end)

net.Receive("IG_OBJECT_SPAWN_MENU_CONF", function(len, ply) -- need to add protection
	local EntityPort = net.ReadEntity()
	if EntityPort:GetClass() == "npc_ig_objective" then
		local spawnpos = EntityPort:GetPos()
		spawnpos.x = spawnpos.x + math.Rand(10, 100)
		spawnpos.y = spawnpos.y + math.Rand(10, 100)
		spawnpos.z = spawnpos.z - 50
		ply:SetPos(spawnpos)
	end
	ply:SetViewEntity(ply)
end)

net.Receive("IG_OBJECT_SPAWN_MENU_CONF_DEF", function(len, ply)
	ply:SetViewEntity(ply)
end)

net.Receive("IG_OBJECT_SPAWN_MENU_CAM", function(len, ply)
	local EntityPort = net.ReadEntity()
	if EntityPort:GetClass() == "npc_ig_objective" then
		ply:SetViewEntity(EntityPort)
	end
end)

net.Receive("IG_OBJECT_SPAWN_MENU_CAM_DEF", function(len, ply)
	ply:SetViewEntity(ply)
end)

hook.Add("PlayerSay", "IG_LoadOut_Command", function( ply, text )
	if string.lower(text) == "!capture" then
		if ply:IsAdmin() then
			net.Start("IG_OBJECT_EDIT_MENU")
			net.Send(ply)
			return ""
		else
			ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
			return ""
		end
	end
end)

net.Receive("IG_OBJECT_EDIT_MENU_SEND", function(len, ply)
	local faction = net.ReadString()
	local timer_respawn = net.ReadInt(32)
	IG_OBJECT_TIMER = timer_respawn
	RunConsoleCommand("ulx", "asay", ply:Nick().." has changed objective respawn timer to: ".. IG_OBJECT_TIMER.." objective hostiles to: ".. faction)
end)