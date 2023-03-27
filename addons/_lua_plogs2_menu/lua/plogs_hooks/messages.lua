plogs.Register('Messages', false)

plogs.AddHook("ULXMessageHook", function(pl, to, text)
		plogs.PlayerLog(pl, 'Messages', pl:Nick().." ("..pl:SteamID()..") to "..to:Nick().." ("..to:SteamID().."): "..text, {
		['Name'] 	= pl:Name(),
		['SteamID']	= pl:SteamID(),
		['SteamID64']	= pl:SteamID64(),
		['Target Name'] 	= to:Name(),
		['Target SteamID']	= to:SteamID(),
		['Target SteamID64']	= to:SteamID64()
	})
end)