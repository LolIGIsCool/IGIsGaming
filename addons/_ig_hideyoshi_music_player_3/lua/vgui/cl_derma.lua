local hideMusic_derma
function hdsmp_DrawDerma(hideMusic)
    hideMusic_derma = hideMusic

    local ent = hideMusic_derma.instance
    local spawnerInfo = player.GetBySteamID( ent:Getent_plyspawner() )

    local l,w = ScrW()/1.6,ScrH()/1.55

    frameMuse = vgui.Create( "DFrame" )
    frameMuse:SetTitle( "" )
    frameMuse:SetSize( l,w )
    frameMuse:Center()			
    frameMuse:MakePopup()
    frameMuse.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox( 0, 0, 0, w, h, Color( 46,46,46, 255 ) ) -- Draw a red box instead of the frame
        draw.RoundedBox( 0, 0, 25, w, 2, Color( 37,37,37, 255 ) ) 

        draw.SimpleText("Hideyoshi's Music Player Management", "Hideyoshi_DermaSmall", w/2-20, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.RoundedBox( 0, w-(w/1.2), h/25, w/1.2, h/1.15, Color( 29,29,29, 255 ) ) 

        draw.RoundedBox( 0, 0, h/1.1, w, 2, Color( 37,37,37, 255 ) ) 
        draw.RoundedBox( 0, w-(w/1.198), h/25.5, 2, h/1.15, Color( 37,37,37, 255) ) 

        draw.RoundedBox( 0, w-(w/1.2), h/25, w/1.2, h/12, Color( 59,59,59, 255 ) ) 
        draw.SimpleText("Current selected player is", "Hideyoshi_DermaSmall", w-(w/1.225), h/21, Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleText("Music Player #"..ent:EntIndex(), "Hideyoshi_DermaDefault", w-(w/1.225), h/16, Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Spawned by ".. spawnerInfo:Nick() , "Hideyoshi_DermaSmall", w-(w/40), h/12, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    
        if (hideMusic_derma.instance.curSongName ~= "" and IsValid(hideMusic_derma.instance.sw_station) and hideMusic_derma.instance.sw_station:GetState() == 1) then
            draw.SimpleText(hideMusic_derma.instance.curSongName, "DermaDefault", w/1.71, h/1.03, Color(255,255,255,55), TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
        end
    end
    
    drawPlayerManagement()
    drawSideBar( frameMuse )
    renderMusicControl(frameMuse)

    local sheetx, sheety = w*1.4365, l/2.2
    songSelect_elementSheet = vgui.Create( "DPropertySheet", frameMuse )
    songSelect_elementSheet:SetPos(ScrW()/9.65, ScrH()/12.6)
    songSelect_elementSheet:SetSize( ScrW()/1.92, ScrH()/1.98 )
    songSelect_elementSheet.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
    end

    local localmusicSheet = vgui.Create( "DPanel", songSelect_elementSheet )
    localmusicSheet.Paint = function() end

    local localDScrollPanel = vgui.Create( "DScrollPanel", localmusicSheet )
    localDScrollPanel:SetPos(0,ScrH()/126.72)
    localDScrollPanel:SetSize( ScrW()/1.95, ScrH()/2.31 )
    -- REAL CODE
    local hideyoshi_mp3name = file.Find("sound/*.mp3", "[IG] Revamped Hideyoshi Music Player")

    for k,v in pairs(hideyoshi_mp3name) do
        local DButton = localDScrollPanel:Add( "DButton" )
        DButton:SetText( "" )
        DButton:Dock( TOP )
        DButton:DockMargin( 0, 0, 0, 5 )
        DButton:SetSize(ScrW()/7.04, ScrH()/38.85)
        DButton.songValue = v
        DButton.Paint = function (self, w, h ) 
            if DButton:IsHovered() or hideMusic_derma.selectedLocalSong == DButton.songValue then
                draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46,255))
            end
            
            draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))
        
            if hideyoshi_mp3name[1] == nil then
                draw.SimpleText("Err","Something went wrong! Couldn't fetch music! Do you have the [IG] Revamped Hideyoshi Music Player addon installed?.", "Hideyoshi_DermaMediumBold", w/26, h/6.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText(k, "Hideyoshi_DermaSmall", w/128, h/4, Color(255,255,255,55), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(string.Replace(v, ".mp3", ""):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end), "Hideyoshi_DermaMediumBold", w/26, h/6.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(string.FormattedTime( SoundDuration(v), "%02i:%02i" ) , "Hideyoshi_DermaSmall", w - w/40, h/8.5, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            end
        end
        DButton.DoClick = function(self)
            hideMusic_derma.selectedLocalSong = self.songValue
        end
        function DButton:OnMousePressed(keyCode)
            if (keyCode == 108) then
                processQueueAdition(string.Replace(v, ".mp3", ""):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end),
                self.songValue, false, hideMusic_derma)
            elseif (keyCode == 107) then
                hideMusic_derma.selectedLocalSong = self.songValue
            end
        end
    end
    -- REAL CODE

    local Hideyoshi_PlayMusicButton = vgui.Create( "DButton", localmusicSheet ) 
    Hideyoshi_PlayMusicButton:SetText( "Play Music" )					
    Hideyoshi_PlayMusicButton:Dock( BOTTOM )
    Hideyoshi_PlayMusicButton:SetSize( 50, 20 )					
    Hideyoshi_PlayMusicButton.DoClick = function()
        if Hideyoshi_SelectedSongName == "" then
            notification.AddLegacy("Please select a song.", 1, 2)
        end

        -- Hideyoshi_PlayMusic(global_variable, musicplayer_pos, song_name, Hideyoshi_SongVolume, MusicPlayerSoundDistance, IsExternalMusic, URL)

        local netQuery = {
            instance = hideMusic_derma.instance:EntIndex(),
            filePath = hideMusic_derma.selectedLocalSong,
            url = nil,
            volume = VolDermaNumSlider:GetValue(),
            soundDistance = DistanceDermaNumSlider:GetValue(),
            isexternalmusic = false,
            isGlobal = Hideyoshi_GlobalMusicDermaCheckbox:GetChecked(),
        }
        hideMusic_derma.selectedLocalSong = nil
        processSongRequest(netQuery)

        --[[net.Start("Hideyoshi_SendToServer_MusicInformation")
            net.WriteTable(Hideyoshi_NetTable)
        net.SendToServer()]]--
    end
    Hideyoshi_PlayMusicButton.Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h, Color(55, 55, 55, 255))

    end

    --panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
    songSelect_elementSheet:AddSheet( "Local Music", localmusicSheet, "icon16/music.png" )
    --panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
    songSelect_elementSheet:AddSheet( "YouTube Converter", renderConverterPanel(songSelect_elementSheet, sheetx, sheety), "icon16/xhtml.png" )
    --panel3.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
    songSelect_elementSheet:AddSheet( "Queue", renderQueuePanel(songSelect_elementSheet, sheetx, sheety), "icon16/text_list_bullets.png" )
    --panel4.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 128, 255, self:GetAlpha() ) ) end 
    songSelect_elementSheet:AddSheet( "Options", renderSettingsPanel(songSelect_elementSheet), "icon16/cog.png" )
