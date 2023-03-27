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
	
	File Information: This is the Control Panel's VGUI functions.
		
----------------------------------------]]--

local w,h = ScrW(), ScrH()

gBan.SelectedCat = "none"

local function OpenFontMenu( pan, mw, mh )
	gBan.ScrollList:Clear()
	local cover = vgui.Create( "DPanel" )
	cover:SetSize( w, h )
	cover.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 188 ) )
	end
	
	local rb = vgui.Create( "DFrame", cover )
	rb:SetSize( w*0.15, h*0.15 )
	rb:SetPos( w*0.425, h*0.425 )
	rb:SetTitle( "" )
	rb:SetDraggable( false )
	rb:ShowCloseButton( false )
	rb.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww*0.01, hh*0.15, ww*0.99, hh*0.15 )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.CatFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "ChangeTextSize", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh*0.13 - ty )
		surface.DrawText( gBan:Translate( "ChangeTextSize", gBan.SelectedLanguage ) )
	end
	
	local bbw, bbh = rb:GetSize()
	
	local sizeslider = vgui.Create( "DNumSlider", rb )
	sizeslider:SetPos( w*0.01, h*0.05 )
	sizeslider:SetSize( w*0.13, h*0.02 )
	sizeslider:SetText( "INFO" )
	sizeslider:SetValue( gBan.FontScale )
	sizeslider:SetMin( 1 )			
	sizeslider:SetMax( 2 )				
	sizeslider:SetDecimals( 1 )
	sizeslider.Slider:SetSlideX( sizeslider.Scratch:GetFraction( gBan.FontScale  ) )
	function sizeslider:OnValueChanged( num )
		gBan.FontScale = num
	end
	
	local sizeslider2 = vgui.Create( "DNumSlider", rb )
	sizeslider2:SetPos( w*0.01, h*0.07 )
	sizeslider2:SetSize( w*0.13, h*0.02 )
	sizeslider2:SetText( "BUTTONS" )
	sizeslider2:SetValue( gBan.BigFontScale )
	sizeslider2:SetMin( 0.5 )			
	sizeslider2:SetMax( 1 )				
	sizeslider2:SetDecimals( 1 )
	sizeslider2.Slider:SetSlideX( sizeslider2.Scratch:GetFraction( gBan.BigFontScale ) )
	function sizeslider2:OnValueChanged( num )
		gBan.BigFontScale = num
	end
		
	local closebutt = vgui.Create( "DButton", rb )
	closebutt:SetSize( bbw*0.5, bbh*0.3 )
	closebutt:SetPos( bbw*0.25, bbh*0.68 )
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
		surface.CreateFont( "gBan.ButtonFont", { font = "BebasNeue", size = 48*(h/1200)*gBan.BigFontScale, weight = 400, antialias = true } ) 
		surface.CreateFont( "gBan.LoadingFont", { font = "BebasNeue", size = 56*(h/1200)*gBan.BigFontScale, weight = 400, antialias = true } ) 
		surface.CreateFont( "gBan.CatFont", { font = "TreBuchet24", size = 18*(h/1200)*gBan.FontScale, weight = 400, antialias = true } ) 
		surface.CreateFont( "gBan.EntryFont", { font = "TreBuchet18", size = 13*(h/1200)*gBan.FontScale, weight = 400, antialias = true } ) 
		cover:Remove()
		gBan.SelectedCat = "none"
		gBan:GenerateControlLibrary( true )
	end

end

