util.AddNetworkString("networkteamtblfull")
util.AddNetworkString("networkteamtbl")
util.AddNetworkString("networkcounttblfull")
util.AddNetworkString("networkhudmodel")
util.AddNetworkString("requestteamtbl")
util.AddNetworkString("igaddrank")
util.AddNetworkString("igremoverank")
util.AddNetworkString("igremoveregiment")
util.AddNetworkString("igupdaterank")
--util.AddNetworkString("dorainbowbullets")
TeamTable = {}

CountTable = {}
TempIGData = TempIGData or {}
local teamcounter = -1
local clearancePay = {
	["1"] = 100,
	["2"] = 150,
	["3"] = 200,
	["4"] = 250,
	["5"] = 300,
	["6"] = 350,
	["ALL ACCESS"] = 400,
	["AREA ACCESS"] = 200,
	["CLASSIFIED"] = 300
}

local eventpay = 400
local civilianpay = 300
----------------------------------------
--Only Used for Triple Credit events v
local clearancePayx3 = {
	["1"] = 400,
	["2"] = 400,
	["3"] = 500,
	["4"] = 500,
	["5"] = 500,
	["6"] = 600,
	["ALL ACCESS"] = 600,
	["AREA ACCESS"] = 450,
	["CLASSIFIED"] = 450
}

local eventpayx3 = 600
local civilianpayx3 = 500
----------------------------------------

function IGDEBUG(text)
	file.Append("igdebug.txt", "[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. text .. "\n")
	print(text)
end

function CreateTeam(teamtbl)
	if not istable(teamtbl) then
		ErrorNoHalt("Failed to create team WHAT THE FUCK TELL KUMO")
		IGDEBUG("Failed to create team WHAT THE FUCK TELL KUMO")

		return
	end

	teamtbl.Name = teamtbl.Name or ""
	teamtbl.Model = teamtbl.Model or ""
	teamtbl.Health = teamtbl.Health or 100
	teamtbl.Weapons = teamtbl.Weapons or {}
	teamtbl.Clearance = teamtbl.Clearance or "Unassigned"
	teamtbl.Colour = teamtbl.Colour or Color(255, 255, 255)
	teamtbl.Side = teamtbl.Side or 0
	teamtbl.Rank = teamtbl.Rank or 0
	teamtbl.OtherModels = teamtbl.OtherModels or {}
	teamtbl.Bodygroups = teamtbl.Bodygroups or ""
	teamtbl.Skin = teamtbl.Skin or 0
	teamtbl.RunSpeed = teamtbl.RunSpeed or 240
	teamtbl.WalkSpeed = teamtbl.WalkSpeed or 160
	teamtbl.Regiment = teamtbl.Regiment or ""
	teamtbl.RealName = teamtbl.RealName or teamtbl.Name
	teamcounter = teamcounter + 1
	teamtbl.Count = teamcounter

	CountTable[teamcounter] = {teamtbl.Regiment, teamtbl.Rank}

	team.SetUp(teamcounter, teamtbl.Name, teamtbl.Colour)

	if not TeamTable[teamtbl.Regiment] then
		TeamTable[teamtbl.Regiment] = {}
	end

	TeamTable[teamtbl.Regiment][teamtbl.Rank] = {}
	TeamTable[teamtbl.Regiment][teamtbl.Rank] = teamtbl

	if not util.IsModelLoaded(teamtbl.Model) then
		util.PrecacheModel(teamtbl.Model)
	end

	for k, v in pairs(teamtbl.OtherModels) do
		if not util.IsModelLoaded(v) then
			util.PrecacheModel(v)
		end
	end
end

for a, b in pairs(util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))) do
	for c, d in pairs(b) do
		IGDEBUG("[IG-GAMEMODE] Loading Job: " .. d.Name)
		CreateTeam(d)
	end
end

-- this is going to be balls
-- local teamtable = util.JSONToTable(file.Read("teamtablejson.txt", "DATA"))

-- for i=1, #teamtable do
-- 	for ii, #teamtable[i] do
-- 		local teamtbl = teamtable[i][ii]
-- 		teamtbl.Name = teamtbl.Name or ""
-- 		teamtbl.Model = teamtbl.Model or ""
-- 		teamtbl.Health = teamtbl.Health or 100
-- 		teamtbl.Weapons = teamtbl.Weapons or {}
-- 		teamtbl.Clearance = teamtbl.Clearance or "Unassigned"
-- 		teamtbl.Colour = teamtbl.Colour or Color(255, 255, 255)
-- 		teamtbl.Side = teamtbl.Side or 0
-- 		teamtbl.Rank = teamtbl.Rank or 0
-- 		teamtbl.OtherModels = teamtbl.OtherModels or {}
-- 		teamtbl.Bodygroups = teamtbl.Bodygroups or ""
-- 		teamtbl.Skin = teamtbl.Skin or 0
-- 		teamtbl.RunSpeed = teamtbl.RunSpeed or 240
-- 		teamtbl.WalkSpeed = teamtbl.WalkSpeed or 160
-- 		teamtbl.Regiment = teamtbl.Regiment or ""
-- 		teamtbl.RealName = teamtbl.RealName or teamtbl.Name
-- 		teamcounter = teamcounter + 1
-- 		teamtbl.Count = teamcounter

-- 		CountTable[teamcounter] = {teamtbl.Regiment, teamtbl.Rank}

-- 		team.SetUp(teamcounter, teamtbl.Name, teamtbl.Colour)

-- 		if not TeamTable[teamtbl.Regiment] then
-- 			TeamTable[teamtbl.Regiment] = {}
-- 		end

-- 		TeamTable[teamtbl.Regiment][teamtbl.Rank] = {}
-- 		TeamTable[teamtbl.Regiment][teamtbl.Rank] = teamtbl

-- 		if not util.IsModelLoaded(teamtbl.Model) then
-- 			util.PrecacheModel(teamtbl.Model)
-- 		end

