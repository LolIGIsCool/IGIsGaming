include("shared.lua")
local vector1 = Vector(0, 0, 82)
function ENT:DrawOverheadText(text)
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), -90)
    cam.Start3D2D(self:GetPos() + Vector(0, 0, 82), ang, 0.1)
    draw.SimpleTextOutlined(text, "QUEST_SYSTEM_ItemTitle", 0, 0, color_white, TEXT_ALIGN_CENTER, nil, 3, Color(0, 0, 0))
    cam.End3D2D()
end

function ENT:Draw()
    self:DrawModel()

    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 500) then
		self:DrawOverheadText("Imperial Lotteries")
    end
end

net.Receive("LOTTERY_OpenDialogue", function(len, ply)
    local random = math.random(1,5);
    surface.PlaySound("vanilla/lottery/Ticket" .. random .. ".wav")

    local LOTTERY_MainFrame = TDLib("DFrame")
    LOTTERY_MainFrame:SetSize(400, 150)
    LOTTERY_MainFrame:Center()
    LOTTERY_MainFrame:MakePopup()
    LOTTERY_MainFrame:SetTitle("")
    LOTTERY_MainFrame:SetDraggable(false)
    LOTTERY_MainFrame.btnMaxim:Hide()
    LOTTERY_MainFrame.btnMinim:Hide()
    LOTTERY_MainFrame:ClearPaint():Blur():Background(Color(0, 0, 0, 200)):Outline(Color(255, 255, 255, 255), 2)
    local LOTTERY_Icon = TDLib("SpawnIcon", LOTTERY_MainFrame)
    LOTTERY_Icon:Stick(LEFT, 5)
    LOTTERY_Icon:SetWide(100)
    LOTTERY_Icon:SetModel("models/imperial_officer/npc_officer.mdl")
    LOTTERY_Icon:SetMouseInputEnabled(false)
    local LOTTERY_Panel = TDLib("DPanel", LOTTERY_MainFrame)
    LOTTERY_Panel:Stick(CENTER, 5)
    LOTTERY_Panel:SetWide(200)
    LOTTERY_Panel:ClearPaint()
    local LOTTERY_Greeting = TDLib("DLabel", LOTTERY_Panel)
    LOTTERY_Greeting:Stick(TOP, 5)
    LOTTERY_Greeting:SetTall(60)
    LOTTERY_Greeting:SetText("Entering the lottery costs 100 credits to enter.\nThe lottery occurs every 30 minutes.\nThis ticket does not save over restarts or logouts.")
    LOTTERY_Greeting:SetTextColor(Color(255, 255, 255, 255))
    LOTTERY_Greeting:SetWrap(true)

    local Button_LottoBuy = TDLib("DButton", LOTTERY_Panel)
    Button_LottoBuy:SetPos(LOTTERY_Panel:GetWide()/4, LOTTERY_Panel:GetTall() - 35)
    Button_LottoBuy:SetSize(120, 25)

    Button_LottoBuy:On("DoClick", function(self)
    Derma_Query("Are you sure you want to buy a lottery ticket for 100 credits?", "", "Yes", function()
            net.Start("BuyLottoTicket")
            net.SendToServer()
            LOTTERY_MainFrame:Close()
        end, "No", function()
            LOTTERY_MainFrame:Close()
        end)
    end)

    Button_LottoBuy:ClearPaint():Background(Color(29, 87, 196)):Text("Buy Lottery Ticket", "QUEST_SYSTEM_ItemInfo", Color(255, 255, 255, 255)):BarHover():CircleClick():Outline(Color(255, 255, 255, 255), 1)
end)