local function OpenLanguageMenu( pan, mw, mh )
	gBan.ScrollList:Clear()
	local cover = vgui.Create( "DPanel" )
	cover:SetSize( w, h )
	cover.Paint = function( pan, ww, hh )
		draw.RoundedBox( 0, 0, 0, ww, hh, Color( 0, 0, 0, 188 ) )
	end
	
	local rb = vgui.Create( "DFrame", cover )
	rb:SetSize( w*0.15, h*0.15 )
	rb:SetPos( w*0.425, h*0.425 )
	rb:SetTitle( "" )
	rb:SetDraggable( false )
	rb:ShowCloseButton( false )
	rb.Paint = function( pan, ww, hh )
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww*0.01, hh*0.15, ww*0.99, hh*0.15 )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.CatFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "ChangeLanguage", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh*0.13 - ty )
		surface.DrawText( gBan:Translate( "ChangeLanguage", gBan.SelectedLanguage ) )
	end
	
	local bbw, bbh = rb:GetSize()
	
	local languages = vgui.Create( "DComboBox", rb )
	languages:SetSize( bbw*0.98, bbh*0.27 )
	languages:SetPos( bbw*0.01, bbh*0.2 )
	languages:SetText( gBan.SelectedLanguage )
	for lang, _ in pairs( gBan.Languages ) do
		languages:AddChoice( lang )
	end
	languages.OnSelect = function( pan, k, v )
		gBan.SelectedLanguage = v
	end
	
	local closebutt = vgui.Create( "DButton", rb )
	closebutt:SetSize( bbw*0.5, bbh*0.3 )
	closebutt:SetPos( bbw*0.25, bbh*0.68 )
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
		gBan.SelectedCat = "none"
		gBan:GenerateControlLibrary( true )
	end

end


local function CreatePlayerList()

	local mw, mh = gBan.ScrollList:GetSize()
	local bw, bh = mw, mh*0.05
	local nextpos = 0
	local allocate = true

	for _, ply in pairs( player.GetAll() ) do
		
		local base = vgui.Create( "DPanel", gBan.ScrollList )
		base:SetSize( bw, bh )
		base:SetPos( 0, nextpos )
		
		local priors = 0
		local lastdata = 0
		local lastban = gBan:Translate( "Never", gBan.SelectedLanguage )
		
		for num,data in pairs( gBan.FormattedHistory ) do
			if data[7] == ply:SteamID() then
				priors = priors + 1
				if num > lastdata then
					lastdata = num
					lastban = data[4]
				end
			end
		end
	
		local name = vgui.Create( "DPanel", base )
		name:SetSize( bw/3, bh )
		name:SetPos( 0, 0 )
		name.Paint = function( pan, ww, hh )
			if not IsValid( ply ) then
				gBan.ControlPanelLibrary[ gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) ]()
				return
			end
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( ply:Nick() )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( ply:Nick() )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local priorbans = vgui.Create( "DPanel", base )
		priorbans:SetSize( bw/3, bh )
		priorbans:SetPos( bw/3, 0 )
		priorbans.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( priors )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( priors )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww*1.01, hh )
		end
		
		local dateb = vgui.Create( "DPanel", base )
		dateb:SetSize( bw/3, bh )
		dateb:SetPos( bw*(2/3), 0 )
		dateb.Paint = function( pan, ww, hh )
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.EntryFont" )
			local tx, ty = surface.GetTextSize( lastban )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( lastban )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
		end
		
		local overlay = vgui.Create( "DButton", gBan.ScrollList )
		overlay:SetSize( bw, bh )
		overlay:SetPos( 0, nextpos )
		overlay:SetText( "" )
		overlay.Paint = function() end
		overlay.DoClick = function()
			gBan.SelectedEntry = num
			gBan:OpenBanContext( ply:Nick(), ply:SteamID(), gBan.ControlPanelLibrary[ gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) ] )
		end 
		
		base.Paint = function( pan, ww, hh )
				draw.RoundedBox( 0, 0, 0, ww, hh, Color( 35, 35, 35, 255 ) )			
		end
		
		nextpos = nextpos + bh
	end

end