-- 		for k, v in pairs(teamtbl.OtherModels) do
-- 			if not util.IsModelLoaded(v) then
-- 				util.PrecacheModel(v)
-- 			end
-- 		end
-- 	end
-- end

local function FixInconsistincies()
	for k, v in ipairs(player.GetAll()) do
		if v and v:IsPlayer() and v.igdata and v.igdata["regiment"] then
			v:SetTeam(v:GetJobTable().Count)
		end
	end

	for k, v in ipairs(player.GetAll()) do
		if v and v:IsPlayer() and v.igdata and v.igdata["regiment"] then
			gmod.GetGamemode():NetworkCountTBL(v)
		end
	end
end

FixInconsistincies()

if (not sql.TableExists("igdata")) then
	sql.Query("CREATE TABLE IF NOT EXISTS igdata ( steamid64 TEXT NOT NULL PRIMARY KEY, regiment TEXT, rank INTEGER, name TEXT, ip TEXT, wid TEXT );")
end

local meta = FindMetaTable("Player")

function meta:SetIGData(datatype, value)
	if not self:IsValid() then return end

	if not istable(datatype) then
		IGDEBUG("[IG-GAMEMODE] Setting " .. datatype .. " to " .. value .. " on " .. self:Nick() .. "")
	else
		IGDEBUG("[IG-GAMEMODE] Setting table value igdata on " .. self:Nick() .. "")
	end

	if not self.igdata then
		self.igdata = {}
	end

	if not istable(datatype) then
		self.igdata[datatype] = value
	else
		self.igdata["steamid64"] = datatype[1]
		self.igdata["regiment"] = datatype[2]
		self.igdata["rank"] = datatype[3]
		self.igdata["name"] = datatype[4]
		self.igdata["ip"] = datatype[5]
		self.igdata["wid"] = datatype[6]
	end

	if istable(datatype) then
		ig_fwk_db:PrepareQuery("REPLACE into igdata (steamid64, regiment, rank, name, ip, wid) values(?, ?, ?, ?, ?, ?)", {datatype[1], datatype[2], datatype[3], datatype[4], datatype[5], datatype[6]})
	else
		ig_fwk_db:PrepareQuery("UPDATE igdata SET " .. datatype .. " = '" .. sql.SQLStr(value, true) .. "' WHERE steamid64 = " .. self:SteamID64())
	end
end

function ManualSetIGData(steamid64, datatype, value)
	if not steamid64 or not datatype or not value then
		print("Manual Set IGDATA Failed")
	end

	if not tonumber(steamid64) then
		steamid64 = util.SteamIDTo64(steamid64)
	end

	ig_fwk_db:PrepareQuery("UPDATE igdata SET " .. datatype .. " = '" .. value .. "' WHERE steamid64 = " .. steamid64)
	IGDEBUG("Manually setting " .. datatype .. " to " .. value .. " on " .. steamid64)
end

function meta:GetIGData(datatype, default)
	if not self:IsValid() then return end
	if not self.igdata then return default end
	local val = self.igdata[datatype]
	if (val == nil) then return default end

	return val
end

function meta:IsSuperAdmin()
	return true
end

function meta:GetRank()
	return tonumber(self:GetIGData("rank", 0))
end

function meta:GetWebsiteID()
	return self:GetIGData("wid", "0000")
end

function meta:GetRegiment()
	return tostring(self:GetIGData("regiment", nil))
end

function meta:GetRankName()
	return tostring(TeamTable[self:GetRegiment()][self:GetRank()].Name) or "Unknown"
end

function meta:GetJobTable()
	return TeamTable[self:GetRegiment()][self:GetRank()]
end

function meta:SetHUDModel(model)
	net.Start("networkhudmodel")
	net.WriteString(model)
	net.Send(self)
end

timer.Create("fixsomemodels", 20, 0, function()
	for k, v in ipairs(player.GetAll()) do
		v:SetHUDModel(v:GetModel())
	end
end)

function meta:SetRank(rank)
	IGDEBUG("[IG-GAMEMODE] Setting rank of " .. self:Nick() .. " to " .. rank)
	self:SetIGData("rank", rank)
	self:SetTeam(TeamTable[self:GetRegiment()][rank].Count)
end

function meta:SetRegiment(regiment)
	IGDEBUG("[IG-GAMEMODE] Setting regiment of " .. self:Nick() .. " to " .. regiment)
	self:SetIGData("regiment", regiment)

	if TeamTable[regiment][0] then
		self:SetRank(0)
	else
		self:SetRank(1)
	end
end

function meta:GetClearance()
	return tostring(TeamTable[self:GetRegiment()][self:GetRank()].Clearance)
end

if not file.Exists("spawns.txt", "DATA") then
	file.Write("spawns.txt", util.TableToJSON({}))
end

local spawnTable = util.JSONToTable(file.Read("spawns.txt", "DATA"))

hook.Add("IGPlayerSay", "SetSpawn", function(ply, text)
	if not (ply:IsSuperAdmin() or ply:IsUserGroup("Senior Event Master") or ply:IsUserGroup("Lead Event Master") or ply:IsUserGroup("admin")) then return end
	text = string.Explode(" ", text)

	if string.lower(text[1]) == "!setspawn" or string.lower(text[1]) == "/setspawn" then
		if text[2] == nil then return "" end
		local t = string.lower(table.concat(text, " ", 2))
		spawnTable[game.GetMap()] = spawnTable[game.GetMap()] or {}
		spawnTable[game.GetMap()][t] = ply:GetPos()
		file.Write("spawns.txt", util.TableToJSON(spawnTable))
		ply:PrintMessage(HUD_PRINTTALK, "[UPDATED SPAWN]")
		ply:PrintMessage(HUD_PRINTTALK, string.upper(t))

		return ""
	end
end)

