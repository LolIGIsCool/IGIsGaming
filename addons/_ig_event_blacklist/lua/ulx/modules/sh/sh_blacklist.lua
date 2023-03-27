function ulx.blacklist(ply)
    if ply:IsAdmin() then
        net.Start("blacklistmenu")
        net.Send(ply)
    end
end
local blacklist = ulx.command("Imperial Gaming", "ulx blacklist", ulx.blacklist, "!blacklist")
blacklist:defaultAccess(ULib.ACCESS_ADMIN)
blacklist:help("Blacklist Menu")