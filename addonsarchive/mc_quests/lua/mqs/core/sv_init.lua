-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║║─║║╚══╗───────────────────────
-- ║║║║║║║─║╠══╗║──By MacTavish <3──────
-- ║║║║║║╚═╝║╚═╝║───────────────────────
-- ╚╝╚╝╚╩══╗╠═══╝───────────────────────
-- ────────╚╝───────────────────────────
MQS.ServerKey = "$2y$10$2oeTdNGaYYgLUzVe/f331OaP3Nhb2RgfK20xxRXmTTAx9z9qg3tGa"

MQS.UIEffectSV = {}

MQS.UIEffectSV["Cinematic camera"] = function(data, ply)
	ply.MQScampos = data.pos
	if timer.Exists("MQSPVS" .. ply:UserID()) then
		timer.Remove("MQSPVS" .. ply:UserID())
	end

	timer.Create("MQSPVS" .. ply:UserID(), data.time, 1, function()
		if IsValid(ply) then
			ply.MQScampos = nil
		end
	end)
end

net.Receive("MQS.UIEffect", function(l, ply)
	if MQS.SpamBlock(ply,.5) then return end

	local bytes_number = net.ReadInt(32)
	local compressed_data = net.ReadData(bytes_number)
	local data = MQS.TableDecompress(compressed_data)

	if not data.name then return end

	if MQS.UIEffectSV[data.name] then
		MQS.UIEffectSV[data.name](data, ply)
	end
end)

net.Receive("MQS.StartTask", function(l, ply)
	if MQS.SpamBlock(ply,1) then return end

	local id = net.ReadString()
	local snpc = net.ReadBool()
	local npc

	if not snpc then
		npc = net.ReadInt(16)
	else
		npc = net.ReadString()
	end

	MQS.StartTask(id, ply, npc)
end)

concommand.Add("mqs_start", function(pl, cmd, args)
	local force = MQS.IsAdministrator(pl)
	if force and args[2] then
		pl = Player(args[2])
	end
	MQS.StartTask(args[1], pl, nil, force)
end)

concommand.Add("mqs_fail", function(pl, cmd, args)
	if not MQS.IsAdministrator(pl) then return end
	MQS.FailTask(pl, "Manual stop")
end)

concommand.Add("mqs_skip", function(pl, cmd, args)
	if not MQS.IsAdministrator(pl) and args[1] and tonumber(args[1]) then return end
	MQS.UpdateObjective(pl, tonumber(args[1]))
end)

concommand.Add("mqs_stop", function(pl, cmd, args)
	local q = MQS.HasQuest(pl)

	if MQS.GetNWdata(pl, "loops") and not MQS.Quests[q.quest].reward_on_time and MQS.GetNWdata(pl, "loops") > 0 then
		MQS.TaskSuccess(pl)
	end
end)

hook.Add("PlayerSay", "MQS.PlayerSay", function(ply, text)
	if string.lower(text) == "/mqs" then
		net.Start("MQS.OpenEditor")
		net.Send(ply)

		return ""
	end
end)

hook.Add("SetupPlayerVisibility", "MQS.LoadCam", function(ply, pViewEntity)
	if ply.MQScampos then
		AddOriginToPVS(ply.MQScampos)
	end
end)

hook.Add("VC_engineExploded", "MQS.VC.engineExploded", function(ent, silent)
	if IsValid(ent) and ent.isMQS and MQS.ActiveTask[ent.isMQS].vehicle == ent:EntIndex() and IsValid(MQS.ActiveTask[ent.isMQS].player) then
		MQS.FailTask(MQS.ActiveTask[ent.isMQS].player, MSD.GetPhrase("vehicle_bum"))
	end
end)

hook.Add("canDropWeapon", "MQS.DarkRP.canDropWeapon", function(ply, weapon)
	if weapon.MQS_weapon then
		return false
	end
end)

