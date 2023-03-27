if SERVER then
	return
else
	net.Receive("IG_LOADOUT_ADMIN_EDIT_OPEN", function()
		-- Tables
			-- Import Tables
            	local bytes1 = net.ReadUInt(16);
				local RegimentsTableImport = util.JSONToTable(util.Decompress(net.ReadData(bytes1)))

			-- ByPass Tables
            	local bytes2 = net.ReadUInt(16);
				local BypassTable = util.JSONToTable(util.Decompress(net.ReadData(bytes2)))
				local newBypass = {}
				for k,v in pairs(RegimentsTableImport) do
					if not table.HasValue(BypassTable, v) then
						table.insert(newBypass, v)
					end
				end

			-- Regiment Loadout Tables
            	local bytes3 = net.ReadUInt(16);
				local RegimentLoadoutTable = util.JSONToTable(util.Decompress(net.ReadData(bytes3)))
				local CurrentRegimentTable = {}
				local MissingRegimentTable = {}
					local i = 0
				    for k, v in pairs(RegimentLoadoutTable) do
				    	i = i + 1
				        table.insert(CurrentRegimentTable, table.GetKeys(RegimentLoadoutTable[i])[1])
				    end
				    for k, v in pairs(RegimentsTableImport) do
				    	if not table.HasValue(CurrentRegimentTable, v) then
							table.insert(MissingRegimentTable, v)
						end
				    end

			-- Universal Item Tables
            	local bytes4 = net.ReadUInt(16);
				local UniversalItemImport = util.JSONToTable(util.Decompress(net.ReadData(bytes4)))

		local frame = vgui.Create("DFrame")
			frame:SetSize(1100,900)
			frame:MakePopup()
			frame:Center()
			frame:SetTitle("Dynamic Loadout Admin Menu")

		local sheet = vgui.Create( "DPropertySheet", frame )
			sheet:Dock( FILL )

		local PanelRefresh = vgui.Create( "DPanel", sheet )
			PanelRefresh.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end 
			sheet:AddSheet("Regiment Refresh", PanelRefresh)
			local newregiments = vgui.Create("DListView", PanelRefresh)
				newregiments:SetSize(400,700)
				newregiments:SetPos(15,15)
				newregiments:SetMultiSelect( false )
				newregiments:AddColumn( "Missing Regiments" )
				for k,v in pairs(MissingRegimentTable) do
					newregiments:AddLine(v)
				end
			local oldregiments = vgui.Create("DListView", PanelRefresh)
				oldregiments:SetSize(400,700)
				oldregiments:SetPos(660,15)
				oldregiments:SetMultiSelect( false )
				oldregiments:AddColumn( "Current Regiments" )
				for k,v in pairs(CurrentRegimentTable) do
					oldregiments:AddLine(v)
				end
			local RefreshButton = vgui.Create( "DButton", PanelRefresh )
				RefreshButton:SetText( "Refresh Regiments" )
				RefreshButton:SetPos( 437, 150 )
				RefreshButton:SetSize( 200, 30 )
				RefreshButton.DoClick = function()
					for k,v in pairs(MissingRegimentTable) do
						table.insert(CurrentRegimentTable, v)
					end
					oldregiments:Clear()
					newregiments:Clear()
					for k,v in pairs(CurrentRegimentTable) do
						oldregiments:AddLine(v)
					end
					net.Start("IG_LOADOUT_ADMIN_SAVE_REFRESH")
						net.WriteTable(MissingRegimentTable)
					net.SendToServer()
					chat.AddText(Color(52, 107, 235), "[DYNAMIC LOADOUTS] ", Color(255, 255, 255), "Refreshing Reigments...")
				end

		local PanelBypass = vgui.Create( "DPanel", sheet )
			PanelBypass.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 118,121,124,0) ) end 
			sheet:AddSheet("Bypass Regiments", PanelBypass)

			local tempaddreg = ""
			local tempaddindex = 0

			local tempremreg = ""
			local tempremindex = 0

			local newregiments = vgui.Create("DListView", PanelBypass)
				newregiments:SetSize(400,700)
				newregiments:SetPos(15,15)
				newregiments:SetMultiSelect( false )
				newregiments:AddColumn( "Regiment List" )
				newregiments.OnRowSelected = function(panel, rowIndex, row)
					tempaddreg = row:GetValue(1)
					tempaddindex = rowIndex
				end
				for k,v in pairs(newBypass) do
					newregiments:AddLine(v)
				end

			local bypassregiments = vgui.Create("DListView", PanelBypass)
				bypassregiments:SetSize(400,700)
				bypassregiments:SetPos(660,15)
				bypassregiments:SetMultiSelect( false )
				bypassregiments:AddColumn( "Bypass Regiment List" )
				bypassregiments.OnRowSelected = function(panel, rowIndex, row)
					tempremreg = row:GetValue(1)
					tempremindex = rowIndex
				end

				for k,v in pairs(BypassTable) do
					bypassregiments:AddLine(v)
				end

			local AddRegimentButton = vgui.Create( "DButton", PanelBypass )
				AddRegimentButton:SetText( "Add Regiment" )
				AddRegimentButton:SetPos( 437, 150 )
				AddRegimentButton:SetSize( 200, 30 )
				AddRegimentButton.DoClick = function()
					if tempaddreg == "" then
					else
						-- Clearing Tables for Refresh
							bypassregiments:Clear()
							newregiments:Clear()
						-- Checking if already there & then removing from non bypass and adding to bypass
							if not table.HasValue(BypassTable, tempaddreg) then
								table.insert(BypassTable, tempaddreg)
							end
							table.remove(newBypass, tempaddindex)
						-- Refreshing List Views
							for k,v in pairs(BypassTable) do
								bypassregiments:AddLine(v)
							end
							for k,v in pairs(newBypass) do
								newregiments:AddLine(v)
							end
						tempaddreg = ""
					end
				end

			local RemoveRegimentButton = vgui.Create( "DButton", PanelBypass )
				RemoveRegimentButton:SetText( "Remove Regiment" )
				RemoveRegimentButton:SetPos( 437, 190 )
				RemoveRegimentButton:SetSize( 200, 30 )
				RemoveRegimentButton.DoClick = function()
					if tempremreg == "" then
					else
						-- Clearing Tables for Refresh
							bypassregiments:Clear()
							newregiments:Clear()
						-- Checking if already there & then removing from bypass to non bypass
							if not table.HasValue(newBypass, tempremreg) then
								table.insert(newBypass, tempremreg)
							end
							table.remove(BypassTable, tempremindex)
						-- Refreshing List Views
							for k,v in pairs(BypassTable) do
								bypassregiments:AddLine(v)
							end
							for k,v in pairs(newBypass) do
								newregiments:AddLine(v)
							end
						tempremreg = ""
					end
				end

			local SaveRegimentButton = vgui.Create( "DButton", PanelBypass )
				SaveRegimentButton:SetText( "Save Bypass List" )
				SaveRegimentButton:SetPos( 437, 230 )
				SaveRegimentButton:SetSize( 200, 30 )
				SaveRegimentButton.DoClick = function()
					chat.AddText(Color(52, 107, 235), "[DYNAMIC LOADOUTS] ", Color(255, 255, 255), "Saved bypass list...")
					net.Start("IG_LOADOUT_ADMIN_SAVE_BYPASS")
						net.WriteTable(BypassTable)
					net.SendToServer()
				end
		
		local PanelLoadout = vgui.Create( "DPanel", sheet )
			PanelLoadout.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 118,121,124,0) ) end 
			sheet:AddSheet("Regiment Loadouts", PanelLoadout)

			local csheet = vgui.Create("DColumnSheet",PanelLoadout)
			csheet:Dock( FILL )

				local tempregimenttable = {}

				local PrimaryMenu = vgui.Create("DPanel")
					PrimaryMenu.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end
					PrimaryMenu:SetSize(950,825)
					csheet:AddSheet("Primary Weapon",PrimaryMenu)

					local TempPrimaryBase = ""
					local PrimaryBaseLabel = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryBaseLabel:SetPos( 0, 40 )
						PrimaryBaseLabel:SetSize( 600, 20 )
						PrimaryBaseLabel:SetDark(true)
						PrimaryBaseLabel:SetText( "Base Weapons & Equipment" )
					local PrimaryBaseText = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryBaseText:SetPos(0,60)
						PrimaryBaseText:SetSize(600,100)
						PrimaryBaseText:SetMultiline(true)
						PrimaryBaseText.OnChange = function( self, value )
							TempPrimaryBase = self:GetValue()
						end

					local TempPrimaryCL2 = ""
					local PrimaryCL2Label = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryCL2Label:SetPos( 0, 160 )
						PrimaryCL2Label:SetSize( 600, 20 )
						PrimaryCL2Label:SetDark(true)
						PrimaryCL2Label:SetText( "Clearance Level 2 Weapons & Equipment" )
					local PrimaryCL2Text = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryCL2Text:SetPos(0,180)
						PrimaryCL2Text:SetSize(600,100)
						PrimaryCL2Text:SetMultiline(true)
						PrimaryCL2Text.OnChange = function( self, value )
							TempPrimaryCL2 = self:GetValue()
						end

					local TempPrimaryCL3 = ""
					local PrimaryCL3Label = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryCL3Label:SetPos( 0, 280 )
						PrimaryCL3Label:SetSize( 600, 20 )
						PrimaryCL3Label:SetDark(true)
						PrimaryCL3Label:SetText( "Clearance Level 3 Weapons & Equipment" )
					local PrimaryCL3Text = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryCL3Text:SetPos(0,300)
						PrimaryCL3Text:SetSize(600,100)
						PrimaryCL3Text:SetMultiline(true)
						PrimaryCL3Text.OnChange = function( self, value )
							TempPrimaryCL3 = self:GetValue()
						end

					local TempPrimaryCL4 = ""
					local PrimaryCL4Label = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryCL4Label:SetPos( 0, 400 )
						PrimaryCL4Label:SetSize( 600, 20 )
						PrimaryCL4Label:SetDark(true)
						PrimaryCL4Label:SetText( "Clearance Level 4 Weapons & Equipment" )
					local PrimaryCL4Text = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryCL4Text:SetPos(0,420)
						PrimaryCL4Text:SetSize(600,100)
						PrimaryCL4Text:SetMultiline(true)
						PrimaryCL4Text.OnChange = function( self, value )
							TempPrimaryCL4 = self:GetValue()
						end

					local TempPrimaryCL5 = ""
					local PrimaryCL5Label = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryCL5Label:SetPos( 0, 520 )
						PrimaryCL5Label:SetSize( 600, 20 )
						PrimaryCL5Label:SetDark(true)
						PrimaryCL5Label:SetText( "Clearance Level 5 Weapons & Equipment" )
					local PrimaryCL5Text = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryCL5Text:SetPos(0,540)
						PrimaryCL5Text:SetSize(600,100)
						PrimaryCL5Text:SetMultiline(true)
						PrimaryCL5Text.OnChange = function( self, value )
							TempPrimaryCL5 = self:GetValue()
						end

					local TempPrimaryCL6 = ""
					local PrimaryCL6Label = vgui.Create( "DLabel", PrimaryMenu )
						PrimaryCL6Label:SetPos( 0, 640 )
						PrimaryCL6Label:SetSize( 600, 20 )
						PrimaryCL6Label:SetDark(true)
						PrimaryCL6Label:SetText( "Clearance Level 6 Weapons & Equipment" )
					local PrimaryCL6Text = vgui.Create( "DTextEntry", PrimaryMenu )
						PrimaryCL6Text:SetPos(0,660)
						PrimaryCL6Text:SetSize(600,100)
						PrimaryCL6Text:SetMultiline(true)
						PrimaryCL6Text.OnChange = function( self, value )
							TempPrimaryCL6 = self:GetValue()
						end

				local SecondaryMenu = vgui.Create("DPanel")
					SecondaryMenu.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end
					SecondaryMenu:SetSize(950,825)
					csheet:AddSheet("Secondary Weapon",SecondaryMenu)
					local TempSecondaryBase = ""
					local SecondaryBaseLabel = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryBaseLabel:SetPos( 0, 40 )
						SecondaryBaseLabel:SetSize( 600, 20 )
						SecondaryBaseLabel:SetDark(true)
						SecondaryBaseLabel:SetText( "Base Weapons & Equipment" )
					local SecondaryBaseText = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryBaseText:SetPos(0,60)
						SecondaryBaseText:SetSize(600,100)
						SecondaryBaseText:SetMultiline(true)
						SecondaryBaseText.OnChange = function( self, value )
							TempSecondaryBase = self:GetValue()
						end

					local TempSecondaryCL2 = ""
					local SecondaryCL2Label = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryCL2Label:SetPos( 0, 160 )
						SecondaryCL2Label:SetSize( 600, 20 )
						SecondaryCL2Label:SetDark(true)
						SecondaryCL2Label:SetText( "Clearance Level 2 Weapons & Equipment" )
					local SecondaryCL2Text = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryCL2Text:SetPos(0,180)
						SecondaryCL2Text:SetSize(600,100)
						SecondaryCL2Text:SetMultiline(true)
						SecondaryCL2Text.OnChange = function( self, value )
							TempSecondaryCL2 = self:GetValue()
						end

					local TempSecondaryCL3 = ""
					local SecondaryCL3Label = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryCL3Label:SetPos( 0, 280 )
						SecondaryCL3Label:SetSize( 600, 20 )
						SecondaryCL3Label:SetDark(true)
						SecondaryCL3Label:SetText( "Clearance Level 3 Weapons & Equipment" )
					local SecondaryCL3Text = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryCL3Text:SetPos(0,300)
						SecondaryCL3Text:SetSize(600,100)
						SecondaryCL3Text:SetMultiline(true)
						SecondaryCL3Text.OnChange = function( self, value )
							TempSecondaryCL3 = self:GetValue()
						end

					local TempSecondaryCL4 = ""
					local SecondaryCL4Label = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryCL4Label:SetPos( 0, 400 )
						SecondaryCL4Label:SetSize( 600, 20 )
						SecondaryCL4Label:SetDark(true)
						SecondaryCL4Label:SetText( "Clearance Level 4 Weapons & Equipment" )
					local SecondaryCL4Text = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryCL4Text:SetPos(0,420)
						SecondaryCL4Text:SetSize(600,100)
						SecondaryCL4Text:SetMultiline(true)
						SecondaryCL4Text.OnChange = function( self, value )
							TempSecondaryCL4 = self:GetValue()
						end

					local TempSecondaryCL5 = ""
					local SecondaryCL5Label = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryCL5Label:SetPos( 0, 520 )
						SecondaryCL5Label:SetSize( 600, 20 )
						SecondaryCL5Label:SetDark(true)
						SecondaryCL5Label:SetText( "Clearance Level 5 Weapons & Equipment" )
					local SecondaryCL5Text = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryCL5Text:SetPos(0,540)
						SecondaryCL5Text:SetSize(600,100)
						SecondaryCL5Text:SetMultiline(true)
						SecondaryCL5Text.OnChange = function( self, value )
							TempSecondaryCL5 = self:GetValue()
						end

					local TempSecondaryCL6 = ""
					local SecondaryCL6Label = vgui.Create( "DLabel", SecondaryMenu )
						SecondaryCL6Label:SetPos( 0, 640 )
						SecondaryCL6Label:SetSize( 600, 20 )
						SecondaryCL6Label:SetDark(true)
						SecondaryCL6Label:SetText( "Clearance Level 6 Weapons & Equipment" )
					local SecondaryCL6Text = vgui.Create( "DTextEntry", SecondaryMenu )
						SecondaryCL6Text:SetPos(0,660)
						SecondaryCL6Text:SetSize(600,100)
						SecondaryCL6Text:SetMultiline(true)
						SecondaryCL6Text.OnChange = function( self, value )
							TempSecondaryCL6 = self:GetValue()
						end

				local SpecialistMenu = vgui.Create("DPanel")
					SpecialistMenu.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end
					SpecialistMenu:SetSize(950,825)
					csheet:AddSheet("Specialist Weapon",SpecialistMenu)
					local TempSpecialistBase = ""
					local SpecialistBaseLabel = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistBaseLabel:SetPos( 0, 40 )
						SpecialistBaseLabel:SetSize( 600, 20 )
						SpecialistBaseLabel:SetDark(true)
						SpecialistBaseLabel:SetText( "Base Weapons & Equipment" )
					local SpecialistBaseText = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistBaseText:SetPos(0,60)
						SpecialistBaseText:SetSize(600,100)
						SpecialistBaseText:SetMultiline(true)
						SpecialistBaseText.OnChange = function( self, value )
							TempSpecialistBase = self:GetValue()
						end

					local TempSpecialistCL2 = ""
					local SpecialistCL2Label = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistCL2Label:SetPos( 0, 160 )
						SpecialistCL2Label:SetSize( 600, 20 )
						SpecialistCL2Label:SetDark(true)
						SpecialistCL2Label:SetText( "Clearance Level 2 Weapons & Equipment" )
					local SpecialistCL2Text = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistCL2Text:SetPos(0,180)
						SpecialistCL2Text:SetSize(600,100)
						SpecialistCL2Text:SetMultiline(true)
						SpecialistCL2Text.OnChange = function( self, value )
							TempSpecialistCL2 = self:GetValue()
						end

					local TempSpecialistCL3 = ""
					local SpecialistCL3Label = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistCL3Label:SetPos( 0, 280 )
						SpecialistCL3Label:SetSize( 600, 20 )
						SpecialistCL3Label:SetDark(true)
						SpecialistCL3Label:SetText( "Clearance Level 3 Weapons & Equipment" )
					local SpecialistCL3Text = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistCL3Text:SetPos(0,300)
						SpecialistCL3Text:SetSize(600,100)
						SpecialistCL3Text:SetMultiline(true)
						SpecialistCL3Text.OnChange = function( self, value )
							TempSpecialistCL3 = self:GetValue()
						end

					local TempSpecialistCL4 = ""
					local SpecialistCL4Label = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistCL4Label:SetPos( 0, 400 )
						SpecialistCL4Label:SetSize( 600, 20 )
						SpecialistCL4Label:SetDark(true)
						SpecialistCL4Label:SetText( "Clearance Level 4 Weapons & Equipment" )
					local SpecialistCL4Text = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistCL4Text:SetPos(0,420)
						SpecialistCL4Text:SetSize(600,100)
						SpecialistCL4Text:SetMultiline(true)
						SpecialistCL4Text.OnChange = function( self, value )
							TempSpecialistCL4 = self:GetValue()
						end

					local TempSpecialistCL5 = ""
					local SpecialistCL5Label = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistCL5Label:SetPos( 0, 520 )
						SpecialistCL5Label:SetSize( 600, 20 )
						SpecialistCL5Label:SetDark(true)
						SpecialistCL5Label:SetText( "Clearance Level 5 Weapons & Equipment" )
					local SpecialistCL5Text = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistCL5Text:SetPos(0,540)
						SpecialistCL5Text:SetSize(600,100)
						SpecialistCL5Text:SetMultiline(true)
						SpecialistCL5Text.OnChange = function( self, value )
							TempSpecialistCL5 = self:GetValue()
						end

					local TempSpecialistCL6 = ""
					local SpecialistCL6Label = vgui.Create( "DLabel", SpecialistMenu )
						SpecialistCL6Label:SetPos( 0, 640 )
						SpecialistCL6Label:SetSize( 600, 20 )
						SpecialistCL6Label:SetDark(true)
						SpecialistCL6Label:SetText( "Clearance Level 6 Weapons & Equipment" )
					local SpecialistCL6Text = vgui.Create( "DTextEntry", SpecialistMenu )
						SpecialistCL6Text:SetPos(0,660)
						SpecialistCL6Text:SetSize(600,100)
						SpecialistCL6Text:SetMultiline(true)
						SpecialistCL6Text.OnChange = function( self, value )
							TempSpecialistCL6 = self:GetValue()
						end

				local UniqueMenu = vgui.Create("DPanel")
					UniqueMenu.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end
					UniqueMenu:SetSize(950,825)
					csheet:AddSheet("Unique Items",UniqueMenu)
					local TempUniqueBase = ""
					local UniqueBaseLabel = vgui.Create( "DLabel", UniqueMenu )
						UniqueBaseLabel:SetPos( 0, 40 )
						UniqueBaseLabel:SetSize( 600, 20 )
						UniqueBaseLabel:SetDark(true)
						UniqueBaseLabel:SetText( "Base Weapons & Equipment" )
					local UniqueBaseText = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueBaseText:SetPos(0,60)
						UniqueBaseText:SetSize(600,100)
						UniqueBaseText:SetMultiline(true)
						UniqueBaseText.OnChange = function( self, value )
							TempUniqueBase = self:GetValue()
						end

					local TempUniqueCL2 = ""
					local UniqueCL2Label = vgui.Create( "DLabel", UniqueMenu )
						UniqueCL2Label:SetPos( 0, 160 )
						UniqueCL2Label:SetSize( 600, 20 )
						UniqueCL2Label:SetDark(true)
						UniqueCL2Label:SetText( "Clearance Level 2 Weapons & Equipment" )
					local UniqueCL2Text = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueCL2Text:SetPos(0,180)
						UniqueCL2Text:SetSize(600,100)
						UniqueCL2Text:SetMultiline(true)
						UniqueCL2Text.OnChange = function( self, value )
							TempUniqueCL2 = self:GetValue()
						end

					local TempUniqueCL3 = ""
					local UniqueCL3Label = vgui.Create( "DLabel", UniqueMenu )
						UniqueCL3Label:SetPos( 0, 280 )
						UniqueCL3Label:SetSize( 600, 20 )
						UniqueCL3Label:SetDark(true)
						UniqueCL3Label:SetText( "Clearance Level 3 Weapons & Equipment" )
					local UniqueCL3Text = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueCL3Text:SetPos(0,300)
						UniqueCL3Text:SetSize(600,100)
						UniqueCL3Text:SetMultiline(true)
						UniqueCL3Text.OnChange = function( self, value )
							TempUniqueCL3 = self:GetValue()
						end

					local TempUniqueCL4 = ""
					local UniqueCL4Label = vgui.Create( "DLabel", UniqueMenu )
						UniqueCL4Label:SetPos( 0, 400 )
						UniqueCL4Label:SetSize( 600, 20 )
						UniqueCL4Label:SetDark(true)
						UniqueCL4Label:SetText( "Clearance Level 4 Weapons & Equipment" )
					local UniqueCL4Text = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueCL4Text:SetPos(0,420)
						UniqueCL4Text:SetSize(600,100)
						UniqueCL4Text:SetMultiline(true)
						UniqueCL4Text.OnChange = function( self, value )
							TempUniqueCL4 = self:GetValue()
						end

					local TempUniqueCL5 = ""
					local UniqueCL5Label = vgui.Create( "DLabel", UniqueMenu )
						UniqueCL5Label:SetPos( 0, 520 )
						UniqueCL5Label:SetSize( 600, 20 )
						UniqueCL5Label:SetDark(true)
						UniqueCL5Label:SetText( "Clearance Level 5 Weapons & Equipment" )
					local UniqueCL5Text = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueCL5Text:SetPos(0,540)
						UniqueCL5Text:SetSize(600,100)
						UniqueCL5Text:SetMultiline(true)
						UniqueCL5Text.OnChange = function( self, value )
							TempUniqueCL5 = self:GetValue()
						end

					local TempUniqueCL6 = ""
					local UniqueCL6Label = vgui.Create( "DLabel", UniqueMenu )
						UniqueCL6Label:SetPos( 0, 640 )
						UniqueCL6Label:SetSize( 600, 20 )
						UniqueCL6Label:SetDark(true)
						UniqueCL6Label:SetText( "Clearance Level 6 Weapons & Equipment" )
					local UniqueCL6Text = vgui.Create( "DTextEntry", UniqueMenu )
						UniqueCL6Text:SetPos(0,660)
						UniqueCL6Text:SetSize(600,100)
						UniqueCL6Text:SetMultiline(true)
						UniqueCL6Text.OnChange = function( self, value )
							TempUniqueCL6 = self:GetValue()
						end

				local ClassMenu = vgui.Create("DPanel")
						ClassMenu.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 141,144,148,0) ) end
						ClassMenu:SetSize(950,825)
						csheet:AddSheet("Class Items",ClassMenu)
						local TempHeavy = ""
						local HeavyLabel = vgui.Create( "DLabel", ClassMenu )
							HeavyLabel:SetPos( 0, 40 )
							HeavyLabel:SetSize( 600, 20 )
							HeavyLabel:SetDark(true)
							HeavyLabel:SetText( "Heavy Weapons & Equipment" )
						local HeavyText = vgui.Create( "DTextEntry", ClassMenu )
							HeavyText:SetPos(0,60)
							HeavyText:SetSize(600,200)
							HeavyText:SetMultiline(true)
							HeavyText.OnChange = function( self, value )
								TempHeavy = self:GetValue()
							end

						local TempSupport = ""
						local SupportLabel = vgui.Create( "DLabel", ClassMenu )
							SupportLabel:SetPos( 0, 280 )
							SupportLabel:SetSize( 600, 20 )
							SupportLabel:SetDark(true)
							SupportLabel:SetText( "Support Weapons & Equipment" )
						local SupportText = vgui.Create( "DTextEntry", ClassMenu )
							SupportText:SetPos(0,300)
							SupportText:SetSize(600,200)
							SupportText:SetMultiline(true)
							SupportText.OnChange = function( self, value )
								TempSupport = self:GetValue()
							end

						local TempSpec = ""
						local SpecLabel = vgui.Create( "DLabel", ClassMenu )
							SpecLabel:SetPos( 0, 520 )
							SpecLabel:SetSize( 600, 20 )
							SpecLabel:SetDark(true)
							SpecLabel:SetText( "Spec Weapons & Equipment" )
						local SpecText = vgui.Create( "DTextEntry", ClassMenu )
							SpecText:SetPos(0,540)
							SpecText:SetSize(600,200)
							SpecText:SetMultiline(true)
							SpecText.OnChange = function( self, value )
								TempSpec = self:GetValue()
							end


			local tempselectreg = ""

			local LoadoutRegimentList = vgui.Create("DComboBox", PanelLoadout)
				LoadoutRegimentList:SetSize(200,30)
				LoadoutRegimentList:SetPos(120,10)
				LoadoutRegimentList:SetValue("Select Regiment to edit")
				for k,v in pairs(RegimentsTableImport) do
					LoadoutRegimentList:AddChoice(v)
				end
				LoadoutRegimentList.OnSelect = function( self, index, value )
					tempselectreg = value
					local i = 0
					for k, v in pairs(RegimentLoadoutTable) do
						i = i + 1
				    	if tempselectreg == table.GetKeys(RegimentLoadoutTable[i])[1] then
				    		tempregimenttable = RegimentLoadoutTable[i][tempselectreg]
				        end
				    end
				    -- Primary
				    	PrimaryBaseText:SetText("")
				    	PrimaryCL2Text:SetText("")
				    	PrimaryCL3Text:SetText("")
				    	PrimaryCL4Text:SetText("")
				    	PrimaryCL5Text:SetText("")
				    	PrimaryCL6Text:SetText("")
					    for _, v in pairs(tempregimenttable["Primary"]["Base"]) do
							PrimaryBaseText:SetText(PrimaryBaseText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Primary"]["CL2"]) do
							PrimaryCL2Text:SetText(PrimaryCL2Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Primary"]["CL3"]) do
							PrimaryCL3Text:SetText(PrimaryCL3Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Primary"]["CL4"]) do
							PrimaryCL4Text:SetText(PrimaryCL4Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Primary"]["CL5"]) do
							PrimaryCL5Text:SetText(PrimaryCL5Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Primary"]["CL6"]) do
							PrimaryCL6Text:SetText(PrimaryCL6Text:GetText() .. "\n" .. v)
						end
						TempPrimaryBase = PrimaryBaseText:GetValue()
						TempPrimaryCL2 = PrimaryCL2Text:GetValue()
						TempPrimaryCL3 = PrimaryCL3Text:GetValue()
						TempPrimaryCL4 = PrimaryCL4Text:GetValue()
						TempPrimaryCL5 = PrimaryCL5Text:GetValue()
						TempPrimaryCL6 = PrimaryCL6Text:GetValue()
					-- Secondary
				    	SecondaryBaseText:SetText("")
				    	SecondaryCL2Text:SetText("")
				    	SecondaryCL3Text:SetText("")
				    	SecondaryCL4Text:SetText("")
				    	SecondaryCL5Text:SetText("")
				    	SecondaryCL6Text:SetText("")
					    for _, v in pairs(tempregimenttable["Secondary"]["Base"]) do
							SecondaryBaseText:SetText(SecondaryBaseText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Secondary"]["CL2"]) do
							SecondaryCL2Text:SetText(SecondaryCL2Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Secondary"]["CL3"]) do
							SecondaryCL3Text:SetText(SecondaryCL3Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Secondary"]["CL4"]) do
							SecondaryCL4Text:SetText(SecondaryCL4Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Secondary"]["CL5"]) do
							SecondaryCL5Text:SetText(SecondaryCL5Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Secondary"]["CL6"]) do
							SecondaryCL6Text:SetText(SecondaryCL6Text:GetText() .. "\n" .. v)
						end
						TempPrimaryBase = PrimaryBaseText:GetValue()
						TempPrimaryCL2 = PrimaryCL2Text:GetValue()
						TempPrimaryCL3 = PrimaryCL3Text:GetValue()
						TempPrimaryCL4 = PrimaryCL4Text:GetValue()
						TempPrimaryCL5 = PrimaryCL5Text:GetValue()
						TempPrimaryCL6 = PrimaryCL6Text:GetValue()
					-- Specialist
				    	SpecialistBaseText:SetText("")
				    	SpecialistCL2Text:SetText("")
				    	SpecialistCL3Text:SetText("")
				    	SpecialistCL4Text:SetText("")
				    	SpecialistCL5Text:SetText("")
				    	SpecialistCL6Text:SetText("")
					    for _, v in pairs(tempregimenttable["Specialist"]["Base"]) do
							SpecialistBaseText:SetText(SpecialistBaseText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Specialist"]["CL2"]) do
							SpecialistCL2Text:SetText(SpecialistCL2Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Specialist"]["CL3"]) do
							SpecialistCL3Text:SetText(SpecialistCL3Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Specialist"]["CL4"]) do
							SpecialistCL4Text:SetText(SpecialistCL4Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Specialist"]["CL5"]) do
							SpecialistCL5Text:SetText(SpecialistCL5Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Specialist"]["CL6"]) do
							SpecialistCL6Text:SetText(SpecialistCL6Text:GetText() .. "\n" .. v)
						end
						TempSpecialistBase = SpecialistBaseText:GetValue()
						TempSpecialistCL2 = SpecialistCL2Text:GetValue()
						TempSpecialistCL3 = SpecialistCL3Text:GetValue()
						TempSpecialistCL4 = SpecialistCL4Text:GetValue()
						TempSpecialistCL5 = SpecialistCL5Text:GetValue()
						TempSpecialistCL6 = SpecialistCL6Text:GetValue()
					-- Unique
				    	UniqueBaseText:SetText("")
				    	UniqueCL2Text:SetText("")
				    	UniqueCL3Text:SetText("")
				    	UniqueCL4Text:SetText("")
				    	UniqueCL5Text:SetText("")
				    	UniqueCL6Text:SetText("")
					    for _, v in pairs(tempregimenttable["Unique"]["Base"]) do
							UniqueBaseText:SetText(UniqueBaseText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Unique"]["CL2"]) do
							UniqueCL2Text:SetText(UniqueCL2Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Unique"]["CL3"]) do
							UniqueCL3Text:SetText(UniqueCL3Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Unique"]["CL4"]) do
							UniqueCL4Text:SetText(UniqueCL4Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Unique"]["CL5"]) do
							UniqueCL5Text:SetText(UniqueCL5Text:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Unique"]["CL6"]) do
							UniqueCL6Text:SetText(UniqueCL6Text:GetText() .. "\n" .. v)
						end
						TempUniqueBase = UniqueBaseText:GetValue()
						TempUniqueCL2 = UniqueCL2Text:GetValue()
						TempUniqueCL3 = UniqueCL3Text:GetValue()
						TempUniqueCL4 = UniqueCL4Text:GetValue()
						TempUniqueCL5 = UniqueCL5Text:GetValue()
						TempUniqueCL6 = UniqueCL6Text:GetValue()
					-- Class
				    	HeavyText:SetText("")
				    	SupportText:SetText("")
				    	SpecText:SetText("")
					    for _, v in pairs(tempregimenttable["Class"]["Heavy"]) do
							HeavyText:SetText(HeavyText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Class"]["Support"]) do
							SupportText:SetText(SupportText:GetText() .. "\n" .. v)
						end
						for _, v in pairs(tempregimenttable["Class"]["Spec"]) do
							SpecText:SetText(SpecText:GetText() .. "\n" .. v)
						end
						TempHeavy = HeavyText:GetValue()
						TempSupport = SupportText:GetValue()
						TempSpec = SpecText:GetValue()
				end

			local RegimentLoadoutSubmit = vgui.Create("DButton", PanelLoadout)
				RegimentLoadoutSubmit:SetSize(200,30)
				RegimentLoadoutSubmit:SetText("Save Regiment Loadouts")
				RegimentLoadoutSubmit:SetPos(325,10)
				RegimentLoadoutSubmit.DoClick = function()
					local function DL_InsetTable(Pos, CL, Table)
						local str = Table
						local weaponsvalue = string.Explode("\n", str)
						local sanitizedWeapons = {}
						for k, v in pairs (weaponsvalue) do
							if (v ~= "" && v ~= " ") then
								table.insert(sanitizedWeapons, v)
							end
						end
						if (table.IsEmpty(sanitizedWeapons)) then
							return false
						else
							tempregimenttable[Pos][CL] = sanitizedWeapons
						end
					end
					-- Primary
						DL_InsetTable("Primary","Base",TempPrimaryBase)
						DL_InsetTable("Primary","CL2",TempPrimaryCL2)
						DL_InsetTable("Primary","CL3",TempPrimaryCL3)
						DL_InsetTable("Primary","CL4",TempPrimaryCL4)
						DL_InsetTable("Primary","CL5",TempPrimaryCL5)
						DL_InsetTable("Primary","CL6",TempPrimaryCL6)
					-- Secondary
						DL_InsetTable("Secondary","Base",TempSecondaryBase)
						DL_InsetTable("Secondary","CL2",TempSecondaryCL2)
						DL_InsetTable("Secondary","CL3",TempSecondaryCL3)
						DL_InsetTable("Secondary","CL4",TempSecondaryCL4)
						DL_InsetTable("Secondary","CL5",TempSecondaryCL5)
						DL_InsetTable("Secondary","CL6",TempSecondaryCL6)
					-- Specialist
						DL_InsetTable("Specialist","Base",TempSpecialistBase)
						DL_InsetTable("Specialist","CL2",TempSpecialistCL2)
						DL_InsetTable("Specialist","CL3",TempSpecialistCL3)
						DL_InsetTable("Specialist","CL4",TempSpecialistCL4)
						DL_InsetTable("Specialist","CL5",TempSpecialistCL5)
						DL_InsetTable("Specialist","CL6",TempSpecialistCL6)
					-- Unique
						DL_InsetTable("Unique","Base",TempUniqueBase)
						DL_InsetTable("Unique","CL2",TempUniqueCL2)
						DL_InsetTable("Unique","CL3",TempUniqueCL3)
						DL_InsetTable("Unique","CL4",TempUniqueCL4)
						DL_InsetTable("Unique","CL5",TempUniqueCL5)
						DL_InsetTable("Unique","CL6",TempUniqueCL6)
					-- Class
						DL_InsetTable("Class","Heavy",TempHeavy)
						DL_InsetTable("Class","Support",TempSupport)
						DL_InsetTable("Class","Spec",TempSpec)
					
					net.Start("IG_LOADOUT_ADMIN_SAVE_LOADOUT")
						net.WriteTable(RegimentLoadoutTable)
					net.SendToServer()
					chat.AddText(Color(52, 107, 235), "[DYNAMIC LOADOUTS] ", Color(255, 255, 255), "Saved Regiment Loadouts...")
				end

		local PanelUniversal = vgui.Create( "DPanel", sheet )
			PanelUniversal.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 118,121,124,0) ) end 
			sheet:AddSheet("Universal Items", PanelUniversal)
			local tempuniversal = ""

			local UniversalText = vgui.Create( "DTextEntry", PanelUniversal )
				UniversalText:SetPos(15,15)
				UniversalText:SetSize(400,700)
				UniversalText:SetMultiline(true)
				UniversalText.OnChange = function( self, value )
					tempuniversal = self:GetValue()
				end
				for _, v in pairs(UniversalItemImport) do
					UniversalText:SetText(UniversalText:GetText() .. "\n" .. v)
				end
				tempuniversal = UniversalText:GetValue()

			local UniversalButtonSubmit = vgui.Create("DButton", PanelUniversal)
				UniversalButtonSubmit:SetSize(200,30)
				UniversalButtonSubmit:SetText("Save Universal Items")
				UniversalButtonSubmit:SetPos( 437, 150 )
				UniversalButtonSubmit.DoClick = function()
					local str = tempuniversal
					local weaponsvalue = string.Explode("\n", str)
					local sanitizedWeapons = {}
					for k, v in pairs (weaponsvalue) do
						if (v ~= "" && v ~= " ") then
							table.insert(sanitizedWeapons, v)
						end
					end
					if (table.IsEmpty(sanitizedWeapons)) then
						return false
					else
						sana = sanitizedWeapons
					end

					net.Start("IG_LOADOUT_ADMIN_SAVE_UNIVERSAL")
						net.WriteTable(sana)
					net.SendToServer()
					chat.AddText(Color(52, 107, 235), "[DYNAMIC LOADOUTS] ", Color(255, 255, 255), "Saved Universal Items...")
				end
	end)

	net.Receive("IG_LOADOUT_SEND_ERROR", function()
		local errornumber = net.ReadString()
		local reason = net.ReadString()
		chat.AddText(Color(52, 107, 235), "[DYNAMIC LOADOUTS] ", Color(235, 52, 52), "ERROR "..errornumber..": ", Color(255,255,255), reason)
	end)
end