hook.Add("IGPlayerSay", "DelSpawn", function(ply, text)
	if not ply:IsSuperAdmin() then return end
	text = string.Explode(" ", text)

	if string.lower(text[1]) == "!delspawn" or string.lower(text[1]) == "/delspawn" then
		if text[2] == nil then return "" end
		local t = string.lower(table.concat(text, " ", 2))

		if string.lower(t) == "default" then
			ply:PrintMessage(HUD_PRINTTALK, "[DEFAULT SPAWN CANNOT BE DELETED]")

			return ""
		end

		spawnTable[game.GetMap()] = spawnTable[game.GetMap()] or {}
		spawnTable[game.GetMap()][t] = nil
		file.Write("spawns.txt", util.TableToJSON(spawnTable))
		ply:PrintMessage(HUD_PRINTTALK, "[DELETED SPAWN]")
		ply:PrintMessage(HUD_PRINTTALK, string.upper(t))

		return ""
	end
end)

function GM:CheckPassword(steamid, networkid, server_password, password, name)
	if (server_password ~= "") then
		if (server_password ~= password) then return false end
	end

	TempIGData[steamid] = {}

	ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE steamid64 = " .. steamid, {}, function(query, status, data)
		local data = data[1]

		if data and data.regiment and isstring(data.regiment) and status then
			for k, v in pairs(data) do
				if TempIGData[steamid] then
					TempIGData[steamid][k] = v
				end
			end
		else
			TempIGData[steamid] = {
				["steamid64"] = steamid,
				["regiment"] = "Recruit",
				["rank"] = 0,
				["name"] = name,
				["ip"] = networkid,
				["wid"] = "0000"
			}

			ig_fwk_db:PrepareQuery("REPLACE into igdata (steamid64, regiment, rank, name, ip, wid) values(?, ?, ?, ?, ?, ?)", {steamid, "Recruit", 0, name, networkid, "0000"})
		end
	end)

	return true
end

gameevent.Listen("player_disconnect")

hook.Add("player_disconnect", "memoryleakfix", function(data)
	local steamid = util.SteamIDTo64(data.networkid)

	if TempIGData[steamid] then
		TempIGData[steamid] = nil
	end

	if timer.Exists(steamid .. "salarytimer") then
		timer.Remove(steamid .. "salarytimer")
	end

	timer.Remove(util.SteamIDFrom64(steamid) .. "RandomWeaponTimer")
end)

function GM:PlayerAuthed(ply)
	IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " PlayerAuthed calling")
	ply.igdata = table.Copy(TempIGData[ply:SteamID64()])
	TempIGData[ply:SteamID64()] = nil
end

function GM:PlayerInitialSpawn(ply)
	if not ply.igdata then
		-- ply:Kick("Your player has not initialized properly, rejoin and contact Kumo/Tank if this is consistent!")
		IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " PlayerAuth failed forcing retry.")
		ply:ConCommand("retfix")

		return
	end

	IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " PlayerInitialSpawn calling")

	if ply:GetRegiment() ~= nil then
		local tbl = TeamTable[ply:GetRegiment()]

		if not tbl then
			ply:SetTeam(TeamTable["Recruit"][0].Count)

			ply:SetIGData({ply:SteamID64(), "Recruit", 0, ply:Nick(), ply:IPAddress(), "0000"})

			ply:ChatPrint("[IG-DATA] The server could not locate your regiment it may have been deleted. Contact a staff member")

			return
		elseif not tbl[ply:GetRank()] then
			ply:SetTeam(tbl[1].Count)

			ply:SetIGData({ply:SteamID64(), ply:GetRegiment(), 1, ply:Nick(), ply:IPAddress(), "0000"})

			ply:ChatPrint("[IG-DATA] The server could not locate your rank in your regiment it may have been deleted. Contact a staff member")

			return
		end

		ply:SetTeam(tbl[ply:GetRank()].Count)
		ply:ConCommand("cl_tfa_hud_crosshair_color_team 0")
		ply:Spawn()
		ply.oocmute = false

		if type(tbl[ply:GetRank()].Model) == "table" then
			local randmodel = table.Random(tbl[ply:GetRank()].Model)
			ply:SetModel(randmodel)
			ply:SetHUDModel(randmodel)
		else
			ply:SetModel(tbl[ply:GetRank()].Model)
			ply:SetHUDModel(tbl[ply:GetRank()].Model)
		end

		ply:SetBodyGroups(tbl[ply:GetRank()].Bodygroups)
		ply:SetSkin(tonumber(tbl[ply:GetRank()].Skin))
	else
		ply:SetIGData({ply:SteamID64(), "Recruit", 0, ply:OldNick(), ply:IPAddress(), "0000"})

		ply:SetRegiment("Recruit")
		ply:SetTeam(TeamTable["Recruit"][0].Count)
		ply:SetModel(TeamTable["Recruit"][0].Model)
		ply:SetHUDModel(TeamTable["Recruit"][0].Model)
		ply:Spawn()
	end

	ply:SetIGData("ip", ply:IPAddress())

	if ply:GetWebsiteID() == "NULL" or not ply:GetWebsiteID() then
		ply:SetIGData("wid", "0000")
	end

	timer.Create(ply:SteamID64() .. "salarytimer", 600, 0, function()
		if not IsValid(ply) then return end
		if player.GetCount() < 20 then return end

		if ply:GetRegiment() == "Event" then
			ply:SH_AddPremiumPoints(eventpay)
			ply:ChatPrint("You recieved " .. eventpay .. " credits for being an Event Character.")
            --------------x3 below
			--ply:SH_AddPremiumPoints(eventpayx3)
			--ply:SH_AddStandardPoints(eventpayx3)
			--ply:ChatPrint("You recieved " .. eventpayx3 .. " credits for being an Event Character. Bonus Creds/Points!")
		elseif ply:GetRegiment() == "Civilian" then
			ply:SH_AddPremiumPoints(civilianpay)
			ply:ChatPrint("You recieved " .. civilianpay .. " credits for serving the Empire.")
            --------------x3 below
			--ply:SH_AddPremiumPoints(civilianpayx3)
			--ply:SH_AddStandardPoints(civilianpayx3)
			--ply:ChatPrint("You recieved " .. civilianpayx3 .. " credits for being a loyal Civilian of the Empire. Bonus Creds/Points!")
		--elseif clearancePay[ply:GetClearance()] then
		elseif clearancePay[ply:GetClearance()] then
			ply:SH_AddPremiumPoints(clearancePay[ply:GetClearance()])
			ply:ChatPrint("You recieved " .. clearancePay[ply:GetClearance()] .. " credits for serving the Empire.")
            --------------x3 below
			--ply:SH_AddPremiumPoints(clearancePayx3[ply:GetClearance()])
			--ply:SH_AddStandardPoints(clearancePayx3[ply:GetClearance()])
			--ply:ChatPrint("You recieved " .. clearancePayx3[ply:GetClearance()] .. " credits for serving the Empire. Bonus Credits!")
		end
	end)

	-- Scale DT to be big fellas when they spawn.
	if (ply:GetRegiment() == "Death Trooper") then
		RunConsoleCommand("ulx", "scale", "$" .. ply:SteamID(), "1.08")
	end
    
    if (ply:GetRegiment() == "Imperial High Command" && ply:Nick() == "Vader") then
		RunConsoleCommand("ulx", "scale", "$" .. ply:SteamID(), "1.18")
	end

