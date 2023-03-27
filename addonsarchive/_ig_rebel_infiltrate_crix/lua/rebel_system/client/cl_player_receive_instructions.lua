if (SERVER) then return end 

local frameColor = Color(47,54,64)

surface.CreateFont("CancelBtnFont", {
	font = "Roboto", 
	size = 20, 
	weight =1000
})
local acceptMission = function()
	local hate = vgui.Create("DFrame")
	hate:SetSize(ScrW() * 0.4, ScrH() * 0.4)
	hate:Center()
	hate:MakePopup()
	hate:SetTitle("")
	hate:SetDraggable(false)
	hate:ShowCloseButton(true)
	hate.Paint = function(self, w, h)
	    //background window
	    surface.SetDrawColor(Color(20,20, 20, 253))
	    surface.DrawRect(0,0,w,h)

	    //text
	    draw.SimpleText("Do you wish to assist the rebellion?","Trebuchet24",w * 0.9,h * 0.25,Color( 255, 255, 255, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
	    draw.SimpleText("> ACCEPT","Trebuchet24",w * 0.9,h * 0.5,Color( 200, 200, 200, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
	    draw.SimpleText("> REJECT","Trebuchet24",w * 0.9,h * 0.63,Color( 200, 200, 200, 255 ),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)

	    //rebel logo
	    surface.SetDrawColor(255,255,255)
	    surface.SetMaterial(Material("material/vanilla/rebel.png"))
	    surface.DrawTexturedRect(w * 0.1,h * 0.25,w * 0.2,w * 0.2)

	    //lines
	    surface.DrawCircle(w * 0.2,h * 0.435,125,255,255,255,255)
	    surface.DrawLine(w * 0.2,h * 0.435,w * 0.2,h)
	    surface.DrawLine(w * 0.2,0,w * 0.2,h * 0.145)
	    surface.DrawLine(w * 0.36,h * 0.4,w,h * 0.4)
	end

	local pain = vgui.Create("DButton",hate)
	pain:SetSize(ScrW() * 0.05,ScrH() * 0.03)
	pain:SetPos(ScrW() * 0.32,ScrH() * 0.2)
	pain:SetText("")
	pain.Paint = function(self,w,h)
	end
	pain.DoClick = function()
		hate:Close()
		net.Start("AcceptRebelMission")
		net.SendToServer()
	end

	local love = vgui.Create("DButton",hate)
	love:SetSize(ScrW() * 0.05,ScrH() * 0.03)
	love:SetPos(ScrW() * 0.32,ScrH() * 0.25)
	love:SetText("")
	love.Paint = function(self,w,h)
	end
	love.DoClick = function()
		hate:Close()
		net.Start("DenyRebelAssignment")
		net.SendToServer()
	end 
end

local missionDetails = function(txt) 
	if not txt then return end
	local w, h = ScrW() * 0.3 , ScrH() * 0.1
	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:Center()
	frame:MakePopup(true)
	frame:SetTitle("Mission Details")
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)


	--[[-------------------------------------------------------------------------
	Abort Button
	---------------------------------------------------------------------------]]
	local abort = vgui.Create("DButton", frame)
	abort:Dock(BOTTOM)
	--SetColor(Color(255,0,0))
	abort:SetText("Abort")
	abort.DoClick = function(self)
		frame:Close()
		net.Start("RebelMissionAborted")
		net.SendToServer()
	end
	--[[-------------------------------------------------------------------------
	Instructions
	---------------------------------------------------------------------------]]
	surface.SetFont("CancelBtnFont")
	local label_x, label_y = w * 0.05, h * 0.3
	local label_size_x, label_size_y = surface.GetTextSize(txt)
	local label = vgui.Create("DLabel",frame)
	label:SetSize(label_size_x, label_size_y)
	label:SetPos(label_x, label_y)
	label:SetText(txt)
	label:SetWrap(true)
	
end

local rebelListing = function(rebels)
	if not rebels then return end
	local w , h = ScrW() * 0.4, ScrH() * 0.5
	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:MakePopup(true)
	frame:Center()

	--[[-------------------------------------------------------------------------
	List view
	---------------------------------------------------------------------------]]
	local rebelist = vgui.Create("DListView", frame)
	rebelist:SetDataHeight(h * 0.35)
	rebelist:Dock(FILL)
	rebelist:SetMultiSelect( false )
	rebelist:AddColumn( "Rebel" )
	rebelist:AddColumn( "Name" )

	for k, v in pairs(rebels) do
		local ply = Entity(k)
		if not IsValid(ply) then continue end
		local icon = vgui.Create("SpawnIcon", frame)
		icon:SetModel(ply:GetModel())
		rebelist:AddLine(icon, ply:Nick())
	end

	--[[-------------------------------------------------------------------------
	close button
	---------------------------------------------------------------------------]]
	local closeBtn = vgui.Create("DButton", frame)
	local btnTxt = "Close"
	local btn_x, btn_y = surface.GetTextSize(btnTxt)
	closeBtn:SetSize(btn_x, btn_y)
	closeBtn:SetText(btnTxt)
	closeBtn:Dock(BOTTOM)

	closeBtn.DoClick = function(self)
		frame:Close()
	end
end

local rebelHistory = function(rebels)
	if not rebels then return end
	local w , h = ScrW() * 0.4, ScrH() * 0.5
	local frame = vgui.Create("DFrame")
	frame:SetSize(w, h)
	frame:SetDraggable(true)
	frame:ShowCloseButton(true)
	frame:MakePopup(true)
	frame:Center()

	--[[-------------------------------------------------------------------------
	List view
	---------------------------------------------------------------------------]]
	local rebelist = vgui.Create("DListView", frame)
	--rebelist:SetDataHeight(h * 0.35)
	rebelist:Dock(FILL)
	rebelist:SetMultiSelect( false )
	rebelist:AddColumn( "Name" )
	rebelist:AddColumn( "Date" )

	for k, v in pairs(rebels) do
		rebelist:AddLine(v['name'], v['date'])
	end
end 

net.Receive("CompleteHistory", function()
	local tbl = net.ReadTable()
	if not tbl then return end 
	rebelHistory(tbl)

end)

net.Receive("RebelMissionAssingment", acceptMission)

net.Receive("AdminRequestForRebelList", function()
	local tbl = net.ReadTable()
	if not tbl then return end 
	rebelListing(tbl)
end)

net.Receive("RebelMissionInstructions", function()
	local txt = net.ReadString()
	if not txt then return end 
	missionDetails(txt)
end)