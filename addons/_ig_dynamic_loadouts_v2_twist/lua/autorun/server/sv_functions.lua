include("autorun/server/sv_augmenthooks.lua")

resource.AddFile("materials/twist/dynamicloadouts_v2/close_icon.png")

local meta = FindMetaTable("Player")

function meta:DynamicError(number,reason)
	net.Start("IG_LOADOUT_SEND_ERROR")
		net.WriteString(number)
		net.WriteString(reason)
	net.Send(self)
end

function meta:DynamicLog(action)
	if not file.Exists("ig_dynamic_loadout_v2/data/log.txt", "DATA") then
		local logtable = {}
		file.Write("ig_dynamic_loadout_v2/data/log.txt", util.TableToJSON(tablelog,true))
	end
	local logtable = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/log.txt", "DATA"))
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	local Stringinsert = TimeString.." | "..self:Name().. " | ".. action
	table.insert(logtable, Stringinsert)
	file.Write("ig_dynamic_loadout_v2/data/log.txt", util.TableToJSON(logtable,true))
end

function meta:GetDynamicPlayerTable()
	if self:IsPlayer() then
		local PlayerTable = {}
		if DYNAMIC_PLAYER_DATA[self:SteamID()]["First"]["Active"] == true then
			PlayerTable = DYNAMIC_PLAYER_DATA[self:SteamID()]["First"]["Loadout"]
		elseif DYNAMIC_PLAYER_DATA[self:SteamID()]["Second"]["Active"] == true then
			PlayerTable = DYNAMIC_PLAYER_DATA[self:SteamID()]["Second"]["Loadout"]
		elseif DYNAMIC_PLAYER_DATA[self:SteamID()]["Third"]["Active"] == true then
			PlayerTable = DYNAMIC_PLAYER_DATA[self:SteamID()]["Third"]["Loadout"]
		end
		return PlayerTable
	end
end

function meta:GetFullDynamicPlayerTable()
	if self:IsPlayer() then
		return DYNAMIC_PLAYER_DATA[self:SteamID()]
	end
end

