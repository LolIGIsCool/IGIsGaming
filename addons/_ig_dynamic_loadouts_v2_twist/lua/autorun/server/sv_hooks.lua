-- Network Strings
	util.AddNetworkString("IG_LOADOUT_ADMIN_EDIT_OPEN")
	util.AddNetworkString("IG_LOADOUT_ADMIN_SAVE_BYPASS")
	util.AddNetworkString("IG_LOADOUT_ADMIN_SAVE_REFRESH")
	util.AddNetworkString("IG_LOADOUT_ADMIN_SAVE_UNIVERSAL")
	util.AddNetworkString("IG_LOADOUT_ADMIN_SAVE_LOADOUT")

	util.AddNetworkString("IG_LOADOUT_SEND_ERROR")

-- Edit Loadouts
	hook.Add("IGPlayerSay", "IG_LoadOut_Command", function( ply, text )
		if string.lower(text) == "!loadoutmenu" then
			if ply:IsSuperAdmin() then
				ply:PrintMessage(HUD_PRINTTALK, "Opening edit loadout menu...")
				-- Imports
					-- Job Code Table
					local RegimentTableImport = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))
					-- Bypass Regiment Table
					local BypassTableImport = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/bypassregiments.txt", "DATA"))
					-- Regiment Loadout Table
					local RegimentLoadoutImport = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA"))
					-- Universal Items Table
					local UniversalItemImport = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/universal.txt", "DATA"))
				local RegimentTableExport = {}
				local i = 0
			    for k, v in pairs(RegimentTableImport) do
			    i = i + 1
			        table.insert(RegimentTableExport, table.GetKeys(RegimentTableImport)[i])
			    end

			    net.Start("IG_LOADOUT_ADMIN_EDIT_OPEN")
                	local compress1 = util.Compress(util.TableToJSON(RegimentTableExport))
                	
                	net.WriteUInt(#compress1, 16)
			    	net.WriteData(compress1)
                
                	local compress2 = util.Compress(util.TableToJSON(BypassTableImport))
                	
                	net.WriteUInt(#compress2, 16)
			    	net.WriteData(compress2)
                
                	local compress3 = util.Compress(util.TableToJSON(RegimentLoadoutImport))
                	
                	net.WriteUInt(#compress3, 16)
			    	net.WriteData(compress3)
                
                	local compress4 = util.Compress(util.TableToJSON(UniversalItemImport))
                	
                	net.WriteUInt(#compress4, 16)
			    	net.WriteData(compress4)
			    net.Send(ply)
				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission for this command.")
				return ""
			end
		end
	end)
-- Refresh Loadouts
	hook.Add("IGPlayerSay", "IG_LoadOut_Refresh_Play--rs", function( ply, text )
		if string.lower(text) == "!loadoutrefresh" then
			if ply:IsSuperAdmin() then
				DYNAMIC_PLAYER_DATA = {}
				for k, v in ipairs( player.GetAll() ) do
					local templayerdata = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA"))
						DYNAMIC_PLAYER_DATA[v:SteamID()] = {
							["First"] = {
								["Active"] = templayerdata[ply:SteamID()]["First"]["Active"],
								["Purchased"] = templayerdata[ply:SteamID()]["First"]["Purchased"],
								["Regiment"] = templayerdata[ply:SteamID()]["First"]["Regiment"],
								["Loadout"] = {
									["Primary"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Primary"],
									["Secondary"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Secondary"],
									["Spec"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Spec"],
									["Ace"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Ace"],
								},
							},
							["Second"] = {
								["Active"] = templayerdata[ply:SteamID()]["Second"]["Active"],
								["Purchased"] = templayerdata[ply:SteamID()]["Second"]["Purchased"],
								["Regiment"] = templayerdata[ply:SteamID()]["Second"]["Regiment"],
								["Loadout"] = {
									["Primary"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Primary"],
									["Secondary"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Secondary"],
									["Spec"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Spec"],
									["Ace"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Ace"],
								},
							},
							["Third"] = {
								["Active"] = templayerdata[ply:SteamID()]["Third"]["Active"],
								["Purchased"] = templayerdata[ply:SteamID()]["Third"]["Purchased"],
								["Regiment"] = templayerdata[ply:SteamID()]["Third"]["Regiment"],
								["Loadout"] = {
									["Primary"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Primary"],
									["Secondary"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Secondary"],
									["Spec"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Spec"],
									["Ace"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Ace"],
								},
							},
						}
				end
				ply:PrintMessage(HUD_PRINTTALK, #player.GetAll().." players refreshed")
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission for this command.")
				return ""
			end
		end
	end)

-- Player Spawn Hook
	hook.Add("PlayerSpawn", "IG_DYNAMIC_V2_PLY_SPAWN", function(ply)
		if not table.HasValue(DYANMIC_BYPASS, ply:GetRegiment()) then
			if ply:GetJobTable().RealName == "ID-10" or ply:GetRankName() == "ID-10" then
			else
				ply:DynamicLoadout()
			end
		end
	end)

--Init Spawn
	hook.Add("PlayerInitialSpawn", "IG_LoadOut_Player_Init", function( ply )
		if not file.Exists("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA") then
			local playerdata = {
				[ply:SteamID()] = {
					["First"] = {
						["Purchased"] = true,
						["Regiment"] = ply:GetRegiment(),
						["Active"] = true,
						["Loadout"] = {
							["Primary"] = "rw_sw_trd_e11_noscope",
							["Secondary"] = "",
							["Spec"] = "",
							["Ace"] = "",
						}
					},
					["Second"] = {
						["Purchased"] = false,
						["Regiment"] = ply:GetRegiment(),
						["Active"] = false,
						["Loadout"] = {
							["Primary"] = "",
							["Secondary"] = "",
							["Spec"] = "",
							["Ace"] = "",
						}
					},
					["Third"] = {
						["Purchased"] = false,
						["Regiment"] = ply:GetRegiment(),
						["Active"] = false,
						["Loadout"] = {
							["Primary"] = "",
							["Secondary"] = "",
							["Spec"] = "",
							["Ace"] = "",
						}
					},
				}
			}
			file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
			print("[IG LOADOUT] Creating Data file for: "..ply:SteamID64())
		end

		local templayerdata = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA"))
		if DYNAMIC_PLAYER_DATA then
			DYNAMIC_PLAYER_DATA[ply:SteamID()] = {
				["First"] = {
					["Active"] = templayerdata[ply:SteamID()]["First"]["Active"],
					["Purchased"] = templayerdata[ply:SteamID()]["First"]["Purchased"],
					["Regiment"] = templayerdata[ply:SteamID()]["First"]["Regiment"],
					["Loadout"] = {
						["Primary"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Primary"],
						["Secondary"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Secondary"],
						["Spec"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Spec"],
						["Ace"] = templayerdata[ply:SteamID()]["First"]["Loadout"]["Ace"],
					},
				},
				["Second"] = {
					["Active"] = templayerdata[ply:SteamID()]["Second"]["Active"],
					["Purchased"] = templayerdata[ply:SteamID()]["Second"]["Purchased"],
					["Regiment"] = templayerdata[ply:SteamID()]["Second"]["Regiment"],
					["Loadout"] = {
						["Primary"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Primary"],
						["Secondary"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Secondary"],
						["Spec"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Spec"],
						["Ace"] = templayerdata[ply:SteamID()]["Second"]["Loadout"]["Ace"],
					},
				},
				["Third"] = {
					["Active"] = templayerdata[ply:SteamID()]["Third"]["Active"],
					["Purchased"] = templayerdata[ply:SteamID()]["Third"]["Purchased"],
					["Regiment"] = templayerdata[ply:SteamID()]["Third"]["Regiment"],
					["Loadout"] = {
						["Primary"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Primary"],
						["Secondary"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Secondary"],
						["Spec"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Spec"],
						["Ace"] = templayerdata[ply:SteamID()]["Third"]["Loadout"]["Ace"],
					},
				},
			}
		end
	end)

net.Receive("IG_LOADOUT_ADMIN_SAVE_BYPASS", function(len, ply)
	if ply:IsSuperAdmin() then
		local ByPassTable = net.ReadTable()
		file.Write("ig_dynamic_loadout_v2/settings/bypassregiments.txt", util.TableToJSON(ByPassTable,true))
		DYANMIC_BYPASS = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/bypassregiments.txt", "DATA"))
		ply:DynamicLog("Bypass Save")
	end
end)

net.Receive("IG_LOADOUT_ADMIN_SAVE_UNIVERSAL", function(len, ply)
	if ply:IsSuperAdmin() then
		local UniversalTable = net.ReadTable()
		file.Write("ig_dynamic_loadout_v2/settings/universal.txt", util.TableToJSON(UniversalTable,true))
		DYNAMIC_UNIVERSAL = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/universal.txt", "DATA"))
		ply:DynamicLog("Universal Save")
	end
end)

net.Receive("IG_LOADOUT_ADMIN_SAVE_LOADOUT", function(len, ply)
	if ply:IsSuperAdmin() then
		local LoadoutTable = net.ReadTable()
		local Regiment = net.ReadString()
		ulx.fancyLogAdmin(ply, "#A made loadout changes")
		file.Write("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", util.TableToJSON(LoadoutTable,true))
		DYNAMIC_REGIMENT_LOADOUT = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA"))
		ply:DynamicLog("Loadout Edit: "..Regiment)
	end
end)

net.Receive("IG_LOADOUT_ADMIN_SAVE_REFRESH", function(len, ply)
	if ply:IsSuperAdmin() then
		local MissingTable = net.ReadTable()
		local RegimentLoadoutImport = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA"))
		for i,v in pairs(MissingTable) do
	    	local regimentloadout = {
	    		[v] = {
    				["Primary"] = {
    					["Base"] = {},
    					["CL1"] = {},
    					["CL2"] = {},
    					["CL3"] = {},
    					["CL4"] = {},
    					["CL5"] = {},
    					["CL6"] = {},
    				},
    				["Secondary"] = {
    					["Base"] = {},
    					["CL1"] = {},
    					["CL2"] = {},
    					["CL3"] = {},
    					["CL4"] = {},
    					["CL5"] = {},
    					["CL6"] = {},
    				},
    				["Specialist"] = {
    					["Base"] = {},
    					["CL1"] = {},
    					["CL2"] = {},
    					["CL3"] = {},
    					["CL4"] = {},
    					["CL5"] = {},
    					["CL6"] = {},
    				},
	    			["Unique"] = {
	    				["Base"] = {},
    					["CL1"] = {},
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
	    	table.insert(RegimentLoadoutImport, regimentloadout)
	    end
		file.Write("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", util.TableToJSON(RegimentLoadoutImport,true))
		DYNAMIC_REGIMENT_LOADOUT = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/settings/regimentloadouts.txt", "DATA"))
		ply:DynamicLog("Refresh Regiment")
	end
end)