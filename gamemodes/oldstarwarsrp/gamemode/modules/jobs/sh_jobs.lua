local meta = FindMetaTable("Player")
TeamTable = {}
RegTable = {}
RegRanks = {}
PrecacheModels = PrecacheModels or {"models/imperial_officer/officer.mdl"}

local admintable = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["advisor"] = true,
    ["admin"] = true,
    ["senior moderator"] = true,
    ["moderator"] = true,
    ["junior moderator"] = true,
    ["trial moderator"] = true,
    ["lead event master"] = true,
    ["senior event master"] = true,
    ["event master"] = true,
    ["trial event master"] = true,
    ["junior event master"] = true,
    ["developer"] = true,
}

local sadmintable = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["advisor"] = true,
}

local emtable = {
    ["superadmin"] = true,
    ["advisor"] = true,
    ["lead event master"] = true,
    ["senior event master"] = true,
    ["event master"] = true,
    ["trial event master"] = true,
    ["junior event master"] = true,
}

local donatortable = {
    ["junior developer"] = true,
    ["tier 1"] = true,
    ["tier 2"] = true,
    ["tier 3"] = true,
    ["donator"] = true
}

function meta:IsAdmin()
    if admintable[string.lower(self:GetUserGroup())] then return true end

    return false
end

function meta:IsSuperAdmin()
    if sadmintable[string.lower(self:GetUserGroup())] then return true end

    return false
end

function meta:IsEventMaster()
    if emtable[string.lower(self:GetUserGroup())] then return true end

    return false
end

function meta:IsDonator()
    if sadmintable[string.lower(self:GetUserGroup())] then return true end
    if admintable[string.lower(self:GetUserGroup())] then return true end
    if emtable[string.lower(self:GetUserGroup())] then return true end
    if donatortable[string.lower(self:GetUserGroup())] then return true end

    return false
end

function CreateTeam(name, teamtbl)
    if not istable(teamtbl) then
        ErrorNoHalt("Failed to create team, " .. (name or "nil"))

        return
    end

    teamtbl.Weapons = teamtbl.Weapons or {}
    teamtbl.Health = teamtbl.Health or 100
    teamtbl.Clearance = teamtbl.Clearance or "Unassigned"
    teamtbl.Colour = teamtbl.Colour or Color(255, 255, 255)
    teamtbl.Side = teamtbl.Side or 0
    teamtbl.Rank = teamtbl.Rank or 0
    teamtbl.Model = teamtbl.Model or ""
    teamtbl.OtherModels = teamtbl.OtherModels or {}
    teamtbl.Bodygroups = teamtbl.Bodygroups or ""
    teamtbl.Skin = teamtbl.Skin or 0
    teamtbl.Regiment = teamtbl.Regiment or ""
    teamtbl.Name = name
    teamtbl.RealName = teamtbl.RealName or name
    teamtbl.SpawnFunc = teamtbl.SpawnFunc or nil
    local count = table.Count(TeamTable)
    teamtbl.Count = count
    team.SetUp(count, name, teamtbl.Colour)
    TeamTable[count] = teamtbl
    local shouldteam = true

    for k, v in pairs(RegTable) do
        if v.Regiment == teamtbl.Regiment then
            shouldteam = false
            break
        end
    end

    if shouldteam then
        table.insert(RegTable, teamtbl)
    end

    RegRanks[teamtbl.Regiment] = RegRanks[teamtbl.Regiment] or {}
    RegRanks[teamtbl.Regiment][count] = teamtbl.RealName

    if type(teamtbl.Model) == "table" then
        for _, v in pairs(teamtbl.Model) do
            --  util.PrecacheModel(v)
            if not table.HasValue(PrecacheModels, v) then
                table.insert(PrecacheModels, v)
                print("[PRECACHE] Precaching model:", v)
            end
        end
    else
        --util.PrecacheModel(teamtbl.Model)
        if not table.HasValue(PrecacheModels, teamtbl.Model) then
            table.insert(PrecacheModels, teamtbl.Model)
            print("[PRECACHE] Precaching model:", teamtbl.Model)
        end
    end

    if type(teamtbl.OtherModels) == "table" then
        for _, v in pairs(teamtbl.OtherModels) do
            --  util.PrecacheModel(v)
            if not table.HasValue(PrecacheModels, v) then
                table.insert(PrecacheModels, v)
                print("[PRECACHE] Precaching model:", v)
            end
        end
    else
        --   util.PrecacheModel(teamtbl.OtherModels)
        if not table.HasValue(PrecacheModels, teamtbl.OtherModels) then
            table.insert(PrecacheModels, teamtbl.OtherModels)
            print("[PRECACHE] Precaching model:", teamtbl.OtherModels)
        end
    end
    -- util.PrecacheModel("models/imperial_officer/officer.mdl")

    return count
end

