AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("igSquadMenu")
util.AddNetworkString("igSquadMenuSelect")
util.AddNetworkString("igSquadMenuEdit")
util.AddNetworkString("igSquadMenuPurchase")

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
		if table.HasValue(bypassjobs, caller:GetRegiment()) then
			caller:PrintMessage( HUD_PRINTTALK, "You don't have permission to use this." )
		else
			local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
			local current = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..caller:SteamID64()..".txt", "DATA"))
			local weps = {
				primary = {},
				secondary = {},
				spec = {}
			}
			local reginum = 0

			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), caller:GetRegiment()) then
					reginum = k
				end
			end
			weps.primary = import[reginum][caller:GetRegiment()]["Main"]["Primary"]
			weps.secondary = import[reginum][caller:GetRegiment()]["Main"]["Secondary"]
			weps.spec = import[reginum][caller:GetRegiment()]["Main"]["Specialist"]

			if caller:GetJobTable().Clearance == "1" then

			elseif caller:GetJobTable().Clearance == "2" then
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(weps.spec, v)
				end
			elseif caller:GetJobTable().Clearance == "3" then
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(weps.spec, v)
				end
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL3"]) do
					table.insert(weps.spec, v)
				end
			elseif caller:GetJobTable().Clearance == "4" or "5" or "6" or "ALL ACCESS" then
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL2"]) do
					table.insert(weps.spec, v)
				end
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL3"]) do
					table.insert(weps.spec, v)
				end
				for k,v in pairs(import[reginum][caller:GetRegiment()]["Clearance"]["CL4"]) do
					table.insert(weps.spec, v)
				end
			end

			// Pointshop Shit - A very dumb but decent solution :)
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

				for k,v in pairs(caller:SH_GetInventory()) do
					if v["class"] == "bhp100" or v["class"] == "dhp200" or v["class"] == "fhp300"then else
						if table.HasValue(primfiles, v["class"]) or v["class"] == "dualse14c" then
							table.insert(weps.primary, primaryClassMappings[v["class"]])
						elseif table.HasValue(secfiles, v["class"]) then
							table.insert(weps.secondary, secondaryClassMappings[v["class"]])
						elseif table.HasValue(specfiles, v["class"]) then
							table.insert(weps.spec, specialtiesClassMappings[v["class"]])
						elseif v["class"] == "iqa11" then
							table.insert(weps.spec, specialtiesClassMappings[v["class"]])
						elseif table.HasValue(donfiles, v["class"]) then
							table.insert(weps.primary, donatorClassMappings[v["class"]])
						elseif table.HasValue(specialfiles, v["class"]) then
							table.insert(weps.spec, specialClassMappings[v["class"]])
						end
					end
				end

			net.Start("igSquadMenu")
				net.WriteTable(weps)
				net.WriteTable(current)
			net.Send(caller)
		end
	end
end

net.Receive("igSquadMenuSelect", function(len, ply)
	local slot = net.ReadString()
	local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA"))
	local ig_errorcode = ""
	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
--    		ply:SH_AddStandardPoints(-500, "You have spent 500 Points swapping loadouts", false, false)
			ply:SH_AddPremiumPoints(-500, "You have spent 500 Credits swapping loadouts", false, false)
			if slot == "1" and playerloadout["First"]["Purchased"] == true then
				playerloadout["First"]["Active"] = true
				playerloadout["Second"]["Active"] = false
				playerloadout["Third"]["Active"] = false
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
			elseif slot == "2" and playerloadout["Second"]["Purchased"] == true then
				playerloadout["First"]["Active"] = false
				playerloadout["Second"]["Active"] = true
				playerloadout["Third"]["Active"] = false
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
			elseif slot == "3" and playerloadout["Third"]["Purchased"] == true then
				playerloadout["First"]["Active"] = false
				playerloadout["Second"]["Active"] = false
				playerloadout["Third"]["Active"] = true
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
			end
			GiveFullLoadout(ply)
		else
			ig_errorcode = "02"
    	end
    end
    if not ig_errorcode == "" then
    	GiveError(ply, ig_errorcode)
    end
end)