end

local fistsblacklist = {}

local fistblacklistreg = {"Recruit"}

--local hightierwepslist = {"rw_sw_tusken_cycler", "weapon_squadshield_arm", "rw_sw_nade_stun", "rw_sw_nade_stun", "rw_sw_nade_stun", "rw_sw_nade_stun", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_bling", "rw_sw_nt242c", "rw_sw_nt242c", "rw_sw_nt242c", "rw_sw_nt242c", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "tfa_swch_dc15a", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_x8", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_dc15se", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact", "rw_sw_nade_impact"}

--|OP Tier|--
-- Cycler Rifle
-- Squad Shield
--|High Tier|--
-- Stun Grenade
-- DC-15 A [Bling]
-- NT-242c
--|Medium Tier|--
-- DC-15A
-- X8 Night Sniper
-- DC-15SE
-- Incendiary/Impact cause incin broke Grenade
--local hightierwepspretprint = {
--	["tfa_swch_dc15a_bling"] = "DC-15A [Bling]",
--	["rw_sw_nade_stun"] = "Stun Grenade",
--	["weapon_squadshield_arm"] = "Squad Shield",
--	["rw_sw_nt242c"] = "NT-242c",
--	["rw_sw_tusken_cycler"] = "Cycler Rifle",
--	["tfa_swch_dc15a"] = "DC-15A",
--	["rw_sw_x8"] = "X-8 Night Sniper",
--	["rw_sw_dc15se"] = "DC-15 SE",
--	["rw_sw_nade_impact"] = "Impact Grenade"
--}

--["rw_sw_nade_incendiary"] = "Incendiary Grenade"
--[[
if not file.Exists("rainbowbullets.txt", "DATA") then
	file.Write("rainbowbullets.txt", util.TableToJSON({}))
end

local rainbowTable = util.JSONToTable(file.Read("rainbowbullets.txt", "DATA")) or {}
local effectnumber = 1

hook.Add("Initialize", "WaitForInitEffects", function()
	timer.Create("ChangeEffectsNomber", 0.25, 0, function()
		effectnumber = effectnumber + 1

		if effectnumber == 4 then
			effectnumber = 1
		end
	end)
end)

function StartRainbowBullets(ply)
	local effectslist = {"effect_sw_laser_green", "effect_sw_laser_red", "effect_sw_laser_white"}

	net.Start("dorainbowbullets")
	net.Send(ply)

	timer.Create("StartRainbowBullets" .. ply:SteamID(), 0.25, 0, function()
		if ply:GetActiveWeapon() and ply:GetActiveWeapon():IsValid() then
			ply:GetActiveWeapon().TracerName = effectslist[effectnumber]
		end
	end)
end


hook.Add("IGPlayerSay", "AddRainbowBullets", function(ply, text)
	if not ply:IsAdmin() then return end
	text = string.Explode(" ", text)

	if string.lower(text[1]) == "!addrainbow" or string.lower(text[1]) == "/addrainbow" then
		table.insert(rainbowTable, text[2])
		file.Write("rainbowbullets.txt", util.TableToJSON(rainbowTable))
		ply:ChatPrint("You have added " .. text[2] .. " to the rainbow bullets table, this action has been logged.")
		file.Append("rainbowbulletslog.txt", ply:Nick() .. " added " .. text[2])

		return ""
	end
end)
]]--

-- This function is used to disable player to player collisions for a given amount of time
-- after spawning on a given player. If this is causing errors, contact HenDoge.
local NoCollideOnSpawn = function (ply, time)
	local oldCollision = ply:GetCollisionGroup() or COLLISION_GROUP_PLAYER
	ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	if(not timer.Exists(ply:SteamID() .. "_NoCollideSpawn")) then
		timer.Create(ply:SteamID() .. "_NoCollideSpawn", time, 1, function()
			ply:SetCollisionGroup(oldCollision)
		end)
	end
end

