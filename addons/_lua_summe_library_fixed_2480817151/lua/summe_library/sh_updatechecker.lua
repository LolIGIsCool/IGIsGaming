SummeLibrary.Updates = {}
SummeLibrary.Updates.Cache = {}


local src = "https://raw.githubusercontent.com/SummeGaming/SummeLibrary/main/data/addons.json"

function SummeLibrary.Updates:Get()
    http.Fetch(src,
    function(body, length, headers, code)
        local data = util.JSONToTable(body)
        SummeLibrary.Updates.Cache = data
        return SummeLibrary.Updates:Process()
    end,
    function(errorMsg)
        
    end)
end

function SummeLibrary.Updates:Process()
    if not SummeLibrary.Updates.Cache then return end
    local data = {}

    for key, addon in pairs(SummeLibrary.Addons) do
        if not addon.version then continue end
        if not SummeLibrary.Updates.Cache[key] then continue end

        data[key] = {
            curVer = addon.version,
            offVer = SummeLibrary.Updates.Cache[key][1].version,
        }
    end

    return data
end

function SummeLibrary.Updates:IsUpToDate(curVer, offVer)
    if curVer == offVer then
        return "upToDate"
    elseif curVer < offVer then
        return "outdated"
    elseif curVer > offVer then
        return "tooNew"
    end
end

--SummeLibrary.Updates:Get()

if CLIENT then
    local theme = {
        bg = Color(27,27,27),
        navButton = Color(34,34,34),
        navButtonH = Color(39,39,39),
        primary = Color(21,180,29),
        grey = Color(168,168,168)
    }

    function SummeLibrary.Updates:Open()
        SummeLibrary.Updates:Get()
        local width = ScrW() * .5
        local height = ScrH() * .5
    
        SummeLibrary.Updates._activeTab = 0
    
        self.MainFrame = vgui.Create("DFrame")
        self.MainFrame:SetTitle("")
        self.MainFrame:SetSize(width, height)
        self.MainFrame:MakePopup()
        self.MainFrame:Center()
        self.MainFrame:SetDraggable(false)
        self.MainFrame:ShowCloseButton(true)
        self.MainFrame:SetAlpha(0)
        self.MainFrame:AlphaTo(255, .1)
        self.MainFrame.Paint = function(me,w,h)
            local x, y = me:LocalToScreen()
    
            BSHADOWS.BeginShadow()
            draw.RoundedBox(20, x, y, w, h, theme.bg)
            BSHADOWS.EndShadow(1, 1, 2, 200, 0, 0)
    
            local x1 = draw.SimpleText("S", "ATS.Menu.TopHeader", w * .02, h * .015, theme.primary, TEXT_ALIGN_LEFT)
            local x2 = draw.SimpleText("UMME", "ATS.Menu.TopHeader", w * .02 + x1, h * .015, theme.grey, TEXT_ALIGN_LEFT)
            local x3 = draw.SimpleText("A", "ATS.Menu.TopHeader", w * .0275 + x2 + x1, h * .015, theme.primary, TEXT_ALIGN_LEFT)
            local x4 = draw.SimpleText("DDONS", "ATS.Menu.TopHeader", w * .025 + x3 + x2 + x3, h * .015, theme.grey, TEXT_ALIGN_LEFT)
    
            draw.RoundedBox(0, w * .4, h * .065, w * .5, h * .002, theme.grey)
        end
    
        self.Main = vgui.Create("DPanel", self.MainFrame)
        self.Main:SetPos(width * .01, height * .12)
        self.Main:SetSize(width * .98, height * .87)
        function self.Main:Paint(w, h)
            --draw.RoundedBox(20, 0, 0, w, h, theme.navButton)
        end

        for key, addonVersData in pairs(SummeLibrary.Updates:Process()) do
            local addonData = SummeLibrary.Addons[key]
            if not addonData then continue end
            local status = SummeLibrary.Updates:IsUpToDate(addonVersData.curVer, addonVersData.offVer)

            local txt = ""
            local col = Color(255,255,255)
    
            if status == "outdated" then
                txt = "Update available"
                col = Color(255,82,82)
            elseif status == "upToDate" then
                txt = "Up-to-date"
                col = Color(0,172,37)
            end

            local panel = vgui.Create("DButton", self.Main)
            panel:Dock(TOP)
            panel:SetSize(0, height * .2)
            panel.NormalColor = theme.navButton
            panel:SetText("")
            panel:DockMargin(0, 0, 0, height * .007)
            function panel:Paint(w, h)
                local bgCol = theme.navButton

                if self:IsHovered() then
                    bgCol = theme.navButtonH
                end
    
                self.NormalColor = SummeLibrary:LerpColor(FrameTime() * 12, self.NormalColor, bgCol)

                draw.RoundedBox(14, 0, 0, w, h, self.NormalColor)
                draw.SimpleText(addonData.name, "ATS.Menu.QuestionTitle", w * .025, h * .1, theme.grey, TEXT_ALIGN_LEFT)

                surface.SetFont("ATS.Menu.QuestionDetails")
                local _w = surface.GetTextSize(txt)

                draw.RoundedBox(14, w * .025, h * .4, w * .05 + _w, h * .2, col)

                local w = draw.SimpleText(txt, "ATS.Menu.QuestionDetails", w * .045, h * .4, color_white, TEXT_ALIGN_LEFT)
            end
        end

    end
end