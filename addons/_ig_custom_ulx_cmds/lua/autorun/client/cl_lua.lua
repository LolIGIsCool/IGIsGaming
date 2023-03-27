
----------------------------------------DEFCON----------------------------------------
globaldefconn = 5
vanillaignewdefcon = 21

local displayDEFCON = 0; // 0 - nothing, 1 - fade in, 2 - fade out
local DEFCONcolors = {Color(202, 66, 75, 255), Color(25, 255, 125, 255), Color(255, 140, 69, 255), Color(255, 231, 69, 255)};
local dc;

net.Receive("DefconSound", function()
    local value = net.ReadUInt(16)

    dc = string.Split(value,"")

    surface.PlaySound("vanilla/defcon/" .. string.lower(string.Replace(vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])]," ","")) .. ".ogg")

	displayDEFCON = 1;

    vanillaignewdefcon = value
end)

local counter = 0;
local lerpNum = 0;
hook.Add("HUDPaint", "VanillaDEFCONHUD", function()
	if displayDEFCON == 0 then return end

	if displayDEFCON == 1 then
		lerpNum = lerpNum + 0.008;
		counter = counter + 1;
	end

	if counter >= 250 then displayDEFCON = 2 end

	if displayDEFCON == 2 then
		lerpNum = lerpNum - 0.008;
	end

	if lerpNum <= 0 then
		displayDEFCON = 0;
		counter = 0;
	end

	local defOpacity = Lerp(lerpNum,0,255);
	local panelOpacity = Lerp(lerpNum,0,80);

	local newTextCol = ColorAlpha(DEFCONcolors[tonumber(dc[1])], defOpacity);
	local newPanelCol = ColorAlpha(Color(0,0,0), panelOpacity);

	surface.SetFont("vanilla_font_info");
	local textWidth, textHeight = surface.GetTextSize(string.upper(vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])]) .. " NOW IN EFFECT");

	_G.vanillaBlurPanel(ScrW() / 2 - (textWidth / 2) - ScrW() * 0.01,ScrH() * 0.09, textWidth + ScrW() * 0.02, textHeight + ScrH() * 0.02, newPanelCol);

	draw.SimpleText(string.upper(vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])]) .. " NOW IN EFFECT", "vanilla_font_info", ScrW() / 2,ScrH() * 0.1, newTextCol,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP);
end)

----------------------------------------ORDERS----------------------------------------
-- code is pretty scruffed ayy lmao
local order_message = ""
local display_orders = 0
local runtime = RealTime()
local Text = ""
local Display_Text = ""
local row_1 = ""
local row_2 = ""
local row_3 = ""
local row_4 = ""
local row_5 = ""
local row_6 = ""
local row_7 = ""
local row_8 = ""
local title = ""
globaligshowingorders = false

local display_mat = Material("transmission/orders_displayIMP.png")

