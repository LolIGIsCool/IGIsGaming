plogs.Register('Handcuff', false)

plogs.AddHook('OnHandcuffed', function(pl, targ)
	plogs.PlayerLog(pl, 'Handcuff', pl:NameID() .. ' cuffed ' .. targ:NameID(), {
		['Name'] 			= pl:Name(),
		['SteamID']			= pl:SteamID(),
		['SteamID64']	= pl:SteamID64(),
		['Target Name'] 	= targ:Name(),
		['Target SteamID']	= targ:SteamID(),
		['Target SteamID64']	= targ:SteamID64()
	})
end)

plogs.AddHook('OnHandcuffBreak', function(pl, cuffs, friend)
	if IsValid(friend) then
		plogs.PlayerLog(pl, 'Handcuff', friend:NameID() .. ' uncuffed ' .. pl:NameID(), {
			['Name'] 			= pl:Name(),
			['SteamID']			= pl:SteamID(),
			['SteamID64']	= pl:SteamID64(),
			['Fried Name'] 		= friend:Name(),
			['Target SteamID']	= friend:SteamID(),
			['Target SteamID64']	= friend:SteamID64()
		})
	else
		plogs.PlayerLog(pl, 'Handcuff', pl:NameID() .. ' broke free from thier handcuffs', {
			['Name'] 			= pl:Name(),
			['SteamID']			= pl:SteamID(),
			['SteamID64']	= pl:SteamID64()
		})
	end
end)