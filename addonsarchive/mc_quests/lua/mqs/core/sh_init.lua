-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║║─║║╚══╗───────────────────────
-- ║║║║║║║─║╠══╗║──By MacTavish <3──────
-- ║║║║║║╚═╝║╚═╝║───────────────────────
-- ╚╝╚╝╚╩══╗╠═══╝───────────────────────
-- ────────╚╝───────────────────────────

--──────────────────────────────────--
-------------- Events ---------------
--──────────────────────────────────--

MQS.Events["Spawn quest entity"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)
	local ent = ents.Create("mqs_ent")
	ent.model = data[1]
	ent.task = task
	ent.task_id = q.id
	ent.task_ply = ply
	ent.pointer = data[3]
	ent.enablephys = data[4]
	local pos = data[2]

	if istable(pos) then
		pos = table.Random(pos)
	end

	if data[5] then
		ent:SetAngles(data[5])
	end

	if data[6] then
		ent:SetMaterial(data[6])
	end

	if data[7] then
		ent:SetColor(data[7])
	end

	if data[8] then
		ent:SetUseHold(data[8])
	end

	ent:SetPos(pos)
	ent:Spawn()

	if not MQS.ActiveTask[q.id].ents then
		MQS.ActiveTask[q.id].ents = {}
	end

	table.insert(MQS.ActiveTask[q.id].ents, ent:EntIndex())
end

MQS.Events["Spawn vehicle"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)
	if MQS.ActiveTask[q.id].vehicle then return end
	local vehicle = MQS.SpawnQuestVehicle(ply, data[1], data[2], data[3], data[4])
	if not vehicle then return end

	if data[5] then
		vehicle:SetSkin(data[5])
	end

	if data[7] then
		vehicle:SetColor(data[7])
	end
	vehicle.isMQS = q.id
	vehicle = vehicle:EntIndex()

	if not MQS.ActiveTask[q.id].vehicle then
		MQS.ActiveTask[q.id].vehicle = vehicle
	end
end

MQS.Events["Remove vehicle"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)
	if not MQS.ActiveTask[q.id].vehicle then return end
	local veh = Entity(MQS.ActiveTask[q.id].vehicle)
	MQS.ActiveTask[q.id].vehicle = nil

	if data and data > 0 then
		timer.Simple(data, function()
			if IsValid(veh) then
				veh:Remove()
			end
		end)
	else
		if IsValid(veh) then
			veh:Remove()
		end
	end
end

MQS.Events["Spawn entity"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)
	if data[1] == "worldspawn" then return end
	local ent = ents.Create(data[1])

	if not ent:IsValid() then
		MsgC(Color(255, 0, 0), "[MQS] Quest id: " .. task .. " failed to create " .. data[1] .. "!\n")

		return
	end

	ent:SetPos(data[2])
	ent:SetAngles(data[3])

	if data[4] then
		ent:SetModel(data[4])
	end

	if data[6] then
		ent:SetMaterial(data[6])
	end

	if data[7] then
		ent:SetColor(data[7])
	end

	ent:Spawn()

	if data[5] then
		local phys = ent:GetPhysicsObject()

		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	end

	table.insert(MQS.ActiveTask[q.id].misc_ents, ent:EntIndex())
end

MQS.Events["Remove all entites"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)

	if MQS.ActiveTask[q.id].misc_ents then
		for k, v in pairs(MQS.ActiveTask[q.id].misc_ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) then
				ent:Remove()
			end
		end
	end
end

