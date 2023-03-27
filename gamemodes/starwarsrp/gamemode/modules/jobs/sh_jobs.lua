local meta = FindMetaTable("Player")

local IGClientPatronList = {};

net.Receive("VANILLA_PATRON_CLIENT",function()
	IGClientPatronList = net.ReadTable();
end)

local admintable = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["senior developer"] = true,
    ["advisor"] = true,
    ["senior admin"] = true,
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
	["senior developer"] = true,
}

local sadmintable = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["advisor"] = true,
    ["senior admin"] = true,
    ["lead event master"] = true,
}

local emtable = {
    ["superadmin"] = true,
    ["senior developer"] = true,
    ["senior admin"] = true,
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
    ["donator"] = true,
    ["patron"] = true,
    ["benefactor"] = true
}

local developertable = {
    ["senior developer"] = true,
    ["junior developer"] = true,
    ["developer"] = true
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
	//check if user is patron
	for k, v in pairs(IGClientPatronList) do
		if v.id == self:SteamID() then return true end
	end

    if sadmintable[string.lower(self:GetUserGroup())] then return true end
    if admintable[string.lower(self:GetUserGroup())] then return true end
    if emtable[string.lower(self:GetUserGroup())] then return true end
    if donatortable[string.lower(self:GetUserGroup())] then return true end

    return false
end

function meta:IsDeveloper()
    if sadmintable[string.lower(self:GetUserGroup())] then return true end
    if developertable[string.lower(self:GetUserGroup())] then return true end

    return false
end

if CLIENT then
    TeamTable = istable(TeamTable) and TeamTable or {}
    CountTable = istable(CountTable) and CountTable or {}

    function meta:GetRegiment()
        if not CountTable or not CountTable[self:Team()] or not CountTable[self:Team()][1] then return "Recruit" end

        return CountTable[self:Team()][1]
    end

    function meta:GetRank()
        if not CountTable or not CountTable[self:Team()] or not CountTable[self:Team()][2] then return 0 end

        return CountTable[self:Team()][2]
    end

    function meta:GetRankName()
        if not TeamTable or not TeamTable[self:GetRegiment()] or not TeamTable[self:GetRegiment()][self:GetRank()] then return "Recruit" end

        return tostring(TeamTable[self:GetRegiment()][self:GetRank()].Name)
    end

    function meta:GetClearance()
        if not TeamTable or not TeamTable[self:GetRegiment()] or not TeamTable[self:GetRegiment()][self:GetRank()] then return "0" end

        return tostring(TeamTable[self:GetRegiment()][self:GetRank()].Clearance)
    end

    function meta:GetJobTable()
        if not TeamTable or not TeamTable[self:GetRegiment()] or not TeamTable[self:GetRegiment()][self:GetRank()] then return {} end

        return TeamTable[self:GetRegiment()][self:GetRank()]
    end

    function meta:GetJobColour()
        if not TeamTable or not TeamTable[self:GetRegiment()] or not TeamTable[self:GetRegiment()][self:GetRank()] then return Color(255, 255, 255) end

        return TeamTable[self:GetRegiment()][self:GetRank()].Colour
    end

    net.Receive("networkteamtblfull", function()
        local size = net.ReadUInt(32)
        local part = util.JSONToTable(util.Decompress(net.ReadData(size)))

        for k, v in pairs(part) do
            TeamTable[k] = v

            for a, b in pairs(v) do
                team.SetUp(b.Count, b.Name, b.Colour)
            end
        end
    end)

    net.Receive("networkcounttblfull", function()
        local size = net.ReadUInt(32)
        local part = util.JSONToTable(util.Decompress(net.ReadData(size)))
        CountTable = table.Copy(part)
    end)

    net.Receive("networkteamtbl", function()
        local typenetwork = net.ReadString()

        if typenetwork == "remover" then
            local regiment = net.ReadString()
            TeamTable[regiment] = nil
        elseif typenetwork == "remover2" then
            local regiment = net.ReadString()
            local rank = net.ReadUInt(8)
            TeamTable[regiment][rank] = nil
        elseif typenetwork == "updater" then
            local regiment = net.ReadString()
            local rank = net.ReadUInt(8)
            local tablea = net.ReadTable()
            TeamTable[regiment][rank] = table.Copy(tablea)
        elseif typenetwork == "newr" then
            local regiment = net.ReadString()
            local rank = net.ReadUInt(8)
            local tablea = net.ReadTable()

            if not TeamTable[regiment] then
                TeamTable[regiment] = {}
            end

            TeamTable[regiment][rank] = table.Copy(tablea)
        end
    end)

    local effectslist = {"effect_sw_laser_green", "effect_sw_laser_red", "effect_sw_laser_white"}

    local effectnumber = 1

    -- net.Receive("dorainbowbullets", function()
    --     timer.Create("rainbowbulletshectic", 0.25, 0, function()
    --         effectnumber = effectnumber + 1

    --         if effectnumber == 4 then
    --             effectnumber = 1
    --         end

    --         if LocalPlayer():GetActiveWeapon() and LocalPlayer():GetActiveWeapon():IsValid() then
    --             LocalPlayer():GetActiveWeapon().TracerName = effectslist[effectnumber]
    --         end
    --     end)
    -- end)
end