end

function renderMusicControl(frame)
    local wPar, hPar = frame:GetSize()

    local currentTimeLabel = vgui.Create( "DLabel", frame )
    currentTimeLabel:SetPos( ScrW()/9.14, ScrH()/1.65 )
    currentTimeLabel:SetText( "00:00" )
    currentTimeLabel:SetFont( "Hideyoshi_DermaSmallBold" )
    currentTimeLabel.Paint = function(self, w, h) 
        local sw_station = hideMusic_derma.instance.sw_station
        if (IsValid(sw_station) and sw_station:GetState() == 1 and sw_station:GetTime()) then
            self:SetText(string.FormattedTime(sw_station:GetTime(), "%02i:%02i"))
        end
    end

    local isinLimbo = false
    local editDelay = 0
    local limboDelay = 0
    local editDelayValue = 0

    local timeSlider = vgui.Create( "DNumSlider", frame )
    timeSlider:SetPos( -(ScrW()/4.96), ScrH()/1.65 )
    timeSlider:SetSize( ScrW()/1.23, ScrH()/72 )
    timeSlider:SetMin( 0 )
    timeSlider:SetMax( 0 )
    timeSlider:SetDecimals( 0 )
    timeSlider.OnValueChanged = function( self, value )
        if (self:IsEditing()) then
            editDelay = RealTime() + 0.5
            editDelayValue = self:GetValue()
            --print( tostring( value ) )
        elseif (RealTime() > limboDelay) then
            if (((editDelay - 0.5) < RealTime()) and ((editDelay + 0.5) > RealTime())) then
                isinLimbo = true
                sendTimeOrder(editDelayValue, hideMusic_derma.instance, function()
                    isinLimbo = false
                    limboDelay = RealTime() + 1
                    editDelay = 0
                    editDelayValue = 0
                end)
            end
        end
    end
    timeSlider.Paint = function( self, w, h )
        local sw_station = hideMusic_derma.instance.sw_station
        if (IsValid(sw_station) and sw_station:GetState() == 1 and sw_station:GetTime() and sw_station:GetLength()) then
            self:SetMax(sw_station:GetLength())
            if (!self:IsEditing() and RealTime() > editDelay or isinLimbo) then
                self:SetValue(sw_station:GetTime())
            end
        end


    end

    local Shape = vgui.Create( "DShape", frame )
    Shape:SetType( "Rect" ) -- This is the only type it can be
    Shape:SetPos( ScrW()/1.70, ScrH()/1.6425 ) 
    Shape:SetColor( Color(46,46,46, 255) )
    Shape:SetSize( ScrW()/34.91,ScrH()/72 )

    local lengthTimeLabel = vgui.Create( "DLabel", frame )
    lengthTimeLabel:SetPos( ScrW()/1.68, ScrH()/1.65 )
    lengthTimeLabel:SetText( "00:00" )
    lengthTimeLabel:SetFont( "Hideyoshi_DermaSmallBold" )
    lengthTimeLabel.Paint = function(self, w, h) 
        local sw_station = hideMusic_derma.instance.sw_station
        if (IsValid(sw_station) and sw_station:GetState() == 1 and sw_station:GetLength()) then
            self:SetText(string.FormattedTime(sw_station:GetLength(), "%02i:%02i"))
        end
    end

    hdsmp_playMode = {}
    hdsmp_playMode[false] = "play"
    hdsmp_playMode[true] = "pause"
    hdsmp_playMode[0] = false
    hdsmp_playMode[1] = true
    hdsmp_playMode[2] = false
    hdsmp_playMode[3] = false

    local playPauseButton = vgui.Create( "DImageButton", frame )
    playPauseButton:SetSize(ScrW()/42.67, ScrH()/24)
    playPauseButton:SetPos( ScrW()/24.80, ScrH()/1.68 )				-- Set position
    playPauseButton:SetImage( "hideyoshi_vgui/vgui_play.png" )	-- Set the material - relative to /materials/ directory
    playPauseButton.Paint = function(self)
        --[[if (IsValid(hideMusic_derma.instance.sw_station) and self.currentMode ~= true) then
            playPauseButton:SetImage("hideyoshi_vgui/vgui_"..hdsmp_playMode[self.currentMode]..".png")
        elseif (!IsValid(hideMusic_derma.instance.sw_station) and self.currentMode ~= false) then
            playPauseButton:SetImage("hideyoshi_vgui/vgui_"..hdsmp_playMode[self.currentMode]..".png")
        end]]--
        if (!IsValid(hideMusic_derma.instance.sw_station)) then return end

        playPauseButton:SetImage("hideyoshi_vgui/vgui_"..hdsmp_playMode[hdsmp_playMode[hideMusic_derma.instance.sw_station:GetState()]]..".png")

    end
    playPauseButton.DoClick = function(self)
        if (!IsValid(hideMusic_derma.instance.sw_station)) then return end
        playPauseButton:SetImage("hideyoshi_vgui/vgui_"..hdsmp_playMode[hdsmp_playMode[hideMusic_derma.instance.sw_station:GetState()]]..".png")
        --self.currentMode = !self.currentMode
        --print(self.currentMode)
        sendStateChange(hideMusic_derma.instance:EntIndex(), hdsmp_playMode[hdsmp_playMode[hideMusic_derma.instance.sw_station:GetState()]])

        --self.currentMode = !self.currentMode
    end

    local forwardButton = vgui.Create( "DImageButton", frame )
    forwardButton:SetSize(ScrW()/64, ScrH()/36)
    forwardButton:SetPos( ScrW()/12.75, ScrH()/1.66 )				-- Set position
    forwardButton:SetImage( "hideyoshi_vgui/derma_forward.png" )	-- Set the material - relative to /materials/ directory
    forwardButton.DoClick = function()
        local queueJSON = hideMusic_derma.instance:GetqueueConstruct()
        local queue = util.JSONToTable(queueJSON)
        if (queue ~= nil and #queue >= 1 and hideMusic_derma.instance.processingSong == nil ) then
            --if (player.GetBySteamID(hideMusic_derma.instance:Getent_plyspawner()) == LocalPlayer()) then
            hideMusic_derma.instance.isProcessing = true
            net.Start("hdsmp_pushQueue")
                net.WriteInt(1, 11)
                net.WriteInt(hideMusic_derma.instance:EntIndex(), 21)
            net.SendToServer()
            --end
        end
    end

    local imageryReference = {}
    imageryReference[true] = "hideyoshi_vgui/derma_repeatActive.png"
    imageryReference[false] = "hideyoshi_vgui/derma_repeatInactive.png"
    
    local backButton = vgui.Create( "DImageButton", frame )
    if (IsValid(hideMusic_derma.instance.sw_station)) then
        backButton.IsActive = hideMusic_derma.instance.sw_station:IsLooping()
    else
        backButton.IsActive = false
    end
    backButton:SetSize(ScrW()/54.86, ScrH()/30.86)
    backButton:SetPos( ScrW()/94.12, ScrH()/1.66 )				-- Set position
    backButton:SetImage( imageryReference[backButton.IsActive] )	-- Set the material - relative to /materials/ directory
    backButton.DoClick = function(self)
        if (!LocalPlayer():IsAdmin()) then return end
        if (!IsValid(hideMusic_derma.instance.sw_station)) then return end

        self.IsActive = !self.IsActive

        self:SetImage(imageryReference[self.IsActive])

        net.Start("hdsmp_setLooping")
            net.WriteInt(hideMusic_derma.instance:EntIndex(), 21)
        net.SendToServer()
    end
end

function renderConverterPanel(songSelect_elementSheet, sheetx, sheety)
    local youtubeConvertSheet = vgui.Create( "DPanel", songSelect_elementSheet )
    youtubeConvertSheet.Paint = function() end

    local searchQuery = vgui.Create( "DTextEntry", youtubeConvertSheet ) -- create the form as a child of frame
    searchQuery:SetPos( ScrW()/128,ScrH()/72 )
    searchQuery:SetSize( ScrW()/5.28, ScrH()/48.55  )
    searchQuery:SetPlaceholderText("YouTube Query")
    searchQuery.OnEnter = function(self)
        if (self:GetValue() ~= "") then
            local query = self:GetText()
            prepareQuery(query, youtubeConvertSheet, sheety, sheetx)
        end
    end
    searchQuery.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
        self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
        if (!self:IsEditing() and self:GetValue() == "") then
            draw.SimpleText("YouTube Query", "DermaDefault", w/32, h/6, Color(155,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    local querySubmitButton = vgui.Create( "DImageButton", youtubeConvertSheet )
    querySubmitButton:SetPos(ScrW()/4.94,ScrH()/61.71)
    -- DermaImageButton:SetSize( 16, 16 )			-- OPTIONAL: Use instead of SizeToContents() if you know/want to fix the size
    querySubmitButton:SetImage( "icon16/magnifier.png" )	-- Set the material - relative to /materials/ directory
    querySubmitButton:SizeToContents()				-- OPTIONAL: Use instead of SetSize if you want to resize automatically ( without stretching )
    querySubmitButton.DoClick = function()
        if (searchQuery:GetValue() ~= "") then
            local query = searchQuery:GetText()
            prepareQuery(query, youtubeConvertSheet, sheety, sheetx)
        end
    end

    hideMusic_derma.DScrollPanel = vgui.Create( "DScrollPanel", youtubeConvertSheet )
    hideMusic_derma.DScrollPanel:SetPos(0,sheety/9)
    hideMusic_derma.DScrollPanel:SetSize( sheety*1.8, sheetx/2.35  )
    for i=0, 24 do
        insertBlankButtons(hideMusic_derma.DScrollPanel, sheety, sheetx)
    end

    hideMusic_derma.urlSubmit = vgui.Create( "DTextEntry", youtubeConvertSheet ) -- create the form as a child of frame
    hideMusic_derma.urlSubmit:SetPos(15,sheety-(sheety/9.25))
    hideMusic_derma.urlSubmit:SetSize( ScrW()/5.28, ScrH()/48.55  )
    hideMusic_derma.urlSubmit:SetPlaceholderText("YouTube Query")
    hideMusic_derma.urlSubmit.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
        self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
        if (!self:IsEditing() and self:GetValue() == "") then
            draw.SimpleText("YouTube URL", "DermaDefault", w/32, h/6, Color(155,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    local processURL = vgui.Create( "DButton", youtubeConvertSheet )
    processURL:SetText( "Play" )
    processURL:SetPos(25 + sheetx/2.75,sheety-(sheety/9.5))
    processURL:SetSize( 50, 20 )					
    processURL.DoClick = function()				
        if (hideMusic_derma.urlSubmit:GetValue() == "") then
            notification.AddLegacy("URL Section is empty! Please enter a valid URL.", 1, 2)
            return
        end

        local netQuery_tube = {
            instance = hideMusic_derma.instance:EntIndex(),
            filePath = nil,
            url = hideMusic_derma.urlSubmit:GetValue(),
            volume = VolDermaNumSlider:GetValue(),
            soundDistance = DistanceDermaNumSlider:GetValue(),
            isexternalmusic = true,
            isGlobal = Hideyoshi_GlobalMusicDermaCheckbox:GetChecked(),
        }

        --[[processSongRequest(
            hideMusic_derma.instance:EntIndex(),
            nil,
            hideMusic_derma.urlSubmit:GetValue(),
            VolDermaNumSlider:GetValue(),
            DistanceDermaNumSlider:GetValue(),
            true,
            Hideyoshi_GlobalMusicDermaCheckbox:GetChecked(),
            false,
            nil
        )]]--

        processSongRequest(netQuery_tube)
    end

    return youtubeConvertSheet;
end

function renderQueuePanel(songSelect_elementSheet, sheetx, sheety)
    local queueSheet = vgui.Create( "DPanel", songSelect_elementSheet )
    queueSheet.Paint = function() end

    local searchQuery = vgui.Create( "DTextEntry", queueSheet ) -- create the form as a child of frame
    searchQuery:SetPos(15,15)
    searchQuery:SetSize( ScrW()/5.28, ScrH()/48.55  )
    searchQuery:SetPlaceholderText("YouTube Query")
    searchQuery.OnEnter = function(self)

    end
    searchQuery.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
        draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
        self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
        if (!self:IsEditing() and self:GetValue() == "") then
            draw.SimpleText("Queue Search", "DermaDefault", w/32, h/6, Color(155,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    local saveQueueButton = vgui.Create( "DButton", queueSheet )
    saveQueueButton:SetSize(65, sheetx/45)
    saveQueueButton:SetPos(25 + sheetx/2.75,15)
    saveQueueButton:SetText("Save")
    saveQueueButton.DoClick = function()
        if (util.JSONToTable(hideMusic_derma.instance:GetqueueConstruct()) ~= {} and hideMusic_derma.instance:GetqueueConstruct() ~= "[]") then
            local dermaPlaylistNameRequest = Derma_StringRequest(
            "Playlist Save Request", 
            "Input the name you wish the playlist to be,",
            "",
            function(text) 
                local dermaLocateRequest = Derma_Query(
                    "Would you like to save this queue to the server or your local client?", 
                    "Playlist Save Request", 
                        "Server", function()
                            if (!LocalPlayer():IsAdmin()) then return end

                            net.Start("hdsmp_savePlaylist")
                                net.WriteString(text)
                                net.WriteInt(hideMusic_derma.instance:EntIndex(), 21)
                            net.SendToServer()

                        end, 
                        "Client", function()
                            savePlaylist(hideMusic_derma.instance, LocalPlayer(), {
                                name = text
                            })
                        end),
                        "Cancel", function()
                            return
                        end
                dermaLocateRequest.Paint = playlistSetup_setupPanelPaint
            end,
            function(text) print("Cancelled input") end,
            "Confirm"
            )

            function playlistSetup_setupPanelPaint(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color( 37,37,37, 255 ) ) -- Draw a red box instead of the frame
                draw.RoundedBox( 0, 0, 25, w, 2, Color( 37,37,37, 255 ) ) 
                draw.RoundedBox( 0, 0, h/5, w, h/1.15, Color( 46,46,46, 255 ) ) 
                --draw.RoundedBox(cornerRadius, x, y, width, height, color)
            end
            dermaPlaylistNameRequest.Paint = playlistSetup_setupPanelPaint
        end
    end


    hideMusic_derma.queueScrollPanel = vgui.Create( "DScrollPanel", queueSheet )
    hideMusic_derma.queueScrollPanel:SetPos(0,sheety/9)
    hideMusic_derma.queueScrollPanel:SetSize( sheety*1.8, sheetx/2.35  )
    renderQueueScroll()

    return queueSheet;
end

function renderQueueScroll()
    local l,w = ScrW()/1.6,ScrH()/1.55
    local sheetx, sheety = w*1.4365, l/2.2

    local queueJSON = hideMusic_derma.instance:GetqueueConstruct()
    local queue = util.JSONToTable(queueJSON)

    if (queue ~= nil) then
        hideMusic_derma.queueScrollPanel:Clear()

        for k,v in pairs(queue) do
            local DButton = hideMusic_derma.queueScrollPanel:Add( "DButton" )
            DButton:SetText( "" )
            DButton:Dock( TOP )
            DButton:DockMargin( 0, 0, 0, 5 )
            DButton:SetSize(ScrW()/7.04, ScrH()/38.85)
            DButton.Paint = function (self, w, h ) 
                if DButton:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46,255))
                end
        
                draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))

                draw.SimpleText(k, "Hideyoshi_DermaSmall", w/128, h/4, Color(255,255,255,55), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(v[1], "Hideyoshi_DermaMediumBold", w/26, h/6.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                --draw.SimpleText(string.FormattedTime( SoundDuration(v), "%02i:%02i" ) , "Hideyoshi_DermaSmall", w - w/40, h/8.5, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end
        end
    end
end
hdsmp_renderQueuePanel = renderQueueScroll

function renderSettingsPanel(songSelect_elementSheet)
    local settingMenu = vgui.Create( "DPanel", songSelect_elementSheet )
    settingMenu.Paint = function() end

    local Hideyoshi_InformativeLabel_Option = vgui.Create( "DLabel", settingMenu )
    Hideyoshi_InformativeLabel_Option:SetTextColor(Color(255,255,255,255))
    Hideyoshi_InformativeLabel_Option:SetSize(1500,30)
    Hideyoshi_InformativeLabel_Option:SetFont("DermaLarge")
    Hideyoshi_InformativeLabel_Option:SetPos( 40, 25 )
    Hideyoshi_InformativeLabel_Option:SetText( "Hideyoshi's Music Player Options" )

    local Hideyoshi_InformativeLabel_Option = vgui.Create( "DLabel", settingMenu )
    Hideyoshi_InformativeLabel_Option:SetTextColor(Color(255,255,255,255))
    Hideyoshi_InformativeLabel_Option:SetSize(1500,30)
    Hideyoshi_InformativeLabel_Option:SetPos( 42.5, 50 )
    Hideyoshi_InformativeLabel_Option:SetText( "Use this tab to manually configure Sound Distance & Sound Levels/Volume as well as Global or Local." )
    
    Hideyoshi_GlobalMusicDermaCheckbox = vgui.Create( "DCheckBoxLabel", settingMenu )
    Hideyoshi_GlobalMusicDermaCheckbox:SetPos( 42.5, 90 )
    Hideyoshi_GlobalMusicDermaCheckbox:SetText("Global Music (Senior Event Master+ Only)")
    Hideyoshi_GlobalMusicDermaCheckbox:SetValue( false )
    Hideyoshi_GlobalMusicDermaCheckbox:SetTextColor( Color(255,255,255) )
    Hideyoshi_GlobalMusicDermaCheckbox:SizeToContents()

    VolDermaNumSlider = vgui.Create( "DNumSlider", settingMenu )
    VolDermaNumSlider:SetPos( 42.5, 125 )
    VolDermaNumSlider:SetSize( 700, 15 )
    VolDermaNumSlider:SetText( "Volume of Music (Default 100)" )
    --VolDermaNumSlider:SetDark( true )
    VolDermaNumSlider:SetMin( 0 )				 	
    VolDermaNumSlider:SetMax( 1000 )			
    VolDermaNumSlider:SetDecimals( 0 )		
    VolDermaNumSlider:SetDefaultValue( 100 )		
    VolDermaNumSlider:ResetToDefaultValue()

    DistanceDermaNumSlider = vgui.Create( "DNumSlider", settingMenu )
    DistanceDermaNumSlider:SetPos( 42.5, 165 )
    DistanceDermaNumSlider:SetSize( 700, 15 )			
    DistanceDermaNumSlider:SetText( "Sound Distance (Default 200 - Not applicable for Global)" )
    --DistanceDermaNumSlider:SetDark( true )
    DistanceDermaNumSlider:SetMin( 0 )				 	
    DistanceDermaNumSlider:SetMax( 2500 )				
    DistanceDermaNumSlider:SetDecimals( 0 )	
    DistanceDermaNumSlider:SetDefaultValue( 200 )		
    DistanceDermaNumSlider:ResetToDefaultValue()

    return settingMenu
end

function prepareQuery(query, youtubeConvertSheet, sheety, sheetx) 
    getQuery(query, nil, function(json)
        local queryTable = util.JSONToTable(json)
        if (hideMusic_derma.DScrollPanel) then
            hideMusic_derma.DScrollPanel:Remove()
        end

        hideMusic_derma.DScrollPanel = vgui.Create( "DScrollPanel", youtubeConvertSheet )
        hideMusic_derma.DScrollPanel:SetPos(0,sheety/9)
        hideMusic_derma.DScrollPanel:SetSize( sheety*1.8, sheetx/2.35  )
        

            for k,v in pairs(queryTable) do
                local titleExtr = v.title
                local artiststr = v.artist
                local url = v.url
                local finstr = titleExtr
                if (string.len(finstr) > 40) then
                    finstr = string.Left(finstr, 60) .. "..."
                end

                local DButton = hideMusic_derma.DScrollPanel:Add( "DButton" )
                DButton:SetText( "" )
                DButton:Dock( TOP )
                DButton:DockMargin( 0, 0, 0, 5 )
                DButton:SetSize(ScrW()/7.04, ScrH()/38.85)
                DButton.AssignedURL = url
                DButton.SongName = titleExtr
                DButton.Paint = function (self, w, h ) 
                    if DButton:IsHovered() then
                        draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46,255))
                    end
        
                    draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))

        
                    draw.SimpleText(finstr, "Hideyoshi_DermaMediumBold", w/26, h/6.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText(artiststr, "Hideyoshi_DermaSmall", w - w/40, h/8.5, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
                DButton.DoClick = function(self) 
                    hideMusic_derma.urlSubmit:SetText(url)
                end
                function DButton:OnMousePressed(keyCode)
                    if (keyCode == 108) then
                        processQueueAdition(self.SongName, self.AssignedURL, true, hideMusic_derma)
                    elseif (keyCode == 107) then
                        hideMusic_derma.urlSubmit:SetText(url)
                    end
                end

        end
    end)
end

--[[function processSongRequest(
    entIndex,
    filePath,
    url,
    volume,
    soundDistance,
    isExternal,
    global,
    broadcast,
    broadcastTable
) ]]--

function processSongRequest(netTable)
    
    if ((netTable.filePath or netTable.url) and netTable.instance and netTable.volume and netTable.soundDistance) then

        net.Start("processSongRequest")
            net.WriteInt(netTable.instance, 21)
            net.WriteBool(netTable.isexternalmusic)
            net.WriteBool(netTable.isGlobal)
            net.WriteString(netTable.filePath or netTable.url)
            net.WriteInt(netTable.volume, 11)
            net.WriteInt(netTable.soundDistance, 15)
            --[[net.WriteBool(broadcast)
            if (broadcast) then
                net.WriteTable(broadcastTable)
            end]]--
        net.SendToServer()
    end
end

function urlValid(url) 

    local validFormat = {
        "youtu.be",
        "youtube.com",
        "m.youtube.com"
    }

    for k,v in pairs(validFormat) do
        local strStart, strEnd = string.find( url:lower(), v )
        if (strStart) then
            return true
        end
    end

    return false

end

function sendStateChange(entIndex, state)
    local validStates = {
        "play",
        "pause",
        "stop"
    }
    if table.HasValue(validStates, state) and IsValid(Entity(entIndex)) then
        net.Start("hdsmp_stateChange-sv")
            net.WriteInt(entIndex, 21)
            net.WriteString(state)
        net.SendToServer()
    end
end

function sendTimeOrder(time, ent, _callback)
    if (time ~= nil and type(_callback) == "function" ) then
        net.Start("hdsmp_sendTimeOrder")
            net.WriteInt(time, 32)
            net.WriteInt(ent:EntIndex(), 11)
        net.SendToServer()
        _callback()
    end
end

function executeTimeOrder()
    local time = net.ReadInt(32)
    local ent = Entity(net.ReadInt(11))

    if (IsValid(ent.sw_station) and ent.sw_station:GetState() == 1) then
        ent.sw_station:SetTime(time)
    end
end
net.Receive("hdsmp_executeTimeOrder", executeTimeOrder)

function recieveStateChange()
    local musicPlayer_ent = net.ReadEntity()
    local action = net.ReadString()

    if (IsValid(musicPlayer_ent.sw_station)) then
        --[[local musicbuttonFunctions = {
            play = musicPlayer_ent.sw_station:Play(),
            stop = musicPlayer_ent.sw_station:Stop(),
            pause = musicPlayer_ent.sw_station:Pause()
        }
        print(musicPlayer_ent)]]--

        if (action == "play") then
            musicPlayer_ent.sw_station:Play()
        elseif (action == "stop") then
            musicPlayer_ent.sw_station:Stop()
        elseif (action == "pause") then
            musicPlayer_ent.sw_station:Pause()
        end
    end
end
net.Receive("hdsmp_stateChange-cl", recieveStateChange)

function drawSideBar(frame)
    local frame_w,frame_h = frame:GetSize()

    local DLabel = vgui.Create( "DLabel", frame )
    DLabel:SetPos( frame_w/72, frame_h/23.65 )
    DLabel:SetText( "MAIN" )
    DLabel:SetColor( Color(255,255,255, 155))
    DLabel:SetFont("Hideyoshi_DermaSmall")

    local DermaButton = vgui.Create( "DButton", frame )
    DermaButton.Text = "Song Selection" 
    DermaButton:SetText("")
    DermaButton:SetPos( 0, frame_h/13 )
    DermaButton:SetSize( frame_w/6.05, frame_h/24 )
    DermaButton.selectedMenu = "songselection"
    DermaButton.DoClick = changeMenu
    DermaButton.Paint = paintSideBarButtons

    local DermaButton = vgui.Create( "DButton", frame )
    DermaButton.Text = "Playlist Selection"
    DermaButton:SetText("")
    DermaButton:SetPos( 0, frame_h/8.35 )
    DermaButton:SetSize( frame_w/6.05, frame_h/24 )
    DermaButton.selectedMenu = "playlistselection"
    DermaButton.DoClick = changeMenu
    DermaButton.Paint = paintSideBarButtons

    local DermaButton = vgui.Create( "DButton", frame )
    DermaButton.Text = "Music Player Management"
    DermaButton:SetText("")
    DermaButton:SetPos( 0, frame_h/6.15 )
    DermaButton:SetSize( frame_w/6.05, frame_h/24 )
    DermaButton.selectedMenu = "playerManagement"
    DermaButton.DoClick = changeMenu
    DermaButton.Paint = paintSideBarButtons
end

function paintSideBarButtons(self, w, h)
    if (hideMusic_derma.instance.selectedMenu == self.selectedMenu) then
        draw.RoundedBox(0, 0, 0, w, h, Color(63,63,63))
        draw.RoundedBox(0, 0, 0, w/64, h, Color(177,114,52))

    elseif (self:IsHovered()) then
        draw.RoundedBox(0, 0, 0, w, h, Color(63,63,63))
    end
    draw.SimpleText(self.Text, "Hideyoshi_DermaMedium", w/2, h/4.25, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

function drawPlaylistSelectionMenu()
    if (playlistSelect_elementSheet) then
        playlistSelect_elementSheet:Remove()
    end

    local l,w = ScrW()/1.6,ScrH()/1.55
    local sheetx, sheety = w*1.4365, l/2.2

    playlistSelect_elementSheet = vgui.Create( "DPropertySheet", frameMuse )
    playlistSelect_elementSheet:SetPos(ScrW()/9.65, ScrH()/12.6)
    playlistSelect_elementSheet:SetSize( ScrW()/1.92, ScrH()/1.98 )
    playlistSelect_elementSheet.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
    end

    local localplaylist_sheet = vgui.Create( "DPanel", sheet )
    localplaylist_sheet.Paint = function() end

        local searchQuery = vgui.Create( "DTextEntry", localplaylist_sheet ) -- create the form as a child of frame
        searchQuery:SetPos(15,15)
        searchQuery:SetSize( ScrW()/5.28, ScrH()/48.55  )
        searchQuery:SetPlaceholderText("YouTube Query")
        searchQuery.OnEnter = function(self)

        end
        searchQuery.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
            self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
            if (!self:IsEditing() and self:GetValue() == "") then
                draw.SimpleText("Local Playlist Search", "DermaDefault", w/32, h/6, Color(155,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        local localPlaylistPanel = vgui.Create( "DScrollPanel", localplaylist_sheet )
        localPlaylistPanel:SetPos(0,ScrH()/17.82)
        localPlaylistPanel:SetSize( ScrW()/1.95, ScrH()/2.535  )
        for i=0, 24 do
            insertBlankButtons(localPlaylistPanel, sheety, sheetx)
        end
        hideMusic_derma.localPlaylist = getPlaylist()
        if (localPlaylist ~= false) then
            updatePlaylistList(localPlaylistPanel, hideMusic_derma.localPlaylist, "client", sheety, sheetx)
        end
    
    playlistSelect_elementSheet:AddSheet( "Local Playlists", localplaylist_sheet, "icon16/book.png" )

    local serverplaylist_sheet = vgui.Create( "DPanel", sheet )
    serverplaylist_sheet.Paint = function() end

        local searchQuery = vgui.Create( "DTextEntry", serverplaylist_sheet ) -- create the form as a child of frame
        searchQuery:SetPos(15,15)
        searchQuery:SetSize( ScrW()/5.28, ScrH()/48.55  )
        searchQuery:SetPlaceholderText("YouTube Query")
        searchQuery.OnEnter = function(self)

        end
        searchQuery.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
            draw.RoundedBox(30, 0, 0, w, h, Color(255, 255, 255, 255))
            self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0))
            if (!self:IsEditing() and self:GetValue() == "") then
                draw.SimpleText("Serverside Playlist Search", "DermaDefault", w/32, h/6, Color(155,155,155,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        local serversidePlaylistPanel = vgui.Create( "DScrollPanel", serverplaylist_sheet )
        serversidePlaylistPanel:SetPos(0,ScrH()/17.82)
        serversidePlaylistPanel:SetSize( ScrW()/1.95, ScrH()/2.535  )
        for i=0, 24 do
            insertBlankButtons(serversidePlaylistPanel, sheety, sheetx)
        end
        if (hideMusic_derma.serverplaylistListing ~= nil) then
            updatePlaylistList(serversidePlaylistPanel, hideMusic_derma.serverplaylistListing, "server", sheety, sheetx)
        end

    playlistSelect_elementSheet:AddSheet( "Serverside Playlists", serverplaylist_sheet, "icon16/book_addresses.png" )
end

function insertBlankButtons(panelSel, sheety, sheetx)
    local DButton = panelSel:Add( "DButton" )
    DButton:SetText( "" )
    DButton:Dock( TOP )
    DButton:DockMargin( 0, 0, 0, 5 )
    DButton:SetSize(ScrW()/7.04, ScrH()/38.85)
    DButton.Paint = function (self, w, h ) 
        if DButton:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46,255))
        end

        draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))
    end
end

function updatePlaylistList(panelSel, playlist, process, sheety, sheetx)
    if (!playlist) then return end
    panelSel:Clear()
    for k,v in pairs(playlist) do
        local DButton = panelSel:Add( "DButton" )
        DButton:SetText( "" )
        DButton:Dock( TOP )
        DButton:DockMargin( 0, 0, 0, 5 )
        DButton:SetSize(ScrW()/7.04, ScrH()/38.85)
        DButton.playlistName = k
        DButton.Paint = function (self, w, h ) 
            if DButton:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(46,46,46,255))
            end

            draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))

            draw.SimpleText(k, "Hideyoshi_DermaMediumBold", w/26, h/6.5, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(v.Owner, "Hideyoshi_DermaSmall", w - w/40, h/8.5, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        end
        function DButton:OnMousePressed(keyCode)
            if (keyCode == 108) then
                openMenu_playlist(v.Owner, process, self.playlistName)
            end
        end
    end
end

function deployPlaylist(process, playlistName)
    if (!LocalPlayer():IsAdmin()) then return end
    net.Start("hdsmp_deployPlaylist")
        net.WriteInt(hideMusic_derma.instance:EntIndex(), 21)
        net.WriteString(process)
        if (process == "client") then
            local tableSend = hideMusic_derma.localPlaylist[playlistName]
            tableSend.Owner = nil
            net.WriteTable(tableSend)
        elseif (process == "server") then
            net.WriteString(playlistName)
        end
    net.SendToServer()
end

function openMenu_playlist(owner, process, playlistName)
    local menu = DermaMenu() 
        local option = menu:AddOption( "Deploy", function() 
            deployPlaylist(process, playlistName)
        end )
        option:SetIcon("icon16/add.png")
        local option = menu:AddOption( "Copy Owner's SteamID", function() 
            chat.AddText("Copied playlist Owner's SteamID ( ".. owner .." ) to clipboard")
            SetClipboardText(owner)
        end )
        option:SetIcon("icon16/add.png")
    menu:Open()
end


net.Receive("hdsmp_sendUserPlaylist", function()
    hideMusic_derma.serverplaylistListing = net.ReadTable()
    drawPlaylistSelectionMenu()
    changeMenu(hideMusic_derma)
end)

function changeMenu(self)
    --local hideMusic_derma = self.hideMusic
    --hideMusic_derma.selectedMenu = self.Menu or self.selectedMenu
    hideMusic_derma.instance.selectedMenu = self.selectedMenu
    if (self.selectedMenu == "playlistselection") then

        if (IsValid(songSelect_elementSheet) and songSelect_elementSheet:IsVisible()) then
            songSelect_elementSheet:SetVisible(false)
        end

        if (IsValid(playerManagement_elementSheet) and playerManagement_elementSheet:IsVisible()) then
            playerManagement_elementSheet:SetVisible(false)
        end

        if (IsValid(playlistSelect_elementSheet) and !playlistSelect_elementSheet:IsVisible()) then
            playlistSelect_elementSheet:SetVisible(true)
        end

    elseif (self.selectedMenu == "songselection") then
        if (IsValid(songSelect_elementSheet) and !songSelect_elementSheet:IsVisible()) then
            songSelect_elementSheet:SetVisible(true)
        end

        if (IsValid(playerManagement_elementSheet) and playerManagement_elementSheet:IsVisible()) then
            playerManagement_elementSheet:SetVisible(false)
        end

        if (IsValid(playlistSelect_elementSheet) and playlistSelect_elementSheet:IsVisible()) then
            playlistSelect_elementSheet:SetVisible(false)
        end
    elseif (self.selectedMenu == "playerManagement") then

        if (IsValid(songSelect_elementSheet) and songSelect_elementSheet:IsVisible()) then
            songSelect_elementSheet:SetVisible(false)
        end

        if (IsValid(playlistSelect_elementSheet) and playlistSelect_elementSheet:IsVisible()) then
            playlistSelect_elementSheet:SetVisible(false)
        end

        if (IsValid(playerManagement_elementSheet) and !playerManagement_elementSheet:IsVisible()) then
            playerManagement_elementSheet:SetVisible(true)
        end

    end

end

function drawPlayerManagement()
    local l,w = ScrW()/1.6,ScrH()/1.55
    local sheetx, sheety = w*1.4365, l/2.2

    playerManagement_elementSheet = vgui.Create( "DPropertySheet", frameMuse )
    playerManagement_elementSheet:SetPos(ScrW()/9.65, ScrH()/12.6)
    playerManagement_elementSheet:SetSize( ScrW()/1.92, ScrH()/1.98 )
    playerManagement_elementSheet.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
    end

    local playerManagement_sheet = vgui.Create( "DPanel", sheet )
    playerManagement_sheet.Paint = function() end

    local length_sheet, width_sheet = playerManagement_elementSheet:GetSize()
    local DScrollPanel = vgui.Create( "DScrollPanel", playerManagement_sheet )
    DScrollPanel:SetPos(0,7.5)
    --DScrollPanel:SetSize( sheety*1.8, sheetx/2.35  )
    DScrollPanel:SetSize( ScrW()/1.95, ScrH()/2.18  )
    for k,v in pairs(ents.FindByClass( "sw_hideyoshi_music_player" )) do
        local DPanel = DScrollPanel:Add( "DPanel" )
        DPanel:SetText( "" )
        DPanel:Dock( TOP )
        DPanel:DockMargin( 0, 0, 0, 5 )
        DPanel:SetSize(ScrW()/7.04, ScrH()/12.95)
        DPanel.Paint = function (self, w, h ) 
            draw.RoundedBox(0, 0, h-1, w, 1, Color(39, 39, 39, 255))

            draw.SimpleText("Music Player #"..v:EntIndex(), "Hideyoshi_DermaDefault", 5, h/6, Color(200,200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Spawned by", "Hideyoshi_DermaMediumBold", 5, h/1.9, Color(200,200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(player.GetBySteamID(v:Getent_plyspawner()):Nick(), "Hideyoshi_DermaMedium", 5, h/1.35, Color(200,200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        end

        local dpanel_width, dpanel_length = DPanel:GetSize()
        local DermaCheck_musicPlayerSelect = vgui.Create( "DCheckBoxLabel", DPanel ) 
        DermaCheck_musicPlayerSelect:SetText( "Is Active?" )					
        DermaCheck_musicPlayerSelect:SetPos( ScrW()/2.17, ScrH()/77.7 )		
        if (LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay == v) then
            DermaCheck_musicPlayerSelect:SetChecked(true)
            LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay = DermaCheck_musicPlayerSelect
        end
        --DermaButton:SetSize( 75, 20 )
        DermaCheck_musicPlayerSelect.OnChange = function(self, val)		
            if (val) then
                if (IsValid(LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay))then
                    LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay:SetChecked(false)
                end
                LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay = self
                LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay = v

            else
                LocalPlayer().hdsmp_checkedBox_musicPlayerSideDisplay = nil
                LocalPlayer().hdsmp_selectedMusicPlayer_sideDisplay = nil

            end
        end

        local DermaButton = vgui.Create( "DButton", DPanel ) 
        DermaButton:SetText( "Control" )					
        DermaButton:SetPos( ScrW()/2.17, ScrH()/32.375 )					
        DermaButton:SetSize( ScrW()/25.6, ScrH()/54 )
        DermaButton.DoClick = function()	
            songSelect_elementSheet:Remove()
            playerManagement_elementSheet:Remove()
            playlistSelect_elementSheet:Remove()

            frameMuse:Remove()
            v.hideMusic.instance = v
            drawHideMusic_derma(v)
        end

        local DermaButton = vgui.Create( "DButton", DPanel ) 
        DermaButton:SetText( "Remove" )					
        DermaButton:SetPos( ScrW()/2.17, ScrH()/19.425 )					
        DermaButton:SetSize( ScrW()/25.6, ScrH()/54 )
        DermaButton.DoClick = function()		
            local dermaRemoveConfirm = Derma_Query(
                    "Are you sure you would like to remove this music player?", 
                    "Removal Confirmation", 
                        "Yes", function()
                            return
                            -- i'll code this later
                            -- probably
                        end, 
                        "No", function()
                            return
                        end)
            dermaRemoveConfirm.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color( 37,37,37, 255 ) ) -- Draw a red box instead of the frame
                draw.RoundedBox( 0, 0, 25, w, 2, Color( 37,37,37, 255 ) ) 
                draw.RoundedBox( 0, 0, h/5, w, h/1.15, Color( 46,46,46, 255 ) ) 
            end
        end
    end

    playerManagement_elementSheet:AddSheet( "Music Player Management", playerManagement_sheet, "icon16/application_xp_terminal.png" )

end

function drawHideMusic_derma(self)
    hdsmp_DrawDerma(self.hideMusic)

    net.Start("hdsmp_requestPlaylist")
    net.SendToServer()

    drawPlaylistSelectionMenu()
    changeMenu(self)
end