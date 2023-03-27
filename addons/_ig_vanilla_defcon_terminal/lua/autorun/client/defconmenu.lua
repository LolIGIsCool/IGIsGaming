net.Receive("OPENDEFCONMENUVANILLAILOVEYOU",function()
    local panel = vgui.Create("DFrame")
    panel:MakePopup()
    panel:SetSize(ScrW() * 0.4,ScrH() * 0.4)
    panel:Center()


    local DScrollPanel = vgui.Create( "DScrollPanel", panel )
    DScrollPanel:Dock( FILL )

    local b1 = DScrollPanel:Add( "DButton" )
    b1:SetText( "Protocol 13" )
    b1:Dock( TOP )
    b1:DockMargin( 0, 0, 0, 5 )
    b1.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(11,16)
        net.SendToServer()
    end

    local b2 = DScrollPanel:Add( "DButton" )
    b2:SetText( "Evacuation" )
    b2:Dock( TOP )
    b2:DockMargin( 0, 0, 0, 5 )
    b2.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(12,16)
        net.SendToServer()
    end

    local b3 = DScrollPanel:Add( "DButton" )
    b3:SetText( "Battle Stations" )
    b3:Dock( TOP )
    b3:DockMargin( 0, 0, 0, 5 )
    b3.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(13,16)
        net.SendToServer()
    end

    local b4 = DScrollPanel:Add( "DButton" )
    b4:SetText( "Standby Alert" )
    b4:Dock( TOP )
    b4:DockMargin( 0, 0, 0, 5 )
    b4.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(41,16)
        net.SendToServer()
    end

    local b5 = DScrollPanel:Add( "DButton" )
    b5:SetText( "Standard Operations" )
    b5:Dock( TOP )
    b5:DockMargin( 0, 0, 0, 5 )
    b5.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(21,16)
        net.SendToServer()
    end

    local b6 = DScrollPanel:Add( "DButton" )
    b6:SetText( "Full Lockdown" )
    b6:Dock( TOP )
    b6:DockMargin( 0, 0, 0, 5 )
    b6.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(31,16)
        net.SendToServer()
    end

    local b7 = DScrollPanel:Add( "DButton" )
    b7:SetText( "Intruder Alert" )
    b7:Dock( TOP )
    b7:DockMargin( 0, 0, 0, 5 )
    b7.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(32,16)
        net.SendToServer()
    end

    local b8 = DScrollPanel:Add( "DButton" )
    b8:SetText( "Hazard Alarm" )
    b8:Dock( TOP )
    b8:DockMargin( 0, 0, 0, 5 )
    b8.DoClick = function()
        net.Start("VANILLAFROMTHEUNDERWORLDDEFCON")
        net.WriteUInt(42,16)
        net.SendToServer()
    end
end)