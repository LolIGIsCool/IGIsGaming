if not file.IsDir("ig_dynamic_loadout_v2", "DATA") then
	print("[IG Load Out] Creating Load Out Directory...")
	file.CreateDir("ig_dynamic_loadout_v2")
end

if not file.IsDir("ig_dynamic_loadout_v2/settings", "DATA") then
	print("[IG Load Out] Creating Load Out Directory...")
	file.CreateDir("ig_dynamic_loadout_v2/settings")
end

if not file.IsDir("ig_dynamic_loadout_v2/data", "DATA") then
	print("[IG Load Out] Creating Data Directory...")
	file.CreateDir("ig_dynamic_loadout_v2/data")
end

if not file.IsDir("ig_dynamic_loadout_v2/data/player", "DATA") then
	print("[IG Load Out] Creating Player Data Directory...")
	file.CreateDir("ig_dynamic_loadout_v2/data/player")
end

local regtable = {}
    local tableValues = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))
    local i = 0
    for k, v in pairs(tableValues) do
    i = i + 1
        table.insert(regtable, table.GetKeys(tableValues)[i])
    end

-- File Creation
	if not file.Exists("ig_dynamic_loadout_v2/settings/bypassregiments.txt", "DATA") then
		print("[IG Load Out] Creating bypassregiments.txt...")
		local loadout = {}
		file.Write("ig_dynamic_loadout_v2/settings/bypassregiments.txt", util.TableToJSON(loadout,true))
	end

	if not file.Exists("ig_dynamic_loadout_v2/settings/universal.txt", "DATA") then
		print("[IG Load Out] Creating universal.txt...")
		local loadout = {}
		file.Write("ig_dynamic_loadout_v2/settings/universal.txt", util.TableToJSON(loadout,true))
	end

	if not file.Exists("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA") then
		print("[IG Load Out] Creating regiment loadouts.txt...")
		local loadout = {}
			 	for i,v in pairs(regtable) do
			    	local regimentloadout = {
			    		[v] = {
		    				["Primary"] = {
		    					["Base"] = {},
		    					["CL2"] = {},
		    					["CL3"] = {},
		    					["CL4"] = {},
		    					["CL5"] = {},
		    					["CL6"] = {},
		    				},
		    				["Secondary"] = {
		    					["Base"] = {},
		    					["CL2"] = {},
		    					["CL3"] = {},
		    					["CL4"] = {},
		    					["CL5"] = {},
		    					["CL6"] = {},
		    				},
		    				["Specialist"] = {
		    					["Base"] = {},
		    					["CL2"] = {},
		    					["CL3"] = {},
		    					["CL4"] = {},
		    					["CL5"] = {},
		    					["CL6"] = {},
		    				},
			    			["Unique"] = {
			    				["Base"] = {},
		    					["CL2"] = {},
		    					["CL3"] = {},
		    					["CL4"] = {},
		    					["CL5"] = {},
		    					["CL6"] = {},
			    			},
			    			["Class"] = {
			    				["Heavy"] = {
			    					"ven_riddick_dlt23v",
			    					"deployable_shield",
			    					"rw_ammo_distributor",
			    				},
			    				["Support"] = {
			    					"weapon_bactainjector",
        							"weapon_jew_stimkit",
			    				},
			    				["Spec"] = {
			    					"weapon_bactainjector",
							        "weapon_jew_stimkit",
							        "hideyoshi_ig_defibs",
			    				},
			    			},
			    		},
			    	}
			    	table.insert(loadout, regimentloadout)
			    end
		file.Write("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", util.TableToJSON(loadout,true))
	end
	
-- Tables
	print("[IG Load Out] Initialising Tables...")
	-- Bypass Regiment Table

		DYANMIC_BYPASS = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/bypassregiments.txt", "DATA"))
		if DYANMIC_BYPASS then
			print("[IG Load Out] Initialised Table: DYNAMIC_BYPASS")
		else
			print("[IG Load Out] Initialisation Failure: DYNAMIC_BYPASS")
		end
	-- Regiment Loadout Table
		DYNAMIC_REGIMENT_LOADOUT = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA"))
		if DYNAMIC_REGIMENT_LOADOUT then
			print("[IG Load Out] Initialised Table: DYNAMIC_REGIMENT_LOADOUT")
		else
			print("[IG Load Out] Initialisation Failure: DYNAMIC_REGIMENT_LOADOUT")
		end
	-- Universal Items Table
		DYNAMIC_UNIVERSAL = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/universal.txt", "DATA"))
		if DYNAMIC_UNIVERSAL then
			print("[IG Load Out] Initialised Table: DYNAMIC_UNIVERSAL")
		else
			print("[IG Load Out] Initialisation Failure: DYNAMIC_UNIVERSAL")
		end
	-- Player Data
		DYNAMIC_PLAYER_DATA = {}
		print("[IG Load Out] Initialised Table: DYNAMIC PLAYER DATA")
		print("[IG Load Out] Initialisation Completed.")

		for k, v in ipairs( player.GetAll() ) do
			print("[IG Load Out] Refreshing: "..v:Nick())
		    local templayerdata = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..v:SteamID64()..".txt", "DATA"))
			if DYNAMIC_PLAYER_DATA then
				table.insert(DYNAMIC_PLAYER_DATA, templayerdata)
			end
		end