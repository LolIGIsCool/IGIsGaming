	function GiveError(ply, errorcode)
		ply:Give("rw_sw_trd_e11_noscope", false)
		ply:PrintMessage( HUD_PRINTTALK, "There was an error loading your loadout, Giving Error Loadout. Error code: "..errorcode)
	end

	function GiveRegDefault(ply)
		local loadtable = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
		local reginum = 0
		for k,v in pairs(loadtable) do
			if table.HasValue(table.GetKeys(loadtable[k]), ply:GetRegiment()) then
				reginum = k
			end
		end
		for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Unique"]) do
			ply:Give(v, false)
		end
	end

	function GiveClass(ply)
		local classport = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/classes.txt", "DATA"))
		if ply:GetRankName() == "[SUPPORT]" or ply:GetRankName() == "[HEAVY]" or ply:GetRankName() == "[MEDIC]" then
			if ply:GetRankName() == "[SUPPORT]" then
				for k,v in pairs(classport[1]["Equipment"]) do
					ply:Give(v, false)
				end
			elseif ply:GetRankName() == "[HEAVY]" then
				if ply:GetRegiment() == "275th Sky Division" then
					for k,v in pairs(classport[2]["Equipment"]) do
						if v == "ven_riddick_dlt23v" then
							ply:Give("rw_sw_smartlauncher", false)
						else
							ply:Give(v, false)
						end
					end
				else
					for k,v in pairs(classport[2]["Equipment"]) do
						ply:Give(v, false)
					end
					if ply:GetRegiment() == "Purge Trooper" then
						ply:Give("imperialarts_bludgeon_electrohammer", false)
					end
				end
			elseif ply:GetRankName() == "[MEDIC]" then
				for k,v in pairs(classport[3]["Equipment"]) do
					ply:Give(v, false)
				end
			end
		end
	end

	function GiveUniversal(ply)
		local uniport = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/universal.txt", "DATA"))
		for i, v in pairs(uniport) do
			ply:Give(v, false)
		end
	end

	function GetPointShopTable(ply)
		local pstable = {}
		local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))

		// Pointshop
			local primfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/primaries/*.lua", "GAME" )
			for k,v in pairs(primfiles) do
				primfiles[k] = primfiles[k]:sub(1, -5)
			end
			local secfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/secondaries/*.lua", "GAME" )
			for k,v in pairs(secfiles) do
				secfiles[k] = secfiles[k]:sub(1, -5)
			end
			local specfiles, directories = file.Find( "addons/_a_pointshop/lua/pointshop/items/specialties/*.lua", "GAME" )
			for k,v in pairs(specfiles) do
				specfiles[k] = specfiles[k]:sub(1, -5)
			end
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
				dualrk3 = "rw_sw_dual_rk3",
				cr2 = "rw_sw_cr2", 
				dc15se = "rw_sw_dc15se",
				dualdc15s = "rw_sw_dual_dc15s",
				dualdc17 = "rw_sw_dual_dc17",
				duale11 = "rw_sw_dual_e11",
				dualse14c = "rw_sw_dual_se14",
				traininge11 = "rw_sw_trd_e11",
			}

			local secondaryClassMappings = {
				dc17 = "rw_sw_dc17",
				dl44 = "rw_sw_dl44",
				dt12 = "rw_sw_dt12",
				rk3 = "rw_sw_rk3",
				s5 = "rw_sw_s5",
				scoutblaster = "rw_sw_scoutblaster",
				x8 = "rw_sw_x8",
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
			}

			local specialClassMappings = {
			    boo_crew = "boocrew_dc17",
			    candy_cane = "rw_sw_e11_candycane", 
			    scream_team = "screamteam_dc17",
			    spooky_skeletons = "spookyskeletons_dc17",
			}

			local specialtiesClassMappings = {
			    e5s = "rw_sw_e5s",
			    iqa11 = "rw_sw_iqa11", 
			    scattershotgun = "rw_sw_scattershotgun",
			    smartlauncher = "rw_sw_smartlauncher",
			    z2 = "rw_sw_z2",
			    z4 = "rw_sw_z4",
			    z6 = "rw_sw_z6",
			}

			for k,v in pairs(ply:SH_GetInventory()) do
				if v["class"] == "bhp100" or v["class"] == "dhp200" or v["class"] == "fhp300"then else
					if table.HasValue(primfiles, v["class"]) or v["class"] == "dualse14c" then
						table.insert(pstable, primaryClassMappings[v["class"]])
					elseif table.HasValue(secfiles, v["class"]) then
						table.insert(pstable, secondaryClassMappings[v["class"]])
					elseif table.HasValue(specfiles, v["class"]) then
						table.insert(pstable, specialtiesClassMappings[v["class"]])
					elseif v["class"] == "iqa11" then
						table.insert(pstable, specialtiesClassMappings[v["class"]])
					elseif table.HasValue(donfiles, v["class"]) then
						table.insert(pstable, donatorClassMappings[v["class"]])
					elseif table.HasValue(specialfiles, v["class"]) then
						table.insert(pstable, specialClassMappings[v["class"]])
					end
				end
			end


		// Weapon
			local reginum = 0

			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), ply:GetRegiment()) then
					reginum = k
				end
			end

			table.Add(pstable, import[reginum][ply:GetRegiment()]["Main"]["Primary"])
			table.Add(pstable, import[reginum][ply:GetRegiment()]["Main"]["Secondary"])
			table.Add(pstable, import[reginum][ply:GetRegiment()]["Main"]["Specialist"])

		// CL
			if ply:GetJobTable().Clearance == "1" then

			elseif ply:GetJobTable().Clearance == "2" then
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(pstable, v)
				end
			elseif ply:GetJobTable().Clearance == "3" then
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(pstable, v)
				end
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
					table.insert(pstable, v)
				end
			elseif ply:GetJobTable().Clearance == "4" or "5" or "6" or "ALL ACCESS" then
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(pstable, v)
				end
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
					table.insert(pstable, v)
				end
				for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL4"]) do
					table.insert(pstable, v)
				end
			end
		return pstable
	end

	function GiveUniqueClearance(ply)
		local reginum = 0	
		local loadtable = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/clearance_unique.txt", "DATA"))
		for k,v in pairs(loadtable) do
			if table.HasValue(table.GetKeys(loadtable[k]), ply:GetRegiment()) then
				reginum = k
			end
		end
		if ply:GetJobTable().Clearance == "1" then
		elseif ply:GetJobTable().Clearance == "2" then
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				ply:Give(v, false)
			end
		elseif ply:GetJobTable().Clearance == "3" then
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				ply:Give(v, false)
			end
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
				ply:Give(v, false)
			end
			ply:Give("weapon_rpw_binoculars_nvg",false)
		elseif ply:GetJobTable().Clearance == "4" or "5" or "6" or "ALL ACCESS" then
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				ply:Give(v, false)
			end
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
				ply:Give(v, false)
			end
			for k,v in pairs(loadtable[reginum][ply:GetRegiment()]["Clearance"]["CL4"]) do
				ply:Give(v, false)
			end
			ply:Give("weapon_rpw_binoculars_nvg",false)
		end
	end

	function GiveLoadout(ply)
		if ply:GetRegiment() == "Recruit" then
			ply:Give("rw_sw_trd_e11_noscope", false)
		else
			local playeritems = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA"))
			local weapontable = GetPointShopTable(ply)
			if playeritems["First"]["Active"] == true and playeritems["First"]["Regiment"] == ply:GetRegiment() then
				if table.HasValue(weapontable, playeritems["First"]["Loadout"]["Primary"]) or playeritems["First"]["Loadout"]["Primary"] == "" then
					if table.HasValue(weapontable, playeritems["First"]["Loadout"]["Secondary"]) or playeritems["First"]["Loadout"]["Secondary"] == "" then
						if table.HasValue(weapontable, playeritems["First"]["Loadout"]["Spec"]) or playeritems["First"]["Loadout"]["Spec"] == "" then
							ply:Give(playeritems["First"]["Loadout"]["Primary"], false)
							ply:Give(playeritems["First"]["Loadout"]["Secondary"], false)
							ply:Give(playeritems["First"]["Loadout"]["Spec"], false)
							ply:PrintMessage( HUD_PRINTTALK, "Spawning with first loadout." )
						else
							local errorcode = "05"
							GiveError(ply, errorcode)
						end
					else
						local errorcode = "05"
						GiveError(ply, errorcode)
					end
				else
					local errorcode = "05"
					GiveError(ply, errorcode)
				end
			elseif playeritems["Second"]["Active"] == true and playeritems["Second"]["Regiment"] == ply:GetRegiment() then
				if table.HasValue(weapontable, playeritems["Second"]["Loadout"]["Primary"]) or playeritems["First"]["Loadout"]["Primary"] == "" then
					if table.HasValue(weapontable, playeritems["Second"]["Loadout"]["Secondary"]) or playeritems["First"]["Loadout"]["Secondary"] == "" then
						if table.HasValue(weapontable, playeritems["Second"]["Loadout"]["Spec"]) or playeritems["First"]["Loadout"]["Spec"] == "" then
							ply:Give(playeritems["Second"]["Loadout"]["Primary"], false)
							ply:Give(playeritems["Second"]["Loadout"]["Secondary"], false)
							ply:Give(playeritems["Second"]["Loadout"]["Spec"], false)
							ply:PrintMessage( HUD_PRINTTALK, "Spawning with second loadout." )
						else
							local errorcode = "05"
							GiveError(ply, errorcode)
						end
					else
						local errorcode = "05"
						GiveError(ply, errorcode)
					end
				else
					local errorcode = "05"
					GiveError(ply, errorcode)	
				end
			elseif playeritems["Third"]["Active"] == true and playeritems["Third"]["Regiment"] == ply:GetRegiment() then
				if table.HasValue(weapontable, playeritems["Third"]["Loadout"]["Primary"]) or playeritems["First"]["Loadout"]["Primary"] == ""  then
					if table.HasValue(weapontable, playeritems["Third"]["Loadout"]["Secondary"]) or playeritems["First"]["Loadout"]["Secondary"] == ""  then
						if table.HasValue(weapontable, playeritems["Third"]["Loadout"]["Spec"]) or playeritems["First"]["Loadout"]["Spec"] == ""  then
							ply:Give(playeritems["Third"]["Loadout"]["Primary"], false)
							ply:Give(playeritems["Third"]["Loadout"]["Secondary"], false)
							ply:Give(playeritems["Third"]["Loadout"]["Spec"], false)
							ply:PrintMessage( HUD_PRINTTALK, "Spawning with third loadout." )
						else
							local errorcode = "05"
							GiveError(ply, errorcode)
						end
					else
						local errorcode = "05"
						GiveError(ply, errorcode)
					end
				else
					local errorcode = "05"
					GiveError(ply, errorcode)	
				end
			else
				local errorcode = "01"
				GiveError(ply, errorcode)
			end
		end
	end

	function GiveAdmin(ply)
		ply:Give("weapon_physgun", false)
		ply:Give("gmod_tool", false)
	end

	function GiveFullLoadout(ply)
		ply:StripWeapons()
		GiveLoadout(ply)
		GiveClass(ply)
		GiveRegDefault(ply)
		GiveUniversal(ply)
		GiveUniqueClearance(ply)
		if ply:IsAdmin() then
			GiveAdmin(ply)
		end
	end


	net.Receive("igSquadMenuSetLoadout", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local weapontable = net.ReadTable()
			local regiment = net.ReadString()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), regiment) then
					reginum = k
				end
			end
			import[reginum][regiment]["Main"]["Primary"] = weapontable.prim
			import[reginum][regiment]["Main"]["Secondary"] = weapontable.sec
			import[reginum][regiment]["Main"]["Specialist"] = weapontable.spec
			file.Write("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", util.TableToJSON(import))
		end
	end)

	net.Receive("igSquadMenuSetClearance", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local weapontable = net.ReadTable()
			local regiment = net.ReadString()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), regiment) then
					reginum = k
				end
			end
			import[reginum][regiment]["Clearance"]["CL2"] = weapontable.prim
			import[reginum][regiment]["Clearance"]["CL3"] = weapontable.sec
			import[reginum][regiment]["Clearance"]["CL4"] = weapontable.spec
			file.Write("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", util.TableToJSON(import))
		end
	end)

	net.Receive("igSquadMenuSetUniqueClearance", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local weapontable = net.ReadTable()
			local regiment = net.ReadString()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/clearance_unique.txt", "DATA"))
			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), regiment) then
					reginum = k
				end
			end
			import[reginum][regiment]["Clearance"]["CL2"] = weapontable.prim
			import[reginum][regiment]["Clearance"]["CL3"] = weapontable.sec
			import[reginum][regiment]["Clearance"]["CL4"] = weapontable.spec
			file.Write("ig_dynamic_loadout/loadouts/clearance_unique.txt", util.TableToJSON(import))
		end
	end)

	net.Receive("igSquadMenuSetUnique", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local weapontable = net.ReadTable()
			local regiment = net.ReadString()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), regiment) then
					reginum = k
				end
			end
			import[reginum][regiment]["Unique"] = weapontable
			file.Write("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", util.TableToJSON(import))
		end
	end)

	net.Receive("igSquadMenuSetUniveral", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local weapontable = net.ReadTable()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/universal.txt", "DATA"))
				import = weapontable
			file.Write("ig_dynamic_loadout/loadouts/universal.txt", util.TableToJSON(import))
		end
	end)

	net.Receive("igSquadMenuSetClasses", function(len, ply)
		if ply:IsSuperAdmin() or ply:IsDeveloper() then
			local sana = net.ReadTable()
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/classes.txt", "DATA"))
				import[1]["Equipment"] = sana.support
				import[2]["Equipment"] = sana.heavy
				import[3]["Equipment"] = sana.medic
			file.Write("ig_dynamic_loadout/loadouts/classes.txt", util.TableToJSON(import))
		end
	end)
