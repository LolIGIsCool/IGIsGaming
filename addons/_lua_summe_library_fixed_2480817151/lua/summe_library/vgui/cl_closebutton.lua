
local CloseButton = {}

function CloseButton:Init()
    self:SetText("")
    self.NormalColor = Color(255,255,255,152)
end

function CloseButton:Paint(w, h)
    local bgCol = Color(255,255,255,152)

    if self:IsHovered() then
        bgCol = Color(255, 118, 118, 208)
    end

    self.NormalColor = SummeLibrary:LerpColor(FrameTime() * 12, self.NormalColor, bgCol)

    surface.SetDrawColor(self.NormalColor)
    SummeLibrary:DrawImgur(0, 0, w, h, "OiGUzEl")
end

function CloseButton:DoClickInternal()
    surface.PlaySound("UI/buttonclick.wav")
end

function CloseButton:DoClick()
    self.func(self)
end

function CloseButton:SetUp(closeFunc)
    self.func = closeFunc
end
    
vgui.Register("SummeLibrary.CloseButton", CloseButton, "DButton")