function GM:PlayerSpawn(ply)
	IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " PlayerSpawn calling")
	if ply:GetNWBool("Flying" .. ply:GetNWString("LastVech", self.Vehicle), false) then return end

	--[[if table.HasValue(rainbowTable, ply:SteamID()) or table.HasValue(rainbowTable, ply:SteamID64()) then
		StartRainbowBullets(ply)
	end]]--
    
    local movespeed, runspeed = ply:GetJobTable().WalkSpeed, ply:GetJobTable().RunSpeed

	ply:SetRunSpeed(runspeed)
	ply:SetWalkSpeed(movespeed)

	if ply:IsAdmin() then
		ply:Give("weapon_physgun", true)
		ply:Give("gmod_tool", true)
	end

	ply.dmgtime = 0
	ply:SetupHands()

	if ply:GetRegiment() then
		if spawnTable[game.GetMap()] and ply:GetRegiment() == "439th Stormtroopers" and game.GetMap() == "rp_stardestroyer_v2_4_inf" then
			local num = math.random(1, 4)
			ply:SetPos(spawnTable[game.GetMap()][string.lower(ply:GetRegiment() .. tostring(num))])
		elseif spawnTable[game.GetMap()] and spawnTable[game.GetMap()][string.lower(ply:GetRegiment())] then
			ply:SetPos(spawnTable[game.GetMap()][string.lower(ply:GetRegiment())])
		elseif spawnTable[game.GetMap()] and spawnTable[game.GetMap()]["default"] then
			num = math.random(1, 4)

			if num == 1 then
				ply:SetPos(spawnTable[game.GetMap()]["default"])
			else
				if spawnTable[game.GetMap()][string.lower("default" .. tostring(num))] then
					ply:SetPos(spawnTable[game.GetMap()][string.lower("default" .. tostring(num))])
				else
					ply:SetPos(spawnTable[game.GetMap()]["default"])
				end
			end
		end
	end

	if ply:GetRegiment() ~= CountTable[ply:Team()][1] or ply:GetRank() ~= CountTable[ply:Team()][2] then
		ply:SetTeam(ply:GetJobTable().Count)
	end

	if ply:GetRegiment() ~= nil then
		local tbl = TeamTable[ply:GetRegiment()][ply:GetRank()]

		if type(tbl.Model) == "table" then
			local randmodel = table.Random(tbl.Model)
			ply:SetModel(randmodel)
			ply:SetHUDModel(randmodel)
		else
			ply:SetModel(tbl.Model)
			ply:SetHUDModel(tbl.Model)
		end
        
        local iAccidentallyDeletedThis = ply:GetJobTable().Health;
        
        ply:SetMaxHealth(iAccidentallyDeletedThis);
        ply:SetHealth(iAccidentallyDeletedThis);

		local weps = tbl.Weapons

		for i = 1, #weps do
			ply:Give(weps[i], true)
		end

		--if ply:GetNWInt("igprogressu", 0) >= 4 then
		--    local randweapon = table.Random(hightierwepslist)
		--    ply:Give(randweapon, true)
		--    ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
		--end
--		if ply:GetNWInt("igprogressu", 0) >= 4 then
			--[[if not timer.Exists(ply:SteamID() .. "RandomWeaponTimer") then
				timer.Create(ply:SteamID() .. "RandomWeaponTimer", 300, 1, function()
					ply:PrintMessage(HUD_PRINTTALK, "You will now receive a random weapon on respawn")
					timer.Remove(ply:SteamID() .. "RandomWeaponTimer")
				end)

				local randweapon = table.Random(hightierwepslist)
				timer.Create(ply:SteamID() .. "RandomWeaponGiveTimer", 15, 1, function()
				ply:Give(randweapon, true)
				ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
                timer.Remove(ply:SteamID() .. "RandomWeaponGiveTimer")
				end)
			elseif timer.Exists(ply:SteamID() .. "RandomWeaponTimer") then
				ply:ChatPrint("Your random weapon is still on cooldown!")
			end]]--
--			if ply:GetNWInt("igRandomWeaponTime", 0) < SysTime() then
--				local randweapon = table.Random(hightierwepslist)
--				ply:Give(randweapon, true)
--				ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
--				ply:SetNWInt("igRandomWeaponTime", math.Round(SysTime(), 0) + 300 )
--			else
--				ply:ChatPrint("Your random weapon is still on cooldown!")
--			end
--		end

		ply:Give("weapon_empty_hands", true)
		ply:Give("climb_swep2", true)
		ply:Give("comlink_swep", true)
		ply:Give("cross_arms_swep", true)
		ply:Give("cross_arms_infront_swep", true)
		ply:Give("point_in_direction_swep", true)
		ply:Give("salute_swep", true)
		ply:Give("surrender_animation_swep", true)
		--ply:Give("bkeycard", true)
		local clearance = ply:GetJobTable().Clearance

		local clearancetable = {
			["3"] = true,
			["4"] = true,
			["5"] = true,
			["6"] = true,
			["ALL ACCESS"] = true
		}

		if clearancetable[clearance] then
			ply:Give("weapon_rpw_binoculars_nvg", true)
		end

		if not table.HasValue(fistsblacklist, ply:SteamID()) and not table.HasValue(fistblacklistreg, ply:GetRegiment()) then
			ply:Give("imperialarts_bludgeon_fists", true)
		end

		weps = ply:GetWeapons()
		ply:StripAmmo()

		for i = 1, #weps do
			if weps[i]:GetPrimaryAmmoType() == "RPG_Round" then
				ply:GiveAmmo(3, weps[i]:GetPrimaryAmmoType(), true)
			end

			if game.GetAmmoName(weps[i]:GetPrimaryAmmoType()) == "standard_battery" then
				ply:GiveAmmo(weps[i]:GetMaxClip1() * 3, "standard_battery", true)
			end

			if game.GetAmmoName(weps[i]:GetPrimaryAmmoType()) == "heavy_battery" then
				ply:GiveAmmo(weps[i]:GetMaxClip1() * 3, "heavy_battery", true)
			end

			if game.GetAmmoName(weps[i]:GetPrimaryAmmoType()) == "light_battery" then
				ply:GiveAmmo(weps[i]:GetMaxClip1() * 3, "light_battery", true)
			end

			if game.GetAmmoName(weps[i]:GetPrimaryAmmoType()) == "high_power_battery" then
				ply:GiveAmmo(weps[i]:GetMaxClip1() * 3, "high_power_battery", true)
			end

			weps[i]:SetClip1(weps[i]:GetMaxClip1())
		end

		if ply:GetNWInt("igprogressc", 0) >= 7 then
			ply:GiveAmmo(60, "light_battery", false)
			ply:GiveAmmo(120, "standard_battery", false)
			ply:GiveAmmo(340, "heavy_battery", false)
			ply:GiveAmmo(26, "high_power_battery", false)
			ply:GiveAmmo(1, "RPG_Round", false)
			ply:GiveAmmo(1, "grenade", false)
		else
			ply:GiveAmmo(20, "light_battery", false)
			ply:GiveAmmo(40, "standard_battery", false)
			ply:GiveAmmo(100, "heavy_battery", false)
			ply:GiveAmmo(9, "high_power_battery", false)
		end
	end

	NoCollideOnSpawn(ply, 5) -- Disable player to player collisions for 5 seconds after spawning.
