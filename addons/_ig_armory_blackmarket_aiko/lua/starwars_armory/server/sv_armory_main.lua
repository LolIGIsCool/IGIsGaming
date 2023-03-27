util.AddNetworkString("Armory_BuyWeapons")
util.AddNetworkString("Armory_OpenMenu")

function SArmory.Action.connectDatabase()
	if not file.Exists("armory", "DATA") then
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

function SArmory.Action.PurchaseWeapon(Player, strWep)

	local data = SArmory.Database[strWep]
	if not data then return end

	for _, wep in ipairs(Player:GetWeapons()) do
		if wep:GetClass() == strWep then
			Player:PrintMessage(HUD_PRINTTALK, "You already own a " .. data.Name .. ", I don't think you need to buy it again!")
			return
		end
	end

	if (Player:SH_CanAffordPremium(data.Cost) == false) then
		Player:PrintMessage(HUD_PRINTTALK, "You can't afford this weapon!")
		return
	end
		Player:SH_AddPremiumPoints(-data.Cost)
	Player:PrintMessage(HUD_PRINTTALK, "Succesfully purchased " .. data.Name .. " for " .. data.Cost .. " credits!")
	Player:Give(strWep)
end

net.Receive("Armory_BuyWeapons", function(len, Player)
	local weapon = net.ReadString()
	if not weapon then return end
	for k, v in ipairs( ents.FindInSphere(Player:GetPos(),500) ) do
		if v:GetClass() == "starwars_armor" then
			SArmory.Action.PurchaseWeapon(Player, weapon)
			return
		end
	end
end)

function SArmory.Action.CreateSpawnPoint(Player, mdl)
	if not IsValid(Player) then return end

	if not mdl then mdl = "models/Humans/Group01/Female_06.mdl" end

	local pos = Player:GetPos()
	local ang = Player:GetAngles()
	local npcmdl = mdl or "models/Humans/Group02/Female_01.mdl"

	local tbl = {vec = pos, ang = ang, model = npcmdl}

	if not ArmorySpawnVector[game.GetMap()] then
		ArmorySpawnVector[game.GetMap()] = {}
	end

	table.insert(ArmorySpawnVector[game.GetMap()], tbl)

	file.Write( "armory_spawns.txt", util.TableToJSON(ArmorySpawnVector))

	local spawnents = ents.Create("starwars_armor")
	spawnents:SetPos(pos)
	spawnents:SetAngles(ang)
	spawnents:SetModel(mdl)
	spawnents:Spawn()
	spawnents:Activate()
end

function SArmory.Action.CMD_Spawn(ply, cmd, args)
	if not IsValid(ply) then return end

	if not ply:IsAdmin() or not ply:IsDeveloper() then return end

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
			MsgN("Armory: No spawns for this map!")
			return
		end

		for k,v in pairs(tbl2[game.GetMap()]) do
			local npcents = ents.Create("starwars_armor")
			npcents:SetPos(Vector(v.vec.x, v.vec.y, v.vec.z))
			npcents:SetAngles(Angle(v.ang.p,v.ang.y,v.ang.r))
			npcents:SetModel(v.model)
			npcents:Spawn()
			npcents:Activate()

			npcents.ArmoryID = k
		end
	end)
end

function SArmory.Action.CMD_RemoveSpawn(Player)
	if not IsValid(Player) then return end
	if not ply:IsSuperAdmin() then return end


	local trace = Player:GetEyeTrace()

	if trace.Entity and trace.Entity:GetClass() == "starwars_armor" then
		local ent = trace.Entity

		local ID = ent.ArmoryID

		if not ID then
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