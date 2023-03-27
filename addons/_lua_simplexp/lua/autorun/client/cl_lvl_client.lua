CreateClientConVar( "cl_lvl_color_r", tostring(SimpleXPConfig.DefaultRed), true, false )
CreateClientConVar( "cl_lvl_color_g", tostring(SimpleXPConfig.DefaultGreen), true, false )
CreateClientConVar( "cl_lvl_color_b", tostring(SimpleXPConfig.DefaultBlue), true, false )
CreateClientConVar( "cl_lvl_color_a", tostring(SimpleXPConfig.DefaultAlpha), true, false )
local map = function(n, start1, stop1, start2, stop2) return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2 end

surface.CreateFont("HungerFont", {
    font = "Arial",
    extended = false,
    size = 13,
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
    outline = false
})

function OnSucessfullyLoaded()
	if SimpleXPConfig.DisplayTargetXP == true then
		function GAMEMODE:HUDDrawTargetID()
		end
	end
end

hook.Add("OnGamemodeLoaded","Gamemode Loaded",OnSucessfullyLoaded)

local TargetFade = 0
local LastTarget = LocalPlayer()

function CustomTargetID()
	if SimpleXPConfig.DisplayTargetXP == true then

		local x = ScrW()
		local y = ScrH()

		local TraceData = {
			start = EyePos(),
			endpos = EyePos() + EyeAngles():Forward()*200,
			filter = LocalPlayer(),
			mask = MASK_SHOT,
			ignoreworld = false,
		}

		local Trace = util.TraceLine(TraceData)

		local Target = Trace.Entity

		if Target and Target:IsPlayer() then
			LastTarget = Target
			TargetFade = math.Clamp(TargetFade + FrameTime()*10,0,1)
		else
			TargetFade = math.Clamp(TargetFade - FrameTime()*10,0,1)
		end

	end
end

hook.Add("HUDDrawTargetID","Custom Target ID",CustomTargetID)

local XPTable = {}
local NextRemoveXP = 0
local NextRemoveLVL = 0

