// Network Strings
	util.AddNetworkString("igSquadMenuEdit")
	util.AddNetworkString("igSquadMenuSetLoadout")
	util.AddNetworkString("igSquadMenuSetUnique")
	util.AddNetworkString("igSquadMenuSetUniveral")
	util.AddNetworkString("igSquadMenuSetClasses")
	util.AddNetworkString("igSquadMenuSetClearance")
	util.AddNetworkString("igSquadMenuCheckPurchase")
	util.AddNetworkString("igSquadMenuCheckLoadout")
	util.AddNetworkString("igSquadMenuSetUniqueClearance")

// Edit Loadouts Command - Done :pray:
	hook.Add("IGPlayerSay", "IG_LoadOut_Command", function( ply, text )
		if string.lower(text) == "!editloadout" then
			if ply:IsSuperAdmin() or ply:IsDeveloper() then
				local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
				local importclasses = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/classes.txt", "DATA"))
				local importuni = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/universal.txt", "DATA"))
				local importcluni = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/clearance_unique.txt", "DATA"))
				local regtable = {}
				for k,v in pairs(import) do
					local fart = table.ToString(table.GetKeys(import[k]))
					fart = fart:sub(3, -4)
					table.insert(regtable, fart)
				end
				net.Start( "igSquadMenuEdit" )
					net.WriteTable(regtable)
					net.WriteTable(import)
					net.WriteTable(importuni)
					net.WriteTable(importclasses)
					net.WriteTable(importcluni)
				net.Send( ply )
				ply:PrintMessage(HUD_PRINTTALK, "Opening...")
				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
				return ""
			end
		end
	end)

// Refresh regiments
	hook.Add("IGPlayerSay", "IG_LoadOut_Refresh", function( ply, text )
		if string.lower(text) == "!refreshregiments" then
			if ply:IsSuperAdmin() or ply:IsDeveloper() then
				// Current Imports
					local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
					local regtable = {}
					for k,v in pairs(import) do
						local fart = table.ToString(table.GetKeys(import[k]))
						fart = fart:sub(3, -4)
						table.insert(regtable, fart)
					end

					local importcl = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/clearance_unique.txt", "DATA"))
				// New Imports
					local newregtable = {}
				    local tableValues = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))
				    local i = 0
				    for k, v in pairs(tableValues) do
				    i = i + 1
				        table.insert(newregtable, table.GetKeys(tableValues)[i])
				    end

				for i, v in pairs(newregtable) do
					if table.HasValue(regtable, v) then
						// print(v..": true")
					else
						print(v..": false")
						print("[IG Load Out] Refreshing Regiment Loadouts...")
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
						table.insert(import, regimentloadout)
						file.Write("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", util.TableToJSON(import))
						local uniqueloadout = {
							[v] = {
				    			["Clearance"] = {
				    				["CL2"] = {},
				    				["CL3"] = {},
				    				["CL4"] = {},
				    			},
			    			},
						}
						table.insert(importcl, uniqueloadout)
						file.Write("ig_dynamic_loadout/loadouts/clearance_unique.txt", util.TableToJSON(importcl))
					end
				end

				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
				return ""
			end
		end
	end)
	
// Reset Command
	hook.Add("IGPlayerSay", "IG_LoadOut_Reset", function( ply, text )
		if string.sub(text,1, 14) == "!loadoutreset " then
			if ply:IsAdmin() then
				local sid64 = string.sub(text, 15)
				if file.Exists("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA") then
					ply:PrintMessage(HUD_PRINTTALK, "Resetting loadout file")
					local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA"))
						playerloadout["First"]["Loadout"]["Primary"] = "rw_sw_trd_e11_noscope"
						playerloadout["First"]["Loadout"]["Secondary"] = ""
						playerloadout["First"]["Loadout"]["Spec"] = ""
						playerloadout["First"]["Active"] = true
						playerloadout["Second"]["Loadout"]["Primary"] = ""
						playerloadout["Second"]["Loadout"]["Secondary"] = ""
						playerloadout["Second"]["Loadout"]["Spec"] = ""
						playerloadout["Second"]["Active"] = false
						playerloadout["Third"]["Loadout"]["Primary"] = ""
						playerloadout["Third"]["Loadout"]["Secondary"] = ""
						playerloadout["Third"]["Loadout"]["Spec"] = ""
						playerloadout["Third"]["Active"] = false
					file.Write("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", util.TableToJSON(playerloadout))
				else
					ply:PrintMessage(HUD_PRINTTALK, "There isn't a file for that SteamID64. Make sure you got the right one")
				end
				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
				return ""
			end
		end
	end)

