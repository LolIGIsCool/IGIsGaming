plogs.Register('Name Changes', true, Color(0,255,255))

plogs.AddHook('MooseSetPlayerName', function(self, name)
    plogs.PlayerLog(self, 'Name Changes', self:NameID() .. ' changed their name to ' .. name, {
        ['Old Name']                = self:Name(),
        ['SteamID']             = self:SteamID(),
        ['SteamID64']	= self:SteamID64(),
		['New Name']             = name
    })
end)