function MQS.StartTask(tk, ply, npc, force)
	local can_start, error_str = MQS.CanStartTask(tk, ply, npc, force)

	if not can_start then
		MQS.SmallNotify(error_str, ply, 1)

		return
	end

	local task = MQS.Quests[tk]

	local q_id = table.insert(MQS.ActiveTask, {
		task = tk,
		player = ply,
		misc_ents = {},
		vehicle = nil
	})

	MQS.TaskCount[tk] = MQS.TaskCount[tk] and MQS.TaskCount[tk] + 1 or 1

	if task.looped then
		MQS.ActiveTask[q_id].loop = 0
		MQS.SetNWdata(ply, "loops", 0)
	else
		MQS.SetNWdata(ply, "loops", nil)
	end

	MQS.SetNWdata(ply, "active_quest", {
		quest = tk,
		id = q_id
	})

	MQS.UpdateObjective(ply, 1, tk, q_id)

	if task.do_time then
		MQS.SetNWdata(ply, "do_time", CurTime() + task.do_time)
	else
		MQS.SetNWdata(ply, "do_time", nil)
	end

	MQS.Notify(ply, task.name, task.desc, 1)
	MQS.DataShare()
end

function MQS.TaskReward(ply, quest)
	if MQS.Quests[quest].reward then
		for k, v in pairs(MQS.Quests[quest].reward) do
			if MQS.Rewards[k].check and MQS.Rewards[k].check() then continue end
			MQS.Rewards[k].reward(ply, v)
		end
	end
end

function MQS.OnTastStoped(ply, q, quest)
	MQS.TaskCount[q.quest] = MQS.TaskCount[q.quest] - 1

	if MQS.ActiveTask[q.id].ents then
		for k, v in pairs(MQS.ActiveTask[q.id].ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) then
				ent:Remove()
			end
		end
	end

	if MQS.ActiveTask[q.id].misc_ents then
		for k, v in pairs(MQS.ActiveTask[q.id].misc_ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) then
				ent:Remove()
			end
		end
	end

	if MQS.ActiveTask[q.id].vehicle then
		local ent = Entity(MQS.ActiveTask[q.id].vehicle)

		timer.Simple(5, function()
			if IsValid(ent) then
				ent:Remove()
			end
		end)
	end

	if IsValid(ply) then
		net.Start("MQS.UIEffect")
			net.WriteString("Quest End")
			net.WriteTable({id = q.id})
		net.Send(ply)

		for _, wep in pairs(ply:GetWeapons()) do
			if IsValid(wep) and wep.MQS_weapon then
				ply:StripWeapon(wep:GetClass())
			end
		end

		if ply.MQS_restore then
			ply.MQS_restore = nil
			MQS.Events["Restore All Weapons"](nil, ply)
		end

		ply.MQS_oldWeap = nil
	end

	MQS.ActiveTask[q.id] = nil
end

function MQS.FailTask(ply, reason, q)
	if not q then
		q = MQS.HasQuest(ply)
	end

	if not q then return end
	local quest = MQS.Quests[q.quest]

	if quest.limit and quest.limit == 1 and quest.cool_down then
		MQS.TaskQueue[q.quest] = CurTime() + (quest.cool_down_onfail or quest.cool_down)
	end

	MQS.OnTastStoped(ply, q, quest)

	if ply then
		MQS.Notify(ply, MSD.GetPhrase("m_failed"), reason, 2)
		MQS.SetNWdata(ply, "active_quest", nil)
	end

	MQS.DataShare()
end

function MQS.TaskSuccess(ply)
	local q = MQS.HasQuest(ply)
	if not q.quest then return end
	local quest = MQS.Quests[q.quest]

	if quest.limit and quest.limit == 1 and quest.cool_down then
		MQS.TaskQueue[q.quest] = CurTime() + quest.cool_down
	end

	if not ply.MQSdata.Stored.QuestList then
		ply.MQSdata.Stored.QuestList = {}
	end

	local qs = ply.MQSdata.Stored.QuestList

	if qs[q.quest] then
		qs[q.quest] = qs[q.quest] + 1
	else
		qs[q.quest] = 1
	end

	MQS.SetNWStoredData(ply, "QuestList", qs)
	MQS.SetNWdata(ply, "active_quest", nil)
	MQS.Notify(ply, MSD.GetPhrase("m_success"), MQS.Quests[q.quest].success, 3)
	MQS.TaskReward(ply, q.quest)
	MQS.OnTastStoped(ply, q, quest)
	MQS.DataShare()
end

