--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--
























































































































































wOS = wOS or {}
wOS.PES = wOS.PES or {}
wOS.PES.Vars = wOS.PES.Vars || {}
wOS.PES.Vars.Data = wOS.PES.Vars.Data || {}


function wOS.PES.Vars:Autoloader()
    for _,source in pairs( file.Find( "wos/pes/vars/*", "LUA"), true ) do

        local lua = "wos/pes/vars/" .. source
        if SERVER then AddCSLuaFile(lua) end
		local varData = include(lua)

        if !varData then
            print("ERROR: " .. source .. " this variable is invalid")
            continue
        end

        self.Data[varData.Name] = varData
    end
end

function wOS.PES.Vars:GetAll()
    return wOS.PES.Vars.Data
end

function wOS.PES.Vars:Get(name)
    if not name then return end
    return self.Data[name]
end

wOS.PES.Vars:Autoloader()