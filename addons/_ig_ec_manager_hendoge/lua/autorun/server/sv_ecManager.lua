util.AddNetworkString("ecm_openDerma")
util.AddNetworkString("ecm_addClientChatMessage")
util.AddNetworkString("ecm_sendDataToServer")
util.AddNetworkString("ecm_loadPreset")
util.AddNetworkString("ecm_getCurrentValues")
util.AddNetworkString("ecm_updatePresetList")
util.AddNetworkString("ecm_deletePreset")
util.AddNetworkString("ecm_getPresetByName")
util.AddNetworkString("ecm_updatePreset")

--------------------------------------------------------- HOOKS -------------------------------------------------------
 -- Handle Chat Commands
hook.Add("PlayerSay", "hanldeECMCommands", function(ply, txt)
	if (ply:IsEventMaster() or ply:IsAdmin()) then
		textTable = string.Explode(" ", string.lower(txt))
		
		if (textTable[1] == "!ecm") then
			if (textTable[2] == "off") then -- if command is "!ecm off" then stop laoding EC presets 
				ResetEcPresetVals()
				AddClientChatMessage(ply, "EC Values Reset. EC's will now spawn as they are setup defaultly.")
				return ""
			else -- otherwise open the interface
				net.Start("ecm_openDerma")
				net.WriteTable(GetAllEcPresets() or nil)
				net.WriteTable(util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data")) or nil)
				net.Send(ply)
				return ""
			end

		elseif (textTable[1] == "!ecspawn") then -- Handle Setting and Resetting Spawnpoint
			if (textTable[2] == "set") then
				SetEcSpawnPoint(ply:GetPos())
				AddClientChatMessage(ply, "EC Spawn Point set to your current position.")
				return ""
			elseif (textTable[2] == "reset") then
				SetEcSpawnPoint(-1)
				AddClientChatMessage(ply, "EC Spawn Point reset.")
				return ""
			end

		end
	end
end)

-- Handle spawning of EC
hook.Add("PlayerSpawn", "handleECMSpawns", function (ply)
	if (ply:GetRegiment() == "Event") then
		SpawnEc(ply)
	end
end)

----------------------------------------------------- NET MESSAGES ----------------------------------------------------
-- Get EC data sent from the client
net.Receive("ecm_sendDataToServer", function (len, ply)
	local failed = false

	local presetToSave = {}
	presetToSave["author"] = ""
	presetToSave["authorID"] = ""
	presetToSave["presetName"] = ""
	presetToSave["ecModels"] = ""
	presetToSave["ecWeapons"] = ""
	presetToSave["ecHealth"] = 0
	presetToSave["ecSpawn"] = "-1"

	if (ply:IsAdmin()) then -- Update to work with Super Admins, EM's and Devs
		local data = net.ReadTable()

		presetToSave["presetName"] = data[1]
		presetToSave["author"] = ply:Nick()
		presetToSave["authorID"] = ply:SteamID()

		if ValidateEcClientData(data) then
			if (ExtractEcModelSet(data[2]) ~= false) then
				presetToSave["ecModels"] = ExtractEcModelSet(data[2])
			else
				AddClientChatMessage(ply, "Bad models sent to server. Your preset has not been saved.")
				failed = true
			end

			presetToSave["ecWeapons"] = ExtractEcWeaponSet(data[3])

			if (isnumber(tonumber(data[4]))) then
				presetToSave["ecHealth"] = tonumber(data[4])
			else
				AddClientChatMessage(ply, "Bad health sent to server. Your preset has not been saved.")
				failed = true
			end
		else
			AddClientChatMessage(ply, "Bad data sent to server. Esure that you have filled out all fields.")
			failed = true
		end

		if(not failed) then
			SavePresetToJSON(ply, presetToSave)
		end

	end
end)

net.Receive("ecm_loadPreset", function (len, ply)
	local ecPreset = net.ReadString()
	if (ply:IsAdmin() || ply:IsEventMaster()) then
		SetEcValues(LoadEcPreset(ecPreset, ply))
		SendCurrentValuesToClient(ply)
	end
end)

net.Receive("ecm_getCurrentValues", function (len, ply)
	if (ply:IsAdmin() || ply:IsEventMaster()) then
		SendCurrentValuesToClient (ply)
	end
end)

net.Receive("ecm_updatePresetList", function (len, ply)
	if (ply:IsAdmin() || ply:IsEventMaster()) then
		SendUpdatedPresetList(ply)
	end
end)

net.Receive("ecm_deletePreset", function (len, ply)
	local presetName = net.ReadString()
	if (ply:IsAdmin() || ply:IsEventMaster()) then
		DeleteECPreset(ply, presetName)
	end
end)

net.Receive("ecm_getPresetByName", function (len, ply)
	local presetName = net.ReadString()
	if (ply:IsAdmin() || ply:IsEventMaster()) then
		if (file.Exists("ecmanager/presets/" .. presetName, "data")) then
			local presetData = util.JSONToTable(file.Read("ecmanager/presets/" .. presetName, "data"))
			net.Start("ecm_getPresetByName")
			net.WriteTable(presetData)
			net.Send(ply)
		else
			AddClientChatMessage(ply, "Something went wrong trying to view your preset. File not found.")
		end
	end
end)

net.Receive("ecm_updatePreset", function (len, ply)
	local fileName = net.ReadString()
	local updatedValues = net.ReadTable()
	if ((ply:IsAdmin() || ply:IsEventMaster()) && ValidateEcClientData(updatedValues)) then -- update to work with EM's, Super Admins and Devs
		UpdatePreset(ply, fileName, updatedValues)
	else
		AddClientChatMessage(ply, "Bad data sent to the server. Your preset has not been updated.")
	end
end)

------------------------------------------------------- FUNCTIONS -----------------------------------------------------
-- Add a message to the clients chat
function AddClientChatMessage (ply, msg)
	net.Start("ecm_addClientChatMessage")
	net.WriteString(msg)
	net.Send(ply)
end

-- Loops through a given table and ensures that no empty data is entered
function ValidateEcClientData (data)
	for k, v in pairs (data) do
		if (v == "") then
			return false
		end
	end
	return true
end

-- Goes through a string and converts it to a set of models
function ExtractEcModelSet (str)
	local modelSetEc = string.Explode("\n", str)
	local sanitizedModels = {}

	for k, v in pairs (modelSetEc) do
		if (util.IsValidModel(v)) then
			table.insert(sanitizedModels, v)
		end
	end
	
	if (table.IsEmpty(sanitizedModels)) then
		return false
	else
		return sanitizedModels
	end
end

--Goes through a string and extracts out a set of weapons
function ExtractEcWeaponSet (str)
	local ecWeaponsTable = string.Explode("\n", str)
	local sanitizedWeapons = {}

	for k, v in pairs (ecWeaponsTable) do
		if (v ~= "" && v ~= " ") then
			table.insert(sanitizedWeapons, v)
		end
	end

	if (table.IsEmpty(sanitizedWeapons)) then
		return false
	else
		return sanitizedWeapons
	end
end

-- Saves an EC Preset to the server
function SavePresetToJSON (ply, vals)
	-- Check if a file of the name already exists, exiting if it does. If not, save the preset.
	if (file.Exists("ecmanager/presets/" .. vals["presetName"] .. ".txt", "data")) then
		AddClientChatMessage(ply, "Unable to save your preset. You've used the same filename as a preset that's already saved.")
	else
		file.Write("ecmanager/presets/" .. vals["presetName"] .. ".txt", util.TableToJSON(vals, true))
			-- Check the file saved
		if (file.Exists("ecmanager/presets/" .. vals["presetName"] .. ".txt", "data")) then
			AddClientChatMessage(ply, "Your preset '" .. vals["presetName"] .. "' has been saved successfully")
		end
	end
end

-- Sets the values to be loaded on EC spawn
function SetEcValues (newValues)
	local currentValues = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))
	newValues["ecSpawn"] = currentValues["ecSpawn"]
	file.Write("ecmanager/ecdata.txt", util.TableToJSON(newValues))
