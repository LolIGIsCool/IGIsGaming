util.AddNetworkString("Armory_SyncWeapons")
util.AddNetworkString("Armory_BuyWeapons")
util.AddNetworkString("Armory_DeployWeapons")
util.AddNetworkString("Armory_OpenMenu")
resource.AddFile("resource/fonts/Aurebesh-English.ttf")

function SArmory.Action.DeployWeapon(Player, strWeapon)
	if not Player then return end
	if not strWeapon then SArmory.Action.FatalError() return end
	if Player:HasWeapon(strWeapon) then return end
	
	local data = SArmory.Database[strWeapon]
	if not data then MsgN("no data for weapon") return end

	--[[ Check Usergroup Table ]]--
	if data.Usergroup and not table.HasValue(data.Usergroup, Player:GetUserGroup()) then 
		SArmory.Action.Notify(Player, "You are not the required group to deploy this weapon!")
		return 
	end
	
	--[[ Check Team Table (bool ]]--
	if data.Job then
		local jobs = SArmory.Database[strWeapon].Job
		local found = false
		
		for k,v in pairs(jobs) do
			if v == Player:Team() then
				found = true
			end
		end
		
		if (found == false) then
			SArmory.Action.Notify(Player, "You are not the required team to deploy this weapon!")
			return
		end
	end

	if data.Blacklist then
		local blacklist = data.Blacklist

		if table.HasValue(blacklist, Player:Team()) then
			SArmory.Action.Notify(Player, "Your team is blacklisted from spawning this weapon!")
			return
		end
	end
	
	--[[ Check Deployment Costs]]--
	if data.DeployCost then
		local vowels = {'a','e','i','o','u','A','E','I','O','U'}
		if not Player:SH_CanAffordPremium(data.DeployCost) then
			SArmory.Action.Notify(Player, "You do not have the money to deploy this weapon!")
			return 
		else
			Player:SH_AddPremiumPoints(-data.DeployCost)
			SArmory.Action.Notify(Player, data.Name.. " deployed for ".. data.DeployCost .. " credits.")
		end
end
    local strWep = strWeapon
	if Player:HasOwnedWeapon(tostring(strWep)) then 
	Player:Give(strWeapon,true)
	timer.Simple(0.1, function()
		Player:SelectWeapon(strWeapon)
	end)
	end
end

function SArmory.Action.Notify(Player, strMessage)
	if SArmory.Config.Notify == "darkrp" then
		DarkRP.notify(Player, 1, 5, tostring(strMessage))
	else
		Player:PrintMessage(HUD_PRINTTALK, strMessage)
	end
end


function SArmory.Action.ArmorySaveData(Player)
	file.Write("armory/armory_"..Player:SteamID64()..".txt", util.TableToJSON(Player.ArmoryWeapons))

	SArmory.Action.SyncData(Player)
end


function SArmory.Action.connectDatabase()
	if !file.Exists("armory", "DATA") then
		file.CreateDir( "armory" )
	end
	
	if file.Exists("armory_spawns.txt", "DATA" ) then
		local tbl = file.Read("armory_spawns.txt", "DATA")
		ArmorySpawnVector = util.JSONToTable(tbl)
	else
		ArmorySpawnVector = {}
		file.Write("armory_spawns.txt", util.TableToJSON(ArmorySpawnVector))
	end
	
	SArmory.Action.SpawnNPCs()
end
hook.Add( "Initialize", "SArmory.Action.connectDatabase", SArmory.Action.connectDatabase)


hook.Add("PlayerInitialSpawn", "Armory_InitalSpawn", function(Player)
	timer.Simple(1, function()
		if file.Exists("armory/armory_"..Player:SteamID64()..".txt", "DATA" ) then
			local tbl = file.Read("armory/armory_"..Player:SteamID64()..".txt", "DATA") 
			Player.ArmoryWeapons = util.JSONToTable(tbl)
			SArmory.Action.SyncData(Player)
		else
			Player.ArmoryWeapons = {}
			file.Write("armory/armory_"..Player:SteamID64()..".txt", util.TableToJSON(Player.ArmoryWeapons))
		end
	end)

	timer.Simple(5, function()
		local tbl = Player.ArmoryWeapons
		local weps = {}
		if not tbl then return end

		for k, v in pairs(tbl) do
			local WEAPON = SArmory.Database[k]

			if (WEAPON) then
				if (WEAPON.GiveOnSpawn) then
					if (WEAPON.Usergroup) then
						if (!table.HasValue(WEAPON.Usergroup, Player:GetUserGroup())) then continue end
					end
					Player:Give(k)
				end
			end
		end
	end)
end)

local function spawn(Player)

	local tbl = Player.ArmoryWeapons
	local weps = {}
	if not tbl then return end


	for k, v in pairs(tbl) do
		local WEAPON = SArmory.Database[k]

		if (WEAPON) then
			if (WEAPON.GiveOnSpawn) then
				if (WEAPON.Usergroup) then
					if (!table.HasValue(WEAPON.Usergroup, Player:GetUserGroup())) then continue end
				end
				Player:Give(k)
			end
		end
	end

end
hook.Add( "PlayerSpawn", "givearmoryweapons", spawn )


local pmeta = FindMetaTable("Player")
function pmeta:HasOwnedWeapon(strWep)
	local bool = false
	
	if self.ArmoryWeapons[strWep] then
		bool = true
	end

	return bool
end

function SArmory.Action.PurchaseWeapon(Player, strWep)

	local data = SArmory.Database[strWep]
	if not data then return end

	if data.Blacklist then
		local blacklist = data.Blacklist

		if table.HasValue(blacklist, Player:Team()) then
			SArmory.Action.Notify(Player, "Your team is blacklisted from spawning this weapon!")
			return
		end
	end

	if Player:HasOwnedWeapon(tostring(strWep)) then 
		SArmory.Action.Notify(Player, "You already own this weapon!")
		return 
	end
	
	if (Player:SH_CanAffordPremium(data.Price)== false) then
		SArmory.Action.Notify(Player, "You can't afford this weapon!")
		return
	end
	
	if data.Usergroup and not table.HasValue(data.Usergroup, Player:GetUserGroup()) then 
		SArmory.Action.Notify(Player, "You are not the required user-group to purchase this weapon!")
		return 
	end


	if SArmory.Database[strWep].Job then
		local jobs = SArmory.Database[strWep].Job
		local found = false
		
		for k,v in pairs(jobs) do
			if v == Player:Team() then
				found = true
			end
		end
		
		if (found == false) then
			SArmory.Action.Notify(Player, "You are not the required team to purchase this weapon!")
			return
		end
	end
	
	Player.ArmoryWeapons[strWep] = true
	Player:SH_AddPremiumPoints(-data.Price)
	Player:PrintMessage(HUD_PRINTTALK, "Succesfully purchased weapon!")
	
	timer.Simple(0.1, function()
		SArmory.Action.ArmorySaveData(Player)
	end)
end

function SArmory.Action.CreateSpawnPoint(Player, mdl)
	if not IsValid(Player) then return end
	
	if not mdl then mdl = "models/Humans/Group01/Female_06.mdl" end
	
	local pos = Player:GetPos()
	local ang = Player:GetAngles()
	local mdl = mdl or "models/Humans/Group02/Female_01.mdl"
	
	local tbl = {vec = pos, ang = ang, model = mdl}
	
	if not ArmorySpawnVector[game.GetMap()] then
		ArmorySpawnVector[game.GetMap()] = {}
	end
	
	table.insert(ArmorySpawnVector[game.GetMap()], tbl)
	
	file.Write( "armory_spawns.txt", util.TableToJSON(ArmorySpawnVector))
	
	local ents = ents.Create("starwars_armor")
	ents:SetPos(pos)
	ents:SetAngles(ang)
	ents:SetModel(mdl)
	ents:Spawn()
	ents:Activate()
end

function SArmory.Action.CMD_Spawn(ply, cmd, args)
	if not IsValid(ply) then return end
	
	if not table.HasValue(SArmory.Config.CMD_UserGroups, ply:GetUserGroup() ) then return end
	
	local mdl = args[1]
	
	SArmory.Action.CreateSpawnPoint(ply, mdl)
end
concommand.Add("sw_addnpc", SArmory.Action.CMD_Spawn)

function SArmory.Action.SpawnNPCs()
	timer.Simple(3, function()
	
		if not file.Exists("armory_spawns.txt", "DATA") then MsgN("[ARMORY] No spawns have been set!") return end
		
		local tbl = file.Read("armory_spawns.txt", "DATA")
		local tbl2 = util.JSONToTable(tbl)
		
		if not tbl2[game.GetMap()] then
			MsgN('Armory: No spawns for this map!')
			return
		end
		
		for k,v in pairs(tbl2[game.GetMap()]) do
			local ents = ents.Create("starwars_armor")
			ents:SetPos(Vector(v.vec.x, v.vec.y, v.vec.z))
			ents:SetAngles(Angle(v.ang.p,v.ang.y,v.ang.r))
			ents:SetModel(v.model)
			ents:Spawn()
			ents:Activate()

			ents.ArmoryID = k
		end
	end)
end

function SArmory.Action.CMD_RemoveSpawn(Player)
	if not IsValid(Player) then return end
	if not table.HasValue(SArmory.Config.CMD_UserGroups, Player:GetUserGroup() ) then return end
	
	
	local trace = Player:GetEyeTrace()
	
	if trace.Entity and trace.Entity:GetClass() == "starwars_armor" then
		local pos = trace.Entity:GetPos()
		local ent = trace.Entity

		local ID = trace.Entity.ArmoryID 

		if !ID then
			Player:PrintMessage(HUD_PRINTTALK, "This armory NPC is invalid. Consider deleteing the data file.")
			return
		end


		ArmorySpawnVector[game.GetMap()][ID] = nil
		SArmory.Action.SaveSpawns()

		trace.Entity:Remove()

		Player:PrintMessage(HUD_PRINTTALK, "This armory NPC has been removed from spawning")

	end
end
concommand.Add("sw_removenpc", SArmory.Action.CMD_RemoveSpawn)

function SArmory.Action.SaveSpawns()
	if not ArmorySpawnVector then return end
	file.Write( "armory_spawns.txt", util.TableToJSON(ArmorySpawnVector))
end