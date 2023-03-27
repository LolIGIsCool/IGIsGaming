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
		if table.HasValue(DYANMIC_BYPASS, caller:GetRegiment()) or caller:GetRankName() == "ID-10" then
			local weaponClassMappings = {
			--Primaries
            cr2 = "rw_sw_cr2",
            dc15se = "rw_sw_dc15se",
            dlt19s = "rw_sw_dlt19s",
            dualdc15s = "rw_sw_dual_dc15s",
            dualdc17 = "rw_sw_dual_dc17",
            dualdl44 = "rw_sw_dual_dl44",
            duale11 = "rw_sw_dual_e11",
            dualib94 = "rw_sw_dual_ib94",
            dualrk3 = "rw_sw_dual_rk3",
            dualse14 = "rw_sw_dual_se14",
            e11 = "ven_e11",
            e5 = "rw_sw_e5",
            nt242 = "rw_sw_nt242",
            --Secondaries
            cr2s = "rw_sw_cr2",
            dc15 = "rw_sw_dc15s",
            dc17 = "rw_sw_dc17",
            dl18 = "rw_sw_dl18",
            dl44 = "rw_sw_dl44",
            dualdc17s = "rw_sw_dual_dc17s",
            dualib94s = "rw_sw_dual_ib94",
            dualrk3s = "rw_sw_dual_rk3",
            dualse14s = "rw_sw_dual_se14",
            e44 = "rw_sw_e44",
            ib94 = "rw_sw_ib94",
            s5 = "rw_sw_s5",
            scoutblaster = "rw_sw_scoutblaster",
            vibroknifes = "imperialarts_knife_electroknife",
            x8 = "rw_sw_x8",
            --Donator
            e11_asiimov = "rw_sw_e11_asiimov",
            e11_atom = "rw_sw_e11_atom",
            e11_dbk = "rw_sw_e11_dbk",
            e11_electrichive = "rw_sw_e11_electrichive",
            e11_hyperbeast = "rw_sw_e11_hyperbeast",
            e11_jaws = "rw_sw_e11_jaws",
            e11_kosmos = "rw_sw_e11_kosmos",
            e11_ps = "rw_sw_e11_ps",
            e11_vaporwave = "rw_sw_e11_vaporwave",
            dlt19s_rain = "rw_sw_rain_dlt19",
        	se14c_rain = "rw_sw_rain_se14c",
            --Special
            boo_crew = "boocrew_dc17",
            candy_cane = "rw_sw_e11_candycane",
            scream_team = "screamteam_dc17",
            spooky_skeletons = "spookyskeletons_dc17",
            --Specialties
            dlt19training = "rw_sw_trd_dlt19",
            duale5bx = "rw_sw_dual_e5bx",
            e5s = "rw_sw_e5s",
            impactnade = "rw_sw_nade_impact",
            iqa11 = "rw_sw_iqa11",
            iqa11carbine = "str_sw_iqa11_carbine",
            scattershotgun = "rw_sw_scattershotgun",
            sg6 = "rw_sw_sg6",
            smartlauncher = "rw_sw_smartlauncher",
            trainingnade = "rw_sw_nade_training",
            valkenx38a = "rw_sw_valkenx38a",
            vibroknife = "imperialarts_knife_electroknife",
            vibrosword = "imperialarts_blade_vibrosword",
            z2 = "rw_sw_z2",
            z4 = "rw_sw_z4",
            z6 = "rw_sw_z6",
			//Starter
			starter_dlt19 = "rw_sw_dlt19_st",
	        starter_e11s = "rw_sw_e11s_st",
			starter_scoutblaster = "rw_sw_scoutblaster_st",
			starter_sx21 = "rw_sw_sx_21_st",
			}
			local pointshop = {}
			for k,v in pairs(caller:SH_GetInventory()) do
				if v["class"] == "hhp5" or v["class"] == "bhp100" or v["class"] == "dhp200" or v["class"] == "fhp300" or v["class"] == "santahat" then else
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
	if ply:SH_CanAffordPremium(500) then
		if table.HasValue(DYANMIC_BYPASS, ply:GetRegiment()) or ply:GetRankName() == "ID-10"then
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
		ply:PrintMessage( HUD_PRINTTALK, "Not enough credits or points." )
	end
end)