// Check Loadout Command
	hook.Add("IGPlayerSay", "IG_LoadOut_Check", function( ply, text )
		if string.sub(text,1, 14) == "!checkloadout " then
			if ply:IsAdmin() then
				local sid64 = string.sub(text, 15)
				if file.Exists("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA") then
					local playeritems = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA"))
					ply:PrintMessage(HUD_PRINTTALK, "Openning loadout Check")
					net.Start( "igSquadMenuCheckLoadout" )
						net.WriteTable(playeritems)
					net.Send(ply)
				else
					ply:PrintMessage(HUD_PRINTTALK, "There isn't a file for that SteamID64. Make sure you got the right one")
				end
				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
				return ""
			end
		end
	end)

// Force Reset Command
	hook.Add("IGPlayerSay", "IG_LoadOut_ForceReset", function( ply, text )
		if string.sub(text,1, 19) == "!forceloadoutreset " then
			if ply:IsSuperAdmin() or ply:IsDeveloper() then
				local sid64 = string.sub(text, 20)
				if file.Exists("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA") then
					ply:PrintMessage(HUD_PRINTTALK, "Resetting loadout file")
					local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", "DATA"))
						playerloadout["First"]["Loadout"]["Primary"] = "rw_sw_trd_e11_noscope"
						playerloadout["First"]["Loadout"]["Secondary"] = ""
						playerloadout["First"]["Loadout"]["Spec"] = ""
						playerloadout["First"]["Active"] = true
						playerloadout["Second"]["Loadout"]["Primary"] = ""
						playerloadout["Second"]["Loadout"]["Secondary"] = ""
						playerloadout["Second"]["Loadout"]["Spec"] = ""
						playerloadout["Second"]["Active"] = false
						playerloadout["Third"]["Loadout"]["Primary"] = ""
						playerloadout["Third"]["Loadout"]["Secondary"] = ""
						playerloadout["Third"]["Loadout"]["Spec"] = ""
						playerloadout["Third"]["Active"] = false
					file.Write("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", util.TableToJSON(playerloadout))
				else
					local lply = ""
					for k,v in pairs(player.GetAll()) do
						if v:SteamID64() == sid64 then
							lply = v
						end
					end
					if lply == "" then
						local playerdata = {
							["SteamID"] = lply:SteamID(), -- Players SteamID
							["First"] = {
									["Purchased"] = true,
									["Regiment"] = lply:GetRegiment(),
									["Active"] = true,
									["Loadout"] = {
										["Primary"] = "rw_sw_trd_e11_noscope",
										["Secondary"] = "",
										["Spec"] = "",
									}
								},
								["Second"] = {
									["Purchased"] = false,
									["Regiment"] = lply:GetRegiment(),
									["Active"] = false,
									["Loadout"] = {
										["Primary"] = "",
										["Secondary"] = "",
										["Spec"] = "",
									}
								},
								["Third"] = {
									["Purchased"] = false,
									["Regiment"] = lply:GetRegiment(),
									["Active"] = false,
									["Loadout"] = {
										["Primary"] = "",
										["Secondary"] = "",
										["Spec"] = "",
									}
								},
							}
						file.Write("ig_dynamic_loadout/playerdata/loadouts/"..sid64..".txt", util.TableToJSON(playerdata))
						ply:PrintMessage(HUD_PRINTTALK, "Force Resetting/Creating data file.")
					end
				end
				return ""
			else
				ply:PrintMessage(HUD_PRINTTALK, "You do not have permission to use this command.")
				return ""
			end
		end
	end)

