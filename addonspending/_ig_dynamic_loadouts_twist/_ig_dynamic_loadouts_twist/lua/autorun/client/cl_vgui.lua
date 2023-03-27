if SERVER then
	return
else
	// Fonts
		surface.CreateFont("REGTitle", {
			font = "Arial",
			extended = false,
			size = 40,
			weight = 500,
			blursize = 0,
			antialias = true,
			outline = false,
		})
		surface.CreateFont("REGITitle", {
			font = "Arial",
			extended = false,
			size = 40,
			weight = 500,
			blursize = 0,
			antialias = true,
			outline = false,
		})

		surface.CreateFont("REGIText", {
			font = "Arial",
			extended = false,
			size = 22,
			weight = 500,
			blursize = 0,
			antialias = true,
			outline = false,
		})

		surface.CreateFont("SmallText", {
			font = "Arial",
			extended = false,
			size = 20,
			weight = 500,
			blursize = 0,
			antialias = true,
			outline = false,
		})
	// Regiment Loadout Menu
		local function regframefunc(tempreg, import)
			local ply = LocalPlayer()
			local regiment = tempreg
			local regimenttable = import
			local temp = {
				prim = "",
				sec = "",
				spec = ""
			}
			local sana = {
				prim = {},
				sec = {},
				spec = {}
			}
			local primweptable = {}
			local secweptable = {}
			local specweptable = {}

			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), tempreg) then
					reginum = k
				end
			end

			local regframe = vgui.Create("DFrame")
				regframe:SetSize(730, 500)
				regframe:Center()
				regframe:SetVisible(true)
				regframe:MakePopup()
				regframe:ShowCloseButton(false)
				regframe:SetTitle("")

				regframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(208, 135, 112))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT LOADOUT MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Editing Regiment: "..regiment, "REGIText", 410,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Primary Weapon Table", "SmallText", 110,130, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Secondary Weapon Table", "SmallText", 110,230, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Specialist Weapon/Item Table", "SmallText", 110,330, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("[NOTE] Each weapon must be on a seperate line", "SmallText", 330,450, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

			local frameheader = vgui.Create("DLabel", regframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textprimary = vgui.Create( "DTextEntry", regframe )
				textprimary:SetPos(110, 150)
				textprimary:SetSize(600,80)
				textprimary:SetMultiline(true)
				textprimary.OnChange = function( self, value )
					temp.prim = self:GetValue()
				end

				primweptable = regimenttable[reginum][regiment]["Main"]["Primary"]

				for _, v in pairs(primweptable) do
					textprimary:SetText(textprimary:GetText() .. "\n" .. v)
				end
				temp.prim = textprimary:GetValue()

			local textseconday = vgui.Create( "DTextEntry", regframe )
				textseconday:SetPos(110, 250)
				textseconday:SetSize(600,80)
				textseconday:SetMultiline(true)
				textseconday.OnChange = function( self, value )
					temp.sec = self:GetValue()
				end
				secweptable = regimenttable[reginum][regiment]["Main"]["Secondary"]
				for _, v in pairs(secweptable) do
					textseconday:SetText(textseconday:GetText() .. "\n" .. v)
				end
				temp.sec = textseconday:GetValue()

			local textspec = vgui.Create( "DTextEntry", regframe )
				textspec:SetPos(110, 350)
				textspec:SetSize(600,80)
				textspec:SetMultiline(true)
				textspec.OnChange = function( self, value )
					temp.spec = self:GetValue()
				end
				for k,v in pairs(regimenttable) do
					if regiment == regimenttable[k]["Regiment"] then
						specweptable = regimenttable[k]["Loadout"]["Spec"]
					end
				end
				specweptable = regimenttable[reginum][regiment]["Main"]["Specialist"]
				for _, v in pairs(specweptable) do
					textspec:SetText(textspec:GetText() .. "\n" .. v)
				end
				temp.spec = textspec:GetValue()

			local buttonsubmit = vgui.Create("DButton", regframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Regiment Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function primaryweaponset(temp, regiment)
						local str = temp.prim
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
							sana.prim = sanitizedWeapons
						end
					end
					local function secondaryweaponset(temp, regiment)
						local str = temp.sec
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
							sana.sec = sanitizedWeapons
						end
					end
					local function specweaponset(temp, regiment)
						local str = temp.spec
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
							sana.spec = sanitizedWeapons
						end
					end
					primaryweaponset(temp, regiment)
					secondaryweaponset(temp, regiment)
					specweaponset(temp, regiment)
					net.Start("igSquadMenuSetLoadout")
						net.WriteTable(sana)
						net.WriteString(regiment)
					net.SendToServer()

					ply:ChatPrint("Saving Loadout for: "..regiment.."...")
					regframe:Close()
				end
		end

	// Regiment Clearance Menu
		local function clframefunc(tempreg, import)
			local ply = LocalPlayer()
			local regiment = tempreg
			local regimenttable = import
			local temp = {
				prim = "",
				sec = "",
				spec = ""
			}
			local sana = {
				prim = {},
				sec = {},
				spec = {}
			}
			local primweptable = {}
			local secweptable = {}
			local specweptable = {}

			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), tempreg) then
					reginum = k
				end
			end

			local regframe = vgui.Create("DFrame")
				regframe:SetSize(730, 500)
				regframe:Center()
				regframe:SetVisible(true)
				regframe:MakePopup()
				regframe:ShowCloseButton(false)
				regframe:SetTitle("")

				regframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(208, 135, 112))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT LOADOUT MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Editing Regiment: "..regiment, "REGIText", 410,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Clearance Level 2 Table", "SmallText", 110,130, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Clearance Level 3 Table", "SmallText", 110,230, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Clearance Level 4 Table", "SmallText", 110,330, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("[NOTE] Each weapon must be on a seperate line", "SmallText", 330,450, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

			local frameheader = vgui.Create("DLabel", regframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textprimary = vgui.Create( "DTextEntry", regframe )
				textprimary:SetPos(110, 150)
				textprimary:SetSize(600,80)
				textprimary:SetMultiline(true)
				textprimary.OnChange = function( self, value )
					temp.prim = self:GetValue()
				end
				primweptable = regimenttable[reginum][regiment]["Clearance"]["CL2"]

				for _, v in pairs(primweptable) do
					textprimary:SetText(textprimary:GetText() .. "\n" .. v)
				end
				temp.prim = textprimary:GetValue()

			local textseconday = vgui.Create( "DTextEntry", regframe )
				textseconday:SetPos(110, 250)
				textseconday:SetSize(600,80)
				textseconday:SetMultiline(true)
				textseconday.OnChange = function( self, value )
					temp.sec = self:GetValue()
				end
				secweptable = regimenttable[reginum][regiment]["Clearance"]["CL3"]
				for _, v in pairs(secweptable) do
					textseconday:SetText(textseconday:GetText() .. "\n" .. v)
				end
				temp.sec = textseconday:GetValue()

			local textspec = vgui.Create( "DTextEntry", regframe )
				textspec:SetPos(110, 350)
				textspec:SetSize(600,80)
				textspec:SetMultiline(true)
				textspec.OnChange = function( self, value )
					temp.spec = self:GetValue()
				end
				specweptable = regimenttable[reginum][regiment]["Clearance"]["CL4"]
				for _, v in pairs(specweptable) do
					textspec:SetText(textspec:GetText() .. "\n" .. v)
				end
				temp.spec = textspec:GetValue()

			local buttonsubmit = vgui.Create("DButton", regframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Regiment Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function primaryweaponset(temp, regiment)
						local str = temp.prim
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
							sana.prim = sanitizedWeapons
						end
					end
					local function secondaryweaponset(temp, regiment)
						local str = temp.sec
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
							sana.sec = sanitizedWeapons
						end
					end
					local function specweaponset(temp, regiment)
						local str = temp.spec
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
							sana.spec = sanitizedWeapons
						end
					end
					primaryweaponset(temp, regiment)
					secondaryweaponset(temp, regiment)
					specweaponset(temp, regiment)
					net.Start("igSquadMenuSetClearance")
						net.WriteTable(sana)
						net.WriteString(regiment)
					net.SendToServer()

					ply:ChatPrint("Saving Clearance Loadout for: "..regiment.."...")
					regframe:Close()
				end
		end

	// Regiment Unique Clearance Menu
		local function uclframefunc(tempreg, importcluni)
			local ply = LocalPlayer()
			local regiment = tempreg
			local regimenttable = importcluni
			local temp = {
				prim = "",
				sec = "",
				spec = ""
			}
			local sana = {
				prim = {},
				sec = {},
				spec = {}
			}
			local primweptable = {}
			local secweptable = {}
			local specweptable = {}

			local reginum = 0
			for k,v in pairs(importcluni) do
				if table.HasValue(table.GetKeys(importcluni[k]), tempreg) then
					reginum = k
				end
			end

			local regframe = vgui.Create("DFrame")
				regframe:SetSize(730, 500)
				regframe:Center()
				regframe:SetVisible(true)
				regframe:MakePopup()
				regframe:ShowCloseButton(false)
				regframe:SetTitle("")

				regframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(208, 135, 112))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT LOADOUT MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Editing Regiment: "..regiment, "REGIText", 410,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Clearance Level 2 Table", "SmallText", 110,130, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Clearance Level 3 Table", "SmallText", 110,230, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Clearance Level 4 Table", "SmallText", 110,330, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("[NOTE] Each weapon must be on a seperate line", "SmallText", 330,450, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

			local frameheader = vgui.Create("DLabel", regframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textprimary = vgui.Create( "DTextEntry", regframe )
				textprimary:SetPos(110, 150)
				textprimary:SetSize(600,80)
				textprimary:SetMultiline(true)
				textprimary.OnChange = function( self, value )
					temp.prim = self:GetValue()
				end
				primweptable = regimenttable[reginum][regiment]["Clearance"]["CL2"]

				for _, v in pairs(primweptable) do
					textprimary:SetText(textprimary:GetText() .. "\n" .. v)
				end
				temp.prim = textprimary:GetValue()

			local textseconday = vgui.Create( "DTextEntry", regframe )
				textseconday:SetPos(110, 250)
				textseconday:SetSize(600,80)
				textseconday:SetMultiline(true)
				textseconday.OnChange = function( self, value )
					temp.sec = self:GetValue()
				end
				secweptable = regimenttable[reginum][regiment]["Clearance"]["CL3"]
				for _, v in pairs(secweptable) do
					textseconday:SetText(textseconday:GetText() .. "\n" .. v)
				end
				temp.sec = textseconday:GetValue()

			local textspec = vgui.Create( "DTextEntry", regframe )
				textspec:SetPos(110, 350)
				textspec:SetSize(600,80)
				textspec:SetMultiline(true)
				textspec.OnChange = function( self, value )
					temp.spec = self:GetValue()
				end
				specweptable = regimenttable[reginum][regiment]["Clearance"]["CL4"]
				for _, v in pairs(specweptable) do
					textspec:SetText(textspec:GetText() .. "\n" .. v)
				end
				temp.spec = textspec:GetValue()

			local buttonsubmit = vgui.Create("DButton", regframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Regiment Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function primaryweaponset(temp, regiment)
						local str = temp.prim
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
							sana.prim = sanitizedWeapons
						end
					end
					local function secondaryweaponset(temp, regiment)
						local str = temp.sec
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
							sana.sec = sanitizedWeapons
						end
					end
					local function specweaponset(temp, regiment)
						local str = temp.spec
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
							sana.spec = sanitizedWeapons
						end
					end
					primaryweaponset(temp, regiment)
					secondaryweaponset(temp, regiment)
					specweaponset(temp, regiment)
					net.Start("igSquadMenuSetUniqueClearance")
						net.WriteTable(sana)
						net.WriteString(regiment)
					net.SendToServer()

					ply:ChatPrint("Saving Clearance Loadout for: "..regiment.."...")
					regframe:Close()
				end
		end

	// Regiment Unique Item Menu
		local function uniqueframefunc(tempreg, import)
			local ply = LocalPlayer()
			local regiment = tempreg
			local regimenttable = import
			local temp = ""
			local sana = {}
			local weptable = {}

			local reginum = 0
			for k,v in pairs(import) do
				if table.HasValue(table.GetKeys(import[k]), tempreg) then
					reginum = k
				end
			end

			local uniqueframe = vgui.Create("DFrame")
				uniqueframe:SetSize(730, 500)
				uniqueframe:Center()
				uniqueframe:SetVisible(true)
				uniqueframe:MakePopup()
				uniqueframe:ShowCloseButton(false)
				uniqueframe:SetTitle("")

				uniqueframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(180, 142, 173))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT UNIQUE ITEM MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Editing Regiment: "..regiment, "REGIText", 410,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				end

			local frameheader = vgui.Create("DLabel", uniqueframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textprimary = vgui.Create( "DTextEntry", uniqueframe )
				textprimary:SetPos(110, 150)
				textprimary:SetSize(600,280)
				textprimary:SetMultiline(true)
				textprimary.OnChange = function( self, value )
					temp = self:GetValue()
				end
				primweptable = regimenttable[reginum][regiment]["Unique"]
				for _, v in pairs(primweptable) do
					textprimary:SetText(textprimary:GetText() .. "\n" .. v)
				end
				temp = textprimary:GetValue()

			local buttonsubmit = vgui.Create("DButton", uniqueframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Regiment Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function uniqueweaponset(temp, regiment)
						local str = temp
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
					end
					uniqueweaponset(temp, regiment)
					net.Start("igSquadMenuSetUnique")
						net.WriteTable(sana)
						net.WriteString(regiment)
					net.SendToServer()

					ply:ChatPrint("Saving Unique Items for: "..regiment.."...")
					uniqueframe:Close()
				end
			end

	// Universal Item Menu
		local function universalframefunc(importuni)
			local ply = LocalPlayer()
			local regimenttable = importuni
			local temp = ""
			local sana = {}
			local weptable = {}

			local universalframe = vgui.Create("DFrame")
				universalframe:SetSize(730, 500)
				universalframe:Center()
				universalframe:SetVisible(true)
				universalframe:MakePopup()
				universalframe:ShowCloseButton(false)
				universalframe:SetTitle("")

				universalframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(163, 190, 140))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT UNIQUE ITEM MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				end

			local frameheader = vgui.Create("DLabel", universalframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textprimary = vgui.Create( "DTextEntry", universalframe )
				textprimary:SetPos(110, 150)
				textprimary:SetSize(600,280)
				textprimary:SetMultiline(true)
				textprimary.OnChange = function( self, value )
					temp = self:GetValue()
				end
				for _, v in pairs(regimenttable) do
					textprimary:SetText(textprimary:GetText() .. "\n" .. v)
				end
				temp = textprimary:GetValue()

			local buttonsubmit = vgui.Create("DButton", universalframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Regiment Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function uniweaponset(temp)
						local str = temp
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
					end
					uniweaponset(temp)
					net.Start("igSquadMenuSetUniveral")
						net.WriteTable(sana)
					net.SendToServer()

					PrintTable(sana)

					ply:ChatPrint("Saving Universal items...")
					universalframe:Close()
				end
			end

	// Class Items Menu
		local function classframefunc(importclasses)
			local ply = LocalPlayer()
			local classtable = importclasses
			local temp = {
				support = "",
				heavy = "",
				medic = ""
			}
			local sana = {
				support = {},
				heavy = {},
				medic = {}
			}
			local supportweptable = classtable[1]["Equipment"]
			local heavyweptable = classtable[2]["Equipment"]
			local medicweptable = classtable[3]["Equipment"]

			local classframe = vgui.Create("DFrame")
				classframe:SetSize(730, 500)
				classframe:Center()
				classframe:SetVisible(true)
				classframe:MakePopup()
				classframe:ShowCloseButton(false)
				classframe:SetTitle("")

				classframe.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,440,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,440,Color(208, 135, 112))
					draw.RoundedBox(0,100,50,620,440,Color(76, 86, 106))
					draw.DrawText("EDIT LOADOUT MENU", "REGITitle", 410,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Editing Class Loadouts", "REGIText", 410,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("Support Equipment Table", "SmallText", 110,130, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Heavy Equipment Table", "SmallText", 110,230, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("Medic Equipment Table", "SmallText", 110,330, Color(255,255,255,255), TEXT_ALIGN_LEFT)
					draw.DrawText("[NOTE] Each weapon must be on a seperate line", "SmallText", 330,450, Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end

			local frameheader = vgui.Create("DLabel", classframe)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local textsupport = vgui.Create( "DTextEntry", classframe )
				textsupport:SetPos(110, 150)
				textsupport:SetSize(600,80)
				textsupport:SetMultiline(true)
				textsupport.OnChange = function( self, value )
					temp.support = self:GetValue()
				end
				for _, v in pairs(supportweptable) do
					textsupport:SetText(textsupport:GetText() .. "\n" .. v)
				end
				temp.support = textsupport:GetValue()

			local textheavy = vgui.Create( "DTextEntry", classframe )
				textheavy:SetPos(110, 250)
				textheavy:SetSize(600,80)
				textheavy:SetMultiline(true)
				textheavy.OnChange = function( self, value )
					temp.heavy = self:GetValue()
				end
				for _, v in pairs(heavyweptable) do
					textheavy:SetText(textheavy:GetText() .. "\n" .. v)
				end
				temp.heavy = textheavy:GetValue()

			local textmedic = vgui.Create( "DTextEntry", classframe )
				textmedic:SetPos(110, 350)
				textmedic:SetSize(600,80)
				textmedic:SetMultiline(true)
				textmedic.OnChange = function( self, value )
					temp.medic = self:GetValue()
				end
				for _, v in pairs(medicweptable) do
					textmedic:SetText(textmedic:GetText() .. "\n" .. v)
				end
				temp.medic = textmedic:GetValue()

			local buttonsubmit = vgui.Create("DButton", classframe)
				buttonsubmit:SetSize(200,45)
				buttonsubmit:SetText("Confirm Classes Loadout")
				buttonsubmit:SetPos(110, 440)
				buttonsubmit:SetTextColor( Color( 236, 239, 244) )
				buttonsubmit.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonsubmit.DoClick = function()
					local function supportweaponset(temp)
						local str = temp.support
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
							sana.support = sanitizedWeapons
						end
					end
					local function heavyweaponset(temp)
						local str = temp.heavy
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
							sana.heavy = sanitizedWeapons
						end
					end
					local function medicweaponset(temp)
						local str = temp.medic
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
							sana.medic = sanitizedWeapons
						end
					end
					supportweaponset(temp)
					heavyweaponset(temp)
					medicweaponset(temp)
					net.Start("igSquadMenuSetClasses")
						net.WriteTable(sana)
					net.SendToServer()

					ply:ChatPrint("Saving Class Loadouts...")
					classframe:Close()
				end
		end
	
	// Index menu
		net.Receive("igSquadMenuEdit", function()
			local regtable = net.ReadTable()
			local import = net.ReadTable()
			local importuni = net.ReadTable()
			local importclasses = net.ReadTable()
			local importcluni = net.ReadTable()
			local tempreg = ""
			local ply = LocalPlayer()

			ply:ChatPrint("Opening Dynamic Loadouts Edit Menu...")

			local frame = vgui.Create("DFrame")
				frame:SetSize(430, 670)
				frame:Center()
				frame:SetVisible(true)
				frame:MakePopup()
				frame:ShowCloseButton(false)
				frame:SetTitle("")

				frame.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,610,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,610,Color(136, 192, 208))
					draw.RoundedBox(0,100,50,230,610,Color(76, 86, 106))
					draw.DrawText("DYNAMIC", "REGTitle", 215,60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("LOADOUTS", "REGTitle", 215,100, Color(255,255,255,255), TEXT_ALIGN_CENTER)
					draw.DrawText("EDIT MENU", "REGTitle", 215,140, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				end

			local frameheader = vgui.Create("DLabel", frame)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local regimentlist = vgui.Create("DComboBox", frame)
				regimentlist:SetSize(200,40)
				regimentlist:SetPos(115,190)
				regimentlist:SetValue("Select Regiment to edit")
				for k,v in pairs(regtable) do
					regimentlist:AddChoice(v)
				end
				regimentlist.OnSelect = function( self, index, value )
					tempreg = value
				end

			local buttonregiment = vgui.Create("DButton", frame)
				buttonregiment:SetSize(200,45)
				buttonregiment:SetText("Edit Regiment Loadouts")
				buttonregiment:SetPos(115, 250)
				buttonregiment:SetTextColor( Color( 236, 239, 244) )
				buttonregiment.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonregiment.DoClick = function()
					if tempreg == "" then
						ply:ChatPrint("Select a regiment from the list")
					else
						frame:Close()
						regframefunc(tempreg, import)
					end
				end

			local buttonunique = vgui.Create("DButton", frame)
				buttonunique:SetSize(200,45)
				buttonunique:SetText("Edit Regiment Unique Items")
				buttonunique:SetPos(115, 310)
				buttonunique:SetTextColor( Color( 236, 239, 244) )
				buttonunique.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonunique.DoClick = function()
					if tempreg == "" then
						ply:ChatPrint("Select a regiment from the list")
					else
						frame:Close()
						uniqueframefunc(tempreg, import)
					end
				end

			local buttonclearance = vgui.Create("DButton", frame)
				buttonclearance:SetSize(200,45)
				buttonclearance:SetText("Edit Regiment Clearance Items")
				buttonclearance:SetPos(115, 370)
				buttonclearance:SetTextColor( Color( 236, 239, 244) )
				buttonclearance.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end
				buttonclearance.DoClick = function()
					if tempreg == "" then
						ply:ChatPrint("Select a regiment from the list")
					else
						frame:Close()
						clframefunc(tempreg, import)
					end
				end

			local buttonuniversal = vgui.Create("DButton", frame)
				buttonuniversal:SetSize(200,45)
				buttonuniversal:SetText("Edit Universal Items")
				buttonuniversal:SetPos(115, 430)
				buttonuniversal:SetTextColor( Color( 236, 239, 244) )

				buttonuniversal.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end

				buttonuniversal.DoClick = function()
					frame:Close()
					universalframefunc(importuni)
				end

			local buttonroles = vgui.Create("DButton", frame)
				buttonroles:SetSize(200,45)
				buttonroles:SetText("Edit Class Loadout")
				buttonroles:SetPos(115, 490)
				buttonroles:SetTextColor( Color( 236, 239, 244) )

				buttonroles.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end

				buttonroles.DoClick = function()
					classframefunc(importclasses)
					frame:Close()
				end

			local buttonucl = vgui.Create("DButton", frame)
				buttonucl:SetSize(200,45)
				buttonucl:SetText("Edit Unique Clearance")
				buttonucl:SetPos(115, 550)
				buttonucl:SetTextColor( Color( 236, 239, 244) )

				buttonucl.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end

				buttonucl.DoClick = function()
					if tempreg == "" then
						ply:ChatPrint("Select a regiment from the list")
					else
						frame:Close()
						uclframefunc(tempreg, importcluni)
					end
				end

			local buttonmainclose = vgui.Create("DButton", frame)
				buttonmainclose:SetSize(200,45)
				buttonmainclose:SetText("Close Menu")
				buttonmainclose:SetPos(115, 610)
				buttonmainclose:SetTextColor( Color( 236, 239, 244) )

				buttonmainclose.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end

				buttonmainclose.DoClick = function()
					frame:Close()
				end
		end)

	// Purchase menu
		net.Receive("igSquadMenuCheckPurchase", function()
			local ply = LocalPlayer()
			local port = net.ReadTable()
			ply:ChatPrint("Opening Dynamic Loadouts Purchase Log Menu...")
			local frame = vgui.Create("DFrame")
				frame:SetSize(630, 610)
				frame:Center()
				frame:SetVisible(true)
				frame:MakePopup()
				frame:ShowCloseButton(false)
				frame:SetTitle("")

				frame.Paint = function( self, w, h )	
					draw.RoundedBox(0, 0, 0, w, h, Color(74, 100, 133))
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
					draw.RoundedBox(0,10,50,20,550,Color(67, 76, 94))
					draw.RoundedBox(0,35,50,20,550,Color(136, 192, 208))
					draw.RoundedBox(0,100,50,430,550,Color(76, 86, 106))
					draw.DrawText("PURCHASE LOGS", "REGTitle", w/2, 60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
				end

			local frameheader = vgui.Create("DLabel", frame)
				frameheader:SetPos(15,0)
				frameheader:SetSize(350,40)
				frameheader:SetText("Imperial Gaming | Dynamic Loadouts")
				frameheader:SetColor(Color(255, 255, 255))

			local buttonmainclose = vgui.Create("DButton", frame)
				buttonmainclose:SetSize(200,45)
				buttonmainclose:SetText("Close Menu")
				buttonmainclose:SetPos(115, 550)
				buttonmainclose:SetTextColor( Color( 236, 239, 244) )

				buttonmainclose.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, 40, Color(46, 52, 64))
				end

				buttonmainclose.DoClick = function()
					frame:Close()
				end

			local loglist_purchase = vgui.Create("DListView", frame)
				loglist_purchase:SetSize(410, 400)
				loglist_purchase:SetPos(110, 100)
				loglist_purchase:AddColumn( "Time" )
				loglist_purchase:AddColumn( "SteamID" )
				loglist_purchase:AddColumn( "Slot #" ):SetFixedWidth(60)
				
				loglist_purchase.DoDoubleClick = function(parent, index, list)
					print("----Selected Entry ----")
					print(list:GetValue(2))
					print("-----------------------")
				end

				/*
				for i = #port, 1, -1 do --Iterate through the list in reverse so most recent items are at the top.
				  v = port[i]
					message = v['player_name'] .. " Sent: " .. v['comms']
					loglist_purchase:AddLine(time_ago(v['timestamp']), message) --Add an entry to the list view containing the time and message.
				end
				*/

				for i,v in pairs(port) do
					loglist_purchase:AddLine(port[i]["Time"], port[i]["SteamID"], port[i]["Slot"])
				end
		end)

	// Check Loadouts
		net.Receive("igSquadMenuCheckLoadout", function()
			local weapontable = net.ReadTable()
			local frame = vgui.Create("DFrame")
			frame:SetSize(500,490)
			frame:MakePopup()
			frame:Center()
			frame:SetTitle("Loadout Check")
			frame.Paint = function ()
				surface.SetDrawColor(Color(32, 32, 32, 255))
				surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())

				draw.RoundedBox(0,10,40,480,55,Color(207, 207, 207))
				draw.DrawText("Player Data", "IG_Dynamic_Text", 15,45, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("SteamID: "..weapontable["SteamID"], "IG_Dynamic_Text", 15,60, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)

				draw.RoundedBox(0,10,100,480,120,Color(207, 207, 207))
				draw.DrawText("Loadout #1 Data", "IG_Dynamic_Text", 15,105, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Purchased: "..tostring(weapontable["First"]["Purchased"]), "IG_Dynamic_Text", 15,120, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Regiment: "..weapontable["First"]["Regiment"], "IG_Dynamic_Text", 15,135, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Active: "..tostring(weapontable["First"]["Active"]), "IG_Dynamic_Text", 15,150, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Primary: "..weapontable["First"]["Loadout"]["Primary"], "IG_Dynamic_Text", 15,165, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Secondary: "..weapontable["First"]["Loadout"]["Secondary"], "IG_Dynamic_Text", 15,180, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Specialist: "..weapontable["First"]["Loadout"]["Spec"], "IG_Dynamic_Text", 15,195, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)

				draw.RoundedBox(0,10,225,480,120,Color(207, 207, 207))
				draw.DrawText("Loadout #2 Data", "IG_Dynamic_Text", 15,230, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Purchased: "..tostring(weapontable["Second"]["Purchased"]), "IG_Dynamic_Text", 15,245, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Regiment: "..weapontable["Second"]["Regiment"], "IG_Dynamic_Text", 15,260, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Active: "..tostring(weapontable["Second"]["Active"]), "IG_Dynamic_Text", 15,275, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Primary: "..weapontable["Second"]["Loadout"]["Primary"], "IG_Dynamic_Text", 15,290, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Secondary: "..weapontable["Second"]["Loadout"]["Secondary"], "IG_Dynamic_Text", 15,305, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Specialist: "..weapontable["Second"]["Loadout"]["Spec"], "IG_Dynamic_Text", 15,320, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)

				draw.RoundedBox(0,10,350,480,120,Color(207, 207, 207))
				draw.DrawText("Loadout #3 Data", "IG_Dynamic_Text", 15,355, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Purchased: "..tostring(weapontable["Third"]["Purchased"]), "IG_Dynamic_Text", 15,370, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Regiment: "..weapontable["Third"]["Regiment"], "IG_Dynamic_Text", 15,385, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Active: "..tostring(weapontable["Third"]["Active"]), "IG_Dynamic_Text", 15,400, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Primary: "..weapontable["Third"]["Loadout"]["Primary"], "IG_Dynamic_Text", 15,415, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Secondary: "..weapontable["Third"]["Loadout"]["Secondary"], "IG_Dynamic_Text", 15,430, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
				draw.DrawText("Specialist: "..weapontable["Third"]["Loadout"]["Spec"], "IG_Dynamic_Text", 15,445, Color(32, 32, 32,255), TEXT_ALIGN_LEFT)
			end
		end)
end