function gBan:GenerateControlLibrary( init )

	gBan.ControlPanelLibrary = {}
	-- Default nothing
	gBan.ControlPanelLibrary[ "none" ] = function( pan, ww, hh ) end
	
	-- Ban Player
	gBan.ControlPanelLibrary[ gBan:Translate( "BanPlayer", gBan.SelectedLanguage ) ] = function( pan, mw, mh ) 
		gBan.ScrollList:Clear()
		local mw, mh = gBan.ScrollList:GetSize()
		local catlist = vgui.Create( "DPanel", self.ControlDock )
		catlist:SetSize( mw, mh*0.2 )
		catlist:SetPos( 0, mh*0.8 )
		catlist.Paint = function( pan, ww, hh )
			surface.SetDrawColor( color_black )
			surface.DrawRect( 0, 0, ww, hh )
			
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, ww, hh )
			
			surface.DrawLine( ww/3, 0, ww/3, hh )
			surface.DrawLine( ww*(2/3), 0, ww*(2/3), hh )
			
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.CatFont" )
			local tx, ty = surface.GetTextSize( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/6 - tx/2, hh/2 - ty/2 )
			surface.DrawText( gBan:Translate( "CatName", gBan.SelectedLanguage ) )
			
			tx, ty = surface.GetTextSize( gBan:Translate( "CatPriors", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( gBan:Translate( "CatPriors", gBan.SelectedLanguage ) )
			
			tx, ty = surface.GetTextSize( gBan:Translate( "CatLastBan", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww*(5/6) - tx/2, hh/2 - ty/2 )
			surface.DrawText( gBan:Translate( "CatLastBan", gBan.SelectedLanguage ) )
		end
		CreatePlayerList()
	end
	
	gBan.ControlPanelLibrary[ gBan:Translate( "BanBySteamID", gBan.SelectedLanguage ) ] = function( pan, bxxx, byyy ) 
		gBan.ScrollList:Clear()
		local bbw, bbh = gBan.ScrollList:GetSize()
		
		local framework = vgui.Create( "DPanel", gBan.ScrollList )
		framework:SetSize( bbw, bbh )
		framework.Paint = function( pann, ww, hh )
			surface.SetDrawColor( 35, 35, 35, 255 )
			surface.DrawRect( 0, 0, ww, hh )
		end
	
		local steamidp = vgui.Create( "DPanel", framework )
		steamidp:SetSize( bbw*0.8, bbh*0.94 )
		steamidp:SetPos( bbw*0.1, bbh*0.03 )
		
		local bx, by = framework:GetPos()
		local bxx, byy = gBan.MainFrame:GetPos()
		local bbbw, bbbh = steamidp:GetPos()
		local bbw, bbh = gBan.ScrollList:GetPos()
		
		bxx, byy = bx + bxx + bbbw + bbw, by + byy + bbbh + bbh
		local mw, mh = steamidp:GetSize()		
		local steamin = vgui.Create( "DTextEntry", steamidp )
		steamin:SetSize( mw*0.595, mh*0.05 )
		steamin:MakePopup()
		steamin:SetPos( bxx + mw*0.39, byy + mh*0.15 )
		steamin:SetFont( "gBan.LoadingFont" )
		steamin:SetTextColor( color_black )
		steamin:SetDrawBorder( true )
		steamin:SetDrawBackground( true )
		steamin:SetText( "" )
		
		local bantime = vgui.Create( "DTextEntry", steamidp )
		bantime:SetSize( mw*0.595, mh*0.05 )
		bantime:MakePopup()
		bantime:SetPos( bxx + mw*0.39, byy + mh*0.25 )
		bantime:SetFont( "gBan.LoadingFont" )
		bantime:SetTextColor( color_black )
		bantime:SetDrawBorder( true )
		bantime:SetDrawBackground( true )
		bantime:SetText( "0" )
		bantime.OnLoseFocus = function()
			if not tonumber( bantime:GetValue() ) then bantime:SetText( "0" ) end
		end
		
		local reason = vgui.Create( "DTextEntry", steamidp )
		reason:SetSize( mw*0.97, mh*0.465 )
		reason:MakePopup()
		reason:SetPos( bxx + mw*0.015, byy + mh*0.415 )
		reason:SetFont( "gBan.LoadingFont" )
		reason:SetTextColor( color_black )
		reason:SetDrawBorder( true )
		reason:SetDrawBackground( true )
		reason:SetMultiline(true)
		reason:SetText( "Reason not specified." )
		
		local banwave = vgui.Create( "DButton", steamidp )
		banwave:SetSize( mw*0.98, mh*0.1 )
		banwave:SetPos( mw*0.01, mh*0.89 )
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
			if not num or not steamin:GetValue() then surface.PlaySound( "buttons/button8.wav" ) return end
			surface.PlaySound( "buttons/button24.wav" )
			net.Start( "gBan.BanBuffer" )
				net.WriteBool( true )
				net.WriteInt( num, 32 )
				net.WriteString( reason:GetValue() )
				net.WriteString( steamin:GetValue() )
			net.SendToServer()
			gBan:OperateAdminControls()
		end
	
		steamidp.Paint = function( pan, ww, hh )
			surface.SetDrawColor( 55, 55, 55, 255 )
			surface.DrawRect( 0, 0, ww, hh )

			surface.SetDrawColor( color_white )
			surface.DrawLine( ww*0.01, hh*0.1, ww*0.99, hh*0.1 )
			
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.LoadingFont" )
			local tx, ty = surface.GetTextSize( gBan:Translate( "BanBySteamID", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh*0.05 - ty/2 )
			surface.DrawText( gBan:Translate( "BanBySteamID", gBan.SelectedLanguage ) )
			
			if not steamin:GetValue() then
				surface.SetTextColor( Color( 255, 0, 0 ) )
			end
			surface.SetTextPos( ww*0.03, hh*0.15 )
			surface.DrawText( gBan:Translate( "STIDOR64", gBan.SelectedLanguage ) .. ":" )
			
			surface.SetTextColor( color_white )
			if not tonumber( bantime:GetValue() ) then
				surface.SetTextColor( Color( 255, 0, 0 ) )
			end
			
			surface.SetTextPos( ww*0.03, hh*0.25 )
			surface.DrawText( gBan:Translate( "Duration", gBan.SelectedLanguage ) .. ":" )
			
			surface.SetTextColor( color_white )
			surface.SetTextPos( ww*0.03, hh*0.35 )
			surface.DrawText( gBan:Translate( "Reason", gBan.SelectedLanguage ) .. ":" )
			
		end
	
	end

	gBan.ControlPanelLibrary[ gBan:Translate( "UnBanSteamID", gBan.SelectedLanguage ) ] = function( pan, bxxx, byyy ) 
		gBan.ScrollList:Clear()
		local bbw, bbh = gBan.ScrollList:GetSize()
		
		local framework = vgui.Create( "DPanel", gBan.ScrollList )
		framework:SetSize( bbw, bbh )
		framework.Paint = function( pann, ww, hh )
			surface.SetDrawColor( 35, 35, 35, 255 )
			surface.DrawRect( 0, 0, ww, hh )
		end
	
		local steamidp = vgui.Create( "DPanel", framework )
		steamidp:SetSize( bbw*0.8, bbh*0.94 )
		steamidp:SetPos( bbw*0.1, bbh*0.03 )
		
		local bx, by = framework:GetPos()
		local bxx, byy = gBan.MainFrame:GetPos()
		local bbbw, bbbh = steamidp:GetPos()
		local bbw, bbh = gBan.ScrollList:GetPos()
		
		bxx, byy = bx + bxx + bbbw + bbw, by + byy + bbbh + bbh
		local mw, mh = steamidp:GetSize()		
		local steamin = vgui.Create( "DTextEntry", steamidp )
		steamin:SetSize( mw*0.98, mh*0.25 )
		steamin:MakePopup()
		steamin:SetPos( bxx + mw*0.01, byy + mh*0.5 )
		steamin:SetFont( "gBan.LoadingFont" )
		steamin:SetTextColor( color_black )
		steamin:SetDrawBorder( true )
		steamin:SetDrawBackground( true )
		steamin:SetText( "" )
		
		local banwave = vgui.Create( "DButton", steamidp )
		banwave:SetSize( mw*0.98, mh*0.1 )
		banwave:SetPos( mw*0.01, mh*0.89 )
		banwave:SetText( "" )
		banwave.Paint = function( pan, ww, hh )
		
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
			surface.DrawRect( 0, 0, ww, hh )
			
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.ButtonFont" )
			local tx, ty = surface.GetTextSize( gBan:Translate( "UnbanPlayer", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( gBan:Translate( "UnbanPlayer", gBan.SelectedLanguage ) )
			
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
			surface.PlaySound( "buttons/button24.wav" )
			net.Start( "gBan.UnBanBuffer" )
				net.WriteString( steamin:GetValue() )
			net.SendToServer()
			gBan:OperateAdminControls()
		end
	
		steamidp.Paint = function( pan, ww, hh )
			surface.SetDrawColor( 55, 55, 55, 255 )
			surface.DrawRect( 0, 0, ww, hh )

			surface.SetDrawColor( color_white )
			surface.DrawLine( ww*0.01, hh*0.1, ww*0.99, hh*0.1 )
			
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.LoadingFont" )
			local tx, ty = surface.GetTextSize( gBan:Translate( "UnBanSteamID", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh*0.05 - ty/2 )
			surface.DrawText( gBan:Translate( "UnBanSteamID", gBan.SelectedLanguage ) )
			
			if not steamin:GetValue() then
				surface.SetTextColor( Color( 255, 0, 0 ) )
			end
			
			tx, ty = surface.GetTextSize( gBan:Translate( "STIDOR64", gBan.SelectedLanguage ) )
			surface.SetTextPos( ww/2 - tx/2, hh*0.4 - ty/2 )
			surface.DrawText( gBan:Translate( "STIDOR64", gBan.SelectedLanguage ) )
			
		end
	
	end
	gBan.ControlPanelLibrary[ gBan:Translate( "ChangeLanguage", gBan.SelectedLanguage ) ] = OpenLanguageMenu
	gBan.ControlPanelLibrary[ gBan:Translate( "ChangeTextSize", gBan.SelectedLanguage ) ] = OpenFontMenu
	
	if init then
		self:OperateAdminControls()
	end
end

function gBan:OperateAdminControls()

	self.ControlDock:Clear()
	
	local mw, mh = self.ControlDock:GetSize()
	self.ControlDock.Paint = function( pan, ww, hh ) 
		surface.SetDrawColor( Color( 25, 25, 55, 255 ) )
		surface.DrawRect( 0, 0, ww, hh )
		
		surface.SetDrawColor( color_white )
		surface.DrawLine( ww*0.01, hh*0.2, ww*0.99, hh*0.2 )
		
		surface.SetTextColor( color_white )
		surface.SetFont( "gBan.LoadingFont" )
		local tx, ty = surface.GetTextSize( gBan:Translate( "SelectFunc", gBan.SelectedLanguage ) )
		surface.SetTextPos( ww/2 - tx/2, hh*0.1 - ty/2 )
		surface.DrawText( gBan:Translate( "SelectFunc", gBan.SelectedLanguage ) )
		
	end
	local num = 5
	local padx, pady = ( ( num - 1 ) * mw*0.01 ), mh*0.06
	local bw, bh = ( mw*0.98/num ), mh*0.2
	local nexty = 0
	local nextpos = padx
	for name, _ in pairs( gBan.ControlPanelLibrary ) do
		if name == "none" then continue end
		if ( nextpos + bw ) >= mw then 
			nexty = nexty + bh + pady
			nextpos = padx
		end
		local butt = vgui.Create( "DButton", self.ControlDock )
		butt:SetSize( bw, bh )
		butt:SetPos( nextpos, mh*0.3 + nexty )
		butt:SetText( "" )
		butt.Paint = function( pan, ww, hh )
			surface.SetDrawColor( Color( 100, 100, 100, 255 ) )	
			surface.DrawRect( 0, 0, ww, hh )
			
			surface.SetTextColor( color_white )
			surface.SetFont( "gBan.ButtonFont" )
			local tx, ty = surface.GetTextSize( name )
			surface.SetTextPos( ww/2 - tx/2, hh/2 - ty/2 )
			surface.DrawText( name )
			
			if butt:IsHovered() then
				surface.SetDrawColor( Color( 148, 0, 211 ) )
				surface.DrawOutlinedRect( 0, 0, ww, hh )
				if not butt.SoundPlayed then
					surface.PlaySound( "UI/buttonrollover.wav" ) 
				end
				butt.SoundPlayed = true
			elseif butt:IsDown() then
				surface.SetDrawColor( Color( 0, 255, 0 ) )
				surface.DrawOutlinedRect( 0, 0, ww, hh )
				butt.SoundPlayed = true
			else
				butt.SoundPlayed = false
			end
		
		end
		butt.DoClick = function() 
			gBan.SelectedCat = name
			gBan:OperateAdminControls()
		end
		nextpos = nextpos + bw + padx
	end
	
	gBan.ControlPanelLibrary[ gBan.SelectedCat ]( self.ControlDock, mw, mh )
	
end
