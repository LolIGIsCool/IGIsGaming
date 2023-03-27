if SERVER then
    util.AddNetworkString("VANILLABOUNTY_net_OpenHitMenu");
end

local clearances = {
    ["0"] = false,
    ["1"] = false,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true,
    ["6"] = true,
    ["ALL ACCESS"] = true,
    ["CLASSIFIED"] = true,
    ["Imperial Citizen"] = true,
    ["AREA ACCESS"] = true,
}

function ulx.bounty( calling_ply )
    if clearances[calling_ply:GetJobTable().Clearance] or false then
        net.Start("VANILLABOUNTY_net_OpenHitMenu");
        net.Send(calling_ply);
    end
end

local bounty = ulx.command( "Vanilla", "ulx bounty", ulx.bounty, "!bounty" );
bounty:defaultAccess( ULib.ACCESS_ALL );
bounty:help( "Opens the bounty hit menu. Clearance Level 2 or above is required." );