net.Receive( "SimpleXPSendInfo", function( len, ply )
	local Data = net.ReadTable()
	table.Add(XPTable,Data)
	NextRemoveXP = RealTime() + (10 / #XPTable)
end )

function SimpleXPCheckLevelUp()

	local ply = LocalPlayer()

	local CurrentLevel = SimpleXPGetLevel(ply)

	if not ply.SimpleXPLast then
		ply.SimpleXPLast = CurrentLevel
	elseif CurrentLevel ~= ply.SimpleXPLast then
		ply:EmitSound("garrysmod/save_load4.wav")
		ply.SimpleXPLast = CurrentLevel
		NextRemoveLVL = RealTime() + 5
	end

end

local StoredXP = nil

function SimpleXPDrawHUD()

	SimpleXPCheckLevelUp()

	local ply = LocalPlayer()

	if IsValid(LastTarget) and LastTarget:IsPlayer() and TargetFade ~= 0 then
    local Name = LastTarget:Nick()
    local TeamColor = team.GetColor(LastTarget:Team())
    local TargColor = LastTarget:GetJobTable().Colour
	local TargRank = LastTarget:GetJobTable().Name
	local TargRegiment = LastTarget:GetJobTable().Regiment
    if LastTarget:GetNoDraw() then return end
    if LastTarget:GetNWBool("CamoEnabled") then
        if LastTarget:GetVelocity():LengthSqr() > 12100 and getimmersionmode == false or table.HasValue(identifiedplayers,LastTarget) then
            draw.DrawText(TargRank .. " " .. Name, "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 40, TargColor, TEXT_ALIGN_CENTER)
			draw.DrawText(TargRegiment, "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 60, TargColor, TEXT_ALIGN_CENTER)
            draw.DrawText(math.max( 0, math.floor( (LastTarget:Health() / LastTarget:GetMaxHealth()) *100 ) ) .. "%", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 80, TargColor, TEXT_ALIGN_CENTER)
            draw.DrawText(SimpleXPCheckRank(SimpleXPGetLevel(LastTarget)), "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 100, TargColor, TEXT_ALIGN_CENTER)
        elseif LastTarget:GetVelocity():LengthSqr() > 12100 and getimmersionmode == true then
            draw.DrawText("Unknown Player", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 40, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER)
            draw.DrawText(math.max( 0, math.floor( (LastTarget:Health() / LastTarget:GetMaxHealth()) *100 ) ) .. "%", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 60, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER)
        end
    end

    if table.HasValue(identifiedplayers,LastTarget) or not LastTarget:GetNWBool("CamoEnabled") and getimmersionmode == false then
        draw.DrawText(TargRank .. " " .. Name, "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 40, TargColor, TEXT_ALIGN_CENTER)
		draw.DrawText(TargRegiment, "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 60, TargColor, TEXT_ALIGN_CENTER)
        draw.DrawText(math.max( 0, math.floor( (LastTarget:Health() / LastTarget:GetMaxHealth()) *100 ) ) .. "%", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 80, TargColor, TEXT_ALIGN_CENTER)
        draw.DrawText(SimpleXPCheckRank(SimpleXPGetLevel(LastTarget)), "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 100, TargColor, TEXT_ALIGN_CENTER)
    elseif not LastTarget:GetNWBool("CamoEnabled") and getimmersionmode == true then
        draw.DrawText("Unknown Player", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 40, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER)
        draw.DrawText(math.max( 0, math.floor( (LastTarget:Health() / LastTarget:GetMaxHealth()) *100 ) ) .. "%", "TargetID", ScrW() * 0.5, ScrH() * 0.50 + 60, Color( 235, 235, 235 ), TEXT_ALIGN_CENTER)
    end
end

	local HudColor = Color(GetConVar("cl_lvl_color_r"):GetFloat(),GetConVar("cl_lvl_color_g"):GetFloat(),GetConVar("cl_lvl_color_b"):GetFloat(),GetConVar("cl_lvl_color_a"):GetFloat())

	if not SimpleXPConfig.UseFixedColors then
		HudColor = team.GetColor(ply:Team())
	end

	local Delay = math.min(1 + (1 / #XPTable),1)


	for k,v in pairs(XPTable) do

		local GlobalTimer = math.Clamp( ((NextRemoveXP - RealTime())*4)/Delay,0,1)

		local Mul = 1

		if k == 1 then
			local Math = GlobalTimer
			Mul = Math
		end

		draw.DrawText(v, "TargetID", ScrW() * 0.5, (ScrH() * 0.85) + (k+(GlobalTimer))*(20), Color( HudColor.r, HudColor.g, HudColor.b, (255 - k*HudColor.a*0.1)*Mul ), TEXT_ALIGN_CENTER )
	end

	if NextRemoveXP <= RealTime() then
		if #XPTable > 0 then
			table.remove(XPTable,1)
		end

		NextRemoveXP = RealTime() + Delay
	end

	if not StoredXP then
		StoredXP = SimpleXPGetXP(ply)
	end

	local CurrentXP = SimpleXPGetXP(ply) or 0
	local Mul = 1

	if CurrentXP > StoredXP then
		if CurrentXP - StoredXP >= 500 then
			Mul = (CurrentXP - StoredXP) * 0.01
		end
		StoredXP = math.min(CurrentXP,StoredXP + (FrameTime() * 200 * Mul))
	elseif CurrentXP < StoredXP then
		if StoredXP - CurrentXP >= 500 then
			Mul = (StoredXP - CurrentXP) * 0.01
		end
		StoredXP = math.max(CurrentXP,StoredXP - (FrameTime() * 200 * Mul))
	end

	local CurrentLevel = SimpleXPCalculateXPToLevel(StoredXP)
	local NextXP = SimpleXPCalculateLevelToXP(CurrentLevel + 1)
	local LastXP = SimpleXPCalculateLevelToXP(CurrentLevel)
	local Number01 = math.floor(StoredXP - LastXP)
	local Number02 = NextXP - LastXP
	local CalcPercent = (CurrentXP - LastXP) / Number02
	local Percent = Number01 / Number02

	local bottom = SimpleXPConfig.HUD_Flip or false
	local xscale = SimpleXPConfig.HUD_Length or 1
	local yscale = SimpleXPConfig.HUD_Pos or 1

	local xsize = ScrW() / 1
	local ysize = 5
	local icon = Material("materials/ig/igxp.png")
	local x = ScrW()/5.5
	local y = ScrH()*0.039

    health_px = ScrW() * 0.77
    health_py = ScrH() * 0.963
    health_sw = 85
    health_sy = ScrH() * 0.015
	if CurrentLevel >= SimpleXPConfig.LevelCap then
		Percent = 1
	end
	--surface.SetDrawColor(Color(255, 255, 255))
	--surface.SetMaterial(icon)
	--surface.DrawTexturedRectRotated(health_px - 12, ScrH()*0.988, ScrW()*0.008333333333333334, ScrH()*0.014814814814814816, 0)
    /*
    local dc = string.Split(vanillaignewdefcon,"")

    local defconcolors = {Color(202, 66, 75, 255), Color(25, 255, 125, 255), Color(255, 140, 69, 255), Color(255, 231, 69, 255)}


	surface.SetDrawColor(Color(50, 50, 50, 200))
	surface.DrawRect(health_px, health_py, health_sw, health_sy)
	surface.SetDrawColor(defconcolors[tonumber(dc[1])])
	surface.DrawRect(health_px, health_py, health_sw*Percent, health_sy)
	draw.SimpleTextOutlined(math.Round(Percent*100,2) .. "%","vanilla_font_info",health_px + 42.5, health_py + 7.5,Color(255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
    */

	--draw.RoundedBox(0,x,y,xsize,ysize,Color(0,128,255,HudColor.a*0.2))
	--draw.RoundedBox(0,x,y,xsize*CalcPercent,ysize,Color(0,255,255,HudColor.a*0.2))
	--draw.RoundedBox(0,x,y,xsize*Percent,ysize,Color(255,255,255,HudColor.a))

	local BottomMul = 1

	if bottom then
		BottomMul = -0.5
	end

	--[[if CurrentLevel < SimpleXPConfig.LevelCap then
		draw.DrawText(Number01.. "XP / " .. Number02 .. "XP" , "IGVANILLAFontO", ScrW() * 0.5, y - 20*BottomMul, HudColor, TEXT_ALIGN_CENTER )
	else
		draw.DrawText(SimpleXPCheckRank(CurrentLevel) , "IGVANILLAFontO", ScrW() * 0.5, y - 20*BottomMul, HudColor, TEXT_ALIGN_CENTER )
	end

	if CurrentLevel < SimpleXPConfig.LevelCap then
		draw.DrawText(SimpleXPCheckRank(CurrentLevel), "IGVANILLAFontO", x, y - 20*BottomMul, HudColor, TEXT_ALIGN_LEFT )
		draw.DrawText(SimpleXPCheckRank(CurrentLevel + 1), "IGVANILLAFontO", x + xsize, y - 20*BottomMul, HudColor, TEXT_ALIGN_RIGHT)
	end

	if NextRemoveLVL > RealTime() then
		draw.DrawText("NEW RANK:", "IGVANILLAFontO", ScrW() * 0.5, ScrH() * 0.4, HudColor, TEXT_ALIGN_CENTER )
		draw.DrawText(SimpleXPCheckRank(SimpleXPGetLevel(ply)), "IGVANILLAFontO", ScrW() * 0.5, ScrH() * 0.4 + 20, HudColor, TEXT_ALIGN_CENTER )
	end]]

end

hook.Add("HUDPaint","Burger Level Draw HUD",SimpleXPDrawHUD)

function SimpleXPPrintLevelsTo(level)

	--local PlayerLevel = SimpleXPGetLevel(LocalPlayer())

	--local Range = 1 + math.max(50,PlayerLevel) - 50

	--level = level + PlayerLevel - 50

	local Start = 1
	local Count = SimpleXPConfig.LevelCap

	if Count > 100 then
		Start = math.max(1,SimpleXPGetLevel(LocalPlayer()) - 50)
		Count = 100
	end

	print("----------------------------------------------------------------------")
	for i=1, SimpleXPConfig.LevelCap do
		local Calc = SimpleXPCalculateLevelToXP(i)
		print("Level " .. i .. ", ",Calc .. "xp, ",SimpleXPCheckRank(i))
	end
	print("----------------------------------------------------------------------")

end

--SimpleXPPrintLevelsTo(100)

function SimpleXPPlayerChat(ply,text,teamChat,isDead)

	if ply == LocalPlayer() then

		local Explode = string.Explode(" ",text)

		if #Explode > 0 then
			if Explode[1] == "!levels" then
				chat.AddText(Color(255,255,255,255),"Information printed to console.")
				SimpleXPPrintLevelsTo(100)
				return true
			elseif Explode[1] == "!xphud" then
				SimpleXPShowDerma()
				return true
			elseif Explode[1] == "!xp" then

				--SimpleXPLeaderboards()


				local White = Color(255,255,255,255)
				local Yellow = Color(255,255,0,255)

				for k,v in pairs(player.GetAll()) do

					local TeamColor = team.GetColor(v:Team())

					chat.AddText(TeamColor,v:Nick(),White," is ",TeamColor,SimpleXPCheckRank(SimpleXPGetLevel(v)),White,"(",tostring(SimpleXPGetXP(v)),"XP)")
				end


				return true
			end
		end

	end

end

hook.Add("OnPlayerChat","Burger Level Player Chat",SimpleXPPlayerChat)

function SimpleXPLeaderboards()

	local XSize = ScrW()*0.5
	local YSize = ScrH()*0.5

	local YOffset = 25

	local BaseFrame = vgui.Create("DFrame")
	BaseFrame:SetSize(XSize,YSize + YOffset*2)
	BaseFrame:Center()
	BaseFrame:MakePopup()

	local ScrollBar = vgui.Create("DScrollPanel",BaseFrame)
	ScrollBar:SetPos(0,0)
	ScrollBar:StretchToParent( 0, 25, 0, 0 )

	local Players = {}

	for i,ply in pairs(player.GetAll()) do
		Players[ply] = SimpleXPGetXP(ply)
	end

	table.SortByKey(Players)

	local Num = 0

	for k,v in pairs(Players) do

		local BasePanel = vgui.Create("DPanel",ScrollBar)
		BasePanel:SetPos(YOffset + 0,YOffset + Num*(128+5))
		BasePanel:SetSize(XSize - YOffset*2,128)

		if k then

			local Name = vgui.Create( "DLabel", BasePanel)
			Name:SetPos(128 + 10, 0)
			Name:SetText( k:Name() )
			Name:SetFont("DermaLarge")
			Name:SetDark(true)
			Name:SizeToContents()

			local Avatar = vgui.Create( "AvatarImage", BasePanel )
			Avatar:SetSize( 128, 128 )
			Avatar:SetPos( 0, 0 )
			Avatar:SetPlayer( k, 128 )

		end

		Num = Num + 1

	end

end



local NextAnnoy  = 0

function SimpleXPChatThink()

	if NextAnnoy <= RealTime() then

		if SimpleXPConfig.DisplayHints == true then
			local White = Color(255,255,255,255)
			local Green = Color(0,255,0,255)

			chat.AddText(White,"We hope you enjoy our new ",Green,"Leveling system!",White,"Good Luck.")
			chat.AddText(White,"Type ",Green,"!xp ",White,"in chat to view all player's current XP.")
			chat.AddText(White,"Type ",Green,"!xphud ",White,"in chat to edit the current XP hud color.")
		end

		NextAnnoy = RealTime() + 4000
	end


end

hook.Add("Think","Burger Level Chat Annoy",SimpleXPChatThink)


function SimpleXPShowDerma()

	local MenuBase = vgui.Create("DFrame")
		MenuBase:SetSize(270,360)
		MenuBase:SetPos(0,0)
		MenuBase:SetTitle("SimpleXP Colors")
		MenuBase:SetDeleteOnClose(false)
		MenuBase:SetDraggable( true )
		MenuBase:SetBackgroundBlur(false)
		MenuBase:Center(true)
		MenuBase:SetVisible( true )
		MenuBase.Paint = function()
			draw.RoundedBox( 8, 0, 0, MenuBase:GetWide(), MenuBase:GetTall(), Color( GetConVarNumber("cl_lvl_color_r"),GetConVarNumber("cl_lvl_color_g"),GetConVarNumber("cl_lvl_color_b"), GetConVarNumber("cl_lvl_color_a") ) )
		end
		MenuBase:MakePopup()

	local Mixer = vgui.Create( "DColorMixer", MenuBase )
		Mixer:SetPos( 5,30 )
		Mixer:SizeToContents()
		Mixer:SetPalette( true ) 		--Show/hide the palette			DEF:true
		Mixer:SetAlphaBar( true ) 		--Show/hide the alpha bar		DEF:true
		Mixer:SetWangs( true )	 		--Show/hide the R G B A indicators 	DEF:true
		Mixer:SetColor( Color( GetConVarNumber("cl_lvl_color_r"),GetConVarNumber("cl_lvl_color_g"),GetConVarNumber("cl_lvl_color_b"), GetConVarNumber("cl_lvl_color_a") ) )--Set the default color

	local ColorButton = vgui.Create( "DButton", MenuBase )
		ColorButton:SetPos( 10, 290 )
		ColorButton:SetSize( 250, 30 )
		ColorButton:SetText( "Apply Color" )
		ColorButton.DoClick = function()
			local col = Mixer:GetColor()
			RunConsoleCommand("cl_lvl_color_r",col.r)
			RunConsoleCommand("cl_lvl_color_g",col.g)
			RunConsoleCommand("cl_lvl_color_b",col.b)
			RunConsoleCommand("cl_lvl_color_a",col.a)
		end

	MenuBase:SizeToContents()

end

concommand.Add("lvl_color", SimpleXPShowDerma)
