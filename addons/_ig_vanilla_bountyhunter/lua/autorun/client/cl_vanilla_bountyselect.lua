//colours, fonts, materials, matrixes.
//font --> 3 x (number) = size
local scrw, scrh = ScrW(), ScrH()
local col = {
    white = Color(255,255,255,255),
    grey = Color(31,31,31,255),
    gray = Color(139,139,139,255),
    black = Color(0,0,0,255),
    maroon = Color(60,27,27,255),
    lightmaroon = Color(86,40,40,255)
}

local prices = {
    ["0"] = 0,
    ["1"] = 0,
    ["2"] = 2000,
    ["3"] = 4000,
    ["4"] = 10000,
    ["5"] = 20000,
    ["6"] = 30000,
    ["ALL ACCESS"] = 75000,
    ["AREA ACCESS"] = 75000,

}

local function RotatedText( text, font, x, y, color, ang)
    render.PushFilterMag( TEXFILTER.ANISOTROPIC )
    render.PushFilterMin( TEXFILTER.ANISOTROPIC )

    local m = Matrix()
    m:Translate( Vector( x, y, 0 ) )
    m:Rotate( Angle( 0, ang, 0 ) )

    surface.SetFont( font )
    local w, h = surface.GetTextSize( text )

    m:Translate( -Vector( w / 2, h / 2, 0 ) )

    cam.PushModelMatrix( m )
        draw.DrawText( text, font, 0, 0, color, TEXT_ALIGN_LEFT )
    cam.PopModelMatrix()

    render.PopFilterMag()
    render.PopFilterMin()
end

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

local decal = Material("materials/vanilla/bh/decal.png")
local background = Material("materials/vanilla/bh/background.png")
local chain = Material("materials/vanilla/bh/chain.png")
local chain2 = Material("materials/vanilla/bh/chain2.png")
local select = Material("materials/vanilla/bh/select.png")
local price = Material("materials/vanilla/bh/price.png")

