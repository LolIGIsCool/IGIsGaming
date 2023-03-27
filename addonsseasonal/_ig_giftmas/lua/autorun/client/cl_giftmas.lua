surface.CreateFont("bebas_32", {
	font = "Bebas Neue",
	size = 32
})

net.Receive("IGOpenGiftMenu", function()
	local steamid = ""
	local message = ""
	local credits = 0
	local pointshopitem = ""
	local GiftFrame = vgui.Create("DFrame")
	GiftFrame:SetPos(ScrW() / 2, ScrH() / 2)
	GiftFrame:SetSize(ScrW() * 0.4, ScrH() * 0.6)
	GiftFrame:SetTitle("")
	GiftFrame:Center()
	GiftFrame:SetVisible(true)
	GiftFrame:SetDraggable(false)
	GiftFrame:ShowCloseButton(true)
	GiftFrame:MakePopup()
	local blur = Material("pp/blurscreen")
	local scrw = ScrW()
	local scrh = ScrH()

	function util.DrawBlur(p, a, d)
		local x, y = p:LocalToScreen(0, 0)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(blur)

		for i = 1, d do
			blur:SetFloat("$blur", (i / d) * a)
			blur:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(x * -1, y * -1, scrw, scrh)
		end
	end

	GiftFrame.Paint = function(s, w, h)
		util.DrawBlur(s, 2, 1)
		surface.SetDrawColor(0, 0, 0, 240)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.SetDrawColor(Color(200, 200, 200))
		surface.DrawRect(0, 0, w, 36)
		surface.SetDrawColor(Color(241, 240, 240))
		surface.DrawRect(0, 0, w, 32)
		draw.SimpleText("SteamID32", "bebas_32", s:GetWide() * 0.1, s:GetTall() * 0.07, Color(120, 120, 120))
		draw.SimpleText("Message", "bebas_32", s:GetWide() * 0.1, s:GetTall() * 0.15, Color(120, 120, 120))
		draw.SimpleText("Credits", "bebas_32", s:GetWide() * 0.1, s:GetTall() * 0.325, Color(120, 120, 120))
		draw.SimpleText("Pointshop Item", "bebas_32", s:GetWide() * 0.1, s:GetTall() * 0.5, Color(120, 120, 120))
		draw.SimpleText("Gift Menu", "bebas_32", 6, 2, Color(120, 120, 120))
	end

	local GiftFramecl = vgui.Create("DButton", GiftFrame)
	GiftFramecl:SetSize(36, 36)
	GiftFramecl:SetPos(GiftFrame:GetWide() - 36, 0)
	GiftFramecl:SetText("")

	GiftFramecl.DoClick = function(_)
		GiftFrame:Remove()
	end

	GiftFramecl.Paint = function(s, w, h)
		surface.SetDrawColor(Color(201, 51, 40))
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Color(231, 76, 60))
		surface.DrawRect(0, 0, w, h - 4)
		draw.SimpleText("✕", "bebas_32", w / 2, h / 2 - 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if (s:IsHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 50))
			surface.DrawRect(0, 0, w, h)
		end
	end

	GiftFramecr = vgui.Create("DButton", GiftFrame)
	GiftFramecr:SetPos(GiftFrame:GetWide() / 2 - 96, GiftFrame:GetTall() * 0.9)
	GiftFramecr:SetSize(96 * 2, 48)
	GiftFramecr:CenterHorizontal()
	GiftFramecr:SetText("")

	local function CanSendGift()
		return (steamid ~= "" and message ~= "" and credits >= 0 and credits < 100001)
	end

	GiftFramecr.Paint = function(s, w, h)
		if CanSendGift() then
			s:SetEnabled(true)
			surface.SetDrawColor(Color(39, 174, 96))
		else
			s:SetEnabled(false)
			surface.SetDrawColor(Color(40, 40, 40))
		end

		surface.DrawRect(0, 0, w, h)

		if CanSendGift() then
			surface.SetDrawColor(Color(46, 204, 113))
		else
			surface.SetDrawColor(Color(40, 40, 40))
		end

		surface.DrawRect(0, 0, w, h - 4)

		if (s:IsHovered()) then
			surface.SetDrawColor(Color(255, 255, 255, 50))
			surface.DrawRect(0, 0, w, h)
		end

		draw.SimpleText("Send Gift", "bebas_32", w / 2, h / 2, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	GiftFramecr.DoClick = function(_)
		if pointshopitem == "" then
			pointshopitem = "none"
		end

		net.Start("IGSendGift")
		net.WriteString(tostring(steamid))
		net.WriteString(tostring(message))
		net.WriteString(tostring(credits))
		net.WriteString(tostring(pointshopitem))
		net.SendToServer()
		GiftFrame:Remove()
	end

	local Giftframesteamid = vgui.Create("DTextEntry", GiftFrame)
	Giftframesteamid:SetPos(0, GiftFrame:GetTall() * 0.07)
	Giftframesteamid:SetUpdateOnType(true)
	Giftframesteamid:SetSize(GiftFrame:GetWide() * 0.2, GiftFrame:GetTall() * 0.04)
	Giftframesteamid:SetPlaceholderText("Eg.   STEAM_0:0:12345678")
	Giftframesteamid:SetNumeric(false)
	Giftframesteamid:CenterHorizontal()

	Giftframesteamid.OnValueChange = function(self)
		steamid = self:GetValue()
	end

	local Giftframemessage = vgui.Create("DTextEntry", GiftFrame)
	Giftframemessage:SetPos(0, GiftFrame:GetTall() * 0.12)
	Giftframemessage:SetSize(GiftFrame:GetWide() * 0.3, GiftFrame:GetTall() * 0.1)
	Giftframemessage:SetUpdateOnType(true)
	Giftframemessage:SetMultiline(true)
	Giftframemessage:CenterHorizontal()
	Giftframemessage:SetPlaceholderText("Merry Christmas!")

	Giftframemessage.OnValueChange = function(self)
		message = self:GetValue()
	end

	local Giftframecredits = vgui.Create("DNumberWang", GiftFrame)
	Giftframecredits:SetPos(0, GiftFrame:GetTall() * 0.325)
	Giftframecredits:SetSize(GiftFrame:GetWide() * 0.1, GiftFrame:GetTall() * 0.05)
	Giftframecredits:CenterHorizontal()
	Giftframecredits:SetMin(0)
	Giftframecredits:SetMax(100000)

	Giftframecredits.OnValueChanged = function(self)
		credits = self:GetValue()
	end

	local Giftframepointshop = vgui.Create("DComboBox", GiftFrame)
	Giftframepointshop:SetValue("No item")
	Giftframepointshop:SetPos(0, GiftFrame:GetTall() * 0.5)
	Giftframepointshop:SetSize(GiftFrame:GetWide() * 0.2, GiftFrame:GetTall() * 0.05)
	Giftframepointshop:CenterHorizontal()

	function Giftframepointshop:OnSelect(index, text, data)
		pointshopitem = data
	end

	local allowedcats = {"primaries", "secondaries", "powerups", "specialties"}

	for k, v in pairs(SH_POINTSHOP.Items) do
		if not table.HasValue(allowedcats, v.Category) then continue end
		Giftframepointshop:AddChoice(v.Name, k)
	end
end)
