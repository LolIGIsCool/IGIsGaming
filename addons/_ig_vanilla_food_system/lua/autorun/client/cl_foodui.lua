//fonts
surface.CreateFont( "vanilla_food_creditslarge", {
    font = "Acumin Pro",
    italic = true,
    weight = 1000,
    size = ScreenScale(25)
} )
surface.CreateFont( "vanilla_food_creditssmall", {
    font = "Acumin Pro",
    weight = 300,
    italic = true,
    size = ScreenScale(15)
} )
surface.CreateFont( "vanilla_food_foodvendor", {
    font = "Acumin Pro",
    weight = 1500,
    size = ScreenScale(10)
} )
surface.CreateFont( "vanilla_food_foodvendorlite", {
    font = "Acumin Pro",
    weight = 300,
    size = ScreenScale(10)
} )
surface.CreateFont( "vanilla_food_foodvendorliter", {
    font = "Acumin Pro",
    weight = 300,
    italic = true,
    size = ScreenScale(8)
} )

local col = {
    bg = Color(29, 46, 98, 220),
    black = Color(0,0,0,255),
    grey = Color(125,125,125,255),
    white = Color(255,255,255,255),
    bbl = Color(9,76,239,80),
    bbl2 = Color(17,183,231,80),
    bbl3 = Color(23,253,252,80),
    blue = Color(9,73,243,255)
}

//draw functions
local function Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 )
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end

local randomPos = {}

local function Bubble(speed,num)
    return (ScrH() * (1.1 + randomPos[num])) - ( CurTime() * speed ) % (ScrH() * (1.3 + randomPos[num]))
end

