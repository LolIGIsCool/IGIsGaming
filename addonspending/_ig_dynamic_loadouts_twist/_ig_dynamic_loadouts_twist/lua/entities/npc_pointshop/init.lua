AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("igSquadMenuPoint")
util.AddNetworkString("igSquadMenuPointSelect")

function ENT:Initialize()
	self:SetModel("models/KingPommes/starwars/playermodels/gnk.mdl")
	--self:SetModel("models/props_borealis/bluebarrel001.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		local bypassjobs = {
			"Bounty Hunter",
			"Civilian",
			"Event",
			"Experimental Unit",
			"Imperial Droid",
			"Imperial Press Corps",
			"Recruit",
			"Inner Circle",
			"Imperial Inquisitor",
			"Imperial Marauder",
			"Shadow Guard",
			"107th Massiff Detachment",
			"Dynamic Environment",
			"Rebel Alliance",
			"Emperor's Enforcer",
			"Imperial High Command",
		}

		local weaponClassMappings = {
			dualrk3 = "rw_sw_dual_rk3",
			cr2 = "rw_sw_cr2", 
			dc15se = "rw_sw_dc15se",
			dualdc15s = "rw_sw_dual_dc15s",
			dualdc17 = "rw_sw_dual_dc17",
			duale11 = "rw_sw_dual_e11",
			dualse14c = "rw_sw_dual_se14",
			traininge11 = "rw_sw_trd_e11",
			dc17 = "rw_sw_dc17",
			dl44 = "rw_sw_dl44",
			dt12 = "rw_sw_dt12",
			rk3 = "rw_sw_rk3",
			s5 = "rw_sw_s5",
			scoutblaster = "rw_sw_scoutblaster",
			x8 = "rw_sw_x8",
			e11_asiimov = "rw_sw_e11_asiimov",
			e11_atom = "rw_sw_e11_atom",
			e11_dbk = "rw_sw_e11_dbk",
			e11_electrichive = "rw_sw_e11_electrichive",
			e11_hyperbeast = "rw_sw_e11_hyperbeast",
			e11_jaws = "rw_sw_e11_jaws",
			e11_kosmos = "rw_sw_e11_kosmos",
			e11_ps = "rw_sw_e11_ps",
			e11_vaporwave = "rw_sw_e11_vaporwave",
			boo_crew = "boocrew_dc17",
		    candy_cane = "rw_sw_e11_candycane", 
		    scream_team = "screamteam_dc17",
		    spooky_skeletons = "spookyskeletons_dc17",
		    e5s = "rw_sw_e5s",
		    iqa11 = "rw_sw_iqa11", 
		    scattershotgun = "rw_sw_scattershotgun",
		    smartlauncher = "rw_sw_smartlauncher",
		    z2 = "rw_sw_z2",
		    z4 = "rw_sw_z4",
		    z6 = "rw_sw_z6",
		}

		if table.HasValue(bypassjobs, caller:GetRegiment()) or caller:GetRankName() == "ID-10" then
			local pointshop = {}
			for k,v in pairs(caller:SH_GetInventory()) do
				if v["class"] == "bhp100" or v["class"] == "dhp200" or v["class"] == "fhp300" or v["class"] == "santahat" then else
					table.insert(pointshop, weaponClassMappings[v["class"]])
				end
			end
			net.Start("igSquadMenuPoint")
				net.WriteTable(pointshop)
			net.Send(caller)
		else
			caller:PrintMessage( HUD_PRINTTALK, "You don't have permission to use this." )
			return
		end
	end
end

net.Receive("igSquadMenuPointSelect", function(len, ply)
	local bypassjobs = {
			"Bounty Hunter",
			"Civilian",
			"Event",
			"Experimental Unit",
			"Imperial Droid",
			"Imperial Press Corps",
			"Recruit",
			"Inner Circle",
			"Imperial Inquisitor",
			"Imperial Marauder",
			"Shadow Guard",
			"107th Massiff Detachment",
			"Dynamic Environment",
			"Rebel Alliance",
			"Emperor's Enforcer",
			"Imperial High Command",
		}
	if ply:SH_CanAffordPremium(500) then
		if table.HasValue(bypassjobs, ply:GetRegiment()) then
			local selected = net.ReadTable()
			local pointshop = net.ReadTable()
			if selected.first == selected.second then
				selected.second = ""
			end
			for k,v in pairs(pointshop) do
				ply:StripWeapon(v)
			end
			if selected.first == "" and selected.second == "" then
				ply:PrintMessage( HUD_PRINTTALK, "You didn't deploy anything" )
			else
				ply:SH_AddStandardPoints(-500, "You have spent 500 Credits deploying a weapon", false, false)
				ply:SH_AddPremiumPoints(-500, "You have spent 500 Credits deploying a weapon", false, false)
			end
			if selected.first == "" then return else
				ply:PrintMessage( HUD_PRINTTALK, "You have deployed: "..selected.first )
				ply:Give(selected.first)
			end
			if selected.second == "" then return else
				ply:PrintMessage( HUD_PRINTTALK, "You have deployed: "..selected.second )
				ply:Give(selected.second)
			end
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "Not enough credits." )
	end
end)