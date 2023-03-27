SummeLibrary.HotKeys = SummeLibrary.HotKeys or {}
SummeLibrary.HotKeyCooldon = 0
SummeLibrary.HotKeysDefault = SummeLibrary.HotKeysDefault or {}

function SummeLibrary:RegisterBind(data)
    SummeLibrary.HotKeys[data.name] = {
        key = data.key,
        func = data.func,
    }

    SummeLibrary.HotKeysDefault[data.name] = {
        key = data.key
    }

    local key_ = cookie.GetNumber("Hotkeys."..data.name, false)
    if not key_ then return end
    print(key_)
    SummeLibrary.HotKeys[data.name].key = key_
end

function SummeLibrary:GetBind(name)
    if SummeLibrary.HotKeys[name] then
        return SummeLibrary.HotKeys[name].key
    end

    return false
end

hook.Add("HUDPaint", "SummeLibrary.HotKeys", function()
    if SummeLibrary.HotKeyCooldon >= CurTime() then return end

    if vgui.GetKeyboardFocus() then return end
    if gui.IsConsoleVisible() then return end
    if gui.IsGameUIVisible() then return end

    for k, data in pairs(SummeLibrary.HotKeys) do
        if data.key == nil then continue end
        if data.key == 0 then continue end
        if input.IsKeyDown(data.key) then
            SummeLibrary.HotKeyCooldon = CurTime() + 0.5
            data.func()
        end
    end
end)

local theme = {
    bg = Color(27,27,27),
    navButton = Color(34,34,34),
    navButtonH = Color(39,39,39),
    primary = Color(21,180,29),
    grey = Color(168,168,168)
}

SummeLibrary:CreateFont("SummeLibrary.HotkeyMenu", ScrH() * .02, 300, false)
SummeLibrary:CreateFont("SummeLibrary.HotkeyMenuTitle", ScrH()/20, 700, false)


function SummeLibrary:OpenHotkeyMenu()
    local width = ScrW() * .3
    local height = ScrH() * .5

    self.MainFrame = vgui.Create("DFrame")
    self.MainFrame:SetTitle("")
    self.MainFrame:SetSize(width, height)
    self.MainFrame:MakePopup()
    self.MainFrame:Center()
    self.MainFrame:SetDraggable(false)
    self.MainFrame:ShowCloseButton(false)
    self.MainFrame:SetAlpha(0)
    self.MainFrame:AlphaTo(255, .1)
    self.MainFrame.Paint = function(me,w,h)
        local x, y = me:LocalToScreen()

        BSHADOWS.BeginShadow()
        draw.RoundedBox(20, x, y, w, h, theme.bg)
        BSHADOWS.EndShadow(1, 1, 2, 200, 0, 0)

        local x1 = draw.SimpleText("S", "SummeLibrary.HotkeyMenuTitle", w * .02, h * .015, theme.primary, TEXT_ALIGN_LEFT)
        local x2 = draw.SimpleText("UMME", "SummeLibrary.HotkeyMenuTitle", w * .02 + x1, h * .015, theme.grey, TEXT_ALIGN_LEFT)
        local x3 = draw.SimpleText("A", "SummeLibrary.HotkeyMenuTitle", w * .0275 + x2 + x1, h * .015, theme.primary, TEXT_ALIGN_LEFT)
        local x4 = draw.SimpleText("DDONS", "SummeLibrary.HotkeyMenuTitle", w * .025 + x3 + x2 + x3, h * .015, theme.grey, TEXT_ALIGN_LEFT)

        draw.RoundedBox(0, w * .66, h * .065, w * .235, h * .002, theme.grey)
    end

    self.closeButton = vgui.Create("SummeLibrary.CloseButton", self.MainFrame)
    self.closeButton:SetPos(width * .92, height * .04)
    self.closeButton:SetSize(height * .05, height * .05)
    self.closeButton:SetUp(function()
        self.MainFrame:Remove()
    end)

    self.Main = vgui.Create("DScrollPanel", self.MainFrame)
    self.Main:SetPos(width * .02, height * .13)
    self.Main:SetSize(width * .96, height * .85)
    function self.Main:Paint(w, h)
        draw.RoundedBox(20, 0, 0, w, h, theme.navButton)
    end

    local sbar = self.Main:GetVBar()
    function sbar:Paint(w, h)
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
    end

    sbar.LerpTarget = 0

    function sbar:AddScroll(dlta)
        local OldScroll = self.LerpTarget or self:GetScroll()
        dlta = dlta * 75
        self.LerpTarget = math.Clamp(self.LerpTarget + dlta, -self.btnGrip:GetTall(), self.CanvasSize + self.btnGrip:GetTall())

        return OldScroll ~= self:GetScroll()
    end

    sbar.Think = function(s)
        local frac = FrameTime() * 5
        if (math.abs(s.LerpTarget - s:GetScroll()) <= (s.CanvasSize / 10)) then
            frac = FrameTime() * 2
        end
        local newpos = Lerp(frac, s:GetScroll(), s.LerpTarget)
        s:SetScroll(math.Clamp(newpos, 0, s.CanvasSize))
        if (s.LerpTarget < 0 and s:GetScroll() <= 0) then
            s.LerpTarget = 0
        elseif (s.LerpTarget > s.CanvasSize and s:GetScroll() >= s.CanvasSize) then
            s.LerpTarget = s.CanvasSize
        end
    end

    for key, value in SortedPairs(SummeLibrary.HotKeys) do
        local pnl = vgui.Create("DPanel", self.Main)
        pnl:SetSize(width * .65, height * .07)
        pnl:Dock(TOP)
        pnl:DockMargin(width * 0.002, height * 0.02, width * 0.002, 0)
        function pnl:Paint(w, h)
            draw.SimpleText(key, "SummeLibrary.HotkeyMenu", w * .02, h * .000, color_white, TEXT_ALIGN_LEFT)
        end

        local btn = vgui.Create("DBinder", pnl)
        btn:SetSize(width * .15, height * .07)
        btn:SetPos(width * .78, 0)
        btn:SetFont("SummeLibrary.HotkeyMenu")
        btn:SetSelectedNumber(value.key or 0)
        function btn:Paint(w, h)
            draw.RoundedBox(5, 0, 0, w, h, theme.grey)
        end
        function btn:OnChange(val)
            SummeLibrary.HotKeys[key].key = val
            cookie.Set("Hotkeys."..key, val)
        end
    end

end

concommand.Add("summelibrary_hotkeys", function(ply, cmd, args)
    SummeLibrary:OpenHotkeyMenu()
end)