end

-- Gets a list of file names for all saved presets
function GetAllEcPresets ()
	local files, directories = file.Find("ecmanager/presets/*.txt", "data")
	return files
end

-- Gets the data for a specific EC presets
function LoadEcPreset (ecPreset, ply)
	if (file.Exists("ecmanager/presets/" .. ecPreset, "data")) then
		AddClientChatMessage(ply, "Your preset '" .. ecPreset .. "' has been loaded.")
		return util.JSONToTable(file.Read("ecmanager/presets/" .. ecPreset, "data"))
	else
		AddClientChatMessage(ply, "Unable to load preset. File not found.")
	end
end

-- Saves the value of an EC Spawn Point. Parse the string "-1" to reset
function SetEcSpawnPoint (pos)
	if (file.Exists("ecmanager/ecdata.txt", "data")) then
		local fileData = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))
		fileData["ecSpawn"] = pos
		file.Write("ecmanager/ecdata.txt", util.TableToJSON(fileData))
	end
end

-- Handles the spawning of EC's
function SpawnEc (ply)
	if (file.Exists("ecmanager/ecdata.txt", "data")) then
		local fileData = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))

		if (fileData["presetName"] ~= "") then
			timer.Create("ecSpawnTimer"..ply:SteamID(), 1, 1, function()
                AddClientChatMessage(ply, "Setting your loadout.")
				ply:StripWeapons()

				-- Set Health()
				ply:SetHealth(fileData["ecHealth"])
				ply:SetMaxHealth(fileData["ecHealth"])

				-- Set Model
				local model = fileData["ecModels"][math.random(1, #fileData["ecModels"])]
				ply:SetModel(model)

				-- Set Weapons
				for k, v in pairs(fileData["ecWeapons"]) do
					ply:Give(v)
				end

				-- Set Spawn
				if (isvector(fileData["ecSpawn"])) then
					ply:SetPos(Vector(fileData["ecSpawn"]))
				end
			end)
		end
	end
end

-- Sets all current EC Values to be blank, meaning that no values will be loaded when the next EC spawns
function ResetEcPresetVals ()
	local fileData = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))

	for k, v in pairs (fileData) do
		fileData[k] = ""
	end
	fileData["ecModels"] = {}
	fileData["ecWeapons"] = {}

	SetEcValues(fileData)