net.Receive("igSquadMenuEdit", function(len, ply)
	local slot = net.ReadString()
	local weapontable = net.ReadTable()
	local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA"))
	local ig_errorcode = ""

	-- Security Check Stuff
		local import = util.JSONToTable(file.Read("ig_dynamic_loadout/loadouts/regiment_loadouts.txt", "DATA"))
		local weps = {
			primary = {},
			secondary = {},
			spec = {}
		}
		local reginum = 0

		for k,v in pairs(import) do
			if table.HasValue(table.GetKeys(import[k]), ply:GetRegiment()) then
				reginum = k
			end
		end
		weps.primary = import[reginum][ply:GetRegiment()]["Main"]["Primary"]
		weps.secondary = import[reginum][ply:GetRegiment()]["Main"]["Secondary"]
		weps.spec = import[reginum][ply:GetRegiment()]["Main"]["Specialist"]

		if ply:GetJobTable().Clearance == "1" then

		elseif ply:GetJobTable().Clearance == "2" then
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				table.insert(weps.spec, v)
			end
		elseif ply:GetJobTable().Clearance == "3" then
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				table.insert(weps.spec, v)
			end
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
				table.insert(weps.spec, v)
			end
		elseif ply:GetJobTable().Clearance == "4" or "5" or "6" or "ALL ACCESS" then
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL2"]) do
				table.insert(weps.spec, v)
			end
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL3"]) do
				table.insert(weps.spec, v)
			end
			for k,v in pairs(import[reginum][ply:GetRegiment()]["Clearance"]["CL4"]) do
				table.insert(weps.spec, v)
			end
		end

		// Pointshop Shit - A very dumb but decent solution :)
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
						table.insert(weps.primary, primaryClassMappings[v["class"]])
					elseif table.HasValue(secfiles, v["class"]) then
						table.insert(weps.secondary, secondaryClassMappings[v["class"]])
					elseif table.HasValue(specfiles, v["class"]) then
						table.insert(weps.spec, specialtiesClassMappings[v["class"]])
					elseif v["class"] == "iqa11" then
						table.insert(weps.spec, specialtiesClassMappings[v["class"]])
					elseif table.HasValue(donfiles, v["class"]) then
						table.insert(weps.primary, donatorClassMappings[v["class"]])
					elseif table.HasValue(specialfiles, v["class"]) then
						table.insert(weps.spec, specialClassMappings[v["class"]])
					end
				end
			end

	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
			if slot == "1" and playerloadout["First"]["Purchased"] == true then
				if table.HasValue(weps.primary, weapontable["Primary"]) or weapontable["Primary"] == "" then
					if table.HasValue(weps.secondary, weapontable["Secondary"]) or weapontable["Secondary"] == "" then
						if table.HasValue(weps.spec, weapontable["Spec"]) or weapontable["Spec"] == "" then
							playerloadout["First"]["Regiment"] = ply:GetRegiment()
							playerloadout["First"]["Loadout"]["Primary"] = weapontable["Primary"]
							playerloadout["First"]["Loadout"]["Secondary"] = weapontable["Secondary"]
							playerloadout["First"]["Loadout"]["Spec"] = weapontable["Spec"]
							file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
							ply:PrintMessage( HUD_PRINTTALK, "Creating Loadout..." )
							ply:PrintMessage( HUD_PRINTTALK, "Primary: "..weapontable["Primary"])
							ply:PrintMessage( HUD_PRINTTALK, "Secondary: "..weapontable["Secondary"] )
							ply:PrintMessage( HUD_PRINTTALK, "Specialist: "..weapontable["Spec"] )
							if playerloadout["First"]["Active"] == true then
								ply:PrintMessage( HUD_PRINTTALK, "Giving new loadout...")
								GiveFullLoadout(ply)
							end
						else
							local errorcode = "03c"
							GiveError(ply, errorcode)
						end
					else
						local errorcode = "03b"
						GiveError(ply, errorcode)
					end
				else
					local errorcode = "03a"
					GiveError(ply, errorcode)
				end
			elseif slot == "2" and playerloadout["Second"]["Purchased"] == true then
				if table.HasValue(weps.primary, weapontable["Primary"]) or weapontable["Primary"] == "" then
					if table.HasValue(weps.secondary, weapontable["Secondary"]) or weapontable["Secondary"] == "" then
						if table.HasValue(weps.spec, weapontable["Spec"]) or weapontable["Spec"] == "" then
							playerloadout["Second"]["Regiment"] = ply:GetRegiment()
							playerloadout["Second"]["Loadout"]["Primary"] = weapontable["Primary"]
							playerloadout["Second"]["Loadout"]["Secondary"] = weapontable["Secondary"]
							playerloadout["Second"]["Loadout"]["Spec"] = weapontable["Spec"]
							file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
							ply:PrintMessage( HUD_PRINTTALK, "Creating Loadout..." )
							ply:PrintMessage( HUD_PRINTTALK, "Primary: "..weapontable["Primary"])
							ply:PrintMessage( HUD_PRINTTALK, "Secondary: "..weapontable["Secondary"] )
							ply:PrintMessage( HUD_PRINTTALK, "Specialist: "..weapontable["Spec"] )
							if playerloadout["Second"]["Active"] == true then
								ply:PrintMessage( HUD_PRINTTALK, "Giving new loadout...")
								GiveFullLoadout(ply)
							end
						end
					end
				end
			elseif slot == "3" and playerloadout["Third"]["Purchased"] == true then
				if table.HasValue(weps.primary, weapontable["Primary"]) or weapontable["Primary"] == "" then
					if table.HasValue(weps.secondary, weapontable["Secondary"]) or weapontable["Secondary"] == "" then
						if table.HasValue(weps.spec, weapontable["Spec"]) or weapontable["Spec"] == "" then
							playerloadout["Third"]["Regiment"] = ply:GetRegiment()
							playerloadout["Third"]["Loadout"]["Primary"] = weapontable["Primary"]
							playerloadout["Third"]["Loadout"]["Secondary"] = weapontable["Secondary"]
							playerloadout["Third"]["Loadout"]["Spec"] = weapontable["Spec"]
							file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
							ply:PrintMessage( HUD_PRINTTALK, "Creating Loadout..." )
							ply:PrintMessage( HUD_PRINTTALK, "Primary: "..weapontable["Primary"])
							ply:PrintMessage( HUD_PRINTTALK, "Secondary: "..weapontable["Secondary"] )
							ply:PrintMessage( HUD_PRINTTALK, "Specialist: "..weapontable["Spec"] )
							if playerloadout["Third"]["Active"] == true then
								ply:PrintMessage( HUD_PRINTTALK, "Giving new loadout...")
								GiveFullLoadout(ply)
							end
						end
					end
				end
			end
		else
			errorcode = "02"
		end
	end
	if not ig_errorcode == "" then
    	GiveError(ply, ig_errorcode)
    end
end)