surface.CreateFont("vanilla_bhmenu_title",{
    font = "Acumin Pro",
    antialias = true,
    weight = 800,
    size = ScreenScale(24)
})
surface.CreateFont("vanilla_bhmenu_button",{
    font = "Acumin Pro",
    antialias = true,
    weight = 800,
    size = ScreenScale(12)
})
surface.CreateFont("vanilla_bhmenu_aurebesh",{
    font = "Aurebesh",
    antialias = true,
    weight = 100,
    size = ScreenScale(6)
})
surface.CreateFont("vanilla_bhmenu_number",{
    font = "Aurebesh",
    antialias = true,
    weight = 100,
    size = ScreenScale(18)
})
surface.CreateFont("vanilla_bhmenu_aurebesh_large",{
    font = "Aurebesh",
    antialias = true,
    weight = 100,
    size = ScreenScale(12)
})
surface.CreateFont("vanilla_bhmenu_text",{
    font = "Acumin Pro",
    antialias = true,
    weight = 800,
    size = ScreenScale(14)
})
surface.CreateFont("vanilla_bhmenu_price",{
    font = "Acumin Pro",
    antialias = true,
    weight = 1,
    size = ScreenScale(18)
})
net.Receive("VANILLABOUNTY_net_OpenHitMenu", function()
    if LocalPlayer():GetRegiment() == "Bounty Hunter" then return end

    local counter = 0
    for _, v in ipairs(player.GetAll()) do
        if v:GetRegiment() == "Bounty Hunter" then
            counter = counter + 1;
        end
    end

    if counter == 0 then counter = "NO" end

    local buttonMatrix = Matrix()
    buttonMatrix:Scale(Vector(1,1,1))
    buttonMatrix:Rotate(Angle(0,-25,0))
    buttonMatrix:Translate(Vector(-(scrw * 0.19), -(scrh * 0.01)))

    local kidnapMatrix = Matrix()
    kidnapMatrix:Scale(Vector(1,1,1))
    kidnapMatrix:Rotate(Angle(0,-25,0))
    kidnapMatrix:Translate(Vector(-(scrw * 0.24), scrh * 0.21))

    local killMatrix = Matrix()
    killMatrix:Scale(Vector(1,1,1))
    killMatrix:Rotate(Angle(0,-25,0))
    killMatrix:Translate(Vector(-(scrw * 0.245), scrh * 0.33))

    local exitMatrix = Matrix()
    exitMatrix:Scale(Vector(1,1,1))
    exitMatrix:Rotate(Angle(0,-25,0))
    exitMatrix:Translate(Vector(-(scrw * 0.22), scrh * 0.053))

    local creditMatrix = Matrix()
    creditMatrix:Scale(Vector(1,1,1))
    creditMatrix:Rotate(Angle(0,15,0))
    creditMatrix:Translate(Vector(scrw * 0.8, scrh * 0.3))

    //Derma begin
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetAlpha(0)
    frame:SetSize(scrw,scrh)
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        //bg
        surface.SetDrawColor(col.white)
        surface.SetMaterial(background)
        surface.DrawTexturedRect(0,0,w,h)
    end
    frame:AlphaTo( 255, 0.2, 0)

    local paige = vgui.Create("DPanel", frame)
    paige:SetSize(scrw,scrh)
    paige:SetPos(0,0)
    paige.Paint = function(self, w, h)
        //title text
        draw.SimpleText("AVAILABLE BOUNTY HUNTERS","vanilla_bhmenu_title",w * 0.98,h * 0.03,col.white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
        draw.SimpleText("rip crix, code by vanilla, portraits by veteran","vanilla_bhmenu_aurebesh",w * 0.98,h * 0.105,col.white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)

        //info text
        draw.SimpleText(counter .. " HUNTERS AVAILABLE","vanilla_bhmenu_button",w / 2 + math.random(-0.1,0.1),h / 2 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER);
    end

    local butan = vgui.Create("DButton", paige)
    butan:SetSize(scrw * 0.11,scrh * 0.1)
    butan:SetPos(scrw * 0.02,scrh * 0.8)
    butan:SetText("")
    butan.Paint = function(self, w, h)
        cam.PushModelMatrix(buttonMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("NEXT","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        cam.PopModelMatrix()
        render.PopFilterMag()
        render.PopFilterMin()
    end

    if counter == "NO" then butan:Remove() end

    local exit = vgui.Create("DButton", paige)
    exit:SetSize(scrw * 0.11,scrh * 0.1)
    exit:SetPos(scrw * 0.13,scrh * 0.8)
    exit:SetText("")
    exit.Paint = function(self, w, h)
        cam.PushModelMatrix(exitMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("EXIT","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    exit.DoClick = function()
        frame:AlphaTo( 0, 0.2, 0)
        timer.Simple(0.2,function() frame:Close() end)
    end

    local selected = "NO TARGET SELECTED"
    local clearance = "0"
    local method = ""
    local walter = vgui.Create("DPanel", frame)
    walter:SetSize(scrw,scrh)
    walter:SetPos(scrw,0)
    //walter:SetPos(0,0)
    walter.Paint = function(self, w, h)
        surface.SetDrawColor(col.white)
        surface.SetMaterial(decal)
        surface.DrawTexturedRect(0,h * 0.05,w * 0.25572916666,h * 0.92685185185)

        surface.SetMaterial(chain)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(select)
        surface.DrawTexturedRect(w * 0.72,h * 0.05,w * 0.25729166666,h * 0.22314814814)

        draw.SimpleText("NAME","vanilla_bhmenu_text",w * 0.36,h * 0.075,col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        //draw.SimpleText("CLEARANCE LEVEL","vanilla_bhmenu_text",w * 0.36 + w * 0.285,h * 0.075,col.white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)

        draw.SimpleText("TARGET:","vanilla_bhmenu_text",w * 0.72,h * 0.43,col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
        draw.SimpleText(selected,"vanilla_bhmenu_text",w * 0.72,h * 0.43,col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

        cam.PushModelMatrix(creditMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        surface.SetDrawColor(col.black)
        surface.DrawRect(0,0,w * 0.26, h * 0.21)

        surface.SetDrawColor(col.white)
        surface.DrawRect(w * 0.013,h * 0.025,w * 0.23, h * 0.005)
        surface.DrawRect(w * 0.013,h * 0.12,w * 0.23, h * 0.005)
        surface.DrawRect(w * 0.013,h * 0.13,w * 0.23, h * 0.005)

        //Crix! Make sure to change this number to the players credits!
        draw.SimpleText(LocalPlayer():SH_GetPremiumPoints(),"vanilla_bhmenu_number",w * 0.242,h * 0.075,col.white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        draw.SimpleText("credits","vanilla_bhmenu_aurebesh_large",w * 0.242,h * 0.165,col.white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end

    local scroll = vgui.Create("DScrollPanel",walter)
    scroll:SetSize(scrw * 0.3,scrh * 0.7)
    scroll:SetPos(scrw * 0.36, scrh * 0.1)
    local sbar = scroll:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, col.lightmaroon)
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, col.white)
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, col.white)
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(10, w * 0.001, 0, w * 0.999, h, col.white)
    end

    //Crix! Make sure to make this loop the targetable players!
    for _, v in ipairs(player.GetAll()) do
        if v == LocalPlayer() then continue end
        if v:GetJobTable().Clearance == "0" or v:GetJobTable().Clearance == "1" then continue end

        local DButton = scroll:Add( "DButton" )
        DButton:SetText("")
        DButton:Dock( TOP )
        DButton:SetSize(0,scrh * 0.05)
        DButton:DockMargin( 0, 0, 0, 10 )
        DButton.Paint = function(self, w, h)
            local poly = {
                { x = 0, y = 0 },
                { x = w * 0.95, y = 0 },
                { x = w * 0.98, y = h * 0.2 },
                { x = w * 0.98, y = h },
                { x = w * 0.03, y = h },
                { x = 0, y = h * 0.8 }
            }
            surface.SetDrawColor(col.white)
            draw.NoTexture()
            surface.DrawPoly(poly)

            //Crix! Make sure to make this text the player's name variable
            if not IsValid(v) then return end
            draw.SimpleText(v:Nick(),"vanilla_bhmenu_button",w * 0.03,h * 0.47,col.black,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        DButton.DoClick = function()
            //Crix! Make sure to make this text the player's name variable
            selected = v:Nick();
            clearance = v:GetJobTable().Clearance;
        end
    end

    local back = vgui.Create("DButton", walter)
    back:SetSize(scrw * 0.11,scrh * 0.1)
    back:SetPos(scrw * 0.02,scrh * 0.85)
    back:SetText("")
    back.Paint = function(self, w, h)
        cam.PushModelMatrix(buttonMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("BACK","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    back:SetAlpha(0)

    local kidnap = vgui.Create("DButton", walter)
    kidnap:SetSize(scrw * 0.11,scrh * 0.1)
    kidnap:SetPos(scrw * 0.35,scrh * 0.85)
    kidnap:SetText("")
    kidnap.Paint = function(self, w, h)
        cam.PushModelMatrix(kidnapMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("KIDNAP","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    kidnap:SetAlpha(0)

    local assasinate = vgui.Create("DButton", walter)
    assasinate:SetSize(scrw * 0.11,scrh * 0.1)
    assasinate:SetPos(scrw * 0.5,scrh * 0.85)
    assasinate:SetText("")
    assasinate.Paint = function(self, w, h)
        cam.PushModelMatrix(killMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("ELIMINATE","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    assasinate:SetAlpha(0)


    local phillip = vgui.Create("DPanel", frame)
    phillip:SetSize(scrw,scrh)
    phillip:SetPos(0,scrh)

    local val = false

    local priceentry = vgui.Create("DTextEntry", phillip)
    priceentry:SetSize(scrw * 0.3, scrh * 0.1)
    priceentry:SetPos(scrw * 0.5, scrh * 0.54)
    priceentry:SetValue("CLICK TO ENTER PRICE")
    priceentry:SetNumeric(true)
    priceentry.OnGetFocus = function()
        priceentry:SetValue(prices[clearance])
        val = true
    end
    priceentry.Paint = function()
    end

    local location = vgui.Create("DTextEntry", phillip)
    location:SetSize(scrw * 0.3, scrh * 0.1)
    location:SetPos(scrw * 0.4, scrh * 0.7)
    location:SetValue("CLICK TO ENTER LOCATION")
    location.OnGetFocus = function()
        location:SetValue("")
    end
    location.Paint = function()
    end

    phillip.Paint = function(self, w, h)
        surface.SetDrawColor(col.white)
        surface.SetMaterial(chain2)
        surface.DrawTexturedRect(0,0,w,h)

        surface.SetMaterial(price)
        surface.DrawTexturedRect(w * 0.2,h * 0.05,w * 0.59166666666,h * 0.13333333333)

        RotatedText("JOB:","vanilla_bhmenu_price",w * 0.44,h * 0.25,col.white,-10)
        RotatedText(method,"vanilla_bhmenu_price",w * 0.50,h * 0.28,col.gray,-10)

        RotatedText("TARGET:","vanilla_bhmenu_price",w * 0.47,h * 0.4,col.white,-10)
        RotatedText(string.upper(selected),"vanilla_bhmenu_price",w * 0.515,h * 0.435,col.gray,-10)

        if method == "KIDNAPPING" then
            RotatedText("Kidnapping bounties must be negotiated manually.","vanilla_bhmenu_price",w * 0.55,h * 0.59,col.gray,5)
            return
        end

        RotatedText("PRICE (Minimum value for this target is " .. prices[clearance] .. ")","vanilla_bhmenu_price",w * 0.65,h * 0.54,col.white,10)
        if val and priceentry:GetValue() ~= "" then
            RotatedText(priceentry:GetValue() .. " credits","vanilla_bhmenu_price",w * 0.65,h * 0.59,col.gray,10.5)
        else
            RotatedText(priceentry:GetValue(),"vanilla_bhmenu_price",w * 0.65,h * 0.59,col.gray,10.5)
        end

        RotatedText("LAST KNOWN LOCATION:","vanilla_bhmenu_price",w * 0.55,h * 0.7,col.white,10)
        RotatedText(location:GetValue(),"vanilla_bhmenu_price",w * 0.55,h * 0.75,col.gray,10.5)
    end

    local finalize = vgui.Create("DButton", phillip)
    finalize:SetSize(scrw * 0.11,scrh * 0.1)
    finalize:SetPos(scrw * 0.45,scrh * 0.83)
    finalize:SetText("")
    finalize.Paint = function(self, w, h)
        cam.PushModelMatrix(killMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("FINALIZE","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    finalize:SetAlpha(0)

    local back2 = vgui.Create("DButton", phillip)
    back2:SetSize(scrw * 0.11,scrh * 0.1)
    back2:SetPos(scrw * 0.02,scrh * 0.85)
    back2:SetText("")
    back2.Paint = function(self, w, h)
        cam.PushModelMatrix(buttonMatrix)
        render.PushFilterMag( TEXFILTER.ANISOTROPIC )
        render.PushFilterMin( TEXFILTER.ANISOTROPIC )
        draw.NoTexture()

        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 40, 50)
        surface.SetDrawColor(col.maroon)
        Circle(w * 0.2, h * 0.5, 25, 50)
        surface.SetDrawColor(col.white)
        Circle(w * 0.2, h * 0.5, 15, 50)

        draw.SimpleTextOutlined("BACK","vanilla_bhmenu_button",w * 0.25 + math.random(-0.1,0.1),h * 0.5 + math.random(-0.1,0.1),col.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,3,col.maroon)
        render.PopFilterMag()
        render.PopFilterMin()
        cam.PopModelMatrix()
    end
    back2:SetAlpha(0)


    //BUTTON DO CLICKS//////////////////////////////////////////////////////////////////////////////////
    back.DoClick = function()
        paige:MoveTo( 0, 0, 1, 0, 2)
        walter:MoveTo(scrw, 0, 1, 0, 2)

        butan:AlphaTo(255,0.2,1)
        exit:AlphaTo(255,0.2,1)

        back:AlphaTo(0,0.2,0)
        kidnap:AlphaTo(0,0.2,0)
        assasinate:AlphaTo(0,0.2,0)
    end
    butan.DoClick = function()
        paige:MoveTo( -scrw, 0, 1, 0, 2)
        walter:MoveTo( 0, 0, 1, 0, 2)

        butan:AlphaTo(0,0.2,0)
        exit:AlphaTo(0,0.2,0)

        back:AlphaTo(255,0.2,1)
        kidnap:AlphaTo(255,0.2,1)
        assasinate:AlphaTo(255,0.2,1)
    end
    assasinate.DoClick = function()
        if selected == "NO TARGET SELECTED" then return end
        method = "ASSASINATION"
        walter:MoveTo( 0, -scrh, 1, 0, 2)
        phillip:MoveTo( 0, 0, 1, 0, 2)

        back:AlphaTo(0,0.2,0)
        kidnap:AlphaTo(0,0.2,0)
        assasinate:AlphaTo(0,0.2,0)

        finalize:AlphaTo(255,0.2,1)
        back2:AlphaTo(255,0.2,1)
    end
    kidnap.DoClick = function()
        if selected == "NO TARGET SELECTED" then return end
        method = "KIDNAPPING"
        walter:MoveTo( 0, -scrh, 1, 0, 2)
        phillip:MoveTo( 0, 0, 1, 0, 2)

        back:AlphaTo(0,0.2,0)
        kidnap:AlphaTo(0,0.2,0)
        assasinate:AlphaTo(0,0.2,0)

        finalize:AlphaTo(255,0.2,1)
        back2:AlphaTo(255,0.2,1)
    end
    back2.DoClick = function(self)
        walter:MoveTo( 0, 0, 1, 0, 2)
        phillip:MoveTo( 0, scrh, 1, 0, 2)

        finalize:AlphaTo(0,0.2,0)
        self:AlphaTo(0,0.2,0)

        back:AlphaTo(255,0.2,1)
        kidnap:AlphaTo(255,0.2,1)
        assasinate:AlphaTo(255,0.2,1)
    end
    finalize.DoClick = function()
        local reward = priceentry:GetValue();
        local locationValue = location:GetValue();

        if method ~= "KIDNAPPING" then
            if reward == "CLICK TO ENTER PRICE" or reward == "" then return end
            if tonumber(reward) < tonumber(prices[clearance]) then return end
            if not LocalPlayer():SH_CanAffordPremium(tonumber(reward)) then return end
        end

        frame:AlphaTo( 0, 0.2, 0)

        timer.Simple(0.2, function()
            frame:Close();

            if method == "KIDNAPPING" then return end

            net.Start("VANILLABOUNTY_net_BroadcastBounty");
            net.WriteString(method);
            net.WriteString(selected);
            net.WriteString(reward);
            net.WriteString(locationValue);
            net.SendToServer();
        end)
    end
end)

hook.Add("InitPostEntity", "VANILLABOUNTY_net_InitPostEntity", function()
    net.Start("VANILLABOUNTY_net_LoginBroadcast");
    net.SendToServer();
end)