end

function GM:PlayerSetHandsModel(ply, ent)
	ent:SetModel("models/banks/ig/imperial/hands/st_hands.mdl")
end

hook.Add("IGPlayerSay", "swapchatv2", function(ply, str)
	if (string.lower(str) == "!oldshitswap") then
		local PlyTeamRefa = TeamTable[ply:GetRegiment()][ply:GetRank()].OtherModels
		local PlyModelRef = ply:GetModel()

		if not PlyTeamRefa then
			ply:ChatPrint("You do not have any other models to swap to.")

			return
		end

		if PlyModelRef == TeamTable[ply:GetRegiment()][ply:GetRank()].Model and PlyTeamRefa[1] ~= nil then
			ply:SetModel(PlyTeamRefa[1])
			ply:SetHUDModel(PlyTeamRefa[1])
		elseif PlyModelRef == PlyTeamRefa[1] and PlyTeamRefa[2] ~= nil then
			ply:SetModel(PlyTeamRefa[2])
			ply:SetHUDModel(PlyTeamRefa[2])
		elseif PlyModelRef == PlyTeamRefa[2] and PlyTeamRefa[3] ~= nil then
			ply:SetModel(PlyTeamRefa[3])
			ply:SetHUDModel(PlyTeamRefa[3])
		elseif PlyModelRef == PlyTeamRefa[3] and PlyTeamRefa[4] ~= nil then
			ply:SetModel(PlyTeamRefa[4])
			ply:SetHUDModel(PlyTeamRefa[4])
		elseif PlyModelRef == PlyTeamRefa[4] and PlyTeamRefa[5] ~= nil then
			ply:SetModel(PlyTeamRefa[5])
			ply:SetHUDModel(PlyTeamRefa[5])
		elseif PlyModelRef == PlyTeamRefa[5] and PlyTeamRefa[6] ~= nil then
			ply:SetModel(PlyTeamRefa[6])
			ply:SetHUDModel(PlyTeamRefa[6])
		elseif PlyModelRef == PlyTeamRefa[6] and PlyTeamRefa[7] ~= nil then
			ply:SetModel(PlyTeamRefa[7])
			ply:SetHUDModel(PlyTeamRefa[7])
		elseif PlyModelRef == PlyTeamRefa[7] and PlyTeamRefa[8] ~= nil then
			ply:SetModel(PlyTeamRefa[8])
			ply:SetHUDModel(PlyTeamRefa[8])
		else
			ply:SetModel(TeamTable[ply:GetRegiment()][ply:GetRank()].Model)
			ply:SetHUDModel(TeamTable[ply:GetRegiment()][ply:GetRank()].Model)
		end
	end
end)

hook.Add("IGPlayerSay", "PlayerSaberLolol", function(ply, txt)
	if string.lower(txt) == "!saber" then
		local saberlvl = ply:GetNWInt("saberlevel", 0)

		if saberlvl == 0 then
			ply:SetNWInt("saberlevel", 1)
			ply:ChatPrint("Corrupted Effect Applied, this has been logged so make sure you have permission.")
		elseif saberlvl == 1 then
			ply:SetNWInt("saberlevel", 2)
			ply:ChatPrint("Discharge/Flame Effect Applied, this has been logged so make sure you have permission.")
		elseif saberlvl == 2 then
			ply:SetNWInt("saberlevel", 0)
			ply:ChatPrint("Saber Effects Removed.")
		end
	end
end)

net.Receive("requestteamtbl", function(len, ply)
	IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " requesting teamtbl")
	if ply.teamtblcooldown then return end
	ply.teamtblcooldown = true

	timer.Simple(10, function()
		ply.teamtblcooldown = false
	end)

	IGDEBUG("[IG-GAMEMODE] Sending teamtbl to " .. ply:Nick())
	gmod.GetGamemode():NetworkTeamTBL(ply)
	IGDEBUG("[IG-GAMEMODE] Sending countbl to " .. ply:Nick())
	gmod.GetGamemode():NetworkCountTBL(ply)
	IGDEBUG("[IG-GAMEMODE] " .. ply:Nick() .. " sending finished")
end)

net.Receive("igremoveregiment", function(len, ply)
	if not ply:IsSuperAdmin() then return end
	local regiment = net.ReadString()

	if not TeamTable[regiment] then
		ply:ChatPrint("Regiment does not exist")

		return
	end

	if regiment == "Recruit" or regiment == "439th Stormtroopers" then
		ply:ChatPrint("You cannot delete the default regiments, speak to kumo if you need to!")

		return
	end

	for k, v in pairs(player.GetAll()) do
		if v:GetRegiment() == regiment then
			v:ChatPrint("Your regiment has been deleted, Contact management for more information.")
			v:SetRegiment("439th Stormtroopers")
		end
	end

	ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE regiment = " .. regiment, {}, function(query, status, data)
		if data then
			for k, v in pairs(data) do
				if player.GetBySteamID64(v.steamid64) then continue end
				ig_fwk_db:PrepareQuery("REPLACE INTO igdata ( steamid64, regiment, rank, name ) VALUES ( " .. sql.SQLStr(v.steamid64) .. ", " .. sql.SQLStr("439th Stormtroopers") .. ", " .. sql.SQLStr(1) .. ", " .. sql.SQLStr(v.name) .. " )", {}, function() end)
			end
		end
	end)

	TeamTable[regiment] = nil
	file.Write("teamtablejson.txt", util.TableToJSON(TeamTable))
	net.Start("networkteamtbl")
	net.WriteString("remover")
	net.WriteString(regiment)
	net.Broadcast()
	ply:ChatPrint("REGIMENT DELETED")

	timer.Simple(1, function()
		net.Start("UpdateMenu")
		net.Broadcast()
	end)
end)