MQS.Events["Spawn npc"] = function(task, ply, data, obj)
	local q = MQS.HasQuest(ply)
	local ent = ents.Create(data[1])

	if not ent:IsValid() then
		MsgC(Color(255, 0, 0), "[MQS] Quest id: " .. task .. " failed to create " .. data[1] .. "!\n")

		return
	end

	data[2].z = data[2].z + 30
	ent:SetPos(data[2])
	ent:SetAngles(data[3])

	if data[4] then
		ent.is_quest_npc = task
		ent:SetNWBool( "MQSTarget", true )
		MQS.ActiveTask[q.id].npcs = MQS.ActiveTask[q.id].npcs and MQS.ActiveTask[q.id].npcs + 1 or 1
	end

	ent.quest_id = q.id
	ent:Spawn()
	ent:Activate()

	if data[5] then
		ent:SetModel(data[5])
	end

	if data[6] then
		ent:Give(data[6])
	end

	local gr = "D_HT"

	if data[7] then
		ent:AddEntityRelationship(ply, 1, 99)
		ent:SetNPCState(NPC_STATE_COMBAT)
	else
		ent:AddEntityRelationship(ply, 4, 99)
		gr = "D_LI"
	end

	if obj.open_target then
		ent:AddRelationship("player " .. gr .. " 99")
		ent.open_target = true
	else
		ent:AddRelationship("player D_NU 99")
	end

	ent:SetKeyValue("spawnflags", bit.bor(SF_NPC_NO_WEAPON_DROP))
	table.insert(MQS.ActiveTask[q.id].misc_ents, ent:EntIndex())
end

MQS.Events["Give weapon"] = function(task, ply, data)
	local weapon = ply:Give(data)
	if IsValid(weapon) and weapon ~= NULL then
		weapon.MQS_weapon = true
	end
end

MQS.Events["Give ammo"] = function(task, ply, data)
	ply:GiveAmmo(data[2], data[1], false)
end

MQS.Events["Strip Weapon"] = function(task, ply, data)
	ply:StripWeapon(data)
end

MQS.Events["Strip All Weapons"] = function(task, ply, data)
	ply.MQS_oldWeap = ply.MQS_oldWeap or {}

	if data then
		ply.MQS_restore = true
	end

	for _, wep in pairs(ply:GetWeapons()) do
		if wep.MQS_weapon then continue end
		ply.MQS_oldWeap[wep:GetClass()] = true
	end

	ply:StripWeapons()
end

MQS.Events["Restore All Weapons"] = function(task, ply)
	for wep, _ in pairs(ply.MQS_oldWeap) do
		ply:Give(wep)
	end
end

MQS.Events["Manage do time"] = function(task, ply, data)
	if not MQS.GetNWdata(ply, "do_time") then return end

	if data[1] then
		MQS.SetNWdata(ply, "do_time", CurTime() + MQS.Quests[task].do_time)
	else
		MQS.SetNWdata(ply, "do_time", MQS.GetNWdata(ply, "do_time") + data[2])
	end
end

MQS.Events["Set HP"] = function(task, ply, data)
	if data[1] then
		ply:SetHealth(ply:GetMaxHealth())
	else
		ply:SetHealth(data[2])
	end
end

MQS.Events["Set Armor"] = function(task, ply, data)
	ply:SetArmor(math.Clamp(data[1], 0, 255))
end

MQS.Events["Teleport player"] = function(task, ply, data)
	ply:SetPos( data[1] )
	ply:SetEyeAngles( data[2] )
	ply:SetLocalVelocity( Vector( 0, 0, 0 ) )
end

MQS.Events["Cinematic camera"] = function(task, ply, data)
	net.Start("MQS.UIEffect")
		net.WriteString("Cinematic camera")
		net.WriteTable(data)
	net.Send(ply)
end

MQS.Events["Music player"] = function(task, ply, data)
	net.Start("MQS.UIEffect")
		net.WriteString("Music")
		net.WriteTable(data)
	net.Send(ply)
end

MQS.Events["[MCS] Spawn npc"] = function(task, ply, data)
	local q = MQS.HasQuest(ply)
	local npc = MCS.Spawns[data[1]]
	if not npc then return end
	local ent = ents.Create("mcs_npc")
	ent:SetModel(npc.model)
	ent:SetPos(data[2])
	ent:SetAngles(data[3])
	ent:SetNamer(npc.name)
	ent:SetUID(data[1])
	ent:SetInputLimit(true)
	ent:SetUseType(SIMPLE_USE)
	ent:SetSolid(SOLID_BBOX)
	ent:PhysicsInit(SOLID_BBOX)
	ent:SetMoveType(MOVETYPE_NONE)

	if npc.sequence then
		local sequence = npc.sequence

		if istable(sequence) then
			sequence = table.Random(sequence)
		end

		ent.AutomaticFrameAdvance = true
		ent:ResetSequence(sequence)
		ent:SetDefAnimation(sequence)
	end

	if npc.bgr then
		for k, v in ipairs(npc.bgr) do
			ent:SetBodygroup(k, v)
		end
	end

	if npc.skin then
		ent:SetSkin(npc.skin)
	end

	ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	ent:Spawn()
	table.insert(MQS.ActiveTask[q.id].misc_ents, ent:EntIndex())
