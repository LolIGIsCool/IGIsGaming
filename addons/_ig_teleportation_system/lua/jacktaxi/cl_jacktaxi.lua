
/* ----------------------
  -- Script created by --
  ------- Jackool -------
  -- for CoderHire.com --
  -----------------------

  This product has lifetime support and updates.

  Having troubles? Contact Jackool at any time:
  http://steamcommunity.com/id/thejackool
*/
// Localize stuff to keep script running fast
local Taxi,Taxi_SH,math,draw,surface,string = {},Taxi_SH,math,draw,surface,string


util.PrecacheModel("models/kingpommes/starwars/patrol_transport/main.mdl")

/* ============== Font Setup ============== */
Taxi.FontTBL = {
 font = "Arial",
 size = 25,
 weight = 400,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 outline = true
}

surface.CreateFont( "Taxi_Travel", Taxi.FontTBL )

Taxi.TravelFont = Taxi.FontTBL
Taxi.TravelFont.size = 20
surface.CreateFont( "Taxi_TravelN", Taxi.TravelFont )

Taxi.CloseFont = Taxi.FontTBL
Taxi.CloseFont.size = 70
surface.CreateFont( "Taxi_Close", Taxi.CloseFont )

Taxi.TitleFont = Taxi.FontTBL
Taxi.TitleFont.size = 30
Taxi.TitleFont.weight = 800
surface.CreateFont( "Taxi_Title", Taxi.TitleFont )

Taxi.TitleFont = Taxi.FontTBL
Taxi.TitleFont.size = 45
Taxi.TitleFont.weight = 800
surface.CreateFont( "Taxi_TitleBig", Taxi.TitleFont )

Taxi.DescFont = Taxi.FontTBL
Taxi.DescFont.size = 21
Taxi.DescFont.weight = 400
Taxi.DescFont.outline = false
Taxi.DescFont.shadow = true
surface.CreateFont( "Taxi_Desc", Taxi.DescFont )

Taxi.CostFont = Taxi.TitleFont
Taxi.CostFont.outline = false
Taxi.CostFont.shadow = true
Taxi.CostFont.size = 24
surface.CreateFont( "Taxi_Cost", Taxi.CostFont )

/* ============== End Font Setup ============== */

Taxi.Locations = {}
net.Receive("Taxi_Send",function(len) Taxi.Locations = net.ReadTable() end)

