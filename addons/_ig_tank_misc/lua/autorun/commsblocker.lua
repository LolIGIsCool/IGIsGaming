if SERVER then
    util.AddNetworkString("IGVANILLABlockCommsNoti")
    util.AddNetworkString("IGVANILLABlockCommsNoti2")
    IGGlobalBlockComms = false

    hook.Add( "IGPlayerSay", "IGVANILLABlockComms", function( ply, text, team )
        if (string.sub(text, 1, 11) == "!blockcomms") and ply:IsAdmin() then
            if IGGlobalBlockComms == false then
                IGGlobalBlockComms = true
                net.Start("IGVANILLABlockCommsNoti")
                net.Broadcast()
                RunConsoleCommand("ulx", "asay", ply:Nick(), "has", "blocked", "communications")
            else
                IGGlobalBlockComms = false
                net.Start("IGVANILLABlockCommsNoti2")
                net.Broadcast()
                RunConsoleCommand("ulx", "asay", ply:Nick(), "has", "unblocked", "communications")
            end
            return ""
        end
        if IGGlobalBlockComms == true and string.sub(string.lower(text), 1, 6) == "/comms" then
            net.Start("IGVANILLABlockCommsNoti")
            net.Send(ply)
            return ""
        end
    end)
end

if CLIENT then
    net.Receive("IGVANILLABlockCommsNoti",function()
        chat.AddText("Your communications unit has been blocked.")
    end)
    net.Receive("IGVANILLABlockCommsNoti2",function()
        chat.AddText("Your communications unit is back online.")
    end)
end
