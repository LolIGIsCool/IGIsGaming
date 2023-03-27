if SERVER then
    util.AddNetworkString("vanillaObjectiveSet")
    util.AddNetworkString("vanillaClientReady")

    hook.Add("IGPlayerSay", "vanillaObjective", function( ply, text )
        if string.StartWith(string.lower(text),"!objective") or string.StartWith(string.lower(text),"/objective") then // ADMIN/EM CHECK GOES HERE
			if ply:IsAdmin() or ply:GetRegiment() == "Imperial High Command" then
            local objectiveText = string.sub(text,12)
            RunConsoleCommand("ulx", "asay", ply:Nick(), "has", "changed", "objective", "to", objectiveText);
            net.Start("vanillaObjectiveSet")
            net.WriteString(objectiveText)
            net.Broadcast()
            //file for when people join AFTER the objective has been set
            file.Write("vanillaObjectiveText.txt", objectiveText)
            return ""
			end
        end
    end)

    net.Receive("vanillaClientReady",function(len, ply)
        //reading from file that was saved
        local objectiveText = file.Read("vanillaObjectiveText.txt")
        net.Start("vanillaObjectiveSet")
        net.WriteString(objectiveText)
        net.Send(ply)
    end)
end

if CLIENT then
    // for when the client connects, should be 100% exploit proof as on the server it only uses who sent it.
    hook.Add("InitPostEntity", "vanillaClientReady", function()
        net.Start("vanillaClientReady")
        net.SendToServer()
    end)

    //hud to display the objective
    net.Receive("vanillaObjectiveSet", function(len, ply)
        local vanillaObjectiveText = net.ReadString()
        hook.Add( "HUDPaint", "vanillaCurrentObjectiveHUD", function()
            _G.vanillaBlurPanel(ScrW() * 0.745,ScrH() * 0.14, ScrW() * 0.245, ScrH() * 0.07,Color(0,0,0,100));

            surface.SetDrawColor( 255, 255, 255, 200 );
            surface.DrawRect(ScrW() * 0.75,ScrH() * 0.175,ScrW() * 0.234,ScrH() * 0.0025);

            surface.SetFont("vanilla_font_info")
            surface.SetTextColor(255,255,255,200)
            surface.SetTextPos(ScrW() * 0.75,ScrH() * 0.15)
            surface.DrawText("CURRENT OBJECTIVE")

            surface.SetFont("Trebuchet18")
            surface.SetTextPos(ScrW() * 0.75,ScrH() * 0.185)
            surface.DrawText(vanillaObjectiveText)
        end)
        if vanillaObjectiveText == "" or vanillaObjectiveText == " " then
            hook.Remove("HUDPaint","vanillaCurrentObjectiveHUD")
        end
    end)
end
