surface.CreateFont("awrc_subtitle", {size = 15, weight = 500})

local colours = {
	primary = Color(32, 32, 32, 255),
	secondary = Color(150, 150, 150, 255),
	highlight = Color(110, 0, 227, 255),
	bracket = Color(0, 0, 0, 255),
	msgColor = Color(255, 255, 255, 255)
}

local targetUserID = ""

net.Receive("awrc_OpenInterface", function(len)
	local data = net.ReadTable()
	print("[AWR CLEARANCES] Networked users  table is as follows: ")
	PrintTable(data)
	AwrDisplayInterface(data)
end)

net.Receive("awrc_MessageClient", function(len)
	local msg = net.ReadString()
	AwrShowChat(msg)
end)

function AwrShowChat (msg)
	chat.AddText(colours.bracket, "[", colours.highlight, "AWRC", colours.bracket, "] ", colours.msgColor, msg)
end

function AwrDisplayInterface (existingUsers)
	local w = ScrW()
	local h = ScrH()

	local frame = vgui.Create("DFrame")
	frame:SetSize(0.5 * w, 0.5 * h)
	frame:SetTitle("AWR Clearances")
	frame:Center()
	frame:MakePopup()
	frame.Paint = function ()
		surface.SetDrawColor(colours.primary)
		surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
	end

	local sheet = vgui.Create("DPropertySheet", frame)
	sheet:Dock(FILL)

	local addUserTab = vgui.Create("DPanel", sheet, "nil", false, false, "Grant a user AWR Clearance")
	sheet:AddSheet("Add Users", addUserTab)
	addUserTab.Paint = function()
		surface.SetDrawColor(colours.secondary)
		surface.DrawRect(0, 0, addUserTab:GetWide(), addUserTab:GetTall())
	end

	local onlinePlayersList = vgui.Create("DListView", addUserTab)
	onlinePlayersList:Dock(LEFT)
	onlinePlayersList:SetSize(0.75 * frame:GetWide(), sheet:GetTall())
	onlinePlayersList:SetMultiSelect(false)
	onlinePlayersList:AddColumn("Name")
	onlinePlayersList:AddColumn("Regiment")
	onlinePlayersList:AddColumn("Rank")
	onlinePlayersList:AddColumn("Steam ID")
	for k, v in pairs(player.GetAll()) do
		onlinePlayersList:AddLine(v:Nick(), v:GetRegiment(), v:GetRankName(), v:SteamID())
	end
	onlinePlayersList.OnRowSelected = function(lst, index, pnl)
		targetUserID = pnl:GetColumnText(4)
	end

	local grantClearanceBtn = vgui.Create("DButton", addUserTab)
	grantClearanceBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
	local desiredX = 0.875 * frame:GetWide() - 0.5 * grantClearanceBtn:GetWide() - 0.01 * frame:GetWide()
	grantClearanceBtn:SetPos(desiredX, 0.1 * frame:GetTall() - 0.5 * grantClearanceBtn:GetTall())
	grantClearanceBtn:SetText("Grant Access")
	grantClearanceBtn.DoClick = function ()
		if (targetUserID ~= "") then
			net.Start("awrc_AddNewUser")
			net.WriteString(targetUserID)
			net.SendToServer()
			frame:Close()
		end
	end

	local grantAccessTxt = vgui.Create("DLabel", addUserTab)
	grantAccessTxt:SetFont("awrc_subtitle")
	grantAccessTxt:SetTextColor(colours.primary)
	grantAccessTxt:SetText("Grant Selected User AWR Access")
	grantAccessTxt:SizeToContents()
	grantAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantAccessTxt:GetWide(), 0.04 * frame:GetTall())

	local addSteamIDBtn = vgui.Create("DButton", addUserTab)
	addSteamIDBtn:SetText("Grant SteamID Access")
	addSteamIDBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
	addSteamIDBtn:SetPos(desiredX, 0.81 * frame:GetTall() - 0.5 * addSteamIDBtn:GetTall())

	local nameInput = vgui.Create("DTextEntry", addUserTab)
	nameInput:SetPlaceholderText("Name...")
	nameInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
	desiredX = 0.875 * frame:GetWide() - 0.5 * nameInput:GetWide() - 0.01 * frame:GetWide()
	nameInput:SetPos(desiredX, 0.69 * frame:GetTall() - 0.5 * nameInput:GetTall())

	local steamIDInput = vgui.Create("DTextEntry", addUserTab)
	steamIDInput:SetPlaceholderText("Steam ID...")
	steamIDInput:SetSize(0.2 * frame:GetWide(), 0.05 * frame:GetTall())
	steamIDInput:SetPos(desiredX, 0.75 * frame:GetTall() - 0.5 * steamIDInput:GetTall())

	addSteamIDBtn.DoClick = function ()
		net.Start("awrc_AddOfflineUser")
		net.WriteString(nameInput:GetText())
		net.WriteString(steamIDInput:GetText())
		net.SendToServer()
		frame:Close()
	end

	local grantSteamIDAccessTxt = vgui.Create("DLabel", addUserTab)
	grantSteamIDAccessTxt:SetFont("awrc_subtitle")
	grantSteamIDAccessTxt:SetTextColor(colours.primary)
	grantSteamIDAccessTxt:SetText("Grant Steam ID AWR Access")
	grantSteamIDAccessTxt:SizeToContents()
	grantSteamIDAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * grantSteamIDAccessTxt:GetWide(), 0.63 * frame:GetTall())

	local removeUserTab = vgui.Create("DPanel", sheet)
	sheet:AddSheet("Manage Users", removeUserTab)
	removeUserTab.Paint = function()
		surface.SetDrawColor(colours.secondary)
		surface.DrawRect(0, 0, removeUserTab:GetWide(), removeUserTab:GetTall())
	end

	local registeredPlayersList = vgui.Create("DListView", removeUserTab)
	registeredPlayersList:Dock(LEFT)
	registeredPlayersList:SetSize(0.75 * frame:GetWide(), sheet:GetTall())
	registeredPlayersList:SetMultiSelect(false)
	registeredPlayersList:AddColumn("Name")
	registeredPlayersList:AddColumn("Steam ID")
	registeredPlayersList:AddColumn("Added By")
	if not existingUsers["error"] then
		for k, v in pairs(existingUsers) do
			registeredPlayersList:AddLine(v["name"], k, v["addedBy"])
		end
	end
	registeredPlayersList.OnRowSelected = function(lst, index, pnl)
		targetUserID = pnl:GetColumnText(2)
	end

	local revokeAccessBtn = vgui.Create("DButton", removeUserTab)
	revokeAccessBtn:SetText("Revoke Access")
	revokeAccessBtn:SetSize(0.15 * frame:GetWide(), 0.05 * frame:GetTall())
	desiredX = 0.875 * frame:GetWide() - 0.5 * revokeAccessBtn:GetWide() - 0.01 * frame:GetWide()
	revokeAccessBtn:SetPos(desiredX, 0.1 * frame:GetTall() - 0.5 * revokeAccessBtn:GetTall())
	revokeAccessBtn.DoClick = function ()
		if (targetUserID ~= "") then
			net.Start("awrc_RemoveUser")
			net.WriteString(targetUserID)
			net.SendToServer()
			frame:Close()
		end
	end

	local revokeAccessTxt = vgui.Create("DLabel", removeUserTab)
	revokeAccessTxt:SetFont("awrc_subtitle")
	revokeAccessTxt:SetTextColor(colours.primary)
	revokeAccessTxt:SetText("Revoke Selected Users Access")
	revokeAccessTxt:SizeToContents()
	revokeAccessTxt:SetPos(0.865 * frame:GetWide() - 0.5 * revokeAccessTxt:GetWide(), 0.04 * frame:GetTall())
end