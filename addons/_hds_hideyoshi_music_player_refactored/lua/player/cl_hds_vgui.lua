local randTable = {}

local hide_dermaFunctions = {}

--[[
    Confirm if the url is indeed a YouTube URL
    @param {string} url

    returns {bool} true if the url is a YouTube URL, false otherwise
]]
function hide_dermaFunctions.validateYouTubeURL(URL)
    if not URL then return false end
    if not string.find(URL, "youtube.com") then return false end
    if not string.find(URL, "v=") then return false end
    return true -- if all checks pass, then it's a YouTube URL
end


--[[
    Find YouTube results from a string query

    @param {string} query
    @param {function} fn
        function to call when results are found; includes the results table as a parameter

    returns {void} void
]]
function hide_dermaFunctions.getYouTubeResults(query, fn)
    local resJsfunction = [[
        const queryList = []
        const raw_queryList = document.querySelectorAll(".ytd-video-renderer.style-scope a[title]") 
        raw_queryList.forEach(function(val, index) { 
            queryList.push([val.title, val.href])
        })
        hideMusicPlayer.passQueryList(queryList)
    ]] -- scrape the results from the YouTube search results page

    local frame = vgui.Create( "DFrame" )
    frame:SetSize( 0, 0 ) -- hide the frame
    frame.paint = function() return end -- cheeky way to stop the frame from drawing

    -- Define the Javascript function in the DHTML element
    local DHTML = vgui.Create( "DHTML", frame )
    DHTML:Dock( FILL )
    DHTML:OpenURL( "https://www.youtube.com/results?search_query="..query ) -- open the YouTube search results page
    DHTML:AddFunction( "hideMusicPlayer", "passQueryList", function( queryList )
        fn(queryList) -- pass the queryList to the callback function
        frame:Remove() -- remove the frame after the function is called
    end)

    DHTML.OnDocumentReady = function() -- when the document is ready, run the Javascript function
        DHTML:RunJavascript(resJsfunction)
    end
end

--[[
    Creates a data submission table for the server to use

    @param {string} song name
    @param {string} song path
    @param {string} song type
    @param {string} sound flags

    returns {table} data table
]]
function hide_dermaFunctions.createDataTable(sng_name, sng_path, sng_type, snd_flag, ent)
    if (sng_type == "youtube") then -- if the song is a YouTube video
        if (!hide_dermaFunctions.validateYouTubeURL(sng_path)) then return end -- if the url is not a YouTube URL, then return
    end

    return {
        sng_name,
        sng_path,
        sng_type,
        snd_flag,
        ent
    }
end

--[[
    Submits the queue update to the server

    @param {table} data
        - data[1] = song name
        - data[2] = song path (Url if external)
        - data[3] = song type (youtube, url or file)
        - data[4] = sound flags

    returns {void} void
]]
function hide_dermaFunctions.submitQueueRequest(data)
    --verify the data sent is valid
    if (!data[1] or !data[2] or !data[3] or !IsValid(data[5])) then return end
    if (data[3] == "youtube") then -- if the song is a YouTube video
        if (!hide_dermaFunctions.validateYouTubeURL(data[2])) then return end -- if the url is not a YouTube URL, then return
    end

    data[4] = LocalPlayer().hideMusic_sndFlags -- add the sound flags to the data table
    -- These sound flags are defined in the hidehelper/player/cl_vgui.lua file and are tied directly to the user

    net.Start("hds_owner-updateQueue")
        net.WriteTable(data) 
    net.SendToServer()

    notification.AddLegacy("Queue Update sent to the server!", NOTIFY_GENERIC, 2) -- notify the user that the song request was sent to the server
    return
end

