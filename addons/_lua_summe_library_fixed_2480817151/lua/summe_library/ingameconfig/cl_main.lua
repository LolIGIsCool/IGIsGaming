
local theme = {
    bg = Color(27,27,27,250),
    bgSec = Color(48,48,48,203),
    navButton = Color(34,34,34),
    navButtonH = Color(39,39,39),
    primary = Color(21,180,29),
    grey = Color(168,168,168)
}

SummeLibrary:CreateFont("SummeLibrary.IngameConfig", ScrH() * .02, 300, false)
SummeLibrary:CreateFont("SummeLibrary.IngameConfigTitle", ScrH()/20, 700, false)
SummeLibrary:CreateFont("SummeLibrary.NavBarText", ScrH() * .016, 100, false)
SummeLibrary:CreateFont("SummeLibrary.NavBarNotify", ScrH() * .013, 100, false)
SummeLibrary:CreateFont("SummeLibrary.PageTitle", ScrH() * .03, 200, false)
SummeLibrary:CreateFont("SummeLibrary.AddonsIcon", ScrH() * .1, 1000, false)
SummeLibrary:CreateFont("SummeLibrary.AddonsTitle", ScrH() * .02, 700, false)
SummeLibrary:CreateFont("SummeLibrary.AddonsText", ScrH() * .017, 300, false)

SummeLibrary.IngameConfig = SummeLibrary.IngameConfig or {}
SummeLibrary.IngameConfig.Pages = SummeLibrary.IngameConfig.Pages or {}

function SummeLibrary.IngameConfig:Open()
    local width = ScrW() * .8
    local height = ScrH() * .7

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

        local x1 = draw.SimpleText("S", "SummeLibrary.IngameConfigTitle", w * .02, h * .015, theme.primary, TEXT_ALIGN_LEFT)
        local x2 = draw.SimpleText("UMME", "SummeLibrary.IngameConfigTitle", w * .02 + x1, h * .015, theme.grey, TEXT_ALIGN_LEFT)
        local x3 = draw.SimpleText("A", "SummeLibrary.IngameConfigTitle", w * .027 + x2 + x1, h * .015, theme.primary, TEXT_ALIGN_LEFT)
        local x4 = draw.SimpleText("DDONS", "SummeLibrary.IngameConfigTitle", w * .025 + x3 + x2 + x3, h * .015, theme.grey, TEXT_ALIGN_LEFT)

        draw.RoundedBox(0, w * .27, h * .0525, w * .65, h * .002, theme.grey)
    end

    self.CloseButton = vgui.Create("SummeLibrary.CloseButton", self.MainFrame)
    self.CloseButton:SetPos(width * .945, height * .04)
    self.CloseButton:SetSize(height * .05, height * .05)
    self.CloseButton:SetUp(function()
        self.MainFrame:Remove()
    end)

    self.MainPanel = vgui.Create("DPanel", self.MainFrame)
    self.MainPanel:SetPos(width * .2, height * .13)
    self.MainPanel:SetSize(width * .78, height * .83)
    function self.MainPanel:Paint(w, h) 
    end

    self.NavBarLEFT = vgui.Create("DScrollPanel", self.MainFrame)
    self.NavBarLEFT:SetPos(width * .01, height * .2)
    self.NavBarLEFT:SetSize(width * .18, height * .7)
    function self.NavBarLEFT:Paint(w, h) 
    end

    local activeButton = ""

    local function GenerateButton(data)
        self.Button = vgui.Create("DButton", self.NavBarLEFT)
        self.Button:Dock(TOP)
        self.Button:DockMargin(0, 0, 0, ScrH() * .01)
        self.Button:SetSize(0, ScrH() * .04)
        self.Button:SetText("")
        self.Button.BackgroundCol = Color(221, 221, 221)
        self.Button.BarStatus = 0
        self.Button.ButtonText = data.name
    
        function self.Button:IsActive()
            if activeButton == self.ButtonText then
                return true
            end
    
            return false
        end
    
        function self.Button:DoClick()
            activeButton = self.ButtonText

            SummeLibrary.IngameConfig.MainPanel:Clear()

            if data.frame then
                data.frame(SummeLibrary.IngameConfig.MainPanel)
            end
        end
    
        function self.Button:Paint(w, h)
            local bgCol = Color(223, 223, 223)
        
            if self:IsHovered() and not self:IsActive() then
                bgCol = Color(170, 43, 43, 234)
                self.BarStatus = math.Clamp(self.BarStatus + (FrameTime() * 7), 0, 1)
            else
                self.BarStatus = math.Clamp(self.BarStatus - (FrameTime() * 7), 0, 1)
            end
    
            if self:IsActive() then
                draw.RoundedBox(10, 0, 0, w, h, theme.bgSec)
            end
    
            self.BackgroundCol = SummeLibrary:LerpColor(FrameTime() * 12, self.BackgroundCol, bgCol)
    
            surface.SetDrawColor(Color(255,255,255))
            SummeLibrary:DrawImgur(w * .05 + w * .1 * self.BarStatus, h * .15, h * .7, h * .7, data.icon)
    
            local textX = draw.SimpleText(self.ButtonText, "SummeLibrary.NavBarText", w * .2 + w * .1 * self.BarStatus, h * .25, self.BackgroundCol, TEXT_ALIGN_LEFT)

            if data.badge then
                surface.SetFont("SummeLibrary.NavBarNotify")
                local textWidth = surface.GetTextSize(data.badge.text)

                draw.RoundedBox(5, w * .24 + textX + (w * .1 * self.BarStatus), h * .25, w * .05 + textWidth, h * .4, data.badge.color)
                draw.SimpleText(data.badge.text, "SummeLibrary.NavBarNotify", w * .262 + textX + (w * .1 * self.BarStatus), h * .25, color_white, TEXT_ALIGN_LEFT)
            end
        end
    end

    local function GenerateAllButtons()
        for key, data in pairs(SummeLibrary.IngameConfig.Pages) do
            GenerateButton(data)
        end 
    end

    self.SearchBarLEFT = vgui.Create("SummeLibrary.TextEntry", self.MainFrame)
    self.SearchBarLEFT:SetPos(width * .015, height * .12)
    self.SearchBarLEFT:SetSize(width * .16, height * .06)
    self.SearchBarLEFT:SetPlaceholder("Search settings")
    self.SearchBarLEFT:SetBarColor(SummeLibrary:GetColor("greyLight"))

    function self.SearchBarLEFT:OnChange()
        local text = self:GetText()
        SummeLibrary.IngameConfig.NavBarLEFT:Clear()

        if text == "" then
            GenerateAllButtons()
            return
        end

        for k, v in pairs(SummeLibrary.IngameConfig.Pages) do
            for _, tag in pairs(v.tags) do
                if string.find(tag, text, 1, false) then
                    GenerateButton(v)
                end
            end
        end
    end

    GenerateAllButtons()
