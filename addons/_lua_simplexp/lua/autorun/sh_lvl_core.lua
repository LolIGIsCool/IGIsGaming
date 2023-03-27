local DEBUGMODE = false

local ModPower = 2
local ModMult = 30 * math.Clamp(SimpleXPConfig.LevelScale,0.01,100)

function SimpleXPCalculateXPToLevel(CurrentXP)
	return math.floor((CurrentXP^(1/ModPower))/ModMult)
end

function SimpleXPCalculateLevelToXP(CurrentLevel)
	if DEBUGMODE and SERVER then print("Calculating XP...") end
	return math.ceil(((CurrentLevel)*ModMult)^ModPower)
end

function SimpleXPGetXP(ply)
	if DEBUGMODE and SERVER then print("Getting XP...") end
	return ply:GetNWFloat("BurgerLevel",0)
end

function SimpleXPGetLevel(ply)
	if DEBUGMODE and SERVER then print("Getting Level...") end
	return SimpleXPCalculateXPToLevel(SimpleXPGetXP(ply))
end

function SimpleXPCheckRank(level)
	if SimpleXPConfig.EnableCustomRanks then
		if SimpleXPConfig.LevelCap < level then
			return SimpleXPConfig.CustomRanks[SimpleXPConfig.LevelCap]
		elseif SimpleXPConfig.CustomRanks[level] then
			return SimpleXPConfig.CustomRanks[level]
		else
			return SimpleXPConfig.CustomRanks[#SimpleXPConfig.CustomRanks] .. " Prestige " .. (level - #SimpleXPConfig.CustomRanks)
		end
	else
		return "Rank " .. level
	end
end
function SimpleReturnPercent(ply)
	local NextXP = SimpleXPCalculateLevelToXP(SimpleXPGetLevel(ply) + 1)
	local LastXP = SimpleXPGetXP(ply)
	local LastLvl = SimpleXPCalculateLevelToXP(SimpleXPGetLevel(ply))
	NextXP = NextXP - LastLvl
	LastXP = LastXP - LastLvl
	local Percent = LastXP/NextXP * 100
	return Percent
end
function SimpleXPGetKills()

	for i=1, 100 do
		local KillReward = 200
		local Kills = math.floor( SimpleXPCalculateLevelToXP(i) / KillReward )
		print("Rank: " .. i,Kills)
	end

end

--SimpleXPGetKills()

local meta = FindMetaTable("Player")

function meta:GetGlobalLevel()
    return SimpleXPGetLevel(self), SimpleReturnPercent(self)
end





