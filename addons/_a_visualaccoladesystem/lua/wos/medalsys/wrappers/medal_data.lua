--[[-------------------------------------------------------------------
	Text-Based Data File:
		Holds all the functions for text-based data
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2018
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}
wOS.Medals.DataStore = wOS.Medals.DataStore or {}

function wOS.Medals.DataStore:Initialize()

	if not file.IsDir( "wos", "DATA" ) then file.CreateDir( "wos", "DATA" ) end
	if not file.IsDir( "wos/medals", "DATA" ) then file.CreateDir( "wos/medals", "DATA" ) end
	
	print( "[wOS-Medals] Successfully initialized data!" )
	
end

function wOS.Medals.DataStore:LoadPlayerMedals( ply )

	ply.AccoladeList = {}

	local dFile = "wos/medals/" .. ply:SteamID64() .. ".txt"
	if file.Exists( dFile, "DATA" ) then
		local dat = util.JSONToTable( file.Read( dFile, "DATA" ) )
		ply.AccoladeList = table.Copy( dat )
	else
		file.Write( dFile, util.TableToJSON( ply.AccoladeList ) )
	end

	wOS.Medals:SendPlayerMedals( ply )

end

function wOS.Medals.DataStore:AddNewMedal( ply, medal, reason )

	if not ply then return false end
	if not ply.AccoladeList then return false end
	if not reason then reason = "" end

	local sFile = "wos/medals/" .. ply:SteamID64() .. ".txt"
	ply.AccoladeList[ medal ] = reason
	
	local savetbl = util.TableToJSON( ply.AccoladeList )
	
	file.Write( sFile, savetbl )

	return true
	
end

function wOS.Medals.DataStore:RevokeMedal( ply, medal )

	if not ply then return false end
	if not ply.AccoladeList then return false end

	local sFile = "wos/medals/" .. ply:SteamID64() .. ".txt"
	ply.AccoladeList[ medal ] = nil
	
	local savetbl = util.TableToJSON( ply.AccoladeList )
	
	file.Write( sFile, savetbl )

	return true
	
end

wOS.Medals.DataStore:Initialize()