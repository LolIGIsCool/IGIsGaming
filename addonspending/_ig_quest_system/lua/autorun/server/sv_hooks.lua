hook.Add( "Initialize", "InitializeQuestHooks", function()
	timer.Create("PlayTimeQuestChecker", 30, 0, function()
		for k, v in pairs(player.GetAll()) do
			local plytime = v:GetUTimeTotalTime()

			if plytime >= 43200 then
				v:ProgressQuest("Play Time", 1)
			end

			if plytime >= 86400 then
				v:ProgressQuest("Play Time", 2)
			end

			if plytime >= 604800 then
				v:ProgressQuest("Play Time", 3)
			end

			local plylevel = SimpleXPGetLevel(v)

			if plylevel >= 10 then
				v:ProgressQuest("Levels", 1)
			end

			if plylevel >= 25 then
				v:ProgressQuest("Levels", 2)
			end

			if plylevel >= 50 then
				v:ProgressQuest("Levels", 3)
			end
		end
	end)

	hook.Add("PlayerDeath", "QuestEventKills", function(victim, inflictor, attacker)
		if (attacker:IsPlayer() and victim:GetRegiment() == "Event") or (attacker:IsPlayer() and victim:GetRegiment() == "Event2") then
			if victim == attacker then return end
			attacker:ProgressQuest("Event Kills", 1)
			attacker:ProgressQuest("Event Kills", 2)
			attacker:ProgressQuest("Event Kills", 3)
		end
	end)

	hook.Add("EntityTakeDamage", "QuestFiringRange", function(ent, dmginfo)
		local targetname = ent:GetName()
		local ply = dmginfo:GetAttacker()
		if not (ply) then return end

		if (targetname == "shoot1Trgt" or targetname == "shoot2Trgt" or targetname == "shoot3Trgt" or targetname == "shoot4Trgt") then
			if (ply:IsPlayer()) then
				ply:ProgressQuest("Firing Range", 1)
				ply:ProgressQuest("Firing Range", 2)
				ply:ProgressQuest("Firing Range", 3)
			end
		end
	end)

	hook.Add("playerclimbjump", "QuestClimbSwep", function(player, jumps)
		if (player:IsPlayer()) and jumps ~= 0 then
			player:ProgressQuest("Climbing", 1)
			player:ProgressQuest("Climbing", 2)
			player:ProgressQuest("Climbing", 3)
		end
	end)

	hook.Add("OnNPCKilled", "QuestNPCKills", function(npc, attacker, inflictor)
		if attacker:IsPlayer() then
			attacker:ProgressQuest("NPC Kills", 1)
			attacker:ProgressQuest("NPC Kills", 2)
			attacker:ProgressQuest("NPC Kills", 3)
		end
	end)

	timer.Create("CheckSecretArea1", 2, 0, function()
		local secretarea1 = Vector(5000.91, 2034.07, -5293.62)

		for k, v in pairs(ents.FindInSphere(secretarea1, 200)) do
			if v:IsPlayer() then
				v:ProgressQuest("Secret Areas", 1)
			end
		end
	end)

	timer.Create("CheckSecretArea2", 2, 0, function()
		local secretarea2 = Vector(1524.03, -1849.74, -5129.90)

		for k, v in pairs(ents.FindInSphere(secretarea2, 200)) do
			if v:IsPlayer() then
				v:ProgressQuest("Secret Areas", 2)
			end
		end
	end)

	timer.Create("CheckSecretArea3", 2, 0, function()
		local secretarea3 = Vector(-3103.63, 1038.96, -6015.97)

		for k, v in pairs(ents.FindInSphere(secretarea3, 200)) do
			if v:IsPlayer() then
				v:ProgressQuest("Secret Areas", 3)
			end
		end
	end)

	local plymeta = FindMetaTable("Player")

	function plymeta:CanRegen()
		if not self:IsPlayer() then return false end
		if self:Health() == self:GetMaxHealth() then return false end
		if self:GetNWInt("igprogressu", 0) < 7 then return false end
		if CurTime() < self.dmgtime then return false end
		if not self:GetNWBool("ighealthregen", true) then return false end
		if not self:Alive() then return false end

		return true
	end

	timer.Create("QuestHealthRegen", 30, 0, function()
		for k, v in pairs(player.GetAll()) do
			if v:CanRegen() then
				local maxhealth = v:GetMaxHealth()
				local health = v:Health()
				local missinghealth = maxhealth - health
				local randomfactor = math.random(1, 10)
				local healfactor = missinghealth * (randomfactor / 100)
				local finalheal = math.Round(math.Clamp(healfactor, 0, maxhealth))
				v:SetHealth(health + finalheal)
			end
		end
	end)
end)