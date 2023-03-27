-- Network Strings
	util.AddNetworkString("IG_EXTRAC_INIT_SPAWN")
	util.AddNetworkString("IG_EXTRAC_ADMIN")
	util.AddNetworkString("IG_EXTRAC_ADMIN_ADD")
	util.AddNetworkString("IG_EXTRAC_ADMIN_ADD_OFFLINE")
	util.AddNetworkString("IG_EXTRAC_SELECT")
	util.AddNetworkString("IG_EXTRAC_CHAT")

-- Admin Menu
	hook.Add("PlayerSay", "IG_Character_Admin", function( ply, text )
		if string.lower(text) == "!characteradmin" then
			if ply:IsSuperAdmin() or ply:GetUserGroup() == "Admin" then
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("Opening character admin menu...")
				net.Send(ply)
				net.Start("IG_EXTRAC_ADMIN")
					net.WriteTable(IG_CHARACTER_PURCHASED)
				net.Send(ply)
				return ""
			else
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("You do not have permission for this command.")
				net.Send(ply)
				return ""
			end
		end
	end)
-- Player Select
	hook.Add("PlayerSay", "IG_Character_Command", function( ply, text )
		if string.lower(text) == "!character" or string.lower(text) == "!char" then
			local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..ply:SteamID64()..".txt", "DATA"))
			if playerdata["Second"]["Owned"] == true then
				if ply:IsAOS() then
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("You are AOS'd")
					net.Send(ply)
				else
					if ply:IsHandcuffed() then
						net.Start("IG_EXTRAC_CHAT")
							net.WriteString("You are in cuffs")
						net.Send(ply)
					else
						if playerdata["First"]["Active"] == true then
							playerdata["First"]["Regiment"] = ply:GetRegiment()
							playerdata["First"]["Rank"] = ply:GetRankName()
							playerdata["First"]["Name"] = ply:Nick()
							playerdata["First"]["Model"] = ply:GetJobTable().Model
							playerdata["First"]["RankNumber"] = ply:GetRank()
					    elseif playerdata["Second"]["Active"] == true then
					    	playerdata["Second"]["Regiment"] = ply:GetRegiment()
							playerdata["Second"]["Rank"] = ply:GetRankName()
							playerdata["Second"]["Name"] = ply:Nick()
							playerdata["Second"]["Model"] = ply:GetJobTable().Model
							playerdata["Second"]["RankNumber"] = ply:GetRank()
					    end
					    file.Write("ig_character_v1/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
						net.Start("IG_EXTRAC_INIT_SPAWN")
							net.WriteTable(playerdata)
						net.Send(ply)
						net.Start("IG_EXTRAC_CHAT")
							net.WriteString("Opening character menu...")
						net.Send(ply)
					end
				end
			else
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("You don't have a second character")
				net.Send(ply)
			end
			return ""
		end
	end)

--Init Spawn
	hook.Add("PlayerInitialSpawn", "IG_Character_Init", function( ply )
		if not file.Exists("ig_character_v1/data/player/"..ply:SteamID64()..".txt", "DATA") then
			local playerdata = {
				["First"] = {
					["Active"] = true,
					["Regiment"] = ply:GetRegiment(),
					["Rank"] = ply:GetRankName(),
					["Name"] = ply:Nick(),
					["Model"] = ply:GetJobTable().Model,
					["RankNumber"] = ply:GetRank(),
				},
				["Second"] = {
					["Active"] = false,
					["Owned"] = false,
					["Regiment"] = "439th Stormtroopers",
					["Rank"] = "Private",
					["Name"] = ply:OldNick(),
					["Model"] = TeamTable["439th Stormtroopers"][1].Model,
					["RankNumber"] = 1,
				}
			}
			file.Write("ig_character_v1/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
			print("[IG CHARACTER] Creating Data file for: "..ply:Nick())
		end
		local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..ply:SteamID64()..".txt", "DATA"))
		IG_CHARACTER_PURCHASED[ply:SteamID()] = playerdata["Second"]["Owned"]
	end)
-- Disconnect update
	hook.Add( "PlayerDisconnected", "IG_Character_Leave", function(ply)
	    local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..ply:SteamID64()..".txt", "DATA"))
	    if playerdata["First"]["Active"] == true then
			playerdata["First"]["Regiment"] = ply:GetRegiment()
			playerdata["First"]["Rank"] = ply:GetRankName()
			playerdata["First"]["Name"] = ply:Nick()
			playerdata["First"]["Model"] = ply:GetJobTable().Model
			playerdata["First"]["RankNumber"] = ply:GetRank()
	    elseif playerdata["Second"]["Active"] == true then
	    	playerdata["Second"]["Regiment"] = ply:GetRegiment()
			playerdata["Second"]["Rank"] = ply:GetRankName()
			playerdata["Second"]["Name"] = ply:Nick()
			playerdata["Second"]["Model"] = ply:GetJobTable().Model
			playerdata["Second"]["RankNumber"] = ply:GetRank()
	    end
	    file.Write("ig_character_v1/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
	    print("[IG CHARACTER] Updating data for: "..ply:Nick())
	end )

