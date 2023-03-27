--[[-------------------------------------------------------------------
	Global Ban! (gBan):
		A simple solution to banning.
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
							  
	Lua Developer: King David
	Contact: http://steamcommunity.com/groups/wiltostech
	
	Web Developer: BearWoolley
	Contact: N/A

	Purchased at www.scriptfodder.com
	
	File Information: This is the Ban History's VGUI functions.
		
----------------------------------------]]--

local w,h = ScrW(), ScrH()

function gBan:OpenBanContext( nick, steamid, custfunc, edit )

	if not steamid then steamid = gBan.FormattedHistory[ gBan.SelectedEntry ][7] end
	if not nick then nick = gBan.FormattedHistory[ gBan.SelectedEntry ][1] 
	else
		nick = nick .. " ( " .. steamid .. " )"
	end
	local cover = vgui.Create( "DFrame" )
	cover:SetSize( w, h )
	cover:SetTitle( "" )
	cover:ShowCloseButton( false )
	cover:SetDraggable( false )
	cover.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 188 ) )
	end
	
	local rb = vgui.Create( "DFrame", cover )
	rb:ShowCloseButton( false )
	rb:SetTitle( "" )
	rb:SetSize( w*0.25, h*0.25 )
	rb:SetPos( w*0.375, h*0.375 )
	rb:SetDraggable( false )
	
	local bxx, byy = rb:GetPos()
	local mw, mh = rb:GetSize()
	local bantime = vgui.Create( "DTextEntry", rb )
	bantime:SetSize( mw*0.795, mh*0.1 )
	bantime:MakePopup()
	bantime:SetPos( bxx + mw*0.19, byy + mh*0.15 )
	bantime:SetFont( "gBan.EntryFont" )
	bantime:SetTextColor( color_black )
	bantime:SetDrawBorder( true )
	bantime:SetDrawBackground( true )
	bantime:SetText( "0" )
	bantime.OnLoseFocus = function()
		if not tonumber( bantime:GetValue() ) then bantime:SetText( "0" ) end
	end
	
	local reason = vgui.Create( "DTextEntry", rb )
	reason:SetSize( mw*0.795, mh*0.49 )
	reason:MakePopup()
	reason:SetPos( bxx + mw*0.19, byy + mh*0.3 )
	reason:SetFont( "gBan.EntryFont" )
	reason:SetTextColor( color_black )
	reason:SetDrawBorder( true )
	reason:SetDrawBackground( true )
	reason:SetMultiline(true)
	reason:SetText( "Reason not specified." )
	
	local banwave = vgui.Create( "DButton", rb )
	banwave:SetSize( mw*0.485, mh*0.15 )
	banwave:SetPos( mw*0.505, mh*0.825 )
	banwave:SetText( "" )
	banwave.Paint = function( pan, ww, hh )
	
		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) )
		
		if banwave:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not banwave.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			banwave.SoundPlayed = true
		elseif banwave:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			banwave.SoundPlayed = true
		else
			banwave.SoundPlayed = false
		end
	end
	
	banwave.DoClick = function()
		local num = tonumber( bantime:GetValue() )
		if not num then surface.PlaySound( "buttons/button8.wav" ) return end
		surface.PlaySound( "buttons/button24.wav" )
		net.Start( "gBan.BanBuffer" )
			net.WriteBool( true )
			net.WriteInt( num, 32 )
			net.WriteString( reason:GetValue() )
			net.WriteString( steamid )
			net.WriteBool( edit )
		net.SendToServer()
		if custfunc then
			custfunc()
		end
		cover:Remove()
	end
	
	local closebutt = vgui.Create( "DButton", rb )
	closebutt:SetSize( mw*0.485, mh*0.15 )
	closebutt:SetPos( mw*0.01, mh*0.825 )
	closebutt:SetText( "" )
	closebutt.Paint = function( pan, ww, hh )
	
		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "Close", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "Close", gBan.SelectedLanguage ) )
		
		if closebutt:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not closebutt.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			closebutt.SoundPlayed = true
		elseif closebutt:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			closebutt.SoundPlayed = true
		else
			closebutt.SoundPlayed = false
		end
	end
	
	closebutt.DoClick = function()
		surface.PlaySound( "UI/buttonclick.wav" ) 
		cover:Remove()
	end
	
	rb.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.CatFont" )
		local tx, ty = surface.GetTextSize( nick )
		surface.SetTextPos( ww/2 - tx/2, hh*0.085 - ty )
		surface.DrawText( nick )
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww*0.01, hh*0.1, ww*0.99, hh*0.1 )
		
		if not tonumber( bantime:GetValue() ) then
			surface.SetTextColor( Color( 255, 0, 0 ) )
		end
		tx, ty = surface.GetTextSize( gBan:Translate( "Duration", gBan.SelectedLanguage ) .. ":" )
		surface.SetTextPos( ww*0.03, hh*0.15 )
		surface.DrawText( gBan:Translate( "Duration", gBan.SelectedLanguage ) .. ":" )
		
		surface.SetTextColor( color_white )
		tx, ty = surface.GetTextSize( gBan:Translate( "CatReason", gBan.SelectedLanguage ) .. ":" )
		surface.SetTextPos( ww*0.03, hh*0.3 )
		surface.DrawText( gBan:Translate( "CatReason", gBan.SelectedLanguage ) .. ":" )
	end
	