net.Receive("igremoverank", function(len, ply)
	if not ply:IsSuperAdmin() then return end
	local regiment = net.ReadString()
	local rank = net.ReadUInt(8)

	if not TeamTable[regiment] then
		ply:ChatPrint("Regiment does not exist")

		return
	end

	if not TeamTable[regiment][rank] then
		ply:ChatPrint("Rank does not exist")

		return
	end

	if regiment == "Recruit" then
		ply:ChatPrint("You cannot the default rank, speak to kumo if you need to for whatever reason")

		return
	end

	if rank == 1 then
		ply:ChatPrint("You cannot delete the lowest rank in the regiment, just delete the regiment!")

		return
	end

	if TeamTable[regiment][rank + 1] then
		ply:ChatPrint("You must delete the rank(s) that are above this rank first otherwise the continuity will be ruined")

		return
	end

	for k, v in pairs(player.GetAll()) do
		if v:GetRegiment() == regiment and v:GetRank() == rank then
			v:ChatPrint("Your rank has been deleted, Contact management for more information.")
			v:SetRank(v:GetRank() - 1)
		end
	end

	ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE regiment='" .. regiment .. "' AND rank='" .. rank .. "'", {}, function(query, status, data)
		if data then
			for k, v in pairs(data) do
				if player.GetBySteamID64(v.steamid64) then continue end
				ig_fwk_db:PrepareQuery("REPLACE INTO igdata ( steamid64, regiment, rank, name ) VALUES ( " .. sql.SQLStr(v.steamid64) .. ", " .. sql.SQLStr(regiment) .. ", " .. sql.SQLStr(rank - 1) .. ", " .. sql.SQLStr(v.name) .. " )", {}, function() end)
			end
		end
	end)

	TeamTable[regiment][rank] = nil
	file.Write("teamtablejson.txt", util.TableToJSON(TeamTable))
	net.Start("networkteamtbl")
	net.WriteString("remover2")
	net.WriteString(regiment)
	net.WriteUInt(rank, 8)
	net.Broadcast()
	ply:ChatPrint("RANK DELETED")

	timer.Simple(1, function()
		net.Start("UpdateMenu")
		net.Broadcast()
	end)
end)

net.Receive("igupdaterank", function(len, ply)
	if not ply:IsSuperAdmin() then return end
	local realregiment = net.ReadString()
	local realrank = net.ReadUInt(8)
	local name = net.ReadString()
	local realname = net.ReadString()
	local regiment = net.ReadString()
	local model = net.ReadString()
	local colorreg = net.ReadColor()
	local health = net.ReadUInt(32)
	local weapons = net.ReadTable()
	local clearance = net.ReadString()
	local side = net.ReadUInt(8)
	local rank = net.ReadUInt(8)
	local othermodels = net.ReadTable()
	local bodygroups = net.ReadString()
	local skin = net.ReadUInt(8)
	local rmovespeed = net.ReadUInt(32)
	local movespeed = net.ReadUInt(32)
	local ClearanceCards = net.ReadTable()

	if realregiment ~= regiment then
		ply:ChatPrint("Just make a new rank in a new regiment instead of changing the regiment name")

		return
	end

	if realrank ~= rank then
		ply:ChatPrint("You can't change the value of the roles rank without ruining continuity, just change the names of the preceeding ranks")

		return
	end

	if not isstring(name) then
		ply:ChatPrint("Invalid variable: Name (not string or nil)")

		return
	end

	if not isstring(realname) then
		ply:ChatPrint("Invalid variable: Real Name (not string or nil)")

		return
	end

	if not isstring(model) and string.sub(model, string.len(model) - 3, string.len(model)) == ".mdl" then
		ply:ChatPrint("Invalid variable: Model (not string, not model or nil)")

		return
	end

	if not IsColor(colorreg) then
		ply:ChatPrint("Invalid variable: Color (not color or nil)")

		return
	end

	if not isnumber(health) then
		ply:ChatPrint("Invalid variable: Health (not number or nil)")
	end

	if not istable(weapons) then
		ply:ChatPrint("Invalid variable: Weapons (not table or nil)")
	end

	if not isstring(clearance) then
		ply:ChatPrint("Invalid variable: Clearance (not string or nil)")

		return
	end

	if not isnumber(side) then
		ply:ChatPrint("Invalid variable: Side (not number or nil)")
	end

	if not istable(othermodels) then
		ply:ChatPrint("Invalid variable: Other Models (not table or nil)")
	end

	if not isstring(bodygroups) then
		ply:ChatPrint("Invalid variable: Bodygroups (not string or nil)")

		return
	end

	if not isnumber(skin) then
		ply:ChatPrint("Invalid variable: Skin (not number or nil)")

		return
	end

	if not isnumber(rmovespeed) then
		ply:ChatPrint("Invalid variable: Run Speed (not number or nil)")

		return
	end

	if not isnumber(movespeed) then
		ply:ChatPrint("Invalid variable: Move Speed (not number or nil)")

		return
	end

	if not TeamTable[regiment] then
		ply:ChatPrint("Regiment does not exist")

		return
	end

	if not TeamTable[regiment][rank] then
		ply:ChatPrint("Rank does not exist in that regiment")

		return
	end

	ulx.fancyLogAdmin(ply, "#A made changes to #s (rank #s)", regiment, rank)

	TeamTable[regiment][rank].Name = name
	TeamTable[regiment][rank].RealName = realname
	TeamTable[regiment][rank].Model = model
	TeamTable[regiment][rank].Colour = colorreg
	TeamTable[regiment][rank].Health = health
	TeamTable[regiment][rank].Weapons = table.Copy(weapons)
	TeamTable[regiment][rank].Clearance = clearance
	TeamTable[regiment][rank].Side = side
	TeamTable[regiment][rank].OtherModels = table.Copy(othermodels)
	TeamTable[regiment][rank].Bodygroups = bodygroups
	TeamTable[regiment][rank].Skin = skin
	TeamTable[regiment][rank].WalkSpeed = movespeed
	TeamTable[regiment][rank].RunSpeed = rmovespeed
	TeamTable[regiment][rank].ClearanceCards = table.Copy(ClearanceCards)

	for k, v in ipairs(player.GetAll()) do
		if v:GetRegiment() ~= regiment or v:GetRank() ~= rank then continue end
		v:SetModel(model)
		v:SetMaxHealth(health)
		v:SetBodyGroups(bodygroups)
		v:SetSkin(skin)
		v:SetWalkSpeed(movespeed)
		v:SetRunSpeed(rmovespeed)
	end

	team.SetUp(TeamTable[regiment][rank].Count, name, colorreg)
	ply:ChatPrint("RANK UPDATED")
	file.Write("teamtablejson.txt", util.TableToJSON(TeamTable))
	net.Start("networkteamtbl")
	net.WriteString("updater")
	net.WriteString(regiment)
	net.WriteUInt(rank, 8)
	net.WriteTable(TeamTable[regiment][rank])
	net.Broadcast()

	timer.Simple(1, function()
		net.Start("UpdateMenu")
		net.Broadcast()
	end)
end)

