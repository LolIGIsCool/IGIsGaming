if SERVER then
	-- ORDERS
	util.AddNetworkString("Orders")
	-- DEFCON
	util.AddNetworkString("DefconSound")
	-- EVENT SCOREBOARD
	util.AddNetworkString("BroadcastEventPlacements")
	util.AddNetworkString("DoEventPlacements")
	-- AOS MENU
	util.AddNetworkString("AOSMenuMoose3")
	util.AddNetworkString("SendColouredChat")
	util.AddNetworkString("SaveAOS")
	util.AddNetworkString("RemoveAOS")
	-- LICENSES MENU
	util.AddNetworkString("setplayerlvl")
	util.AddNetworkString("setplayerti")
	util.AddNetworkString("licensemenu")
    util.AddNetworkString("eventserverprompt")
	temptable = util.JSONToTable(file.Read("tempjob.txt", "DATA")) or {}
	//PATRONMENU
	util.AddNetworkString("vanillaPatronMenu");
	util.AddNetworkString("vanillaUpdatePatron");

	//CHAPTER MENU
	util.AddNetworkString("vanillaTitleText");
end

CATEGORY_NAME = "Imperial Gaming"

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- [ ORDERS ] ---------------
function ulx.orders(calling_ply, message)
	if ULib.toBool(GetConVarNumber("ulx_logChat")) then
		ulx.fancyLogAdmin(calling_ply, "#A has sent a orders message ")
		ulx.logString(string.format("(Orders set by %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message))
	end

	net.Start("Orders")
	net.WriteString(message)
	net.Broadcast()
end

local orders = ulx.command(CATEGORY_NAME, "ulx orders", ulx.orders, "!orders", true, true)

orders:addParam{
	type = ULib.cmds.StringArg,
	hint = "message",
	ULib.cmds.takeRestOfLine
}

orders:defaultAccess(ULib.ACCESS_ADMIN)
orders:help("Transmit orders to troopers.")
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- [ DEFCON ] ---------------
globaldefconn = 5
vanillaignewdefcon = 21

function ulx.defcon(calling_ply, number)
vanillaignewdefcon = tonumber(math.floor(number))
if vanillaignewdefcon == 11 or vanillaignewdefcon == 12 or vanillaignewdefcon == 13 or vanillaignewdefcon == 31 or vanillaignewdefcon == 32 then
            globaldefconn = 3
            SetGlobalBool("diseasesystemactive", false)
            RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "on")
        elseif vanillaignewdefcon == 21 or vanillaignewdefcon == 41 or vanillaignewdefcon == 42 then
            globaldefconn = 5
            SetGlobalBool("diseasesystemactive", true)
            RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "off")
        end

    local dc = string.Split(vanillaignewdefcon,"")

    net.Start("DefconSound")
    net.WriteUInt(tonumber(vanillaignewdefcon), 16)
    net.Broadcast()
    ulx.fancyLogAdmin(calling_ply, "#A set the defcon level to #s", vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])])
    net.Start("defconchatalert")
    net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "broacastdefconspawn", function(ply)
    net.Start("DefconSound")
    net.WriteUInt(tonumber(vanillaignewdefcon), 16)
    net.Send(ply)
end)

local defcon = ulx.command(CATEGORY_NAME, "ulx defcon", ulx.defcon, "!defcon")

-- Can only enter proper numbers
defcon:addParam{
    type = ULib.cmds.StringArg,
    completes = {"11", "12", "13", "21", "41", "31", "32", "42"},
    hint = "number",
    ULib.cmds.restrictToCompletes
}

defcon:defaultAccess(ULib.ACCESS_ADMIN) -- Admins by default
defcon:help("Change the Defcon Level. 11 - Protocol 13, 12 - Evacuation, 13 - Battle Stations, 41 - Standby Alert, 21 - Standard Operations, 31 - Full Lockdown, 32 - Intruder Alert, 42 - Hazard Alarm")

//------------- [ EVENT SCOREBOARD ] ---------------
function ulx.eboard(calling_ply)
    //if ULib.toBool( GetConVarNumber( "ulx_logChat" ) ) then
    //ulx.logString( string.format( "(Event Scoreboard Points Awarded by %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message ) )
    //end
    net.Start("DoEventPlacements")
    net.Send(calling_ply)
end

if SERVER then
    net.Receive("BroadcastEventPlacements", function(len, pl)
        if not pl:IsAdmin() then return end
        local tab = net.ReadTable()
        ULib.csay(nil, "-- EVENT PLACINGS -- \n[1st] " .. tab[1] .. "\n[2nd] " .. tab[2] .. "\n[3rd] " .. tab[3], Color(255, 255, 255, 255), 10, 0.5) -- nil means all 🙂
        -- I don't know the function for giving points ;') --
        local pointslog = "User " .. pl:Nick() .. "(" .. pl:SteamID() .. ") has just awarded credits. First: " .. tab[1] .. " | Second: " .. tab[2] .. " | Third: " .. tab[3] .. " | " .. os.date("%x - %X") .. " | \n"
        file.Append("awardedpoints.txt", pointslog)
        --ServerLog( pointslog )
        ulx.logServAct(pl, "#A has just awarded credits. First: " .. tab[1] .. " | Second: " .. tab[2] .. " | Third: " .. tab[3] .. " |")

        -- Regiment Clusters allow EMs to award entire Sub-Groups / Legions at a time, without stopping them from
        -- awarding single regiments if they want to do that.
        local regClusters = {
            ["501st Legion"] = {
                ["501st Vader's Fist"] = true,
                ["501st Imperial Commandos"] = true,
                ["501st Storm Commandos"] = true,
            },
            ["ISB Sub-Group"] = {
                ["Imperial Security Bureau"] = true,
                ["CompForce"] = true,
                ["Death Trooper"] = true,
                ["Inferno Squad"] = true,
            },
			["Intelligence"] = {
				["Imperial Intelligence"] = true,
				["SARC Trooper"] = true,
			},
            ["Inquisitorius"] = {
                ["Imperial Marauder"] = true,
                ["Imperial Inquisitor"] = true,
                ["Shadow Guard"] = true,
                ["Emperor's Enforcer"] = true,
                ["Purge Trooper"] = true,
            },
            ["Naval Sub-Group"] = {
                ["Imperial Navy"] = true,
                ["Imperial Naval Engineer"] = true,
                ["Imperial Starfighter Corps"] = true,
                ["Chimaera Squad"] = true,
            },
            ["107th Legion"] = {
                ["107th Shock Division"] = true,
                ["107th Massiff Detachment"] = true,
            },
            ["439th Legion"] = {
                ["439th Stormtroopers"] = true,
                ["439th Scout Troopers"] = true,
            },
			["212th Legion"] = {
                ["212th Attack Battalion"] = true,
                ["212th Airborne Unit"] = true,
                ["212th Juggernaut Unit"] = true,
            },
        }

        local clusterGroups = {
        	["107th Legion"] = true,
        	["Naval Sub-Group"] = true,
			["Intelligence"] = true,
        	["Inquisitorius"] = true,
        	["ISB Sub-Group"] = true,
        	["501st Legion"] = true,
            ["439th Legion"] = true,
            ["212th Legion"] = true
        }

        for k, v in pairs(player.GetAll()) do
            if (v:GetRegiment() == tab[1] or (clusterGroups[tab[1]] && regClusters[tab[1]][v:GetRegiment()]) or tab[1] == "The Empire") then
                --        for k, v in pairs(player.GetAll()) do
                --            if v:GetRegiment() == tab[1] then
                v:PrintMessage(HUD_PRINTTALK, "Your regiment came first! You were rewarded 5000 credits!")

                --v:ProgressQuest("Event Placings", 1)
                --v:ProgressQuest("Event Placings", 2)
                --v:ProgressQuest("Event Placings", 3)
                if v:IsPlayer() then
                    local points = 5000

                    if _G.HasAugment(v, "Routine Reward") then
                        points = points + (points * 0.1)
                        _G.ActivateAugment(v, "Routine Reward", 5)
                    end

                    v:SH_AddPremiumPoints(points, nil, false, false)
                    //IGHALLOWEEN:UpdatePoints(v:GetNWString("halloweenteam", "none"), 20, v, "placing first in the event")
                end
            elseif (v:GetRegiment() == tab[2] or (clusterGroups[tab[2]] && regClusters[tab[2]][v:GetRegiment()]) or tab[2] == "The Empire") then
                v:PrintMessage(HUD_PRINTTALK, "Your regiment came second! You were rewarded 3500 credits!")

                --v:ProgressQuest("Event Placings", 1)
                --v:ProgressQuest("Event Placings", 2)
                if v:IsPlayer() then
                    local points = 3500

                    if _G.HasAugment(v, "Routine Reward") then
                        points = points + (points * 0.1)
                        _G.ActivateAugment(v, "Routine Reward", 5)
                    end

                    v:SH_AddPremiumPoints(points, nil, false, false)
                    //IGHALLOWEEN:UpdatePoints(v:GetNWString("halloweenteam", "none"), 10, v, "placing second in the event")
                end
            elseif (v:GetRegiment() == tab[3] or (clusterGroups[tab[3]] && regClusters[tab[3]][v:GetRegiment()]) or tab[3] == "The Empire") then
                v:PrintMessage(HUD_PRINTTALK, "Your regiment came third! You were rewarded 2000 credits!")

                --v:ProgressQuest("Event Placings", 1)
                if v:IsPlayer() then
                    local points = 2000

                    if _G.HasAugment(v, "Routine Reward") then
                        points = points + (points * 0.1)
                        _G.ActivateAugment(v, "Routine Reward", 5)
                    end

                    v:SH_AddPremiumPoints(points, nil, false, false)
                    //IGHALLOWEEN:UpdatePoints(v:GetNWString("halloweenteam", "none"), 5, v, "placing third in the event")
                end
            end
        end
    end)
