-----------------------------------
-- MADE BY LONELYWOLF------------
------------------------------

-- FRAGS AND DEATHS

function ulx.frags_deaths( calling_ply, target_plys, number, should_deaths )

	if ( not should_deaths ) then
	
		for k,v in pairs( target_plys ) do 
		
			v:SetFrags( number )

		end
		
		ulx.fancyLogAdmin( calling_ply, "#A set the frags for #T to #s", target_plys, number )
		
	elseif should_deaths then
	
		for k,v in pairs( target_plys ) do 
		
			v:SetDeaths( number )

		end
		
		ulx.fancyLogAdmin( calling_ply, "#A set the deaths for #T to #s", target_plys, number )
		
	end
	
end
local frags_deaths = ulx.command( "Fun", "ulx frags", ulx.frags_deaths, "!frags" )
frags_deaths:addParam{ type=ULib.cmds.PlayersArg }
frags_deaths:addParam{ type=ULib.cmds.NumArg, hint="number" }
frags_deaths:addParam{ type=ULib.cmds.BoolArg, invisible=true }
frags_deaths:defaultAccess( ULib.ACCESS_ADMIN )
frags_deaths:help( "Set a player's frags and deaths." )
frags_deaths:setOpposite( "ulx deaths", { _, _, _, true }, "!deaths" )

-- Stop Whole Server Sounds

function ulx.stopsounds( calling_ply )

	for _,v in ipairs( player.GetAll() ) do 
	
		v:SendLua([[RunConsoleCommand("stopsound")]]) 
		
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A stopped sounds" )
	
end
local stopsounds = ulx.command("Utility", "ulx stopsounds", ulx.stopsounds, {"!ss", "!stopsounds"} )
stopsounds:help( "Stops sounds for the whole wide server." )

-- Bans an IP

function ulx.banip( calling_ply, minutes, ip )

	if not ULib.isValidIP( ip ) then
	
		ULib.tsayError( calling_ply, "Please Check The IP as it seems to be INVALID." )
		
		return
		
	end

	local plys = player.GetAll()
	
	for i=1, #plys do
	
		if string.sub( tostring( plys[ i ]:IPAddress() ), 1, string.len( tostring( plys[ i ]:IPAddress() ) ) - 6 ) == ip then
			
			ip = ip .. " (" .. plys[ i ]:Nick() .. ")"
			
			break
			
		end
		
	end

	RunConsoleCommand( "addip", minutes, ip )
	RunConsoleCommand( "writeip" )

	ulx.fancyLogAdmin( calling_ply, true, "#A banned ip address #s for #i minutes", ip, minutes )
	
	if ULib.fileExists( "cfg/banned_ip.cfg" ) then
		ULib.execFile( "cfg/banned_ip.cfg" )
	end
	
end
local banip = ulx.command( "Utility", "ulx banip", ulx.banip )
banip:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.allowTimeString, min=0 }
banip:addParam{ type=ULib.cmds.StringArg, hint="address" }
banip:help( "Bans a players ip address." )

-- Unbans IP

function ulx.unbanip( calling_ply, ip )

	if not ULib.isValidIP( ip ) then
	
		ULib.tsayError( calling_ply, "Wrong ip address." )
		
		return
		
	end

	RunConsoleCommand( "removeip", ip )
	RunConsoleCommand( "writeip" )

	ulx.fancyLogAdmin( calling_ply, true, "#A unbanned ip address #s", ip )
	
end
local unbanip = ulx.command( "Utility", "ulx unbanip", ulx.unbanip )
unbanip:addParam{ type=ULib.cmds.StringArg, hint="address" }
unbanip:help( "Unbans ip address." )

-- FORCE RESPAWN

function ulx.forcerespawn( calling_ply, target_plys )

	if GetConVarString("gamemode") == "terrortown" then
		for k, v in pairs( target_plys ) do
			if v:Alive() then
				v:Kill()
				v:SpawnForRound( true )
			else
				v:SpawnForRound( true )			
			end
		end
	else
		for k, v in pairs( target_plys ) do
			if v:Alive() then
				v:Kill()
				v:Spawn()
			else
				v:Spawn()
			end
		end
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A respawned #T", target_plys )
	
end
local forcerespawn = ulx.command( "Utility", "ulx forcerespawn", ulx.forcerespawn, { "!forcerespawn", "!frespawn"} )
forcerespawn:addParam{ type=ULib.cmds.PlayersArg }
forcerespawn:defaultAccess( ULib.ACCESS_ADMIN )
forcerespawn:help( "Force-respawn a player." )

-- SOUNDS

function ulx.soundlist( calling_ply )
	if calling_ply:IsValid() then
		calling_ply:ConCommand( "xgui hide" )	
		calling_ply:ConCommand( "menu_sounds" )
	end
end
local soundlist = ulx.command( "Fun", "ulx soundlist", ulx.soundlist, { "!soundlist", "!sounds", "!sound" } )
soundlist:defaultAccess( ULib.ACCESS_ALL )
soundlist:help( "Open the server soundlist" )

-- DARKP SET NAME

function ulx.rpname( calling_ply, target_ply, newname )
	local target = target_ply
	local name = tostring(newname)
	------------
	local oldname = target:Nick()
	oldname = tostring(oldname)
	------------
	DarkRP.storeRPName(target, name)
	target:setDarkRPVar("rpname", name)
	target:PrintMessage(2, DarkRP.getPhrase("x_set_your_name", "ULX", name))

	ulx.fancyLogAdmin( calling_ply, "#A set the name of #T(" .. oldname .. ") to " .. name .. ".", target_ply )
end
local rpName = ulx.command( "DarkRP", "ulx rpname", ulx.rpname, "!rpname" )
rpName:addParam{ type=ULib.cmds.PlayerArg }
rpName:addParam{ type=ULib.cmds.StringArg, hint="John Doe", ULib.cmds.takeRestOfLine }
rpName:defaultAccess( ULib.ACCESS_ADMIN )
rpName:help( "Set a person's RP name." )