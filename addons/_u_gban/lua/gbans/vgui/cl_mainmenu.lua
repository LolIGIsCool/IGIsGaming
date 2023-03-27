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
	
	File Information: This is the main menu component of the VGUI. It's basically what we're going to draw the other stuff on top of.
		
----------------------------------------]]--


w,h = ScrW(), ScrH()
local mw, mh = w*0.96, h*0.96

ACTIVE_BANS = 1
CURRENT_HISTORY = 2
CONTROL_PANEL = 3

gBan.CurrentTab = ACTIVE_BANS
gBan.FontScale = 1
gBan.BigFontScale = 1

surface.CreateFont( "gBan.ButtonFont", { font = "BebasNeue", size = 48*(h/1200)*gBan.BigFontScale, weight = 400, antialias = true } ) 
surface.CreateFont( "gBan.LoadingFont", { font = "BebasNeue", size = 56*(h/1200)*gBan.BigFontScale, weight = 400, antialias = true } ) 
surface.CreateFont( "gBan.CatFont", { font = "TreBuchet24", size = 18*(h/1200)*gBan.FontScale, weight = 400, antialias = true } ) 
surface.CreateFont( "gBan.EntryFont", { font = "TreBuchet18", size = 13*(h/1200)*gBan.FontScale, weight = 400, antialias = true } ) 

gBan.CustomIndices = {}

function gBan:Refresh()

	self.ScrollList:Clear()
	self.ControlDock:Clear()
	gBan.CustomIndices = {}
	
	if self.CurrentTab == ACTIVE_BANS then
		self:RefreshBans()
	elseif self.CurrentTab == CURRENT_HISTORY then
		self:RefreshHistory()
	else
		self:GenerateControlLibrary( true )
	end
	
end