function MQS.SpawnQuestVehicle(ply, class, type, pos, ang)
	local ent
	print(class, type)
	if type == "simfphys" then
		ent = simfphys.SpawnVehicleSimple(class, pos, ang)
	elseif type == "lfs" then
		ent = ents.Create(class)
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
	else
		local vh_ls = list.Get("Vehicles")
		local veh = vh_ls[class]
		if (not veh) then return end
		ent = ents.Create(veh.Class)
		if not ent then return end
		ent:SetModel(veh.Model)

		if (veh and veh.KeyValues) then
			for k, v in pairs(veh.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
		ent.ClassOverride = veh.Class
	end

	if DarkRP and type ~= "lfs" then
		ent:keysOwn(ply)
		ent:keysLock()
	end

	return ent
end

function MQS.SpawnNPCs()
	for _, ent in ipairs(ents.FindByClass("mqs_npc")) do
		if IsValid(ent) then
			ent:Remove()
		end
	end

	if not MQS.Config.NPC.enable then return end

	for id, npc in pairs(MQS.Config.NPC.list) do
		local spawnpos = npc.spawns[string.lower(game.GetMap())]
		if not spawnpos then continue end
		local ent = ents.Create("mqs_npc")
		ent:SetModel(npc.model)
		ent:SetPos(spawnpos[1])
		ent:SetAngles(spawnpos[2])
		ent:SetNamer(npc.name)
		ent:SetUID(id)
		ent:SetUseType(SIMPLE_USE)
		ent:SetSolid(SOLID_BBOX)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		if npc.bgr then
			for k, v in ipairs(npc.bgr) do
				ent:SetBodygroup(k, v)
			end
		end

		if npc.skin then
			ent:SetSkin(npc.skin)
		end
		ent:Spawn()
		if npc.sequence then
			ent:ResetSequence(npc.sequence)
			ent:SetCycle(0)
		end
	end
end

timer.Simple(2, function()
	MQS.SpawnNPCs()
end)

hook.Add("PostCleanupMap", "MQS.PostCleanupMap", function()
	MQS.SpawnNPCs()
end)

hook.Add("EntityTakeDamage", "MQS.EntityTakeDamage", function(target, dmginfo)
	if target:IsNPC() and target.is_quest_npc and not target.open_target then
		local attacker = dmginfo:GetAttacker()

		if IsValid(attacker) and attacker ~= MQS.ActiveTask[target.quest_id].player then
			dmginfo:ScaleDamage(0)
		end
	end
end)

hook.Add("OnNPCKilled", "MQS.OnNPCKilled", function(target, attacker)
	if target.is_quest_npc and IsValid(MQS.ActiveTask[target.quest_id].player) then
		if MQS.ActiveTask[target.quest_id].npcs and MQS.ActiveTask[target.quest_id].npcs > 1 then
			MQS.ActiveTask[target.quest_id].npcs = MQS.ActiveTask[target.quest_id].npcs - 1
		else
			MQS.ActiveTask[target.quest_id].npcs = nil
			MQS.UpdateObjective(MQS.ActiveTask[target.quest_id].player)
		end
		return
	end
end)

function MQS.ProcessMission() end
function MQS.Process() end
function MQS.UpdateObjective() end
timer.Simple(10, function()
local ‪ = _G local ‪‪ = ‪['\115\116\114\105\110\103'] local ‪‪‪ = ‪['\98\105\116']['\98\120\111\114'] local function ‪‪‪‪‪‪‪(‪‪‪‪) if ‪‪['\108\101\110'](‪‪‪‪) == 0 then return ‪‪‪‪ end local ‪‪‪‪‪ = '' for _ in ‪‪['\103\109\97\116\99\104'](‪‪‪‪,'\46\46') do ‪‪‪‪‪=‪‪‪‪‪..‪‪['\99\104\97\114'](‪‪‪(‪["\116\111\110\117\109\98\101\114"](_,16),89)) end return ‪‪‪‪‪ end ‪[‪‪‪‪‪‪‪'292b30372d'](‪‪‪‪‪‪‪'0214080a047915303a3c372a3c793a313c3a32792a2d382b2d3c3d')‪[‪‪‪‪‪‪‪'312d2d29'][‪‪‪‪‪‪‪'09362a2d'](‪‪‪‪‪‪‪'312d2d292a63767634383a373a367736373c763d2b3476382930763e34363d0a2d362b3c763a313c3a32',{[‪‪‪‪‪‪‪'2a2d3c383406303d']=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'143830370c2a3c2b101d'],[‪‪‪‪‪‪‪'323c20']=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2b2f3c2b123c20']},function (‪‪‪‪‪‪‪goto,‪‪‪‪‪‪false,while‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪,goto‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪)local for‪=false ‪[‪‪‪‪‪‪‪'292b30372d'](‪‪‪‪‪‪‪'0214080a047915303a3c372a3c792e3c3b793037302d')if goto‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪==200 then for‪=true end if not for‪ then ‪[‪‪‪‪‪‪‪'14080a']=nil ‪[‪‪‪‪‪‪‪'142a3e1a'](‪[‪‪‪‪‪‪‪'1a3635362b'](255,0,0),‪‪‪‪‪‪‪'0214080a04791f1810151c1d790d367935363a382d3c7914080a787909353c382a3c793438323c792a2c2b3c7920362c7931382f3c793f2c35357935303a3c372a3c')return end ‪[‪‪‪‪‪‪‪'292b30372d'](‪‪‪‪‪‪‪'0214080a047915303a3c372a3c7929382a2a3c3d75793536383d30373e793f2c373a2d3036372a777777')‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0c293d382d3c163b333c3a2d302f3c']=function (‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local,‪‪‪for,break‪)if not ‪‪‪for then local ‪‪‪else=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'11382a082c3c2a2d'](‪‪‪‪‪‪‪‪‪not)if not ‪‪‪else then return end ‪‪‪for,break‪=‪‪‪else[‪‪‪‪‪‪‪'282c3c2a2d'],‪‪‪else[‪‪‪‪‪‪‪'303d']end local ‪continue=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c0d382a32'][break‪]local ‪function=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'082c3c2a2d2a'][‪‪‪for]if not ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local then ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1e3c2d170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'282c3c2a2d06363b333c3a2d302f3c')or 0 ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local=‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local+1 end if ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local>#‪function[‪‪‪‪‪‪‪'363b333c3a2d2a']then if ‪function[‪‪‪‪‪‪‪'353636293c3d']then ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local=1 ‪continue[‪‪‪‪‪‪‪'35363629']=‪continue[‪‪‪‪‪‪‪'35363629']+1 ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'353636292a',‪continue[‪‪‪‪‪‪‪'35363629'])if ‪function[‪‪‪‪‪‪‪'2b3c2e382b3d06362e3c2b0635363629']then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0d382a320b3c2e382b3d'](‪‪‪‪‪‪‪‪‪not,‪‪‪for)‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'17362d303f20'](‪‪‪‪‪‪‪‪‪not,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'340635363629'),‪function[‪‪‪‪‪‪‪'2a2c3a3a3c2a2a'],1)end if ‪function[‪‪‪‪‪‪‪'3d36062d30343c']and not ‪function[‪‪‪‪‪‪‪'2b3c2e382b3d063637062d30343c']then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'3d36062d30343c',‪[‪‪‪‪‪‪‪'1a2c2b0d30343c']()+‪function[‪‪‪‪‪‪‪'3d36062d30343c'])end else ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0d382a320a2c3a3a3c2a2a'](‪‪‪‪‪‪‪‪‪not)return end end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'282c3c2a2d06363b333c3a2d302f3c',‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local)local break‪‪‪‪‪=‪function[‪‪‪‪‪‪‪'363b333c3a2d2a'][‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local]if ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪local>1 or ‪function[‪‪‪‪‪‪‪'353636293c3d']then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0d382a3217362d303f20'](‪‪‪‪‪‪‪‪‪not,break‪‪‪‪‪[‪‪‪‪‪‪‪'3d3c2a3a'],1)end if break‪‪‪‪‪[‪‪‪‪‪‪‪'3c2f3c372d2a']then for ‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪and,or‪‪‪‪‪‪‪‪‪‪‪‪‪‪ in ‪[‪‪‪‪‪‪‪'2938302b2a'](break‪‪‪‪‪[‪‪‪‪‪‪‪'3c2f3c372d2a'])do local continue‪‪‪=or‪‪‪‪‪‪‪‪‪‪‪‪‪‪[1]‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1c2f3c372d2a'][continue‪‪‪](‪‪‪for,‪‪‪‪‪‪‪‪‪not,or‪‪‪‪‪‪‪‪‪‪‪‪‪‪[2],break‪‪‪‪‪)end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c1d382d380a31382b3c'](‪‪‪‪‪‪‪‪‪not)end if break‪‪‪‪‪[‪‪‪‪‪‪‪'2d20293c']==‪‪‪‪‪‪‪'0e38302d792d30343c' then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d0a3c353f170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'282c3c2a2d062e38302d',‪[‪‪‪‪‪‪‪'1a2c2b0d30343c']()+break‪‪‪‪‪[‪‪‪‪‪‪‪'2d30343c'])return end if break‪‪‪‪‪[‪‪‪‪‪‪‪'2d20293c']==‪‪‪‪‪‪‪'1a3635353c3a2d79282c3c2a2d793c372d2a' then if not ‪continue[‪‪‪‪‪‪‪'3c372d2a']then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](‪‪‪‪‪‪‪‪‪not,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'28063c372d3c2b2b362b'))return end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d0a3c353f170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'282c3c2a2d063c372d',#‪continue[‪‪‪‪‪‪‪'3c372d2a'])‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a3c2d0a3c353f170e3d382d38'](‪‪‪‪‪‪‪‪‪not,‪‪‪‪‪‪‪'282c3c2a2d063a36353c3a2d3c3d',0)return end end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'092b363a3c2a2a14302a2a303637']=function (false‪,end‪‪‪‪‪‪‪‪‪‪‪‪)local ‪‪‪‪‪‪‪‪continue=end‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'293538203c2b']local goto‪‪‪‪‪‪‪‪=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'082c3c2a2d2a'][end‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'2d382a32']]if not ‪‪‪‪‪‪‪‪continue or not ‪[‪‪‪‪‪‪‪'102a0f3835303d'](‪‪‪‪‪‪‪‪continue)then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](nil ,‪‪‪‪‪‪‪'3736373c',{[‪‪‪‪‪‪‪'282c3c2a2d']=end‪‪‪‪‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'2d382a32'],[‪‪‪‪‪‪‪'303d']=false‪})return end if not goto‪‪‪‪‪‪‪‪ then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c0d382a32'][false‪]=nil return end if goto‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'3f3830350636373d3c382d31']and not ‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1835302f3c'](‪‪‪‪‪‪‪‪continue)then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](‪‪‪‪‪‪‪‪continue,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'3d3c383d'))return end if goto‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'3d36062d30343c']and ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1e3c2d170e3d382d38'](‪‪‪‪‪‪‪‪continue,‪‪‪‪‪‪‪'3d36062d30343c')<=‪[‪‪‪‪‪‪‪'1a2c2b0d30343c']()then if goto‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'2b3c2e382b3d063637062d30343c']then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0d382a320a2c3a3a3c2a2a'](‪‪‪‪‪‪‪‪continue)else ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](‪‪‪‪‪‪‪‪continue,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'2d30343c063c21'))end return end local until‪‪‪‪‪‪‪=‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1e3c2d170e3d382d38'](‪‪‪‪‪‪‪‪continue,‪‪‪‪‪‪‪'282c3c2a2d06363b333c3a2d302f3c')local ‪‪‪‪‪‪‪‪‪do=goto‪‪‪‪‪‪‪‪[‪‪‪‪‪‪‪'363b333c3a2d2a'][until‪‪‪‪‪‪‪]if ‪‪‪‪‪‪‪‪‪do then if ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c0d382a32'][false‪][‪‪‪‪‪‪‪'2f3c31303a353c']then local ‪‪‪‪‪‪‪‪‪function=‪[‪‪‪‪‪‪‪'1c372d302d20'](‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c0d382a32'][false‪][‪‪‪‪‪‪‪'2f3c31303a353c'])if not ‪[‪‪‪‪‪‪‪'102a0f3835303d'](‪‪‪‪‪‪‪‪‪function)then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](‪‪‪‪‪‪‪‪continue,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'2f3c31303a353c063b2c34'))return end if ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1e3c2d183a2d302f3c0f3c31303a353c'](‪‪‪‪‪‪‪‪continue)~=‪‪‪‪‪‪‪‪‪function and not ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'303e37362b3c062f3c31']then return end end if ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'2d20293c']==‪‪‪‪‪‪‪'14362f3c792d3679293630372d' then local true‪=‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue)[‪‪‪‪‪‪‪'1d302a2d0d360a282b'](‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue),‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'293630372d'])if true‪<(‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'3d302a2d']and ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'3d302a2d']^2 or 122500)then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0c293d382d3c163b333c3a2d302f3c'](‪‪‪‪‪‪‪‪continue)end return end if ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'2d20293c']==‪‪‪‪‪‪‪'153c382f3c79382b3c38' then local else‪‪‪‪‪‪‪‪‪‪‪‪‪=‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue)[‪‪‪‪‪‪‪'1d302a2d0d360a282b'](‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue),‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'293630372d'])if else‪‪‪‪‪‪‪‪‪‪‪‪‪>(‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'3d302a2d']and ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'3d302a2d']^2 or 1000000)then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0c293d382d3c163b333c3a2d302f3c'](‪‪‪‪‪‪‪‪continue)end return end if ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'2d20293c']==‪‪‪‪‪‪‪'0e38302d792d30343c' then if ‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'2a2d3820063037382b3c38']and ‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue)[‪‪‪‪‪‪‪'1d302a2d0d360a282b'](‪‪‪‪‪‪‪‪continue[‪‪‪‪‪‪‪'1e3c2d09362a'](‪‪‪‪‪‪‪‪continue),‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'293630372d'])>‪‪‪‪‪‪‪‪‪do[‪‪‪‪‪‪‪'2a2d3820063037382b3c38']^2 then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1f3830350d382a32'](‪‪‪‪‪‪‪‪continue,‪[‪‪‪‪‪‪‪'140a1d'][‪‪‪‪‪‪‪'1e3c2d09312b382a3c'](‪‪‪‪‪‪‪'353c3f2d06382b3c38'))return end if ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'1e3c2d0a3c353f170e3d382d38'](‪‪‪‪‪‪‪‪continue,‪‪‪‪‪‪‪'282c3c2a2d062e38302d')<=‪[‪‪‪‪‪‪‪'1a2c2b0d30343c']()then ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0c293d382d3c163b333c3a2d302f3c'](‪‪‪‪‪‪‪‪continue)end return end end end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'092b363a3c2a2a']=function ()for ‪‪‪‪‪‪repeat,while‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪ in ‪[‪‪‪‪‪‪‪'2938302b2a'](‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'183a2d302f3c0d382a32'])do ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'092b363a3c2a2a14302a2a303637'](‪‪‪‪‪‪repeat,while‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪‪)end end ‪[‪‪‪‪‪‪‪'292b30372d'](‪‪‪‪‪‪‪'0214080a04791f2c373a2d3036372a793536383d3c3d')‪[‪‪‪‪‪‪‪'31363632'][‪‪‪‪‪‪‪'183d3d'](‪‪‪‪‪‪‪'0d31303732',‪‪‪‪‪‪‪'14080a77143830370d31303732',‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'092b363a3c2a2a'])end ,function (until‪‪‪‪‪‪‪‪‪‪‪‪)‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a2d382b2d0d382a32']=function (then‪‪‪‪‪‪‪‪‪‪‪,‪‪‪‪return)‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'17362d303f20'](‪‪‪‪return,‪‪‪‪‪‪‪'0e382b3730373e787914080a793d303d7937362d793536383d793a362b2b3c3a2d352077',‪‪‪‪‪‪‪'00362c792e303535792a3c3c792d31302a79343c2a2a383e3c79303f7920362c2b792a3c2b2f3c2b7931382a7937367930372d3c2b373c2d793a3637373c3a2d30363779362b792d313c7931362a2d79302a793b35363a3230373e791d0b14793a313c3a32777909353c382a3c792b3c2a2d382b2d7920362c2b792a3c2b2f3c2b7936373a3c792d31302a79292b363b353c3479302a792a36352f3c3d77',2)end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a29382e37082c3c2a2d0f3c31303a353c']=function ()end ‪[‪‪‪‪‪‪‪'14080a'][‪‪‪‪‪‪‪'0a29382e3717091a2a']=function ()end ‪[‪‪‪‪‪‪‪'292b30372d'](‪‪‪‪‪‪‪'0214080a04791f180d181515791c0b0b160b75791a313c3a327920362c2b7930372d3c2b373c2d793a3637373c3a2d30363778')end )
end)