end

-- Sends the values that are currently being applied to all EC's to a specified client
function SendCurrentValuesToClient (ply)
	local fileData = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))
	net.Start("ecm_getCurrentValues")
	net.WriteTable(fileData)
	net.Send(ply)
end

-- Sends an updated list of EC presets to a specified client
function SendUpdatedPresetList (ply)
	net.Start("ecm_updatePresetList")
	net.WriteTable(GetAllEcPresets())
	net.Send(ply)
end

-- Delete a given preset if the passed player is the author or admin/developer/SEM+
function DeleteECPreset (ply, presetName)
	if (file.Exists("ecmanager/presets/" .. presetName, "data")) then
		local fileData = util.JSONToTable(file.Read("ecmanager/presets/" .. presetName, "data")) -- We need to to check if the caller is the preset author
		local currentPreset = util.JSONToTable(file.Read("ecmanager/ecdata.txt", "data"))

		if (fileData["presetName"] ~= currentPreset["presetName"] && (fileData["authorID"] == ply:SteamID() || ply:IsSuperAdmin() || ply:SteamID() == "STEAM_0:1:46112709")) then
			file.Delete("ecmanager/presets/" .. presetName, "data")
			AddClientChatMessage(ply, "The preset '" .. presetName .. "' has been deleted.")
			SendUpdatedPresetList(ply)
		else
			AddClientChatMessage(ply, "You do not have permission to delete that preset or it is currently loaded.")
		end
	else
		AddClientChatMessage(ply, "Preset '" .. presetName .. "' not found.")
	end
end

function UpdatePreset (ply, fileName, newData)
	if (file.Exists("ecmanager/presets/" .. fileName, "data")) then
		local currentData = util.JSONToTable(file.Read("ecmanager/presets/" .. fileName, "data"))

                                                                                         
		if (ply:IsSuperAdmin() || currentData["authorID"] == ply:SteamID() || ply:SteamID() == "STEAM_0:1:46112709") then  -- HenDoge's Steam ID. Delete if I'm not dev anymore

			currentData["ecModels"] = ExtractEcModelSet(newData["ecModels"])

			currentData["ecWeapons"] = ExtractEcWeaponSet(newData["ecWeapons"])

			if (isnumber(tonumber(newData["ecHealth"]))) then
				currentData["ecHealth"] = tonumber(newData["ecHealth"])
			else
				currentData["ecHealth"] = false
			end

			if (currentData["ecHealth"] ~= false && currentData["ecModels"] ~= false) then
				file.Write("ecmanager/presets/" .. fileName, util.TableToJSON(currentData, true))
				AddClientChatMessage(ply, "Your preset, '" .. fileName .. "' has been updated.")
			else
				AddClientChatMessage(ply, "Bad data sent to the server. Your preset has not been updated.")
				PrintTable(currentData)
			end
		else
			AddClientChatMessage(ply, "You do not have permission to edit this preset.")
		end
	else
		AddClientChatMessage(ply, "Unable to find preset to update - fileName: " .. fileName)
	end
end