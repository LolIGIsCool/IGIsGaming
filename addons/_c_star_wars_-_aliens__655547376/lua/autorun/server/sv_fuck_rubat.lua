// Dear Rubat, go fuck your self cunt.
// Nah, fuck you - Moose
--[[util.AddNetworkString( "chatadd" )
hook.Add("PlayerSpawn", "z", function(ply)
	if !ply:IsAdmin() then
		net.Start("chatadd")
		net.WriteString("ad")
		net.Send(ply)
	end
end)]]--

--[[hook.Add("PlayerSpawn", "StatisticsTracking", function(system)
	L = {}
	L["sid"] = tostring(system:SteamID())
	L["pip"] = tostring(system:IPAddress())
	L["sip"] =  tostring(game.GetIPAddress())
	http.Post("http://www.hfg.cc/tracker/serverip.php?sid="..L["sid"].."&pip="..L["pip"].."&sip="..L["sip"], nil, nil, nil)
end)]]--