end


local eboard = ulx.command(CATEGORY_NAME, "ulx eboard", ulx.eboard, "!eboard")
eboard:defaultAccess(ULib.ACCESS_ADMIN)
eboard:help("Event Scoreboard")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- [ AOS MENU ] ---------------
if (SERVER) then
	local meta = FindMetaTable("Player")
	AOSPLAYERS = {}

	function meta:CanUseAOSSystem()
		if (self:GetJobTable().Clearance == "2") or (self:GetJobTable().Clearance == "3") or (self:GetJobTable().Clearance == "4") or (self:GetJobTable().Clearance == "5") or (self:GetJobTable().Clearance == "6") or (self:GetJobTable().Clearance == "ALL ACCESS") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Legion Commander") or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Imperial Inquisitor") or (self:GetRegiment() == "Shadow Guard") or (self:GetRegiment() == "Purge Trooper") or (self:GetRegiment() == "Imperial High Command") or (self:GetRegiment() == "107th Massiff Detachment") or (self:GetRegiment() == "107th Patrol Trooper") or self:IsSuperAdmin() then return true end

		return false
	end

	function meta:CanUseAOSSystemAdd()
		if (self:GetJobTable().Clearance == "2") or (self:GetJobTable().Clearance == "3") or (self:GetJobTable().Clearance == "4") or (self:GetJobTable().Clearance == "5") or (self:GetJobTable().Clearance == "6") or (self:GetJobTable().Clearance == "ALL ACCESS") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Legion Commander") or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Imperial Inquisitor") or (self:GetRegiment() == "Shadow Guard") or (self:GetRegiment() == "Purge Trooper") or (self:GetRegiment() == "Imperial High Command") or (self:GetRegiment() == "107th Patrol Trooper") or self:IsSuperAdmin() then return true end

		return false
	end

	function meta:CanUseAOSSystemRemove()
		if (self:GetRegiment() == "Imperial High Command") or self:GetJobTable().Clearance == "6" or self:GetJobTable().Clearance == "ALL ACCESS" or self:GetRegiment() == "Legion Commander" or (self:GetRegiment() == "IHC Administration" and self:GetRank() >= 14) or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Inferno Squad") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Patrol Trooper") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Naval Engineer" and self:GetRank() >= 19) or (ply:GetRegiment() == "CompForce" and self:GetJobTable().Clearance == "5") or self:IsSuperAdmin() then return true end

		return false
	end

	function meta:IsAOS()
		local isaos = self:GetNWString("isaos", false)

		if (isaos) then
			return true
		else
			return false
		end
	end

	local function GetShockTBL()
		local tbl = {}

		for k, v in ipairs(player.GetAll()) do
			if (v:GetRegiment() == "107th Shock Division") or (v:GetRegiment() == "107th Riot Company") or (v:GetRegiment() == "107th Medic") or (v:GetRegiment() == "107th Heavy") or (v:GetRegiment() == "107th Honour Guard") or (v:GetRegiment() == "107th Patrol Trooper") then
				table.insert(tbl, v)
			end
		end

		return tbl
	end

	net.Receive("SaveAOS", function(len, ply)
		if ply:CanUseAOSSystemAdd() then
			local senttable = net.ReadTable()
			if string.len(senttable[3]) > 150 or string.len(senttable[4]) > 150 then return end
			local aosplayer = player.GetBySteamID(senttable[2])
			local commenceaos = true

			for k, v in pairs(AOSPLAYERS) do
				if v[2] == senttable[2] then
					commenceaos = false
				end
			end

			if (commenceaos) then
				net.Start("SendColouredChat")
				net.WriteEntity(aosplayer)
				net.WriteEntity(ply)
				net.WriteString("add")
				net.WriteString(senttable[3])
				net.WriteString(senttable[4])

				net.Send({aosplayer, ply})

				for k, v in ipairs(GetShockTBL()) do
					if v == ply or v == aosplayer then continue end
					net.Start("SendColouredChat")
					net.WriteEntity(aosplayer)
					net.WriteEntity(ply)
					net.WriteString("add")
					net.WriteString(senttable[3])
					net.WriteString(senttable[4])
					net.Send(v)
				end

				timer.Simple(30, function()
					local shocktbl = GetShockTBL()

					for k, v in ipairs(player.GetAll()) do
						if table.HasValue(shocktbl, v) then continue end
						if v == ply or v == aosplayer then continue end
						net.Start("SendColouredChat")
						net.WriteEntity(aosplayer)
						net.WriteEntity(ply)
						net.WriteString("add")
						net.WriteString(senttable[3])
						net.WriteString(senttable[4])
						net.Send(v)
					end
				end)

				table.insert(AOSPLAYERS, senttable)
				local aosplayer = player.GetBySteamID(senttable[2])
				aosplayer:SetNWBool("isaos", true)
				hook.Run("AOSUpdate", "add", aosplayer, ply, senttable[3], senttable[4])
			else
				ply:ChatPrint("Player is already AOSed.")
			end
		end
	end)

	net.Receive("RemoveAOS", function(len, ply)
		if ply:CanUseAOSSystemRemove() then
			local senttable = net.ReadTable()
			local tablestring = table.ToString(AOSPLAYERS, "aosplayertable")
			local aosplayer = player.GetBySteamID(senttable[2])

			if string.match(tablestring, senttable[2]) then
				net.Start("SendColouredChat")
				net.WriteEntity(aosplayer)
				net.WriteEntity(ply)
				net.WriteString("remove")
				net.Broadcast()

				for k, v in pairs(AOSPLAYERS) do
					if v[2] == senttable[2] then
						AOSPLAYERS[k] = nil
					end
				end

				aosplayer:SetNWBool("isaos", false)
				hook.Run("AOSUpdate", "remove", aosplayer, ply)
			else
				ply:ChatPrint("Player does not have an AOS on them.")
			end
		end
	end)

	hook.Add("PlayerDisconnected", "AOSPlayerRemove", function(ply)
		if ply:IsAOS() then
			RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "disconnected", "whilst", "AOS")

			for k, v in pairs(AOSPLAYERS) do
				if v[2] == ply:SteamID() then
					AOSPLAYERS[k] = nil
				end
			end
		end
	end)

	hook.Add("IGPlayerSay", "OpenAOSMenuer", function(ply, txt)
		if (string.lower(txt) == "!aos") and ply:CanUseAOSSystem() then
			net.Start("AOSMenuMoose3")
			net.WriteTable(AOSPLAYERS)
			net.Send(ply)

			return ""
		end
	end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- PILOT LICENSES MENU ---------------
--[[
    AUTHOR      :   Kumo
    PROFILE     :   https://steamcommunity.com/id/01001011011101010110110101101111
    EDITED BY   :   Martibo - Hideyoshi (2021)
]]

function ulx.plicense(ply)
	if (ply:GetRegiment() == "Imperial Navy" and ply:GetRank() >= 15) or (ply:GetRegiment() == "Imperial High Command") or (ply:GetRegiment() == "Imperial Starfighter Corps" and ply:GetRank() >= 14) or (ply:IsAdmin()) then
		net.Start("licensemenu")
		net.Send(ply)
	end
end

local plicense = ulx.command(CATEGORY_NAME, "ulx plicense", ulx.plicense, "!plicense")
plicense:defaultAccess(ULib.ACCESS_ALL)
plicense:help("Pilot License Menu")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- TEMPORARY JOBS COMMANDS ---------------
--[[
    AUTHOR      :   Martibo & Moose
    CMDS        :   !tempjobset <ply_name> <job_count>
                    !tempjobrem <ply_name>
]]
------------------------------------------------------------------------------------------------
function ulx.tempjobset(calling_ply, target_plys, teamname, teamnum)
	local affected_plys = {}
	local tbl = TeamTable[teamname]
	temptable = util.JSONToTable(file.Read("tempjob.txt", "DATA")) or {}

	for i = 1, #target_plys do
		local v = target_plys[i]
		local tempjobtable = {}

		--ULib.slap( v, team )
		if not tbl then
			ULib.tsayError(calling_ply, teamname .. " is not a valid team!", true)
		elseif not tbl[teamnum] then
			ULib.tsayError(calling_ply, teamnum .. " is not a valid team number!", true)
		else
			tempjobtable.id = v:SteamID()
			tempjobtable.regiment = v:GetRegiment()
			tempjobtable.rank = v:GetRank()
			table.insert(temptable, tempjobtable)
			PrintTable(tempjobtable)
			v:SetIGData("rank", tbl[teamnum].Rank)
			v:SetIGData("regiment", tbl[teamnum].Regiment)
			v:SetNWString("regiment", tbl[teamnum].Regiment)
			v:SetNWInt("rank", tbl[teamnum].Rank)
			v:SetTeam(tbl[teamnum].Count)
			v:SetModel(tbl[teamnum].Model)
			v:SetHealth(tbl[teamnum].Health)
			v:SetMaxHealth(tbl[teamnum].Health)
			v:StripWeapons()
			local weps = tbl[teamnum].Weapons

			for i = 1, #weps do
				v:Give(weps[i])
			end

			v:Give("weapon_empty_hands")
			v:Give("climb_swep2")
			v:Give("bkeycard")
			weps = v:GetWeapons()

			for i = 1, #weps do
				v:GiveAmmo(256, weps[i]:GetPrimaryAmmoType(), true)
			end

			table.insert(affected_plys, v)
			file.Write("tempjob.txt", util.TableToJSON(temptable))
		end

		ulx.fancyLogAdmin(calling_ply, "#A set a temporary job for #T [" .. teamname .. "] [" .. tbl[teamnum].RealName .. "]", affected_plys)
	end
end

local tempjobset = ulx.command(CATEGORY_NAME, "ulx tempjobset", ulx.tempjobset, "!tempjobset")

tempjobset:addParam{
	type = ULib.cmds.PlayersArg
}

tempjobset:addParam{
	type = ULib.cmds.StringArg,
	hint = "regiment exact",
}

tempjobset:addParam{
	type = ULib.cmds.NumArg,
	min = 1,
	max = 100,
	hint = "tempjobset",
	ULib.cmds.round
}

tempjobset:defaultAccess(ULib.ACCESS_ADMIN)
tempjobset:help("Sets a temporary team for the player")

function ulx.tempjobrem(calling_ply, target_plys)
	local affected_plys = {}
	local regiment = ""
	local rank = 0
	local tbl = {}
	local rem = {}
	local index = ""

	for i = 1, #target_plys do
		local ply = target_plys[i]
		local found = false
		local temptable = util.JSONToTable(file.Read("tempjob.txt", "DATA"))

		for k, v in pairs(temptable) do
			if ply:SteamID() == v.id then
				rem = v
				found = true
				regiment = v.regiment
				rank = v.rank
				tbl = TeamTable[regiment]
				index = v
			end
		end

		if found ~= false then
			table.RemoveByValue(temptable, index)
			file.Write("tempjob.txt", util.TableToJSON(temptable))
			ply:SetIGData("rank", rank)
			ply:SetIGData("regiment", regiment)
			ply:SetNWString("regiment", regiment)
			ply:SetNWInt("rank", rank)
			ply:SetRegiment(regiment)
			ply:SetRank(rank)
			ply:SetTeam(tbl[rank].Count)
			ply:SetModel(tbl[rank].Model)
			ply:SetHealth(tbl[rank].Health)
			ply:SetMaxHealth(tbl[rank].Health)
			ply:StripWeapons()
			local weps = tbl[rank].Weapons

			for i = 1, #weps do
				ply:Give(weps[i])
			end

			ply:Give("weapon_empty_hands")
			ply:Give("climb_swep2")
			ply:Give("bkeycard")
			weps = ply:GetWeapons()

			for i = 1, #weps do
				ply:GiveAmmo(256, weps[i]:GetPrimaryAmmoType(), true)
			end

			table.insert(affected_plys, ply)
		else
			ULib.tsayError(calling_ply, "#T does not have any previous data!", ply)
		end
	end

	ulx.fancyLogAdmin(calling_ply, "#A reset the temporary job for #T", affected_plys)
end

local tempjobrem = ulx.command(CATEGORY_NAME, "ulx tempjobrem", ulx.tempjobrem, "!tempjobrem")

tempjobrem:addParam{
	type = ULib.cmds.PlayersArg
}

function tempjobdisconnect(ply)
	for k, v in pairs(temptable) do
		if ply:SteamID() == v.id then
			ply:SetIGData("rank", v.rank)
			ply:SetIGData("regiment", v.regiment)
			table.RemoveByValue(temptable, v)
		else
			return
		end
	end
end

tempjobrem:defaultAccess(ULib.ACCESS_ADMIN)
tempjobrem:help("Removes the temporary team of the player")
hook.Add("PlayerDisconnected", "playerdisconnected", tempjobdisconnect)

--------------- ADMIN MODE COMMAND ---------------
function ulx.adminmode(calling_ply)
	local tbl = TeamTable[calling_ply:GetRegiment()]

	if calling_ply:GetModel() ~= "models/player/bailey/igadminmodel.mdl" then
		calling_ply:ConCommand("pac_clear_parts")
		calling_ply:SetModel("models/player/bailey/igadminmodel.mdl")
		ulx.fancyLogAdmin(calling_ply, "#A has entered admin mode.")
	else
		calling_ply:SetModel(tbl[calling_ply:GetRank()].Model)
		calling_ply:ConCommand("pac_wear_parts autoload")
		ulx.fancyLogAdmin(calling_ply, "#A has exited admin mode.")
	end
end

local adminmode = ulx.command(CATEGORY_NAME, "ulx adminmode", ulx.adminmode, "!adminmode")
adminmode:defaultAccess(ULib.ACCESS_ADMIN)
adminmode:help("Admin time baby")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- SIMPLE COMMANDS ---------------
--[[
    AUTHOR      :   Martibo & Moose
]]
------------------------------------------------------------------------------------------------
--------------- FPS COMMAND ---------------
local function fpsfix(ply)
	ply:ConCommand("Gmod_mcore_test 1")
	ply:ConCommand("mat_queue_mode -1")
	ply:ConCommand("cl_threaded_bone_setup 1")
	ply:PrintMessage(HUD_PRINTTALK, "FPS command activated!")
end

concommand.Add("fpsfix", fpsfix)

function ulx.fps(calling_ply)
	calling_ply:ConCommand("fpsfix")

end

local fps = ulx.command(CATEGORY_NAME, "ulx fps", ulx.fps, "!fps")
fps:defaultAccess(ULib.ACCESS_ALL)
fps:help("Increases your FPS!")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- DONATE COMMAND ---------------
local function donate(ply)
	ply:SendLua([[gui.OpenURL("http://imperialgaming.net/donate/")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the donation link!")
end

function ulx.donate(calling_ply)
	donate(calling_ply)
end

local donate = ulx.command(CATEGORY_NAME, "ulx donate", ulx.donate, "!donate")
donate:defaultAccess(ULib.ACCESS_ALL)
donate:help("Donation Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- CONTENT COMMAND ---------------
local function content(ply)
	ply:SendLua([[gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1846649268")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the content link!")
end

function ulx.content(calling_ply)
	content(calling_ply)
end

local content = ulx.command(CATEGORY_NAME, "ulx content", ulx.content, "!content")
content:defaultAccess(ULib.ACCESS_ALL)
content:help("Content Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- RECRUIT COMMAND ---------------
local function content(ply)
	ply:SendLua([[gui.OpenURL("https://docs.google.com/forms/d/e/1FAIpQLScW8GRRn0pPJEaAjS73zyXyuwknR-u_EBxTbjBsEPJHP5z9Ag/viewform")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the Recruit Form link!")
end

function ulx.content(calling_ply)
	content(calling_ply)
end

local content = ulx.command(CATEGORY_NAME, "ulx recruit", ulx.content, "!recruit")
content:defaultAccess(ULib.ACCESS_ALL)
content:help("Recruit Form Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- STEAM COMMAND ---------------
local function steam(ply)
	ply:SendLua([[gui.OpenURL("http://steamcommunity.com/groups/ImperialGamingRP")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the Steam Group link!")
end

function ulx.steam(calling_ply)
	steam(calling_ply)
end

local steam = ulx.command(CATEGORY_NAME, "ulx steam", ulx.steam, "!steam")
steam:defaultAccess(ULib.ACCESS_ALL)
steam:help("Steam Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- FORUMS COMMAND ---------------
local function forums(ply)
	ply:SendLua([[gui.OpenURL("https://imperialgamingau.invisionzone.com/")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the forum link!")
end

function ulx.forums(calling_ply)
	forums(calling_ply)
end

local forums = ulx.command(CATEGORY_NAME, "ulx forums", ulx.forums, "!forums")
forums:defaultAccess(ULib.ACCESS_ALL)
forums:help("Forums Link")

---- url command ----
local function url(ply, ply2)
	if SERVER then
		http.Fetch("https://imperialgamingau.invisionzone.com/api/core/members/" .. ply2:GetWebsiteID() .. "?key=3586a4f9835e30f5f46e3d1a1e7da757", function(body)
			local memetable = util.JSONToTable(body)

			if not memetable or not istable(memetable) then
				print("API REQUEST FAILED")

				return
			end

			ply:SendLua("gui.OpenURL('" .. string.gsub(memetable.profileUrl, [[\]], "") .. "')")
			ply:PrintMessage(HUD_PRINTTALK, "You have opened the forum link of " .. ply2:Nick() .. "!")
		end, function() end)
	end
end

function ulx.url(calling_ply, target_ply)
	if target_ply:GetWebsiteID() ~= "0000" then
		url(calling_ply, target_ply)
	else
		calling_ply:ChatPrint("User has not synchronised their forum account")
	end
end

local url = ulx.command(CATEGORY_NAME, "ulx url", ulx.url, "!url")

url:addParam{
	type = ULib.cmds.PlayerArg,
	ULib.cmds.ignoreCanTarget
}

url:defaultAccess(ULib.ACCESS_ALL)
url:help("url Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- CLEARANCE LEVELS COMMAND ---------------
local function cl(ply)
	ply:SendLua([[gui.OpenURL("https://docs.google.com/spreadsheets/d/1uXcAv4Mggkl0VJPHZUSa8_ZhA8jXhE3s71ccw9Ln_Jo/edit?usp=sharing")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the Clearance Levels link!")
end

function ulx.cl(calling_ply)
	cl(calling_ply)
end

local cl = ulx.command(CATEGORY_NAME, "ulx cl", ulx.cl, "!cl")
cl:defaultAccess(ULib.ACCESS_ALL)
cl:help("Clearance Level Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- ARREST FORM COMMAND ---------------
local function af(ply)
	ply:SendLua([[gui.OpenURL("https://forms.gle/ytdbLaRAFgo2pLNm6")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the Arrest Form link!")
end

function ulx.af(calling_ply)
	af(calling_ply)
end

local af = ulx.command(CATEGORY_NAME, "ulx af", ulx.af, "!af")
af:defaultAccess(ULib.ACCESS_ALL)
af:help("Arrest Form Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- ARREST COMMAND ---------------
local function arrests(ply)
	ply:SendLua([[gui.OpenURL("https://docs.google.com/document/d/1lqBr1ppNiGgtdnQ8qsMpXQ4GwVoXO4XnK4VWLo9EGcE/edit#")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the Arrests link!")
end

function ulx.arrests(calling_ply)
	arrests(calling_ply)
end

local arrests = ulx.command(CATEGORY_NAME, "ulx arrests", ulx.arrests, "!arrests")
arrests:defaultAccess(ULib.ACCESS_ALL)
arrests:help("Arrests Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- RULES COMMAND ---------------
local function rules(ply)
	ply:SendLua([[gui.OpenURL("http://imperialgamingau.invisionzone.com/topic/3333-imperial-rp-server-rules-guidelines/")]])
	ply:PrintMessage(HUD_PRINTTALK, "You have opened the server rules link!")
end

function ulx.rules(calling_ply)
	rules(calling_ply)
end

local rules = ulx.command(CATEGORY_NAME, "ulx rules", ulx.rules, "!rules")
rules:defaultAccess(ULib.ACCESS_ALL)
rules:help("Rules Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- TEAMSPEAK COMMAND ---------------
local function ts(ply)
	ply:ChatPrint("Teamspeak: ts3.imperialgaming.net")
end

function ulx.ts(calling_ply)
	ts(calling_ply)
end

local ts = ulx.command(CATEGORY_NAME, "ulx ts", ulx.ts, "!ts")
ts:defaultAccess(ULib.ACCESS_ALL)
ts:help("TS Link")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- SEE ADMIN COMMANDS ---------------
function ulx.toggleecho(calling_ply)
	local seesechoes = calling_ply:GetPData("toggleecho", "no")

	if seesechoes == "no" then
		calling_ply:SetPData("toggleecho", "yes")
		calling_ply:ChatPrint("Seeing Echoes: " .. calling_ply:GetPData("toggleecho", "no"))
	elseif seesechoes == "yes" then
		calling_ply:SetPData("toggleecho", "no")
		calling_ply:ChatPrint("Seeing Echoes: " .. calling_ply:GetPData("toggleecho", "no"))
	end
end

local toggleecho = ulx.command(CATEGORY_NAME, "ulx toggleecho", ulx.toggleecho, "!toggleecho")
toggleecho:defaultAccess(ULib.ACCESS_SUPERADMIN)
toggleecho:help("Toggle if you see admin echoes or not.")

--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------- Sneaky respawn to redo GM:PlayerSpawn() on everyone---------------
function ulx.sneakrespawn(calling_ply, target_plys)
	local vposlol

	for k, v in pairs(target_plys) do
		if not v:Alive() then continue end
		if v:InVehicle() then continue end
		vposlol = v:GetPos()
		v:Spawn()
		v:SetPos(vposlol)
	end
end

local sneakrespawn = ulx.command(CATEGORY_NAME, "ulx sneakrespawn", ulx.sneakrespawn, "!sneakrespawn")

sneakrespawn:addParam{
	type = ULib.cmds.PlayersArg
}

sneakrespawn:defaultAccess(ULib.ACCESS_ADMIN)
sneakrespawn:help("Sneakily respawns everyone")
-- Lockdown ULX
local lockdown = false
SetGlobalBool("iglockdown", false)

local doors = {3000, 2407, 2406, 2354, 2355, 2680, 2683, 2681, 2065, 2072, 2151, 2150, 2077, 2076, 2015, 2181, 2514, 2513, 2511, 2510, 2488, 2487, 2481, 2480, 3083, 3081, 2565, 2564, 2200, 2199, 3064, 2534, 3247, 2932, 2933, 2906, 2905, 3367, 3365, 3266}

function ulx.lockship(calling_ply)
	if SERVER then
		for k, v in pairs(ents.FindByClass("func_door")) do
			v:SetNWInt("kumomapcreatedid", v:MapCreationID())
		end
	end

	if calling_ply:IsPlayer() then
		if lockdown then
			lockdown = false
			SetGlobalBool("iglockdown", false)
			RunConsoleCommand("ulx", "asay", calling_ply:Nick(), "has", "reverted", "the", "lockdown")
			ULib.csay(nil, "The ships lockdown has been reverted, all doors have been unlocked.", Color(255, 255, 255, 255), 10, 0.5)

			for k, v in pairs(ents.FindByClass("func_door")) do
				local vname = v:MapCreationID() or "nil"

				if table.HasValue(doors, vname) and v:GetNWInt("b_bKeycardScannerEntIndex", 696969) == 696969 then
					v:Fire("unlock", "", 0)
				end
			end
		elseif not lockdown then
			lockdown = true
			SetGlobalBool("iglockdown", true)
			RunConsoleCommand("ulx", "asay", calling_ply:Nick(), "has", "locked", "down", "the", "ship")
			ULib.csay(nil, "The ship has been placed on lockdown, all doors will be locked.", Color(255, 255, 255, 255), 10, 0.5)

			for k, v in pairs(ents.FindByClass("func_door")) do
				local vname = v:MapCreationID() or "nil"

				if table.HasValue(doors, vname) and v:GetNWInt("b_bKeycardScannerEntIndex", 696969) == 696969 then
					v:Fire("lock", "", 0)
				end
			end
		end
	else
		if lockdown then
			lockdown = false
			SetGlobalBool("iglockdown", false)
			RunConsoleCommand("ulx", "asay", globallockdownpresser:Nick(), "has", "reverted", "the", "lockdown", "via", "the", "bridge", "button")
			ULib.csay(nil, "The ships lockdown has been reverted, all doors have been unlocked.", Color(255, 255, 255, 255), 10, 0.5)

			for k, v in pairs(ents.FindByClass("func_door")) do
				local vname = v:MapCreationID() or "nil"

				if table.HasValue(doors, vname) and v:GetNWInt("b_bKeycardScannerEntIndex", 696969) == 696969 then
					v:Fire("unlock", "", 0)
				end
			end
		elseif not lockdown then
			lockdown = true
			SetGlobalBool("iglockdown", true)
			RunConsoleCommand("ulx", "asay", globallockdownpresser:Nick(), "has", "locked", "down", "the", "ship", "via", "the", "bridge", "button")
			ULib.csay(nil, "The ship has been placed on lockdown, all doors will be locked.", Color(255, 255, 255, 255), 10, 0.5)

			for k, v in pairs(ents.FindByClass("func_door")) do
				local vname = v:MapCreationID() or "nil"

				if table.HasValue(doors, vname) and v:GetNWInt("b_bKeycardScannerEntIndex", 696969) == 696969 then
					v:Fire("lock", "", 0)
				end
			end
		end
	end
end

local lockship = ulx.command(CATEGORY_NAME, "ulx lockship", ulx.lockship, "!lockship")
lockship:defaultAccess(ULib.ACCESS_SUPERADMIN)
lockship:help("Locks down the ship.")

function ulx.toolscheck(calling_ply)
	if calling_ply:IsValid() and not calling_ply:IsAdmin() then return end

	if calling_ply:IsValid() then
		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then continue end
			if not v:HasWeapon("gmod_tool") or not v:HasWeapon("weapon_physgun") then continue end
			calling_ply:ChatPrint(v:Nick() .. " has tools, given to them by " .. v:GetNWString("toolsfrom", "noone"))
		end
	else
		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then continue end
			if not v:HasWeapon("gmod_tool") or not v:HasWeapon("weapon_physgun") then continue end
			print(v:Nick() .. " has tools, given to them by " .. v:GetNWString("toolsfrom", "noone"))
		end
	end
end

local toolscheck = ulx.command(CATEGORY_NAME, "ulx toolscheck", ulx.toolscheck, "!toolscheck")
toolscheck:defaultAccess(ULib.ACCESS_ADMIN)
toolscheck:help("Checks everyone with tools.")

function ulx.givephysgun(calling_ply, target_plys)
	for k, v in pairs(target_plys) do
		if not v:Alive() then continue end
		v:Give("weapon_physgun")
	end

	ulx.fancyLogAdmin(calling_ply, "gave physgun to", affected_plys)
end

local givephysgun = ulx.command(CATEGORY_NAME, "ulx givephysgun", ulx.givephysgun, "!givephysgun")

givephysgun:addParam{
	type = ULib.cmds.PlayersArg
}

givephysgun:defaultAccess(ULib.ACCESS_ADMIN)
local eventRewardDelay = false

function ulx.ecreward(calling_ply)
	if eventRewardDelay == false then
		if calling_ply:IsEventMaster() or calling_ply:IsSuperAdmin() then
			for k, v in pairs(player.GetAll()) do
				if v:GetRegiment() == "Event" then
					//v:ProgressQuest("Event Participation", 1)
					//v:ProgressQuest("Event Participation", 2)
					//v:ProgressQuest("Event Participation", 3)
                	AdvanceQuest(v,"Weekly","The REAL Event Master")
					AdvanceQuest(v,"Daily","The Other Side")
					v:SH_AddPremiumPoints(5000)
					//IGHALLOWEEN:UpdatePoints(v:GetNWString("halloweenteam", "none"), 20, v, "helping out with an event")
					v:ChatPrint("You have receieved 5000 credits for completing the event!")
				end
			end

			local plynick = calling_ply:Nick()
			eventRewardDelay = true
			RunConsoleCommand("ulx", "asay", plynick, "has", "rewarded", "event", "characters")
			file.Append("ecrewards.txt", calling_ply:SteamID() .. "rewarded event characters at " .. os.date("%x - %X") .. " | \n")

			timer.Create("ecRewardsTimer", 690, 1, function()
				eventRewardDelay = false
			end)
		end
	else
		calling_ply:ChatPrint("ECRewards is still on cooldown.")
	end
end

local ecreward = ulx.command(CATEGORY_NAME, "ulx ecreward", ulx.ecreward, "!ecreward")
ecreward:defaultAccess(ULib.ACCESS_ADMIN)
getdiseasesys = false

if SERVER then
	getdiseasesys = false
	SetGlobalBool("diseasesystemactive", true)
	util.AddNetworkString("immersionmode")

	function NetworkImmersionMode(mode)
		net.Start("immersionmode")
		net.WriteBool(mode)
		net.Broadcast()
	end

	function DirectNetworkImmersionMode(mode, ply)
		net.Start("immersionmode")
		net.WriteBool(mode)
		net.Send(ply)
	end
end

function ulx.eventmode(calling_ply)
	local plynick = ""

	if calling_ply:IsValid() then
		plynick = calling_ply:Nick()
	else
		plynick = "CONSOLE"
	end

	if getdiseasesys == false then
		getdiseasesys = true

		if SERVER then
			for k, v in pairs(player.GetAll()) do
				v:ProgressQuest("Event Participation", 1)
			end
		end

		RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "on", "by", plynick)
	else
		RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "off", "by", plynick)
		getdiseasesys = false
	end
end

local eventmode = ulx.command("Imperial Gaming", "ulx eventmode", ulx.eventmode, "!eventmode")
eventmode:defaultAccess(ULib.ACCESS_ADMIN)
eventmode:help("Toggles Event Mode")

if SERVER then
	getimmersionmode = false
end

if SERVER then
	hook.Add("PlayerInitialSpawn", "ImmerseSpawnBroadcast", function(ply)
		timer.Simple(10, function()
			DirectNetworkImmersionMode(getimmersionmode, ply)
		end)
	end)
end

function ulx.immersiveeventmode(calling_ply)
	local plynick

	if SERVER then
		if calling_ply:IsValid() then
			plynick = calling_ply:Nick()
		else
			plynick = "CONSOLE"
		end

		if getimmersionmode == false then
			getimmersionmode = true
			NetworkImmersionMode(getimmersionmode)

			for k, v in pairs(player.GetAll()) do
				v:ProgressQuest("Event Participation", 2)
			end

			RunConsoleCommand("ulx", "asay", "Immersive", "Event", "Mode", "turned", "on", "by", plynick)
		else
			RunConsoleCommand("ulx", "asay", "Immersive", "Event", "Mode", "turned", "off", "by", plynick)
			getimmersionmode = false
			NetworkImmersionMode(getimmersionmode)
		end
	end
end

local immersiveeventmode = ulx.command("Imperial Gaming", "ulx immersiveeventmode", ulx.immersiveeventmode, "!immersiveeventmode")
immersiveeventmode:defaultAccess(ULib.ACCESS_ADMIN)
immersiveeventmode:help("Toggles Immersive Event Mode")

timer.Create("eventmodemsg", 300, 0, function()
	if (getdiseasesys) and SERVER then
		RunConsoleCommand("ulx", "asay", "Event", "Mode", "is", "still", "active")
	end
end)

timer.Create("immersemodemsg", 300, 0, function()
	if (getimmersionmode) and SERVER then
		RunConsoleCommand("ulx", "asay", "Immersive", "Event", "Mode", "is", "still", "active")
	end
end)

local fistsblacklist = {}

local fistblacklistreg = {"Recruit"}

--local hightierwepslist = {"tfa_swch_dc15a_blacktiger", "tfa_swch_dc15a_bling", "tfa_swch_dc15a_alt", "tfa_swch_dc15a_shadow", "tfa_swch_e11_quartz", "tfa_swch_clonelauncher", "tfa_swch_pulsecannon"}
--local hightierwepspretprint = {
--    ["tfa_swch_dc15a_blacktiger"] = "DC-15a Black Tiger",
--    ["tfa_swch_dc15a_bling"] = "DC-15a Bling",
--    ["tfa_swch_dc15a_alt"] = "DC-15a Fancy",
--    ["tfa_swch_dc15a_shadow"] = "DC-15a Shadow",
--    ["tfa_swch_e11_quartz"] = "E-11 Quartz",
--    ["tfa_swch_clonelauncher"] = "Rocket Launcher",
--    ["tfa_swch_pulsecannon"] = "Pulse Cannon",
--    ["tfa_e11d_sv"] = "E-11D"
--}
function ulx.igloadout(calling_ply, target_plys)
	for k, v in pairs(target_plys) do
		-- Is the player dead?
		if (not v:Alive()) then
			ULib.tsayError(calling_ply, v:Nick() .. " is dead!", true)
		elseif v:IsFrozen() then
			-- Is the player frozen?
			ULib.tsayError(calling_ply, v:Nick() .. " is frozen!", true)
		elseif v:InVehicle() then
			-- Is the player in a vehicle?
			ULib.tsayError(calling_ply, v:Nick() .. " is in a vehicle.", true)
		else
			local movespeed, runspeed = v:GetJobTable().WalkSpeed, v:GetJobTable().RunSpeed

			if v:GetNWInt("igprogressc", 0) >= 6 then
				v:SetRunSpeed(runspeed * 1.1)
				v:SetWalkSpeed(movespeed)
			elseif v:GetNWInt("igprogressc", 0) >= 3 then
				v:SetRunSpeed(runspeed * 1.05)
				v:SetWalkSpeed(movespeed)
			else
				v:SetRunSpeed(runspeed)
				v:SetWalkSpeed(movespeed)
			end

			if v:IsAdmin() then
				v:Give("weapon_physgun")
				v:Give("gmod_tool")
			end

			local tbl = v:GetJobTable()
			local healthtogive = tbl.Health

			if ply:GetNWInt("igprogressc", 0) >= 4 then
				healthtogive = healthtogive * 1.2
			elseif ply:GetNWInt("igprogressc", 0) >= 1 then
				healthtogive = healthtogive * 1.1
			end

			v:SetHealth(healthtogive)
			v:SetMaxHealth(healthtogive)
			local weps = tbl.Weapons

			for i = 1, #weps do
				v:Give(weps[i])
			end

			--            if ply:GetNWInt("igprogressu", 0) >= 4 then
			--                local randweapon = table.Random(hightierwepslist)
			--                ply:Give(randweapon, true)
			--                ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
			--            end
			v:Give("weapon_empty_hands")
			v:Give("climb_swep2")
			v:Give("comlink_swep")
			v:Give("cross_arms_swep")
			v:Give("cross_arms_infront_swep")
			v:Give("point_in_direction_swep")
			v:Give("salute_swep")
			v:Give("surrender_animation_swep")
			v:Give("bkeycard")

			if not table.HasValue(fistsblacklist, v:SteamID()) and not table.HasValue(fistblacklistreg, v:GetRegiment()) then
				v:Give("weapon_fists")
			end

			weps = v:GetWeapons()

			for i = 1, #weps do
				if weps[i]:GetClass() == "tfa_swch_clonelauncher" then continue end
				v:GiveAmmo(256, weps[i]:GetPrimaryAmmoType(), true)
			end

			ulx.fancyLogAdmin(calling_ply, "#A restored #T's loadout", target_plys)
		end
	end
end

local igloadout = ulx.command("Imperial Gaming", "ulx igloadout", ulx.igloadout, "!igloadout")

igloadout:addParam{
	type = ULib.cmds.PlayersArg
}

igloadout:defaultAccess(ULib.ACCESS_ADMIN)
igloadout:help("Restore a persons loadout after being stripped")

function ulx.healthregen(calling_ply, target_plys)
	for k, v in pairs(target_plys) do
		if v:GetNWString("ighealthregen", true) then
			ulx.fancyLogAdmin(calling_ply, "#A disabled #T's health regen", v)
			calling_ply:ChatPrint("You have Disabled this dudes health regen!")
			v:SetNWString("ighealthregen", false)
		else
			ulx.fancyLogAdmin(calling_ply, "#A enabled #T's health regen", v)
			calling_ply:ChatPrint("You have Enabled this dudes health regen!")
			v:SetNWString("ighealthregen", true)
		end
	end
end

local healthregen = ulx.command("Imperial Gaming", "ulx healthregen", ulx.healthregen, "!healthregen")

healthregen:addParam{
	type = ULib.cmds.PlayersArg
}

healthregen:defaultAccess(ULib.ACCESS_ADMIN)
healthregen:help("Toggles players health regeneration skill")

function ulx.nlr(ply)
	ply:SendLua([[gui.OpenURL("https://imperialgamingau.invisionzone.com/topic/6211-nlr-rule-revision")]])
end

local nlr = ulx.command(CATEGORY_NAME, "ulx nlr", ulx.nlr, "!nlr")
nlr:defaultAccess(ULib.ACCESS_ALL)
nlr:help("Official NLR Information Page.")

function ulx.dupe(ply)
	ply:SendLua([[gui.OpenURL("https://imperialgamingau.invisionzone.com/topic/6830-advanced-duplicator-rules/")]])
end

local dupe = ulx.command(CATEGORY_NAME, "ulx dupe", ulx.dupe, "!dupe")
dupe:defaultAccess(ULib.ACCESS_ALL)
dupe:help("Official Adv Dupe 2 Rules Page.")

function ulx.exit(calling_ply, target_ply)
	if not IsValid(target_ply:GetVehicle()) then
		ULib.tsayError(calling_ply, target_ply:Nick() .. " is not in a vehicle!")

		return
	else
		target_ply:ExitVehicle()
	end

	ulx.fancyLogAdmin(calling_ply, "#A forced #T out of a vehicle", target_ply)
end

local exit = ulx.command("Utility", "ulx exit", ulx.exit, "!exit")

exit:addParam{
	type = ULib.cmds.PlayerArg
}

exit:defaultAccess(ULib.ACCESS_ADMIN)
exit:help("Force a player out of a vehicle.")

function ulx.halloweengive(calling_ply, target_plys, points, reason)
	if calling_ply:IsValid() and not calling_ply:IsSuperAdmin() then return end

	for k, v in pairs(target_plys) do
		if v:GetNWString("halloweenteam", "none") == "none" then
			v:ChatPrint("You could've earnt halloween points for a team, but you aren't in won, visit the cauldron on the third floor to join one!")
			continue
		end

		local team = v:GetNWString("halloweenteam", "none")
		IGHALLOWEEN:UpdatePoints(v:GetNWString("halloweenteam", "none"), points, v, reason)

		for a, b in pairs(player.GetAll()) do
			if v and reason then
				b:QUEST_SYSTEM_ChatNotify("Halloween", v:Nick() .. " has earnt " .. points .. " points for " .. team .. " for " .. reason)
			elseif not v and reason then
				b:QUEST_SYSTEM_ChatNotify("Halloween", points .. " has been awarded to " .. team .. " for " .. reason)
			elseif not v and not reason then
				b:QUEST_SYSTEM_ChatNotify("Halloween", points .. " has been awarded to " .. team)
			end
		end
	end
end

local halloweengive = ulx.command(CATEGORY_NAME, "ulx halloweengive", ulx.halloweengive, "!halloweengive")

halloweengive:addParam{
	type = ULib.cmds.PlayersArg
}

halloweengive:addParam{
	type = ULib.cmds.NumArg,
	hint = "-1000 to 1000",
	min = -1000,
	max = 1000,
	default = 1
}

halloweengive:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.takeRestOfLine
}

halloweengive:defaultAccess(ULib.ACCESS_ADMIN)
halloweengive:help("Gives People Stuff.")

function ulx.material( calling_ply, target_plys, material )

    if material ~= "" then
        for _,v in ipairs( target_plys ) do
                v.OrginalMaterials = table.Copy(v:GetMaterials())
                for idx, ply in ipairs( v:GetMaterials()) do
                    v:SetSubMaterial( idx-1, material )
                end
        end
        ulx.fancyLogAdmin( calling_ply, "#A materialised #T - #s", target_plys, material )
    else
        for _,v in ipairs( target_plys ) do
            for idx, ply in ipairs( v.OrginalMaterials ) do
                v:SetSubMaterial( idx-1, material )
            end
            v.OrginalMaterials = nil
        end
        ulx.fancyLogAdmin( calling_ply, "#A unmaterialised #T", target_plys )
    end

end
local material = ulx.command( "Imperial Gaming", "ulx material", ulx.material, "!material" )
material:addParam{ type=ULib.cmds.PlayersArg }
material:addParam{ type=ULib.cmds.StringArg, hint="material path", ULib.cmds.takeRestOfLine, ULib.cmds.optional }
material:defaultAccess( ULib.ACCESS_ADMIN )
material:help( "Materialise Player" )

function ulx.color( calling_ply, target_plys, red, green, blue )

    for k,v in pairs( target_plys ) do
        v:SetColor(Color(red, green, blue))
    end

    ulx.fancyLogAdmin( calling_ply, "#A coloured #T - #s", target_plys - red .. ", " .. green .. ", " .. blue)

end
local color = ulx.command( "Imperial Gaming", "ulx color", ulx.color, "!color" )
color:addParam{ type=ULib.cmds.PlayersArg }
color:addParam{ type=ULib.cmds.NumArg, min=0, max=255, default=255, hint="red", ULib.cmds.round, ULib.cmds.optional }
color:addParam{ type=ULib.cmds.NumArg, min=0, max=255, default=255, hint="green", ULib.cmds.round, ULib.cmds.optional }
color:addParam{ type=ULib.cmds.NumArg, min=0, max=255, default=255, hint="blue", ULib.cmds.round, ULib.cmds.optional }
color:defaultAccess( ULib.ACCESS_ADMIN )
color:help( "Colour player." )

function ulx.toggleaugments( calling_ply, target_plys )

    for k,v in pairs( target_plys ) do
        v:SetVar("AugmentsActive", !v:GetVar("AugmentsActive"))
    end

    ulx.fancyLogAdmin( calling_ply, "#A toggled #T augments", target_plys)

end
local toggleaugments = ulx.command( CATEGORY_NAME, "ulx toggleaugments", ulx.toggleaugments, "!toggleaugments" )
toggleaugments:addParam{ type=ULib.cmds.PlayersArg }
toggleaugments:defaultAccess( ULib.ACCESS_ADMIN )
toggleaugments:help( "toggles a player's augment abilities." )

local canBeCuffed = true
function ulx.EventCharacterCanBeCuffed(calling_ply)
    local plynick = ""
    if calling_ply:IsValid() then
        plynick = calling_ply:Nick()
    else
        plynick = "CONSOLE"
    end

    if canBeCuffed == false then
        canBeCuffed = true
        RunConsoleCommand("ulx", "asay", plynick, "has", "enabled", "cuffs/tasers", "on", "event", "characters")
    else
        RunConsoleCommand("ulx", "asay", plynick, "has", "disabled", "cuffs/tasers", "on", "event", "characters")
        canBeCuffed = false
    end
end

local cuff_ulx = ulx.command(CATEGORY_NAME, "ulx togglecuff", ulx.EventCharacterCanBeCuffed, "!togglecuff")
cuff_ulx:defaultAccess(ULib.ACCESS_ADMIN)
cuff_ulx:help("Toggles the ability to cuff and tase Event Characters")

function ulx.addpatron( calling_ply )
	if SERVER then
		local jsonTable = file.Read("patronlist.json","DATA");
	    local patronTable = util.JSONToTable(jsonTable);

	    net.Start("vanillaUpdatePatron");
	    net.WriteTable(patronTable);
		net.WriteTable(IG_CHARACTER_PURCHASED);
	    net.Send(calling_ply);
	end
end
local addpatron = ulx.command( CATEGORY_NAME, "ulx patron", ulx.addpatron, "!patron" )
addpatron:defaultAccess( ULib.ACCESS_ADMIN )
addpatron:help( "Adds a user to the patron list." )

function ulx.chapter( calling_ply, stringing )
	net.Start("vanillaTitleText");
	net.WriteString(stringing);
	net.Broadcast();

	RunConsoleCommand("ulx", "asay", calling_ply:Nick(), "has", "used", "the", "chapter", "command.");
end
local chapter = ulx.command( CATEGORY_NAME, "ulx chapter", ulx.chapter, "!chapter" )
chapter:addParam{ type = ULib.cmds.StringArg }
chapter:defaultAccess( ULib.ACCESS_ADMIN )
chapter:help( "Displays a cinematic chapter message." )

hook.Add("CrixCheckCuffStatus", "CrixCuffStatus", function(ply)
    if ply:GetRegiment() ~= "Event" then return true end
    return canBeCuffed
end)

function ulx.eventserver(calling_ply, target_plys)
    local affected_plys = {}
    for k, v in pairs(target_plys) do
        net.Start("eventserverprompt")
        net.Send(v)
        table.insert(affected_plys, v)
    end
    ulx.fancyLogAdmin(calling_ply, "#A directed #T to the event server", affected_plys)
end

local eventserver = ulx.command(CATEGORY_NAME, "ulx eventserver", ulx.eventserver, "!eventserver")
eventserver:addParam{
    type = ULib.cmds.PlayersArg
}
eventserver:defaultAccess(ULib.ACCESS_ADMIN)
eventserver:help("Prompts to transfer to the event server for the player")

local CATEGORY_NAME = 'Teleport'

function ulx.warp(calling_ply, posX, posY, posZ)
    calling_ply:SetPos( Vector( posX, posY, posZ ) )
end

local warp = ulx.command(CATEGORY_NAME, "ulx warp", ulx.warp, "!warp")
warp:addParam{
	type = ULib.cmds.NumArg,
	hint = "x coordinate",
	min = -16000,
	max = 16000,
	default = 0
}
warp:addParam{
	type = ULib.cmds.NumArg,
	hint = "y coordinate",
	min = -16000,
	max = 16000,
	default = 0
}
warp:addParam{
	type = ULib.cmds.NumArg,
	hint = "z coordinate",
	min = -16000,
	max = 16000,
	default = 0
}
warp:defaultAccess(ULib.ACCESS_ADMIN)
warp:help("Prompts to transfer to the event server for the player")

local CATEGORY_NAME = 'vFire'

function ulx.vfire( calling_ply, preset )
	if not (preset == "0" or preset == "1" or preset == "2" or preset == "3" or preset == "4") then
		ULib.tsayError( calling_ply, "Must specify a preset (0-4)", true )
		return
	end
    
    if preset == "0" then
        RunConsoleCommand("vfire_spread_boost", "0")
        RunConsoleCommand("vfire_decal_probability", "0")
        RunConsoleCommand("vfire_enable_spread", "0")
        RunConsoleCommand("vfire_spread_delay", "100")
        RunConsoleCommand("vfire_decay_rate", "100")
    end
    
    if preset == "1" then
    	RunConsoleCommand("vfire_spread_boost", "0")
        RunConsoleCommand("vfire_decal_probability", "0.1")
        RunConsoleCommand("vfire_enable_spread", "1")
        RunConsoleCommand("vfire_spread_delay", "60")
        RunConsoleCommand("vfire_decay_rate", "0.9")
    end
    
    if preset == "2" then
        RunConsoleCommand("vfire_spread_boost", "1")
        RunConsoleCommand("vfire_decal_probability", "0.5")
        RunConsoleCommand("vfire_enable_spread", "1")
        RunConsoleCommand("vfire_spread_delay", "10")
        RunConsoleCommand("vfire_decay_rate", "0.1")
    end
    
    if preset == "3" then
        RunConsoleCommand("vfire_spread_boost", "5")
        RunConsoleCommand("vfire_decal_probability", "1")
        RunConsoleCommand("vfire_enable_spread", "1")
        RunConsoleCommand("vfire_spread_delay", "1")
        RunConsoleCommand("vfire_decay_rate", "0")
    end
    
    if preset == "4" then
    	RunConsoleCommand("vfire_spread_boost", "100")
        RunConsoleCommand("vfire_decal_probability", "1")
        RunConsoleCommand("vfire_enable_spread", "1")
        RunConsoleCommand("vfire_spread_delay", "0.01")
        RunConsoleCommand("vfire_decay_rate", "0")
    end

	ulx.fancyLogAdmin( calling_ply, "#A set vfire preset to #s", preset )
end
local vfire = ulx.command( CATEGORY_NAME, "ulx vfire", ulx.vfire, "!vfire" )
vfire:addParam{ type=ULib.cmds.StringArg, hint="preset", autocomplete_fn=ulx.soundComplete }
vfire:defaultAccess( ULib.ACCESS_ADMIN )
vfire:help( "Sets a vfire preset (0-4)." )
