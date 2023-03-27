include("shared.lua")

surface.CreateFont("IG_Dynamic_Title", {
	font = "Arial",
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("IG_Dynamic_Sub", {
	font = "Arial",
	extended = false,
	size = 25,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("IG_Dynamic_Text", {
	font = "Arial",
	extended = false,
	size = 15,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

function ENT:Draw()
	self:DrawModel()
	local pos = self:LocalToWorld(Vector(0, 0, 0))
	local ang = self:LocalToWorldAngles(Angle(0, 270, 90))

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetDrawColor(24, 31, 41,220)
    	surface.DrawRect(-200, -650, 400, 100)
    	draw.SimpleText("RFA Console", "IG_Dynamic_Title", 0, -600, Color(255,255,255), 1, 1)
	cam.End3D2D()
end

net.Receive("ig_rfa_open", function()
	local lply = net.ReadEntity()
	local size = net.ReadUInt(32)
	local jsoncom = net.ReadData(size)
	local jsondecom = util.Decompress(jsoncom)
	local rfatable = util.JSONToTable(jsondecom)

	local temp = {
		officer = lply:Name(),
		sksid = lply:SteamID(),
		offender = "",
		offsid = "",
		offreg = "",
		offrank = "",
		offence = "",
		note = "",
		isb = false,
		confirm = false
	}

	local cell = "0"

	local tempsearch = ""
	local tempsearchid = ""

	local rfareasons = {
		["One"] = {
			"LC-01 Trespassing",
			"LC-02 Loitering",
			"LC-03 Disrespect",
			"LC-04 Defacing, Theft or Destruction of Personal Property",
			"LC-05 Misuse of Imperial Equipment",
			"LC-06 Discharging a Weapon Unlawfully",
			"LC-07 Weapon out on Inappropriate DEFCON",
			"LC-08 Operating a Vehicle Illegally or without a License",
		},
		["Two"] = {
			"HC-01 Orders from Command Staff",
			"HC-02 Corruption",
			"HC-03 Murder / Attempted Murder",
			"HC-04 Kidnapping",
			"HC-05 Assault",
			"HC-06 Aiding and Abetting",
			"HC-07 Insubordination",
			"HC-08 Impersonation",
			"HC-09 Misconduct",
			"HC-10 Posession or Distribution of Contraband or Narcotics",
			"HC-11 Defacing, Theft or Destruction of Imperial Property",
			"HC-12 Obstruction of Imperial Justice",
			"HC-13 Animal Cruelty",
		},
		["Three"] = {
			"CAE-01 High Treason",
			"CAE-02 Treason",
			"CAE-03 Petty Treason",
			"CAE-04 Terrorism",
			"CAE-05 Sedition",
			"CAE-06 War Crimes",
			"CAE-07 Unauthorised Access or Disclosure of Classified Material",
		},
	}
	   
	local frame = vgui.Create("DFrame")
		frame:SetSize(1000, 675)
		frame:Center()
		frame:SetVisible(true)
		frame:MakePopup()
		frame:ShowCloseButton(false)
		frame:SetTitle("")

		frame.Paint = function( self, w, h )	
			draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
			draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
			draw.RoundedBox(0,10,80,980,585,Color(67, 76, 94))
			draw.DrawText("Imperial Arrest Database", "IG_Dynamic_Title", w/2,40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		local sheet = vgui.Create("DColumnSheet",frame)
			sheet:SetPos(10,90)
			sheet:SetSize(970,565)
			
			local AutoMenu = vgui.Create("DPanel")
				AutoMenu:SetSize(900,600)
				sheet:AddSheet("Automatic RFA",AutoMenu)
				AutoMenu.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.DrawText("Automatic RFA MENU", "IG_Dynamic_Title", 10,10, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Select Offender:", "IG_Dynamic_Text", 10,50, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Select Offence:", "IG_Dynamic_Text", 530,50, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Extra Notes:", "IG_Dynamic_Text", 530,120, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Cell:", "IG_Dynamic_Text", 530,230, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Should ISB be notified:", "IG_Dynamic_Text", 530,310, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("All Details are true:", "IG_Dynamic_Text", 530,340, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local offender = vgui.Create( "DListView", AutoMenu )
					offender:SetPos(10, 70)
					offender:SetSize(500,485)
					offender:SetMultiSelect( false )
						offender:AddColumn("Offender")
						offender:AddColumn("Regiment")
						offender:AddColumn("Rank")
						offender:AddColumn("SteamID")
							for k,v in pairs(player.GetAll()) do
								offender:AddLine(v:Nick(), v:GetRegiment(), v:GetRankName(), v:SteamID())
							end
						offender.OnRowSelected = function( lst, index, pnl )
							temp.offender = pnl:GetColumnText( 1 )
							temp.offsid = pnl:GetColumnText( 4 )
							temp.offreg = pnl:GetColumnText( 2 )
							temp.offrank = pnl:GetColumnText( 3 )
						end

				local offence = vgui.Create( "DComboBox", AutoMenu )
					offence:SetPos(530, 70)
					offence:SetSize(310,40)
					offence:SetSortItems(false)
					offence:SetValue( "Select Offence" )
						for k,v in pairs(rfareasons["One"]) do
							offence:AddChoice(v)
						end
						for k,v in pairs(rfareasons["Two"]) do
							offence:AddChoice(v)
						end
						for k,v in pairs(rfareasons["Three"]) do
							offence:AddChoice(v)
						end
					offence.OnSelect = function( self, index, value )
						temp.offence = value
					end
				local extranotes = vgui.Create( "DTextEntry", AutoMenu )
					extranotes:SetPos(530, 140)
					extranotes:SetSize(310,80)
					extranotes:SetValue("Extra Notes")
					extranotes:SetMultiline(true)
					extranotes.OnChange = function( self, value )
						temp.note = self:GetValue()
					end
				local offcell = vgui.Create( "DComboBox", AutoMenu )
					offcell:SetPos(530, 250)
					offcell:SetSize(310,40)
					offcell:SetSortItems(false)
					offcell:SetValue( "Select Cell" )
						for i=1,12 do 
							offcell:AddChoice(i)
						end 
					offcell.OnSelect = function( self, index, value )
						cell = value
					end
				local isbcheckbox = vgui.Create( "DCheckBox", AutoMenu ) 
					isbcheckbox:SetPos(660, 309)	
					isbcheckbox:SetSize(20,20)					
					isbcheckbox:SetText("")								
					isbcheckbox:SetValue( false )	

					function isbcheckbox:OnChange(bVal)
						if (bVal) then
							temp.isb = true
						else
							temp.isb = false
						end
					end
				local truecheckbox = vgui.Create( "DCheckBox", AutoMenu ) 
					truecheckbox:SetPos(660, 339)	
					truecheckbox:SetSize(20,20)					
					truecheckbox:SetText("")								
					truecheckbox:SetValue( false )	

					function truecheckbox:OnChange(bVal)
						if (bVal) then
							temp.confirm = true
						else
							temp.confirm = false
						end
					end
				local buttonsubmit = vgui.Create("DButton", AutoMenu)
					buttonsubmit:SetSize(310,45)
					buttonsubmit:SetText("Submit RFA")
					buttonsubmit:SetPos(530, 515)
					buttonsubmit:SetTextColor( Color( 236, 239, 244) )

					buttonsubmit.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					end

					buttonsubmit.DoClick = function()
						if temp.offender == "" or temp.offence == "" or temp.confirm == false or cell == "0" then
							chat.AddText("Please fill out all parts of the form (Optional: Extra notes)")
						else
							local level = ""
							local offlevel = ""
							if table.HasValue(rfareasons["One"], temp.offence) then
								level = "LC"
								for i = 1, #rfareasons["One"] do
									if rfareasons["One"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							elseif table.HasValue(rfareasons["Two"], temp.offence) then
								level = "HC"
								for i = 1, #rfareasons["Two"] do
									if rfareasons["Two"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							elseif table.HasValue(rfareasons["Three"], temp.offence) then
								level = "CAE"
								for i = 1, #rfareasons["Three"] do
									if rfareasons["Three"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							end
							
							RunConsoleCommand( "say", "/comms [RFA] "..temp.offender.." | C"..cell.." | "..level.."-"..offlevel)
							
							net.Start("ig_rfa_recieve")
								net.WriteTable(temp)
							net.SendToServer()
							frame:Close()
						end
					end

			local ManMenu = vgui.Create("DPanel")
				ManMenu:SetSize(900,600)
				sheet:AddSheet("Manual RFA",ManMenu)
				ManMenu.Paint = function( self, w, h )
					draw.RoundedBox( 0, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.DrawText("Manual RFA MENU", "IG_Dynamic_Title", 10,10, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Offender Name:", "IG_Dynamic_Text", 10,50, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Offender SteamID:", "IG_Dynamic_Text", 10,100, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Offender Rank:", "IG_Dynamic_Text", 10,150, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Offender Regiment:", "IG_Dynamic_Text", 10,200, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Select Offence:", "IG_Dynamic_Text", 10,250, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Extra Notes:", "IG_Dynamic_Text", 10,300, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Cell:", "IG_Dynamic_Text", 10,350, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Should ISB be notified:", "IG_Dynamic_Text", 10,400, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("All Details are true:", "IG_Dynamic_Text", 10,430, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local textname = vgui.Create( "DTextEntry", ManMenu )
					textname:SetPos(10, 65)
					textname:SetSize(310,25)
					textname:SetValue("Enter offender Name")
					textname:SetMultiline(false)
					textname.OnChange = function( self, value )
						temp.offender = self:GetValue()
					end
				local textsid = vgui.Create( "DTextEntry", ManMenu )
					textsid:SetPos(10, 115)
					textsid:SetSize(310,25)
					textsid:SetValue("Enter offender SteamID")
					textsid:SetMultiline(false)
					textsid.OnChange = function( self, value )
						temp.offsid = self:GetValue()
					end
				local textrank = vgui.Create( "DTextEntry", ManMenu )
					textrank:SetPos(10, 165)
					textrank:SetSize(310,25)
					textrank:SetValue("Enter offender Rank")
					textrank:SetMultiline(false)
					textrank.OnChange = function( self, value )
						temp.offrank = self:GetValue()
					end
				local textregiment = vgui.Create( "DTextEntry", ManMenu )
					textregiment:SetPos(10, 215)
					textregiment:SetSize(310,25)
					textregiment:SetValue("Enter offender Regiment")
					textregiment:SetMultiline(false)
					textregiment.OnChange = function( self, value )
						temp.offreg = self:GetValue()
					end
				local offence = vgui.Create( "DComboBox", ManMenu )
					offence:SetPos(10, 265)
					offence:SetSize(310,25)
					offence:SetSortItems(false)
					offence:SetValue( "Select Offence" )
						for k,v in pairs(rfareasons["One"]) do
							offence:AddChoice(v)
						end
						for k,v in pairs(rfareasons["Two"]) do
							offence:AddChoice(v)
						end
						for k,v in pairs(rfareasons["Three"]) do
							offence:AddChoice(v)
						end
					offence.OnSelect = function( self, index, value )
						temp.offence = value
					end
				local extranotes = vgui.Create( "DTextEntry", ManMenu )
					extranotes:SetPos(10, 315)
					extranotes:SetSize(310,25)
					extranotes:SetValue("Extra Notes")
					extranotes:SetMultiline(false)
					extranotes.OnChange = function( self, value )
						temp.note = self:GetValue()
					end
				local offcell = vgui.Create( "DComboBox", ManMenu )
					offcell:SetPos(10, 365)
					offcell:SetSize(310,25)
					offcell:SetSortItems(false)
					offcell:SetValue( "Select Cell" )
						for i=1,12 do 
							offcell:AddChoice(i)
						end 
					offcell.OnSelect = function( self, index, value )
						cell = value
					end
				local isbcheckbox = vgui.Create( "DCheckBox", ManMenu ) 
					isbcheckbox:SetPos(145, 399)	
					isbcheckbox:SetSize(20,20)					
					isbcheckbox:SetText("")								
					isbcheckbox:SetValue( false )	

					function isbcheckbox:OnChange(bVal)
						if (bVal) then
							temp.isb = true
						else
							temp.isb = false
						end
					end
				local truecheckbox = vgui.Create( "DCheckBox", ManMenu ) 
					truecheckbox:SetPos(145, 429)	
					truecheckbox:SetSize(20,20)					
					truecheckbox:SetText("")								
					truecheckbox:SetValue( false )	
					function truecheckbox:OnChange(bVal)
						if (bVal) then
							temp.confirm = true
						else
							temp.confirm = false
						end
					end
				local buttonsubmit = vgui.Create("DButton", ManMenu)
					buttonsubmit:SetSize(310,45)
					buttonsubmit:SetText("Submit RFA")
					buttonsubmit:SetPos(10, 465)
					buttonsubmit:SetTextColor( Color( 236, 239, 244) )

					buttonsubmit.Paint = function( self, w, h )
						draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					end

					buttonsubmit.DoClick = function()
						if temp.offender == "" or temp.offence == "" or temp.confirm == false or cell == "0" then
							chat.AddText("Please fill out all parts of the form (Optional: Extra notes)")
						else
							local level = ""
							local offlevel = ""
							if table.HasValue(rfareasons["One"], temp.offence) then
								level = "1"
								for i = 1, #rfareasons["One"] do
									if rfareasons["One"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							elseif table.HasValue(rfareasons["Two"], temp.offence) then
								level = "2"
								for i = 1, #rfareasons["Two"] do
									if rfareasons["Two"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							elseif table.HasValue(rfareasons["Three"], temp.offence) then
								level = "3"
								for i = 1, #rfareasons["Three"] do
									if rfareasons["Three"][i] == temp.offence then
										offlevel = tostring(i)
									end
								end
							end
							
							RunConsoleCommand( "say", "/comms [RFA] "..temp.offender.." | C"..cell.." | "..level.."-"..offlevel)
							
							net.Start("ig_rfa_recieve")
								net.WriteTable(temp)
							net.SendToServer()
							frame:Close()
						end
					end

			local LogsMenu = vgui.Create("DPanel")
				LogsMenu:SetSize(900,600)
				sheet:AddSheet("RFA Logs",LogsMenu)
				LogsMenu.Paint = function( self, w, h )
					draw.RoundedBox( 4, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.DrawText("RFA Log Menu", "IG_Dynamic_Title", 10,10, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end
				local logsscreen = vgui.Create( "DListView", LogsMenu )
					logsscreen:SetPos(10, 70)
					logsscreen:SetSize(830,485)
					logsscreen:SetMultiSelect( false )
						logsscreen:AddColumn("Timestamp")
						logsscreen:AddColumn("Processing Officer")
						logsscreen:AddColumn("Offender's Name")
						logsscreen:AddColumn("Rank")
						logsscreen:AddColumn("Regiment")
						logsscreen:AddColumn("SteamID")
						logsscreen:AddColumn("Offence")
						logsscreen:AddColumn("Extra Info")
						logsscreen:AddColumn("ISB Notification")
							for k,v in pairs(rfatable) do
								logsscreen:AddLine(v["time"], v["officer"], v["oname"], v["orank"], v["oregiment"], v["osid"], v["ooffence"], v["note"], v["isb"])
							end

				local sidsearchbar = vgui.Create( "DTextEntry", LogsMenu )
					sidsearchbar:SetPos(530, 35)
					sidsearchbar:SetSize(310,20)
					sidsearchbar:SetValue("Search for SteamID")
					sidsearchbar:SetMultiline(false)
					sidsearchbar.OnChange = function( self, value )
						tempsearchid = self:GetValue()
						logsscreen:Clear()
						if tempsearchid == "" then
							for k,v in pairs(rfatable) do
								logsscreen:AddLine(v["time"], v["officer"], v["oname"], v["orank"], v["oregiment"], v["osid"], v["ooffence"], v["note"], v["isb"])
							end
						else
							for k,v in pairs(rfatable) do
								if string.find(v["osid"], tempsearchid) then
									logsscreen:AddLine(v["time"], v["officer"], v["oname"], v["orank"], v["oregiment"], v["osid"], v["ooffence"], v["note"], v["isb"])
								end
							end
						end
					end

				local snsearchbar = vgui.Create( "DTextEntry", LogsMenu )
					snsearchbar:SetPos(530, 10)
					snsearchbar:SetSize(310,20)
					snsearchbar:SetValue("Search for Name")
					snsearchbar:SetMultiline(false)
					snsearchbar.OnChange = function( self, value )
						tempsearch = self:GetValue()
						logsscreen:Clear()
						if tempsearch == "" then
							for k,v in pairs(rfatable) do
								logsscreen:AddLine(v["time"], v["officer"], v["oname"], v["orank"], v["oregiment"], v["osid"], v["ooffence"], v["note"], v["isb"])
							end
						else
							for k,v in pairs(rfatable) do
								if string.find(v["oname"], tempsearch) then
									logsscreen:AddLine(v["time"], v["officer"], v["oname"], v["orank"], v["oregiment"], v["osid"], v["ooffence"], v["note"], v["isb"])
								end
							end
						end
					end

		local frameheader = vgui.Create("DLabel", frame)
			frameheader:SetPos(15,0)
			frameheader:SetSize(350,40)
			frameheader:SetText("Imperial Gaming | Loadout System")
			frameheader:SetColor(Color(255, 255, 255))

		local buttonmainclose = vgui.Create("DButton", frame)
			buttonmainclose:SetSize(100,20)
			buttonmainclose:SetText("Close Menu")
			buttonmainclose:SetPos(20, 170)

			buttonmainclose.DoClick = function()
				frame:Close()
			end

end)