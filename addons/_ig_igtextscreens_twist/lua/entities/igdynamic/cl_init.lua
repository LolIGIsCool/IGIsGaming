include("shared.lua")
// Fonts
	surface.CreateFont("IG_DYANMIC_TEXT_LARGE", {
		font = "Arial",
		extended = false,
		size = 90,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})
	surface.CreateFont("IG_DYANMIC_TEXT_RED", {
		font = "Arial",
		extended = false,
		size = 70,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})
	surface.CreateFont("IG_DYANMIC_TEXT_SMALL", {
		font = "Arial",
		extended = false,
		size = 40,
		weight = 500,
		blursize = 0,
		antialias = true,
		outline = false,
	})

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "Title" )
    self:NetworkVar( "String", 1, "Type" )
    self:NetworkVar( "String", 2, "Clearance" )
    self:NetworkVar( "String", 3, "Clearance2" )
end

function ENT:Initialize()
    self:SetRenderMode(RENDERMODE_NORMAL)
    if self:GetTitle() == "" then
    	self:SetTitle("[TITLE]")
    	self:SetType("[AREA TYPE]")
    	self:SetClearance("[AREA CLEARANCE]")
    	self:SetClearance2("[SECOND AREA CLEARANCE]")
    end
end

function ENT:Draw()
	self:DrawModel()
    
    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 1000) then
        local pos = self:LocalToWorld(Vector(3.1, -0.5, -27))
        local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
        cam.Start3D2D(pos, ang, 0.1)
            draw.RoundedBox(0, -470, 460, 900, -950, Color(255, 255, 255,0))
            draw.SimpleText(self:GetTitle(), "IG_DYANMIC_TEXT_LARGE", 0, -375, Color(255,255,255),1,1)
            if self:GetType() != "N/A" then
                draw.SimpleText(self:GetType(), "IG_DYANMIC_TEXT_RED", 0, -290, Color(255,0,0),1,1)
            end
            if self:GetClearance() != "N/A" then
                draw.SimpleText(self:GetClearance(), "IG_DYANMIC_TEXT_SMALL", 0, -220, Color(255,255,255),1,1)
            end
            if self:GetClearance2() != "N/A" or self:GetClearance2() == "" then
                draw.SimpleText("or", "IG_DYANMIC_TEXT_SMALL", 0, -185, Color(255,255,255),1,1)
                draw.SimpleText(self:GetClearance2(), "IG_DYANMIC_TEXT_SMALL", 0, -145, Color(255,255,255),1,1)
            end
        cam.End3D2D()
    end
end

net.Receive("IG_DYNAMIC_BOARD_OPEN", function()
	local EntityID = net.ReadInt(16)
	local EntityPort = net.ReadEntity()
	local caller = LocalPlayer()
	local temp = {
		["Title"] = "",
		["AreaType"] = "N/A",
		["FirstClearance"] = "N/A",
		["SecondClearance"] = "N/A",
	}
	local frame = vgui.Create("DFrame")
		frame:SetSize(300,290)
		frame:MakePopup()
		frame:Center()
		frame:SetTitle("Text Screen Editor")
		frame.Paint = function ()
			surface.SetDrawColor(Color(32, 32, 32, 255))
			surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		end

	local textname = vgui.Create( "DTextEntry", frame)
		textname:SetSize(280,30)
		textname:SetPos(10,50)
		textname:SetMultiline(false)
		textname:SetText("Enter Area Location Name *")
		textname.OnChange = function( self, value )
			temp["Title"] = self:GetValue()
		end

	local comboarea = vgui.Create("DComboBox", frame)
		comboarea:SetSize(280,30)
		comboarea:SetPos(10,100)
		comboarea:SetValue("Enter area type")
			comboarea:AddChoice("Enlisted Access")
			comboarea:AddChoice("Non-Commissioned Access")
			comboarea:AddChoice("Officer Access")
			comboarea:AddChoice("Senior-Grade Officer Access")
			comboarea:AddChoice("Command Access")
			comboarea:AddChoice("Senior-Grade Command Access")
        	comboarea:AddChoice("Military Command Access")
			comboarea:AddChoice("Executive Access")
			comboarea:AddChoice("Restricted Access")
		comboarea.OnSelect = function( self,  value , index)
			temp["AreaType"] = index
		end

	local combocl = vgui.Create("DComboBox", frame)
		combocl:SetSize(280,30)
		combocl:SetPos(10,150)
		combocl:SetValue("Enter Required Clearance")
			combocl:AddChoice("Medical Clearance")
			combocl:AddChoice("Administrative Clearance")
			combocl:AddChoice("Operations Clearance")
			combocl:AddChoice("Death Trooper Clearance")
			combocl:AddChoice("Inquisitorius Clearance")
			combocl:AddChoice("Intelligence Clearance")
			combocl:AddChoice("Military Security Clearance")
			combocl:AddChoice("Imperial Security Clearance")
			combocl:AddChoice("COMPNOR Personnel")
        	combocl:AddChoice("Military Personnel")
        	combocl:AddChoice("Special Operations Brigade Personnel")
			combocl:AddChoice("Advanced Weapons Research Clearance")
			combocl:AddChoice("Royal Clearance")
			combocl:AddChoice("Imperial Contracted Bounty Hunter ID")
			combocl:AddChoice("Imperial Civillian ID")
    	  	combocl:AddChoice("Maintenance Clearance")
			combocl:AddChoice("N/A")
		combocl.OnSelect = function( self,  value , index)
			temp["FirstClearance"] = index
		end

	local combocl2 = vgui.Create("DComboBox", frame)
		combocl2:SetSize(280,30)
		combocl2:SetPos(10,200)
		combocl2:SetValue("Enter Required Clearance")
			combocl2:AddChoice("Medical Clearance")
			combocl2:AddChoice("Administrative Clearance")
			combocl2:AddChoice("Death Trooper Clearance")
			combocl2:AddChoice("Maintenance Clearance")
			combocl2:AddChoice("Inquisitorius Clearance")
			combocl2:AddChoice("Intelligence Clearance")
			combocl2:AddChoice("Military Security Clearance")
			combocl2:AddChoice("Imperial Security Clearance")
       		combocl:AddChoice("COMPNOR Personnel")
        	combocl:AddChoice("Military Personnel")
        	combocl:AddChoice("Special Operations Brigade Personnel")
			combocl2:AddChoice("Advanced Weapons Research Clearance")
			combocl2:AddChoice("Royal Clearance")
			combocl2:AddChoice("Imperial Contracted Bounty Hunter ID")
			combocl2:AddChoice("Imperial Civillian ID")
     		combocl2:AddChoice("Maintenance Clearance")
			combocl2:AddChoice("N/A")
		combocl2.OnSelect = function( self,  value , index)
			temp["SecondClearance"] = index
		end

	local confirm =	vgui.Create("DButton", frame)
		confirm:SetSize(280,30)
		confirm:SetPos(10,250)
		confirm:SetText("Confirm Placings")
		confirm.DoClick = function()
			if temp["Title"] == "" or temp["AreaType"] == "" or temp["FirstClearance"] == "" then
				chat.AddText(Color(235, 64, 52), "[TEXT SCREEN] ", Color(255, 255, 255), "Title name needs to be entered.")
			else
				net.Start("IG_DYNAMIC_BOARD_EDIT")
					net.WriteTable(temp)
					net.WriteInt(EntityID, 16)
					net.WriteEntity(EntityPort)
				net.SendToServer()
				chat.AddText(Color(235, 64, 52), "[TEXT SCREEN] ", Color(255, 255, 255), "Updating textscreen.")
				frame:Close()
			end
		end
end)