Taxi.Gradient = surface.GetTextureID( "gui/gradient" )
Taxi.Image = Material("jacktaxi/imperial_transport.png")
Taxi.Icon = Material("jacktaxi/pin.png")
function Taxi.Menu()
	local B = {}
	local W,H = (Taxi_SH.Width <= 1 and ScrW()*Taxi_SH.Width) or Taxi_SH.Width,(Taxi_SH.Height <= 1 and ScrH()*Taxi_SH.Height) or Taxi_SH.Height

	// Incase people have small ass monitors:
	W = math.Clamp(W,0,ScrW())
	H = math.Clamp(H,0,ScrH())

	local CurLocation,Dist
	for k,v in pairs(Taxi.Locations) do if !Dist or LocalPlayer():GetPos():Distance(v.vec) < Dist then Dist = LocalPlayer():GetPos():Distance(v.vec) CurLocation = k end end

	B.BG = vgui.Create("DFrame")
	B.BG:SetSize(W,H)
	B.BG:MakePopup()
	B.BG:SetPos(-W,ScrH()*.5-(H*.5))
	B.BG:SetTitle("")
	B.BG:ShowCloseButton(false)
	B.BG:SetDraggable(false)
	B.BG.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,220))
		draw.RoundedBox(0,4,4,w-8,h-8,Color(200,200,200,50))

		surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial(Taxi.Image)
		surface.DrawTexturedRect( w*.02, 8, 120, 60 )

		draw.DrawText(Taxi_SH.TitleText, "Taxi_TitleBig", 150, 15, Color(255,255,255,180), TEXT_ALIGN_LEFT)
	end
	local oClose = B.BG.Close
	B.BG.Close = function(s,nounfreeze)
		if s.Closin then return end
		s.Closin = true
		timer.Simple(.5,function() oClose(s) Taxi.View = nil Taxi.Selected = nil end)
		s:MoveTo(ScrW(),ScrH()*.5-(H*.5),.5)
		if !nounfreeze then
			net.Start("Taxi_Close")
			net.SendToServer()
		end
	end
	B.BG:MoveTo(ScrW()*.5-(W*.5),ScrH()*.5-(H*.5),.5)

	// List of locations
	B.Locations = vgui.Create("DPanelList",B.BG)
	B.Locations:SetPos(8,70)
	B.Locations:SetSize(W-16,H-78)
	B.Locations.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
	end
	B.Locations:SetPadding(4)
	B.Locations:SetSpacing(0)
	B.Locations:EnableVerticalScrollbar(true)

	// Close button
	local Hover1
	B.Close = vgui.Create("DButton",B.BG)
	B.Close:SetPos(W-68,6)
	B.Close:SetSize(60,60)
	B.Close.DoClick = function() B.BG:Close() end
	B.Close.Paint = function(s,w,h)
		local Fade = (Hover1 and math.Clamp((CurTime()-Hover1)/.3,0,1)) or 0
		draw.RoundedBox(6,0,0,w,h,Color((70*Fade),(70*Fade),(70*Fade),200))
		draw.SimpleTextOutlined("X", "Taxi_Close", w*.5, h*.52, Color(255,255,255,200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0)
	end
	B.Close:SetText("")
	B.Close.OnCursorEntered = function() Hover1 = CurTime() end
	B.Close.OnCursorExited = function() Hover1 = nil end

	// Travel button. Don't show it until we select a location
	function B.ShowTravel()
		local Hover2
		B.Travel = vgui.Create("DButton",B.BG)
		B.Travel:SetPos(W-192,6)
		B.Travel:SetSize(120,60)
		B.Travel.DoClick = function() B.BG:Close() end
		B.Travel.Paint = function(s,w,h)
			local Fade = (Hover2 and math.Clamp((CurTime()-Hover2)/.3,0,1)) or 0
			draw.RoundedBox(6,0,0,w,h,Color((70*Fade),(70*Fade),(70*Fade),200))
			draw.DrawText("Travel to", "Taxi_Travel", w*.5, h*.01, Color(255,255,255,200),TEXT_ALIGN_CENTER)
			draw.DrawText(Taxi.GoTo, "Taxi_TravelN", w*.5, h*.5, Color(255,255,255,200),TEXT_ALIGN_CENTER)

		end
		B.Travel:SetText("")
		B.Travel.OnCursorEntered = function() Hover2 = CurTime() end
		B.Travel.OnCursorExited = function() Hover2 = nil end
		B.Travel.DoClick = function()
			B.BG.Close(B.BG,true)
			net.Start("Taxi_Go")
				net.WriteString(Taxi.GoTo)
			net.SendToServer()
		end
	end

	local CurNum = -1
	for k,v in pairs(Taxi.Locations) do
		CurNum = CurNum+1
		local Num = CurNum

		local Loc,CurAng,Hover = vgui.Create("DButton"),0
		Loc:SetTall(60)
		Loc:SetText("")
		Loc.Paint = function(s,w,h)
			draw.RoundedBox(4,0,0,w,h,Color(0,0,0,150))

			if Taxi.Selected == k then
				surface.SetDrawColor( 0, 0, 255, 54 )
					surface.SetTexture(Taxi.Gradient)
				surface.DrawTexturedRect( 0, 0, w, h )
			end

			if CurLocation == k then
				surface.SetDrawColor( 0, 255, 0, 54 )
					surface.SetTexture(Taxi.Gradient)
				surface.DrawTexturedRect( 0, 0, w, h )

				draw.DrawText(Taxi_SH.CurLocation, "Taxi_Desc", w-6, 3, Color(255,255,255,200), TEXT_ALIGN_RIGHT )
			end

			local Alpha,RD,BL = 24,255,255
			if Taxi.View == k and CurLocation != k and Taxi.Selected != k then Alpha = 44 end

			surface.SetDrawColor( 255, 255, 255, Alpha )
				surface.SetTexture(Taxi.Gradient)
			surface.DrawTexturedRect( 0, 0, w, h )

			surface.SetDrawColor( 255, 255, 255, 154 )
				surface.SetMaterial(Taxi.Icon)
			surface.DrawTexturedRect( 4, 4, 52, 52 )

			draw.DrawText( k, "Taxi_Title", 70, 0, Color(255,255,255,200), TEXT_ALIGN_LEFT )
			draw.DrawText( v.desc, "Taxi_Desc", 80, 32, Color(255,255,255,200), TEXT_ALIGN_LEFT )
			if v.cost > 0 then draw.DrawText( "$" .. v.cost, "Taxi_Cost", w*.75, 3, Color(255,255,255,200), TEXT_ALIGN_CENTER ) end

			if Hover then CurAng = CurAng+.2 end
		end

		Loc.OnCursorEntered = function()
			Hover = CurTime()
			Taxi.Angle = 0
			CurAng = 0
			Taxi.View = k
		end

		Loc.OnCursorExited = function()
			Taxi.View = nil
			Hover = nil
		end

		Loc.DoClick = function()
			if CurLocation == k then LocalPlayer():ChatPrint("Already at this location.") return end
			Taxi.Selected = k
			Taxi.GoTo = k
			if !B.Travel then B.ShowTravel() end
		end

		B.Locations:AddItem(Loc)
	end

end
net.Receive("Taxi_Menu",Taxi.Menu)

Taxi.Angle = 0
hook.Add("CalcView","Show taxi locations",function(ply, pos, ang, fov)
	if Taxi.View and Taxi.Locations[Taxi.View] then
		Taxi.Angle = Taxi.Angle+.2
		local Info,CamAng,view = Taxi.Locations[Taxi.View],Angle(25,Taxi.Angle,0),{}

		view.origin = util.TraceLine({start = Info.vec, endpos = Info.vec-(CamAng:Forward()*300), mask = MASK_SOLID_BRUSHONLY}).HitPos+(CamAng:Forward()*50)
		view.angles = CamAng
		view.fov = 70

		return view
	end
end)

hook.Add("ShouldDrawLocalPlayer","Show self at taxi",function()
	if Taxi.View then return true end
end)

function Taxi.AddLocation()
	local B,Pos,Ang = {},LocalPlayer():GetEyeTrace().HitPos,Angle(0,LocalPlayer():EyeAngles().y,0)

	local Ghost = ents.CreateClientProp("models/kingpommes/starwars/patrol_transport/main.mdl")
	Ghost:SetModel("models/kingpommes/starwars/patrol_transport/main.mdl")
	Ghost:SetPos(Pos)
	Ghost:SetAngles(Ang)
	Ghost:Spawn()

	B.BG = vgui.Create("DFrame")
	B.BG:SetSize(300,300)
	B.BG:Center()
	B.BG.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,180))
		draw.RoundedBox(0,4,4,w-8,50,Color(200,200,200,100))
		draw.DrawText("Add a dropship location\n where you are looking", "Taxi_Travel", w*.5, 2, Color(255,255,255,200),TEXT_ALIGN_CENTER)

		draw.DrawText("Name", "Taxi_Travel", w*.5, 56, Color(255,255,255,200),TEXT_ALIGN_CENTER)

		draw.DrawText("Description", "Taxi_Travel", w*.5, 113, Color(255,255,255,200),TEXT_ALIGN_CENTER)

		draw.DrawText("Cost (0 for non-DarkRP)", "Taxi_Travel", w*.5, 172, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.BG:MakePopup()
	B.BG:SetTitle("")
	B.BG:ShowCloseButton(false)

	local oClose = B.BG.Close
	B.BG.Close = function(s,nounfreeze)
		if s.Closin then return end
		s.Closin = true
		Ghost:Remove()
		timer.Simple(.5,function() oClose(s) end)
		s:MoveTo(ScrW(),ScrH()*.5-(B.BG:GetTall()*.5),.5)
	end

	B.Name = vgui.Create("DTextEntry",B.BG)
	B.Name:SetPos(4,81)
	B.Name:SetSize(292,30)
	B.Name.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(200,200,200,100))
		s:DrawTextEntryText(Color(0,0,0),Color(30,130,255),Color(0,0,0))
	end

	B.Desc = vgui.Create("DTextEntry",B.BG)
	B.Desc:SetPos(4,140)
	B.Desc:SetSize(292,30)
	B.Desc.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(200,200,200,100))
		s:DrawTextEntryText(Color(0,0,0),Color(30,130,255),Color(0,0,0))
	end

	B.Cost = vgui.Create("DTextEntry",B.BG)
	B.Cost:SetPos(4,199)
	B.Cost:SetSize(292,30)
	B.Cost.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(200,200,200,100))
		s:DrawTextEntryText(Color(0,0,0),Color(30,130,255),Color(0,0,0))
	end

	local InAdd
	B.Add = vgui.Create("DButton",B.BG)
	B.Add:SetPos(4,250)
	B.Add:SetSize(134,42)
	B.Add.Paint = function(s,w,h)
		local Fade = (InAdd and math.Clamp((CurTime()-InAdd)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Confirm", "Taxi_Travel", w*.5, 8, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Add:SetText("")
	B.Add.OnCursorEntered = function() InAdd = CurTime() end
	B.Add.OnCursorExited = function() InAdd = nil end
	B.Add.DoClick = function()
		local Name,Desc,Cost = B.Name:GetValue(),B.Desc:GetValue(),B.Cost:GetValue()
		if !Name or !Desc or !Cost or Name == "" or Desc == "" or Cost == "" then LocalPlayer():ChatPrint("You forgot to a field for the taxi addition!") return end

		net.Start("Taxi_Add")
			net.WriteString(Name)
			net.WriteTable({[1]=Pos.x,[2]=Pos.y,[3]=Pos.z})
			net.WriteFloat(tonumber(Cost))
			net.WriteString(Desc)
		net.SendToServer()

		B.BG:Close()
	end

	local InCancel
	B.Cancel = vgui.Create("DButton",B.BG)
	B.Cancel:SetPos(158,250)
	B.Cancel:SetSize(134,42)
	B.Cancel.Paint = function(s,w,h)
		local Fade = (InCancel and math.Clamp((CurTime()-InCancel)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Cancel", "Taxi_Travel", w*.5, 8, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Cancel:SetText("")
	B.Cancel.OnCursorEntered = function() InCancel = CurTime() end
	B.Cancel.OnCursorExited = function() InCancel = nil end
	B.Cancel.DoClick = function() B.BG:Close() end
end

function Taxi.Remove()
	local B = {}

	B.BG = vgui.Create("DFrame")
	B.BG:SetSize(300,130)
	B.BG:Center()
	B.BG:SetTitle("")
	B.BG.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,180))
		draw.RoundedBox(0,4,4,w-8,50,Color(200,200,200,100))
		draw.DrawText("Select a location\nto remove", "Taxi_Travel", w*.5, 2, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.BG:ShowCloseButton(false)
	B.BG:MakePopup()
	local oClose = B.BG.Close
	B.BG.Close = function(s,nounfreeze)
		if s.Closin then return end
		s.Closin = true
		timer.Simple(.5,function() oClose(s) end)
		s:MoveTo(ScrW(),ScrH()*.5-(B.BG:GetTall()*.5),.5)
	end

	local Name
	B.Locate = vgui.Create("DComboBox",B.BG)
	B.Locate:SetPos(4,58)
	B.Locate:SetSize(292,30)
	for k,v in pairs(Taxi.Locations) do
		B.Locate:AddChoice(k)
	end
	B.Locate.OnSelect = function(__,____,val ) Name = val end

	local InAdd
	B.Add = vgui.Create("DButton",B.BG)
	B.Add:SetPos(4,94)
	B.Add:SetSize(134,32)
	B.Add.Paint = function(s,w,h)
		local Fade = (InAdd and math.Clamp((CurTime()-InAdd)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Confirm", "Taxi_Travel", w*.5, 4, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Add:SetText("")
	B.Add.OnCursorEntered = function() InAdd = CurTime() end
	B.Add.OnCursorExited = function() InAdd = nil end
	B.Add.DoClick = function()
		if !Name or Name == "" then LocalPlayer():ChatPrint("Choose an option") return end

		net.Start("Taxi_Remove")
			net.WriteString(Name)
		net.SendToServer()

		B.BG:Close()
	end

	local InCancel
	B.Cancel = vgui.Create("DButton",B.BG)
	B.Cancel:SetPos(162,94)
	B.Cancel:SetSize(134,32)
	B.Cancel.Paint = function(s,w,h)
		local Fade = (InCancel and math.Clamp((CurTime()-InCancel)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Cancel", "Taxi_Travel", w*.5, 4, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Cancel:SetText("")
	B.Cancel.OnCursorEntered = function() InCancel = CurTime() end
	B.Cancel.OnCursorExited = function() InCancel = nil end
	B.Cancel.DoClick = function() B.BG:Close() end
end

function Taxi.Admin()
	local B = {}

	B.BG = vgui.Create("DFrame")
	B.BG:SetSize(300,140)
	B.BG:SetPos(-300,ScrH()*.5-(B.BG:GetTall()*.5),.5)
	B.BG:SetTitle("")
	B.BG.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,180))
		draw.RoundedBox(0,4,4,w-8,23,Color(200,200,200,100))
		draw.DrawText("Select an action", "Taxi_Travel", w*.5, 2, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.BG:MakePopup()
	B.BG:ShowCloseButton(false)
	B.BG:MoveTo(ScrW()*.5-150,ScrH()*.5-(B.BG:GetTall()*.5),.5)
	local oClose = B.BG.Close
	B.BG.Close = function(s,nounfreeze)
		if s.Closin then return end
		s.Closin = true
		timer.Simple(.5,function() oClose(s) end)
		s:MoveTo(ScrW(),ScrH()*.5-(B.BG:GetTall()*.5),.5)
	end
	B.BG:SetDraggable(false)

	local InAdd
	B.Add = vgui.Create("DButton",B.BG)
	B.Add:SetPos(4,31)
	B.Add:SetSize(292,32)
	B.Add.Paint = function(s,w,h)
		local Fade = (InAdd and math.Clamp((CurTime()-InAdd)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Add Taxi at eye position", "Taxi_Travel", w*.5, 4, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Add:SetText("")
	B.Add.OnCursorEntered = function() InAdd = CurTime() end
	B.Add.OnCursorExited = function() InAdd = nil end
	B.Add.DoClick = function() Taxi.AddLocation() oClose(B.BG) end

	local InRem
	B.Rem = vgui.Create("DButton",B.BG)
	B.Rem:SetPos(4,67)
	B.Rem:SetSize(292,32)
	B.Rem.Paint = function(s,w,h)
		local Fade = (InRem and math.Clamp((CurTime()-InRem)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Remove taxi", "Taxi_Travel", w*.5, 4, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Rem:SetText("")
	B.Rem.OnCursorEntered = function() InRem = CurTime() end
	B.Rem.OnCursorExited = function() InRem = nil end
	B.Rem.DoClick = function() Taxi.Remove() oClose(B.BG) end

	local InCancel
	B.Cancel = vgui.Create("DButton",B.BG)
	B.Cancel:SetPos(4,103)
	B.Cancel:SetSize(292,32)
	B.Cancel.Paint = function(s,w,h)
		local Fade = (InCancel and math.Clamp((CurTime()-InCancel)/.3,0,1)) or 0
		draw.RoundedBox(0,0,0,w,h,Color(200-(Fade*60),200-(Fade*60),200-(Fade*60),100+(Fade*60)))
		draw.DrawText("Cancel", "Taxi_Travel", w*.5, 4, Color(255,255,255,200),TEXT_ALIGN_CENTER)
	end
	B.Cancel:SetText("")
	B.Cancel.OnCursorEntered = function() InCancel = CurTime() end
	B.Cancel.OnCursorExited = function() InCancel = nil end
	B.Cancel.DoClick = function() B.BG:Close() end
end
net.Receive("Taxi_Admin",Taxi.Admin)

net.Receive("Taxi_Black",function(len)
	local Start = CurTime()
	local Black = vgui.Create("DFrame")
	Black:SetPos(0,0)
	Black:SetSize(ScrW(),ScrH())
	Black:ShowCloseButton(false)
	Black:SetDraggable(false)
	Black:SetTitle("")
	Black.Paint = function(s,w,h)
		local Fade = 1
		if CurTime()-Start < 2 then
			Fade = math.Clamp((CurTime()-Start)/(Taxi_SH.TeleTime*.4),0,1)
		elseif CurTime()-Start > 2.7 then
			Fade = 1-math.Clamp((CurTime()-(Start+(Taxi_SH.TeleTime*.6)))/2,0,1)
		end
		draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,255*Fade))
	end

	timer.Simple(Taxi_SH.TeleTime,function()
		Black:Remove()
	end)
end)
