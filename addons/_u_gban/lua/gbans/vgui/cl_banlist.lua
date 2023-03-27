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
	
	File Information: This is the Ban List's vgui functions.
		
----------------------------------------]]--

function gBan:Search( str, ref )
	gBan.CustomIndices = {}
	local returntbl = {}
	
	for i = 1, #ref do 
		if ref[i][1]:lower():find( str:lower() ) then
			self.CustomIndices[ #self.CustomIndices + 1 ] = i
			returntbl[ #returntbl + 1 ] = ref[i]
		end
	end
	
	return returntbl

end

function gBan:OperateBanControls()

	self.ControlDock:Clear()
	
	local mw, mh = self.ControlDock:GetSize()
	
	self.ControlDock.Paint = function( pan, ww, hh ) 
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.LoadingFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "LoadingBans", gBan.SelectedLanguage ) )
		if not gBan.BanlistReady then
			surface.SetTextPos( ww/2 - tx/2, hh*0.3 - ty/2 )
			surface.DrawText( gBan:Translate( "LoadingBans", gBan.SelectedLanguage ) )
			return
		elseif not gBan.SelectedEntry then
			tx, ty = surface.GetTextSize( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh*0.3 - ty/2 )
			surface.DrawText( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )	
			return
		end
			
		surface.SetFont( "gBan.ButtonFont" )
		tx, ty = surface.GetTextSize( gBan:Translate( "CatName", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][1] )
		surface.SetTextPos( ww*0.03, hh*0.15 - ty/2 )
		surface.DrawText( gBan:Translate( "CatName", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][1] )
			
		local ttx, tty = surface.GetTextSize( gBan:Translate( "CatDateUnbanned", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][5] )
		surface.SetTextPos( ww*0.03, hh*0.15 + ty - tty/2  )
		surface.DrawText( gBan:Translate( "CatDateUnbanned", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][5] )			
		
		local tttx, ttty = surface.GetTextSize( gBan:Translate( "CatReason", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][5] )
		surface.SetTextPos( ww*0.03, hh*0.15 + ty + tty - ttty/2  )
		surface.DrawText( gBan:Translate( "CatReason", self.SelectedLanguage ) .. ": " .. gBan.FormattedBans[ gBan.SelectedEntry ][3] )
		
	end
	
	local catlist = vgui.Create( "DPanel", self.ControlDock )
	catlist:SetSize( mw, mh*0.2 )
	catlist:SetPos( 0, mh*0.8 )
	catlist.Paint = function( pan, ww, hh )
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetDrawColor( color_white )
		surface.DrawOutlinedRect( 0, 0, ww, hh )
		
		surface.DrawLine( ww*0.15, 0, ww*0.15, hh )
		surface.DrawLine( ww*0.3, 0, ww*0.3, hh )
		surface.DrawLine( ww*0.7, 0, ww*0.7, hh )
		surface.DrawLine( ww*0.85, 0, ww*0.85, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.CatFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.075 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
		
		local tx, ty = surface.GetTextSize( gBan:Translate( "CatAdminBan", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.225 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatAdminBan", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatReason", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.5 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatReason", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatDateBanned", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.775 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatDateBanned", gBan.SelectedLanguage ) )

		local tx, ty = surface.GetTextSize( gBan:Translate( "CatDateUnbanned", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww*0.925 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CatDateUnbanned", gBan.SelectedLanguage ) )
		
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
		net.Start( "gBan.SendBans" )
		net.SendToServer()
	end
	
	local bw, bh = self.ControlDock:GetSize()
	
	local searchpan = vgui.Create( "DTextEntry", self.ControlDock )
	searchpan:SetPos( bw*1.04 - tx/2, bh*0.79 )
	searchpan:SetSize( bw*0.15 + tx/2, bh*0.1 )
	searchpan:SetEnterAllowed( true )
	searchpan:SetEditable( true )
	searchpan.OnEnter = function( pan )
		local newtbl = ( pan:GetValue():len() < 1 and gBan.FormattedBans ) or gBan:Search( pan:GetValue(), gBan.FormattedBans )
		gBan:RefreshBans( newtbl )
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
		local tx, ty = surface.GetTextSize( gBan:Translate( "UnbanPlayer", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "UnbanPlayer", gBan.SelectedLanguage ) )
		
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
		net.Start( "gBan.UnBanBuffer" )
			net.WriteString( gBan.FormattedBans[ gBan.SelectedEntry ][6] )
		net.SendToServer()
		gBan:RefreshBans()
	end
	
	local controls2 = vgui.Create( "DButton", self.ControlDock )
	controls2:SetSize( mw*0.15 + tx/2, mh*0.2 )
	controls2:SetPos( mw*0.62 - tx/2, mh*0.04 )
	controls2:SetText( "" )
	controls2.Paint = function( pan, ww, hh )
	
		surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "Select", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "Select", gBan.SelectedLanguage ) )
		
		if controls2:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not controls2.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			controls2.SoundPlayed = true
		elseif controls2:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			controls2.SoundPlayed = true
		else
			controls2.SoundPlayed = false
		end
	end
	
	controls2.DoClick = function()
		gBan:OpenBanContext( gBan.FormattedBans[ gBan.SelectedEntry ][7], gBan.FormattedBans[ gBan.SelectedEntry ][6], gBan:RefreshBans(), true )
	end
	
end

function gBan:RefreshBans( filt )
	if not self.MainFrame then return end
	if not self.ScrollList then return end
	
	self.SelectedEntry = nil
	self.BansUpdated = false
	
	self.ScrollList:Clear()
	
	local mw, mh = self.ScrollList:GetSize()
	local bw, bh = mw, mh*0.05
	local nextpos = 0
	local allocate = true
	local SelectedEntry = 0
	if not filt then filt = self.FormattedBans end
	for num, ban in pairs( filt ) do
		
		local base = vgui.Create( "DPanel", self.ScrollList )
		base:SetSize( bw, bh )
		base:SetPos( 0, nextpos )
	
		local name = vgui.Create( "DPanel", base )
		name:SetSize( bw*0.15, bh )
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
		admin:SetSize( bw*0.15, bh )
		admin:SetPos( bw*0.15, 0 )
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
		reason:SetSize( bw*0.4, bh )
		reason:SetPos( bw*0.3, 0 )
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
		dateb:SetSize( bw*0.15, bh )
		dateb:SetPos( bw*0.7, 0 )
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
		dateub:SetSize( bw*0.15, bh )
		dateub:SetPos( bw*0.85, 0 )
		dateub.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ban[5] )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ban[5] )
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
			gBan:OperateBanControls()
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
	
	self:OperateBanControls()
	
end