end

function SummeLibrary.IngameConfig:AddPage(key, data)
    SummeLibrary.IngameConfig.Pages[key] = data
end

SummeLibrary.IngameConfig:AddPage("KEYBINDS", {
    name = "Keybinds",
    icon = "l6KAUSP",
    frame = function(mainPanel)
        local width, height = mainPanel:GetSize()

        local content = vgui.Create("DPanel", mainPanel)
        content:Dock(FILL)
        function content:Paint(w, h)
            draw.DrawText("Keybinds", "SummeLibrary.PageTitle", w * .01, h * .01, color_white, TEXT_ALIGN_LEFT)
        end

        local main = vgui.Create("DScrollPanel", content)
        main:Dock(FILL)
        main:DockMargin(0, height * .1, 0, 0)
        function main:Paint(w, h)
            --draw.RoundedBox(20, 0, 0, w, h, theme.navButton)
        end
    
        local sbar = main:GetVBar()
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
            local pnl = vgui.Create("DPanel", main)
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
    end,
    tags = {},
})

SummeLibrary.IngameConfig:AddPage("NOTIFICATIONS", {
    name = "Notifications",
    icon = "NulzATC",
    tags = {"Hotkeys"},
    badge = {
        text = "1",
        color = Color(255,77,77),
    },
    frame = function(mainPanel)
        
    end
})

SummeLibrary.IngameConfig:AddPage("INSTALLED_PACKAGES", {
    name = "Installed packages",
    icon = "ylyT04G",
    tags = {"dd"},
    frame = function(mainPanel)
        local w, h = mainPanel:GetSize()

        local content = vgui.Create("DPanel", mainPanel)
        content:Dock(FILL)
        function content:Paint(w, h)
            draw.DrawText("Installed packages", "SummeLibrary.PageTitle", w * .01, h * .01, color_white, TEXT_ALIGN_LEFT)
        end

        local addonsList = vgui.Create("DScrollPanel", content)
        addonsList:SetSize(w * .96, h * .75)
        addonsList:SetPos(w * .02, h * .15)

        local sbar = addonsList:GetVBar()
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

        local grid = vgui.Create( "DGrid", content )
        grid:SetPos(w * .02, h * .15)
        grid:SetSize(w * .96, h * .75)
        grid:SetCols(2)
        grid:SetColWide(w * .45)
        grid:SetRowHeight(h * .21)

        for k, addon in pairs(SummeLibrary.Addons) do
            PrintTable(addon)
            local addonPanel = vgui.Create("DButton")
            addonPanel:SetSize(w * .44, h * .2)
            addonPanel:SetText("")
            grid:AddItem(addonPanel)

            print(k)

            addon.IsUpToDate = false

            SummeLibrary:CheckRecentVersion(k, function(result)
                addon.IsUpToDate = result
            end)

            function addonPanel:Paint(w, h)
                local x, y = self:LocalToScreen()

                BSHADOWS.BeginShadow()
                    draw.RoundedBox(5, x, y, w, h, theme.bg)
                BSHADOWS.EndShadow(1, 1, 2, 200, 0, 0)

                draw.SimpleText(addon.name[1], "SummeLibrary.AddonsIcon", w * .1, h * .07, theme.grey, TEXT_ALIGN_CENTER)

                surface.SetDrawColor(Color(123,255,123))
                draw.NoTexture()
                draw.Circle(w * .95, h * .15, h * .06, 40)

                draw.SimpleText(addon.name, "SummeLibrary.AddonsTitle", w * .2, h * .1, color_white, TEXT_ALIGN_LEFT)
                draw.SimpleText(addon.version or "nil", "SummeLibrary.AddonsText", w * .2, h * .3, color_white, TEXT_ALIGN_LEFT)

                local text = ""
                local color = color_white

                if addon.IsUpToDate == "LATEST" then
                    text = "Latest version"
                    color = Color(26,156,58)
                elseif addon.IsUpToDate == "OLD" then
                    text = "New version available"
                    color = Color(201,82,13)
                else
                    text = "Private"
                    color = Color(123,13,133)
                end

                surface.SetFont("SummeLibrary.NavBarNotify")
                local textWidth = surface.GetTextSize(text)

                draw.RoundedBox(5, w * .2, h * .5, w * .05 + textWidth, h * .17, color)
                draw.SimpleText(text, "SummeLibrary.NavBarNotify", w * .222, h * .51, color_white, TEXT_ALIGN_LEFT)
            end
        end
    end
})