net.Receive("igaddrank", function(len, ply)
	if not ply:IsSuperAdmin() then return end
	local name = net.ReadString()
	local realname = net.ReadString()
	local regiment = net.ReadString()
	local model = net.ReadString()
	local colorreg = net.ReadColor()
	local health = net.ReadUInt(32)
	local weapons = net.ReadTable()
	local clearance = net.ReadString()
	local side = net.ReadUInt(8)
	local rank = net.ReadUInt(8)
	local othermodels = net.ReadTable()
	local bodygroups = net.ReadString()
	local skin = net.ReadUInt(8)
	local rmovespeed = net.ReadUInt(32)
	local movespeed = net.ReadUInt(32)
	local ClearanceCards = net.ReadTable()

	if not isstring(name) then
		ply:ChatPrint("Invalid variable: Name (not string or nil)")

		return
	end

	if not isstring(realname) then
		ply:ChatPrint("Invalid variable: Real Name (not string or nil)")

		return
	end

	if not isstring(model) and string.sub(model, string.len(model) - 3, string.len(model)) == ".mdl" then
		ply:ChatPrint("Invalid variable: Model (not string, not model or nil)")

		return
	end

	if not IsColor(colorreg) then
		ply:ChatPrint("Invalid variable: Color (not color or nil)")

		return
	end

	if not isnumber(health) then
		ply:ChatPrint("Invalid variable: Health (not number or nil)")

		return
	end

	if not istable(weapons) then
		ply:ChatPrint("Invalid variable: Weapons (not table or nil)")

		return
	end

	if not isstring(clearance) then
		ply:ChatPrint("Invalid variable: Clearance (not string or nil)")

		return
	end

	if not isnumber(side) then
		ply:ChatPrint("Invalid variable: Side (not number or nil)")

		return
	end

	if not istable(othermodels) then
		ply:ChatPrint("Invalid variable: Other Models (not table or nil)")

		return
	end

	if not isstring(bodygroups) then
		ply:ChatPrint("Invalid variable: Bodygroups (not string or nil)")

		return
	end

	if not isnumber(skin) then
		ply:ChatPrint("Invalid variable: Skin (not number or nil)")

		return
	end

	if TeamTable[regiment] and TeamTable[regiment][rank] then
		ply:ChatPrint("THAT RANK ALREADY EXISTS IN THAT REGIMENT, JUST EDIT IT IN THE OTHER TAB")

		return
	end

	if not TeamTable[regiment] and rank ~= 1 then
		ply:ChatPrint("The starting rank of a regiment must be 1")

		return
	end

	if rank ~= 1 and TeamTable[regiment] and not TeamTable[regiment][rank - 1] then
		ply:ChatPrint("Ranks numbers must be in sequential order, make the RANK value +1 of the previous rank")

		return
	end

	if not TeamTable[regiment] then
		ply:ChatPrint("CREATING NEW REGIMENT :" .. regiment)
		TeamTable[regiment] = {}
	end

	ply:ChatPrint("CREATING NEW RANK [" .. rank .. "] in REGIMENT " .. regiment)
	TeamTable[regiment][rank] = {}
	TeamTable[regiment][rank].Name = name
	TeamTable[regiment][rank].Rank = rank
	TeamTable[regiment][rank].Regiment = regiment
	TeamTable[regiment][rank].RealName = realname
	TeamTable[regiment][rank].Model = model
	TeamTable[regiment][rank].Colour = colorreg
	TeamTable[regiment][rank].Health = health
	TeamTable[regiment][rank].Weapons = table.Copy(weapons)
	TeamTable[regiment][rank].Clearance = clearance
	TeamTable[regiment][rank].Side = side
	TeamTable[regiment][rank].OtherModels = table.Copy(othermodels)
	TeamTable[regiment][rank].Bodygroups = bodygroups
	TeamTable[regiment][rank].Skin = skin
	TeamTable[regiment][rank].WalkSpeed = movespeed
	TeamTable[regiment][rank].RunSpeed = rmovespeed
	TeamTable[regiment][rank].ClearanceCards = table.Copy(ClearanceCards)
	teamcounter = teamcounter + 1

	CountTable[teamcounter] = {regiment, rank}

	TeamTable[regiment][rank].Count = teamcounter
	team.SetUp(teamcounter, name, colorreg)
	print(ply:Nick() .. " has created rank " .. rank .. " in regiment " .. regiment)
	ply:ChatPrint("REGIMENT/RANK CREATED")
	file.Write("teamtablejson.txt", util.TableToJSON(TeamTable))
	net.Start("networkteamtbl")
	net.WriteString("newr")
	net.WriteString(regiment)
	net.WriteUInt(rank, 8)
	net.WriteTable(TeamTable[regiment][rank])
	net.Broadcast()

	for k, v in ipairs(player.GetAll()) do
		gmod.GetGamemode():NetworkCountTBL(ply)
	end

	timer.Simple(1, function()
		net.Start("UpdateMenu")
		net.Broadcast()
	end)
end)
