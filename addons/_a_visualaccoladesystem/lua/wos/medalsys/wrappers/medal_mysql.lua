--[[-------------------------------------------------------------------
	MySQL File:
		Holds all the SQL functions, executes if config is set to
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

require('mysqloo')
local DATA = mysqloo.CreateDatabase( wOS.Medals.SQL.Host, wOS.Medals.SQL.Username, wOS.Medals.SQL.Password, wOS.Medals.SQL.Database, wOS.Medals.SQL.Port, wOS.Medals.SQL.Socket )
if not DATA then
	error( "[wOS-Medals] MySQL Database connection failed." )
	wOS.Medals.DataStore = {}
	include( "wos/medalsys/wrappers/medal_data.lua" )
	return
else
	print( "[wOS-Medals] VAS MySQL connection was successful!" )	
end

local MYSQL_COLUMNS_GENERAL = "( SteamID varchar(255), Medal varchar(255), Reason varchar(255) )"

function wOS.Medals.DataStore:Initialize()
	
	local TRANS = DATA:CreateTransaction()
	TRANS:Query( "CREATE TABLE IF NOT EXISTS wos_medaldata " .. MYSQL_COLUMNS_GENERAL )
	TRANS:Start( function(transaction, status, err)
		if (!status) then error(err) return end
	end )

end

function wOS.Medals.DataStore:LoadPlayerMedals( ply )

	if not ply then return end	
	if ply:IsBot() then return end
	
	ply.AccoladeList = {}

	local TRANS = DATA:CreateTransaction()
	TRANS:Prepare( "SELECT * FROM wos_medaldata WHERE SteamID = ?", { ply:SteamID64() } )
	TRANS:Start(function(transaction, status, err)
		if (!status) then error(err) return end
		local queries = transaction:getQueries()
		local medals = queries[1]:getData()
		
		if table.Count( medals ) > 0 then
			for slot, dat in ipairs( medals ) do
				if not wOS.Medals.Badges[ dat.Medal ] then continue end
				ply.AccoladeList[ dat.Medal ] = dat.Reason
			end
		end
		
		wOS.Medals:SendPlayerMedals( ply )
		
	end )

end

function wOS.Medals.DataStore:AddNewMedal( ply, medal, reason )

	if not ply then return false end
	if not ply.AccoladeList then return false end
	if ply:IsBot() then return false end
	
	ply.AccoladeList[ medal ] = reason
		
	local TRANS = DATA:CreateTransaction()
	TRANS:Prepare( "INSERT INTO wos_medaldata ( SteamID, Medal, Reason ) VALUES ( ?, ?, ? )", {  ply:SteamID64(), DATA:escape( medal ), DATA:escape( reason ) } )
	TRANS:Start(function(transaction, status, err)
		if (!status) then error(err) return end
	end )
	
	return true
		
end

function wOS.Medals.DataStore:RevokeMedal( ply, medal )

	if not ply then return false end
	if not ply.AccoladeList then return false end
	if ply:IsBot() then return false end
	
	ply.AccoladeList[ medal ] = nil
	
	local TRANS = DATA:CreateTransaction()
	TRANS:Prepare( "DELETE FROM wos_medaldata WHERE SteamID = ? AND Medal = ?", {  ply:SteamID64(), DATA:escape( medal ) } )
	TRANS:Start(function(transaction, status, err)
		if (!status) then error(err) return end
	end )
	
	return true
	
end

wOS.Medals.DataStore:Initialize()