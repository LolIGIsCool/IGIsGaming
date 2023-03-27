include('shared.lua')

function ENT:Draw()
    self:DrawModel() -- Draw the model.
end

--[[
    net.Receive("DROIDOpenHealMenu", function()
    local health = net.ReadInt(32)
    local healthmax = net.ReadInt(32)
    local medics = net.ReadInt(32)
    local percent = health / healthmax
    local nicepercent = math.Round(percent * 100)
    local cost = 100 - nicepercent
    local truecost = cost * (1 + medics)
    print(nicepercent)
    percentdroid = percent

    net.Receive("DROIDHpUpdate", function()
        percentdroid = 1
        HbarG:Refresh()
    end)

    local frame = vgui.Create("DFrame")
    local W = ScrW()
    local H = ScrH()
    frame:SetSize(W / 1.4, H / 1.6)
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetTitle("Healing Droid")

    frame.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
        draw.RoundedBox(5, 2, 2, w - 4, h - 4, Color(60, 60, 60))
    end

    local BGPanel3 = vgui.Create("DPanel", frame)
    BGPanel3:SetSize(W / 4 + 10, H / 2 + 10)
    BGPanel3:SetPos(W / 35 - 5, H / 25 - 5)
    BGPanel3:SetBackgroundColor(Color(255, 0, 0, 255))
    local BGPanel1 = vgui.Create("DPanel", frame)
    BGPanel1:SetSize(W / 4, H / 2)
    BGPanel1:SetPos(W / 35, H / 25)
    BGPanel1:SetBackgroundColor(Color(50, 50, 50, 255))
    local icon = vgui.Create("DModelPanel", frame)
    icon:SetSize(W / 4, H / 2)
    icon:SetPos(W / 35, H / 25)
    local model = LocalPlayer()
    icon:SetModel(model:GetModel())
    local BGPanel2 = vgui.Create("DPanel", frame)
    BGPanel2:SetSize(W / 5 + 10, H / 4 + 10)
    BGPanel2:SetPos(W / 2.5 - 5, H / 25 - 5)
    BGPanel2:SetBackgroundColor(Color(255, 0, 0, 255))
    local BGPanel = vgui.Create("DPanel", frame)
    BGPanel:SetSize(W / 5, H / 4)
    BGPanel:SetPos(W / 2.5, H / 25)
    BGPanel:SetBackgroundColor(Color(50, 50, 50, 255))
    local icon1 = vgui.Create("DModelPanel", frame)
    icon1:SetSize(W / 5, H / 3.5)
    icon1:SetPos(W / 2.5, 0)
    icon1:SetModel("models/props/starwars/medical/health_droid.mdl")
    icon1:SetCamPos(Vector(-60, 60, 60))

    function icon1:LayoutEntity(Entity)
        return
    end

    local Hbar1 = vgui.Create("DPanel", frame)
    Hbar1:SetSize(W / 4 + 4, H / 100 + 4)
    Hbar1:SetPos(W / 35 - 2, 13.5 * H / 25 - 2)
    Hbar1:SetBackgroundColor(Color(0, 0, 0, 255))
    local Hbar = vgui.Create("DPanel", frame)
    Hbar:SetSize(W / 4, H / 100)
    Hbar:SetPos(W / 35, 13.5 * H / 25)
    Hbar:SetBackgroundColor(Color(255, 0, 0, 255))
    local HbarG = vgui.Create("DPanel", frame)
    HbarG:SetSize(percentdroid * W / 4, H / 100)
    HbarG:SetPos(W / 35, 13.5 * H / 25)
    HbarG:SetBackgroundColor(Color(0, 255, 0, 255))
    local Info = vgui.Create("DLabel", frame)
    Info:SetFont("HudHintTextLarge")
    Info:SetText(" Hello there! Based on your current injuries Its gonna take " .. truecost .. " Credits to get you to full health again!")
    Info:SetSize(W / 2.5, H / 20)
    Info:SetPos(W / 3, H / 3)
    local Info1 = vgui.Create("DLabel", frame)
    Info1:SetFont("HudHintTextLarge")
    Info1:SetText("And if you somehow managed to break your legs again, it's 50 credits!")
    Info1:SetSize(W / 2.5, H / 20)
    Info1:SetPos(W / 2.7, H / 3 + H / 20)
    local Leg = vgui.Create("DButton", frame)
    Leg:SetText("Fix Leg")
    Leg:SetPos(W / 2.5, H / 2)
    Leg:SetSize(W / 20, H / 20)
    Leg:SetFont("Trebuchet18")

    Leg.DoClick = function()
        net.Start("DROIDLeg")
        net.SendToServer()
        frame:Close()
    end

    local Health = vgui.Create("DButton", frame)
    Health:SetText("Heal")
    Health:SetPos(W / 1.9, H / 2)
    Health:SetSize(W / 20, H / 20)
    Health:SetFont("Trebuchet18")

    Health.DoClick = function()
        net.Start("DROIDHealing")
        net.WriteInt(nicepercent, 32)
        net.SendToServer()
        frame:Close()
    end
end)
]]--
local function Draw3DText(pos, ang, scale, text, flipView)
    if (flipView) then
        -- Flip the angle 180 degrees around the UP axis
        ang:RotateAroundAxis(Vector(0, 0, 1), 180)
    end

    cam.Start3D2D(pos, ang, scale)
    -- Actually draw the text. Customize this to your liking.
    draw.DrawText(text, "HudHintTextLarge", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Draw()
    -- Draw the model
    self:DrawModel()
    -- The text to display
    local text = "Healing Droid"
    -- The position. We use model bounds to make the text appear just above the model. Customize this to your liking.
    local mins, maxs = self:GetModelBounds()
    local pos = self:GetPos() + Vector(0, 0, maxs.z + 10)
    -- The angle
    local ang = Angle(0, SysTime() * 100 % 360, 90)
    -- Draw front
    Draw3DText(pos, ang, 0.2, text, false)
    -- DrawDraw3DTextback
    Draw3DText(pos, ang, 0.2, text, true)
end