include("shared.lua")

net.Receive("ig_pl_terminal_open", function()
	local pltable = net.ReadTable()
	
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
			draw.DrawText("Imperial Pilot License Database", "IG_Dynamic_Title", w/2,40, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		local sheet = vgui.Create("DColumnSheet",frame)
			sheet:SetPos(10,90)
			sheet:SetSize(970,565)
			
			local LogsMenu = vgui.Create("DPanel")
				LogsMenu:SetSize(900,600)
				sheet:AddSheet("PL Logs",LogsMenu)
				LogsMenu.Paint = function( self, w, h )
					draw.RoundedBox( 4, 0, 0, w, h, Color( 76, 86, 106 ) )
					draw.DrawText("Imperial Pilot License Database", "IG_Dynamic_Title", 10,10, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

				local logsscreen = vgui.Create( "DListView", LogsMenu )
					logsscreen:SetPos(10, 70)
					logsscreen:SetSize(830,485)
					logsscreen:SetMultiSelect( false )
						logsscreen:AddColumn("Rank")
						logsscreen:AddColumn("Name")
						logsscreen:AddColumn("Regiment")
						logsscreen:AddColumn("SteamID")
						logsscreen:AddColumn("License")
							for k,v in pairs(pltable) do
								logsscreen:AddLine(v["Rank"],v["Name"],v["Regiment"], v["SteamID"], v["License"])
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
							for k,v in pairs(pltable) do
								logsscreen:AddLine(v["Rank"],v["Name"],v["Regiment"], v["SteamID"], v["License"])
							end
						else
							for k,v in pairs(pltable) do
								if string.find(v["SteamID"], tempsearchid) then
									logsscreen:AddLine(v["Rank"],v["Name"],v["Regiment"], v["SteamID"], v["License"])
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
							for k,v in pairs(pltable) do
								logsscreen:AddLine(v["Rank"],v["Name"],v["Regiment"], v["SteamID"], v["License"])
							end
						else
							for k,v in pairs(pltable) do
								if string.find(v["Name"], tempsearch) then
									logsscreen:AddLine(v["Rank"],v["Name"],v["Regiment"], v["SteamID"], v["License"])
								end
							end
						end
					end

		local frameheader = vgui.Create("DLabel", frame)
			frameheader:SetPos(15,0)
			frameheader:SetSize(350,40)
			frameheader:SetText("Imperial Gaming | Pilot License System")
			frameheader:SetColor(Color(255, 255, 255))

		local buttonmainclose = vgui.Create("DButton", frame)
			buttonmainclose:SetSize(100,20)
			buttonmainclose:SetText("Close Menu")
			buttonmainclose:SetPos(20, 130)

			buttonmainclose.DoClick = function()
				frame:Close()
			end

end)