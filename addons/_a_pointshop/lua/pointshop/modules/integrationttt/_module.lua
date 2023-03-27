MODULE = {}

MODULE.ClassName = "integrationttt"
MODULE.Name = "Integration: Trouble in Terrorist Town"
MODULE.Description = "Adds Points rewards for actions in Trouble in Terrorist Town."

MODULE.Config = {
	-- Should points be given when the round ends or not?
	-- If not, players will get points as they kill etc.
	RewardAtEndOfRound = true,

	-- Send a message to the player telling them how many points they earned at the end of a round?
	NotifyAtEndOfRound = true,

	-- How many players must be connected for rewards to be activated?
	MinPlayers = 2,

	-- How long a round can last up to before a round is not considered for the QuickRoundBonus?
	QuickRoundTime = 120,

	-- Traitor rewards
	InnocentKilled = {standard = 100, premium = 0}, -- How much Points does a Traitor get for killing an Innocent?
	DetectiveKilled = {standard = 250, premium = 0}, -- How much Points does a Traitor get for killing a Detective?

	-- Innocent/Detective rewards
	TraitorKilledAsInnocent = {standard = 75, premium = 0}, -- How much Points does an Innocent get for killing a Traitor?
	TraitorKilledAsDetective = {standard = 150, premium = 0}, -- How much Points does a Detective get for killing a Traitor?

	-- Round end rewards
	InnocentWin = {standard = 100, premium = 0}, -- Points given to all Innocents if Innocents win.
	TraitorWin = {standard = 250, premium = 0}, -- Points given to all Traitors if Traitors win.
	DetectiveWin = {standard = 150, premium = 0}, -- Points given to all Detectives if Innocents win.

	InnocentAliveBonus = {standard = 100, premium = 0}, -- Bonus points for winning and being alive as Innocent.
	TraitorAliveBonus = {standard = 100, premium = 0}, -- Bonus points for winning and being alive as Traitor.
	DetectiveAliveBonus = {standard = 100, premium = 0}, -- Bonus points for winning and being alive as Traitor.

	CleanRoundBonus = {standard = 100, premium = 0}, -- Bonus for finishing a round without incurring a karma loss.
	QuickRoundBonus = {standard = 50, premium = 0}, -- Bonus for finishing a round quickly.

	-- Point multiplier depending on the player's group. Defaults to 1.
	GroupMultiplier = {
		["vip"] = 2, -- VIPs will earn 2x more points.
		["respected"] = 1.5,
	}
}

-- Hooks for the developer people
function MODULE:GetMultiplier(ply)
	local mult = self.Config.GroupMultiplier[ply:GetUserGroup()] or 1
	local hm = hook.Run("SH_POINTSHOP.IntegrationTTT.GetMultiplier", ply)
	if (hm) then
		mult = hm
	end

	return mult
end

if (SERVER) then
	include("sv_integrationttt.lua")
end

SH_POINTSHOP:RegisterModule(MODULE)
MODULE = nil