CreateClientConVar("hdsmp_clientVolumeSetting", "100", false, false)
CreateClientConVar("hdsmp_clientVolumePersistance", "false", false, false)
GetConVar("hdsmp_clientVolumeSetting"):SetInt(100)
GetConVar("hdsmp_clientVolumePersistance"):SetBool(false)

list.Set( "DesktopWindows", "hideyoshi_clientside_music_control", {
    title = "Hideyoshi Music Box Clientside Control",
    icon = "icon16/music.png",
    init = function( icon, window )
        if ( SERVER ) then return end

        if IsValid(hdsmp_controlPanel) then 
            hdsmp_controlPanel:Close()
        end

        hook.Add("OnContextMenuClose", "Hide_HideyoshiAudioControl", function()
            if IsValid(hdsmp_controlPanel) then
                hdsmp_controlPanel:Hide()
            end
        end)

        hook.Add("OnContextMenuOpen", "Show_HideyoshiAudioControl", function()
            if IsValid(hdsmp_controlPanel) then
                hdsmp_controlPanel:Show()
            end
        end)

        renderControlPanel_hdsmp()
    

    end
} )

function renderControlPanel_hdsmp()
    hdsmp_controlPanel = vgui.Create( "DFrame" )
    hdsmp_controlPanel:Center()			
    hdsmp_controlPanel:SetSize( 350, 200 ) 
    hdsmp_controlPanel:SetTitle( "Hideyoshi's SWRP Music Clienstide Control" ) 
    hdsmp_controlPanel:SetVisible( true ) 
    hdsmp_controlPanel:SetDraggable( true ) 
    hdsmp_controlPanel:ShowCloseButton( true ) 
    hdsmp_controlPanel:MakePopup()
    function hdsmp_controlPanel:OnClose()
        LocalPlayer():SetNWBool("Hideyoshi_ResetConfigValue", hdsmp_controlPanel_ResetConfig:GetChecked())
        --LocalPlayer():SetNWBool("Hideyoshi_MuteConfigValue", hdsmp_controlPanelVolumeSlider_MuteConfig:GetChecked())
        Hideyoshi_SongVolumeMessage = hdsmp_controlPanelVolumeSlider:GetValue()
    end
    hdsmp_controlPanel.Paint = function (self, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 37,37,37, 255 ) ) -- Draw a red box instead of the frame
        draw.RoundedBox( 0, 0, 25, w, 2, Color( 37,37,37, 255 ) ) 
        draw.RoundedBox( 0, 0, h/8, w, h, Color( 46,46,46, 255 ) ) 

        draw.RoundedBox( 0, 0, h/1.75, w, 1, Color(155, 155, 155, 155) ) 

        if (LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay and LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay) then
            draw.SimpleText("Music Player #"..LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay:EntIndex(), "Hideyoshi_DermaMediumBold", w/2.1, h/1.675, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        else
            draw.SimpleText("No Active Music Player", "Hideyoshi_DermaMediumBold", w/2.1, h/1.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        end
    end

    local hdsmp_controlPanelVolumeLabel = vgui.Create( "DLabel", hdsmp_controlPanel )
    hdsmp_controlPanelVolumeLabel:SetPos( 40, 40 )
    hdsmp_controlPanelVolumeLabel:SetText( "Manual Volume Control" )
    hdsmp_controlPanelVolumeLabel:SetFont("DermaDefaultBold")
    hdsmp_controlPanelVolumeLabel:SizeToContents()

    hdsmp_controlPanelVolumeSlider = vgui.Create( "DNumSlider", hdsmp_controlPanel )
    hdsmp_controlPanelVolumeSlider:SetPos( 40, 60 )				-- Set the position
    hdsmp_controlPanelVolumeSlider:SetSize( 300, 15)
    hdsmp_controlPanelVolumeSlider:SetText( "Manual Volume" )	-- Set the text above the slider
    hdsmp_controlPanelVolumeSlider:SetMin( 0 )				 	-- Set the minimum number you can slide to
    hdsmp_controlPanelVolumeSlider:SetMax( 1000 )				-- Set the maximum number you can slide to
    hdsmp_controlPanelVolumeSlider:SetDecimals( 0 )				-- Decimal places - zero for whole number
    hdsmp_controlPanelVolumeSlider:SetDefaultValue(100)
    hdsmp_controlPanelVolumeSlider:ResetToDefaultValue()
    hdsmp_controlPanelVolumeSlider:SetConVar("hdsmp_clientVolumeSetting")
    hdsmp_controlPanelVolumeSlider:SetValue(GetConVar("hdsmp_clientVolumeSetting"):GetInt())
    cvars.AddChangeCallback("hdsmp_clientVolumeSetting", function()
        --local sw_station = LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station
        if (hdsmp_tableOfigmodaudio ~= nil) then
            for k,v in pairs(hdsmp_tableOfigmodaudio) do
                if (IsValid(v)) then
                    v:SetVolume(GetConVar("hdsmp_clientVolumeSetting"):GetInt()/100)
                end
            end
        end
        hdsmp_controlPanelVolumeSlider:SetValue(GetConVar("hdsmp_clientVolumeSetting"):GetInt())
    end)

    hdsmp_controlPanel_ResetConfig = vgui.Create( "DCheckBoxLabel", hdsmp_controlPanel )
    hdsmp_controlPanel_ResetConfig:SetPos( 40, 80 )						-- Set the position
    hdsmp_controlPanel_ResetConfig:SetText("Do not reset volume after music change")					-- Set the text next to the box
    hdsmp_controlPanel_ResetConfig:SetValue( GetConVar("hdsmp_clientVolumePersistance"):GetBool() or false )						-- Initial value
    hdsmp_controlPanel_ResetConfig:SizeToContents()				-- Make its size the same as the contents
    hdsmp_controlPanel_ResetConfig:SetConVar( "hdsmp_clientVolumePersistance" )
    renderRemotePlayer_hsmp()
end

function renderRemotePlayer_hsmp()
    if (LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay and LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay) then

        local parent_length, parent_width = hdsmp_controlPanel:GetSize()

        --[[local DPanel = vgui.Create( "DPanel", hdsmp_controlPanel )
        DPanel:SetPos( 0, parent_width/1.725 ) -- Set the position of the panel
        DPanel:SetSize( parent_length, parent_width/2.3 ) -- Set the size of the panel
        DPanel.Paint = function(self , w, have) 
            --draw.SimpleText("Music Player #".."18", "Hideyoshi_DermaMediumBold", w/3, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end]]--

        local hdsmp_remotePlayer_slider = vgui.Create( "DNumSlider", hdsmp_controlPanel )
        hdsmp_remotePlayer_slider:SetPos( 40, 145 )				-- Set the position
        hdsmp_remotePlayer_slider:SetSize( 300, 15)
        hdsmp_remotePlayer_slider:SetText( "Pending song input..." )	-- Set the text above the slider
        hdsmp_remotePlayer_slider:SetMin( 0 )				 	-- Set the minimum number you can slide to
        hdsmp_remotePlayer_slider:SetMax( 0 )				-- Set the maximum number you can slide to
        hdsmp_remotePlayer_slider:SetDecimals( 0 )				-- Decimal places - zero for whole number
        hdsmp_remotePlayer_slider.Paint = function(self, w, h) 
            if (IsValid(LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station)) then
                self:SetText(string.FormattedTime(LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station:GetTime(), "%02i:%02i"))
                if (self:GetMax() ~= LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station:GetLength()) then
                    self:SetMax(LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station:GetLength())
                end
                self:SetValue(LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay.sw_station:GetTime())
            end
        end

        local DermaButton = vgui.Create( "DButton", hdsmp_controlPanel )
        DermaButton:SetText( "Open Control Panel" )	
        DermaButton:SetPos( parent_width/4, parent_length/2.015 )
        DermaButton:SetSize( 250, 15 )
        DermaButton.DoClick = function()
            drawHideMusic_derma(LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay)
        end
    end
end