--[[

	https://support.billy.enterprises/console.log
	This file uploads the server's console.log to my script support site.

]]

--////////////////////////////////////////////////////////////////////////--

local SupportURL = "https://support.billy.enterprises"

concommand.Add("billy_consolelog", function(ply, _, args)
	if (IsValid(ply)) then
		ply:SendLua(string.Trim([[
			MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "You are using the wrong console.", "\n")
			gui.OpenURL("]] .. SupportURL .. [[/console.log")
		]]))
		return
	end

	local authentication_code = args[1]

	if (not authentication_code) then
		MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "We were unable to upload your console.log as you did not provide an authentication code. READ THIS: " .. SupportURL .. "/console.log", "\n")
		return
	end
	if (#player.GetHumans() == 0) then
		MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "Please have a player join the server before performing this operation.", "\n")
		return
	end
	if (not file.Exists("console.log", "GAME") and not file.Exists("logs/latest.log", "BASE_PATH")) then
		MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "We couldn't find your console.log as it does not exist in your server. READ THIS: " .. SupportURL .. "/console.log", "\n")
		return
	end

	MsgC(Color(0,255,255), "[Billy] ", Color(255,255,255), "Reading console.log...", "\n")

	local console_log_raw
	if (file.Exists("logs/latest.log", "BASE_PATH")) then
		console_log_raw = file.Read("logs/latest.log", "BASE_PATH")
	else
		console_log_raw = file.Read("console.log", "GAME")
	end

	local console_log = utf8.force(console_log_raw):sub(1, 5000000 - 1)

	MsgC(Color(0,255,255), "[Billy] ", Color(255,255,255), "Reading server info...", "\n")

	local ip_address = game.GetIPAddress()
	local server_name = GetConVar("hostname"):GetString()
	local gamemode = (GM or GAMEMODE).Name
	if ((GM or GAMEMODE).BaseClass) then
		gamemode = gamemode .. " (derived from " .. (GM or GAMEMODE).BaseClass.Name .. ")"
	end
	local avg_ping = 0
	for _,v in ipairs(player.GetHumans()) do
		avg_ping = avg_ping + v:Ping()
	end
	avg_ping = tostring(math.Round(avg_ping / #player.GetHumans()))

	MsgC(Color(0,255,255), "[Billy] ", Color(255,255,255), "Starting upload...", "\n")

	http.Post(

		SupportURL .. "/console.log/upload",

		{
			authentication_code = authentication_code,
			console_log = console_log,
			
			ip_address = ip_address,
			server_name = server_name,
			gamemode = gamemode,
			avg_ping = avg_ping
		},

		function(body, size, headers, status_code)
			if (status_code ~= 200) then
				MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "HTTP Error " .. status_code, "\n")
				return
			end
			if (size == 0) then
				MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "Empty body", "\n")
				return
			end
			local decoded_body = util.JSONToTable(body)
			if (not decoded_body) then
				MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "JSON error", "\n")
				return
			end
			if (decoded_body.success == true) then
				MsgC(Color(0,255,0), "[Billy] ", Color(255,255,255), "Thank you; successfully uploaded your console.log to the support site :)", "\n")
			elseif (decoded_body.failure ~= nil) then
				MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "Error: " .. decoded_body.failure, "\n")
			else
				MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "Unknown error", "\n")
			end
		end,

		function(err)
			MsgC(Color(255,0,0), "[Billy] ", Color(255,255,255), "Error: " .. err, "\n")
		end

	)
end)