end

function gBan:OperateHistoryControls()

	self.ControlDock:Clear()
	
	local mw, mh = self.ControlDock:GetSize()
	
	self.ControlDock.Paint = function( pan, ww, hh ) 
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.LoadingFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "LoadingHistory", gBan.SelectedLanguage ) )
		if not gBan.HistoryReady then
			surface.SetTextPos( ww/2 - tx/2, hh*0.3 - ty/2 )
			surface.DrawText( gBan:Translate( "LoadingHistory", gBan.SelectedLanguage ) )
			return
		elseif not gBan.SelectedEntry then
			tx, ty = surface.GetTextSize( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh*0.3 - ty/2 )
			surface.DrawText( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )	
			return
		end
			
		surface.SetFont( "gBan.ButtonFont" )
		tx, ty = surface.GetTextSize( gBan:Translate( "CatName", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][1] )
		surface.SetTextPos( ww*0.03, hh*0.15 - ty/2 )
		surface.DrawText( gBan:Translate( "CatName", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][1] )
			
		local ttx, tty = surface.GetTextSize( gBan:Translate( "CatDateUnbanned", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][5] )
		surface.SetTextPos( ww*0.03, hh*0.15 + ty - tty/2  )
		surface.DrawText( gBan:Translate( "CatDateUnbanned", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][5] )			
		
		local tttx, ttty = surface.GetTextSize( gBan:Translate( "CatReason", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][5] )
		surface.SetTextPos( ww*0.03, hh*0.15 + ty + tty - ttty/2  )
		surface.DrawText( gBan:Translate( "CatReason", self.SelectedLanguage ) .. ": " .. gBan.FormattedHistory[ gBan.SelectedEntry ][3] )
		
	end
	
	local catlist = vgui.Create( "DPanel", self.ControlDock )
	catlist:SetSize( mw, mh*0.2 )
	catlist:SetPos( 0, mh*0.8 )
	catlist.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		
		surface.DrawLine( ww*0.13, 0, ww*0.13, hh )
		surface.DrawLine( ww*0.26, 0, ww*0.26, hh )
		surface.DrawLine( ww*0.61, 0, ww*0.61, hh )
		surface.DrawLine( ww*0.74, 0, ww*0.74, hh )
		surface.DrawLine( ww*0.87, 0, ww*0.87, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.CatFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.065 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
		
		local tx, ty = surface.GetTextSize( gBan:Translate( "CatAdminBan", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.195 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatAdminBan", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatReason", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.435 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatReason", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatDateBanned", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.675 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatDateBanned", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatDateUnbanned", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.805 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatDateUnbanned", gBan.SelectedLanguage ) )
		
		local tx, ty = surface.GetTextSize( gBan:Translate( "CatAdminUnban", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.935 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatAdminUnban", gBan.SelectedLanguage ) )
		
	end
	
	surface.SetFont( "gBan.ButtonFont" )
	local tx, ty = surface.GetTextSize( gBan:Translate( "Refresh", gBan.SelectedLanguage ) )
	
	local refreshl = vgui.Create( "DButton", self.ControlDock )
	refreshl:SetSize( mw*0.15 + tx/2, mh*0.2 )
	refreshl:SetPos( mw*0.84 - tx/2, mh*0.39 )
	refreshl:SetText( "" )
	refreshl.Paint = function( pan, ww, hh )
	
		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "Refresh", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "Refresh", gBan.SelectedLanguage ) )
		
		if refreshl:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not refreshl.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			refreshl.SoundPlayed = true
		elseif refreshl:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			refreshl.SoundPlayed = true
		else
			refreshl.SoundPlayed = false
		end
	end
	
	refreshl.DoClick = function()
		surface.PlaySound( "UI/buttonclick.wav" ) 
		net.Start( "gBan.SendHistory" )
		net.SendToServer()
	end
	
	local bw, bh = self.ControlDock:GetSize()
	
	local searchpan = vgui.Create( "DTextEntry", self.ControlDock )
	searchpan:SetPos( bw*1.04 - tx/2, bh*0.79 )
	searchpan:SetSize( bw*0.15 + tx/2, bh*0.1 )
	searchpan:SetEnterAllowed( true )
	searchpan:SetEditable( true )
	searchpan.OnEnter = function( pan )
		local newtbl = ( pan:GetValue():len() < 1 and gBan.FormattedHistory ) or gBan:Search( pan:GetValue(), gBan.FormattedHistory )
		gBan:RefreshHistory( newtbl )
	end
	searchpan:SetFont( "gBan.EntryFont" )
	searchpan:SetTextColor( color_black )
	searchpan:SetDrawBorder( true )
	searchpan:SetDrawBackground( true )
	searchpan.OnGetFocus = function()
		searchpan:SetText( "" )
	end
	searchpan.OnLoseFocus = function()
		searchpan:SetText( self:Translate( "Search", self.SelectedLanguage ) )
	end
	searchpan:SetHighlightColor( Color( 20, 20, 20 ) )
	searchpan:SetText( self:Translate( "Search", self.SelectedLanguage ) )
	searchpan:MakePopup()
		
	if not self.SelectedEntry then return end

	local controls = vgui.Create( "DButton", self.ControlDock )
	controls:SetSize( mw*0.15 + tx/2, mh*0.2 )
	controls:SetPos( mw*0.84 - tx/2, mh*0.04 )
	controls:SetText( "" )
	controls.Paint = function( pan, ww, hh )
	
		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) )
		
		if controls:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not controls.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			controls.SoundPlayed = true
		elseif controls:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			controls.SoundPlayed = true
		else
			controls.SoundPlayed = false
		end
	end
	
	controls.DoClick = function()
		surface.PlaySound( "UI/buttonclick.wav" ) 
		gBan:OpenBanContext()
	end
	
end

function gBan:RefreshHistory( filt )
	if not self.MainFrame then return end
	if not self.ScrollList then return end
	
	self.SelectedEntry = nil
	self.HistoryUpdated = false
	
	self.ScrollList:Clear()
	
	local mw, mh = self.ScrollList:GetSize()
	local bw, bh = mw, mh*0.05
	local nextpos = 0
	local allocate = true
	local SelectedEntry = 0
	if not filt then filt = self.FormattedHistory end
	for num, ban in pairs( filt ) do
		
		local base = vgui.Create( "DPanel", self.ScrollList )
		base:SetSize( bw, bh )
		base:SetPos( 0, nextpos )
	
		local name = vgui.Create( "DPanel", base )
		name:SetSize( bw*0.13, bh )
		name:SetPos( 0, 0 )
		name.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[1] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[1] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local admin = vgui.Create( "DPanel", base )
		admin:SetSize( bw*0.13, bh )
		admin:SetPos( bw*0.13, 0 )
		admin.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[2] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[2] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local reason = vgui.Create( "DPanel", base )
		reason:SetSize( bw*0.35, bh )
		reason:SetPos( bw*0.26, 0 )
		reason.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[3] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[3] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local dateb = vgui.Create( "DPanel", base )
		dateb:SetSize( bw*0.13, bh )
		dateb:SetPos( bw*0.61, 0 )
		dateb.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[4] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[4] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local dateub = vgui.Create( "DPanel", base )
		dateub:SetSize( bw*0.13, bh )
		dateub:SetPos( bw*0.74, 0 )
		dateub.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[5] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[5] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local dateubb = vgui.Create( "DPanel", base )
		dateubb:SetSize( bw*0.13, bh )
		dateubb:SetPos( bw*0.87, 0 )
		dateubb.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[6] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[6] )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
		end
		
		local overlay = vgui.Create( "DButton", self.ScrollList )
		overlay:SetSize( bw, bh )
		overlay:SetPos( 0, nextpos )
		overlay:SetText( "" )
		overlay.Paint = function() end
		overlay.DoClick = function()
			if #gBan.CustomIndices > 0 then
				gBan.SelectedEntry = gBan.CustomIndices[ num ]
			else
				gBan.SelectedEntry = num
			end
			SelectedEntry = num
			gBan:OperateHistoryControls()
		end
		
		base.Paint = function( pan, ww, hh )
			if overlay:IsHovered() or SelectedEntry == num then
				draw.RoundedBox( 0, 0, 0, ww, hh, Color( 155, 155, 155, 255 ) )
			elseif not allocate then
				draw.RoundedBox( 0, 0, 0, ww, hh, Color( 75, 75, 75, 255 ) )
			else
				draw.RoundedBox( 0, 0, 0, ww, hh, Color( 35, 35, 35, 255 ) )			
			end
		end
		
		nextpos = nextpos + bh
	end
	
	self:OperateHistoryControls()
	
end