function meta:GetPointShopTable()
    local PlayerTable = {
		["Primary"] = {},
		["Secondary"] = {},
		["Specialist"] = {},
		["Ace"] = {},
		["Unique"] = {},
		["Regiment"] = "",
	}
	local primfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/primaries/*.lua", "GAME" )
	for k,v in pairs(primfiles) do
		primfiles[k] = primfiles[k]:sub(1, -5)
	end
    table.insert(primfiles, "starter_dlt19"); //starter weapons
    table.insert(primfiles, "starter_e11s");
	local secfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/secondaries/*.lua", "GAME" )
	for k,v in pairs(secfiles) do
		secfiles[k] = secfiles[k]:sub(1, -5)
	end
    table.insert(secfiles, "starter_scoutblaster");
	local specfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/specialties/*.lua", "GAME" )
	for k,v in pairs(specfiles) do
		specfiles[k] = specfiles[k]:sub(1, -5)
	end
    table.insert(secfiles, "starter_sx21");
	local donfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/donator/*.lua", "GAME" )
	for k,v in pairs(donfiles) do
		donfiles[k] = donfiles[k]:sub(1, -5)
	end
	local specialfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/special/*.lua", "GAME" )
	for k,v in pairs(specialfiles) do
		specialfiles[k] = specialfiles[k]:sub(1, -5)
	end

	-- A shitty solution, but it works lol
	local primaryClassMappings = {
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
        starter_dlt19 = "rw_sw_dlt19_st",
        starter_e11s = "rw_sw_e11s_st",
	}

	local secondaryClassMappings = {
		cr2s = "rw_sw_cr2",
        --dc15 = "rw_sw_dc15s",
        dc15 = "at_sw_dc15sa_original", -- new
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
        starter_scoutblaster = "rw_sw_scoutblaster_st",
	}

	local donatorClassMappings = {
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
	}

	local donatorSecondaryClassMappings = {
		se14c_rain = "rw_sw_rain_se14c",
	}

	local SpecialClassMappings = {
	    boo_crew = "boocrew_dc17",
	    candy_cane = "rw_sw_e11_candycane",
	    scream_team = "screamteam_dc17",
	    spooky_skeletons = "spookyskeletons_dc17",
	}

	local SpecialtiesClassMappings = {
	    dlt19training = "rw_sw_trd_dlt19",
        dual35bx = "rw_sw_dual_e5bx",
        e5s = "rw_sw_e5s",
        impactnade = "rw_sw_nade_impact",
        iqa11 = "rw_sw_iqa11",
        iqa11carbine = "str_sw_iqa11_carbine",
        scattershotgun = "rw_sw_scattershotgun",
        sg6 = "rw_sw_sg6",
        trainingnade = "rw_sw_nade_training",
        valkenx38a = "rw_sw_valkenx38a",
        vibroknife = "imperialarts_knife_electroknife",
        vibrosword = "imperialarts_blade_vibrosword",
        z2 = "rw_sw_z2",
        z4 = "rw_sw_z4",
        z6 = "rw_sw_z6",
        starter_sx21 = "rw_sw_sx_21_st",
	}

	for k,v in pairs(self:SH_GetInventory()) do
		if v["class"] == "hhp5" or v["class"] == "bhp100" or v["class"] == "dhp200" or v["class"] == "fhp300"then else
			if v["class"] == "dual35bx" then
				table.insert(PlayerTable["Specialist"], SpecialtiesClassMappings[v["class"]])
			end
			if table.HasValue(primfiles, v["class"]) then
				table.insert(PlayerTable["Primary"], primaryClassMappings[v["class"]])
			elseif table.HasValue(secfiles, v["class"]) then
				table.insert(PlayerTable["Secondary"], secondaryClassMappings[v["class"]])
			elseif table.HasValue(specfiles, v["class"]) then
				table.insert(PlayerTable["Specialist"], SpecialtiesClassMappings[v["class"]])
			elseif table.HasValue(donfiles, v["class"]) then
				if v["class"] == "se14c_rain" then
					table.insert(PlayerTable["Secondary"], donatorSecondaryClassMappings[v["class"]])
				end
				table.insert(PlayerTable["Primary"], donatorClassMappings[v["class"]])
			elseif table.HasValue(specialfiles, v["class"]) then
				table.insert(PlayerTable["Specialist"], SpecialClassMappings[v["class"]])
			end
		end
	end

	return PlayerTable
end

function meta:GetDynamicFullRegimentTable()
	local PreTable = {}
	local PlayerTable = self:GetPointShopTable()
	for k,v in pairs(DYNAMIC_REGIMENT_LOADOUT) do
		if table.GetKeys(DYNAMIC_REGIMENT_LOADOUT[k])[1] == self:GetRegiment() then
			PreTable = v
		end
	end
	-- Primary Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["Base"]) do
			table.insert(PlayerTable["Primary"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL5"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL6"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL5"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		end
	-- Secondary Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["Base"]) do
			table.insert(PlayerTable["Secondary"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL5"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL6"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL5"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		end
	-- Specialist Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["Base"]) do
			table.insert(PlayerTable["Specialist"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL5"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL6"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL5"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		end
	-- Unique Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["Base"]) do
			table.insert(PlayerTable["Unique"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL5"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL6"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL5"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		end
	-- Vanillas Stuff :)
		if HasAugment(self,"Ace up the Sleeve [PRIMARY]") then
			for k,v in pairs(PlayerTable["Primary"]) do
				table.insert(PlayerTable["Ace"],v)
			end
		elseif HasAugment(self,"Ace up the Sleeve [SPECIALIST]") then
			for k,v in pairs(PlayerTable["Specialist"]) do
				table.insert(PlayerTable["Ace"],v)
			end
		end
	return PlayerTable
end

function meta:GetDynamicRegimentTable()
	local PreTable = {}
	local PlayerTable = {
		["Primary"] = {},
		["Secondary"] = {},
		["Specialist"] = {},
		["Unique"] = {},
		["Regiment"] = "",
	}
	for k,v in pairs(DYNAMIC_REGIMENT_LOADOUT) do
		if table.GetKeys(DYNAMIC_REGIMENT_LOADOUT[k])[1] == self:GetRegiment() then
			PreTable = v
		end
	end
	-- Primary Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["Base"]) do
			table.insert(PlayerTable["Primary"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL5"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL6"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL5"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL4"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL3"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Primary"]["CL2"]) do
				table.insert(PlayerTable["Primary"],v)
			end
		end
	-- Secondary Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["Base"]) do
			table.insert(PlayerTable["Secondary"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL5"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL6"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL5"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL4"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL3"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Secondary"]["CL2"]) do
				table.insert(PlayerTable["Secondary"],v)
			end
		end
	-- Specialist Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["Base"]) do
			table.insert(PlayerTable["Specialist"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL5"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL6"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL5"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL4"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL3"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Specialist"]["CL2"]) do
				table.insert(PlayerTable["Specialist"],v)
			end
		end
	-- Unique Weapons Adding
		for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["Base"]) do
			table.insert(PlayerTable["Unique"],v)
		end
		if self:GetJobTable().Clearance == "6" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL5"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL6"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "5" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL5"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "4" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL4"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "3" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL3"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		elseif self:GetJobTable().Clearance == "2" then
			for k,v in pairs(PreTable[self:GetRegiment()]["Unique"]["CL2"]) do
				table.insert(PlayerTable["Unique"],v)
			end
		end
	return PlayerTable
end

function meta:DynamicCheck()
	local RegimentTable = self:GetDynamicFullRegimentTable()
	local PlayerTable = self:GetDynamicPlayerTable()
	local Returned = false
	if table.HasValue(RegimentTable["Primary"], PlayerTable["Primary"]) or PlayerTable["Primary"] == ""  then
		if table.HasValue(RegimentTable["Secondary"], PlayerTable["Secondary"]) or PlayerTable["Secondary"] == ""   then
			if table.HasValue(RegimentTable["Specialist"], PlayerTable["Spec"]) or PlayerTable["Spec"] == ""   then
				if (HasAugment(self,"Ace up the Sleeve [PRIMARY]") and table.HasValue(RegimentTable["Primary"], PlayerTable["Ace"])) or PlayerTable["Ace"] == ""   then
					Returned = true
				elseif (HasAugment(self,"Ace up the Sleeve [SPECIALIST]") and table.HasValue(RegimentTable["Specialist"], PlayerTable["Ace"])) or PlayerTable["Ace"] == ""   then
					Returned = true
				else
					Returned = false
				end
			else
				Returned = false
			end
		else
			Returned = false
		end
	else
		Returned = false
	end
	return Returned
end

function meta:DynamicEditCheck(PlayerTable)
	local RegimentTable = self:GetDynamicFullRegimentTable()
	local Returned = false
	if table.HasValue(RegimentTable["Primary"], PlayerTable["Primary"]) or PlayerTable["Primary"] == "" then
		if table.HasValue(RegimentTable["Secondary"], PlayerTable["Secondary"]) or PlayerTable["Secondary"] == ""  then
			if table.HasValue(RegimentTable["Specialist"], PlayerTable["Spec"]) or PlayerTable["Spec"] == ""  then
				Returned = true
			else
				Returned = false
			end
		else
			Returned = false
		end
	else
		Returned = false
	end
	return Returned
end

function meta:GiveLoadout()
	local PlayerTable = self:GetDynamicPlayerTable()
	local RegimentTable = self:GetDynamicRegimentTable()
	self:Give(PlayerTable["Primary"],false)
	self:Give(PlayerTable["Secondary"],false)
	self:Give(PlayerTable["Spec"],false)
	self:Give(PlayerTable["Ace"],false)
	for k,v in pairs(RegimentTable["Unique"]) do
		self:Give(v,false)
	end
end

function meta:GiveUniversal()
	for k,v in pairs(DYNAMIC_UNIVERSAL) do
		self:Give(v,false)
	end
end

function meta:DynamicStaff()
	if self:IsAdmin() then
		self:Give("gmod_tool")
		self:Give("weapon_physgun")
	end
end

function meta:GiveClass()
	if self:GetRankName() == "[HEAVY]" then
		local PreTable = {}
		for k,v in pairs(DYNAMIC_REGIMENT_LOADOUT) do
			if table.GetKeys(DYNAMIC_REGIMENT_LOADOUT[k])[1] == self:GetRegiment() then
				PreTable = v[self:GetRegiment()]["Class"]
			end
		end
		for k,v in pairs(PreTable["Heavy"]) do
			self:Give(v,false)
		end
	elseif self:GetRankName() == "[SUPPORT]" then
		local PreTable = {}
		for k,v in pairs(DYNAMIC_REGIMENT_LOADOUT) do
			if table.GetKeys(DYNAMIC_REGIMENT_LOADOUT[k])[1] == self:GetRegiment() then
				PreTable = v[self:GetRegiment()]["Class"]
			end
		end
		for k,v in pairs(PreTable["Support"]) do
			self:Give(v,false)
		end
	elseif self:GetRankName() == "[SPEC]" then
		local PreTable = {}
		for k,v in pairs(DYNAMIC_REGIMENT_LOADOUT) do
			if table.GetKeys(DYNAMIC_REGIMENT_LOADOUT[k])[1] == self:GetRegiment() then
				PreTable = v[self:GetRegiment()]["Class"]
			end
		end
		for k,v in pairs(PreTable["Spec"]) do
			self:Give(v,false)
		end
	end
end

function meta:DynamicStrip()
	for k,v in pairs(self:GetWeapons()) do
		if v:GetClass() == "bkeycard" or v:GetClass() == "climb_swep2" then
		else
			self:StripWeapon(v:GetClass())
		end
	end
end

function meta:DynamicLoadout()
	timer.Simple(0.01, function()
		self:DynamicStrip()
		if self:DynamicCheck() then
			self:GiveLoadout()
		else
			self:DynamicError("1", "Security Check Failed. Try recreating your loadout.")
		end
		self:GiveClass()
		self:DynamicStaff()
		self:GiveUniversal()
	end)
end
