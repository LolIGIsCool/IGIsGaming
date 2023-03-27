local ps = SH_POINTSHOP
local MODULE = MODULE or ps.Modules.integrationttt

local pending = {}
local playing = {}
local total = {}

function MODULE:ProperGiveReward(ply, rew)
	if (rew.standard == 0 and rew.premium == 0) then
		return end

	local mult = self:GetMultiplier(ply)
	local std, prm = math.Round((rew.standard or 0) * mult), math.Round((rew.premium or 0) * mult)

	ply:SH_AddStandardPoints(std, nil, true, true)
	ply:SH_AddPremiumPoints(prm, nil, true, true)

	total[ply:SteamID()] = total[ply:SteamID()] or {standard = 0, premium = 0}
	local tot = total[ply:SteamID()]
	tot.standard = tot.standard + std
	tot.premium = tot.premium + prm

	-- Let's avoid saving multiple times
	timer.Create("SH_POINTSHOP.IntegrationTTT.Save" .. ply:UserID(), 0.1, 1, function()
		if (!IsValid(ply)) then
			return end

		ply:SH_TransmitPoints()
		ply:SH_SavePointshop()

		if (self.Config.RewardAtEndOfRound and self.Config.NotifyAtEndOfRound) then
			local tot = total[ply:SteamID()]
			if (tot) then
				ply:SH_SendNotification(ps:LangFormat("int_earned_x_points_this_round", {points = ps:GetPriceString(tot.standard, tot.premium)}), true)
				total[ply:SteamID()] = nil
			end
		end
	end)
end

function MODULE:GiveReward(ply, rew)
	if (player.GetCount() < self.Config.MinPlayers) then
		return end

	if (isstring(rew)) then
		rew = self.Config[rew]
	end

	if (self.Config.RewardAtEndOfRound) then
		table.insert(pending, {ply = ply, rew = rew})
	else
		self:ProperGiveReward(ply, rew)
	end
end

function MODULE:GiveDelayedRewards()
	for _, rew in pairs (pending) do
		if (IsValid(rew.ply)) then
			self:ProperGiveReward(rew.ply, rew.rew)
		end
	end

	pending = {}
end

local roundstart = 0
function MODULE:TTTEndRound(winner)
	if (winner == WIN_INNOCENT) then
		for _, v in ipairs (player.GetAll()) do
			if (!playing[v:SteamID()] or v:IsSpec() or v:IsTraitor()) then
				continue end

			local det = v:IsDetective()
			self:GiveReward(v, det and "DetectiveWin" or "InnocentWin")

			if (v:Alive()) and (!v.IsGhost or !v:IsGhost()) then
				self:GiveReward(v, det and "DetectiveAliveBonus" or "InnocentAliveBonus")
			end

			if (v:GetCleanRound()) then
				self:GiveReward(v, "CleanRoundBonus")
			end

			if (CurTime() - roundstart <= self.Config.QuickRoundTime) then
				self:GiveReward(v, "QuickRoundBonus")
			end
		end
	elseif (winner == WIN_TRAITOR) then
		for _, v in ipairs (player.GetAll()) do
			if (!playing[v:SteamID()] or v:IsSpec() or !v:IsTraitor()) then
				continue end

			self:GiveReward(v, "TraitorWin")

			if (v:Alive()) and (!v.IsGhost or !v:IsGhost()) then
				self:GiveReward(v, "TraitorAliveBonus")
			end

			if (CurTime() - roundstart <= self.Config.QuickRoundTime) then
				self:GiveReward(v, "QuickRoundBonus")
			end
		end
	end

	self:GiveDelayedRewards()

	playing = {}
end

function MODULE:PlayerDeath(victim, inflictor, attacker)
	if (!victim.GetRole or !attacker:IsPlayer()) or (victim == attacker) or (attacker.IsGhost and attacker:IsGhost()) then
		return end

	local vic = victim:GetRole()
	local att = attacker:GetRole()

	if (att == ROLE_TRAITOR) then
		self:GiveReward(attacker, vic == ROLE_DETECTIVE and "DetectiveKilled" or "InnocentKilled")
	elseif (att == ROLE_DETECTIVE) then
		if (vic == ROLE_TRAITOR) then
			self:GiveReward(attacker, "TraitorKilledAsDetective")
		end
	elseif (att == ROLE_INNOCENT) then
		if (vic == ROLE_TRAITOR) then
			self:GiveReward(attacker, "TraitorKilledAsInnocent")
		end
	end
end

hook.Add("TTTBeginRound", "SH_POINTSHOP.IntegrationTTT", function()
	for _, v in ipairs (player.GetAll()) do
		if (!v:IsSpec()) then
			playing[v:SteamID()] = true
		end
	end
	roundstart = CurTime()
end)

hook.Add("TTTEndRound", "SH_POINTSHOP.IntegrationTTT", function(winner)
	MODULE:TTTEndRound(winner)
end)

hook.Add("PlayerDeath", "SH_POINTSHOP.IntegrationTTT", function(victim, inflictor, attacker)
	if (!ROLE_TRAITOR) then
		return end

	MODULE:PlayerDeath(victim, inflictor, attacker)
end)