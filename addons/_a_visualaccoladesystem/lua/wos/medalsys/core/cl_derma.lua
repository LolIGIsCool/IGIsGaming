--[[-------------------------------------------------------------------
	The Derma Central for this addon:
		Does the clientside derma stuff
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2018
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}
wOS.Medals.SelectedMedals = wOS.Medals.SelectedMedals or {}
wOS.Medals.SelectedMedalsInfo = wOS.Medals.SelectedMedalsInfo or {}

local w, h = ScrW(), ScrH()
local BackgroundImage = Material( "wos/vas/framestyle.png", "unlitgeneric" )

surface.CreateFont( "wOS.VAS.TitleFont", {
	font = "Roboto Cn",
	extended = false,
	size = 24*(h/1200),
	weight = 1000,
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

surface.CreateFont( "wOS.VAS.ButtonFont",{
	font = "Roboto Cn",
	extended = false,
	size = 18*(h/1200),
	weight = 700,
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

local function AutoUpdateModelPanel( panel, model, skin )
	if not model or not panel then return end
	print(panel,model,skin)
	local Iconent = ClientsideModel("borealis/barrel.mdl")
	Iconent:SetAngles(Angle(0,0,0))
	Iconent:SetPos(Vector(0,0,0))
	Iconent:Spawn()
	Iconent:Activate()	
	Iconent:SetModel( model )
	if skin then
		Iconent:SetSkin( skin )
	end
	local center = Iconent:OBBCenter()
	local dist = Iconent:BoundingRadius()*1.2
	panel:SetModel( model )
	if skin then
		panel:SetSkin( skin )
	end
	panel:SetLookAt( center - vector_up*dist*0.25 )
	panel:SetCamPos( center + Vector( dist, dist, -dist*0.25 ) )				
	Iconent:Remove()
end

--[[
	This CharWrap and TextWrap is straight from Falco in DarkRP. 
	There are similar ones on the Lua Users recipe, but you gotta give it to the man for making it good as fuck
	THANKS FALCO!
--]]
local function charWrap(text, pxWidth)
    local total = 0

    text = text:gsub(".", function(char)
        total = total + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if total >= pxWidth then
            total = 0
            return "\n" .. char
        end

        return char
    end)

    return text, total
end

function wOS.Medals.TextWrap(text, font, pxWidth)
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end

function wOS.Medals:ToggleMedalMenu()

	if IsValid( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
		gui.EnableScreenClicker( false )
		return
	end
	
	self.SelectedOption = nil
	
	gui.EnableScreenClicker( true )
	self.Menu = vgui.Create( "DFrame" )
	self.Menu:SetSize( w, h )
	self.Menu:ShowCloseButton( false )
	self.Menu:SetTitle( "" )
	self.Menu:MakePopup()
	self.Menu.mx = 0
	self.Menu.my = 0
	self.Menu.Captured = false
	self.Menu.Paint = function( pan, ww, hh )
		
	end
	self.Menu.Think = function( pan )
		if pan:IsVisible() then 
			gui.EnableScreenClicker( true ) 
		end	
		if pan.Captured then
			local x, y = pan:CaptureMouse()
			wOS.Medals.Offsety = wOS.Medals.Offsety + x*0.1
			wOS.Medals.Offsetp = wOS.Medals.Offsetp - y*0.1
		end
	end
	
	self.Menu.OnMousePressed = function( pan, key ) 
		if key == MOUSE_RIGHT then
			pan.Captured = true
		end		
	end
	self.Menu.OnMouseReleased = function( pan, key ) 
		if key == MOUSE_RIGHT then
			pan.Captured = false
		end		
	end
	self.Menu.OnMouseWheeled = function( pan, delta ) 
		wOS.Medals.OffsetZoom = math.Clamp( wOS.Medals.OffsetZoom - delta*2, 40, 80 )
	end
	self.Menu.CaptureMouse = function( pan )

		local x, y = input.GetCursorPos()

		local dx = x - pan.mx
		local dy = y - pan.my

		local centerx, centery = pan:LocalToScreen( pan:GetWide() * 0.5, pan:GetTall() * 0.2 )
		input.SetCursorPos( centerx, centery )
		pan.mx = centerx
		pan.my = centery

		return dx, dy

	end
	
	local container = vgui.Create( "DPanel", self.Menu )
	container:SetPos( w*0.05, h*0.5 )
	container:SetSize( w*0.5, h*0.3 )
	container.Paint = function( pan, ww, hh )
		draw.RoundedBox( hh*0.07, ww*0.035, hh*0.095, ww*0.93, hh*0.905, color_white )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( BackgroundImage )
		surface.DrawTexturedRect( 0, 0, ww, hh )
		
		draw.RoundedBox( ww*0.005, ww*0.24, hh*0.25, ww*0.01, hh*0.70, wOS.Medals.Config.NormalButtonClr )		
		
	end
	
	local mw, mh = container:GetSize()
	
	local closebutt = vgui.Create( "DButton", container )
	closebutt:SetPos( mw*0.08, mh*0.75 )
	closebutt:SetSize( mw*0.15, mh*0.1 )
	closebutt:SetText( "" )
	closebutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( hh*0.5, 0, 0, ww, hh, Color( 151, 152, 171, 255 ) )
		draw.SimpleText( "CLOSE", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	closebutt.DoClick = function()
		self:ToggleMedalMenu()
	end
	
	if table.HasValue( wOS.Medals.Config.AllowedULX, LocalPlayer():GetUserGroup() ) then 
		local awardbutt = vgui.Create( "DButton", container )
		awardbutt:SetPos( mw*0.08, mh*0.6 )
		awardbutt:SetSize( mw*0.15, mh*0.1 )
		awardbutt:SetText( "" )
		awardbutt.Paint = function( pan, ww, hh )
			draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( self.SelectedOption == "AwardMedals" and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
			draw.SimpleText( "AWARD MEDALS", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		awardbutt.DoClick = function()
			self:AwardMedals()
		end
	end
	
	local viewbutt = vgui.Create( "DButton", container )
	viewbutt:SetPos( mw*0.08, mh*0.45 )
	viewbutt:SetSize( mw*0.15, mh*0.1 )
	viewbutt:SetText( "" )
	viewbutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( self.SelectedOption == "ViewMedals" and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
		draw.SimpleText( "VIEW MEDALS", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	viewbutt.DoClick = function()
		self:ViewMedals()
	end
	
	local selectbutt = vgui.Create( "DButton", container )
	selectbutt:SetPos( mw*0.08, mh*0.3 )
	selectbutt:SetSize( mw*0.15, mh*0.1 )
	selectbutt:SetText( "" )
	selectbutt.Paint = function( pan, ww, hh )
		draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( self.SelectedOption == "ManageMedals" and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
		draw.SimpleText( "MANAGE MEDALS", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	selectbutt.DoClick = function()
		self:ManageMedals()
	end
	
	self.SideFrame = vgui.Create( "DPanel", container )
	self.SideFrame:SetPos( mw*0.275, mh*0.265 )
	self.SideFrame:SetSize( mw*0.665, mh*0.67 )
	self.SideFrame.Paint = function( pan, ww, hh )
		//draw.RoundedBox( 20, 0, 0, ww, hh, color_black )
		if !self.SelectedOption then
			draw.SimpleText( "NO CATEGORY SELECTED!", "wOS.VAS.TitleFont", ww/2, hh*0.2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )		
			draw.SimpleText( "HOLD [" .. string.upper( input.LookupBinding( "+attack2" ) ) .. "] AND MOVE YOUR MOUSE TO ROTATE THE CAMERA", "wOS.VAS.TitleFont", ww/2, hh*0.52, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )				
			draw.SimpleText( "SCROLL TO ADJUST ZOOM LEVEL", "wOS.VAS.TitleFont", ww/2, hh*0.66, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )						
		end
	end
	
	self.SideFrame.RebuildFromData = nil
	
end

function wOS.Medals:ColumnListPaint( pan, ww, hh )
	draw.RoundedBox( 0, 0, 0, w, h, wOS.Medals.Config.ListHeaderClr )
end

function wOS.Medals:ManageMedals()
	if not IsValid( self.SideFrame ) then return end
	self.SelectedOption = "ManageMedals"
	self.SideFrame:Clear()
	
	local equipped = {}
	LocalPlayer().SelectedMedals = LocalPlayer().SelectedMedals or {}
	for slot, data in pairs( LocalPlayer().SelectedMedals ) do
		equipped[ data.Name ] = slot
	end
	
	local sw, sh = self.SideFrame:GetSize()
	
	local viewlist = vgui.Create( "DListView", self.SideFrame )
	viewlist:SetSize( sw*0.45, sh )
	viewlist:SetSortable( false )
	
	local col = viewlist:AddColumn( "Medal" )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	col = viewlist:AddColumn( "Equipped" )
	col:SetFixedWidth( sw*0.2 )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	viewlist:SetDataHeight( sh*0.07 )
	viewlist:SetHeaderHeight( sh*0.1 )
	viewlist:SetMultiSelect( false )
	
	local _VPaint = viewlist.Paint
	viewlist.Paint = function( pan, ww, hh )
		_VPaint( pan, ww, hh )
	end
	viewlist.RefreshMedals = function( pan )
		pan:Clear()
		for medal, reason in pairs( LocalPlayer().AccoladeList ) do
			local slot = ( equipped[ medal ] and "Slot " .. equipped[ medal ] ) or ""
			local line = viewlist:AddLine( medal, slot )
			line.Reason = reason
			line.Slot = equipped[ medal ]
		end
	end
	viewlist:RefreshMedals()
	
	local medalpanel = vgui.Create( "DModelPanel", self.SideFrame )
	medalpanel:SetSize( sw*0.32, sh )
	medalpanel:SetPos( sw*0.467, 0 )
	medalpanel.ChangeModel = function( pan, model, skin )
		AutoUpdateModelPanel( pan, model, skin )
	end
	local _MPaint = medalpanel.Paint
	medalpanel.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		_MPaint( pan, ww, hh )
		
		local reason = "No Medal Selected"
		local line = viewlist:GetLine( viewlist:GetSelectedLine() )
		if IsValid( line ) then
			reason = line.Reason or reason
		end
		local text = wOS.Medals.TextWrap( reason, "wOS.VAS.ButtonFont", ww*0.92 )
		draw.DrawText( text, "wOS.VAS.ButtonFont", ww/2, hh*0.7, color_black, TEXT_ALIGN_CENTER )
	end
	medalpanel:ChangeModel( "" )

	self.SideFrame.RebuildFromData = function()
		viewlist:RefreshMedals()
		medalpanel:ChangeModel( "" )
	end
	
	local optionpanel = vgui.Create( "DPanel", self.SideFrame )
	optionpanel:SetSize( sw*0.2, sh )
	optionpanel:SetPos( sw*0.8, 0 )
	optionpanel.Paint = function( pan, ww, hh )
		if #pan:GetChildren() < 1 then return end
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
	end
	optionpanel.RefreshOptions = function( pan, equipped )
		pan:Clear()
		if pan.LastData and pan.LastSlot then
			LocalPlayer().SelectedMedals[ pan.LastSlot ] = table.Copy( pan.LastData )
			pan.LastData = nil
			pan.LastSlot = nil
		end
		local ow, oh = pan:GetSize()
		if equipped then
			local line = viewlist:GetLine( viewlist:GetSelectedLine() )
			if !IsValid( line ) then return end
			local medal = line:GetColumnText( 1 )
			if #medal < 1 then return end
			if !LocalPlayer().AccoladeList[ medal ] then return end
			local slot = line.Slot
			if not slot then return end
			pan.LastSlot = slot
			pan.LastData = table.Copy( LocalPlayer().SelectedMedals[ slot ] )
			if not pan.LastData then return end
			
			local equipbutt = vgui.Create( "DButton", optionpanel )
			equipbutt:SetPos( ow*0.05, oh*0.025 )
			equipbutt:SetSize( ow*0.9, oh*0.15 )
			equipbutt:SetText( "" )
			equipbutt.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "UNEQUIP MEDAL", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			equipbutt.DoClick = function()
				net.Start( "wOS.Medals.Badges.Strip" )
					net.WriteUInt( line.Slot or 0, 4 )
				net.SendToServer()
			end
			
			local sideslide = vgui.Create( "DNumberScratch", optionpanel )
			sideslide:SetPos( ow*0.05, oh*0.225 )
			sideslide:SetSize( ow*0.9, oh*0.15 )
			sideslide:SetMin(-10)
			sideslide:SetMax(10)
			sideslide:SetImage( "models/effects/vol_light001" )
			sideslide:SetValue( LocalPlayer().SelectedMedals[ slot ].Positions.Up )
			sideslide.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "ADJUST X", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			sideslide.Think = function( pan, num )
				if pan:IsEditing() then return end
				if pan.LastVal == pan:GetFloatValue() then return end
				pan.LastVal = pan:GetFloatValue()
				LocalPlayer().SelectedMedals[ slot ].Positions.Up = pan:GetFloatValue()
			end

			local forslide = vgui.Create( "DNumberScratch", optionpanel )
			forslide:SetPos( ow*0.05, oh*0.425 )
			forslide:SetSize( ow*0.9, oh*0.15 )
			forslide:SetMin(-10)
			forslide:SetMax(10)
			forslide:SetImage( "models/effects/vol_light001" )
			forslide:SetValue( LocalPlayer().SelectedMedals[ slot ].Positions.Right )
			forslide.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "ADJUST Y", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			forslide.Think = function( pan, num )
				if pan:IsEditing() then return end
				if pan.LastVal == pan:GetFloatValue() then return end
				pan.LastVal = pan:GetFloatValue()
				LocalPlayer().SelectedMedals[ slot ].Positions.Right = pan:GetFloatValue()
			end			
			
			local upslide = vgui.Create( "DNumberScratch", optionpanel )
			upslide:SetPos( ow*0.05, oh*0.625 )
			upslide:SetSize( ow*0.9, oh*0.15 )
			upslide:SetMin(-10)
			upslide:SetMax(10)
			upslide:SetImage( "models/effects/vol_light001" )
			upslide:SetValue( LocalPlayer().SelectedMedals[ slot ].Positions.Forward )
			upslide.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "ADJUST Z", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			upslide.Think = function( pan, num )
				if pan:IsEditing() then return end
				if pan.LastVal == pan:GetFloatValue() then return end
				pan.LastVal = pan:GetFloatValue()
				LocalPlayer().SelectedMedals[ slot ].Positions.Forward = pan:GetFloatValue()
			end		
			
			local savebutt = vgui.Create( "DButton", optionpanel )
			savebutt:SetPos( ow*0.05, oh*0.825 )
			savebutt:SetSize( ow*0.9, oh*0.15 )
			savebutt:SetText( "" )
			savebutt.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "SAVE CHANGES", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			savebutt.DoClick = function()
				local line = viewlist:GetLine( viewlist:GetSelectedLine() )
				if !IsValid( line ) then return end
				local medal = line:GetColumnText( 1 )
				if #medal < 1 then return end
				if !LocalPlayer().AccoladeList[ medal ] then return end
				net.Start( "wOS.Medals.Badges.RequestBadgePos" )
					net.WriteUInt( slot or 0, 4 )
					net.WriteTable( LocalPlayer().SelectedMedals[ slot ].Positions or {} )
				net.SendToServer()
			end
			
		else
		
			local equipbutt = vgui.Create( "DButton", optionpanel )
			equipbutt:SetPos( ow*0.05, oh*0.05 )
			equipbutt:SetSize( ow*0.9, oh*0.15 )
			equipbutt:SetText( "" )
			equipbutt.Paint = function( pan, ww, hh )
				if not medalpanel:GetModel() then return end
				draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
				draw.SimpleText( "EQUIP MEDAL", "wOS.VAS.ButtonFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			equipbutt.DoClick = function()
				local line = viewlist:GetLine( viewlist:GetSelectedLine() )
				if !IsValid( line ) then return end
				local medal = line:GetColumnText( 1 )
				if #medal < 1 then return end
				if !LocalPlayer().AccoladeList[ medal ] then return end
				net.Start( "wOS.Medals.Badges.Select" )
					net.WriteString( medal )
				net.SendToServer()
			end
			
		end
	end
	
	viewlist.OnRowSelected = function( pan, index, line )
		if not IsValid( line ) then return end
		local medal = line:GetColumnText( 1 )
		local model = wOS.Medals.Badges[ medal ]
		local skin = model.Skin or 0
		medalpanel:ChangeModel( model.Model, skin )
		optionpanel:RefreshOptions( #line:GetColumnText( 2 ) > 0 )
	end
	
	--[[
	if !table.HasValue( wOS.Medals.Config.AllowedULX, LocalPlayer():GetUserGroup() ) then return end
	
	local sendbutt = vgui.Create( "DButton", self.SideFrame )
	sendbutt:SetPos( sw*0.68, sh*0.875 )
	sendbutt:SetSize( sw*0.32, sh*0.125 )
	sendbutt:SetText( "" )
	sendbutt.Paint = function( pan, ww, hh )
		if not medalpanel:GetModel() then return end
		draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
		draw.SimpleText( "REVOKE MEDAL", "wOS.VAS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	sendbutt.DoClick = function()
		local line = selection.SelectedLine
		if !IsValid( line ) then return end
		local ply = line.Player
		if !IsValid( ply ) then return end
		local medal = viewlist.Medal
		if !medal then return end
		if !ply.AccoladeList[ medal ] then return end
		net.Start("wOS.Medals.DataStore.RevokeMedal")
			net.WriteString( ply:SteamID64() )
			net.WriteString( medal )
		net.SendToServer()
	end
	]]--
	
	self.SideFrame.RebuildFromData = function()
		self:ManageMedals()
	end
	
	
end

function wOS.Medals:ViewMedals()
	if not IsValid( self.SideFrame ) then return end
	self.SelectedOption = "ViewMedals"
	self.SideFrame:Clear()
	
	local sw, sh = self.SideFrame:GetSize()
	
	local selection = vgui.Create( "DListView", self.SideFrame )
	selection:SetSize( sw*0.32, sh )
	selection:SetSortable( false )
	
	local col = selection:AddColumn( "Name" )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	selection:SetDataHeight( sh*0.07 )
	selection:SetHeaderHeight( sh*0.1 )
	selection:SetMultiSelect( false )
	
	local viewlist = vgui.Create( "DListView", self.SideFrame )
	viewlist:SetSize( sw*0.32, sh )
	viewlist:SetPos( sw*0.34, 0 )
	viewlist:SetSortable( false )
	
	col = viewlist:AddColumn( "Medal" )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	viewlist:SetDataHeight( sh*0.07 )
	viewlist:SetHeaderHeight( sh*0.1 )
	viewlist:SetMultiSelect( false )
	
	local _VPaint = viewlist.Paint
	viewlist.Paint = function( pan, ww, hh )
		if not IsValid( selection.SelectedLine ) then pan:SetVisible( false ) return end
		_VPaint( pan, ww, hh )
	end
	
	viewlist.RefreshMedals = function( pan )
		pan:Clear()	
		viewlist.Medal = nil
		if not IsValid( selection.SelectedLine ) then pan:SetVisible( false ) return end
		local ply = selection.SelectedLine.Player
		if not ply:IsValid() then pan:SetVisible( false ) return end
		for medal, reason in pairs( ply.AccoladeList ) do
			viewlist:AddLine( medal )
		end
	end
	
	selection.RebuildPlayers = function( pan )
		pan:Clear()
		for _, ply in ipairs( player.GetAll() ) do
			local line = selection:AddLine( ply:Nick() )
			line.Player = ply
			line.Think = function( ppan )
				if not ppan.Player:IsValid() then
					if ppan:IsLineSelected() then
						self:ViewMedals()
					else
						pan:RebuildPlayers()
					end
				end
			end
		end	
	end
	
	local medalpanel = vgui.Create( "DModelPanel", self.SideFrame )
	medalpanel:SetSize( sw*0.32, ( table.HasValue( wOS.Medals.Config.AllowedULX, LocalPlayer():GetUserGroup() ) and sh*0.85 ) or sh )
	medalpanel:SetPos( sw*0.68, 0 )
	medalpanel.ChangeModel = function( pan, model, skin )
		AutoUpdateModelPanel( pan, model, skin )
	end
	local _MPaint = medalpanel.Paint
	medalpanel.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		_MPaint( pan, ww, hh )
		
		local line = selection.SelectedLine
		local reason = "No Player Selected"
		if IsValid( line ) then
			local ply = line.Player
			if IsValid( ply ) then
				local medal = viewlist.Medal
				reason = "No Medal Selected"
				if medal then
					reason = ply.AccoladeList[ medal ] or reason
				end	
			end
		end
		local text = wOS.Medals.TextWrap( reason, "wOS.VAS.ButtonFont", ww*0.92 )
		draw.DrawText( text, "wOS.VAS.ButtonFont", ww/2, hh*0.7, color_black, TEXT_ALIGN_CENTER )
	end
	medalpanel:ChangeModel( "" )
	
	selection.OnRowSelected = function( pan, index, line )
		if not IsValid( line ) then return end
		local ply = line.Player
		if not IsValid( line.Player ) then return end
		medalpanel:ChangeModel( "" )
		pan.SelectedLine = line
		net.Start( "wOS.Medals.DataStore.DisplayMedals" )
			net.WriteEntity( ply )
		net.SendToServer()
	end

	viewlist.OnRowSelected = function( pan, index, line )
		if not IsValid( line ) then return end
		pan.Medal = line:GetColumnText( 1 )
		local model = wOS.Medals.Badges[ pan.Medal ]
		local skin = model.Skin or 0
		medalpanel:ChangeModel( model.Model, skin )
	end

	selection:RebuildPlayers()

	self.SideFrame.RebuildFromData = function()
		viewlist:SetVisible( true )
		viewlist:RefreshMedals()
	end
	
	if !table.HasValue( wOS.Medals.Config.AllowedULX, LocalPlayer():GetUserGroup() ) then return end
	
	local sendbutt = vgui.Create( "DButton", self.SideFrame )
	sendbutt:SetPos( sw*0.68, sh*0.875 )
	sendbutt:SetSize( sw*0.32, sh*0.125 )
	sendbutt:SetText( "" )
	sendbutt.Paint = function( pan, ww, hh )
		if not medalpanel:GetModel() then return end
		draw.RoundedBox( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ) )
		draw.SimpleText( "REVOKE MEDAL", "wOS.VAS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	sendbutt.DoClick = function()
		local line = selection.SelectedLine
		if !IsValid( line ) then return end
		local ply = line.Player
		if !IsValid( ply ) then return end
		local medal = viewlist.Medal
		if !medal then return end
		if !ply.AccoladeList[ medal ] then return end
		net.Start("wOS.Medals.DataStore.RevokeMedal")
			net.WriteString( ply:SteamID64() )
			net.WriteString( medal )
		net.SendToServer()
	end
	
end

function wOS.Medals:AwardMedals()
	if not IsValid( self.SideFrame ) then return end
	self.SelectedOption = "AwardMedals"
	self.SideFrame:Clear()
	
	local sw, sh = self.SideFrame:GetSize()
	
	local selection = vgui.Create( "DListView", self.SideFrame )
	selection:SetSize( sw*0.32, sh*0.85 )
	selection:SetSortable( false )
	
	local col = selection:AddColumn( "Name" )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	selection:SetDataHeight( sh*0.07 )
	selection:SetHeaderHeight( sh*0.1 )
	selection:SetMultiSelect( false )
	
	local viewlist = vgui.Create( "DListView", self.SideFrame )
	viewlist:SetSize( sw*0.32, sh*0.85 )
	viewlist:SetPos( sw*0.34, 0 )
	viewlist:SetSortable( false )
	
	col = viewlist:AddColumn( "Medal" )
	col.Header:SetTextColor( color_white )
	col.Header.Paint = self.ColumnListPaint
	
	viewlist:SetDataHeight( sh*0.07 )
	viewlist:SetHeaderHeight( sh*0.1 )
	viewlist:SetMultiSelect( false )
	
	local _VPaint = viewlist.Paint
	viewlist.Paint = function( pan, ww, hh )
		if not IsValid( selection.SelectedLine ) then pan:SetVisible( false ) return end
		_VPaint( pan, ww, hh )
	end
	
	viewlist.RefreshMedals = function( pan )
		pan:Clear()	
		viewlist.Medal = nil
		if not IsValid( selection.SelectedLine ) then pan:SetVisible( false ) return end
		local ply = selection.SelectedLine.Player
		if not ply:IsValid() then pan:SetVisible( false ) return end
		for medal, data in pairs( self.Badges ) do
			local line = viewlist:AddLine( medal )
			line.Data = data
		end
	end
	
	selection.RebuildPlayers = function( pan )
		pan:Clear()
		for _, ply in ipairs( player.GetAll() ) do
			local line = selection:AddLine( ply:Nick() )
			line.Player = ply
			line.Think = function( ppan )
				if not ppan.Player:IsValid() then
					if ppan:IsLineSelected() then
						self:ViewMedals()
					else
						pan:RebuildPlayers()
					end
				end
			end
		end	
	end
	
	local medalpanel = vgui.Create( "DModelPanel", self.SideFrame )
	medalpanel:SetSize( sw*0.32, sh*0.85 )
	medalpanel:SetPos( sw*0.68, 0 )
	medalpanel.ChangeModel = function( pan, model, skin )
		AutoUpdateModelPanel( pan, model, skin )
	end
	local _MPaint = medalpanel.Paint
	medalpanel.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_black )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		_MPaint( pan, ww, hh )
		
		local line = selection.SelectedLine
		local reason = "No Player Selected"
		if IsValid( line ) then
			local ply = line.Player
			if IsValid( ply ) then
				local medal = viewlist:GetLine( viewlist:GetSelectedLine() )
				reason = "No Medal Selected"
				if medal then
					reason = medal.Data.Description or reason
				end	
			end
		end
		local text = wOS.Medals.TextWrap( reason, "wOS.VAS.ButtonFont", ww*0.92 )
		draw.DrawText( text, "wOS.VAS.ButtonFont", ww/2, hh*0.7, color_black, TEXT_ALIGN_CENTER )
	end
	medalpanel:ChangeModel( "" )
	
	selection.OnRowSelected = function( pan, index, line )
		if not IsValid( line ) then return end
		local ply = line.Player
		if not IsValid( line.Player ) then return end
		medalpanel:ChangeModel( "" )
		pan.SelectedLine = line
		viewlist:SetVisible( true )
		viewlist:RefreshMedals()
	end

	viewlist.OnRowSelected = function( pan, index, line )
		if not IsValid( line ) then return end
		pan.Medal = line:GetColumnText( 1 )
		local model = wOS.Medals.Badges[ pan.Medal ]
		local skin = model.Skin or 0
		medalpanel:ChangeModel( model.Model, skin )
	end
	
	local inputBox = vgui.Create("DTextEntry", self.SideFrame )
	inputBox:SetSize( sw*0.8, sh*0.125 )
	inputBox:SetPos( 0, sh*0.875 )
	inputBox:SetText( "Enter your reason for awarding the medal" )
	inputBox:SetFont( "wOS.VAS.TitleFont" )
	inputBox:SetUpdateOnType( true )
	inputBox.Flash = 0
	inputBox.Colors = {
		Background = Color(65, 64, 69),
		Highlight = Color( 151, 152, 171 ),
		Text = color_white
	}
	inputBox.Paint = function( self, ww, hh )
		if inputBox.Flash < CurTime() then
			surface.SetDrawColor( color_white )
		else
			surface.SetDrawColor( Color( 255, 255*math.cos( CurTime()*20 ), 255*math.cos( CurTime()*20 ), 255 ) )
		end
		if (self:HasFocus()) then
			draw.RoundedBoxEx( hh*0.5, 0, 0, ww, hh, wOS.Medals.Config.NormalButtonClr, true, false, true, false )
		else
			draw.RoundedBoxEx( hh*0.5, 0, 0, ww, hh, Color( 151, 152, 171 ), true, false, true, false )
		end
		self:DrawTextEntryText(self.Colors.Text, self.Colors.Highlight, self.Colors.Text)
	end
	
	local sendbutt = vgui.Create( "DButton", self.SideFrame )
	sendbutt:SetPos( sw*0.81, sh*0.875 )
	sendbutt:SetSize( sw*0.19, sh*0.125 )
	sendbutt:SetText( "" )
	sendbutt.Paint = function( pan, ww, hh )
		draw.RoundedBoxEx( hh*0.5, 0, 0, ww, hh, ( pan:IsHovered() and wOS.Medals.Config.NormalButtonClr ) or Color( 151, 152, 171, 255 ), false, true, false, true )
		draw.SimpleText( "AWARD", "wOS.VAS.TitleFont", ww/2, hh/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	sendbutt.DoClick = function()
		local line = selection:GetLine( selection:GetSelectedLine() )
		if not IsValid( line ) then return end
		local ply = line.Player
		if not IsValid( line.Player ) then return end
		local medal = viewlist:GetLine( viewlist:GetSelectedLine() )
		if not IsValid( medal ) then return end
		if not medal.Data then return end
		local reason = ( #inputBox:GetValue() > 0 and inputBox:GetValue() ) or "Being a great guy"
		if reason == "Enter your reason for awarding the medal" then reason = "Being a great guy" end
		net.Start("wOS.Medals.DataStore.SaveMedal")
			net.WriteString( ply:SteamID64() )
			net.WriteString( medal.Data.Name )
			net.WriteString( reason )
		net.SendToServer()
	end

	selection:RebuildPlayers()

	self.SideFrame.RebuildFromData = nil
	
end