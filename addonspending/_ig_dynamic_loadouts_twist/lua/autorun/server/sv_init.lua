if SERVER then

	//
		local regtable = {}
	    local tableValues = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))
	    local i = 0
	    for k, v in pairs(tableValues) do
	    i = i + 1
	        table.insert(regtable, table.GetKeys(tableValues)[i])
	    end
    
    // Creating Data Directories
		if not file.IsDir("ig_dynamic_loadout", "DATA") then
			print("[IG Load Out] Creating Load Out Directory...")
			file.CreateDir("ig_dynamic_loadout")
		end

		if not file.IsDir("ig_dynamic_loadout/loadouts", "DATA") then
			print("[IG Load Out] Creating Load Out Directory...")
			file.CreateDir("ig_dynamic_loadout/loadouts")
		end

		if not file.IsDir("ig_dynamic_loadout/playerdata", "DATA") then
			print("[IG Load Out] Creating Load Out Directory...")
			file.CreateDir("ig_dynamic_loadout/playerdata")
		end

		if not file.IsDir("ig_dynamic_loadout/playerdata/loadouts", "DATA") then
			print("[IG Load Out] Creating Load Out Directory...")
			file.CreateDir("ig_dynamic_loadout/playerdata/loadouts")
		end

		if not file.IsDir("ig_dynamic_loadout/playerdata/purchases", "DATA") then
			print("[IG Load Out] Creating Load Out Directory...")
			file.CreateDir("ig_dynamic_loadout/playerdata/purchases")
		end

	// Creating Data Files
		// Final Loadouts
			if not file.Exists("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA") then
				print("[IG Load Out] Creating regiment.txt...")
				local loadout = {}
			 	for i,v in pairs(regtable) do
			    	local regimentloadout = {
			    		[v] = {
			    			["Main"] = {
			    				["Primary"] = {},
			    				["Secondary"] = {},
			    				["Specialist"] = {},
			    			},
			    			["Clearance"] = {
			    				["CL2"] = {},
			    				["CL3"] = {},
			    				["CL4"] = {},
			    			},
			    			["Unique"] = {},
			    		},
			    	}
			    	table.insert(loadout, regimentloadout)
			    end
				file.Write("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", util.TableToJSON(loadout))
			end

		// CL Unique :pensive:
			if not file.Exists("ig_dynamic_loadout/loadouts/clearance_unique.txt", "DATA") then
				print("[IG Load Out] Creating regiment.txt...")
				local loadout = {}
			 	for i,v in pairs(regtable) do
			    	local regimentloadout = {
			    		[v] = {
			    			["Clearance"] = {
			    				["CL2"] = {},
			    				["CL3"] = {},
			    				["CL4"] = {},
			    			},
			    		},
			    	}
			    	table.insert(loadout, regimentloadout)
			    end
				file.Write("ig_dynamic_loadout/loadouts/clearance_unique.txt", util.TableToJSON(loadout))
			end

		// Class Loadouts
			if not file.Exists("ig_dynamic_loadout/loadouts/classes.txt", "DATA") then
				print("[IG Load Out] Creating classes.txt...")
				local loadout = {}
				local classes = {
					"[SUPPORT]",
					"[HEAVY]",
					"[MEDIC]"
				}
				for i, v in pairs(classes) do
					local classloadout = {
						["Class"] = v,
						["Equipment"] = {
							"",
						}
					}
				table.insert(loadout, classloadout)
				end

				file.Write("ig_dynamic_loadout/loadouts/classes.txt", util.TableToJSON(loadout))
			end

		// Universal Items
			if not file.Exists("ig_dynamic_loadout/loadouts/universal.txt", "DATA") then
				print("[IG Load Out] Creating loadout.txt...")
				local loadout = {
					"climb_swep2",
					"weapon_fists",
					"none"
				}
				file.Write("ig_dynamic_loadout/loadouts/universal.txt", util.TableToJSON(loadout))
			end
end
