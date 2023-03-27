--  _______               __          _______  __                   __          _______  ______  ______        
-- |   |   |.---.-..----.|  |.-----. |     __||__|.--------..-----.|  |.-----. |    |  ||   __ \|      |.-----.
-- |       ||  _  ||  __| |_||__ --| |__     ||  ||        ||  _  ||  ||  -__| |       ||    __/|   ---||__ --|
-- |__|_|__||___._||____|    |_____| |_______||__||__|__|__||   __||__||_____| |__|____||___|   |______||_____|
--                                                          |__|      
--
util.AddNetworkString("MCS.OpenMenu")
util.AddNetworkString("MCS.SetupMenu")
util.AddNetworkString("MCS.CloseMenu")
util.AddNetworkString("MCS.SrartSvFunc")
util.AddNetworkString("MCS.SrartAnimation")
util.AddNetworkString("MCS.GetConfigData")
util.AddNetworkString("MCS.SaveConfig")

function MCS.SpawnAllNPCs()
	print( "[MCS NPCs] Spawning NPCs" )
	for _, ent in pairs(ents.FindByClass("mcs_npc")) do
		if IsValid(ent) then
			ent:Remove()
			print( "[MCS NPCs] Old npc found removing..." )
		end
	end

	for uid, npc in pairs(MCS.Spawns) do
		local spawnpos = npc.pos[string.lower(game.GetMap())] or npc.pos["all"]
		if not spawnpos then continue end
		npc.uselimit = npc.uselimit or false
		local ent = ents.Create("mcs_npc")
		ent:SetModel(npc.model)
		ent:SetModelScale(npc.scale or 1)
		ent:SetPos(spawnpos[1])
		ent:SetAngles(spawnpos[2])
		ent:SetNamer(npc.name)
		ent:SetUID(uid)
		ent:SetInputLimit(npc.uselimit)
		ent:SetUseType(SIMPLE_USE)
		ent:SetSolid(SOLID_BBOX)
		ent:PhysicsInit(SOLID_BBOX)
		ent:SetMoveType(MOVETYPE_NONE)

		if npc.bgr then
			for k, v in pairs(npc.bgr) do
				ent:SetBodygroup(k, v)
			end
		end

		if npc.skin then
			ent:SetSkin(npc.skin)
		end
		ent:Spawn()

		if npc.sequence then
			local sequence = npc.sequence

			if istable(sequence) then
				ent.randSequence = sequence
				sequence = table.Random(sequence)
			end

			ent.AutomaticFrameAdvance = true
			ent:SetDefAnimation(sequence)
			ent:ResetSequence(sequence)
			ent:SetCycle(0)
		end

		print( "[MCS NPCs] Spawning npc - " .. npc.name .. " [" .. uid .. "]" )
	end
end

concommand.Add("mcs_npcrespawn", function(ply)
	if not ply:IsSuperAdmin() then return end
	MCS.SpawnAllNPCs()
end)

hook.Add("PostCleanupMap", "MCS.PostCleanupMap", function()
	MCS.SpawnAllNPCs()
end)

timer.Simple(5, function() MCS.SpawnAllNPCs() end)

concommand.Add("mcs_setup", function(ply)
	if not ply:IsSuperAdmin() then return end
	net.Start("MCS.SetupMenu")
	net.Send(ply)
end)


net.Receive("MCS.SrartSvFunc", function(l, ply)
	local aid = net.ReadString()
	local npc = net.ReadEntity()
	local data = net.ReadTable()
	if not aid then return end

	if MCS.AddonList[aid] and MCS.AddonList[aid]["enabled"] and MCS.AddonList[aid]["function_sv"] then
		MCS.AddonList[aid]["function_sv"](ply, npc, data)
	end
end)

net.Receive("MCS.CloseMenu", function(l, ply)
	local npc = net.ReadEntity()
	if not npc or not IsValid(npc) then return end
	npc.UsingPlayer = false

	local seq = npc:GetDefAnimation()
	if npc.randSequence then seq =  table.Random(npc.randSequence) end
	npc:ResetSequence(seq)
	npc:SetCycle(0)
end)

net.Receive("MCS.SrartAnimation", function(l, ply)
	local npc = net.ReadEntity()
	local anim = net.ReadString()
	if not npc or not IsValid(npc) or not anim then return end
	npc:ResetSequence(anim)
	--npc:AddGestureSequence( npc:LookupSequence(anim), true )
	npc:SetCycle(0)
end)