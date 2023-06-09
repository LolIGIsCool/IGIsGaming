plogs.Register('Kills', true, Color(255,0,0))

plogs.AddHook('PlayerDeath', function(pl, _, attacker)
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
	plogs.PlayerLog(pl, 'Kills', attacker .. ' killed ' .. pl:NameID() .. weapon, copy)
end)


plogs.Register('Damage', false)

plogs.AddHook('EntityTakeDamage', function(ent, dmginfo)
	if ent:IsPlayer() then
		local copy = {
	    	['Name'] = ent:Name(),
			['SteamID']	= ent:SteamID(),
			['SteamID64']	= ent:SteamID64()
	    }
	    local weapon = ''
	    local attacker = dmginfo:GetAttacker()
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
		if not plogs.cfg.DmgBlacklist[attacker] then
			plogs.PlayerLog(ent, 'Damage', attacker .. ' did ' .. math.Round(dmginfo:GetDamage(), 0) .. ' damage to ' .. ent:NameID() .. weapon, copy)
		end
	end
end)