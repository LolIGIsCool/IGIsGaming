plogs.Register('Bounty Hunter', true, Color(0,255,255))

plogs.AddHook('BOUNTY_PlaceHit', function(owner, target)
    plogs.PlayerLog(owner, 'Bounty Hunter', owner:NameID() .. ' has placed a hit on ' .. target:ID(), {
        ['Placer Name']                = owner:Name(),
        ['Placer SteamID']             = owner:SteamID(),
        ['Placer SteamID64']	= owner:SteamID64(),
		['Target Name']             = target:Name(),
        ['Target SteamID']             = target:SteamID(),
        ['Target SteamID64']	= target:SteamID64()
    })
end)

plogs.AddHook('BOUNTY_ClaimHit', function(hunter, target)
    plogs.PlayerLog(hunter, 'Bounty Hunter', hunter:NameID() .. ' has claimed a hit on ' .. target:ID(), {
        ['Hunter Name']                = hunter:Name(),
        ['Hunter SteamID']             = hunter:SteamID(),
        ['Hunter SteamID64']	= hunter:SteamID64(),
		['Target Name']             = target:Name(),
        ['Target SteamID']             = target:SteamID(),
        ['Target SteamID64']	= target:SteamID64()
    })
end)

plogs.AddHook('BOUNTY_CompleteHit', function(hunter, target)
    plogs.PlayerLog(hunter, 'Bounty Hunter', hunter:NameID() .. ' has successfully killed ' .. target:ID(), {
        ['Hunter Name']                = hunter:Name(),
        ['Hunter SteamID']             = hunter:SteamID(),
        ['Hunter SteamID64']	= hunter:SteamID64(),
		['Target Name']             = target:Name(),
        ['Target SteamID']             = target:SteamID(),
        ['Target SteamID64']	= target:SteamID64()
    })
end)

plogs.AddHook('BOUNTY_FailHit', function(hunter, target)
    plogs.PlayerLog(hunter, 'Bounty Hunter', hunter:NameID() .. ' has failed their hit on ' .. target:ID(), {
        ['Hunter Name']                = hunter:Name(),
        ['Hunter SteamID']             = hunter:SteamID(),
        ['Hunter SteamID64']	= hunter:SteamID64(),
		['Target Name']             = target:Name(),
        ['Target SteamID']             = target:SteamID(),
        ['Target SteamID64']	= target:SteamID64()
    })
end)