--[[
    Submits the song to the server

    @param {table} data
        - data[1] = song name
        - data[2] = song path (Url if external)
        - data[3] = song type (youtube, url or file)
        - data[4] = sound flags

    returns {void} void
]]
function hide_dermaFunctions.submitSongRequest(data)
    --verify the data sent is valid
    if (!data[1] or !data[2] or !data[3] or !IsValid(data[5])) then return end
    if (data[3] == "youtube") then -- if the song is a YouTube video
        if (!hide_dermaFunctions.validateYouTubeURL(data[2])) then return end -- if the url is not a YouTube URL, then return
    end

    data[4] = LocalPlayer().hideMusic_sndFlags -- add the sound flags to the data table
    -- These sound flags are defined in the hidehelper/player/cl_vgui.lua file and are tied directly to the user

    net.Start("hideMusic_submitSongRequest")
        net.WriteTable(data) 
    net.SendToServer()

    notification.AddLegacy("Song request sent to the server!", NOTIFY_GENERIC, 2) -- notify the user that the song request was sent to the server
    return
end

--[[
Hideyoshi Music Player Frame Notes,
    (To scale with 1920*1080 Resolution) 
    
    - DPropertySheet Container is
        width: 768px
        height: 935px
        
    - Sidebar Container is
        width: 192px
        height: 935px
        
]]--