if SERVER then
    if (not sql.TableExists("jobdata")) then
        sql.Query("CREATE TABLE IF NOT EXISTS jobdata ( steamid TEXT NOT NULL PRIMARY KEY, value TEXT );")
    end

    function meta:GetJData(name, default)
        name = string.format("%s[%s]", self:SteamID64(), name)
        local val = sql.QueryValue("SELECT value FROM jobdata WHERE steamid = " .. sql.SQLStr(name) .. " LIMIT 1")
        if (val == nil) then return default end

        return val
    end

    function meta:SetJData(name, value)
        name = string.format("%s[%s]", self:SteamID64(), name)
        sql.Query("REPLACE INTO jobdata ( steamid, value ) VALUES ( " .. sql.SQLStr(name) .. ", " .. sql.SQLStr(value) .. " )")
    end

    if not file.Exists("spawns.txt", "DATA") then
        file.Write("spawns.txt", util.TableToJSON({}))
    end

    local spawnTable = util.JSONToTable(file.Read("spawns.txt", "DATA"))

    hook.Add("Initialize", "Precacheafterloading", function()
        local models = table.Count(PrecacheModels)
        local count = -1
        local index = 0
        local percent = 0
        timer.Simple(30, function()
            for _, v in pairs(PrecacheModels) do
                count = count + 1

                timer.Simple(10 * count, function()
                    index = index + 1
                    percent = math.Round(index / models * 100)
                    print("[PRECACHE " .. percent .. "% ] Precaching model: " .. v)
                    PrintMessage( 3, "[PRECACHE " .. percent .. "% ] Precaching model: " .. v )
                    util.PrecacheModel(v)
                    if index == models then
                        PrintMessage( 3, "--Precaching Complete--")
                    end
                end)
            end
        end)
    end)

    hook.Add("IGPlayerSay", "SetSpawn", function(ply, text)
        if not ply:IsSuperAdmin() then return end
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

    function GM:PlayerInitialSpawn(ply)
        if ply:GetJData("job", nil) ~= nil then
            local job = ply:GetJData("job", nil)
            local tbl = TeamTable[tonumber(job)]
            ply:SetTeam(job)
            ply:Spawn()

            if type(tbl.Model) == "table" then
                ply:SetModel(table.Random(tbl.Model))
            else
                ply:SetModel(tbl.Model)
            end

            ply:SetBodyGroups(tbl.Bodygroups)
            ply:SetSkin(tonumber(tbl.Skin))
        else
            local tbl = TeamTable[TEAM_ST_RECRUIT]
            ply:SetJData("job", TEAM_ST_RECRUIT)
            ply:SetTeam(TEAM_ST_RECRUIT)

            if type(tbl.Model) == "table" then
                ply:SetModel(table.Random(tbl.Model))
            else
                ply:SetModel(tbl.Model)
            end
        end
    end

    local fistsblacklist = {}
    local fistblacklistreg = {"Recruit"}
    local hightierwepslist = {"rw_sw_dual_e11", "rw_sw_e11_hyperbeast", "rw_sw_tusken_cycler", "rw_sw_iqa11", "rw_sw_smartlauncher", "rw_sw_dt29_4", "rw_sw_trd_dlt19"}

    local hightierwepspretprint = {
        ["rw_sw_dual_e11"] = "Dual E-11's",
        ["rw_sw_e11_hyperbeast"] = "E-11 Hyperbeast",
        ["rw_sw_tusken_cycler"] = "Cycler Rifle",
        ["rw_sw_iqa11"] = "IQA-11",
        ["rw_sw_smartlauncher"] = "Smart Launcher",
        ["rw_sw_dt29_4"] = "DT29",
        ["rw_sw_trd_dlt19"] = "Training DLT-19"
    }

    function GM:PlayerSpawn(ply)
        if ply:GetNWInt("igquestprogress", 0) >= 16 then
            ply:SetRunSpeed(240 * 1.1)
            ply.runspeed = 240 * 1.1
            ply:SetWalkSpeed(160 * 1.1)
            ply.walkspeed = 160 * 1.1
        elseif ply:GetNWInt("igquestprogress", 0) >= 8 then
            ply:SetRunSpeed(240 * 1.1)
            ply.runspeed = 240 * 1.05
            ply:SetWalkSpeed(160 * 1.1)
            ply.walkspeed = 160 * 1.05
        else
            ply:SetRunSpeed(240)
            ply.runspeed = 240
            ply:SetWalkSpeed(160)
            ply.walkspeed = 160
        end

        if ply:IsAdmin() then
            ply:Give("weapon_physgun")
            ply:Give("gmod_tool")
        end

        ply.dmgtime = 0
        ply:SetNWBool("igbrokenleg", false)
        ply.brokenlegged = false
        ply.brokenleggedheal = 0

        if TeamTable[ply:Team()] then
            local tbl = TeamTable[ply:Team()]
            if  spawnTable[game.GetMap()] and tbl.Regiment == "Storm Trooper" and game.GetMap() == "rp_stardestroyer_v2_4_inf" then
                local num = math.random(1,4)
                print(string.lower(tbl.Regiment .. tostring(num)))
                ply:SetPos(spawnTable[game.GetMap()][string.lower(tbl.Regiment .. tostring(num))])
            elseif spawnTable[game.GetMap()] and spawnTable[game.GetMap()][string.lower(tbl.Regiment)] then
                ply:SetPos(spawnTable[game.GetMap()][string.lower(tbl.Regiment)])
            elseif spawnTable[game.GetMap()] and spawnTable[game.GetMap()]["default"] then
                ply:SetPos(spawnTable[game.GetMap()]["default"])
            end
        end

        if ply:GetJData("job", nil) ~= nil then
            if tonumber(ply:GetJData("job", nil)) ~= ply:Team() then
                local tbl = TeamTable[ply:Team()]

                if type(tbl.Model) == "table" then
                    ply:SetModel(table.Random(tbl.Model))
                else
                    ply:SetModel(tbl.Model)
                end

                local healthtogive = tbl.Health

                if ply:GetNWInt("igquestprogress", 0) >= 10 then
                    healthtogive = healthtogive * 1.2
                elseif ply:GetNWInt("igquestprogress", 0) >= 2 then
                    healthtogive = healthtogive * 1.1
                end

                ply:SetHealth(healthtogive)
                ply:SetMaxHealth(healthtogive)
                local weps = tbl.Weapons

                for i = 1, #weps do
                    ply:Give(weps[i])
                end

                if ply:GetNWInt("igquestprogress", 0) >= 19 then
                    local randweapon = table.Random(hightierwepslist)
                    ply:Give(randweapon)
                    ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
                end
            else
                local job = ply:GetJData("job", nil)
                local tbl = TeamTable[tonumber(job)]

                if type(tbl.Model) == "table" then
                    ply:SetModel(table.Random(tbl.Model))
                else
                    ply:SetModel(tbl.Model)
                end

                local healthtogive = tbl.Health

                if ply:GetNWInt("igquestprogress", 0) >= 10 then
                    healthtogive = healthtogive * 1.2
                elseif ply:GetNWInt("igquestprogress", 0) >= 2 then
                    healthtogive = healthtogive * 1.1
                end

                ply:SetHealth(healthtogive)
                ply:SetMaxHealth(healthtogive)
                local weps = tbl.Weapons

                for i = 1, #weps do
                    ply:Give(weps[i])
                end

                if ply:GetNWInt("igquestprogress", 0) >= 19 then
                    local randweapon = table.Random(hightierwepslist)
                    ply:Give(randweapon)
                    ply:ChatPrint("You have been given a " .. hightierwepspretprint[randweapon] .. " at random.")
                end
            end

            ply:Give("weapon_empty_hands")
            ply:Give("climb_swep2")
            ply:Give("comlink_swep")
            ply:Give("cross_arms_swep")
            ply:Give("cross_arms_infront_swep")
            ply:Give("point_in_direction_swep")
            ply:Give("salute_swep")
            ply:Give("surrender_animation_swep")
            ply:Give("bkeycard")

            if not table.HasValue(fistsblacklist, ply:SteamID()) and not table.HasValue(fistblacklistreg, TeamTable[ply:Team()].Regiment) then
                ply:Give("weapon_fists")
            end

            weps = ply:GetWeapons()

            for i = 1, #weps do
                if weps[i]:GetPrimaryAmmoType() == "RPG_Round" then
                    ply:GiveAmmo(3, weps[i]:GetPrimaryAmmoType(), true)
                end

                if weps[i]:GetPrimaryAmmoType() == "ar2" then
                    ply:GiveAmmo(256, weps[i]:GetPrimaryAmmoType(), true)
                end
            end
        end
        if TeamTable[ply:Team()].SpawnFunc then
            TeamTable[ply:Team()].SpawnFunc(ply)
        end
    end

    hook.Add("IGPlayerSay", "swapchatv2", function(ply, str)
        if (string.lower(str) == "!swap") then
            local PlyTeamRefa = TeamTable[ply:Team()].OtherModels
            local PlyModelRef = ply:GetModel()

            if not PlyTeamRefa then
                ply:ChatPrint("You do not have any other models to swap to.")

                return
            end

            if PlyModelRef == TeamTable[ply:Team()].Model and PlyTeamRefa[1] ~= nil then
                ply:SetModel(PlyTeamRefa[1])
            elseif PlyModelRef == PlyTeamRefa[1] and PlyTeamRefa[2] ~= nil then
                ply:SetModel(PlyTeamRefa[2])
            elseif PlyModelRef == PlyTeamRefa[2] and PlyTeamRefa[3] ~= nil then
                ply:SetModel(PlyTeamRefa[3])
            elseif PlyModelRef == PlyTeamRefa[3] and PlyTeamRefa[4] ~= nil then
                ply:SetModel(PlyTeamRefa[4])
            elseif PlyModelRef == PlyTeamRefa[4] and PlyTeamRefa[5] ~= nil then
                ply:SetModel(PlyTeamRefa[5])
            elseif PlyModelRef == PlyTeamRefa[5] and PlyTeamRefa[6] ~= nil then
                ply:SetModel(PlyTeamRefa[6])
            elseif PlyModelRef == PlyTeamRefa[6] and PlyTeamRefa[7] ~= nil then
                ply:SetModel(PlyTeamRefa[7])
            elseif PlyModelRef == PlyTeamRefa[7] and PlyTeamRefa[8] ~= nil then
                ply:SetModel(PlyTeamRefa[8])
            else
                ply:SetModel(TeamTable[ply:Team()].Model)
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
end

TEAM_ST_RECRUIT = CreateTeam( "Recruit", {
  Weapons = {"rw_sw_e11_recruit"},
  Clearance = "0",
  Colour = Color(200, 200, 200, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 0,
  Model = "models/player/tiki/white.mdl",
  Regiment = "Recruit",
} )

TEAM_ST_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11"},
  Clearance = "1",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 1,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11"},
  Clearance = "1",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 2,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11"},
  Clearance = "1",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 3,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11"},
  Clearance = "1",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 4,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 6,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 7,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 8,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 9,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 10,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_e11", "deployable_shield" },
  Health = 250,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 11,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 12,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 13,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 14,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 15,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 16,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 17,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_ST_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(102, 0, 102, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/sono/starwars/snowtrooper.mdl"},
  Rank = 18,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Storm Trooper",
} )

TEAM_WID_PRV = CreateTeam( "Member", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Clearance = "1",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_PFC = CreateTeam( "Senior Member", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Clearance = "1",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_LCPL = CreateTeam( "Assistant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_CPL = CreateTeam( "Senior Assistant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_SGT = CreateTeam( "Leading Assistant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_SSGT = CreateTeam( "Deputy Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_MSGT = CreateTeam( "Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_OC = CreateTeam( "Chief Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 150,
  Clearance = "2",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_WOT = CreateTeam( "Project Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 200,
  Clearance = "3",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 11,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_WOO = CreateTeam( "Community Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 200,
  Clearance = "3",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/chairman_director/cd_m.mdl"},
  Rank = 12,
  Model = "models/imperial_officer/navy/admiral/ad_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_HEAVY = CreateTeam( "Captain", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 200,
  Clearance = "3",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 13,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_SUPPORT = CreateTeam( "Sub-Administrator", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 200,
  Clearance = "3",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 14,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_SLT = CreateTeam( "Administrative Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 250,
  Clearance = "4",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 15,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_LT = CreateTeam( "Administrative Manager", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 250,
  Clearance = "4",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 16,
  Model = "models/player/female/isb.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_CPT = CreateTeam( "Administrator", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "gmod_camera", "gmod_cinematic_camera"},
  Health = 250,
  Clearance = "4",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 17,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_MAJ = CreateTeam( "Sector Administrator", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 300,
  Clearance = "5",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 18,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_LCOL = CreateTeam( "Prefect", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 300,
  Clearance = "5",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 19,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_COL = CreateTeam( "Superintendent", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 300,
  Clearance = "5",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 20,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_HCOL = CreateTeam( "Minister", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 350,
  Clearance = "6",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/chairman_director/cd_m.mdl"},
  Rank = 21,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_WID_BRIG = CreateTeam( "Vice Chair", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 350,
  Clearance = "6",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 22,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_IHC_MGEN = CreateTeam( "Major General", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_general1.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_LGEN = CreateTeam( "Lieutenant General", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_general1.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_GEN = CreateTeam( "General", {
  Weapons = {"rw_sw_rk3_officer", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "6",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_general2.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_HGEN = CreateTeam( "High General", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_general2.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_SMAR = CreateTeam( "Surface Marshal", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_general3.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_GGEN = CreateTeam( "Grand General", {
  Weapons = {"rw_sw_se14c_grand", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg", "rw_sw_e11_ihc"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/msc/grey/grey_m.mdl"},
  Rank = 5,
  Model = "models/player/banks/tk_arc/tk_wolf.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_RADM = CreateTeam( "Rear Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Bodygroups = "0000000021000220060001",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_VADM = CreateTeam( "Vice Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Bodygroups = "0000000021001230060001",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_ADM = CreateTeam( "Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "6",
  Bodygroups = "0000000021002240060001",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_FADM = CreateTeam( "Fleet Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Bodygroups = "0000000021002230070001",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_HADM = CreateTeam( "High Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Bodygroups = "0000000021002240080001",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_CON = CreateTeam( "Counselor", {
  Weapons = {"rw_sw_dt29_1", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/bailey/galliusrax.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_GADTHR = CreateTeam( "Grand Admiral", {
  Weapons = {"rw_sw_rk3_grand", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/valley/thrawn.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_AGEN = CreateTeam( "", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 5,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  RealName = "Aide - CL3",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_VMAR = CreateTeam( "", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "4",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 5,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  RealName = "Aide - CL4",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_AMAR = CreateTeam( "", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 5,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  RealName = "Aide - CL5",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_CAM = CreateTeam( "Extra", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_HMAR = CreateTeam( "Extra", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_elastic", "rw_sw_stun_e11",  "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_IHC_DIR = CreateTeam( "Director", {
  Weapons = {"rw_sw_rk3_grand", "rw_sw_stun_e11", "weapon_cuff_elastic", "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Bodygroups = "0010000001000670070000",
  Colour = Color(0, 19, 77, 255 ),
  Side = 1,
  Rank = 15,
  Model = "models/imperial_officer/msc/red/red_m.mdl",
  Regiment = "Imperial High Command",
} )

TEAM_GOV_AA = CreateTeam( "Administrative Assistant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Clearance = "1",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 1,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_JC = CreateTeam( "Junior Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 5,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_AC = CreateTeam( "Assistant Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 6,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_UC = CreateTeam( "Under Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 7,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_DC = CreateTeam( "Deputy Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 8,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_CLERK = CreateTeam( "Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 9,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_PC = CreateTeam( "Principal Clerk", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 10,
  Model = "models/player/female/rgofficer.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_USEC = CreateTeam( "Under Secretary", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 11,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_DSEC = CreateTeam( "Deputy Secretary", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 12,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_SEC = CreateTeam( "Secretary", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 13,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_PSEC = CreateTeam( "Principal Secretary", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 14,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_ESEC = CreateTeam( "Executive Secretary", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 15,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_COS = CreateTeam( "Chief of Staff", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 16,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_GOV = CreateTeam( "Governor", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 17,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_MOFF = CreateTeam( "Moff", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 400,
  Clearance = "6",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 18,
  Model = "models/imperial_officer/msc/grey/grey_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_GENR = CreateTeam( "General", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Bodygroups = "0100000001001624000000",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/gov/sec_clerk/sc_m.mdl"},
  Rank = 19,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_MJR = CreateTeam( "Major", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "3",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 20,
  Model = "models/imperial_officer/gov/moff_general/mg_m.mdl",
  Regiment = "Regional Government",
} )

TEAM_GOV_GMOFFT = CreateTeam( "Grand Moff", {
  Weapons = {"rw_sw_e11_ihc","rw_sw_rk3_grand", "weapon_rpw_binoculars_nvg", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Colour = Color(178, 169, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 20,
  Model = "models/player/heracles421/tarkin//moff_tarkin.mdl",
  Regiment = "Regional Government",
} )

TEAM_NAVY_CAD = CreateTeam( "Crewman", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Clearance = "1",
  Bodygroups = "0000000000000000000000",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/crewman/inferno_squad_crewman.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_JCREW = CreateTeam( "Able Crewman", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Clearance = "1",
  Bodygroups = "0000000000000000100000",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/crewman/inferno_squad_crewman.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_CREW = CreateTeam( "Senior Crewman", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Clearance = "1",
  Bodygroups = "0000000010001020100001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/crewman/inferno_squad_crewman.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_ACREW = CreateTeam( "Leading Crewman", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Clearance = "1",
  Bodygroups = "0000000010001000200001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/crewman/inferno_squad_crewman.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_LCREW = CreateTeam( "Petty Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000010001010200001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_CHIEF = CreateTeam( "Chief Petty Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000010001100300001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_MCHIEF = CreateTeam( "Senior Chief Petty Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000010001100300001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_OC = CreateTeam( "Master Chief Petty Officer", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000020002200400001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_MSM = CreateTeam( "Midshipman", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000020002200500001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_ENSIG = CreateTeam( "Ensign", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000020002200600001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/imperial_officer/navy/ensign_cadet/ec_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_JLT = CreateTeam( "Junior Lieutenant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010700001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 11,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_SLT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010800001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 12,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_LT = CreateTeam( "Senior Lieutenant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000010001210010001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_LTC = CreateTeam( "Lieutenant Commander", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000010001210020001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 14,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_COMM = CreateTeam( "Commander", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000010001210030001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 15,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000021002210040001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 16,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_LCPT = CreateTeam( "Line Captain", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000021002220040001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 17,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_NAVY_COMMDRE = CreateTeam( "Commodore", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_noscope", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Bodygroups = "0000000021002220050001",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 18,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy",
} )

TEAM_ENG_JAN = CreateTeam( "Janitor", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope"},
  Clearance = "1",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 1,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_JWRK = CreateTeam( "Junior Workman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope"},
  Clearance = "1",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 2,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_WRK = CreateTeam( "Workman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope"},
  Clearance = "1",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 3,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_SWRK = CreateTeam( "Senior Workman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope"},
  Clearance = "1",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 4,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_TAPP = CreateTeam( "Technican Apprentice", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 5,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_JTECH = CreateTeam( "Junior Technician", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 6,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_TECH = CreateTeam( "Technician", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 7,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_STECH = CreateTeam( "Senior Technician", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 8,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_MTECH = CreateTeam( "Master Technician", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 9,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_JENG = CreateTeam( "Junior Engineer", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet"},
  Health = 150,
  Clearance = "2",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 10,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_ENG = CreateTeam( "Engineer", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 11,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_SENG = CreateTeam( "Senior Engineer", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 12,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_CENG = CreateTeam( "Chief Engineer", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 13,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_MENG = CreateTeam( "Master Engineer", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 14,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_JFOR = CreateTeam( "Junior Foreman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 15,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_FOR = CreateTeam( "Foreman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 16,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_SFOR = CreateTeam( "Senior Foreman", {
  Weapons = {"weapon_physgun", "rw_sw_rk3", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 17,
  Model = "models/crewman/hcn_gunner.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_AMAN = CreateTeam( "Manager", {
  Weapons = {"weapon_physgun", "rw_sw_rk3_officer", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Bodygroups = "0000000000000020050000",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"},
  Rank = 18,
  Model = "models/imperial_officer/navy/commodore_lieutenant/cl_m.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_MAN = CreateTeam( "Doctor", {
  Weapons = {"weapon_physgun", "rw_sw_rk3_officer", "alydus_fusioncutter", "gmod_tool", "cityworker_wrench", "cityworker_shovel", "cityworker_pliers", "rw_sw_e11_noscope", "alydus_fortificationbuildertablet", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "AREA ACCESS",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 19,
  Model = "models/galen_erso/galen_erzo.mdl",
  Regiment = "Navy Engineer",
} )

TEAM_ENG_OMAN = CreateTeam( "Chair", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "gmod_camera", "gmod_cinematic_camera"},
  Health = 400,
  Clearance = "6",
  Colour = Color(250, 250, 55, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/isb.mdl"},
  Rank = 22,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "Coalition for Progress",
} )

TEAM_ENG_DDIR = CreateTeam( "Deputy Director", {
  Weapons = {""},
  Health = 300,
  Clearance = "6",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 21,
  Model = "",
  Regiment = "Spare 0",
} )

TEAM_ENG_DIR = CreateTeam( "Director", {
  Weapons = {""},
  Health = 300,
  Clearance = "6",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 22,
  Model = "",
  Regiment = "Spare 0",
} )

TEAM_ENG_DOC = CreateTeam( "Doctor", {
  Weapons = {""},
  Health = 250,
  Clearance = "AREA ACCESS",
  Colour = Color(102, 102, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "",
  Regiment = "Spare 0",
} )

TEAM_ISB_KALLUS = CreateTeam( "", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/valley/kallus.mdl",
  Regiment = "ISB",
  RealName = "Kallus",
} )

TEAM_ISB_AO = CreateTeam( "Acting Operative", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Clearance = "1",
  Bodygroups = "0000000000000020100000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 3,
  Model = "models/imperial_officer/isb/operative/op_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_JO = CreateTeam( "Junior Operative", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Clearance = "1",
  Bodygroups = "0000000000000000200000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 4,
  Model = "models/imperial_officer/isb/operative/op_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_OP = CreateTeam( "Operative", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000010200000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 5,
  Model = "models/imperial_officer/isb/operative/op_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_SO = CreateTeam( "Senior Operative", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000000300000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 6,
  Model = "models/imperial_officer/isb/operative/op_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_MO = CreateTeam( "Master Operative", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000020300000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 7,
  Model = "models/imperial_officer/isb/operative/op_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_AA = CreateTeam( "Acting Agent", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000000400000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 8,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_JA = CreateTeam( "Junior Agent", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000000500000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 9,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_AG = CreateTeam( "Agent", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Bodygroups = "0000000000000000600000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 10,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_SA = CreateTeam( "Head Agent", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010700000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 11,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_SPA = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010800000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 12,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_HA = CreateTeam( "Captain", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010010000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/female/trooper.mdl"},
  Rank = 13,
  Model = "models/imperial_officer/isb/agent/ag_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_ACOL = CreateTeam( "Major", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Bodygroups = "0000000000000010020000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl","models/player/female/isb.mdl"},
  Rank = 14,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_LCOL = CreateTeam( "Commander", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000000000010030000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 15,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000000000010040000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 16,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_AC = CreateTeam( "Senior Colonel", {
  Weapons = {"rw_sw_rk3", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Bodygroups = "0000000000000020040000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 17,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_CH = CreateTeam( "Deputy Chief", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_noscope", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Bodygroups = "0000000000000020050000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 18,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_ABC = CreateTeam( "Chief", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "5",
  Bodygroups = "0000000000000020060000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 19,
  Model = "models/imperial_officer/isb/chief/ch_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_BC = CreateTeam( "Bureau Chief", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "5",
  Bodygroups = "0000000000000030060000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 20,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_ADM = CreateTeam( "Assistant Director", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "6",
  Bodygroups = "0000000000000040060000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 21,
  Model = "models/garrick_versio/garrick_versio.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_DD = CreateTeam( "Deputy Director", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "6",
  Bodygroups = "0000000000000030070000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl", "models/player/female/isb.mdl"},
  Rank = 22,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_CPTDUNSTIG = CreateTeam( "Admiral", {
  Weapons = {"rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "6",
  Bodygroups = "0010000000000020020000",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl"},
  Rank = 14,
  Model = "models/garrick_versio/garrick_versio.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_DIRKR = CreateTeam( "Director", {
  Weapons = {"rw_sw_dt29_2", "rw_sw_rk3_officer", "rw_sw_e11_ihc", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "6",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl"},
  Rank = 23,
  Model = "models/player/hydro/swbf_krennic/swbf_krennic.mdl",
  Regiment = "ISB",
} )

TEAM_ISB_CHR = CreateTeam( "Director General", {
  Weapons = {"rw_sw_rk3_grand", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 500,
  Clearance = "ALL ACCESS",
  Colour = Color(225, 225, 153, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/isb.mdl"},
  Rank = 24,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "ISB",
} )

TEAM_INF_ID10 = CreateTeam( "ID10", {
  Weapons = {"rw_sw_rk3", "weapon_camo", "rw_sw_stun_e11", "weapon_bactainjector", "weapon_rpw_binoculars_nvg", "rw_sw_tl50"},
  Health = 350,
  Clearance = "AREA ACCESS",
  Colour = Color(217, 20, 20, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/seeker_droid2/seeker_droid2.mdl",
  Regiment = "Inferno Squad",
} )

TEAM_INF_DEL = CreateTeam( "[INF-04]", {
  Weapons = {"rw_sw_tl50", "rw_sw_rk3", "weapon_cuff_tactical", "rw_sw_dlt19x", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(217, 20, 20, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/pilot/inferno_squad_pilot.mdl",
  Regiment = "Inferno Squad",
} )

TEAM_INF_SEYN = CreateTeam( "[INF-03]", {
  Weapons = {"rw_sw_tl50", "rw_sw_rk3", "weapon_cuff_tactical", "rw_sw_dlt19x", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(217, 20, 20, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/markus/ot_inferno_squad_del/ot_inferno_squad_del_playermodel.mdl",
  Regiment = "Inferno Squad",
} )

TEAM_INF_HASK = CreateTeam( "[INF-02]", {
  Weapons = {"rw_sw_tl50", "rw_sw_rk3", "weapon_cuff_tactical", "rw_sw_dlt19x", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(217, 20, 20, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/markus/ot_inferno_squad_hask/ot_inferno_squad_hask_playermodel.mdl",
  Regiment = "Inferno Squad",
} )

TEAM_INF_IDEN = CreateTeam( "[INF-01]", {
  Weapons = {"rw_sw_tl50", "rw_sw_rk3", "weapon_cuff_tactical", "rw_sw_dlt19x", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(217, 20, 20, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 12,
  Model = "models/player/markus/ot_inferno_squad_iden_versio/ot_inferno_squad_iden_versio_playermodel.mdl",
  Regiment = "Inferno Squad",
} )

TEAM_MED_PVT = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/banks/mtroopers/mtrooper.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/banks/mtroopers/mtrooper.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/banks/mtroopers/mtrooper.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/banks/mtroopers/mtrooper.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl"},
  Rank = 8,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl"},
  Rank = 9,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl"},
  Rank = 10,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 11,
  Model = "models/player/banks/mtroopers/mofficer.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 12,
  Model = "models/player/banks/mtroopers/mofficer.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/banks/mtroopers/mofficer.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/banks/mtroopers/mofficer.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/banks/mcommander/mcommander.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/banks/mcommander/mcommander.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/banks/mcommander/mcommander.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_MED_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11", "weapon_multihealer", "weapon_jew_stimkit", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator", "rw_sw_dlt19", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(255, 51, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/male/medic.mdl", "models/player/female/medic.mdl"},
  Rank = 18,
  Model = "models/player/banks/mcommander/mcommander.mdl",
  Regiment = "Medical Trooper",
} )

TEAM_SK_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bunny/imperial_shock/shock_trooper.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bunny/imperial_shock/shock_trooper.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bunny/imperial_shock/shock_trooper.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bunny/imperial_shock/shock_trooper.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/bunny/imperial_shock/shock_sergeant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 11,
  Model = "models/player/bunny/imperial_shock/shock_lieutenant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 12,
  Model = "models/player/bunny/imperial_shock/shock_lieutenant.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 13,
  Model = "models/player/bunny/imperial_shock/shock_officer.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg", "heavy_shield"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 14,
  Model = "models/player/bunny/imperial_shock/shock_officer.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg", "heavy_shield"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 15,
  Model = "models/player/bunny/imperial_shock/shock_commander.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg", "heavy_shield"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 16,
  Model = "models/player/bunny/imperial_shock/shock_commander.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg", "heavy_shield"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 17,
  Model = "models/player/bunny/imperial_shock/shock_commander.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_SK_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_stun_e11", "rw_sw_dlt19", "rw_sw_se14c", "weapon_rpw_binoculars_nvg", "heavy_shield"},
  Health = 350,
  Clearance = "5",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 18,
  Model = "models/player/bunny/imperial_shock/shock_commander.mdl",
  Regiment = "Shock Trooper",
} )

TEAM_RT_PVT = CreateTeam( "Trainee", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 250,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_PFC = CreateTeam( "Trooper", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 250,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_LCPL = CreateTeam( "Trooper", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 250,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_CPL = CreateTeam( "Trooper", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 250,
  Clearance = "1",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 275,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_SSGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 275,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_MSGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 275,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_OC = CreateTeam( "Warrant Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_WOT = CreateTeam( "Warrant Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_WOO = CreateTeam( "Warrant Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "riot_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_SLT = CreateTeam( "Senior Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 11,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_LT = CreateTeam( "Senior Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 12,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_CPT = CreateTeam( "Senior Officer", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 13,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_MAJ = CreateTeam( "Commander", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 14,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 15,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 16,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 17,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_RT_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11", "rw_sw_e44", "weapon_cuff_tactical", "weapon_cuff_elastic", "rw_sw_dp23", "rw_sw_stun_e11", "heavy_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(255, 77, 77, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl", "models/player/female/trooper.mdl"},
  Rank = 18,
  Model = "models/player/ven/tk_major_01/tk_major.mdl",
  Regiment = "Riot Trooper",
} )

TEAM_BS_CAD = CreateTeam( "Cadet", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 1,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_SPB = CreateTeam( "Spaceman Basic", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 2,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_SPC = CreateTeam( "Spaceman", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 3,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_LSM = CreateTeam( "Leading Spacecraftsman", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 4,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_FCP = CreateTeam( "Flight Corporal", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 5,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_FSG = CreateTeam( "Flight Sergeant", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 6,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_FCH = CreateTeam( "Flight Chief", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 7,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_OFC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 8,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_WOI = CreateTeam( "Warrant Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 9,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_WOII = CreateTeam( "Chief Warrant Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 10,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_FO = CreateTeam( "Flight Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 11,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_FLT = CreateTeam( "Flight Lieutenant", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 12,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_CAP = CreateTeam( "Flight Captain", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_SLD = CreateTeam( "Squadron Leader", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_06_p/pilot_imperial_orig_06_p.mdl",
  Regiment = "ISC",
} )

TEAM_BS_WCD = CreateTeam( "Wing Commander", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_02_r/pilot_imperial_orig_02_r.mdl",
  Regiment = "ISC",
} )

TEAM_BS_GCAP = CreateTeam( "Group Captain", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_02_r/pilot_imperial_orig_02_r.mdl",
  Regiment = "ISC",
} )

TEAM_BS_COML = CreateTeam( "Command Leader", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_02_r/pilot_imperial_orig_02_r.mdl",
  Regiment = "ISC",
} )

TEAM_BS_AIRC = CreateTeam( "Air Commodore", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(156, 0, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_05_o/pilot_imperial_orig_05_o.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_02_r/pilot_imperial_orig_02_r.mdl",
  Regiment = "ISC",
} )
TEAM_NS_CAD = CreateTeam( "", {
  Weapons = {""},
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  RealName = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_SPB = CreateTeam( "Imperial Heavy", {
  Weapons = {""},
  Health = 1250,
  Clearance = "1",
  Colour = Color(119, 136, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/exec/swbf2015/playermodels/exec_stormtrooper.mdl",
  Regiment = "Event2",
} )

TEAM_NS_SPC = CreateTeam( "Imperial Medic", {
  Weapons = {""},
  Health = 500,
  Clearance = "1",
  Colour = Color(119, 136, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/banks/mtroopers/msergeant.mdl",
  Regiment = "Event2",
} )

TEAM_NS_LSM = CreateTeam( "Imperial Trooper", {
  Weapons = {""},
  Health = 1000,
  Clearance = "1",
  Colour = Color(119, 136, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_FCP = CreateTeam( "Imperial Commander", {
  Weapons = {""},
  Health = 1500,
  Clearance = "2",
  Colour = Color(119, 136, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_FSG = CreateTeam( "Sith Inquisitor", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18"},
  Health = 2000,
  Clearance = "2",
  Colour = Color(119, 136, 153, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/valley/eighth_brother.mdl",
  Regiment = "Event2",
} )

TEAM_NS_FCH = CreateTeam( "Flight Chief", {
  Weapons = {""},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_OFC = CreateTeam( "Officer Cadet", {
  Weapons = {""},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_WOI = CreateTeam( "Warrant Officer", {
  Weapons = {""},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "",
  Regiment = "Event2",
} )

TEAM_NS_WOII = CreateTeam( "Chief Warrant Officer", {
  Weapons = {""},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_FO = CreateTeam( "Flight Officer", {
  Weapons = {""},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 11,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_FLT = CreateTeam( "Flight Lieutenant", {
  Weapons = {""},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 12,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_CAP = CreateTeam( "Flight Captain", {
  Weapons = {""},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_NS_SLD = CreateTeam( "Squadron Leader", {
  Weapons = {""},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 151, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 14,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event2",
} )

TEAM_G_EP = CreateTeam( "Galactic Emperor", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 5000,
  Clearance = "ALL ACCESS",
  Colour = Color(68,68,68, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/emperor_palpatine.mdl",
  RealName = "Palpatine",
  Regiment = "Imperial Ruler",
} )

TEAM_BH_ZUCK = CreateTeam( "", {
  Weapons = {"rw_sw_e44", "weapon_cuff_elastic", "rw_sw_nt242c", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/tiki/zuckuss.mdl",
  Regiment = "Bounty Hunter",
  RealName = "Zuckuss",
} )

TEAM_BH_IG88 = CreateTeam( "", {
  Weapons = {"rw_sw_e5c", "rw_sw_dual_e11", "weapon_cuff_elastic", "Dartgun", "rw_sw_dlt20a", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/kryptonite/ig88/ig88.mdl",
  Regiment = "Bounty Hunter",
  RealName = "IG-88",
} )

TEAM_BH_4LOM = CreateTeam( "", {
  Weapons = {"rw_sw_dlt19x", "weapon_cuff_elastic", "rw_sw_dlt19", "rw_sw_huntershotgun", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/kryptonite/4lom/4lom.mdl",
  Regiment = "Bounty Hunter",
  RealName = "4-LOM",
} )

TEAM_MUD_PRV = CreateTeam( "Private", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 150,
  Clearance = "1",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 1,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_PFC = CreateTeam( "Private First Class", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 150,
  Clearance = "1",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 2,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 150,
  Clearance = "1",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 3,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_CPL = CreateTeam( "Corporal", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 150,
  Clearance = "1",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 4,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_SGT = CreateTeam( "Sergeant", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 6,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 7,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 8,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 9,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 10,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "deployable_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19"},
  Health = 200,
  Clearance = "2",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl"},
  Rank = 5,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "3",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 11,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_LT = CreateTeam( "Lieutenant", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "3",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 12,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_CPT = CreateTeam( "Captain", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "3",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_MAJ = CreateTeam( "Major", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "3",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "4",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_COL = CreateTeam( "Colonel", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "4",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "4",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_MUD_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"ven_e22", "rw_sw_scoutblaster", "rw_sw_dlt19", "rw_sw_dc17m_launcher", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "5",
  Colour = Color(91, 43, 43, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/mud_trooper/mud_trooper.mdl", "models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/ven/tk_mimban_01/tk_mimban.mdl",
  Regiment = "224th Trooper",
} )

TEAM_996_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 200,
  Clearance = "1",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bunny/imperial_996/996_trooper.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 200,
  Clearance = "1",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bunny/imperial_996/996_trooper.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 200,
  Clearance = "1",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bunny/imperial_996/996_trooper.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 200,
  Clearance = "1",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bunny/imperial_996/996_trooper.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_996/996_sergeant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/bunny/imperial_996/996_lieutenant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/bunny/imperial_996/996_lieutenant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/bunny/imperial_996/996_lieutenant.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/bunny/imperial_996/996_officer.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/bunny/imperial_996/996_commander.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/bunny/imperial_996/996_commander.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/bunny/imperial_996/996_commander.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_996_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc17c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(195, 210, 78, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/bunny/imperial_996/996_commander.mdl",
  Regiment = "996th Guard Division",
} )

TEAM_212_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_e11", "rw_sw_relbyv10", "flamethrower_basic", "flamethrower_variant", "deployable_shield"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "rw_sw_e11", "weapon_bactainjector", "rw_sw_relbyv10", "flamethrower_basic", "flamethrower_variant"},
  Health = 150,
  Clearance = "2",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_212_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_relbyv10", "rw_sw_e11", "flamethrower_basic", "flamethrower_variant", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(255, 79, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/flametrooper.mdl",
  Regiment = "Flame Trooper",
} )

TEAM_442_PRV = CreateTeam( "Candidate", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 150,
  Clearance = "1",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_PFC = CreateTeam( "Trooper", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 150,
  Clearance = "1",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 150,
  Clearance = "1",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 150,
  Clearance = "1",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_SSGT = CreateTeam( "Senior Sergeant", {
  Weapons = {"rw_sw_tl40", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_MSGT = CreateTeam( "Sergeant Major", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_WOT = CreateTeam( "Sub Officer", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_WOO = CreateTeam( "Officer", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "2",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_HEAVY = CreateTeam( "Senior Officer", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 250,
  Clearance = "3",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 11,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_SUPPORT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 250,
  Clearance = "3",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  Rank = 12,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_SLT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 250,
  Clearance = "3",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_LT = CreateTeam( "Brigade Major", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 250,
  Clearance = "3",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_CPT = CreateTeam( "Commander", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 300,
  Clearance = "4",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_MAJ = CreateTeam( "Senior Commander", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 300,
  Clearance = "4",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/chief/ch_m.mdl"},
  Rank = 16,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_LCOL = CreateTeam( "Brigade Commander", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 300,
  Clearance = "4",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/chief/ch_m.mdl"},
  Rank = 17,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_COL = CreateTeam( "Sector Commander", {
  Weapons = {"rw_sw_tl40", "rw_sw_dc19", "rw_sw_se14c", "weapon_camo", "weapon_cuff_elastic"},
  Health = 350,
  Clearance = "5",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/chief/ch_m.mdl"},
  Rank = 18,
  Model = "models/player/bailey/compforce.mdl",
  Regiment = "CompForce",
} )

TEAM_442_HCOL = CreateTeam( "Sub-Command General", {
  Weapons = {"rw_sw_e11_ihc", "rw_sw_rk3_officer", "weapon_cuff_elastic"},
  Health = 350,
  Clearance = "5",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/bailey/compforce.mdl"},
  Rank = 19,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "CompForce",
} )

TEAM_442_BRIG = CreateTeam( "Command General", {
  Weapons = {"rw_sw_e11_ihc", "rw_sw_rk3_officer", "weapon_cuff_elastic"},
  Health = 350,
  Clearance = "5",
  Colour = Color(166, 121, 0, 31),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/bailey/compforce.mdl"},
  Rank = 20,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "CompForce",
} )

TEAM_JT_PRV = CreateTeam( "Private", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_PFC = CreateTeam( "Private First Class", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_CPL = CreateTeam( "Corporal", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_SGT = CreateTeam( "Sergeant", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "rw_sw_t21", "deployable_shield"},
  Health = 250,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_LT = CreateTeam( "Lieutenant", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_CPT = CreateTeam( "Captain", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_MAJ = CreateTeam( "Major", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/ven/tk_jumptrooper_01/tk_jumptrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/ven/tk_skytrooper_01/tk_skytrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_COL = CreateTeam( "Colonel", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/ven/tk_skytrooper_01/tk_skytrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/ven/tk_skytrooper_01/tk_skytrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_JT_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"weapon_jetpack", "rw_sw_rt97c", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(15, 112, 169, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/ven/tk_skytrooper_01/tk_skytrooper.mdl",
  Regiment = "Jump Trooper",
} )

TEAM_SDW_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "deployable_shield"},
  Health = 275,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_t21b", "rw_sw_t21", "weapon_camo"},
  Health = 150,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/ven/tk_shadowtrooper_01/tk_shadowtrooper.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/banks/commander1/commander1.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/banks/commander1/commander1.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/banks/commander1/commander1.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SDW_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_t21b", "rw_sw_t21", "weapon_camo", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/banks/commander1/commander1.mdl",
  Regiment = "Shadow Trooper",
} )

TEAM_SHR_PRV = CreateTeam( "Private", {
  Weapons = {"ven_e22", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bunny/coastal_defense/shoretrooper.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_PFC = CreateTeam( "Private First Class", {
  Weapons = {"ven_e22", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bunny/coastal_defense/shoretrooper.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"ven_e22", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bunny/coastal_defense/shoretrooper.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_CPL = CreateTeam( "Corporal", {
  Weapons = {"ven_e22", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bunny/coastal_defense/shoretrooper.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_SGT = CreateTeam( "Sergeant", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "ven_e22", "zeus_thermaldet", "rw_sw_e11", "deployable_shield"},
  Health = 250,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "zeus_thermaldet", "ven_e22", "rw_sw_e11"},
  Health = 150,
  Clearance = "2",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/coastal_defense/shoretrooper_sergeant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/bunny/coastal_defense/shoretrooper_lieutenant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_LT = CreateTeam( "Lieutenant", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/bunny/coastal_defense/shoretrooper_lieutenant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_CPT = CreateTeam( "Captain", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/bunny/coastal_defense/shoretrooper_lieutenant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_MAJ = CreateTeam( "Major", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/bunny/coastal_defense/shoretrooper_lieutenant.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/bunny/coastal_defense/shoretrooper_commander.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_COL = CreateTeam( "Colonel", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/bunny/coastal_defense/shoretrooper_commander.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/bunny/coastal_defense/shoretrooper_commander.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_SHR_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"ven_e22", "zeus_thermaldet", "rw_sw_e11", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(213, 171, 53, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/bunny/coastal_defense/shoretrooper_commander.mdl",
  Regiment = "Shore Trooper",
} )

TEAM_374_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 200,
  Clearance = "1",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 200,
  Clearance = "1",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 200,
  Clearance = "1",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 200,
  Clearance = "1",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 250,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield"},
  Health = 400,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_t21b", "rw_sw_huntershotgun"},
  Health = 300,
  Clearance = "2",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "3",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "4",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "4",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "4",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_374_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_t21b", "rw_sw_huntershotgun", "deployable_shield", "weapon_rpw_binoculars_nvg"},
  Health = 400,
  Clearance = "5",
  Colour = Color(59, 11, 5, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/sono/specopstorm/bshadow.mdl",
  Regiment = "374th Reinforced Infantry",
} )

TEAM_VF_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bunny/imperial_501_revision/501_trooper.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bunny/imperial_501_revision/501_trooper.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bunny/imperial_501_revision/501_trooper.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11"},
  Clearance = "1",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bunny/imperial_501_revision/501_trooper.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "deployable_shield"},
  Health = 250,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24"},
  Health = 150,
  Clearance = "2",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/bunny/imperial_501_revision/501_sergeant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 11,
  Model = "models/player/bunny/imperial_501_revision/501_lieutenant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 12,
  Model = "models/player/bunny/imperial_501_revision/501_lieutenant.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/bunny/imperial_501_revision/501_officer.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/bunny/imperial_501_revision/501_officer.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/bunny/imperial_501_revision/501_commander.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/bunny/imperial_501_revision/501_commander.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/bunny/imperial_501_revision/501_commander.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_VF_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_dc15s", "rw_sw_e11", "rw_sw_dp24", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(0, 63, 255, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/bunny/imperial_501_revision/501_commander.mdl",
  Regiment = "Vader's Fist Trooper",
} )

TEAM_SCOUT_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Clearance = "1",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 1,
  Model = "models/sono/swbf3/scout.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Clearance = "1",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 2,
  Model = "models/sono/swbf3/scout.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Clearance = "1",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 3,
  Model = "models/sono/swbf3/scout.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Clearance = "1",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 4,
  Model = "models/sono/swbf3/scout.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 5,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 6,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 7,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 8,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 9,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 10,
  Model = "models/sono/swbf3/sergeant.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "rw_sw_t21", "weapon_rpw_binoculars_nvg", "deployable_shield"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 11,
  Model = "models/sono/swbf3/backpack.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster",  "weapon_jew_stimkit", "weapon_bactainjector", "weapon_rpw_binoculars_nvg"},
  Health = 150,
  Clearance = "2",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/backpack.mdl"},
  Rank = 12,
  Model = "models/sono/swbf3/scout.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 13,
  Model = "models/sono/swbf3/officer.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 14,
  Model = "models/sono/swbf3/officer.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 15,
  Model = "models/sono/swbf3/officer.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 16,
  Model = "models/sono/swbf3/officer.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 17,
  Model = "models/sono/swbf3/commander.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 18,
  Model = "models/sono/swbf3/commander.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "4",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 19,
  Model = "models/sono/swbf3/commander.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_SCOUT_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_nt242c", "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 250,
  Clearance = "5",
  Colour = Color(161, 161, 161, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/sono/swbf3/forest.mdl"},
  Rank = 20,
  Model = "models/sono/swbf3/commander.mdl",
  Regiment = "Scout Trooper",
} )

TEAM_31_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 200,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/sample/purge/trooper/trooperupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 200,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/sample/purge/trooper/trooperupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 200,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/sample/purge/trooper/trooperupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 200,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/sample/purge/trooper/trooperupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/sample/purge/sgt/sgtupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sample/purge/specialist/specialistupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_dc15a", "rw_sw_dc15le", "swep_mexicanelectrostaff"},
  Health = 250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/sample/purge/specialist/specialistupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/player/sample/purge/officer/officerupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/sample/purge/officer/officerupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/sample/purge/officer/officerupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/sample/purge/officer/officerupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/sample/purge/commander/commanderupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/sample/purge/commander/commanderupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/sample/purge/commander/commanderupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_31_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_dc15a", "rw_sw_dc15le", "rw_sw_dp23", "swep_mexicanelectrostaff", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/sample/purge/commander/commanderupdate.mdl",
  Regiment = "Purge Trooper",
} )

TEAM_DT_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 200,
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 1,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 200,
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 2,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 200,
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 3,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 200,
  Clearance = "1",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 4,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 5,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 6,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 7,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 8,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 9,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "weapon_cuff_elastic", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 10,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_e11d", "weapon_cuff_elastic", "rw_sw_dlt19d", "thermal_flir", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 5,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_e11d", "weapon_cuff_elastic", "rw_sw_dlt19d", "thermal_flir"},
  Health = 250,
  Clearance = "2",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 5,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 13,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 14,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 15,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 16,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 17,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 18,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_DT_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 19,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

  TEAM_DT_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11d", "rw_sw_dlt19d", "rw_sw_se14c", "weapon_cuff_elastic", "thermal_flir", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(23, 23, 23, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_01/deathtrooper_01_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_04/deathtrooper_04_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_04/deathtrooper_04_female_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_03/deathtrooper_03_male_mesh.mdl","models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_03/deathtrooper_03_female_mesh.mdl"},
  Rank = 20,
  Model = "models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_01/deathtrooper_01_male_mesh.mdl",
  Regiment = "Death Trooper",
} )

TEAM_IC_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 200,
  Clearance = "1",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 200,
  Clearance = "1",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 200,
  Clearance = "1",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 200,
  Clearance = "1",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang"},
  Health = 250,
  Clearance = "2",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_IC_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_dc17m", "rw_sw_dc15x", "rw_sw_dc17", "zeus_flashbang", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(7, 164, 164, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/grealms/characters/imperialcommando/imperialcommando.mdl",
  Regiment = "Imperial Commando",
} )

TEAM_SC_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 200,
  Clearance = "1",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/shepherdmod/storm/sarge/storm_sergeant.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 200,
  Clearance = "1",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/shepherdmod/storm/sarge/storm_sergeant.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 200,
  Clearance = "1",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/shepherdmod/storm/sarge/storm_sergeant.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 200,
  Clearance = "1",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/shepherdmod/storm/sarge/storm_sergeant.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x"},
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_e11", "rw_sw_valken38x",  "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_e11", "rw_sw_valken38x", },
  Health = 250,
  Clearance = "2",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/shepherdmod/storm/officer/storm_officer.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/shepherdmod/storm/captain/storm_captain.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/shepherdmod/storm/captain/storm_captain.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/shepherdmod/storm/captain/storm_captain.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/shepherdmod/storm/captain/storm_captain.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/shepherdmod/storm/commander/storm_commander.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/shepherdmod/storm/commander/storm_commander.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/shepherdmod/storm/commander/storm_commander.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SC_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11", "rw_sw_valken38x",  "rw_sw_scoutblaster", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(150, 135, 135, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/shepherdmod/storm/commander/storm_commander.mdl",
  Regiment = "Storm Commando",
} )

TEAM_SCAR_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 200,
  Clearance = "1",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_pvt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 200,
  Clearance = "1",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_pvt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 200,
  Clearance = "1",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_pvt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 200,
  Clearance = "1",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_pvt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_dc19le", "rw_sw_sg6", "weapon_camo", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_dc19le", "rw_sw_sg6", "weapon_camo"},
  Health = 250,
  Clearance = "2",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_sgt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 13,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_2ndlt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_2ndlt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_2ndlt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_2ndlt.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_ltcol.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_ltcol.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_ltcol.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_SCAR_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_dc19le", "weapon_camo", "rw_sw_sg6", "rw_sw_se14", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(3, 150, 3, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/ragnar/sw_scar_troopers/scar_trooper_ltcol.mdl",
  Regiment = "SCAR Trooper",
} )

TEAM_RAN_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 200,
  Clearance = "1",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_SSGT = CreateTeam( "DO NOT USE", {
  Weapons = {""},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Skin = "1",
  Model = "",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Skin = "0",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Skin = "0",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Skin = "0",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Skin = "2",
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "rw_sw_dc15x", "weapon_bactainjector", "rw_sw_westarm5", "rw_sw_se14c"},
  Health = 250,
  Clearance = "2",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Skin = "2",
  Model = "models/player/bunny/imperial_arc/arc_troopers_trooper.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_special_job.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Skin = "0",
  Model = "models/player/bunny/imperial_arc/arc_troopers_officer_commander.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_officer_commander.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_officer_commander.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_officer_commander.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_RAN_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_westarm5", "rw_sw_dc15x", "rw_sw_se14c", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(255, 135, 0, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Skin = "1",
  Model = "models/player/bunny/imperial_arc/arc_troopers_officer_commander.mdl",
  Regiment = "Rancor Battalion",
} )

TEAM_CS_PRV = CreateTeam( "Private", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "1",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperstrooper/chimeradeathtrooperstrooper.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_PFC = CreateTeam( "Private First Class", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "1",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperstrooper/chimeradeathtrooperstrooper.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_LCPL = CreateTeam( "Lance Corporal", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "1",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperstrooper/chimeradeathtrooperstrooper.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_CPL = CreateTeam( "Corporal", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic"},
  Health = 200,
  Clearance = "1",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperstrooper/chimeradeathtrooperstrooper.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_SGT = CreateTeam( "Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_SSGT = CreateTeam( "Staff Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_MSGT = CreateTeam( "Master Sergeant", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_OC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_WOT = CreateTeam( "Warrant Officer II", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_WOO = CreateTeam( "Warrant Officer I", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 10,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_HEAVY = CreateTeam( "[Heavy]", {
  Weapons = {"rw_sw_t21", "rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "deployable_shield"},
  Health = 350,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_SUPPORT = CreateTeam( "[Support]", {
  Weapons = {"weapon_jew_stimkit", "weapon_bactainjector", "rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic" , "rw_sw_stun_e11"},
  Health = 250,
  Clearance = "2",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperssergeant/chimeradeathtrooperssergeant.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_SLT = CreateTeam( "Second Lieutenant", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtroopersofficer/chimeradeathtroopersofficer.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_LT = CreateTeam( "Lieutenant", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtroopersofficer/chimeradeathtroopersofficer.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_CPT = CreateTeam( "Captain", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtroopersofficer/chimeradeathtroopersofficer.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_MAJ = CreateTeam( "Major", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "3",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtroopersofficer/chimeradeathtroopersofficer.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_LCOL = CreateTeam( "Lieutenant Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperscommander/chimeradeathtrooperscommander.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_COL = CreateTeam( "Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperscommander/chimeradeathtrooperscommander.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_HCOL = CreateTeam( "High Colonel", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "4",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperscommander/chimeradeathtrooperscommander.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_CS_BRIG = CreateTeam( "Brigadier", {
  Weapons = {"rw_sw_e11d", "rw_sw_se14c", "weapon_cuff_elastic", "rw_sw_stun_e11", "weapon_rpw_binoculars_nvg"},
  Health = 350,
  Clearance = "5",
  Colour = Color(51, 190, 190, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/gonzo/chimeradeathtroopers/chimeradeathtrooperscommander/chimeradeathtrooperscommander.mdl",
  Regiment = "Chimaera Squad",
} )

TEAM_BH_BF = CreateTeam( "", {
  Weapons = {"weapon_cuff_elastic", "rw_sw_ee3", "rw_sw_b2rp_rocket", "rw_sw_dlt20a", "weapon_jetpack", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/nate159/swbf/hero/hero_gunslinger_bobafett.mdl",
  RealName = "Boba Fett",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_BK = CreateTeam( "", {
  Weapons = {"rw_sw_relbyv10_bossk", "rw_sw_dc17m_launcher", "weapon_cuff_elastic", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/hydro/swbf_bossk/swbf_bossk.mdl",
  RealName = "Bossk",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_CB = CreateTeam( "", {
  Weapons = {"rw_sw_x8", "rw_sw_iqa11", "weapon_cuff_elastic", "weapon_jetpack", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/grealms/characters/cadbane/cadbane.mdl",
  RealName = "Cad Bane",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_DR = CreateTeam( "", {
  Weapons = {"rw_sw_dlt19_dengar", "rw_sw_dlt19x", "weapon_cuff_elastic", "zeus_thermaldet", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/hydro/swbf_dengar/swbf_dengar.mdl",
  RealName = "Dengar",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_HK47 = CreateTeam( "", {
  Weapons = {"rw_sw_dc17m", "weapon_cuff_elastic", "rw_sw_nt242", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/nikout/swtor/npc/hk47.mdl",
  RealName = "HK-47",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_HK51 = CreateTeam( "", {
  Weapons = {"rw_sw_dc17m", "weapon_cuff_elastic", "rw_sw_nt242", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/nikout/swtor/npc/hk51.mdl",
  RealName = "HK-51",
  Regiment = "Bounty Hunter",
} )

TEAM_BH_GRD = CreateTeam( "", {
  Weapons = {"rw_sw_dt12", "rw_sw_e5", "rw_sw_tusken_cycler", "weapon_cuff_elastic", "weapon_rpw_binoculars_nvg", "bkeycardscanner_cracker"},
  Health = 550,
  Clearance = "AREA ACCESS",
  Colour = Color(139, 109, 139, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/nate159/swbf/hero/player/hero_gunslinger_greedo_player.mdl",
  RealName = "Greedo",
  Regiment = "Bounty Hunter",
} )

TEAM_SEN_SEN = CreateTeam( "EG-5 Hunter Droid", {
  Weapons = {"weapon_lightsaber", "rw_sw_dc19le_phase"},
  Health = 3000,
  Clearance = "CLASSIFIED",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/jazzmcfly/jka/eg5/noflicker/jka_eg5.mdl",
  Regiment = "Jedi Hunter Droid",
  SpawnFunc = function(ply) ply:ChatPrint("Go kick some ass hunter droid!") end
} )

TEAM_ID_R2 = CreateTeam( "R2 Series", {
  Weapons = {"rw_sw_dl18", "weapon_jetpack", "weapon_stunstick", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Bodygroups = "00",
  Model = "models/kingpommes/starwars/playermodels/astromech.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_R4 = CreateTeam( "R4 Series", {
  Weapons = {"rw_sw_dl18", "weapon_jetpack", "weapon_stunstick", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Bodygroups = "01",
  Model = "models/kingpommes/starwars/playermodels/astromech.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_R5 = CreateTeam( "R5 Series", {
  Weapons = {"rw_sw_dl18", "weapon_jetpack", "weapon_stunstick", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Bodygroups = "02",
  Model = "models/kingpommes/starwars/playermodels/astromech.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_MSE = CreateTeam( "MSE-6 Series", {
  Weapons = {"rw_sw_dl18", "sswep_mouse"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/kingpommes/emperors_tower/ph_props/mouse_droid/mouse_droid.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_KX = CreateTeam( "KX Series", {
  Weapons = {"rw_sw_e5s","rw_sw_dl18", "weapon_fists", "rw_sw_stun_e11", "weapon_cuff_elastic", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/valley/k2so.mdl",
  Regiment = "Imperial Droid",
  SpawnFunc = function(ply) ply:SetModelScale(1.2,0) end
} )

TEAM_ID_GNK = CreateTeam( "GNK Series", {
  Weapons = {"rw_sw_dl18", "weapon_bactainjector", "weapon_stunstick"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/KingPommes/starwars/playermodels/gnk.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_GNK5 = CreateTeam( "GNK Series", {
  Weapons = {"rw_sw_dl18", "weapon_bactainjector"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/kingpommes/playermodels/gnk_550.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_ID_21B = CreateTeam( "2-1B Surgical Droid", {
  Weapons = {"rw_sw_dl18", "weapon_jew_stimkit", "weapon_multihealer", "weapon_bactainjector", "weapon_bactanade", "weapon_defibrillator"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/valley/medicaldroid.mdl",
  Regiment = "Imperial Droid",
} )

TEAM_EVENT_BLANK = CreateTeam( " ", {
  Weapons = {""},
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/player/ven/tk_basic_01/tk_basic.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_RL = CreateTeam( "Rebel Leader", {
  Weapons = {"rw_sw_dual_dh17a", "rw_sw_a280c"},
  Health = 1500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/banks/roger/swbf_rebel_soldiersand_roger/swbf_rebel_soldiersand_roger.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_RH = CreateTeam( "Rebel Heavy", {
  Weapons = {"rw_sw_a280", "rw_sw_rt97c"},
  Health = 1250,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/banks/roger/swbf_rebel_soldiersand_roger/swbf_rebel_soldiersand_roger.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_RT = CreateTeam( "Rebel Trooper", {
  Weapons = {"rw_sw_a280", "rw_sw_a280cfe"},
  Health = 1000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/banks/roger/swbf_rebel_soldiersand_roger/swbf_rebel_soldiersand_roger.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_RP = CreateTeam( "Rebel Pilot", {
  Weapons = {"rw_sw_dh17"},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/sgg/starwars/rebels/r_trooper/male_02.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_ML = CreateTeam( "Mandalorian Leader", {
  Weapons = {""},
  Health = 1500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/porky-da-corgi/starwars/mandalorians/bountyhunter.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MH = CreateTeam( "Mandalorian Heavy", {
  Weapons = {""},
  Health = 1250,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/porky-da-corgi/starwars/mandalorians/bountyhunter.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MT = CreateTeam( "Mandalorian Trooper", {
  Weapons = {""},
  Health = 1000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/porky-da-corgi/starwars/mandalorians/bountyhunter.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_ID = CreateTeam( "Imperial Droid", {
  Weapons = {"rw_sw_e11", "rw_sw_dl18"},
  Health = 1000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/church/swtor/imperialdroid/cpt_imperialdroid.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_LTD = CreateTeam( "Lightsaber Training Droid", {
  Weapons = {"weapon_lightsaber"},
  Health = 2000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/church/swtor/republicdroid/cpt_republicdroid.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_TD = CreateTeam( "Training Droid", {
  Weapons = {"rw_sw_e11"},
  Health = 1250,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/church/swtor/republicdroid/cpt_republicdroid.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MD = CreateTeam( "Medical Droid", {
  Weapons = {""},
  Health = 500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/valley/medicaldroid.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MILL = CreateTeam( "Militia Leader", {
  Weapons = {""},
  Health = 1500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/group03/male_01.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MILG = CreateTeam( "Militia Gunner", {
  Weapons = {""},
  Health = 1250,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/group03/male_03.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_MILS = CreateTeam( "Militia Soldier", {
  Weapons = {""},
  Health = 1000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/player/group03/male_06.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_JEDIK = CreateTeam( "Jedi Knight", {
  Weapons = {"weapon_lightsaber"},
  Health = 2000,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/grealms/characters/jedirobes/jedirobes_05.mdl",
  Regiment = "Event",
} )

TEAM_EVENT_JEDIP = CreateTeam( "Jedi Padawan", {
  Weapons = {"weapon_lightsaber"},
  Health = 1500,
  Clearance = "AREA ACCESS",
  Colour = Color(255, 255, 255, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/grealms/characters/padawan/padawan_04.mdl",
  Regiment = "Event",
} )

TEAM_INQ_INT = CreateTeam( "Initiate", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 800,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/egbanks/characters/eginquisitor/inquisitor.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_NOV = CreateTeam( "Novice", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1000,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 2,
  Model = "models/egbanks/characters/eginquisitor/inquisitor.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ5 = CreateTeam( "Inquisitor V", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1000,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 3,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ4 = CreateTeam( "Inquisitor IV", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1000,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 4,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ3 = CreateTeam( "Inquisitor III", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1000,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 5,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ2 = CreateTeam( "Inquisitor II", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1250,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 6,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ1 = CreateTeam( "Inquisitor I", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1250,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 7,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_INQ = CreateTeam( "Inquisitor", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 1500,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 8,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_TB = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  RealName = "Tenth Brother",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_NS = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/ninth_sister1.mdl",
  RealName = "Ninth Sister",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_EB = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/eighth_brother.mdl",
  RealName = "Eighth Brother",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_SVS = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquisitor_seventhsister.mdl",
  RealName = "Seventh Sister",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_SB = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  RealName = "Sixth Brother",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_FB = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquis_fifthbrother.mdl",
  RealName = "Fifth Brother",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_FS = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  RealName = "Fourth Sister",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_TH = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 9,
  Model = "models/egbanks/characters/eginquisitor/inquisitor2.mdl",
  RealName = "Third Brother",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_SS = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2000,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 9,
  Model = "models/player/sample/sister/test/sister.mdl",
  RealName = "Second Sister",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_HI = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2250,
  Clearance = "5",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 18,
  Model = "models/imperius/imperiuss.mdl",
  RealName = "High Inquisitor",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_GI = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 2500,
  Clearance = "6",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 19,
  Model = "models/egbanks/characters/eginquisitor/grandinquisitor.mdl",
  RealName = "Grand Inquisitor",
  Regiment = "Imperial Inquisitor",
} )

TEAM_INQ_DV = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "forcechoke"},
  Health = 3000,
  Clearance = "ALL ACCESS",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  Rank = 20,
  Model = "models/nate159/swbf/hero/player/hero_sith_vader_player.mdl",
  RealName = "Darth Vader",
  Regiment = "Sith Lord",
} )

TEAM_IG_IN = CreateTeam( "Initiate", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 500,
  Clearance = "1",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 1,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_GM = CreateTeam( "Guardsman", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 750,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 2,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_LG = CreateTeam( "Leading Guardsman", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1000,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 3,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_SG = CreateTeam( "Senior Guardsman", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 4,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_WAR = CreateTeam( "Warden", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 5,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_DEF = CreateTeam( "Defender", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1250,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 6,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_SEN = CreateTeam( "Sentinel", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1500,
  Clearance = "2",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 7,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_HW = CreateTeam( "High Warden", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1500,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 8,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_HD = CreateTeam( "High Defender", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1500,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 9,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

  TEAM_IG_HS = CreateTeam( "High Sentinel", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic"},
  Health = 1750,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/starwars/mistersweetroll/imperialguard.mdl"},
  Rank = 10,
  Model = "models/player/ven/guard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_CH = CreateTeam( "Challenger", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo"},
  Health = 1750,
  Clearance = "3",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,
  OtherModels = {"models/imperial/guard/blackguard.mdl"},
  Rank = 11,
  Model = "models/player/ven/shadowguard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_MG = CreateTeam( "Master Guardsman", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo", "forcechoke"},
  Health = 1750,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial/guard/blackguard.mdl"},
  Rank = 12,
  Model = "models/player/ven/shadowguard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_MS = CreateTeam( "Master Sentinel", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo", "forcechoke"},
  Health = 1750,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial/guard/blackguard.mdl"},
  Rank = 13,
  Model = "models/player/ven/shadowguard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_MI = CreateTeam( "Master Instructor", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo", "forcechoke"},
  Health = 1750,
  Clearance = "4",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial/guard/blackguard.mdl"},
  Rank = 14,
  Model = "models/player/ven/shadowguard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_CMD = CreateTeam( "Commander", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo", "forcechoke"},
  Health = 2000,
  Clearance = "5",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial/guard/blackguard.mdl"},
  Rank = 19,
  Model = "models/player/ven/shadowguard.mdl",
  Regiment = "Imperial Guard",
} )

TEAM_IG_SP = CreateTeam( "", {
  Weapons = {"weapon_lightsaber", "rw_sw_dl18", "weapon_cuff_elastic", "weapon_camo", "forcechoke"},
  Health = 2500,
  Clearance = "6",
  Colour = Color(161, 0, 63, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 20,
  Model = "models/carnor_jax_rm/carnor_jax_rm.mdl",
  RealName = "Soverign Protector",
  Regiment = "Imperial Guard",
} )

TEAM_MAR_CON = CreateTeam( "Service General", {
  Weapons = {"rw_sw_e11_ihc", "rw_sw_rk3_officer", "rw_sw_stun_e11", "weapon_cuff_elastic"},
  Health = 400,
  Clearance = "6",
  Colour = Color(166, 121, 0, 31 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/bailey/compforce.mdl"},
  Rank = 21,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "CompForce",
} )

TEAM_MAR_HAR = CreateTeam( "Deputy Director General", {
  Weapons = {"rw_sw_tl40", "rw_sw_e11_ihc", "rw_sw_rk3_officer", "rw_sw_stun_e11", "weapon_cuff_elastic"},
  Health = 400,
  Clearance = "6",
  Colour = Color(166, 121, 0, 31 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/bailey/compforce.mdl"},
  Rank = 22,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "CompForce",
} )

TEAM_MAR_VAN = CreateTeam( "Director General", {
  Weapons = {"rw_sw_e11_ihc", "rw_sw_rk3_officer", "rw_sw_stun_e11", "weapon_cuff_elastic"},
  Health = 400,
  Clearance = "6",
  Colour = Color(166, 121, 0, 31 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/bailey/compforce.mdl"},
  Rank = 23,
  Model = "models/imperial_officer/isb/chairman_director/cd_m.mdl",
  Regiment = "CompForce",
} )

TEAM_TANK_TRP = CreateTeam( "", {
  Weapons = {"weapon_rpw_binoculars_nvg", "rw_sw_se14c_phase", "rw_sw_e11d_phase", "rw_sw_e11d_phase_2", "rw_sw_dlt19d_phase", "rw_sw_b2rp_rocket", "thermal_flir", "weapon_cuff_elastic"},
  Health = 500,
  Clearance = "CLASSIFIED",
  Colour = Color(96,96,96, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/custom/characters/hero/deathtrooper/male/deathtrooper_male_02/deathtrooper_02_male_mesh.mdl", "models/player/markus/custom/characters/hero/deathtrooper/female/deathtrooper_female_02/deathtrooper_02_female_mesh.mdl"},
  Rank = 1,
  Model = "models/player/alpha/trooper/trooper.mdl",
  Regiment = "Phase Trooper",
} )

TEAM_TANK_LDR = CreateTeam( "", {
  Weapons = {},
  Health = 600,
  Clearance = "CLASSIFIED",
  Colour = Color(68,68,68, 255 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "",
  Regiment = "Spare 0",
} )

TEAM_IPC_PLY = CreateTeam( "", {
 Weapons = {},
 Health = 500,
 Clearance = "AREA ACCESS",
 Colour = Color(217, 20, 20, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "",
 Regiment = "Spare 0",
} )

TEAM_ICCS_TC = CreateTeam( "Cinder Medic", {
 Weapons = {"rw_sw_dc17m", "rw_sw_dc17", "weapon_jew_stimkit", "weapon_bactainjector", "deployable_shield", "alydus_fusioncutter"},
 Health = 300,
 Clearance = "3",
 Colour = Color(153, 51, 153, 255 ),
 Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
 Rank = 5,
 Model = "models/player/banks/omega/member/omega.mdl",
 Regiment = "IC Cinder Squad",
} )

TEAM_ICCS_SN = CreateTeam( "Cinder Sniper", {
 Weapons = {"rw_sw_dc17m", "rw_sw_nt242",  "weapon_camo", "weapon_rpw_binoculars_nvg", "rw_sw_dual_dc17"},
 Health = 300,
 Clearance = "3",
 Colour = Color(153, 51, 153, 255 ),
 Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
 Rank = 5,
 Model = "models/player/banks/omega/member/omega.mdl",
 Regiment = "IC Cinder Squad",
} )

TEAM_ICCS_DM = CreateTeam( "Cinder Demo", {
 Weapons = {"rw_sw_dc17m", "rw_sw_dc17m_launcher", "zeus_thermaldet"},
 Health = 300,
 Clearance = "3",
 Colour = Color(153, 51, 153, 255 ),
 Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
 Rank = 5,
 Model = "models/player/banks/omega/member/omega.mdl",
 Regiment = "IC Cinder Squad",
} )

TEAM_ICCS_LD = CreateTeam( "Cinder Leader", {
 Weapons = {"rw_sw_dc17m", "rw_sw_dual_dc17", "weapon_rpw_binoculars_nvg"},
 Health = 350,
 Clearance = "4",
 Colour = Color(153, 51, 153, 255 ),
 Side = 1,                                                                                                                                              
  OtherModels = {"models/imperial_officer/isb/operative/op_m.mdl"},
 Rank = 5,
 Model = "models/player/banks/omega/commander/omega.mdl",
 Regiment = "IC Cinder Squad",
} )

TEAM_Civilian_1 = CreateTeam( "Human", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/x2era/x2era.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_2 = CreateTeam( "Jawa", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/church/swtor/jawa/cpt_jawa.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_3 = CreateTeam( "Gotal", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/player/valley/gotal.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_4 = CreateTeam( "Bith", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/player/valley/bith.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_5 = CreateTeam( "Twi'lek", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/padawan6/padawan6.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_6 = CreateTeam( "Rodian", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/byan7259/bodian_player/segular_rodian_player.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_7 = CreateTeam( "Gungan", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/grealms/characters/gungans/gungans.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_8 = CreateTeam( "Weequay", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/gyan7259/geequay_player/geequay_regular_player.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_9 = CreateTeam( "Devaronian", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/jazzmcfly/jka/dv/dv.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_10 = CreateTeam( "Tusken", {
 Weapons = {"rw_sw_defender", "rw_sw_tusken_cycler"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/zyan7259/zusken_raider_player/zusken_raider_player.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_11 = CreateTeam( "Chagrian", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/player/tiki/ameda.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_12 = CreateTeam( "Quarren", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/player/tiki/tikkes.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_13 = CreateTeam( "Gamorrean Guard", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/player/valley/gamorreanguard_01.mdl",
 Regiment = "Civilian",
} )

TEAM_Civilian_14 = CreateTeam( "Hutt", {
 Weapons = {"rw_sw_defender"},
 Health = 500,
 Clearance = "Imperial Citizen",
 Colour = Color(63, 79, 127, 255 ),
 Side = 1,                                                                                                                                              
 Rank = 1,
 Model = "models/npc/hgn/swrp/swrp/hutt_01.mdl",
 Regiment = "Civilian",
} )

TEAM_ID_ITO = CreateTeam( "IT-O", {
  Weapons = {"rw_sw_dl18", "weapon_jetpack", "weapon_stunstick", "weapon_rpw_binoculars_nvg"},
  Health = 300,
  Clearance = "AREA ACCESS",
  Colour = Color(193, 68, 31, 225 ),
  Side = 1,                                                                                                                                              
  Rank = 1,
  Model = "models/interrogationdroid/interrogationdroid.mdl",
  Regiment = "Imperial Droid",
} )
---
TEAM_CD_CAD = CreateTeam( "Cadet", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 1,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_SPB = CreateTeam( "Spaceman Basic", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 2,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_SPC = CreateTeam( "Spaceman", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 3,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_LSM = CreateTeam( "Leading Spacecraftsman", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Clearance = "1",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 4,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_FCP = CreateTeam( "Flight Corporal", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 5,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_FSG = CreateTeam( "Flight Sergeant", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 6,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_FCH = CreateTeam( "Flight Chief", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 7,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_OFC = CreateTeam( "Officer Cadet", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 8,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_WOI = CreateTeam( "Warrant Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 9,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_WOII = CreateTeam( "Chief Warrant Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3"},
  Health = 150,
  Clearance = "2",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 10,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_FO = CreateTeam( "Flight Officer", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 11,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_FLT = CreateTeam( "Flight Lieutenant", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 12,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_CAP = CreateTeam( "Flight Captain", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 13,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_CD_SLD = CreateTeam( "Squadron Leader", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 14,
  Model = "models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_03.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU1 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 15,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU2 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 16,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU3 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 17,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU4 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 18,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU5 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 19,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )

TEAM_DNU6 = CreateTeam( "DO NOT USE", {
  Weapons = {"rw_sw_e11_noscope", "rw_sw_rk3", "weapon_rpw_binoculars_nvg"},
  Health = 200,
  Clearance = "3",
  Colour = Color(1, 15, 38, 255 ),
  Side = 1,                                                                                                                                              
  OtherModels = {"models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl","models/imperial_officer/isb/operative/op_m.mdl"},
  Rank = 20,
  Model = "models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl",
  Regiment = "Hammer Squadron",
} )