end

MQS.Events["Run Console Command"] = function(task, ply, data)
	local cmd = data[1]
	local args = data[2]
	local cmd_arg = ""
	args = string.Explode(" ", args)

	for _, arg in pairs(args) do
		if arg == "$uid" then
			arg = ply:UserID()
		end

		if arg == "$sid" then
			arg = ply:SteamID()
		end

		if arg == "$s64" then
			arg = ply:SteamID64()
		end

		if arg == "$n" then
			arg = "\"" .. ply:Name() .. "\""
		end

		cmd_arg = cmd_arg .. " " .. arg
	end
	print(cmd .. cmd_arg)
	game.ConsoleCommand(cmd .. cmd_arg .. "\n")
end

--──────────────────────────────────--
-------------- Rewards ---------------
--──────────────────────────────────--

MQS.Rewards["Give Weapon"] = {
	reward = function(ply, val)
		ply:Give(val[1])
	end,
}

MQS.Rewards["DarkRP money"] = {
	check = function()
		if DarkRP then return false end

		return true
	end,
	reward = function(ply, val)
		ply:addMoney(val[1])
	end,
}

MQS.Rewards["PointShop2 Standard Points"] = {
	check = function()
		if Pointshop2 then return false end

		return true
	end,
	reward = function(ply, val)
		ply:PS2_AddStandardPoints(val[1])
	end,
}

MQS.Rewards["PointShop2 Premium Points"] = {
	check = function()
		if Pointshop2 then return false end

		return true
	end,
	reward = function(ply, val)
		ply:PS2_AddPremiumPoints(val[1])
	end,
}

MQS.Rewards["PointShop2 Give Item"] = {
	check = function()
		if Pointshop2 then return false end

		return true
	end,
	reward = function(ply, val)
		ply:PS2_EasyAddItem(val[1])
	end,
}

MQS.Rewards["PointShop Points"] = {
	check = function()
		if PS then return false end

		return true
	end,
	reward = function(ply, val)
		ply:PS_GivePoints(val[1])
	end,
}

MQS.Rewards["PointShop Give Item"] = {
	check = function()
		if PS then return false end

		return true
	end,
	reward = function(ply, val)
		ply:PS_GiveItem(val[1])
	end,
}

MQS.Rewards["DarkRP Leveling System"] = {
	check = function()
		if LevelSystemConfiguration then return false end

		return true
	end,
	reward = function(ply, val)
		ply:addXP(val[1])
	end,
}

MQS.Rewards["Glorified Leveling"] = {
	check = function()
		if GlorifiedLeveling then return false end

		return true
	end,
	reward = function(ply, val)
		GlorifiedLeveling.AddPlayerXP(ply, val[1])
		if val[2] then
			GlorifiedLeveling.AddPlayerLevels(ply, val[2])
		end
	end,
}

MQS.Rewards["Helix money"] = {
	check = function()
		if ix then return false end

		return true
	end,
	reward = function(ply, val)
		ply:GetCharacter():GiveMoney(val[1])
	end,
}

MQS.Rewards["Run Console Command"] = {
	reward = function(ply, val)
		local cmd = val[1]
		local args = val[2]
		local cmd_arg = ""
		args = string.Explode(" ", args)

		for _, arg in pairs(args) do
			if arg == "$uid" then
				arg = ply:UserID()
			end

			if arg == "$sid" then
				arg = ply:SteamID()
			end

			if arg == "$s64" then
				arg = ply:SteamID64()
			end

			if arg == "$n" then
				arg = "\"" .. ply:Name() .. "\""
			end

			cmd_arg = cmd_arg .. " " .. arg
		end
		print(cmd .. cmd_arg)
		game.ConsoleCommand(cmd .. cmd_arg .. "\n")
	end,
}