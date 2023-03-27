AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("ig_pl_terminal_open")

function ENT:Initialize()
	self:SetModel("models/kingpommes/starwars/misc/bridge_console4.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

// Regiments and Clearance Levels able to open the RFA menu
	local regiments = {
		"Imperial High Command",
		"Imperial Starfighter Corps",
		"Imperial Naval Engineer",
		"Imperial Navy",
	}
	local clearancelevel = {
		"5",
		"6",
		"ALL ACCESS",
		"CLASSIFIED",
	}

function ENT:AcceptInput( name, activator, caller )	
	if name == "Use" and caller:IsPlayer() then
		local pltable = {}
		if table.HasValue(regiments, caller:GetRegiment()) or table.HasValue(clearancelevel, caller:GetJobTable().Clearance) then
			for k,v in pairs(player.GetAll()) do
				local plinsert = {
					["Name"] = v:Nick(),
					["Regiment"] = v:GetRegiment(),
					["Rank"] = v:GetRankName(),
					["SteamID"] = v:SteamID(),
					["License"] = v:GetNWString("license"),
				}
				table.insert(pltable, plinsert)
			end
			net.Start("ig_pl_terminal_open")
				net.WriteTable(pltable)
			net.Send(caller)
		end
	end
end