// Check purchase logs
	hook.Add("IGPlayerSay", "IG_LoadOut_Check_Purchase", function( ply, text )
		if string.sub(text,1, 14) == "!purchasecheck" then
			if ply:IsAdmin() then
				local files, directories = file.Find( "ig_dynamic_loadout/playerdata/purchases/*.txt", "DATA" )
				local port = {}
				for i,v in pairs(files) do
					local tableimport = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/purchases/"..files[i], "DATA"))
					table.insert(port, tableimport)
				end
				net.Start( "igSquadMenuCheckPurchase" )
					net.WriteTable(port)
				net.Send(ply)
			end
		end
	end)

// Initial Player Spawn
	hook.Add("PlayerInitialSpawn", "IG_LoadOut_Player_Init", function( ply )
		if not file.Exists("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA") then
			local playerdata = {
				["SteamID"] = ply:SteamID(), -- Players SteamID
				["First"] = {
						["Purchased"] = true,
						["Regiment"] = ply:GetRegiment(),
						["Active"] = true,
						["Loadout"] = {
							["Primary"] = "rw_sw_trd_e11_noscope",
							["Secondary"] = "",
							["Spec"] = "",
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
						}
					},
				}
			file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata))
			print("[IG LOADOUT] Creating Data file for: "..ply:SteamID64())
		end
	end)

// Player Spawn
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
		"Jinata Security",
	}
	hook.Add("PlayerSpawn", "IG_LoadOut_Player_Spawn", function( ply )
		if table.HasValue(bypassjobs, ply:GetRegiment()) or ply:GetRankName() == "ID-10" then
			return
		else
			if file.Exists("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA") then
				timer.Simple(0.01, function()
					ply:StripWeapons()
					GiveLoadout(ply)
					GiveClass(ply)
					GiveRegDefault(ply)
					GiveUniversal(ply)
					GiveUniqueClearance(ply)
					if ply:IsAdmin() then
						GiveAdmin(ply)
					end
				end)
			else
				local errorcode = "06"
				GiveError(ply, errorcode)
			end
		end
		local hightierwepslist = {"rw_sw_tusken_cycler", "weapon_squadshield_arm", "rw_sw_nade_stun", "rw_sw_nade_stun", "rw_sw_nade_stun", "rw_sw_nade_stun", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "rw_sw_nt242c", "rw_sw_nt242c", "rw_sw_nt242c", "rw_sw_nt242c", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact"}
		--|OP Tier|--
		-- Cycler Rifle
		-- Squad Shield
		--|High Tier|--
		-- Stun Grenade
		-- DC-15 A [Bling]
		-- NT-242c
		--|Medium Tier|--
		-- DC-15A
		-- X8 Night Sniper
		-- DC-15SE
		-- Incendiary/Impact cause incin broke Grenade
		local hightierwepspretprint = {
			["tfa_swch_dc15a_bling"] = "DC-15A [Bling]",
			["rw_sw_nade_stun"] = "Stun Grenade",
			["weapon_squadshield_arm"] = "Squad Shield",
			["rw_sw_nt242c"] = "NT-242c",
			["rw_sw_tusken_cycler"] = "Cycler Rifle",
			["tfa_swch_dc15a"] = "DC-15A",
			["rw_sw_x8"] = "X-8 Night Sniper",
			["rw_sw_dc15se"] = "DC-15 SE",
			["rw_sw_nade_impact"] = "Impact Grenade"
		}
		if ply:GetNWInt("igprogressu", 0) >= 4 then
			if ply:GetNWInt("igRandomWeaponTime2", 0) < SysTime() then 
				local randweapon = table.Random(hightierwepslist)
				ply:Give(randweapon, true)
				ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
				ply:SetNWInt("igRandomWeaponTime2", math.Round(SysTime(), 0) + 300 )
			else
				ply:ChatPrint("Your random weapon is still on cooldown!")
			end
		end
	end)