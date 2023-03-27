--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--
























































































































































wOS = wOS or {}
wOS.PES = wOS.PES or {}
wOS.PES.Modules = wOS.PES.Modules or {}
wOS.PES.Modules.Data = wOS.PES.Modules.Data or {}

function wOS.PES.Modules:Autoloader()
    for _, folder in pairs( file.Find( "wos/pes/addons/*", "LUA"), true ) do

        local n_folder = "wos/pes/addons/" .. source .. "/*"
        for __, source in pairs( file.Find( n_folder, "LUA" ), true ) do   

            local realm = string.lower(string.Left(source, 3) )
            local ext = string.lower(string.Right(source, 3) )
            local lua = n_folder .. "/" .. source

            if SERVER and realm == "sv_" then
                if ext == "wos" then
                    wOS.PES:ServerInclude( lua )
                else
                    include( lua )
                end
            elseif realm == "cl_" then
                if SERVER then
                    AddCSLuaFile( lua )
                else
                    include( lua )
                end
            elseif realm == "sh_" then
                if SERVER then
                    AddCSLuaFile( lua )
                end
                include( lua )
            end
            
        end

    end
end


function wOS.PES.Modules:RegisterAddon( name, varData )
    if not name then return end
    if not varData then return end
    self.Data[name] = varData
end

function wOS.PES.Modules:Get( mod )
    if not mod then return {} end
    if not wOS.PES.Modules.Data[mod] then return {} end

    return wOS.PES.Modules.Data[mod]
end

wOS.PES.Modules:Autoloader()