surface.CreateFont( "Display_Text", {
	font = "anakinmono", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = math.floor(ScrH()/77),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local function func_time_orders()
	if display_orders == 1 then
		if RealTime() > runtime then
			if #Text < #order_message then
				Text = Text .. order_message[#Text + 1]

				if #Text <= 38 then
					row_1 = row_1 .. Text[#Text]
				elseif #Text <= 76 then
					row_2 = row_2 .. Text[#Text]
				elseif #Text <= 114 then
					row_3 = row_3 .. Text[#Text]
				elseif #Text <= 152 then
					row_4 = row_4 .. Text[#Text]
				elseif #Text <= 190 then
					row_5 = row_5 .. Text[#Text]
				elseif #Text <= 228 then
					row_6 = row_6 .. Text[#Text]
				elseif #Text <= 266 then
					row_7 = row_7 .. Text[#Text]
				elseif #Text <= 304 then
					row_8 = row_8 .. Text[#Text]
				else
					return
				end

				surface.PlaySound("transmission/beep.wav")
			end

			runtime = RealTime() + 0.05
		end
    end
end

local function func_display_orders()
	if display_orders == 1 then
		/*
		surface.SetDrawColor( 255, 255, 255, math.random(185,245) )
		surface.SetMaterial( display_mat )
		surface.DrawTexturedRect( ScrW() - ScrW()/3.5, ScrH()/24 * -1, ScrW()/3.4, ScrH()/3.75 )*/

		surface.SetFont( "Display_Text" );

		_G.vanillaBlurPanel(ScrW() * 0.38, ScrH() * 0.01, ScrW() * 0.22, ScrH() * 0.03, Color(0, 0, 0, 80));
		_G.vanillaBlurPanel(ScrW() * 0.38, ScrH() * 0.05, ScrW() * 0.22, ScrH() * 0.15, Color(0, 0, 0, 80));

		local x = ScrW() * 0.4;

		local dd = string.Split(vanillaignewdefcon,"");

		surface.SetTextColor( DEFCONcolors[tonumber(dd[1])] )
		surface.SetTextPos( x, ScrH() * 0.02)
		surface.DrawText( title )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 0.7)
		surface.DrawText( row_1 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 1.2)
		surface.DrawText( row_2 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 1.7)
		surface.DrawText( row_3 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 2.2)
		surface.DrawText( row_4 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 2.7)
		surface.DrawText( row_5 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 3.2)
		surface.DrawText( row_6 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 3.7)
		surface.DrawText( row_7 )
		surface.SetTextPos( x, ScrH()/24 + ScrW()/60 * 4.2)
		surface.DrawText( row_8 )

    end
end

local function func_display_timer()
	timer.Create( "OfficerSound", 1, 1, function()
		surface.PlaySound("transmission/officer.wav")
	end)
	timer.Create( "CloseSound", string.len(order_message) * 0.06 + 9, 1, function()
		surface.PlaySound("transmission/close.wav")
	end)
	timer.Create( "DisplayTimer", string.len(order_message) * 0.06 + 10, 1, function()
		display_orders = 0
		globaligshowingorders = false
	end)
end

net.Receive("Orders", function()
	display_orders = 0
	globaligshowingorders = false
	Text = ""
	Display_Text = ""
	row_1 = ""
	row_2 = ""
	row_3 = ""
	row_4 = ""
	row_5 = ""
	row_6 = ""
	row_7 = ""
	row_8 = ""
	title = "⧨ALERT⧩ Imperial Transmission ⧨ALERT⧩"
	//title = "⧨ TARKIN'S INITIATIVE - SECURE COMMUNICATIONS ⧩"
	order_message = net.ReadString()
	display_orders = 1
	globaligshowingorders = true
	surface.PlaySound("transmission/launch.wav")
	hook.Call( "Timers" )
end)

hook.Add( "HUDPaint" , "Display the Orders" , func_display_orders)
hook.Add( "Think", "Time the Orders", func_time_orders)
hook.Add( "Timers", "Initiate Timer", func_display_timer)

----------------------------------------EVENT SCOREBOARD----------------------------------------

net.Receive( "DoEventPlacements", function()
	local regiment = ""
	local rank = {}

	local esf = vgui.Create( "DFrame" )
	esf:SetSize(500, 500)
	esf:Center()
	esf:MakePopup()
	esf:SetTitle( "Event Placement Menu" )

	function esf:Paint( w,h )
		draw.RoundedBox( 0,0,0,w,h,Color( 255,255,255 ) )
		draw.RoundedBox( 0,0,0,w,23,Color( 100,100,100 ) )

		draw.SimpleText( "Regiment","DermaLarge",(esf:GetWide()/2 - 15)/2 + 5,30,Color( 50, 50, 50, 255 ),TEXT_ALIGN_CENTER )
		draw.SimpleText( "Placement","DermaLarge",esf:GetWide() - (esf:GetWide()/2 + 10)/2,30,Color( 50, 50, 50, 255 ),TEXT_ALIGN_CENTER )
	end

	local ess = vgui.Create( "DScrollPanel", esf )
	ess:SetPos( 5,75 )
	ess:SetSize( esf:GetWide()/2 - 15,esf:GetTall() - 80 )

	local esl = vgui.Create( "DIconLayout", ess )
	esl:SetSize( esf:GetWide()/2 - 15,esf:GetTall() - 45 )
	esl:SetSpaceY( 2 )

	-- Regiment Clusters will allow EMs to award entire legions/branchs at a time
	-- without removing the ability to award single regiments. The heavy lifting is done
	-- in _ig_custom_ulx_cmds\lua\ulx\modules\sh\sh_lua.lua -HenDoge
	if TeamTable and istable( TeamTable ) then
		-- local regClusters = {
		-- 	["501st Legion"] = true,
		-- 	["ISB Sub-Group"] = true,
		-- 	["Inquisitorius"] = true,
		-- 	["Naval Sub-Group"] = true,
		-- }
/*
		local regiments = {
			["501st Legion"] = true,
			["ISB Sub-Group"] = true,
			["Inquisitorius"] = true,
			["Naval Sub-Group"] = true,
			["107th Battalion"] = true,
		}*/

        local groups = {
        	["107th Legion"] = true,
        	["Naval Sub-Group"] = true,
        	["Intelligence"] = true,
        	["Inquisitorius"] = true,
        	["ISB Sub-Group"] = true,
        	["501st Legion"] = true,
            ["439th Legion"] = true,
            ["212th Legion"] = true
        }

        for k,_ in SortedPairs( groups ) do
			local esb = vgui.Create( "DButton", esl )
			esb:SetSize( esl:GetWide(),15 )
			esb:SetText( k )

			function esb:DoClick()
				regiment = k
			end
		end

        local placeholder = vgui.Create("DLabel", esl)
        placeholder:SetSize(esl:GetWide(),15 )
        placeholder:SetText("")

        regiments = {}

		for k,v in pairs( TeamTable ) do
			regiments[ k ] = true
		end

		for k,_ in SortedPairs( regiments ) do
			local esb = vgui.Create( "DButton", esl )
			esb:SetSize( esl:GetWide(),15 )
			esb:SetText( k )

			function esb:DoClick()
				regiment = k
			end
		end
	end

    local esb = vgui.Create( "DButton", esl )
    esb:SetSize( esl:GetWide(),15 )
    esb:SetText( "The Empire" )

    function esb:DoClick()
        regiment = "The Empire"
    end

	local esl2 = vgui.Create( "DIconLayout", esf )
	esl2:SetPos( esf:GetWide() - esf:GetWide()/2 + 10,75 )
	esl2:SetSize( esf:GetWide()/2 - 15,esf:GetTall() - 95 )
	esl2:SetSpaceY( 2 )

	for i=1,3 do
		local esb2 = vgui.Create( "DButton", esl2 )
		esb2:SetSize( esl2:GetWide(),20 )
		esb2:SetText( "Placing "..i )

		function esb2:DoClick()
			if regiment != "" then
				rank[ i ] = regiment
				esb2:SetText( "Placing "..i.." = "..regiment )
			end
		end
	end

	local finish = vgui.Create( "DButton", esf )
	finish:SetPos( esf:GetWide() - 50 - 5, esf:GetTall() - 25 )
	finish:SetSize( 50,20 )
	finish:SetText( "Submit" )

	function finish:DoClick()
		if rank[1] and rank[2] and rank[3] then
			net.Start( "BroadcastEventPlacements" )
				net.WriteTable( rank )
			net.SendToServer()

			esf:Remove()
		end
	end
end )

----------------------------------------AOS MENU----------------------------------------

local meta = FindMetaTable("Player")

    function meta:CanUseAOSSystem()
		if (self:GetJobTable().Clearance == "2") or (self:GetJobTable().Clearance == "3") or (self:GetJobTable().Clearance == "4") or (self:GetJobTable().Clearance == "5") or (self:GetJobTable().Clearance == "6") or (self:GetJobTable().Clearance == "ALL ACCESS") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Legion Commander") or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Imperial Inquisitor") or (self:GetRegiment() == "Shadow Guard") or (self:GetRegiment() == "Purge Trooper") or (self:GetRegiment() == "Imperial High Command") or self:IsSuperAdmin() then return true end

		return false
	end

	function meta:CanUseAOSSystemAdd()
		if (self:GetJobTable().Clearance == "2") or (self:GetJobTable().Clearance == "3") or (self:GetJobTable().Clearance == "4") or (self:GetJobTable().Clearance == "5") or (self:GetJobTable().Clearance == "6") or (self:GetJobTable().Clearance == "ALL ACCESS") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Legion Commander") or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Imperial Inquisitor") or (self:GetRegiment() == "Shadow Guard") or (self:GetRegiment() == "Purge Trooper") or (self:GetRegiment() == "Imperial High Command") or self:IsSuperAdmin() then return true end

		return false
	end

	function meta:CanUseAOSSystemRemove()
		if (self:GetRegiment() == "Imperial High Command") or self:GetJobTable().Clearance == "6" or self:GetJobTable().Clearance == "ALL ACCESS" or self:GetRegiment() == "Legion Commander" or (self:GetRegiment() == "IHC Administration" and self:GetRank() >= 14) or (self:GetRegiment() == "Imperial Security Bureau") or (self:GetRegiment() == "Inferno Squad") or (self:GetRegiment() == "107th Shock Division") or (self:GetRegiment() == "107th Riot Company") or (self:GetRegiment() == "107th Medic") or (self:GetRegiment() == "107th Heavy") or (self:GetRegiment() == "107th Honour Guard") or (self:GetRegiment() == "Naval Engineer" and self:GetRank() >= 19) or (ply:GetRegiment() == "CompForce" and self:GetJobTable().Clearance == "5") or self:IsSuperAdmin() then return true end
		return false
	end

net.Receive("eventserverprompt", function()
    RunConsoleCommand("connect", "server.imperialgaming.net:27065")
end)

function meta:IsAOS()
    local isaos = self:GetNWString("isaos", false)

    if (isaos) then
        return true
    else
        return false
    end
end

local function OpenAOSMenuMoose3()
    local AOS = net.ReadTable()
    local target = "None Given"
    local reason = "None Given"
    local location = "N/A"
    --VARIABLES FOR BACKGROUND
    local reasonPosX = 50
    local reasonPosY = 480
    local locationPosX = 500
    local locationPosY = 480
    --Used for calulating draw for labels
    myParent = vgui.Create("EditablePanel") -- Draw the panel

    myParent:SetTall(550)
    myParent:SetWide(1000)
    myParent:Center()
    myParent:MakePopup()

    function myParent:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(56, 65, 80, 255))
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(0, 0, 1000, 40)
        -- Background rect for reason  button
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(reasonPosX - 10, reasonPosY, 100, 40)
        -- background rect for location button
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(locationPosX - 10, locationPosY, 110, 40)
        --background rectangle for name label
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(30, 100, 110, 40)
    end

    local myButton = vgui.Create("DButton", myParent)
    myButton:SetText("X")
    myButton:SetPos(935, 8)
    myButton:SetFont("DermaLarge")
    myButton:SetTextColor(Color(255, 255, 255, 255))

    myButton.Paint = function()
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(0, 0, myButton:GetWide(), myButton:GetTall())
    end

    myButton.DoClick = function()
        myParent:Remove()
    end

    local addButton = vgui.Create("DButton", myParent)
    addButton:SetText("+")
    addButton:SetPos(900, 480)
    addButton:SetSize(60, 40)

    addButton.DoClick = function()
        if target == "None Given" or reason == "None Given" or string.len(reason) > 150 or string.len(location) > 150 then
            chat.AddText("You are missing a parameter, go back and double check your entry.")
            myParent:Remove()
        else
            net.Start("SaveAOS")
            net.WriteTable({target, steamid, reason, location})
            net.SendToServer()
            myParent:Remove()
        end
    end

    addButton.Paint = function()
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(0, 0, addButton:GetWide(), addButton:GetTall())
    end

    addButton:SetFont("DermaLarge")
    addButton:SetTextColor(Color(255, 255, 255, 255))
    local removeButton = vgui.Create("DButton", myParent)
    removeButton:SetText("-")
    removeButton:SetPos(900, 200)
    removeButton:SetSize(60, 40)

    removeButton.DoClick = function()
        if target == "None Given" then
            chat.AddText("Select a Target")
            myParent:Remove()
        else
            net.Start("RemoveAOS")
            net.WriteTable({target, steamid})
            net.SendToServer()
            myParent:Remove()
        end
    end

    removeButton.Paint = function()
        surface.SetDrawColor(76, 84, 103, 255)
        surface.DrawRect(0, 0, removeButton:GetWide(), removeButton:GetTall())
    end

    removeButton:SetFont("DermaLarge")
    removeButton:SetTextColor(Color(255, 255, 255, 255))
    local reasonLabel = vgui.Create("DLabel", myParent)
    reasonLabel:SetText("Reason")
    reasonLabel:SetPos(reasonPosX+10, reasonPosY)
    reasonLabel:SetSize(100, 40)
    reasonLabel:SetFont("Trebuchet24")
    reasonLabel:SetTextColor(Color(255, 255, 255, 255))
    local reasonEntry = vgui.Create("DTextEntry", myParent)
    reasonEntry:SetPos(140, 480)
    reasonEntry:SetSize(350, 40)
    reasonEntry:SetText("Reason for Arrest")
    reasonEntry:SetDrawBorder(true)
    reasonEntry:SetUpdateOnType(true)

    -- Passes a single argument, the text entry object.
    reasonEntry.OnGetFocus = function()
        reasonEntry:SetText("")
    end

    -- Passes a single argument, the text entry object.
    reasonEntry.OnLoseFocus = function()
        if reasonEntry:GetValue() == "" then
            reasonEntry:SetText("Reason for Arrest")
        end
    end

    reasonEntry.OnValueChange = function(self)
        if string.len(self:GetValue()) > 150 then
            reasonEntry:SetTextColor(Color(255, 64, 64, 255))
        else
            reasonEntry:SetTextColor(Color(64, 255, 64, 255))
            reason = self:GetValue()
        end
    end

    reasonEntry.Paint = function(self)
        surface.SetDrawColor(56, 65, 80)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, 0, self:GetWide(), 2)
        -- bottom line in text entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, self:GetTall() - 2, self:GetWide(), 2)
    end

    local locationLabel = vgui.Create("DLabel", myParent)
    locationLabel:SetText("Location")
    locationLabel:SetPos(locationPosX+10, locationPosY)
    locationLabel:SetSize(100, 40)
    locationLabel:SetFont("Trebuchet24")
    locationLabel:SetTextColor(Color(255, 255, 255, 255))
    local locationEntry = vgui.Create("DTextEntry", myParent)
    locationEntry:SetPos(600, 480)
    locationEntry:SetSize(310, 40)
    locationEntry:SetText("Last Location")
    locationEntry:SetDrawBorder(true)
    locationEntry:SetUpdateOnType(true)

    -- Passes a single argument, the text entry object.
    locationEntry.OnGetFocus = function()
        locationEntry:SetText("")
    end

    -- Passes a single argument, the text entry object.
    locationEntry.OnLoseFocus = function()
        if locationEntry:GetValue() == "" then
            locationEntry:SetText("Last Location")
        end
    end

    locationEntry.OnValueChange = function(self)
        location = self:GetValue()
    end

    locationEntry.Paint = function(self)
        surface.SetDrawColor(56, 65, 80)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
        -- top line in text entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, 0, self:GetWide(), 2)
        -- bottom line in text entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, self:GetTall() - 2, self:GetWide(), 2)
    end

    local title = vgui.Create("DLabel", myParent)
    title:SetPos(10, -30)
    title:SetSize(200, 100)
    title:SetText("AOS MENU")
    title:SetTextColor(Color(228, 229, 232))
    title:SetFont("DermaLarge")
    local playerListView = vgui.Create("DListView", myParent)
    playerListView:SetPos(30, 150)
    playerListView:SetSize(650, 250)
    playerListView:SetMultiSelect(false)
    playerListView:SetBackgroundColor(49, 57, 70, 255)
    playerListView:AddColumn("Name")
    playerListView.m_bHideHeaders = true
    --local playerListViewscrollbar = playerListView:GetVBar()
    --function playerListViewscrollbar:Paint( w, h )
      --  return
    --end
	function playerListView.VBar:Paint( w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 100 ) )
	end

	function playerListView.VBar.btnUp:Paint( w, h )
	   draw.SimpleText("↑","DermaDefault",3,2.5,Color(255, 255, 255, 255))
	end

	function playerListView.VBar.btnDown:Paint( w, h )
	   draw.SimpleText("↓","DermaDefault",3,0,Color(255, 255, 255, 255))
	end

	function playerListView.VBar.btnGrip:Paint( w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color(110, 119, 140, 255) )
	end

    local searchEntry = vgui.Create("DTextEntry", myParent) -- create the form as a child of frame
    searchEntry:SetPos(30, 55)
    searchEntry:SetSize(350, 40)
    searchEntry:SetEnterAllowed(true)
    searchEntry:SetUpdateOnType(true)
    searchEntry:SetText("Player Search...")

    -- Passes a single argument, the text entry object.
    searchEntry.OnGetFocus = function()
        searchEntry:SetText("")
    end

    -- Passes a single argument, the text entry object.
    searchEntry.OnLoseFocus = function()
        searchEntry:SetText("Player Search...")
    end

    -- Passes a single argument, the text entry object.
    searchEntry.OnValueChange = function(self)
        playerListView:Clear()

        if self:GetValue() == "" then
            for k, v in pairs(player.GetAll()) do
                if v:IsAOS() then
                    playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
                    playerListView:SortByColumns(3, true, 1, false)
                else
                    playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
                    playerListView:SortByColumns(3, true, 1, false)
                end

                for _, line in pairs(playerListView:GetLines()) do
                            function line:Paint(w, h)
            if player.GetBySteamID(line:GetValue(2)):IsAOS() then
                surface.SetDrawColor(240, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsSelected()) then
                surface.SetDrawColor(255, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsHovered()) then
                surface.SetDrawColor(220, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsSelected()) then
                -- draw it selected
                surface.SetDrawColor(100, 200, 100, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsHovered()) then
                -- draw it highlighted
                surface.SetDrawColor(90, 100, 120, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:GetAltLine()) then
                -- draw it lighter or darker
                surface.SetDrawColor(76, 84, 103, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            else
                -- draw it normally
                surface.SetDrawColor(49, 57, 70, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            end
                    end

                    -- if you want to change the text font/color of the columnsWWWWWWWWW
                    for _, column in pairs(line["Columns"]) do
                        column:SetFont("DermaDefault")
                        column:SetTextColor(Color(255, 255, 255, 255))
                    end
                end
            end
        else
            for k, v in pairs(player.GetAll()) do
                if string.match(string.lower(v:Nick()), string.lower(self:GetValue())) then
                    if v:IsAOS() then
                        playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
                        playerListView:SortByColumns(3, true, 1, false)
                    else
                        playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
                        playerListView:SortByColumns(3, true, 1, false)
                    end

                    for _, line in pairs(playerListView:GetLines()) do
                                function line:Paint(w, h)
            if player.GetBySteamID(line:GetValue(2)):IsAOS() then
                surface.SetDrawColor(240, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsSelected()) then
                surface.SetDrawColor(255, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsHovered()) then
                surface.SetDrawColor(220, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsSelected()) then
                -- draw it selected
                surface.SetDrawColor(100, 200, 100, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsHovered()) then
                -- draw it highlighted
                surface.SetDrawColor(244, 175, 66, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:GetAltLine()) then
                -- draw it lighter or darker
                surface.SetDrawColor(76, 84, 103, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            else
                -- draw it normally
                surface.SetDrawColor(49, 57, 70, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            end
                        end

                        -- if you want to change the text font/color of the columns
                        for _, column in pairs(line["Columns"]) do
                            column:SetFont("DermaDefault")
                            column:SetTextColor(Color(255, 255, 255, 255))
                        end
                    end
                end
            end
        end
    end

    searchEntry.Paint = function(self)
        surface.SetDrawColor(56, 65, 80)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
        self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, 0, self:GetWide(), 2)
        -- bottom line in text entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, self:GetTall() - 2, self:GetWide(), 2)
        -- left line in entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(0, 0, 2, self:GetTall())
        -- right line in entry
        surface.SetDrawColor(76, 84, 103)
        surface.DrawRect(self:GetWide() - 2, 0, 2, self:GetTall())
    end

    for k, v in pairs(player.GetAll()) do
        if v:IsAOS() then
            playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
            playerListView:SortByColumns(3, true, 1, false)
        else
            playerListView:AddLine(v:Nick(), v:SteamID(), tostring(v:IsAOS()))
            playerListView:SortByColumns(3, true, 1, false)
        end
    end

    --colours each 2nd line grey or black
    playerListView.Paint = function()
        surface.SetDrawColor(49, 57, 70, 255)
        surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
        surface.SetDrawColor(56, 65, 80, 255)
        surface.DrawOutlinedRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
    end

    playerListView.OnRowSelected = function(panel, rowIndex, row)
        target = row:GetValue(1)
        steamid = row:GetValue(2)
        local playerforaos = player.GetBySteamID(steamid)

        if playerforaos:IsAOS() then


            for k, v in pairs(AOS) do
                if v[2] == steamid then
                    locationEntry:SetText(v[4])
                    reasonEntry:SetText(v[3])
                end
            end
        else
            locationEntry:SetText("Last Location")
            reasonEntry:SetText("Reason for Arrest")
        end
    end

    for _, line in pairs(playerListView:GetLines()) do
        function line:Paint(w, h)
            if player.GetBySteamID(line:GetValue(2)):IsAOS() then
                surface.SetDrawColor(240, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsSelected()) then
                surface.SetDrawColor(255, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif player.GetBySteamID(line:GetValue(2)):IsAOS() and (self:IsHovered()) then
                surface.SetDrawColor(220, 95, 95, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsSelected()) then
                -- draw it selected
                surface.SetDrawColor(100, 200, 100, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:IsHovered()) then
                -- draw it highlighted
                surface.SetDrawColor(244, 175, 66, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            elseif (self:GetAltLine()) then
                -- draw it lighter or darker
                surface.SetDrawColor(76, 84, 103, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            else
                -- draw it normally
                surface.SetDrawColor(49, 57, 70, 255)
                surface.DrawRect(0, 0, playerListView:GetWide(), playerListView:GetTall())
            end
        end

        -- if you want to change the text font/color of the columns
        for _, column in pairs(line["Columns"]) do
            column:SetFont("DermaDefault")
            column:SetTextColor(Color(255, 255, 255, 255))
        end
    end

    local nameLabel = vgui.Create("DLabel", myParent)
    nameLabel:SetText("Name")
    nameLabel:SetPos(55, 100)
    nameLabel:SetSize(100, 40)
    nameLabel:SetFont("Trebuchet24")
    nameLabel:SetTextColor(Color(255, 255, 255, 255))
end

net.Receive("AOSMenuMoose3", function()
    OpenAOSMenuMoose3()
end)

if CLIENT then
    function ReceiveColouredChat()
        local target = net.ReadEntity()
        local targeter = net.ReadEntity()
        local s_type = net.ReadString()
        local reason = net.ReadString()
        local location = net.ReadString()

        if s_type == "remove" and target:IsValid() and targeter:IsValid() then
            chat.AddText(Color(255, 255, 255), "[", Color(0, 255, 0), "AOS-REMOVE", Color(255, 255, 255), "] ", targeter:GetJobColour(), targeter:Nick(), Color(151, 211, 255), " has removed ", target:GetJobTable().Colour, target:Nick(), Color(151, 211, 255), " from the AOS System") --[[targeter:GetJobTable().Colour]] --[[targeter:GetJobTable().Colour]]
        elseif s_type == "add" and target:IsValid() and targeter:IsValid() then
            chat.AddText(Color(255, 255, 255), "[", Color(255, 0, 0), "AOS-ADD", Color(255, 255, 255), "] ", targeter:GetJobColour(), targeter:Nick(), Color(151, 211, 255), " has made ", target:GetJobTable().Colour, target:Nick(), Color(151, 211, 255), " AOS for reason: ", Color(255, 255, 0), reason, Color(151, 211, 255), " | Location: ", Color(255, 255, 0), location) --[[targeter:GetJobTable().Colour]] --[[targeter:GetJobTable().Colour]]
        end
    end

    net.Receive("SendColouredChat", ReceiveColouredChat)
end

----------------------------------------PILOT LICENSE MENU----------------------------------------

local license

    local hideyoshi_plreference = {
        {
            "NPL",
            "BPL",
            "APL",
            "EPL",
            "MPL",
            "HV-PL",
            "FT-PL",
            "FT-PL",
            "AD-PL",
            "FPL"
        },
        {
            "INQ-PL",
            "ROY-PL",
            "INF-PL"
        },
        {
            "SL",
            "AL"
        }
    }

    local hideyoshi_pl_permittedreg = {
        "Imperial Navy",
        "Imperial Starfighter Corps",
        "Imperial High Command",
        "Inferno Squad"
    }

    -- create font
    surface.CreateFont("PilotMenuFont", {
        font = "Roboto",
        size = 22,
    })

    function OpenPilotLicenseMenu()
        local frame = vgui.Create("DPanel") --Create outline frame
        frame:SetSize(600, 720)
        frame:Center()
        frame:SetVisible(true)
        frame:MakePopup()

        -- frame background
        frame.Paint = function(self, w, g)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(0, 0, 600, 720)
        end

        local headerBackground = vgui.Create("DLabel", frame)
        headerBackground:SetPos(0, 0)
        headerBackground:SetSize(600, 30)
        headerBackground:SetText("")

        function headerBackground:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 255))
        end

        local headerLabel = vgui.Create("DLabel", frame)
        headerLabel:SetPos(10, 5)
        headerLabel:SetSize(500, 25)
        headerLabel:SetText("Pilot Management System")
        headerLabel:SetFont("PilotMenuFont")
        headerLabel:SetTextColor(Color(255, 255, 255, 255))


        local closeIcon = vgui.Create("DButton", frame)
            closeIcon:SetTextColor(Color(60, 64, 82))
            closeIcon:SetText("X")
            closeIcon:SetFont("CloseCaption_Normal")
            closeIcon:SetSize(22, 21)
            closeIcon:SetPos(578, 0)
            closeIcon.Paint = function(self, w, h)
                draw.RoundedBox( 0, 0, 0, w, h, Color(32, 36, 44))
            end
            closeIcon.DoClick = function()
            frame:SetVisible(false)
        end

        local sheet = vgui.Create( "DPropertySheet", frame )
        sheet:DockMargin(0, 30, 0, 0)
        sheet:Dock( FILL )
        sheet.Paint = function( self, w, h )
            draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255, self:GetAlpha() ) )
        end


        local panel1 = vgui.Create( "DPanel", sheet )
        panel1.Paint = function( self, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, Color( 235, 235, 235, self:GetAlpha() ) )
        end

            local applicantList = vgui.Create("DListView", panel1) --List of applicants
            applicantList:SetMultiSelect(false)
            applicantList:SetSize(500, 400)
            applicantList:SetPos(42.5, 30)
            applicantList:AddColumn("Name")
            applicantList:AddColumn("SteamID")
            applicantList:AddColumn("Regiment")
            applicantList:AddColumn("Pilot Rank")

            --colours each 2nd line grey or black
            applicantList.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            end

            local buttonRevoke = vgui.Create("DButton", panel1) --Revoke Button
            buttonRevoke:SetPos(50, 500)
            buttonRevoke:SetSize(75, 25)
            buttonRevoke:SetText("Revoke")
            buttonRevoke:SetFont("PilotMenuFont")
            buttonRevoke:SetTextColor(Color(255, 255, 255, 255))

            -- The paint function
            buttonRevoke.Paint = function()
                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(0, 0, buttonRevoke:GetWide(), buttonRevoke:GetTall())
            end

            buttonRevoke.DoClick = function()
                local selectedsteamid = applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2)
                net.Start("setplayerlvl")
                net.WriteString("NONE")
                net.WriteString(selectedsteamid)
                net.SendToServer()
                frame:SetVisible(false)
            end

            local TertiaryPilotRanks = vgui.Create("DListView", panel1)
            TertiaryPilotRanks:SetMultiSelect(false)
            TertiaryPilotRanks:SetSize(130, 150)
            TertiaryPilotRanks:SetPos(410, 475)
            TertiaryPilotRanks:AddColumn("Tertiary Licences")
            for k,v in pairs(hideyoshi_plreference[3]) do
                TertiaryPilotRanks:AddLine(v)
            end

            TertiaryPilotRanks.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, TertiaryPilotRanks:GetWide(), TertiaryPilotRanks:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, TertiaryPilotRanks:GetWide(), TertiaryPilotRanks:GetTall())
            end

            local SecondaryPilotRanks = vgui.Create("DListView", panel1)
            SecondaryPilotRanks:SetMultiSelect(false)
            SecondaryPilotRanks:SetSize(130, 150)
            SecondaryPilotRanks:SetPos(275, 475)
            SecondaryPilotRanks:AddColumn("Secondary Licences")
            for k,v in pairs(hideyoshi_plreference[2]) do
                SecondaryPilotRanks:AddLine(v)
            end

            SecondaryPilotRanks.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, SecondaryPilotRanks:GetWide(), SecondaryPilotRanks:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, SecondaryPilotRanks:GetWide(), SecondaryPilotRanks:GetTall())
            end

            local pilotRanks = vgui.Create("DListView", panel1)
            pilotRanks:SetMultiSelect(false)
            pilotRanks:SetSize(130, 150)
            pilotRanks:SetPos(140, 475)
            pilotRanks:AddColumn("Primary Licences")
            for k,v in pairs(hideyoshi_plreference[1]) do
                pilotRanks:AddLine(v)
            end

            pilotRanks.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, pilotRanks:GetWide(), pilotRanks:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, pilotRanks:GetWide(), pilotRanks:GetTall())
            end

            local buttonAssign = vgui.Create("DButton", panel1) --Assignment button
            buttonAssign:SetPos(50, 550)
            buttonAssign:SetSize(75, 25)
            buttonAssign:SetText("Assign")
            buttonAssign:SetFont("PilotMenuFont")
            buttonAssign:SetTextColor(Color(255, 255, 255, 255))

            -- The paint function
            buttonAssign.Paint = function()
                surface.SetDrawColor(0, 0, 0, 255)
                surface.DrawRect(0, 0, buttonAssign:GetWide(), buttonAssign:GetTall())
            end

            local function checkIfValidLine(tableof_selectline)
                local return_table = {}
                for k,v in pairs(tableof_selectline) do
                    if (IsValid(v)) then
                        table.insert(return_table, v:GetColumnText(1))
                    end
                end
                return return_table
            end

            buttonAssign.DoClick = function()
                local primarylvl = pilotRanks:GetLine(pilotRanks:GetSelectedLine())
                local secondarylvl = SecondaryPilotRanks:GetLine(SecondaryPilotRanks:GetSelectedLine())
                local tertiarylvl = TertiaryPilotRanks:GetLine(TertiaryPilotRanks:GetSelectedLine())
                if !(IsValid(primarylvl or secondarylvl or tertiarylvl) and IsValid(applicantList:GetLine(applicantList:GetSelectedLine()))) then
                    notification.AddLegacy("Missing one or more inputs", 1, 2)
                    return
                end
                local tableof_pilotlvl = checkIfValidLine({primarylvl,secondarylvl,tertiarylvl})
                local settolvl = table.concat(tableof_pilotlvl, " | ")
                local selectedsteamid = applicantList:GetLine(applicantList:GetSelectedLine()):GetColumnText(2)

                net.Start("hidePLenhance_setpilot")
                    net.WriteString(settolvl)
                    net.WriteString(selectedsteamid)
                net.SendToServer()
                frame:SetVisible(false)
            end

            --Rertrive info for applicant
            for _, v in pairs(player.GetAll()) do
                applicantList:AddLine(v:Nick(), v:SteamID(), v:GetRegiment(), v:GetNWString("license"))
            end

        sheet:AddSheet( "Pilot Licence", panel1, "icon16/vcard.png" )

        --[[local panel2 = vgui.Create( "DPanel", sheet )
        panel2.Paint = function( self, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, Color( 235, 235, 235, self:GetAlpha() ) )
        end
            local applicantList = vgui.Create("DListView", panel2) --List of applicants
            applicantList:SetMultiSelect(false)
            applicantList:SetSize(500, 250)
            applicantList:SetPos(42.5, 30)
            applicantList:AddColumn("Name")
            applicantList:AddColumn("SteamID")
            applicantList:AddColumn("Regiment")
            applicantList:AddColumn("Pilot Rank")

            --colours each 2nd line grey or black
            applicantList.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, applicantList:GetWide(), applicantList:GetTall())
            end

            local warningList = vgui.Create("DListView", panel2) --List of applicants
            warningList:SetMultiSelect(false)
            warningList:SetSize(500, 100)
            warningList:SetPos(42.5, 300)
            warningList:AddColumn("Warner"):SetWidth(5)
            warningList:AddColumn("Reason"):SetWidth(95)

            --colours each 2nd line grey or black
            warningList.Paint = function()
                surface.SetDrawColor(200, 200, 200, 255)
                surface.DrawRect(0, 0, warningList:GetWide(), warningList:GetTall())
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawOutlinedRect(0, 0, warningList:GetWide(), warningList:GetTall())
            end

            local TextEntry = vgui.Create( "DTextEntry", panel2 ) -- create the form as a child of frame
            TextEntry:Dock( TOP )
            TextEntry:DockMargin( 42.5, 425, 42.5, 0 )
            TextEntry:SetPlaceholderText( "Warning Reason" )

            TextEntry.OnEnter = function( self )
                chat.AddText( self:GetValue() )	-- print the textentry text as a chat message
            end

        sheet:AddSheet( "Pilot Warnings", panel2, "icon16/vcard_delete.png" )]]--

    end

