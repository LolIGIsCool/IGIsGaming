-- Fire's body group and swap model manager
print("Initializing IG Fire's Model Manager")

BODYWORKS = {}

-- local meta = FindMetaTable( "Entity" )
-- function meta:GetRegiment()
--     return "Cum"
-- end

-- function meta:GetRank()
--     return "Cum"
-- end

-- local TeamTable = { Cum = { Cum = {}}}
-- TeamTable["Cum"]["Cum"].Model = "models/banks/ig/imperial/st/st_trooper/st_trooper.mdl"
-- TeamTable["Cum"]["Cum"].OtherModels = {
--     "models/player/sono/starwars/snowtrooper.mdl",
--     "models/imperial_officer/isb/operative/op_m.mdl",
--     "models/player/female/trooper_v2.mdl"
-- }

util.AddNetworkString("bodyworks_apply")
util.AddNetworkString("bodyworks_open")
-- this hook not needed anymore but why shouldnt I keep it?
util.AddNetworkString("bodyworks_load")

net.Receive("bodyworks_apply", function(len, ply)
    local model = net.ReadString()
    local skin = net.ReadUInt(5)
    local bodygroups = net.ReadString()
    
    local function has_value(tab, val)
        for index, value in ipairs(tab) do
            if value == val then
                return true
            end
        end
    
        return false
    end
    othermodels = table.Copy(TeamTable[ply:GetRegiment()][ply:GetRank()].OtherModels)
    table.insert(othermodels, 1, TeamTable[ply:GetRegiment()][ply:GetRank()].Model)

    if not has_value(othermodels, model) then
        --print("Model not in default list for regiment")
        if model != ply:GetModel() then
            --print("Player attempting to switch to un-owned model, rejecting..")
            return
        end
    end

    ply:SetModel(model)
    ply:SetSkin(skin)
    ply:SetBodyGroups(bodygroups)
end)

hook.Add("IGPlayerSay", "swapchatv3", function(ply, str)
    if (string.lower(str) == "!swap") then
        net.Start("bodyworks_open")
        print("makeing net magic")
        net.Send(ply)
    end
end)

-- this shit don't work
-- hook.Add("PlayerSetModel", "PlayerSpawnModel", function(ply)
--     net.Start("bodyworks_load")
--     net.Send(ply)
-- end)

-- idk if this is needed
-- hook.Add("OnPlayerChangedTeam", "PlayerSpawnModel", function( ply, before, after)
--     net.Start("bodyworks_load")
--     net.Send(ply)
-- end)