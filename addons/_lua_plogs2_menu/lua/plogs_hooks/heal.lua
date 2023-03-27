plogs.Register('Healing', true, Color(0,255,255))

plogs.AddHook('healfrombacta', function(self,heal,target)
    plogs.PlayerLog(targ, 'Healing', self:Nick() .. ' has healed ' .. target:Nick() .. ' for ' .. heal .. ' health', {
        ['Name']                = self:Nick(),
        ['SteamID']             = self:SteamID(),
        ['SteamID64']	= self:SteamID64()
    })
end)