function gBan:OpenMenu()
	gui.EnableScreenClicker( true )

	if IsValid( self.MainFrame ) then
		self.MainFrame:SetVisible( true )
		self:Refresh()
		return
	end
	
	self.MainFrame = vgui.Create( "DPanel" )
	self.MainFrame:SetSize( mw, mh )
	self.MainFrame:SetPos( (w - mw)*0.5, ( h - mh )*0.5 )
	self.MainFrame.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		surface.DrawRect( 0, 0, ww*0.15, hh )		
	end
	
	self.ScrollList = vgui.Create( "DScrollPanel", self.MainFrame )
	self.ScrollList:SetSize( mw*0.85, mh*0.8 )
	self.ScrollList:SetPos( mw*0.15, mh*0.2 )
	self.ScrollList.Paint = function() end
	
	self.ControlDock = vgui.Create( "DPanel", self.MainFrame )
	self.ControlDock:SetSize( mw*0.85, mh*0.2 )
	self.ControlDock:SetPos( mw*0.15, 0 )
	self.ControlDock.Paint = function( pan, ww, hh ) 
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.LoadingFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "LoadingBans", gBan.SelectedLanguage ) )

		if gBan.ActiveTab == ACTIVE_BANS then
			if not gBan.BanlistReady then
				surface.SetTextPos( ww*0.33 - tx/2, hh/2 - ty/2 )
				surface.DrawText( gBan:Translate( "LoadingBans", gBan.SelectedLanguage ) )
			elseif not pan.SelectedUser then
				tx, ty = surface.GetTextSize( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )
				surface.SetTextPos( ww*0.33 - tx/2, hh/2 - ty/2 )
				surface.DrawText( gBan:Translate( "SelectBans", gBan.SelectedLanguage ) )					
			end
		elseif gBan.ActiveTab == CURRENT_HISTORY and not gBan.HistoryReady then
			tx, ty = surface.GetTextSize( gBan:Translate( "LoadingHistory", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww*0.33 - tx/2, hh/2 - ty/2 )
			surface.DrawText( gBan:Translate( "LoadingHistory", gBan.SelectedLanguage ) )		
		end
		
	end
	
	self.SidePanel = vgui.Create( "DPanel", self.MainFrame )
	self.SidePanel:SetSize( mw*0.15, mh )
	self.SidePanel.Paint = function() end
	
	local logo = vgui.Create( "DImage", self.SidePanel )
	logo:SetSize( mw*0.15, mh*0.18 )
	logo:SetImage( "gban/logo.png" )
	
	local bans = vgui.Create( "DButton", self.SidePanel )
	bans:SetSize( mw*0.15, mh*0.205 )
	bans:SetPos( 0, mh*0.18 )
	bans:SetText( "" )
	bans.Paint = function( pan, ww, hh )
		if gBan.ActiveTab == ACTIVE_BANS then
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		else
			surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		end
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "CurBans", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CurBans", gBan.SelectedLanguage ) )
		
		if gBan.ActiveTab == ACTIVE_BANS then return end
		
		if bans:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not bans.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			bans.SoundPlayed = true
		elseif bans:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			bans.SoundPlayed = true
		else
			bans.SoundPlayed = false
		end
	end
	
	bans.DoClick = function()
		if gBan.ActiveTab == ACTIVE_BANS then return end
		surface.PlaySound( "UI/buttonclick.wav" ) 
		gBan.CurrentTab = ACTIVE_BANS 
		gBan:Refresh()
	end
	
	local history = vgui.Create( "DButton", self.SidePanel )
	history:SetSize( mw*0.15, mh*0.205 )
	history:SetPos( 0, mh*0.385 )
	history:SetText( "" )
	history.Paint = function( pan, ww, hh )
		if gBan.ActiveTab == CURRENT_HISTORY then
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		else
			surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		end
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "CurHistory", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "CurHistory", gBan.SelectedLanguage ) )
		
		if gBan.ActiveTab == CURRENT_HISTORY then return end
		
		if history:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not history.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			history.SoundPlayed = true
		elseif history:IsDown() then
			surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			history.SoundPlayed = true
		else
			history.SoundPlayed = false
		end
	end
	
	history.DoClick = function()
		if gBan.ActiveTab == CURRENT_HISTORY then return end
		surface.PlaySound( "UI/buttonclick.wav" ) 
		gBan.CurrentTab = CURRENT_HISTORY
		gBan:Refresh()
	end
	
	local controls = vgui.Create( "DButton", self.SidePanel )
	controls:SetSize( mw*0.15, mh*0.205 )
	controls:SetPos( 0, mh*0.59 )
	controls:SetText( "" )
	controls.Paint = function( pan, ww, hh )
		if gBan.ActiveTab == CONTROL_PANEL then
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
		else
			surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		end
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "Controls", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "Controls", gBan.SelectedLanguage ) )
		
		if gBan.ActiveTab == CONTROL_PANEL then return end
		
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
		if gBan.ActiveTab == CONTROL_PANEL then return end
		surface.PlaySound( "UI/buttonclick.wav" ) 
		gBan.CurrentTab = CONTROL_PANEL
		gBan:Refresh()
	end
	
	local close = vgui.Create( "DButton", self.SidePanel )
	close:SetSize( mw*0.15, mh*0.205 )
	close:SetPos( 0, mh*0.795 )
	close:SetText( "" )
	close.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.ButtonFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "Close", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
		surface.DrawText( gBan:Translate( "Close", gBan.SelectedLanguage ) )
		
		if close:IsHovered() then
			surface.SetDrawColor( Color( 148, 0, 211 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			if not close.SoundPlayed then
				surface.PlaySound( "UI/buttonrollover.wav" ) 
			end
			close.SoundPlayed = true
		elseif close:IsDown() then
						surface.SetDrawColor( Color( 0, 255, 0 ) )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			close.SoundPlayed = true
		else
			close.SoundPlayed = false
		end
	end
	
	close.DoClick = function()
		surface.PlaySound( "UI/buttonclick.wav" ) 		
		gBan:CloseMenu()
	end

	gBan:Refresh()
	
end

function gBan:CloseMenu()
	if not self.MainFrame then return end
	
	self.MainFrame:SetVisible( false )
	gui.EnableScreenClicker( false )
	
end