net.Receive("igSquadMenuPurchase", function(len, ply)
	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
			local slot = net.ReadString()
			local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", "DATA"))
			local savefilewrite = {
					["Slot"] = slot,
					["SteamID64"] = ply:SteamID64(),
					["SteamID"] = ply:SteamID(),
					["Time"] = os.date("%H:%M:%S - %d/%m/%Y",os.time()),
				}
			file.Write("ig_dynamic_loadout/playerdata/purchases/"..ply:SteamID64().."_slot_"..slot..".txt", util.TableToJSON(savefilewrite))
			if slot == "1" then
				playerloadout["First"]["Purchased"] = true
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
			elseif slot == "2" and ply:SH_CanAffordPremium(10000) then
				playerloadout["Second"]["Purchased"] = true
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
				ply:SH_AddPremiumPoints(-10000, "You have spent 10,000 Credits purchasing the second loadout slot", false, false)
			elseif slot == "3" and ply:SH_CanAffordPremium(50000) then
				playerloadout["Third"]["Purchased"] = true
				file.Write("ig_dynamic_loadout/playerdata/loadouts/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout))
				ply:SH_AddPremiumPoints(-50000, "You have spent 50,000 Credits purchasing the second loadout slot", false, false)
			else
				local errorcode = "04"
				GiveError(ply, errorcode)
			end
		else
			local errorcode = "02"
			GiveError(ply, errorcode)
		end
	end
end)