--[[
    Draw's the panel

    @param {entity} player - The player entity

    return {void} void
]]--Draws the panel
function drawpanel(player)
    local frameMuse = vgui.Create("DFrame")
    frameMuse:SetTitle("")
    frameMuse:SetSize(ScrW() / 1.75, ScrH() / 1.75)
    frameMuse:Center()
    frameMuse:MakePopup()

    frameMuse.Paint = function(self, w, h) -- Override the paint function
        -- Header Section
        draw.RoundedBox(0, 0, 0, w, h, Color(46, 46, 46, 255)) -- Recreate entire frame
        draw.RoundedBox(0, 0, 25, w, 2, Color(36, 36, 36, 255)) -- Top Bar (Title Bar) Line
        draw.SimpleText("Hideyoshi's Music Player Refactored Management", "HideMusic_DermaSmall", 480 * (ScrW() / 1920), 5 * (ScrH() / 1080), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        -- Body Section
        draw.RoundedBox(0, 192 * (ScrW() / 1920), 25 * (ScrH() / 1080), w / 1.21, h - (100 * (ScrH() / 1080)), Color(36, 36, 36, 255)) -- DPropertySheet Container
        draw.RoundedBox(0, 192 * (ScrW() / 1920), 27 * (ScrH() / 1080), w / 1.21, h - (545 * (ScrH() / 1080)), Color(46, 46, 46, 255)) -- Music Player Info Container
        draw.RoundedBox(0, 192 * (ScrW() / 1920), 25, 2, h - (100 * (ScrH() / 1080)), Color(36, 36, 36, 255)) -- Sidebar Seperation Line 
        
        draw.RoundedBox(0, 0, 540, w, 2, Color(36, 36, 36, 255)) -- Top Bar (Title Bar) Line

        draw.RoundedBox(0, 0, 542 * (ScrH() / 1080), w , h - (540 * (ScrH() / 1080)), Color(50, 50, 50, 255)) -- DPropertySheet Container

    end

    --draw.RoundedBox( 0, 0, h-h/8, w, h/8, Color( 33,33,33, 255 ) )
    -- Sidepanel button container
    local sidepanel_parent = vgui.Create("DPanel", frameMuse)
    sidepanel_parent:SetPos(0, 50 * (ScrH() / 1080))
    sidepanel_parent:SetSize(192 * (ScrW() / 1920), 200) -- (TODO: 200 should be fine for every machine right?) 
    sidepanel_parent.Paint = nil -- do not paint the ugly white background
    sidepanel_parent.curIndex = 1

    --[[
        Song Selection Center Panel
    ]]--
    local sheet = vgui.Create("DPropertySheet", frameMuse) 
    sheet:SetSize((ScrW() / 1.75) / 1.21, (ScrH() / 2) - (100 * (ScrH() / 1080))) -- same as the container size
    sheet:SetPos(192 * (ScrW() / 1920), 102 * (ScrH() / 1080)) -- same as the container position
    sheet.Paint = nil
    sheet.ParentPanel = frameMuse -- TODO: This is a spaghetti way to get the parent frame, but it works for now.
 
    -- stops the ugly white background from being drawn
    local function paint_invisButton(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(100, 0, 0, w, h, Color(229, 126, 29, 255))

            return
        end

        draw.RoundedBox(100, 0, 0, w, h, Color(59, 59, 59, 255))
    end

    --[[
        Creates a button for the sidepanel dynamically.

        @param {string} name
        @param {integer} index

        returns {panel} button
    ]]
    local function generateSidePanelbut(name, index) -- Generate a sidepanel button
        -- make my life easier with standard buttons
        local spanel_button = vgui.Create("DButton", sidepanel_parent)
        spanel_button:SetText(name)
        spanel_button:SetHeight(30 * (ScrH() / 1080))
        spanel_button:SetColor(Color(255, 255, 255, 255))
        spanel_button:SetFont("HideMusic_DermaSmall")
        spanel_button:Dock(TOP)
        spanel_button:DockMargin(0, 2.5, 0, 0)

        spanel_button.DoClick = function()
            -- Change the current menu index
            sidepanel_parent.curIndex = index
            hook.Run("hdsmp_MenuChange", index, sheet) -- request the center panel to change, (passes the property sheet and the index)
        end

        spanel_button.Paint = function(self, w, h)
            if sidepanel_parent.curIndex == index then
                -- draw cool shading thing if the curIndex is equal to the button's assigned index
                draw.RoundedBox(0, 0, 0, w, h, Color(61, 61, 61, 255))
                draw.RoundedBox(0, 0, 0, 3 * (ScrW() / 1920), h, Color(238, 219, 159, 255)) -- haha it's shokuhou misaki's hair color lol
            end
        end

        return spanel_button
    end

    --[[
        Button Generation
    ]]
    --
    generateSidePanelbut("Song Selection", 1)
    --generateSidePanelbut("Playlist Selection", 2)
    generateSidePanelbut("Sound Configuration", 3)
    --generateSidePanelbut("Player Management", 4)

    --[[
        Song Control Panel
    ]]--

    local loopIcon_table = {
        [true] = "hideyoshi_vgui/derma_repeatActive.png",
        [false] = "hideyoshi_vgui/derma_repeatInactive.png"
    }
    local loopIcon = vgui.Create( "DImageButton", frameMuse )
    loopIcon:SetPos( 15, 565 )	
    loopIcon:SetSize( 32, 32 )
    loopIcon:SetImage( loopIcon_table[player:Gethds_Loop()] )
    loopIcon.DoClick = function()
        if (!LocalPlayer():IsAdmin()) then return end
        loopIcon:SetImage( loopIcon_table[!player:Gethds_Loop()] )
        net.Start("hds_setloop")
            net.WriteBool(!player:Gethds_Loop())
            net.WriteEntity(player)
        net.SendToServer()
    end

    local controlIcon_table = {
        [0] = "hideyoshi_vgui/vgui_play.png",
        [1] = "hideyoshi_vgui/vgui_pause.png",
        [2] = "hideyoshi_vgui/vgui_play.png",
        [3] = "hideyoshi_vgui/vgui_play.png"
    }
    local controlIcon = vgui.Create( "DImageButton", frameMuse )
    controlIcon:SetPos( 65 * (1920 / ScrW()), 555 * (1080 / ScrH()) )	
    controlIcon:SetSize( 48 * (1920 / ScrW()), 48 * (1080 / ScrH()) )
    controlIcon:SetImage( controlIcon_table[IsValid(player.station) and player.station:GetState() or 0] )
    controlIcon.DoClick = function()
        if (controlIcon_table[IsValid(player.station) and player.station:GetState() or 0] == "hideyoshi_vgui/vgui_play.png") then
            hds_sendStateChange(player, "play") -- send the state change to the server
            controlIcon:SetImage( controlIcon_table[1] ) -- this is based on the assumption that the state change happened successfully
        else
            hds_sendStateChange(player, "pause") -- same as above
            controlIcon:SetImage( controlIcon_table[0] )
        end
    end


    local skipIcon = vgui.Create( "DImageButton", frameMuse )
    skipIcon:SetPos( 132.5 * (1920 / ScrW()), 564 * (1080 / ScrH()) )	
    skipIcon:SetSize( 32 * (1920 / ScrW()), 32 * (1080 / ScrH()) )
    skipIcon:SetImage( "hideyoshi_vgui/derma_forward.png" )
    skipIcon.DoClick = function()
        hds_sendStateChange(player, "stop")
    end

    --[[
        Music Time Control bar thing
    ]]

    local timeLabel = vgui.Create( "DPanel", frameMuse )
    timeLabel:SetPos( 235 * (1920 / ScrW()), 570 * (1080 / ScrH()) ) -- Set the position of the panel
    timeLabel:SetSize( 800 * (1920 / ScrW()), 27 * (1080 / ScrH()) ) -- Set the size of the panel
    timeLabel.Paint = function( self, w, h )

        -- Currrent Song Time
        draw.SimpleText(IsValid(player.station) and string.FormattedTime(player.station:GetTime(), "%02i:%02i") or "00:00",
            "DermaDefault", 0, 1 * (1080 / ScrH()), Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        -- Total Time / Length
        draw.SimpleText(IsValid(player.station) and string.FormattedTime(player.station:GetLength(), "%02i:%02i") or "00:00", 
            "DermaDefault", w, 1 * (1080 / ScrH()), Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        -- Song Name
        draw.SimpleText(IsValid(player.station) and player.HideMusic_settings.name or "", "DermaDefault", w/2, 14 * (1080 / ScrH()), Color(200,200,200,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    end

    local seekingBar = vgui.Create( "DPanel", frameMuse )
    seekingBar:SetPos( 285 * (1920 / ScrW()), 575 * (1080 / ScrH()) ) -- Set the position of the panel
    seekingBar:SetSize( 700 * (1920 / ScrW()), 10 * (1080 / ScrH()) ) -- Set the size of the panel
    seekingBar.processingShift = false; -- cosmetic variable to prevent the bar from shifting while processing
    seekingBar.Paint = function( self, w, h )
        -- Background Bar
        draw.RoundedBox( 90, 0, 0, w, h/1.75, Color( 115, 115, 115, 255 ) )

        if (IsValid(player.station)) then
            self.song_width = !self.processingShift and player.station:GetTime()*(w/player.station:GetLength()) or self.song_width

            draw.RoundedBox( 90, 0, 0, self.song_width * (1920 / ScrW()), h/1.75, 
                self:IsHovered() and Color( 30, 215, 96, 255 ) or Color( 200, 200, 200, 255 ) 
            )

            if ( self:IsHovered() ) then
                draw.RoundedBox( 90, self.song_width-5 * (1920 / ScrW()), 0, 7 * (1920 / ScrW()), h/1.75, Color( 255, 255, 255, 255 ) )
            end
        end
    end
    function seekingBar:OnMouseReleased(keyCode)
        if (!LocalPlayer():IsAdmin()) then return end

        if (self:IsHovered() and keyCode == MOUSE_LEFT and IsValid(player.station)) then -- idk, just in case
            local x, y = self:LocalCursorPos()
            local time = x/(self:GetWide()/player.station:GetLength())
            self.song_width = time*(self:GetWide()/player.station:GetLength())

            net.Start("hds_settime")
                net.WriteInt(time, 16) -- god forbid if you have a song longer than 16383 seconds
                net.WriteEntity(player)
            net.SendToServer()

            self.processingShift = true;
            timer.Simple(1, function() -- god save you if it takes longer than 2 seconds to process the time shift
                self.processingShift = false;
            end)

            --player.station:SetTime(self:GetCursorPos()*(player.station:GetLength()/self:GetWide()))
        end
    end

    --[[
        adds buttons to the song selection panel

        @param {panel} panel
        @param {string} name
        @param {integer} index

        return {void} void
    ]] 
    local function addButtons(panel, name, index, traits, rghtfunction, visual)
        local DPanel = panel:Add("DPanel")
        DPanel:Dock(TOP)
        --DPanel:DockMargin(0, 0, 0, 5)
        DPanel:SetHeight(27.5 * (1080 / ScrH()))
        DPanel:SetCursor("hand")

        local function childrenHover(self) -- hover function for the children
            if (self.child1 == nil or self.child2 == nil) then return end -- if the children are nil, return
            if (self.child1:IsHovered() or self.child2:IsHovered()) then -- if the children are hovered, return
                return true;
            end
            return false; -- if the children are not hovered, return false
        end

        DPanel.Paint = function(self, w, h)
            if self:IsHovered() or childrenHover(self) then -- TODO: clean this up ; it is ugly
                draw.RoundedBox(0, 0, 0, w, h, Color(46, 46, 46, 255))
            end

            draw.RoundedBox(0, 0, h - 1, w, 1, Color(49, 49, 49, 255))
            draw.SimpleText(index or "", "HideMusic_DermaSmall", 5 * (1920 / ScrW()), h / 3, Color(115, 115, 115))
            draw.SimpleText(name or "", "HideMusic_DermaMediumBold", 35 * (1920 / ScrW()), h / 5, color_white)
        end
        DPanel.traits = traits -- the song's traits to be referenced when playing the song
        function DPanel:OnKeyCodeReleased(keyCode)
            if (self:IsHovered() && keyCode == MOUSE_RIGHT) then
                rghtfunction(DPanel, traits)
            end
        end

        if (visual) then return end -- if the song is not playable, don't add a button
        -- TODO: This is a wasteful way to do this, but it'll do for now.

        local dpanel_width, dpanel_height = DPanel:GetSize()
        local queueButton = vgui.Create("DButton", DPanel)
        DPanel.child1 = queueButton -- assign the button to the panel so it can be referenced later
        queueButton:SetText("Queue Song")
        queueButton:SetSize(100 * (1920 / ScrW()), dpanel_height - 7.5)
        queueButton:SetPos((ScrW() / 1.75) / 1.45, (10 / 2) * (1080 / ScrH()))
        queueButton:SetColor(Color(255, 255, 255, 255))
        queueButton:SetFont("HideMusic_DermaSmall")
        queueButton.Paint = paint_invisButton
        queueButton.DoClick = function(self)
            hide_dermaFunctions.submitQueueRequest(traits) -- submit the song request to the server
        end

        local playButton = vgui.Create("DButton", DPanel)
        DPanel.child2 = playButton -- assign the button to the panel so it can be referenced later
        playButton:SetText("▶")
        playButton:SetSize(20 * (1920 / ScrW()), dpanel_height - 7.5)
        playButton:SetPos((ScrW() / 1.75) / 1.5, (10 / 2) * (1080 / ScrH()))
        playButton:SetColor(Color(255, 255, 255, 255))
        playButton:SetFont("DebugFixed")
        playButton.Paint = paint_invisButton
        playButton.DoClick = function(self)
            hide_dermaFunctions.submitSongRequest(traits) -- submit the song request to the server
        end
    end

    --[[
        adds the song selection panels to the center panel

        @param {panel} sheet -- the property sheet
        IMPORTANT: Passes the parent panel to the function. This is necessary because the parent panel is not accessible in the function.

        return {void} void
    ]]
    function drawSelectionTabs(sheet)
        local localSelect = vgui.Create("DPanel", sheet)
        localSelect.Paint = nil

        local localSelectPanel = vgui.Create("DScrollPanel", localSelect)
        localSelectPanel:Dock(FILL)

        local hideyoshi_mp3name = file.Find("sound/*.mp3", "GAME")
        for k, v in pairs(hideyoshi_mp3name) do
            addButtons(localSelectPanel, string.Replace(v, ".mp3", ""), k, hide_dermaFunctions.createDataTable(
                string.Replace(v, ".mp3", ""),
                "sound/"..v,
                "file",
                LocalPlayer().hideMusic_sndFlags,
                player -- the player variable is the entity of the player
            )) -- add the song to the panel and creates a data table for it,
        end

        sheet:AddSheet("Local Music Player", localSelect, "icon16/music.png")

        --[[
            YouTube Music Player Search Panel (TODO: make it so it can search for a playlist)
        ]]

        local extSelection = vgui.Create("DPanel", sheet)
        extSelection.Paint = nil

        local extSelectPanel = vgui.Create("DScrollPanel", extSelection) -- create a scroll panel for the search results
        extSelectPanel:Dock(FILL)
        extSelectPanel:DockMargin(0, 25, 0, 0)

        local extInput = vgui.Create("DTextEntry", extSelection) -- create the form as a child of frame
        extInput:SetWidth(300 * (1920 / ScrW())) -- TODO: Make it so it can be resized dynamically
        extInput.Paint = function(self, w, h) -- override the paint function
            draw.RoundedBox(90, 0, 0, w, h, color_white) -- draw a rounded box override the default background
            self:DrawTextEntryText(Color(0, 0, 0), Color(30, 130, 255), Color(0, 0, 0)) -- draw the text entry text

            if not self:IsEditing() and self:GetValue() == "" then -- if the textentry is not being edited and it's empty, draw the placeholder text
                draw.SimpleText("YouTube or Direct Dropbox URL", "DermaDefault", w / 32, h / 6, Color(155, 155, 155, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end
        extInput.OnEnter = function( self ) -- when the user presses enter, run this function
            if (string.find(self:GetValue(), "http")) then return end -- if the user entered a URL, don't search

            extSelectPanel:Clear() 
            addButtons(extSelectPanel, "Loading results...", nil, nil, nil, true) -- add a loading message to the scroll panel TODO: make this look better

            hide_dermaFunctions.getYouTubeResults(self:GetValue(), function(queryList) -- get the results of the query
                if (!IsValid(extSelectPanel)) then return end -- if the scroll panel is not valid, return. Inpaitent people can avoid errors.
                extSelectPanel:Clear() -- remove the loading message
                for k,v in pairs(queryList) do 

                    local simpResult = (string.Left(v[1], 85) .. (string.len(v[1]) > 85 and "..." or "") ) -- get the first 50 characters of the result
                    addButtons(extSelectPanel, simpResult, k, hide_dermaFunctions.createDataTable(
                        simpResult,
                        v[2], -- the url of the result;
                        "youtube",
                        LocalPlayer().hideMusic_sndFlags,
                        player -- the player variable is the entity of the player
                    )) -- add the results to the panel

                end
            end)
        end

        local extSubmit = vgui.Create("DButton", extSelection) -- play button for youtube music player
        extSubmit:SetText("▶ Play")
        extSubmit:SetSize(50 * (1920 / ScrW()), 21 * (1080 / ScrH()))
        extSubmit:SetPos(305 * (1920 / ScrW()), 0)
        extSubmit:SetColor(Color(255, 255, 255, 255))
        extSubmit:SetFont("HideMusic_DermaSmall")
        extSubmit.Paint = paint_invisButton -- override the paint function TODO: Less shitty way to do this

        sheet:AddSheet("External Music Player", extSelection, "icon16/html.png")

    end
    
    --[[
        adds the player settings panel to the center panel

        @param {panel} sheet -- the property sheet
        IMPORTANT: Passes the parent panel to the function. This is necessary because the parent panel is not accessible in the function.

        return {void} void
    ]]
    function drawSettingsPanel(sheet)
        local soundConfig = vgui.Create("DPanel", sheet)
        soundConfig.Paint = function(self, w, h)
            --draw.SimpleText(text, font="DermaDefault", x=0, y=0, color=Color(255,255,255,255), xAlign=TEXT_ALIGN_LEFT, yAlign=TEXT_ALIGN_TOP)

            -- Distance Controls Instructions
            draw.SimpleText("Distance Controls", "HideMusic_arial@18px", 515 * (1920 / ScrW()), 0 * (1080 / ScrH()), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Distance slider is equal to map distance in all X, Y, and Z directions.", "HideMusic_arial@15px_thin", 515, 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            -- Global Controls Instructions
            draw.SimpleText("Global Controls", "HideMusic_arial@18px", 515 * (1920 / ScrW()), 65 * (1080 / ScrH()), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Set so any player can hear regardless of location. (May be restricted)", "HideMusic_arial@15px_thin", 515, 80, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            -- Volume Controls Instructions
            draw.SimpleText("Volume Controls", "HideMusic_arial@18px", 515 * (1920 / ScrW()), 130 * (1080 / ScrH()), Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Control the transmitting volume of the song.", "HideMusic_arial@15px_thin", 515, 145, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        end

        --[[
            Distance Controls
        ]]--
        local distanceSlider = vgui.Create("DNumSlider", soundConfig)
        distanceSlider:SetPos( 517.5 * (1920 / ScrW()), 32.5 * (1080 / ScrH()) )
        distanceSlider:SetSize( 380 * (1920 / ScrW()), 25 * (1080 / ScrH()) )
        distanceSlider:SetText( "Distance (Map Scale)" )
        distanceSlider:SetMin( 0 ) -- set the minimum zoom value
        distanceSlider:SetMax( 3000 ) -- you definitely don't need to go past this.
        distanceSlider:SetDecimals( 0 )
        distanceSlider:SetValue( LocalPlayer().hideMusic_sndFlags["music_3d_distance"] )
        function distanceSlider:OnValueChanged(val)
            LocalPlayer().hideMusic_sndFlags["music_3d_distance"] = val
        end

        --[[
            Global Music Controls
        ]]
        local DermaCheckbox = vgui.Create( "DCheckBoxLabel", soundConfig )
        DermaCheckbox:SetPos( 517.5 * (1920 / ScrW()), 97.5 * (1080 / ScrH()) )	
        DermaCheckbox:SetText("Global Music")	
        DermaCheckbox:SetValue( !LocalPlayer().hideMusic_sndFlags["music_3d"] )	
        DermaCheckbox:SizeToContents()
        function DermaCheckbox:OnChange( bVal )
            LocalPlayer().hideMusic_sndFlags["music_3d"] = !bVal -- set the global music flag to the opposite of the checkbox value
            if (bVal) then -- this looks yucky
                distanceSlider:SetMax(0) 
                distanceSlider:SetValue(0)
            else
                distanceSlider:SetMax(3000)
            end
        end

        --[[
            Volume Controls
        ]]--
        local volumeSlider = vgui.Create("DNumSlider", soundConfig)
        volumeSlider:SetPos( 517.5 * (1920 / ScrW()), 162.5 * (1080 / ScrH()) )
        volumeSlider:SetSize( 380 * (1920 / ScrW()), 25 * (1080 / ScrH()) )
        volumeSlider:SetText( "Volume" )
        volumeSlider:SetMin( 0 ) -- set the minimum volume value
        volumeSlider:SetMax( 100 ) -- you definitely DEFINITELY don't need to go past this.
        volumeSlider:SetDecimals( 0 )
        volumeSlider:SetValue( LocalPlayer().hideMusic_sndFlags["music_volume"] * 100 )
        function volumeSlider:OnValueChanged(val)
            LocalPlayer().hideMusic_sndFlags["music_volume"] = val / 100 -- set the volume to the slider value
            -- divide by 100 because the slider is 0-100, but the volume is 0-1 (lets not defean the user)
        end

        --[[
            Distance Map Functions 
        ]]--
        hook.Add( "PostDrawTranslucentRenderables", "hideMusic_distanceVisual", function() -- draw the distance value on the map and world
            if (IsValid(soundConfig)) then -- if the distance config is visible, draw a sphere at the distance value
                render.SetColorMaterial()
                local pos = player:GetPos() -- get the music player's position
                render.DrawSphere( pos, LocalPlayer().hideMusic_sndFlags["music_3d_distance"], 30, 30, Color( 0, 175, 175, 100 ) ) -- draw a sphere at the music player's position
            else 
                hook.Remove("PostDrawTranslucentRenderables", "hideMusic_distanceVisual") -- if the distance config is not visible, remove the hook
            end
        end )

        local zoomValue = LocalPlayer():GetPos().z + 1000 -- the zoom value of the distance map
        local mapConatiner = vgui.Create("DPanel", soundConfig)
        mapConatiner:SetSize(500 * (1920 / ScrW()), 380 * (1080 / ScrH()))
        function mapConatiner:Paint(w, h)

            local x, y = self:LocalToScreen(self:GetX(), self:GetY()) -- get the position of the panel on the screen
            --local x, y = sheet.ParentPanel:GetPos() -- TODO: this is a spaghetti way to get the parent panel. Find a better way to do this.

            local preOrigin = player:GetPos() -- get the position of the player (returns vector)
            preOrigin.z = zoomValue -- set the z value of the player to the zoom value

            local old = DisableClipping( true ) -- Avoid issues introduced by the natural clipping of Panel rendering
            render.RenderView( {
                origin = preOrigin, -- vector
                angles = Angle( 90, 0, 0 ),
                x = x, y = y,
                w = w, h = h
            } )
            DisableClipping( old )
        end 

        local zoomSlider = vgui.Create( "DNumSlider", soundConfig )
        zoomSlider:SetPos( 15 * (1920 / ScrW()), 382.5 * (1080 / ScrH()) )
        zoomSlider:SetSize( 500 * (1920 / ScrW()), 25 * (1080 / ScrH()) )
        zoomSlider:SetText( "Zoom (Z Vector)" )
        zoomSlider:SetMin( -30000 ) -- set the minimum zoom value
        zoomSlider:SetMax( 30000 ) -- you definitely don't need to go past this.
        zoomSlider:SetDecimals( 0 )
        zoomSlider:SetValue( zoomValue or 0 )
        function zoomSlider:OnValueChanged(val)
            zoomValue = val -- set the zoom value to the slider value
        end


        sheet:AddSheet("Sound Settings", soundConfig, "icon16/sound.png")

    end

    drawSelectionTabs(sheet)
    -- Trigger the menu change event. First time so something loads.
        -- IMPORTANT: Passes the parent panel to the function. This is necessary because the parent panel is not accessible in the function.


    --[[ i dont know why but this is the only way to make the sheet work.
    -- dont ask me why because i dont know.
    --]]
end




--[[
    This hook is called when the player presses a sidebutton.
    It is used to hide/show the derma elements when the player is in the menu.

    @param {index} The index of the sidebutton that was pressed.
    @param {panel} The parent panel container.

    returns {void} void
]]
hook.Add("hdsmp_MenuChange", "hdsmp_renderPanel", function(index, prtpnl)
    local drawingOrder = {
        drawSelectionTabs,
        nil,
        drawSettingsPanel
    } -- the order in which the panels are drawn

    local itmIndx = #prtpnl:GetItems() -- store the number of items in the panel for later use

    drawingOrder[index](prtpnl) -- draws the panel based on the index of the sidebutton that was pressed
    -- IMPORTANT: Passes the parent panel to the function. This is necessary because the parent panel is not accessible in the function.

    for i=1, itmIndx do -- cycle through all the panels in the property container
        prtpnl:CloseTab(prtpnl:GetItems()[1].Tab, true) -- close the specified tab while removing the panel from the client
    end
    prtpnl:SetActiveTab(prtpnl:GetItems()[1].Tab)

    -- FIXME: There has to be a better way to do this. I'm not sure how to clear the panels without causing an error.
end)