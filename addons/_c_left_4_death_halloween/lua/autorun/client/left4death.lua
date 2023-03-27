--[[ Made by StealthPaw: http://steamcommunity.com/id/stealthpaw ]]--
--[[ Sound credits to Left 4 Dead. ]]--
local L4DSound, L4DColors, L4DPanel
surface.CreateFont("l4deathfont", {font = "TargetID", size = 60, weight = 250, antialias = true, shadow = false})

local iglogo = Material("ig/menu/ig_logo.png", "noclamp smooth")
local function cinematicScreen()
	if IsValid(L4DPanel) then L4DPanel:Remove() end
	L4DPanel = vgui.Create( "DPanel" )
	L4DPanel:SetSize( ScrW(), ScrH() )
	L4DPanel.t = CurTime()+1
	L4DPanel.Paint = function( s, w, h )
		if IsValid(s) and (CurTime() >= (s.t or 0)) and IsValid(LocalPlayer()) and LocalPlayer():Alive() then s:Remove() end
	end
	L4DPanel:SetAlpha(0)
	L4DPanel:AlphaTo(255, 3, 0)
	local Panel1 = vgui.Create( "DPanel", L4DPanel )
	Panel1:SetSize( L4DPanel:GetWide(), L4DPanel:GetTall()/8 )
	Panel1:SetPos( 0, 0-Panel1:GetTall() )
	local SubTitle = ""
	if GetConVar( "Left4Death_Subtitle" ) and GetConVar( "Left4Death_Subtitle" ):GetString() then
		SubTitle = GetConVar( "Left4Death_Subtitle" ):GetString()
	end
	Panel1.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, color_black)

		surface.SetMaterial( iglogo )
		surface.SetDrawColor(Color(255,255,255,255))
	    surface.DrawTexturedRect(w/8-80, h/2-30, 60, 60)
		if string.find(LocalPlayer():GetRegiment(), "Event") then
			draw.SimpleText("You have died as an Event Character", "l4deathfont", w/8, h/2, Color(255,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("In your past life you may have served the Empire, but now you're a slave for the Event Masters.", "DermaLarge", w/8+40, h/2+50, Color(255,255,255,150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("You have died serving the Empire", "l4deathfont", w/8, h/2, Color(255,0,0,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("The Empire thanks you for your service and loyalty to the Emperor!", "DermaLarge", w/8+40, h/2+50, Color(53, 137, 255, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	Panel1:MoveTo( 0, 0, 3)
	local Panel2 = vgui.Create( "DPanel", L4DPanel )
	Panel2:SetSize( L4DPanel:GetWide(), L4DPanel:GetTall()/8 )
	Panel2:SetPos( 0, L4DPanel:GetTall() )
	Panel2.Paint = function( self, w, h ) 
		draw.RoundedBox(0, 0, 0, w, h, color_black) 
		draw.SimpleText("You can respawn in " .. math.Clamp(math.ceil(LocalPlayer():GetNWInt("VANILLA_DEATHTIMER")), 0, 5) .. " seconds.", "DermaLarge", w / 2, h/2, Color(255,20,20,150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	Panel2:MoveTo( 0, L4DPanel:GetTall()-Panel2:GetTall(), 3)
end

concommand.Add( "PlayerSpawn_L4D", function( ply, cmd, args )
	if L4DSound then L4DSound:Stop() end
	if IsValid(L4DPanel) then L4DPanel:Remove() end
	L4DColors["$pp_colour_colour"] = 1
	L4DColors["$pp_colour_contrast"] = 1
	L4DColors["$pp_colour_mulr"] = 0
end )

CreateClientConVar( "Left4Death", 1, true, false, "Enable/Disable Left4Death DeathScreen" )
CreateClientConVar( "Left4Death_Version", 1, true, false, "Switch between L4D 1 & 2" )
CreateClientConVar( "Left4Death_Subtitle", "", true, false, "Set the subtitle text" )
cvars.AddChangeCallback( "Left4Death_Version", function() if L4DSound then L4DSound:Stop() end L4DSound = false end )
concommand.Add( "PlayerDeath_L4D", function( ply, cmd, args )
	if !GetConVar( "Left4Death" ) or !GetConVar( "Left4Death" ):GetBool() then return end
	if !L4DSound then L4DSound = CreateSound( LocalPlayer(), "ig/deadsound.mp3" ) end
	L4DSound:Play()
	cinematicScreen()
end )


hook.Add( "HUDShouldDraw", "HUDShouldDraw_MrBean", function( name )
	if ( GetConVar( "Left4Death" ) and GetConVar( "Left4Death" ):GetBool() ) and ( !IsValid(LocalPlayer()) or !LocalPlayer():Alive() ) and ( name and name == "CHudDamageIndicator" ) then return false end
end )

L4DColors = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
hook.Add( "RenderScreenspaceEffects", "RenderScreenspaceEffects_L4D", function()
	if !IsValid(LocalPlayer()) then return end
	if LocalPlayer():Alive() then return end
	if !GetConVar( "Left4Death" ) or !GetConVar( "Left4Death" ):GetBool() then return end
	L4DColors["$pp_colour_colour"] = math.Clamp( (L4DColors["$pp_colour_colour"] or 1) - (FrameTime()/5), 0, 1 )
	L4DColors["$pp_colour_contrast"] = math.Clamp( (L4DColors["$pp_colour_contrast"] or 1) - (FrameTime()/15), 0.5, 1 )
	L4DColors["$pp_colour_mulr"] = math.Clamp( (L4DColors["$pp_colour_mulr"] or 0) + (FrameTime()/2), 0, 3 )
	DrawColorModify( L4DColors )
end )