net.Receive("licensemenu", OpenPilotLicenseMenu)

identifiedplayers = {}
getimmersionmode = false
net.Receive("immersionmode",function()
	local admin = LocalPlayer():IsAdmin() or false
	if admin then
		getimmersionmode = false
		identifiedplayers = {}
	else
		getimmersionmode = net.ReadBool()
		identifiedplayers = {}
	end
end)

//patron
local patronList = {};
local IG_CHARACTER_PURCHASED = {};
local frame;

local function findByID(id)
    for k, v in pairs(player.GetAll()) do
        if v:SteamID() == id then
            return v:Nick();
        end
    end

    return id;
end

local function patronMenu()
    local colourTable = {
        background = Color(255,255,255),
        buttonBackground = Color(214, 214, 214),
        titleText = Color(255,156,227),
        regularText = Color(56,56,56)
    }

	local colours = {
		primary = Color(32, 32, 32, 255),
		secondary = Color(150, 150, 150, 255),
		highlight = Color(110, 0, 227, 255),
		bracket = Color(0, 0, 0, 255),
		msgColor = Color(255, 255, 255, 255)
	}

    local allPlayers = player.GetAll();
    local selected = allPlayers[1]:Nick();
    local selectedID = allPlayers[1]:SteamID();
	local selectedID64 = allPlayers[1]:SteamID64();

    local scrw, scrh = ScrW(), ScrH();

    frame = vgui.Create("DFrame");
    frame:SetSizable(false);
    frame:SetTitle("");
    frame:SetSize(scrw * 0.7,scrh * 0.7);
    frame:Center();
    frame:MakePopup();

	//propertysheet
	local tabs = vgui.Create("DPropertySheet",frame);
	tabs:Dock(FILL);

	local tab1 = vgui.Create("DPanel",tabs)
	tab1.Paint = function(self, w, h)
		//Background Rectangle
		surface.SetDrawColor(colourTable.background);
		surface.DrawRect(0,0,w,h);

		//Title Texts
		surface.SetTextColor(colourTable.titleText);
		surface.SetFont("DermaLarge");

		surface.SetTextPos(w * 0.15, h * 0.05);
		surface.DrawText("NON PATRONS");

		surface.SetTextPos(w * 0.72, h * 0.05);
		surface.DrawText("JUST PATRONS");

		//selected text
		surface.SetFont("DermaDefault");
		surface.SetTextPos(w * 0.1,h * 0.95);
		surface.SetTextColor(colourTable.regularText);

		local expiryDay = "0";
		local expiryMonth = "0";

		for k, v in pairs(patronList) do
			if v.id == selectedID then
				expiryDay = v.day;
				expiryMonth = v.month;
				break
			end

			expiryDay = "0";
			expiryMonth = "0";
		end

		surface.DrawText(selected .. "'s patronage expires on " .. expiryDay .. "/" .. expiryMonth);
	end

	local tab2 = vgui.Create("DPanel",tabs);

    local border = 16;
    local topMargin = ((scrh * 0.5) * 0.1) + border / 2;
    local rightMargin = (scrh * 0.7);

    //player list (non patron)
    local leftScrollPanel = vgui.Create("DScrollPanel",tab1);
    leftScrollPanel:Dock(FILL);
    leftScrollPanel:DockMargin(border,topMargin,rightMargin,border * 4);

    //player right (patron)
    local rightScrollPanel = vgui.Create("DScrollPanel",tab1);
    rightScrollPanel:Dock(FILL);
    rightScrollPanel:DockMargin(rightMargin,topMargin,border,border * 4);

    //add patron button
    local addPatron = vgui.Create("DButton",tab1);
    addPatron:SetSize(scrw * 0.05,scrh * 0.05);
    addPatron:SetPos((scrw * 0.7) * 0.47, (scrh * 0.7) * 0.3);
    addPatron:SetText("");
    addPatron.Paint = function(self, w, h)
        surface.SetDrawColor(colourTable.buttonBackground);
        surface.DrawRect(0,0,w,h);

        draw.SimpleText("Add Patron","DermaDefault",w / 2, h / 2,colourTable.regularText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
    end
    addPatron.DoClick = function()
        net.Start("vanillaUpdatePatron");
        net.WriteString(selectedID);
		net.WriteString(selected);
        net.WriteBool(true);
        net.SendToServer();

		net.Start("IG_EXTRAC_ADMIN_ADD")
			net.WriteString(selectedID)
			net.WriteString(selectedID64)
		net.SendToServer()

		frame:Close()
    end

    //remove patron button
    local removePatron = vgui.Create("DButton",tab1);
    removePatron:SetSize(scrw * 0.05,scrh * 0.05);
    removePatron:SetPos((scrw * 0.7) * 0.47, (scrh * 0.7) * 0.5);
    removePatron:SetText("");
    removePatron.Paint = function(self, w, h)
        surface.SetDrawColor(colourTable.buttonBackground);
        surface.DrawRect(0,0,w,h);

        draw.SimpleText("Remove Patron","DermaDefault",w / 2, h / 2,colourTable.regularText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
    end
    removePatron.DoClick = function()
        net.Start("vanillaUpdatePatron");
        net.WriteString(selectedID);
        net.WriteBool(false);
        net.SendToServer();

		net.Start("IG_EXTRAC_ADMIN_ADD")
			net.WriteString(selectedID)
			net.WriteString(selectedID64)
		net.SendToServer()

		frame:Close()
    end

    //populate user table
    for k, v in pairs(player.GetAll()) do
        local found = false;

        //if user is a patron, skip
        for k2, v2 in pairs(patronList) do
            if v2.id == v:SteamID() then
                found = true;
                break
            end
        end

        if found == true then continue end

        local button = leftScrollPanel:Add("DButton");
        local text = v:Nick();
        button:Dock( TOP )
    	button:DockMargin( 0, 0, 0, 5 )
        button:SetText("");
        button.Paint = function(self, w, h)
            //background
            surface.SetDrawColor(colourTable.buttonBackground);
            surface.DrawRect(0,0,w,h);

            //text
            if selected != text then
                draw.SimpleText(text,"DermaDefault",w / 2, h / 2,colourTable.regularText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
            else
                draw.SimpleText(text,"DermaDefault",w / 2, h / 2,colourTable.titleText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
            end
        end

        button.DoClick = function()
            selected = v:Nick();
            selectedID = v:SteamID();
        end
    end

    //populate patron table
    for k, v in pairs(patronList) do
        local button = rightScrollPanel:Add("DButton");
        local text = v.id;
        button:Dock( TOP )
    	button:DockMargin( 0, 0, 0, 5 )
        button:SetText("");
        button.Paint = function(self, w, h)
            //background
            surface.SetDrawColor(colourTable.buttonBackground);
            surface.DrawRect(0,0,w,h);

            //text
            if selected ~= text then
                draw.SimpleText(v.id .. " " .. v.nick,"DermaDefault",w / 2, h / 2,colourTable.regularText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
            else
                draw.SimpleText(v.id .. " " .. v.nick,"DermaDefault",w / 2, h / 2,colourTable.titleText,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
            end
        end

        button.DoClick = function()
            selected = text;

            if string.sub(text,1,5) == "STEAM" then
                selectedID = text;
            else
                for k2, v2 in pairs(player.GetAll()) do
                    if v2:Nick() == selected then
                        selectedID = v2:SteamID();
						selectedID64 = v2:SteamID64();
                    end
                end
            end
        end
    end

	local onlinePlayersList = vgui.Create("DListView", tab2)
		onlinePlayersList:Dock(LEFT)
		onlinePlayersList:SetSize(0.75 * frame:GetWide(), tabs:GetTall())
		onlinePlayersList:SetMultiSelect(false)
		onlinePlayersList:AddColumn("Name")
		onlinePlayersList:AddColumn("SteamID")
		onlinePlayersList:AddColumn("SteamID64")
		onlinePlayersList:AddColumn("Second Character")
		for k, v in pairs(player.GetAll()) do
			onlinePlayersList:AddLine(v:Nick(), v:SteamID(),v:SteamID64(), IG_CHARACTER_PURCHASED[v:SteamID()])
		end
		onlinePlayersList.OnRowSelected = function(lst, index, pnl)
			targetSID = pnl:GetColumnText(2)
			targetSID64 = pnl:GetColumnText(3)
		end

	local grantClearanceBtn = vgui.Create("DButton", tab2)
		grantClearanceBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
		local desiredX = 0.875 * frame:GetWide() - 0.5 * grantClearanceBtn:GetWide() - 0.01 * frame:GetWide()
		grantClearanceBtn:SetPos(desiredX, 0.1 * frame:GetTall() - 0.5 * grantClearanceBtn:GetTall())
		grantClearanceBtn:SetText("Add/Remove")
		grantClearanceBtn.DoClick = function ()
			net.Start("IG_EXTRAC_ADMIN_ADD")
				net.WriteString(targetSID)
				net.WriteString(targetSID64)
			net.SendToServer()
			frame:Close()
		end

	local grantAccessTxt = vgui.Create("DLabel", tab2)
		grantAccessTxt:SetFont("subtitle")
		grantAccessTxt:SetTextColor(colours.primary)
		grantAccessTxt:SetText("Give Second Character to user")
		grantAccessTxt:SizeToContents()
		grantAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantAccessTxt:GetWide(), 0.04 * frame:GetTall())

	local addSteamIDBtn = vgui.Create("DButton", tab2)
		addSteamIDBtn:SetText("Grant SteamID Access")
		addSteamIDBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
		addSteamIDBtn:SetPos(desiredX, 0.81 * frame:GetTall() - 0.5 * addSteamIDBtn:GetTall())

	local nameInput = vgui.Create("DTextEntry", tab2)
		nameInput:SetPlaceholderText("Name...")
		nameInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
		desiredX = 0.875 * frame:GetWide() - 0.5 * nameInput:GetWide() - 0.01 * frame:GetWide()
		nameInput:SetPos(desiredX, 0.69 * frame:GetTall() - 0.5 * nameInput:GetTall())

	local steamIDInput = vgui.Create("DTextEntry", tab2)
		steamIDInput:SetPlaceholderText("Steam ID32...")
		steamIDInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
		steamIDInput:SetPos(desiredX, 0.75 * frame:GetTall() - 0.5 * steamIDInput:GetTall())
		addSteamIDBtn.DoClick = function ()
			net.Start("awrc_AddOfflineUser")
				net.WriteString(nameInput:GetText())
				net.WriteString(steamIDInput:GetText())
			net.SendToServer()
			frame:Close()
		end

	local grantSteamIDAccessTxt = vgui.Create("DLabel", tab2)
		grantSteamIDAccessTxt:SetFont("subtitle")
		grantSteamIDAccessTxt:SetTextColor(colours.primary)
		grantSteamIDAccessTxt:SetText("Grant Steam ID AWR Access")
		grantSteamIDAccessTxt:SizeToContents()
		grantSteamIDAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantSteamIDAccessTxt:GetWide(), 0.63 * frame:GetTall())

	tabs:AddSheet("patron menu", tab1);
	tabs:AddSheet("second character menu", tab2);
end

net.Receive("vanillaUpdatePatron",function()
    patronList = net.ReadTable();
	IG_CHARACTER_PURCHASED = net.ReadTable();
    patronMenu();
end)
net.Receive("vanillaPatronMenu", patronMenu);

net.Receive("vanillaTitleText", function()
	local letterBoxHeight = math.floor(ScrH() / 8);
	local topY = -letterBoxHeight;
	local botY = ScrH();
	local textOpacity = 0;

	local done = 0;
	local delay = 3; //delay in seconds (for each phase) *E.G 3 seconds to fade in, 3 seconds to stay, 3 seconds to fade out
	delay = delay * 16;

	local delta = 0;

	local titleText = net.ReadString();

	hook.Add( "PostDrawHUD", "vanillaTitlePaint", function()
		surface.SetDrawColor( 0, 0, 0 );
		surface.DrawRect( 0, topY, ScrW(), letterBoxHeight );
		surface.DrawRect( 0, botY, ScrW(), letterBoxHeight );

		draw.SimpleText(titleText,"CloseCaption_Bold",ScrW() * 0.9, ScrH() / 1.12,Color(255,255,255,textOpacity),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP);
	end )

	//create a timer that loops to bring the black boxes down.
	timer.Create("vanillaTitleLoop",0,0,function()
		//Bars coming down
		if topY >= 0 and botY <= (ScrH() - letterBoxHeight) and done == 0 then
			done = 1;
		elseif done == 0 then
			topY = math.Clamp(topY + 2,-letterBoxHeight,0);
			botY = math.Clamp(botY - 2,ScrH() - letterBoxHeight,ScrH());
		end

		//delay + text fade
		if done > 0 and done < delay then
			done = done + 1;
			delta = delta + 0.05;
			textOpacity = Lerp(delta,0,255);
		elseif done == delay then
			delta = delta - 0.05;
			textOpacity = Lerp(delta,0,255);

			if textOpacity == 0 then
				done = delay + 1;
			end
		end

		//Bars going back
		if topY <= -letterBoxHeight and botY >= ScrH() and done == delay + 1 then
			timer.Remove("vanillaTitleLoop");
			hook.Remove("PostDrawHUD","vanillaTitlePaint");
		elseif done == delay + 1 then
			topY = topY - 2;
			botY = botY + 2;
		end
	end)

end)
