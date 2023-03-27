plogs.Register('AOS Menu', true, Color(0,255,255))

plogs.AddHook('AOSUpdate', function(ar,aosply,callingply,reason,location)
	if ar == "add" then
    	plogs.PlayerLog(callingply, 'AOS Menu', callingply:NameID() .. ' has made ' .. aosply:NameID()..' AOS for the reason '..reason..' at location '..location, {
        	['AOSer Name']                = callingply:Name(),
        	['AOSer SteamID']             = callingply:SteamID(),
            ['AOSed Name']                = aosply:Name(),
        	['AOSed SteamID']             = aosply:SteamID(),
        	['Reason'] 					  = reason,
        	['Location'] 				  = location
    	})
    elseif ar == "remove" then
    	plogs.PlayerLog(callingply, 'AOS Menu', callingply:NameID() .. ' has removed '..aosply:NameID()..' from the AOS menu' , {
        	['AOSer Name']                = callingply:Name(),
        	['AOSer SteamID']             = callingply:SteamID(),
            ['AOSed Name']                = aosply:Name(),
        	['AOSed SteamID']             = aosply:SteamID()
    	})
    end
end)

plogs.AddHook('PlayerDisconnected', function(pl)
	if pl:IsAOS() then
		plogs.PlayerLog(pl, 'AOS Menu', pl:NameID() .. ' has disconnected whilst AOS', {
			['Name'] 	= pl:Name(),
			['Ingame Name'] = pl:Nick(),
			['SteamID']	= pl:SteamID(),
			['SteamID64']	= pl:SteamID64()
		})
	end
end)

plogs.AddHook('PlayerDeath', function(pl, _, attacker)
	if not pl:IsAOS() then return end
	local copy = {
		['Name'] = pl:Name(),
		['SteamID']	= pl:SteamID(),
		['SteamID64']	= pl:SteamID64()
	}
	local weapon = ''
	if IsValid(attacker) then
		if attacker:IsPlayer() then
			copy['Attacker Name'] = attacker:Name()
			copy['Attacker SteamID'] = attacker:SteamID()
			copy['Attacker SteamID64'] = attacker:SteamID64()
			weapon = ' with ' .. (IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() or 'unknown')
			attacker = attacker:NameID()
		else
			if attacker.CPPIGetOwner and IsValid(attacker:CPPIGetOwner()) then
				weapon = ' with ' .. attacker:GetClass()
				attacker = attacker:CPPIGetOwner():NameID()
			else
				attacker = attacker:GetClass()
			end
		end
	else
		attacker = tostring(attacker)
	end
	plogs.PlayerLog(pl, 'AOS Menu', attacker .. ' killed ' .. pl:NameID() .. weapon.." whilst they were AOSed", copy)
end)