//menu
net.Receive("VANILLAFOOD_net_OpenBuyMenu",function()
    for i = 1, 9 do
        table.insert(randomPos,i,math.random(0,0.5))
    end
        
    local random = math.random(1,5);
    surface.PlaySound("vanilla/foodlines/interact_" .. random .. ".wav")

    local stock = net.ReadTable()

    local mat = Material("materials/vanilla/food/hateyouveteran.png")

    local frame = vgui.Create("DFrame")
    frame:SetSize(ScrW(),ScrH())
    frame:MakePopup()
    frame:Center()
    frame:SetTitle("")
    frame:NoClipping(true)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        //background
        surface.SetDrawColor(col.bg)
        surface.DrawRect(0,0,w,h)

        //bubbles n' lines
        surface.SetDrawColor(col.bbl)
        draw.NoTexture()
        Circle( w * 0.1, Bubble(125,1), 50, 30 )
        Circle( w * 0.15, Bubble(100,2), 100, 30 )
        Circle( w * 0.4, Bubble(100,4), 80, 30 )
        Circle( w * 0.42, Bubble(120,5), 65, 30 )
        Circle( w * 0.9, Bubble(75,9), 150, 30 )

        surface.SetDrawColor(col.bbl2)
        Circle( w * 0.3, Bubble(80,3), 125, 30 )
        Circle( w * 0.55, Bubble(100,6), 100, 30 )
        Circle( w * 0.7, Bubble(105,7), 85, 30 )
        Circle( w * 0.84, Bubble(150,8), 12, 30 )

        surface.SetDrawColor(col.bbl3)
        Circle( w * 0.05, h * 0.96, 132,  math.sin( CurTime() ) * 20 + 25 )
        Circle( w * 0.05, h * 0.84, 80,  math.cos( CurTime() ) * 20 + 25 )
        Circle( w * 0.1, h * 0.84, 32,  math.sin( CurTime() ) * 20 + 25 )
        Circle( w * 0.13, h * 0.9, 70, math.cos( CurTime() ) * 20 + 25 )
        Circle( w * 0.17, h * 0.98, 200, math.sin( CurTime() ) * 20 + 25 )
        Circle( w * 0.2, h * 0.85, 100, math.cos( CurTime() ) * 20 + 25 )

        surface.DrawCircle(w * 1.2,h * 0.8,800,17,183,231,80)
        surface.SetDrawColor(col.bbl2)
        surface.DrawLine(0,h * 0.7,w * 0.4,h)
        surface.DrawLine(w * 0.8,0,w * 0.35,h)
        surface.DrawLine(0,h * 0.8,w * 0.3,h)
        surface.DrawLine(0,h * 0.2,w * 0.6,0)
        surface.DrawLine(w * 0.2,0,w * 0.85,h)
        surface.SetDrawColor(col.white)
        surface.DrawLine(w,h * 0.3,0,h * 0.15)
        surface.DrawLine(w,h * 0.5,0,h * 0.35)

        surface.SetMaterial(mat)
        surface.SetDrawColor(col.black)
        surface.DrawTexturedRect(-20,5,w,h)
        surface.SetDrawColor(col.white)
        surface.DrawTexturedRect(0,0,w,h)

        //credits
        local box = {
            {x = w * 0.7, y = h * 0.75},
            {x = w * 0.95, y = h * 0.7},
            {x = w * 0.96, y = h * 0.85},
            {x = w * 0.71, y = h * 0.9}
        }
        local line = {
            {x = w * 0.72, y = h * 0.85},
            {x = w * 0.87, y = h * 0.82},
            {x = w * 0.87, y = h * 0.825},
            {x = w * 0.72, y = h * 0.855}
        }

        surface.SetDrawColor( col.black )
        draw.NoTexture()
        surface.DrawPoly( box )

        surface.SetDrawColor(col.grey)
        surface.DrawPoly( line )

        local matrix = Matrix()

        matrix:Translate(Vector(w / 2, h / 2))
        matrix:Rotate(Angle(0,-6.5,0))
        matrix:Scale(Vector(1,1,1))
        matrix:Translate(-Vector(w / 2, h / 2))

        cam.PushModelMatrix(matrix)
        draw.SimpleText(string.Comma(LocalPlayer():SH_GetPremiumPoints()), "vanilla_food_creditslarge", w * 0.845, h * 0.826, col.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText("credits", "vanilla_food_creditssmall", w * 0.85, h * 0.862, col.grey, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        cam.PopModelMatrix()
    end

    local sidePanel = vgui.Create("DPanel",frame)
    sidePanel:SetSize(ScrW() * 0.45,ScrH() * 0.85)
    sidePanel:SetPos(0,ScrH() * 0.05)
    sidePanel.Paint = function(self, w, h)
        local box = {
            {x = w * -0.01, y = h * 0.1},
            {x = w * 0.87, y = h * 0.05},
            {x = w * 0.93, y = h * 0.78},
            {x = w * 0.07, y = h * 0.855}
        }

        surface.SetDrawColor( col.white )
        draw.NoTexture()
        surface.DrawPoly( box )

        //TEXT

        local matrix = Matrix()

        matrix:Translate(Vector(w / 2, h / 2))
        matrix:Rotate(Angle(0,-5,0))
        matrix:Scale(Vector(1,1,1))
        matrix:Translate(-Vector(w / 2, h / 2))

        cam.PushModelMatrix(matrix)
        draw.SimpleText("FOOD VENDOR", "vanilla_food_foodvendor", w * 0.43, h * 0.083, col.blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        local activeBuff = LocalPlayer():GetNWString("VANILLABUFF",nil)
        if activeBuff == "" then
            draw.SimpleText("NO BUFF ACTIVE", "vanilla_food_foodvendor", w * 0.07, h * 0.77, col.blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        else
            draw.SimpleText(string.upper(activeBuff) .. " BUFF ACTIVE", "vanilla_food_foodvendor", w * 0.07, h * 0.77, col.blue, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
        cam.PopModelMatrix()
    end

    //ugly code i know, TOO BAD I DONT CAREE

    local clicked

    local b1 = vgui.Create("DButton",sidePanel)
    b1:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b1:SetPos(ScrW() * 0.01,ScrH() * 0.12)
    b1:SetText("")
    b1.Paint = function(self, w, h)
        local color
        if clicked == 1 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end

        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[1],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[1].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[1].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b1.DoClick = function()
        clicked = 1
    end

    local b2 = vgui.Create("DButton",sidePanel)
    b2:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b2:SetPos(ScrW() * 0.014,ScrH() * 0.17)
    b2:SetText("")
    b2.Paint = function(self, w, h)
        local color
        if clicked == 2 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end

        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[2],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[2].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[2].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b2.DoClick = function()
        clicked = 2
    end

    local b3 = vgui.Create("DButton",sidePanel)
    b3:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b3:SetPos(ScrW() * 0.018,ScrH() * 0.22)
    b3:SetText("")
    b3.Paint = function(self, w, h)
        local color
        if clicked == 3 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[3],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[3].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[3].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b3.DoClick = function()
        clicked = 3
    end

    local b4 = vgui.Create("DButton",sidePanel)
    b4:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b4:SetPos(ScrW() * 0.022,ScrH() * 0.27)
    b4:SetText("")
    b4.Paint = function(self, w, h)
        local color
        if clicked == 4 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[4],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[4].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[4].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b4.DoClick = function()
        clicked = 4
    end

    local b5 = vgui.Create("DButton",sidePanel)
    b5:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b5:SetPos(ScrW() * 0.026,ScrH() * 0.32)
    b5:SetText("")
    b5.Paint = function(self, w, h)
        local color
        if clicked == 5 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[5],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[5].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[5].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b5.DoClick = function()
        clicked = 5
    end

    local b6 = vgui.Create("DButton",sidePanel)
    b6:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b6:SetPos(ScrW() * 0.03,ScrH() * 0.37)
    b6:SetText("")
    b6.Paint = function(self, w, h)
        local color
        if clicked == 6 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[6],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[6].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[6].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b6.DoClick = function()
        clicked = 6
    end

    local b7 = vgui.Create("DButton",sidePanel)
    b7:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b7:SetPos(ScrW() * 0.034,ScrH() * 0.42)
    b7:SetText("")
    b7.Paint = function(self, w, h)
        local color
        if clicked == 7 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[7],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[7].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[7].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b7.DoClick = function()
        clicked = 7
    end

    local b8 = vgui.Create("DButton",sidePanel)
    b8:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b8:SetPos(ScrW() * 0.038,ScrH() * 0.47)
    b8:SetText("")
    b8.Paint = function(self, w, h)
        local color
        if clicked == 8 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[8],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[8].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[8].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b8.DoClick = function()
        clicked = 8
    end

    local b9 = vgui.Create("DButton",sidePanel)
    b9:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b9:SetPos(ScrW() * 0.042,ScrH() * 0.52)
    b9:SetText("")
    b9.Paint = function(self, w, h)
        local color
        if clicked == 9 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[9],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[9].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[9].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b9.DoClick = function()
        clicked = 9
    end

    local b10 = vgui.Create("DButton",sidePanel)
    b10:SetSize(ScrW() * 0.36,ScrH() * 0.033)
    b10:SetPos(ScrW() * 0.046,ScrH() * 0.57)
    b10:SetText("")
    b10.Paint = function(self, w, h)
        local color
        if clicked == 10 then color = col.white; draw.RoundedBox(5,w * 0.16,0,w * 0.84,h * 0.8,Color(0,0,0,253)) else color = col.black end
        draw.RoundedBox(5,0,0,w * 0.15,h * 0.8,col.black)
        draw.SimpleText("x" .. stock[10],"vanilla_food_foodvendor",w * 0.08,h * 0.35,col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        draw.SimpleText(vanillaIGFoodItems[10].Name,"vanilla_food_foodvendor",w * 0.18,h * 0.35,color,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        draw.SimpleText(vanillaIGFoodItems[10].Price,"vanilla_food_foodvendorlite",w * 0.87,h * 0.35,color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_food_foodvendorliter",w * 0.88,h * 0.4,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

        surface.SetDrawColor(Color(17,183,231,255))
        surface.DrawRect(0,h * 0.95,w,h)
    end
    b10.DoClick = function()
        clicked = 10
    end

    local infoPanel = vgui.Create("DPanel",frame)
    infoPanel:SetSize(ScrW() * 0.4,ScrH() * 0.32)
    infoPanel:SetPos(ScrW() * 0.27,ScrH() * 0.68)
    infoPanel.Paint = function(self, w, h)
        local box = {
            {x = w * 0.05, y = 0},
            {x = w * 0.95, y = h * 0.1},
            {x = w, y = h},
            {x = 0, y = h}
        }

        local intersect = {
            {x = w * 0.05, y = 0},
            {x = w * 0.369, y = h * 0.033},
            {x = w * 0.373, y = h * 0.12},
            {x = w * 0.041, y = h * 0.174}
        }

        draw.NoTexture()

        surface.SetDrawColor( col.white )
        surface.DrawPoly( box )

        surface.SetDrawColor( col.black )
        surface.DrawPoly( intersect )

        surface.SetTextColor(col.black)
        surface.SetFont("vanilla_food_foodvendor")
        surface.SetTextPos(w * 0.1,h * 0.3)
        if clicked == nil then
            surface.DrawText("Click on an item to view its details.")
        else
            surface.DrawText(vanillaIGFoodItems[clicked].Name .. " - x" .. vanillaIGFoodItems[clicked].Stock .. " in stock")
            draw.DrawText(vanillaIGFoodItems[clicked].Buffs,"vanilla_food_foodvendor",w * 0.1,h * 0.45,col.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
        end
    end

    local buy = vgui.Create("DButton", infoPanel)
    buy:SetSize(ScrW() * 0.15, ScrH() * 0.1)
    buy:SetPos(ScrW() * 0.252,ScrH() * 0.2)
    buy:SetText("")
    buy.Paint = function(self, w, h)
        if clicked ~= nil then
            local box = {
                {x = w * 0.05, y = 0},
                {x = w * 0.85, y = h * 0.033},
                {x = w * 0.9, y = h * 0.9},
                {x = w * 0.041, y = h * 0.87}
            }

            draw.NoTexture()
            surface.SetDrawColor( col.black )
            surface.DrawPoly( box )

            local matrix = Matrix()

            matrix:Rotate(Angle(0,5,0))
            matrix:Scale(Vector(1,1,1))
            matrix:Translate(Vector(w * 0.5, -h * 0.65))

            cam.PushModelMatrix(matrix)
            draw.SimpleText("PURCHASE", "vanilla_food_foodvendor", w * 0.25, h * 0, col.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            cam.PopModelMatrix()
        end
    end
    buy.DoClick = function()
        if clicked ~= nil then
            net.Start("VANILLAFOOD_net_Purchase")
            net.WriteInt(clicked,6)
            net.SendToServer()
            frame:Close()
        end
    end
end)

net.Receive("VANILLAFOOD_net_Purchase",function()
    local id = net.ReadInt(6)
    chat.AddText(col.white,"[",col.bbl2,"FOOD VENDOR",col.white,"]",col.bbl2," You have succesfully purchased, and consumed: ", col.white, vanillaIGFoodItems[id].Name, col.bbl2, ".")
end)

surface.CreateFont("vanilla_font_info", {
        font = "Proxima Nova Rg",
        size = ScreenScale(6),
        weight = 800
    })

hook.Add( "HUDPaint", "VANILLAFOOD_hook_HUDPAINT", function()
    local activeBuff = LocalPlayer():GetNWString("VANILLABUFF",nil)
    if activeBuff ~= "" then
        surface.SetFont("vanilla_font_info")
        local length = surface.GetTextSize(activeBuff .. "BUFF ACTIVE: 800")

        _G.vanillaBlurPanel(ScrW() * 0.01,ScrH() * 0.86,length + ScrW() * 0.03,ScrH() * 0.035, Color(0,0,0,100));

        draw.SimpleText(string.upper(activeBuff) .. " BUFF ACTIVE: " .. tostring(LocalPlayer():GetNWInt("VANILLABUFFTIMER",900)), "vanilla_font_info", ScrW() * 0.015, ScrH() * 0.877, col.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end )
