--[[ Nykez 2017. Do not edit ]]--

if !CLIENT then return end
--------------
local PANEL = {}
PANEL.BaseMat = Material("starhud/derma/bg.png")
PANEL.TitleMat = Material("starhud/derma/top.png")
PANEL.LabelMat = Material("starhud/derma/label_holder.png")
PANEL.ButMat = Material("starhud/derma/close_n.png")
PANEL.ButMatHover = Material("starhud/derma/close_h.png")

function PANEL:Init()
self.Title = "Window"
self.lblTitle:Remove()
self.btnMaxim:Remove()
self.btnMinim:Remove()
end

function PANEL:SetPanelColor(col)
self.PanelColor = col
end

function PANEL:GetPanelColor()
return self.PanelColor
end

function PANEL:Paint()
local offset = self:GetTall()*.1
local th = offset*.85
local labelw = self:GetWide()*.25
local labelh = offset*.95
--
surface.SetDrawColor(255,255,255)
surface.SetMaterial(self.BaseMat)
local space = offset*.135
surface.DrawTexturedRect(0, offset - space, self:GetWide(), self:GetTall() - offset + space)
--
surface.SetDrawColor(255,255,255)
surface.SetMaterial(self.TitleMat)
surface.DrawTexturedRect(0, offset - th, self:GetWide(), th)

surface.SetDrawColor(255,255,255)
surface.SetMaterial(self.LabelMat)
surface.DrawTexturedRect(self:GetWide()/2 - (labelw/2), 0, labelw, labelh)

draw.SimpleText(self:GetTitle(), "StarHUDFontTitle", self:GetWide()/2, labelh/2, self:GetPanelColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:GetTitle()
return self.Title
end

function PANEL:SetTitle(str)
self.Title = str
end

function PANEL:PerformLayout()
	local titlePush = 0

	if ( IsValid( self.imgIcon ) ) then

		self.imgIcon:SetPos( 5, 5 )
		self.imgIcon:SetSize( 16, 16 )
		titlePush = 16

	end
	
	local bw = 24
	local xpos = self:GetWide()*.966 - (bw/2)
	local ypos = self:GetTall()*.1 - bw - (bw*.65)
	self.btnClose:SetSize( bw, bw )
	self.btnClose:SetPos( xpos, ypos )
	self.btnClose.OnCursorEntered = function(me)
	  me.ins = true
	end
	self.btnClose.OnCursorExited = function(me)
	  me.ins = false
	end
	self.btnClose.Paint = function(me)
	  local mat = self.ButMat
	  if me.ins then
	    mat = self.ButMatHover
	  end
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(mat)
	  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	end
end

vgui.Register("DStarFrame_Armory", PANEL, "DFrame")