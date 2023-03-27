plogs.Register('AWarn', true, Color(153,51,102))

plogs.AddHook('AWarnPlayerWarned', function(targ, admin, reason)
    plogs.PlayerLog(targ, 'AWarn', targ:NameID() .. ' was warned by ' .. admin:NameID() .. ' for ' .. reason, {
        ['Name']                = targ:Name(),
        ['SteamID']             = targ:SteamID(),
        ['SteamID64']             = targ:SteamID64(),
        ['Admin Name']          = admin:Name(),
        ['Admin SteamID']       = admin:SteamID(),
        ['Admin SteamID64']       = admin:SteamID64(),
        ['Reason']              = reason,
    })
end)

plogs.AddHook('AWarnPlayerIDWarned', function(steamid, admin, reason)
    local targ = plogs.FindPlayer(steamid)

    if IsValid(targ) then
        plogs.PlayerLog(targ, 'AWarn', targ:NameID() .. ' was warned by ' .. admin:NameID() .. ' for ' .. reason, {
            ['Name']                = targ:Name(),
            ['SteamID']             = targ:SteamID(),
            ['SteamID64']             = targ:SteamID64(),
            ['Admin Name']          = admin:Name(),
            ['Admin SteamID']       = admin:SteamID(),
            ['Admin SteamID64']       = admin:SteamID64(),
            ['Reason']              = reason,
        })
    else
        plogs.Log('AWarn', steamid .. ' was warned by ' .. admin:NameID() .. ' for ' .. reason, {
            ['SteamID']             = steamid,
            ['Admin Name']          = admin:Name(),
            ['Admin SteamID']       = admin:SteamID(),
            ['Admin SteamID64']       = admin:SteamID64(),
            ['Reason']              = reason,
        })
    end
end)

plogs.AddHook('AWarnLimitKick', function(pl)
    plogs.PlayerLog(pl, 'AWarn', pl:NameID() .. ' was kicked for too many warnings', {
        ['Name']                = pl:Name(),
        ['SteamID']             = pl:SteamID(),
        ['SteamID64']             = pl:SteamID64(),
    })
end)

plogs.AddHook('AWarnLimitBan', function(pl)
    plogs.PlayerLog(pl, 'AWarn', pl:NameID() .. ' was banned for too many warnings', {
        ['Name']                = pl:Name(),
        ['SteamID']             = pl:SteamID(),
        ['SteamID64']             = pl:SteamID64(),
    })
end)

plogs.Register('Job Changes', true, Color(0,255,255))

plogs.AddHook('MooseSetPlayerRegiment', function(user, ply, regiment)
    plogs.PlayerLog(targ, 'Job Changes', ply:NameID() .. ' was set to regiment ' .. regiment .. ' by ' .. user:NameID(), {
        ['Name']                = ply:Name(),
        ['SteamID']             = ply:SteamID(),
        ['SteamID64']             = ply:SteamID64(),
        ['Admin Name']          = user:Name(),
        ['Admin SteamID']       = user:SteamID(),
        ['Admin SteamID64']       = user:SteamID64(),
		['Regiment']              = regiment,
    })
end)

plogs.AddHook('MooseSetPlayerRank', function(user, ply, rank)
    plogs.PlayerLog(targ, 'Job Changes', ply:NameID() .. ' was set to rank ' .. rank .. ' by ' .. user:NameID(), {
        ['Name']                = ply:Name(),
        ['SteamID']             = ply:SteamID(),
        ['SteamID64']             = ply:SteamID64(),
        ['Admin Name']          = user:Name(),
        ['Admin SteamID']       = user:SteamID(),
        ['Admin SteamID']       = user:SteamID64(),
		['Rank']              = rank,
    })
end)

plogs.AddHook('MoosePromoteUser', function(user, ply, rank)
    plogs.PlayerLog(targ, 'Job Changes', ply:NameID() .. ' was promoted by ' .. user:NameID(), {
        ['Name']                = ply:Name(),
        ['SteamID']             = ply:SteamID(),
        ['SteamID64']             = ply:SteamID64(),
        ['Promoter Name']          = user:Name(),
        ['Promoter SteamID']       = user:SteamID(),
        ['Promoter SteamID64']       = user:SteamID64(),
    })
end)

plogs.AddHook('MooseDemoteUser', function(user, ply, rank)
    plogs.PlayerLog(targ, 'Job Changes', ply:NameID() .. ' was demoted by ' .. user:NameID(), {
        ['Name']                = ply:Name(),
        ['SteamID']             = ply:SteamID(),
        ['SteamID64']             = ply:SteamID64(),
        ['Demoter Name']          = user:Name(),
        ['Demoter SteamID']       = user:SteamID(),
        ['Demoter SteamID64']       = user:SteamID64(),
    })
end)

plogs.Register('Admin Claims', true, Color(50,175,255))

plogs.AddHook("ASayPopupClaim", function(admin, noob)
    plogs.PlayerLog(pl, 'Admin Claims', admin:NameID() .. ' claimed a case requested by ' .. noob:NameID(), {
        ['Name'] = admin:Name(),
        ['SteamID'] = admin:SteamID(),
        ['SteamID64'] = admin:SteamID64(),
        ['Requester Name'] = noob:Name(),
        ['Requester SteamID'] = noob:SteamID(),
        ['Requester SteamID64'] = noob:SteamID64()
    })
end)

plogs.AddHook("ASayPopupClaimCreate", function(ply, arg)
    plogs.PlayerLog(pl, 'Admin Claims', ply:NameID() .. ' has created a ticket for: ' .. arg, {
        ['Name'] = ply:Name(),
        ['SteamID'] = ply:SteamID(),
        ['SteamID64'] = ply:SteamID()
    })
end)

plogs.Register('Ships', true, Color(100,3,0))

plogs.AddHook("MoosePlayerEnterShip", function(ply, ship, shipseat)
    plogs.PlayerLog(pl, 'Ships', ply:NameID() .. ' entered the ' .. shipseat .. ' seat of ' .. ship, {
        ['Name'] = ply:Name(),
        ['SteamID'] = ply:SteamID(),
        ['SteamID64'] = ply:SteamID64(),
        ['Ship Name'] = ship
    })
end)