-- Select Function
	net.Receive("IG_EXTRAC_SELECT", function(len, ply)
		local slot = net.ReadString()
		local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..ply:SteamID64()..".txt", "DATA"))
		if slot == "1" then
			if playerdata["First"]["Active"] == true then
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("Character already selected...")
				net.Send(ply)
			else
				playerdata["First"]["Active"] = true
				playerdata["Second"]["Active"] = false
				ply:SetRegiment(playerdata["First"]["Regiment"])
				ply:SetRank(playerdata["First"]["RankNumber"])
				ply:SetPlayerName(playerdata["First"]["Name"])
				ply:SetModel(ply:GetJobTable().Model)
				ply:Kill()
				ply:Spawn()
				SimpleXPSetXP(ply,SimpleXPGetXP(ply) + 1000)
				file.Write("ig_character_v1/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
				ply:SendLua("RunConsoleCommand('simple_thirdperson_enabled','0')")
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("Changing to: "..playerdata["Second"]["Name"])
				net.Send(ply)
			end
		elseif slot == "2" then
			if playerdata["Second"]["Owned"] == true then
				if playerdata["Second"]["Active"] == true then
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Character already selected...")
					net.Send(ply)
				else
					playerdata["Second"]["Active"] = true
					playerdata["First"]["Active"] = false
					ply:SetRegiment(playerdata["Second"]["Regiment"])
					ply:SetRank(playerdata["Second"]["RankNumber"])
					ply:SetPlayerName(playerdata["Second"]["Name"])
					ply:SetModel(ply:GetJobTable().Model)
					ply:Kill()
					ply:Spawn()
					SimpleXPSetXP(ply,SimpleXPGetXP(ply) + 1000)
					file.Write("ig_character_v1/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerdata,true))
					ply:SendLua("RunConsoleCommand('simple_thirdperson_enabled','0')")
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Changing to: "..playerdata["Second"]["Name"])
					net.Send(ply)
				end
			else
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("Don't have access to this...")
				net.Send(ply)
			end
		end

	end)

-- Add Function
	net.Receive("IG_EXTRAC_ADMIN_ADD", function(len, ply)
		local targetSID = net.ReadString()
		local targetSID64 = net.ReadString()
		local action = ""
		if ply:IsSuperAdmin() or ply:GetUserGroup() == "Admin" then
			if file.Exists("ig_character_v1/data/player/"..targetSID64..".txt", "DATA") then
				local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..targetSID64..".txt", "DATA"))
				if playerdata["Second"]["Owned"] == false then
					playerdata["Second"]["Owned"] = true
					action = "added"
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Added second character to: "..targetSID)
					net.Send(ply)
				elseif playerdata["Second"]["Owned"] == true then
					playerdata["Second"]["Owned"] = false
					action = "removed"
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Removed second character to: "..targetSID)
					net.Send(ply)
				end
				file.Write("ig_character_v1/data/player/"..targetSID64..".txt", util.TableToJSON(playerdata,true))
				IG_CHARACTER_PURCHASED[targetSID] = playerdata["Second"]["Owned"]
				local logtable = util.JSONToTable(file.Read("ig_character_v1/data/log.txt", "DATA"))
				local Timestamp = os.time()
				local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
				local Stringinsert = TimeString.." | "..ply:Nick().."/"..ply:OldNick().. " | ".. action .. " " .. targetSID.." ("..targetSID64..")"
				print(Stringinsert)
				table.insert(logtable, Stringinsert)
				file.Write("ig_character_v1/data/log.txt", util.TableToJSON(logtable,true))
			end
		end
	end)

-- Add Offline Function
	net.Receive("IG_EXTRAC_ADMIN_ADD_OFFLINE", function(len, ply)
		local targetSID64 = net.ReadString()
		local action = ""
		if ply:IsSuperAdmin() or ply:GetUserGroup() == "Admin" then
			if file.Exists("ig_character_v1/data/player/"..targetSID64..".txt", "DATA") then
				local playerdata = util.JSONToTable(file.Read("ig_character_v1/data/player/"..targetSID64..".txt", "DATA"))
				if playerdata["Second"]["Owned"] == false then
					playerdata["Second"]["Owned"] = true
					action = "added"
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Added second character to: "..targetSID64)
					net.Send(ply)
				elseif playerdata["Second"]["Owned"] == true then
					playerdata["Second"]["Owned"] = false
					action = "removed"
					net.Start("IG_EXTRAC_CHAT")
						net.WriteString("Removed second character to: "..targetSID64)
					net.Send(ply)
				end
				file.Write("ig_character_v1/data/player/"..targetSID64..".txt", util.TableToJSON(playerdata,true))
				local logtable = util.JSONToTable(file.Read("ig_character_v1/data/log.txt", "DATA"))
				local Timestamp = os.time()
				local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
				local Stringinsert = TimeString.." | "..ply:Nick().."/"..ply:OldNick().. " | ".. action .. " " .. targetSID
				print(Stringinsert)
				table.insert(logtable, Stringinsert)
				file.Write("ig_character_v1/data/log.txt", util.TableToJSON(logtable,true))
			else
				net.Start("IG_EXTRAC_CHAT")
					net.WriteString("Could not find data file for: "..targetSID64)
				net.Send(ply)
			end
		end
	end)