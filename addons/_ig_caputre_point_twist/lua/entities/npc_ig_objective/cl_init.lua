include("shared.lua")

IG_OBJECT_MODEL = "models/capturepoint/twist/rebel.mdl"

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "IG_OBJECTIVE_NAME" )
    self:NetworkVar( "Int", 0, "IG_OBJECTIVE_ALLY" )
    self:NetworkVar( "Int", 1, "IG_OBJECTIVE_HOSTILE" )
end

surface.CreateFont("IG_Dynamic_Title", {
	font = "Arial",
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	antialias = true,
	outline = false,
})

surface.CreateFont("IG_Dynamic_Title2", {
	font = "Arial",
	extended = false,
	size = 60,
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

function draw.Circle( x, y, radius, seg )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.DrawPoly( cir )
end

function ENT:Draw()
	local map = function(n, start1, stop1, start2, stop2) return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2 end
	local pos = self:LocalToWorld(Vector(0, 0, -55))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
	local objective_colour = Color(227, 227, 227, 50)

	if self:GetIG_OBJECTIVE_ALLY() < 100 and self:GetIG_OBJECTIVE_HOSTILE() < 100 then
		objective_colour = Color(227, 227, 227, 50)
		self:SetModel("models/capturepoint/twist/base.mdl")
	elseif self:GetIG_OBJECTIVE_ALLY() < 100 then
		objective_colour = Color(245, 66, 66, 50)
		self:SetModel(IG_OBJECT_MODEL)
	elseif self:GetIG_OBJECTIVE_HOSTILE() < 100 then
		objective_colour = Color(66, 135, 245, 50)
		self:SetModel("models/capturepoint/twist/imp.mdl")
	end
	self:DrawModel()
	--[[ Old UI above Model for capturing
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetDrawColor(24, 31, 41,220)
	    	surface.DrawRect(-200, -650, 400, 100)
	    	if self:GetIG_OBJECTIVE_ALLY() > 0 then
				surface.SetDrawColor(Color(66, 135, 245, 100))
	        	surface.DrawRect(-200, -650, map(math.Clamp(self:GetIG_OBJECTIVE_ALLY(), 0, 100), 0, 100, 0, 400), 100)
			elseif self:GetIG_OBJECTIVE_HOSTILE() > 0 then
				surface.SetDrawColor(Color(245, 66, 66, 100))
	        	surface.DrawRect(-200, -650, map(math.Clamp(self:GetIG_OBJECTIVE_HOSTILE(), 0, 100), 0, 100, 0, 400), 100)
			end
			draw.SimpleText("Objective: "..self:GetIG_OBJECTIVE_NAME(), "IG_Dynamic_Title", 0, -600, Color(255,255,255), 1, 1)
		cam.End3D2D()
	]]--

	-- Circle on the Floor
		local pos = self:LocalToWorld(Vector(3.1, -0.5, -67))
		local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
		cam.Start3D2D(pos, ang, 0.1)
			surface.SetDrawColor(objective_colour)
			draw.NoTexture()
			draw.Circle( 0,0, 2000, 100)
		cam.End3D2D()
end

net.Receive("IG_OBJECT_NAME_OPEN", function()

	local object_name = net.ReadString()
	local entityname =  net.ReadEntity()

	local temp_title = ""

	local frame = vgui.Create("DFrame")
		frame:SetSize(300,290)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Capture Point Editor")
		frame.Paint = function ()
			surface.SetDrawColor(Color(32, 32, 32, 255))
			surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		end

	local textname = vgui.Create( "DTextEntry", frame)
		textname:SetSize(280,30)
		textname:SetPos(10,50)
		textname:SetMultiline(false)
		textname:SetText("Enter Objective Name")
		textname.OnChange = function( self, value )
			temp_title = self:GetValue()
		end

	local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(280,30)
		confirm:SetPos(10,250)
		confirm:SetText("Confirm Name")
		confirm.DoClick = function()
			if temp_title == "" then
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Title name needs to be entered.")
			else
				net.Start("IG_OBJECT_NAME_EDIT")
					net.WriteString(temp_title)
					net.WriteEntity(entityname)
				net.SendToServer()
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Updating objective name.")
				frame:Close()
			end
		end
end)

net.Receive("IG_OBJECT_EDIT_MENU", function()

	local object_name = net.ReadString()
	local entityname =  net.ReadEntity()

	local temp_faction = ""
	local temp_num = 0

	local frame = vgui.Create("DFrame")
		frame:SetSize(300,290)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Capture Point Editor")
		frame.Paint = function ()
			surface.SetDrawColor(Color(32, 32, 32, 255))
			surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		end

	local LabelTimer = vgui.Create( "DLabel", frame )
		LabelTimer:SetPos( 10, 25 )
		LabelTimer:SetSize(280,30)
		LabelTimer:SetText( "Respawn Timer:" )

	local Wang = vgui.Create("DNumberWang", frame)
		Wang:SetSize(280,30)
		Wang:SetPos(10,50)
		Wang:SetMin(0)
		Wang:SetMax(100)
		Wang.OnValueChanged = function(self)
			temp_num = self:GetValue()
		end

	local capturelist = vgui.Create("DComboBox", frame)
		capturelist:SetSize(280,30)
		capturelist:SetPos(10,90)
		capturelist:SetValue("Select Enemy Faction")
			capturelist:AddChoice("Rebel")
			capturelist:AddChoice("CIS")
			capturelist:AddChoice("Republic")
		capturelist.OnSelect = function( self, index, value )
			temp_faction = value
		end

	local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(280,30)
		confirm:SetPos(10,250)
		confirm:SetText("Confirm Name")
		confirm.DoClick = function()
			if temp_faction == "" then
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Faction needs to be selected.")
			else
				net.Start("IG_OBJECT_EDIT_MENU_SEND")
					net.WriteString(temp_faction)
					net.WriteInt(temp_num, 32)
				net.SendToServer()
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Updating objective name.")
				frame:Close()
				if temp_faction == "Rebel" then
					IG_OBJECT_MODEL = "models/capturepoint/twist/rebel.mdl"
				elseif temp_faction == "CIS" then
					IG_OBJECT_MODEL = "models/capturepoint/twist/cis.mdl"
				elseif temp_faction == "Republic" then
					IG_OBJECT_MODEL = "models/capturepoint/twist/republic.mdl"
				end
			end
		end
end)

net.Receive("IG_OBJECT_SOUND_CAPTURE", function()
	local capture_string = net.ReadString()
	if capture_string == "IMP CAPTURE" then
		local fart = math.random(1, 3)
		surface.PlaySound("capture/impcapture0"..fart..".wav")
	else
		local fart = math.random(1, 4)
		surface.PlaySound("capture/imploss0"..fart..".wav")
	end
end)

net.Receive("IG_OBJECT_SPAWN_MENU_OPEN", function()
	local object_table = net.ReadTable()
	local playerec = net.ReadBool()
	local x = ScrW()
    local y = ScrH()
	local object_name = net.ReadString()
	local temp_title = ""
	local cam_position = 1000
	local cam_def = false
	local frame = vgui.Create("DFrame")
		frame:SetSize(x,y)
		frame:MakePopup()
		frame:Center()
		frame:SetDraggable( false )
		frame:ShowCloseButton( false )
		frame:SetTitle("")
		frame.Paint = function ()
			surface.SetDrawColor(Color(32, 32, 32, 200))
			surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
			draw.DrawText("CAPTURE POINT", "IG_Dynamic_Title2", x/2,45, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			draw.DrawText("SPAWN MENU", "IG_Dynamic_Title2", x/2,90, Color(255,255,255,255), TEXT_ALIGN_CENTER)
			draw.DrawText("Select a capture point to spawn at", "IG_Dynamic_Title", x/2,145, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

	local default =	vgui.Create("DButton", frame)
		default:SetSize(280,30)
		default:SetPos((x/2)-140,230)
		default:SetTextColor( Color(255,255,255) )
		default:SetText("Spawn at Default Location")
		default.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, 40, Color(32, 32, 32, 230))
			if(default:IsHovered()) then
				if cam_def == false then
					cam_position = 1000
					net.Start("IG_OBJECT_SPAWN_MENU_CAM_DEF")
					net.SendToServer()
					cam_def = true
				end
			end
		end
		default.DoClick = function()
			net.Start("IG_OBJECT_SPAWN_MENU_CONF_DEF")
			net.SendToServer()
			frame:Close()
		end

	for k, v in pairs(object_table) do
		local object_spawnable = true
		local objective_colour = Color(32, 32, 32, 230)
		if v:GetIG_OBJECTIVE_ALLY() < 100 and v:GetIG_OBJECTIVE_HOSTILE() < 100 then
			objective_colour = Color(32, 32, 32, 230)
			object_spawnable = false
		elseif v:GetIG_OBJECTIVE_ALLY() < 100 then
			objective_colour = Color(245, 66, 66, 230)
			if playerec == true then
				object_spawnable = true
			else
				object_spawnable = false
			end
		elseif v:GetIG_OBJECTIVE_HOSTILE() < 100 then
			objective_colour = Color(66, 135, 245, 230)
			if playerec == false then
				object_spawnable = true
			else
				object_spawnable = false
			end
		end

		local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(280,30)
		confirm:SetPos((x/2)-140,230+(k*40))
		confirm:SetTextColor( Color(255,255,255) )
		confirm:SetText("Objective: "..v:GetIG_OBJECTIVE_NAME())
		confirm.Paint = function( self, w, h )
			draw.RoundedBox(0, 0, 0, w, 40, objective_colour)
			if(confirm:IsHovered()) then
				if object_spawnable == true then
					cam_def = false
					if cam_position == k then
					else
						cam_position = k
						net.Start("IG_OBJECT_SPAWN_MENU_CAM")
							net.WriteEntity(v)
						net.SendToServer()
					end
				end
			end
		end

		confirm.DoClick = function()
			if object_spawnable == true then
				net.Start("IG_OBJECT_SPAWN_MENU_CONF")
					net.WriteEntity(v)
				net.SendToServer()
				frame:Close()
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Spawning you at Capture point: "..v:GetIG_OBJECTIVE_NAME())
			else
				chat.AddText(Color(235, 64, 52), "[OBJECTIVE] ", Color(255, 255, 255), "Capture point: "..v:GetIG_OBJECTIVE_NAME().. " is not held by you")
			end
		end
	end
end)

hook.Add("HUDPaint", "IG_CAPTURE_HUD", function()
	if ents.FindByClass("npc_ig_objective")[1] then
        local heightExtender = 0;

        //calculate height of the box
        for _, v in pairs(ents.FindByClass("npc_ig_objective")) do
            surface.SetFont("Trebuchet18");
            local textWidth, textHeight = surface.GetTextSize("Objective: "..v:GetIG_OBJECTIVE_NAME().." | State: ");
            heightExtender = heightExtender + textHeight;
        end

        _G.vanillaBlurPanel(ScrW() * 0.745,ScrH() * 0.265, ScrW() * 0.245, ScrH() * 0.051 + heightExtender,Color(0,0,0,100));

        surface.SetDrawColor( 255, 255, 255, 200 );
        surface.DrawRect(ScrW() * 0.75,ScrH() * 0.3,ScrW() * 0.234,ScrH() * 0.0025);

	    surface.SetFont("vanilla_font_info")
	    surface.SetTextColor(255,255,255,200)

	    surface.SetTextPos(ScrW() * 0.75,ScrH() * 0.275)
	    surface.DrawText("CURRENT CAPTURE POINTS")
	    local fart = "Neutral Controlled"
	    local distancefart = 0.31
	    for k, v in pairs(ents.FindByClass("npc_ig_objective")) do
	    	if k == 1 then distancefart = 0.31 else distancefart = distancefart + 0.015 end
	    	if v:GetIG_OBJECTIVE_ALLY() < 100 and v:GetIG_OBJECTIVE_HOSTILE() < 100 then
				fart = "Contested Point"
				surface.SetTextColor(255,255,255,200)
			elseif v:GetIG_OBJECTIVE_ALLY() < 100 then
				fart = "Hostile Controlled"
				surface.SetTextColor(245, 66, 66,200)
			elseif v:GetIG_OBJECTIVE_HOSTILE() < 100 then
				fart = "Imperial Controlled"
				surface.SetTextColor(66, 135, 245,200)
			end
	    	surface.SetFont("Trebuchet18")
		    surface.SetTextPos(ScrW() * 0.75, ScrH() * distancefart)
		    surface.DrawText("Objective: "..v:GetIG_OBJECTIVE_NAME().." | State: ".. fart )
	    end
	end

	local map = function(n, start1, stop1, start2, stop2) return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2 end

	for k, v in ipairs( ents.FindInSphere(LocalPlayer():GetPos(),180) ) do
		if v:GetClass() == "npc_ig_objective" then
		    local w = ScrW() / 7.5
		    local h = ScrH() * 0.045
		    local x = ScrW() * 0.5 - (w/2)
		    local y = ScrH() * 0.915
	    	_G.vanillaBlurPanel(x,y,w,h,Color(0,0,0,100));
	    	if v:GetIG_OBJECTIVE_ALLY() > 0 then
                _G.vanillaBlurPanel(x,y, map(math.Clamp(v:GetIG_OBJECTIVE_ALLY(), 0, 100), 0, 100, 0, w), h,Color(66, 135, 245, 100));
			elseif v:GetIG_OBJECTIVE_HOSTILE() > 0 then
                _G.vanillaBlurPanel(x,y, map(math.Clamp(v:GetIG_OBJECTIVE_HOSTILE(), 0, 100), 0, 100, 0, w), h,Color(245, 66, 66, 100));
			end
		    draw.SimpleText("Objective: "..v:GetIG_OBJECTIVE_NAME(), "IG_Dynamic_Sub",x+(w/2),y+(h/2), Color(255,255,255), 1, 1)
		end
	end
end)
