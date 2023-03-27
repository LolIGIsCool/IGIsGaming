if SERVER then
    util.AddNetworkString("OpenF4Menu")

    hook.Add("ShowSpare2", "ShowF4Menu", function(ply)
        net.Start("OpenF4Menu")
        net.Send(ply)
    end)
else
    F4Menu = function()
        local function GlobalLength(length, type)
            if type == w then
                return length * (ScrW() / 1920)
            elseif type == h then
                return length * (ScrH() / 1080)
            end
        end

        local materials = {}
        materials["U"] = Material("gradients/u.png", "unlitgeneric")
        materials["L"] = Material("gradients/l.png", "unlitgeneric")
        materials["R"] = Material("gradients/r.png", "unlitgeneric")
        materials["D"] = Material("gradients/d.png", "unlitgeneric")
        materials["LU"] = Material("gradients/lu.png", "unlitgeneric")
        materials["RU"] = Material("gradients/ru.png", "unlitgeneric")
        materials["LD"] = Material("gradients/ld.png", "unlitgeneric")
        materials["RD"] = Material("gradients/rd.png", "unlitgeneric")
        materials["menu"] = Material("menu.png", "unlitgeneric smooth")

        local function BoxShadow(x, y, w, h)
            surface.SetDrawColor(255, 255, 255, 255)

            local one = {
                {
                    x = x,
                    y = y - 16,
                    u = 0,
                    v = 0
                },
                {
                    x = x + w,
                    y = y - 16,
                    u = 1 / w / 1024,
                    v = 0
                },
                {
                    x = x + w,
                    y = y - 16 + 16,
                    u = 1 / w / 1024,
                    v = 1
                },
                {
                    x = x,
                    y = y - 16 + 16,
                    u = 0,
                    v = 1
                }
            }

            local two = {
                {
                    x = x + w,
                    y = y,
                    u = 0,
                    v = 0
                },
                {
                    x = x + w + 16,
                    y = y,
                    u = 1,
                    v = 0
                },
                {
                    x = x + w + 16,
                    y = y + h,
                    u = 1,
                    v = 1 / h / 1024
                },
                {
                    x = x + w,
                    y = y + h,
                    u = 0,
                    v = 1 / h / 1024
                }
            }

            local three = {
                {
                    x = x,
                    y = y + h,
                    u = 0,
                    v = 0
                },
                {
                    x = x + w,
                    y = y + h,
                    u = 1 / w / 1024,
                    v = 0
                },
                {
                    x = x + w,
                    y = y + h + 16,
                    u = 1 / w / 1024,
                    v = 1
                },
                {
                    x = x,
                    y = y + h + 16,
                    u = 0,
                    v = 1
                }
            }

            local four = {
                {
                    x = x - 16,
                    y = y,
                    u = 0,
                    v = 0
                },
                {
                    x = x - 16 + 16,
                    y = y,
                    u = 1,
                    v = 0
                },
                {
                    x = x - 16 + 16,
                    y = y + h,
                    u = 1,
                    v = 1 / h / 1024
                },
                {
                    x = x - 16,
                    y = y + h,
                    u = 0,
                    v = 1 / h / 1024
                }
            }

            surface.SetMaterial(materials["U"])
            surface.DrawPoly(one)
            surface.SetMaterial(materials["R"])
            surface.DrawPoly(two)
            surface.SetMaterial(materials["D"])
            surface.DrawPoly(three)
            surface.SetMaterial(materials["L"])
            surface.DrawPoly(four)
            surface.SetMaterial(materials["LU"])
            surface.DrawTexturedRect(x - 16, y - 16, 16, 16)
            surface.SetMaterial(materials["RU"])
            surface.DrawTexturedRect(x + w, y - 16, 16, 16)
            surface.SetMaterial(materials["RD"])
            surface.DrawTexturedRect(x + w, y + h, 16, 16)
            surface.SetMaterial(materials["LD"])
            surface.DrawTexturedRect(x - 16, y + h, 16, 16)
        end

        surface.CreateFont("addon" .. "_-_" .. "title", {
            font = "Roboto",
            size = ScreenScale(8.5)
        })

        surface.CreateFont("addon" .. "_-_" .. "subtitle", {
            font = "Roboto",
            size = ScreenScale(7.5)
        })

        surface.CreateFont("addon" .. "_-_" .. "close", {
            font = "Roboto",
            size = ScreenScale(7)
        })

        surface.CreateFont("addon" .. "_-_" .. "text", {
            font = "Roboto",
            size = ScreenScale(6)
        })

        local shadow = vgui.Create("DFrame")
        shadow:SetSize(GlobalLength(500, w), GlobalLength(700, h))
        shadow:Center()
        shadow:ShowCloseButton(false)
        shadow:SetTitle("")
        shadow:SetDraggable(false)
        shadow:MakePopup()

        shadow.Paint = function(self, w, h)
            BoxShadow(16, 16, w - 32, h - 32)
            BoxShadow(16, 16, w - 32, h - 32)
        end

        local main = vgui.Create("DPanel", shadow)
        main:SetPos(16, 16)
        main:SetSize(shadow:GetWide() - 32, shadow:GetTall() - 32)

        main.Paint = function(self, w, h)
            surface.SetDrawColor(235, 235, 235, 255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(65, 133, 244, 255)
            surface.DrawRect(0, 0, w, h / 15)
            surface.SetMaterial(materials["D"])
            surface.SetDrawColor(155, 155, 155, 255)
            surface.DrawTexturedRect(main:GetWide(), h / 15, w - main:GetWide() / 15 * 3, h / 75)
            surface.DrawTexturedRect(main:GetWide(), h / 15, w - main:GetWide() / 15 * 3, h / 75)
            surface.SetMaterial(materials["menu"])
            surface.SetDrawColor(235, 235, 235, 255)
            surface.DrawTexturedRect(w / 150, h / 30 - 16, 32, 32)
            draw.SimpleText("Job Menu", "addon" .. "_-_" .. "title", w / 25 + w / 25, h / 75, Color(235, 235, 235, 255))
        end

        local CButton = vgui.Create("DButton", main)
        CButton:SetPos(main:GetWide() - GlobalLength(19, w), 0)
        CButton:SetSize(GlobalLength(19.2, w), GlobalLength(19.2, h))
        CButton:SetFont("addon" .. "_-_" .. "close")
        CButton:SetText("x")
        CButton:SetTextColor(Color(85, 153, 254, 255))

        CButton.Paint = function(self, w, h)
            surface.SetDrawColor(65, 133, 244, 255)
            surface.DrawRect(0, 0, w, h)
        end

        CButton.OnCursorEntered = function(self)
            self:SetTextColor(Color(255, 255, 255, 255))
        end

        CButton.OnCursorExited = function(self)
            self:SetTextColor(Color(85, 153, 254, 255))
        end

        CButton.DoClick = function(self)
            shadow:Hide()
        end

        -- Menu options
        local ScrollBar = vgui.Create("DScrollPanel", main)
        ScrollBar:SetPos(0, main:GetTall() / 15)
        ScrollBar:SetSize(main:GetWide(), main:GetTall() - main:GetTall() / 15.5)
        ScrollBar.Paint = function() end
        local SideBar = ScrollBar:GetVBar()

        function SideBar:Paint(w, h)
            surface.SetDrawColor(0, 0, 0, 0)
            surface.DrawRect(0, 0, w, h)
        end

        function SideBar.btnUp:Paint(w, h)
            surface.SetDrawColor(65, 133, 244, 255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(240, 240, 240, 255)
            draw.NoTexture()

            surface.DrawPoly({
                {
                    x = w / 2,
                    y = h / 3
                },
                {
                    x = w * (2 / 3),
                    y = h * (2 / 3)
                },
                {
                    x = w / 3,
                    y = h * (2 / 3)
                }
            })
        end

        function SideBar.btnDown:Paint(w, h)
            surface.SetDrawColor(65, 133, 244, 255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(240, 240, 240, 255)
            draw.NoTexture()

            surface.DrawPoly({
                {
                    x = w / 3,
                    y = h / 3
                },
                {
                    x = w * (2 / 3),
                    y = h / 3
                },
                {
                    x = w / 2,
                    y = h * (2 / 3)
                }
            })
        end

        function SideBar.btnGrip:Paint(w, h)
            surface.SetDrawColor(65, 133, 244, 255)
            surface.DrawRect(0, 0, w, h)
        end
        local i = 0

        for k, v in pairs(TeamTable) do
            i = i + 1
            local tbl = v[1]
            if not istable(tbl) then
                tbl = v[0]
            end
            local mainpanel = vgui.Create("DPanel", ScrollBar)
            mainpanel:SetPos(6, 6 + (ScrollBar:GetTall() / 8.5 + 4) * (i - 1) - (i == 0 and 10 or 0))
            mainpanel:SetSize(ScrollBar:GetWide() - 12 - ScrollBar:GetWide() / 40, ScrollBar:GetTall() / 7)

            mainpanel.Paint = function(self, w, h)
                surface.SetDrawColor(Color(245, 245, 245))
                surface.DrawRect(16, 16, w - 32, h - 32)
                BoxShadow(16, 16, w - 32, h - 32)
                BoxShadow(16, 16, w - 32, h - 32)
                draw.SimpleText(tbl.Regiment, "addon" .. "_-_" .. "subtitle", w / 6, h / 2, Color(20, 20, 20, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local model = vgui.Create("DModelPanel", mainpanel)
            model:SetSize(mainpanel:GetTall() / 2, mainpanel:GetTall() / 2)
            model:SetPos(16 + mainpanel:GetWide() / 100, mainpanel:GetTall() / 4)
            model:SetModel(tbl.Model)
            if not model.Entity then continue end
            local headpos = model.Entity:LookupBone("ValveBiped.Bip01_Head1") and model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1")) or model.Entity:OBBCenter()
            model:SetLookAt(headpos)
            model:SetCamPos(headpos - Vector(-15, 0, 0))
            model.LayoutEntity = function(ent) return end
        end

        shadow:SetVisible(false)

        net.Receive("OpenF4Menu", function()
            if shadow:IsVisible() then
                shadow:SetVisible(false)
            else
                shadow:SetVisible(true)
            end
        end)
    end
end