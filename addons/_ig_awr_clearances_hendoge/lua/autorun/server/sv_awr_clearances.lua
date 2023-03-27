util.AddNetworkString("awrc_OpenInterface")
util.AddNetworkString("awrc_AddNewUser")
util.AddNetworkString("awrc_AddOfflineUser")
util.AddNetworkString("awrc_RemoveUser")
util.AddNetworkString("awrc_MessageClient")

local authorisedUsers = {}
authorisedUsers["STEAM_0:0:71575572"] = true
authorisedUsers["STEAM_0:0:521116828"] = true


hook.Add("IGPlayerSay", "awrc_OpenInterfaceCommand", function (ply, txt)
	if (txt == "!awrc" && (ply:IsSuperAdmin() or authorisedUsers[ply:SteamID()])) then
		SendInterfaceData(ply)
		return ""
	end
end)

net.Receive("awrc_AddNewUser", function (len, ply)
	if (ply:IsSuperAdmin() or authorisedUsers[ply:SteamID()]) then
		local targetUserID = net.ReadString()
		local targetPlayer = player.GetBySteamID(targetUserID)
		if (targetPlayer) then
			data = {
				[targetUserID] = {
					addedBy = ply:Nick() .. " - " .. ply:SteamID(), 
					name = targetPlayer:Nick()
				}
			}
			SaveNewAwrUsers(data, ply)
			SendInterfaceData(ply)
		else
			AwrMessageClient(ply, "Data not saved. Please ensure you have entered a valid user.")
		end
	end
end)

net.Receive("awrc_RemoveUser", function (len, ply)
	if (ply:IsSuperAdmin() or authorisedUsers[ply:SteamID()]) then
		local targetUserID = net.ReadString()
		RemoveAwrUser(targetUserID, ply)
		SendInterfaceData(ply)
	end
end)

net.Receive("awrc_AddOfflineUser", function (len, ply)
	if (ply:IsSuperAdmin() or authorisedUsers[ply:SteamID()]) then
		local targetName = net.ReadString()
		local targetUserID = net.ReadString()

		if (targetName && targetUserID) then
			data = {
				[string.Trim(targetUserID)] = {
					addedBy = ply:Nick() .. " - " .. ply:SteamID(), 
					name = targetName
				}
			}
			SaveNewAwrUsers(data, ply)
			SendInterfaceData(ply)
		else 
			AwrMessageClient(ply, "Data not saved. Please ensure you have entered a Steam ID and Name.")
		end
	end
end)

-- Checks the desired directory exists in the data foilder, creates it if not
function CheckAwrDir ()
	if (not file.IsDir("awr_clearances", "DATA")) then
		file.CreateDir("awr_clearances")
	end
end

-- Writes to the AWR Personnel file. Takes in a table
function WriteToAwrFile (data)
	CheckAwrDir()
	print("[AWR CLEARANCES] WriteToAwrFile() parsed data is as follows: ")
	PrintTable(data)
	local finalData = util.TableToJSON(data, true)
	file.Write("awr_clearances/awr_personnel.txt", finalData)
end

-- Reads the AWR personnel file, returning it or "-1" in the case of file not found
function ReadAwrFile ()
	if (file.Exists("awr_clearances/awr_personnel.txt", "DATA")) then
		local awrUsers = util.JSONToTable(file.Read("awr_clearances/awr_personnel.txt", "DATA"))
		if (not awrUsers or table.IsEmpty(awrUsers)) then
			print("[AWR CLEARANCES] Something went wrong trying to load awr_personnel.txt. Tell HenDoge because the file just got wiped.")
			return {error = "An error occured trying to load awr_personnel.txt."}
		end
		--return util.JSONToTable(file.Read("awr_clearances/awr_personnel.txt", "DATA"))
		return awrUsers
	else
		return {error = "File Not Found"} -- File not found
	end
end

-- Saves the new AWR Authorised Users. Takes in a table
function SaveNewAwrUsers (newValues, ply)
	local currentValues = ReadAwrFile()

	-- Check for being parsed an empty table or a duplicate value
	if (table.IsEmpty(newValues) or currentValues[table.GetKeys(newValues)[1]]) then 
		--print("[AWR Clearances] Bad or duplicate data sent to SaveNewAwrUser.")
		AwrMessageClient(ply, "Bad or duplicate data sent to the server. Please try again.")
		return
	end

	if (currentValues["error"] or table.IsEmpty(currentValues)) then
		WriteToAwrFile(newValues)
	elseif (not currentValues[target]) then
		for k, v in pairs(newValues) do
			currentValues[k] = v
		end

		WriteToAwrFile(currentValues)
	end
	AwrMessageClient(ply, "Added user '" .. newValues[table.GetFirstKey(newValues)].name .. "'' to the AWR Clearance list.")
end 

-- Removes a user from the AWR Clearances file
function RemoveAwrUser (target, ply)
	local currentValues = ReadAwrFile()
	if currentValues["error"] or table.IsEmpty(currentValues) or not currentValues[target] then return end
	local targetPlayer = currentValues[target].name
	currentValues[target] = nil
	WriteToAwrFile(currentValues)
	AwrMessageClient(ply, "User '" .. targetPlayer .. "'' has been removed from the AWR Clearance list.")
end

-- Sends all requied data to the client when they open the interface
function SendInterfaceData (ply)
	net.Start("awrc_OpenInterface")
	net.WriteTable(ReadAwrFile())
	net.Send(ply)
end

function AwrMessageClient (ply, msg)
	net.Start("awrc_MessageClient")
	net.WriteString(msg)
	net.Send(ply)
end