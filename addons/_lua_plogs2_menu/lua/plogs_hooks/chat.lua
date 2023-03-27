plogs.Register('Chat', false)

local hook_name = DarkRP and 'PostPlayerSay' or 'IGPlayerSay'
plogs.AddHook(hook_name, function(pl, text)
	if (text ~= '') then
		plogs.PlayerLog(pl, 'Chat', pl:NameID() .. ' said ' .. string.Trim(text), {
			['Name'] 	= pl:Name(),
			['SteamID']	= pl:SteamID(),
			['SteamID64']	= pl:SteamID64()
		})
	end
end)

---------------------------------------------