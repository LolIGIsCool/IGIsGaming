function AttemptToPurchase(aug)
    net.Start("VANILLAAUGMENTS_net_PurchaseAttempt")
    net.WriteString(aug)
    net.SendToServer()
end

local plyData
local augmentPoints
local textColour = (Color(255,255,255))

function AugmentHUD()
    //READ DATA
    plyData = net.ReadTable()
    augmentPoints = plyData.Points

    //Whole Frame
    local sFrame = vgui.Create("DFrame")
    sFrame:SetSize(ScrW() * 0.9, ScrH() * 0.9)
    sFrame:Center()
    sFrame:MakePopup()
    sFrame:SetTitle("")
    sFrame:NoClipping(true)
    sFrame:SetDraggable(false)
    sFrame.Paint = function(self, w, h)
        surface.SetDrawColor(Color(38, 38, 38, 250))
        surface.DrawRect(0,0,w,h)
    end

    local fx, fy = sFrame:GetSize()

    //Sidebar Frame
    local cFrame = vgui.Create("DPanel", sFrame)
    cFrame:SetSize(fx * 0.25, fy)
    cFrame:Dock(LEFT)
    cFrame:DockMargin(-10,-30,0,-30)
    cFrame.Paint = function(self, w, h)
    end

    local sx, sy = cFrame:GetSize()

    //------------------------------SIDE BAR INFO--------------------\\

    local sidebar = {}
    sidebar.Name = "Click on an Augment"
    sidebar.Tree = "to read its information"
    sidebar.Cost = ""
    sidebar.Req = ""
    sidebar.Info = ""
    sidebar.Icon = "vanilla/skillicon/healthbooster3.png"

    //--------------------------------SKILL TREE CONTENT----------------------------------\\

    //Property Sheet
    local propSheet = vgui.Create("DPropertySheet",sFrame)
    propSheet:DockMargin(sx * 0.05,0,sx * 0.05,sy * 0.03)
    propSheet:Dock(FILL)
    propSheet:SetFadeTime(0)
    propSheet.Paint = function(self,w,h)
    end

    //Icon Size
    local ix,iy = ScrW() / 19.2, ScrH() / 10.8
    propSheet:InvalidateParent( true )
    local px,py = propSheet:GetSize()

    //Survival Tree
    local survivalTree = vgui.Create("DPanel",propSheet)
    propSheet:AddSheet( "Survival", survivalTree)

    local iconColourTable = {};

    //Health Booster 1
    local hB1 = vgui.Create("DImageButton", survivalTree)
    hB1:SetSize(ix,iy)
    hB1:SetPos(px * 0.45,py * 0.1)
    hB1:SetImage("vanilla/skillicon/healthbooster1.png")
    hB1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Health Booster I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Health Booster I"] = hB1;

    //Health Booster 2
    local hB2 = vgui.Create("DImageButton", survivalTree)
    hB2:SetSize(ix,iy)
    hB2:SetPos(px * 0.65,py * 0.35)
    hB2:SetImage("vanilla/skillicon/healthbooster2.png")
    hB2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Health Booster II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Health Booster II"] = hB2;

    //Health Booster 3
    local hB3 = vgui.Create("DImageButton", survivalTree)
    hB3:SetSize(ix,iy)
    hB3:SetPos(px * 0.65,py * 0.6)
    hB3:SetImage("vanilla/skillicon/healthbooster3.png")
    hB3.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Health Booster III" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Health Booster III"] = hB3;

    //Passive Recoverment
    local pR = vgui.Create("DImageButton", survivalTree)
    pR:SetSize(ix,iy)
    pR:SetPos(px * 0.85,py * 0.6)
    pR:SetImage("vanilla/skillicon/passiverecoverment.png")
    pR.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Passive Recovery" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Passive Recovery"] = pR;

    //Heal Intake 1
    local hI1 = vgui.Create("DImageButton", survivalTree)
    hI1:SetSize(ix,iy)
    hI1:SetPos(px * 0.25,py * 0.35)
    hI1:SetImage("vanilla/skillicon/healintake1.png")
    hI1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Heal Intake I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Heal Intake I"] = hI1;


    //Heal Intake 2
    local hI2 = vgui.Create("DImageButton", survivalTree)
    hI2:SetSize(ix,iy)
    hI2:SetPos(px * 0.25,py * 0.6)
    hI2:SetImage("vanilla/skillicon/healintake2.png")
    hI2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Heal Intake II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Heal Intake II"] = hI2;

    //Swift Recovery
    local sR = vgui.Create("DImageButton", survivalTree)
    sR:SetSize(ix,iy)
    sR:SetPos(px * 0.05,py * 0.6)
    sR:SetImage("vanilla/skillicon/swiftrecovery.png")
    sR.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Swift Recovery" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Swift Recovery"] = sR;

    //Shatterproof Bones
    local sB = vgui.Create("DImageButton", survivalTree)
    sB:SetSize(ix,iy)
    sB:SetPos(px * 0.45,py * 0.35)
    sB:SetImage("vanilla/skillicon/steellegs.png")
    sB.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Durasteel Skeleton" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Durasteel Skeleton"] = sB;

    //Event Horizon
    local eH = vgui.Create("DImageButton", survivalTree)
    eH:SetSize(ix,iy)
    eH:SetPos(px * 0.45,py * 0.7)
    eH:SetImage("vanilla/skillicon/eventhorizon.png")
    eH.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Event Horizon" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Event Horizon"] = eH;

    local survivalMat = Material("vanilla/skillicon/survivalmythic.png");
    survivalTree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h)

        //Lines
        surface.SetDrawColor(208,128,41,255)
        surface.DrawLine(px * 0.45 + ix / 2,py * 0.1 + iy,px * 0.45 + ix / 2,py * 0.35) //HB1 --> SB
        surface.DrawLine(px * 0.45,py * 0.1 + iy,px * 0.25 + ix / 2,py * 0.35) //HB1 --> HI1
        surface.DrawLine(px * 0.45 + ix,py * 0.1 + iy,px * 0.65 + ix / 2,py * 0.35) //HB1 --> HB2

        surface.DrawLine(px * 0.65 + ix / 2, py * 0.35 + iy,px * 0.65 + ix / 2,py * 0.6) //HB2 --> HB3
        surface.DrawLine(px * 0.65 + ix, py * 0.35 + iy,px * 0.85 + ix / 2,py * 0.6) //HB2 --> PR

        surface.DrawLine(px * 0.25 + ix / 2,py * 0.35 + iy,px * 0.25 + ix / 2,py * 0.6) //HI1 --> HI2
        surface.DrawLine(px * 0.25,py * 0.35 + iy,px * 0.05 + ix / 2,py * 0.6) //HI1 --> SR

        //Mythic Cooliness
        surface.SetDrawColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        surface.SetMaterial(survivalMat);
        surface.DrawTexturedRectRotated( px * 0.45 + ix / 2,py * 0.7 + iy / 2, ix + ix, iy + iy, (CurTime() % 360) * 25 )
        surface.DrawTexturedRectRotated( px * 0.45 + ix / 2,py * 0.7 + iy / 2, ix + ix, iy + iy, ((CurTime() % 360) * 25) + 45 )
        surface.DrawTexturedRectRotated( px * 0.45 + ix / 2,py * 0.7 + iy / 2, ix + ix, iy + iy, ((CurTime() % 360) * 25) + 23.5 )

    end

    //Offense Tree
    local offenseTree = vgui.Create("DPanel",propSheet)
    propSheet:AddSheet( "Offense", offenseTree)

    //Critical Strike 1
    local cS1 = vgui.Create("DImageButton", offenseTree)
    cS1:SetSize(ix,iy)
    cS1:SetPos(px * 0.15,py * 0.1)
    cS1:SetImage("vanilla/skillicon/criticalstrike1.png")
    cS1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Critical Strike I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Critical Strike I"] = cS1;

    //Critical Strike 2
    local cS2 = vgui.Create("DImageButton", offenseTree)
    cS2:SetSize(ix,iy)
    cS2:SetPos(px * 0.15,py * 0.35)
    cS2:SetImage("vanilla/skillicon/criticalstrike2.png")
    cS2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Critical Strike II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Critical Strike II"] = cS2;

    //Dead Eye 1
    local dE1 = vgui.Create("DImageButton", offenseTree)
    dE1:SetSize(ix,iy)
    dE1:SetPos(px * 0.75,py * 0.1)
    dE1:SetImage("vanilla/skillicon/deadeye1.png")
    dE1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Dead Eye I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Dead Eye I"] = dE1;

    //Dead Eye 2
    local dE2 = vgui.Create("DImageButton", offenseTree)
    dE2:SetSize(ix,iy)
    dE2:SetPos(px * 0.75,py * 0.35)
    dE2:SetImage("vanilla/skillicon/deadeye2.png")
    dE2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Dead Eye II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Dead Eye II"] = dE2;

    //Critical Limit
    local cL = vgui.Create("DImageButton", offenseTree)
    cL:SetSize(ix,iy)
    cL:SetPos(px * 0.45,py * 0.5)
    cL:SetImage("vanilla/skillicon/criticallimit.png")
    cL.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Critical Limit" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Critical Limit"] = cL;

    //Zenith Potential
    local zP = vgui.Create("DImageButton", offenseTree)
    zP:SetSize(ix,iy)
    zP:SetPos(px * 0.45,py * 0.75)
    zP:SetImage("vanilla/skillicon/zenithpotential.png")
    zP.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Zenith Potential" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Zenith Potential"] = zP;

    //Bloodlust
    local bL = vgui.Create("DImageButton", offenseTree)
    bL:SetSize(ix,iy)
    bL:SetPos(px * 0.6,py * 0.75)
    bL:SetImage("vanilla/skillicon/bloodlust.png")
    bL.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Bloodlust" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Bloodlust"] = bL;

    //Inspiring Aura
    local iA = vgui.Create("DImageButton", offenseTree)
    iA:SetSize(ix,iy)
    iA:SetPos(px * 0.3,py * 0.75)
    iA:SetImage("vanilla/skillicon/inspiringaura.png")
    iA.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Inspiring Aura" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Inspiring Aura"] = iA;

    //Last Stand
    local lS = vgui.Create("DImageButton", offenseTree)
    lS:SetSize(ix,iy)
    lS:SetPos(px * 0.45,py * 0.2)
    lS:SetImage("vanilla/skillicon/laststand.png")
    lS.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Last Stand" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Last Stand"] = lS;

    local offenseMat = Material("vanilla/skillicon/offensemythic.png");
    offenseTree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h)

        //Lines
        surface.SetDrawColor(208,128,41,255)
        surface.DrawLine(px * 0.15 + ix / 2,py * 0.1 + iy,px * 0.15 + ix / 2,py * 0.35) //CS1 --> CS2
        surface.DrawLine(px * 0.15 + ix,py * 0.35 + iy,px * 0.45,py * 0.5 + iy / 2) //CS2 --> CL

        surface.DrawLine(px * 0.75 + ix / 2,py * 0.1 + iy,px * 0.75 + ix / 2,py * 0.35) //DE1 --> DE2
        surface.DrawLine(px * 0.75,py * 0.35 + iy,px * 0.45 + ix,py * 0.5 + iy / 2) //DE2 --> CL

        surface.DrawLine(px * 0.45 + ix / 2,py * 0.5 + iy,px * 0.45 + ix / 2,py * 0.75) //CL --> ZP
        surface.DrawLine(px * 0.45 + ix,py * 0.5 + iy,px * 0.6 + ix / 2,py * 0.75) //CL --> BL
        surface.DrawLine(px * 0.45,py * 0.5 + iy,px * 0.3 + ix / 2,py * 0.75) //CL --> IA

        //Mythic Cooliness
        surface.SetDrawColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        surface.SetMaterial(offenseMat);
        surface.DrawTexturedRectRotated( px * 0.45 + ix / 2,py * 0.2 + iy / 2, ix + ix, iy + iy,0)
    end

    //Profit Tree
    local profitTree = vgui.Create("DPanel",propSheet)
    propSheet:AddSheet( "Profit", profitTree)

    //Lady Luck 1
    local lL1 = vgui.Create("DImageButton", profitTree)
    lL1:SetSize(ix,iy)
    lL1:SetPos(px * 0.05,py * 0.1)
    lL1:SetImage("vanilla/skillicon/ladyluck1.png")
    lL1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Lady Luck I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Lady Luck I"] = lL1;

    //Lady Luck 2
    local lL2 = vgui.Create("DImageButton", profitTree)
    lL2:SetSize(ix,iy)
    lL2:SetPos(px * 0.15,py * 0.4)
    lL2:SetImage("vanilla/skillicon/ladyluck2.png")
    lL2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Lady Luck II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Lady Luck II"] = lL2;

    //Lady Luck 3
    local lL3 = vgui.Create("DImageButton", profitTree)
    lL3:SetSize(ix,iy)
    lL3:SetPos(px * 0.05,py * 0.7)
    lL3:SetImage("vanilla/skillicon/ladyluck3.png")
    lL3.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Lady Luck III" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Lady Luck III"] = lL3;

    //Experience Accumulator 1
    local eA1 = vgui.Create("DImageButton", profitTree)
    eA1:SetSize(ix,iy)
    eA1:SetPos(px * 0.85,py * 0.1)
    eA1:SetImage("vanilla/skillicon/experienceaccumulator1.png")
    eA1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Experience Accumulator I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Experience Accumulator I"] = eA1;

    //Routine Reward
    local rR = vgui.Create("DImageButton", profitTree)
    rR:SetSize(ix,iy)
    rR:SetPos(px * 0.75,py * 0.4)
    rR:SetImage("vanilla/skillicon/routinereward.png")
    rR.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Routine Reward" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Routine Reward"] = rR;

    //Experience Accumulator 2
    local eA2 = vgui.Create("DImageButton", profitTree)
    eA2:SetSize(ix,iy)
    eA2:SetPos(px * 0.85,py * 0.7)
    eA2:SetImage("vanilla/skillicon/experienceaccumulator2.png")
    eA2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Experience Accumulator II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Experience Accumulator II"] = eA2;

    //Debt Collector
    local dC = vgui.Create("DImageButton", profitTree)
    dC:SetSize(ix,iy)
    dC:SetPos(px * 0.45,py * 0.4)
    dC:SetImage("vanilla/skillicon/debtcollector.png")
    dC.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Debt Collector" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Debt Collector"] = dC;

    local profitMat = Material("vanilla/skillicon/profitmythic.png");
    profitTree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h)

        //Lines
        surface.SetDrawColor(208,128,41,255)
        surface.DrawLine(px * 0.05 + ix,py * 0.1 + iy,px * 0.15 + ix / 2,py * 0.4) //LL1 --> LL2
        surface.DrawLine(px * 0.15 + ix / 2,py * 0.4 + iy,px * 0.05 + ix,py * 0.7) //LL2 --> LL3

        surface.DrawLine(px * 0.85,py * 0.1 + iy,px * 0.75 + ix / 2,py * 0.4) //EA1 --> RR
        surface.DrawLine(px * 0.75 + ix / 2,py * 0.4 + iy,px * 0.85,py * 0.7) //RR --> EA2

        //Mythic Cooliness
        surface.SetDrawColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        surface.SetMaterial(profitMat);
        surface.DrawTexturedRectRotated( px * 0.45 + ix / 2,py * 0.4 + iy / 2, ix + ix, iy + iy,-( CurTime() * 25 ) % 360)
    end

    //Utility Tree
    local utilityTree = vgui.Create("DPanel",propSheet)
    propSheet:AddSheet( "Utility", utilityTree)

    local aH1 = vgui.Create("DImageButton", utilityTree)
    aH1:SetSize(ix,iy)
    aH1:SetPos(px * 0.15,py * 0.1)
    aH1:SetImage("vanilla/skillicon/ammunitionhoarder1.png")
    aH1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Ammunition Hoarder I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Ammunition Hoarder I"] = aH1;

    local aH2 = vgui.Create("DImageButton", utilityTree)
    aH2:SetSize(ix,iy)
    aH2:SetPos(px * 0.15,py * 0.25)
    aH2:SetImage("vanilla/skillicon/ammunitionhoarder2.png")
    aH2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Ammunition Hoarder II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Ammunition Hoarder II"] = aH2;

    local tM = vgui.Create("DImageButton", utilityTree)
    tM:SetSize(ix,iy)
    tM:SetPos(px * 0.26,py * 0.25)
    tM:SetImage("vanilla/skillicon/themountaineer.png")
    tM.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "The Mountaineer" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["The Mountaineer"] = tM;

    local sO = vgui.Create("DImageButton", utilityTree)
    sO:SetSize(ix,iy)
    sO:SetPos(px * 0.26,py * 0.4)
    sO:SetImage("vanilla/skillicon/starshipoverdrive.png")
    sO.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Starship Overdrive" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Starship Overdrive"] = sO;

    local fTL1 = vgui.Create("DImageButton", utilityTree)
    fTL1:SetSize(ix,iy)
    fTL1:SetPos(px * 0.75,py * 0.1)
    fTL1:SetImage("vanilla/skillicon/fasterthanlight1.png")
    fTL1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Faster Than Light I" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Faster Than Light I"] = fTL1;

    local fTL2 = vgui.Create("DImageButton", utilityTree)
    fTL2:SetSize(ix,iy)
    fTL2:SetPos(px * 0.69,py * 0.25)
    fTL2:SetImage("vanilla/skillicon/fasterthanlight2.png")
    fTL2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Faster Than Light II" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Faster Than Light II"] = fTL2;

    local fTL3 = vgui.Create("DImageButton", utilityTree)
    fTL3:SetSize(ix,iy)
    fTL3:SetPos(px * 0.63,py * 0.4)
    fTL3:SetImage("vanilla/skillicon/fasterthanlight3.png")
    fTL3.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Faster Than Light III" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Faster Than Light III"] = fTL3;

    local aUTSP = vgui.Create("DImageButton", utilityTree)
    aUTSP:SetSize(ix,iy)
    aUTSP:SetPos(px * 0.4,py * 0.75)
    aUTSP:SetImage("vanilla/skillicon/aceupthesleevepri.png")
    aUTSP.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Ace up the Sleeve [PRIMARY]" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Ace up the Sleeve [PRIMARY]"] = aUTSP;

    local aUTSS = vgui.Create("DImageButton", utilityTree)
    aUTSS:SetSize(ix,iy)
    aUTSS:SetPos(px * 0.5,py * 0.75)
    aUTSS:SetImage("vanilla/skillicon/aceupthesleevespec.png")
    aUTSS.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Ace up the Sleeve [SPECIALIST]" then
                table.Merge(sidebar,v)
            end
        end
    end
    iconColourTable["Ace up the Sleeve [SPECIALIST]"] = aUTSS;

    local utilMat = Material("vanilla/skillicon/utilitymythic1.png");
    local utilMat2 = Material("vanilla/skillicon/utilitymythic2.png");
    utilityTree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h)

        //Lines
        surface.SetDrawColor(208,128,41,255)
        surface.DrawLine(px * 0.15 + ix / 2,py * 0.1 + iy,px * 0.15 + ix / 2,py * 0.25) //AH1-->AH2
        surface.DrawLine(px * 0.15 + ix,py * 0.25 + iy / 2,px * 0.26,py * 0.25 + iy / 2) //AH2-->TM
        surface.DrawLine(px * 0.26 + ix / 2,py * 0.25 + iy,px * 0.26 + ix / 2,py * 0.4) //TM-->SO

        surface.DrawLine(px * 0.75,py * 0.1 + iy,px * 0.69 + ix / 2,py * 0.25) //FTL1-->FTL2
        surface.DrawLine(px * 0.69,py * 0.25 + iy,px * 0.63 + ix / 2,py * 0.4) //FTL2-->FTL3

        //Mythic Cooliness
        surface.SetDrawColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        surface.DrawLine(px * 0.4 + ix,py * 0.75 + iy / 2,px * 0.5,py * 0.75 + iy / 2)
        surface.SetMaterial(utilMat);
        //Right wing
        surface.DrawTexturedRect( px * 0.5 + ix,py * 0.78 - iy / 2, ix + ix * 2, iy + iy / 2)
        //Left wing
        surface.SetMaterial(utilMat2);
        surface.DrawTexturedRect( px * 0.087 + ix,py * 0.78 - iy / 2, ix + ix * 2, iy + iy / 2)
    end

    //Mobility Tree
    local mobilityTree = vgui.Create("DPanel",propSheet);
    propSheet:AddSheet( "Mobility", mobilityTree);

    local tL1 = vgui.Create("DImageButton", mobilityTree);
    tL1:SetSize(ix,iy);
    tL1:SetPos(px * 0.2,py * 0.1);
    tL1:SetImage("vanilla/skillicon/tauntaunlegs1.png");
    tL1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Tauntaun Legs I" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Tauntaun Legs I"] = tL1;

    local tL2 = vgui.Create("DImageButton", mobilityTree);
    tL2:SetSize(ix,iy);
    tL2:SetPos(px * 0.3,py * 0.25);
    tL2:SetImage("vanilla/skillicon/tauntaunlegs2.png");
    tL2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Tauntaun Legs II" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Tauntaun Legs II"] = tL2;

    local sC1 = vgui.Create("DImageButton", mobilityTree);
    sC1:SetSize(ix,iy);
    sC1:SetPos(px * 0.85,py * 0.1);
    sC1:SetImage("vanilla/skillicon/skilledcrawler1.png");
    sC1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Skilled Crawler I" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Skilled Crawler I"] = sC1;

    local sC2 = vgui.Create("DImageButton", mobilityTree);
    sC2:SetSize(ix,iy);
    sC2:SetPos(px * 0.7,py * 0.1);
    sC2:SetImage("vanilla/skillicon/skilledcrawler2.png");
    sC2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Skilled Crawler II" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Skilled Crawler II"] = sC2;

    local sC3 = vgui.Create("DImageButton", mobilityTree);
    sC3:SetSize(ix,iy);
    sC3:SetPos(px * 0.85,py * 0.45);
    sC3:SetImage("vanilla/skillicon/skilledcrawler3.png");
    sC3.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Skilled Crawler III" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Skilled Crawler III"] = sC3;

    local eS1 = vgui.Create("DImageButton", mobilityTree);
    eS1:SetSize(ix,iy);
    eS1:SetPos(px * 0.6,py * 0.25);
    eS1:SetImage("vanilla/skillicon/evasivestance1.png");
    eS1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Evasive Stance I" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Evasive Stance I"] = eS1;

    local eS2 = vgui.Create("DImageButton", mobilityTree);
    eS2:SetSize(ix,iy);
    eS2:SetPos(px * 0.6,py * 0.45);
    eS2:SetImage("vanilla/skillicon/evasivestance2.png");
    eS2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Evasive Stance II" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Evasive Stance II"] = eS2;

    local uA = vgui.Create("DImageButton", mobilityTree);
    uA:SetSize(ix,iy);
    uA:SetPos(px * 0.2,py * 0.65);
    uA:SetImage("vanilla/skillicon/relentlessadvance.png");
    uA.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Unstoppable Advance" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Unstoppable Advance"] = uA;

    local mobilityTable = {};

    for i = 1, 36 do
        mobilityTable[#mobilityTable + 1] = Material("vanilla/skillicon/mobilitymythic/444339b5NDLuWQ-" .. #mobilityTable .. ".png");
    end

    local number = 1;
    mobilityTree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255);
        surface.DrawOutlinedRect(0,0,w,h);

        //Lines
        surface.SetDrawColor(208,128,41,255)

        surface.DrawLine(px * 0.2 + ix,py * 0.1 + iy / 2,px * 0.3 + ix / 2,py * 0.25); //TL1 --> TL2

        surface.DrawLine(px * 0.85,py * 0.1 + iy / 2,px * 0.7 + ix,py * 0.1 + iy / 2); //SC1 --> SC2
        surface.DrawLine(px * 0.7,py * 0.1 + iy / 2,px * 0.6 + ix / 2,py * 0.25); //SC2 --> ES1
        surface.DrawLine(px * 0.6 + ix / 2,py * 0.25 + iy,px * 0.6 + ix / 2,py * 0.45); //ES1 --> ES2
        surface.DrawLine(px * 0.6 + ix,py * 0.45 + ix / 2,px * 0.85,py * 0.45 + iy / 2); //ES2 --> SC3

        //Mythic Cooliness
        surface.SetDrawColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        surface.SetMaterial(mobilityTable[math.floor(number)]);
        surface.DrawTexturedRect(px * 0.12,py * 0.42,ix * 3,iy * 4);

        number = number + 0.1;
        if number > 36 then number = 1 end
    end

    //Specialty Tree
    local specialtytree = vgui.Create("DPanel",propSheet);
    propSheet:AddSheet( "Specialty", specialtytree);

    local sP1 = vgui.Create("DImageButton", specialtytree);
    sP1:SetSize(ix,iy);
    sP1:SetPos(px * 0.8,py * 0.1);
    sP1:SetImage("vanilla/skillicon/steadfastpresence1.png");
    sP1.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Steadfast Presence I" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Steadfast Presence I"] = sP1;

    local sP2 = vgui.Create("DImageButton", specialtytree);
    sP2:SetSize(ix,iy);
    sP2:SetPos(px * 0.8,py * 0.3);
    sP2:SetImage("vanilla/skillicon/steadfastpresence2.png");
    sP2.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Steadfast Presence II" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Steadfast Presence II"] = sP2;

    local eD = vgui.Create("DImageButton", specialtytree);
    eD:SetSize(ix,iy);
    eD:SetPos(px * 0.55,py * 0.3);
    eD:SetImage("vanilla/skillicon/efficientdischarge.png");
    eD.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Efficient Discharge" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Efficient Discharge"] = eD;

    local sM = vgui.Create("DImageButton", specialtytree);
    sM:SetSize(ix,iy);
    sM:SetPos(px * 0.35,py * 0.3);
    sM:SetImage("vanilla/skillicon/slowmetabolism.png");
    sM.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Slow Metabolism" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Slow Metabolism"] = sM;

    local sA = vgui.Create("DImageButton", specialtytree);
    sA:SetSize(ix,iy);
    sA:SetPos(px * 0.35,py * 0.5);
    sA:SetImage("vanilla/skillicon/stimulantaddict.png");
    sA.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Stimulant Addict" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Stimulant Addict"] = sA;

    local peR = vgui.Create("DImageButton", specialtytree);
    peR:SetSize(ix,iy);
    peR:SetPos(px * 0.1,py * 0.5);
    peR:SetImage("vanilla/skillicon/personalresentment.png");
    peR.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Personal Resentment" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Personal Resentment"] = peR;

    local wA = vgui.Create("DImageButton", specialtytree);
    wA:SetSize(ix,iy);
    wA:SetPos(px * 0.1,py * 0.7);
    wA:SetImage("vanilla/skillicon/wookiearms.png");
    wA.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Wookie Arms" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Wookie Arms"] = wA;

    local lP = vgui.Create("DImageButton", specialtytree);
    lP:SetSize(ix,iy);
    lP:SetPos(px * 0.8,py * 0.7);
    lP:SetImage("vanilla/skillicon/logisticsprime.png");
    lP.DoClick = function()
        for k, v in pairs(vanillaIGAugmentTree) do
            if v.Name == "Logistics Prime" then
                table.Merge(sidebar,v);
            end
        end
    end
    iconColourTable["Logistics Prime"] = lP;

    specialtytree.Paint = function(self,w,h)
        //Outline
        surface.SetDrawColor(255,255,255);
        surface.DrawOutlinedRect(0,0,w,h);

        //Lines
        surface.SetDrawColor(208,128,41,255)
        surface.DrawLine(px * 0.8 + ix / 2,py * 0.1 + iy, px * 0.8 + ix / 2,py * 0.3); //SP1 --> SP2

        //Mythic Cooliness
        surface.DrawCircle( px * 0.8 + ix / 2,py * 0.7 + iy / 2, 100 + math.sin( CurTime() ) * 50, HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ) );
        surface.DrawCircle( px * 0.8 + ix / 2,py * 0.7 + iy / 2, 10 + math.cos( CurTime() ) * 35, HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ) );
        surface.DrawCircle( px * 0.8 + ix / 2,py * 0.7 + iy / 2, 5 + math.tan( CurTime() ) * 60, HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ) );
    end

    //Colour Handler
    function HandleColours()
        for _, v in pairs(iconColourTable) do
            v:SetColor(Color(100,100,100));
        end

        for _, v in ipairs(plyData) do
            if iconColourTable[v] then
                iconColourTable[v]:SetColor(Color(255,255,255));
            end
        end
    end
    HandleColours();

//--------------------------------SIDEBAR CONTENT----------------------------------\\

    //Sidebar Panel 1 - Skill tree text
    local sb1 = vgui.Create("DPanel", cFrame)
    sb1:Dock(TOP)
    sb1:SetSize(sx, sy * 0.2)
    sb1:InvalidateParent()
    sb1.Paint = function(self,w,h)
        surface.SetDrawColor(15, 15, 15, 200)
        surface.DrawRect(0,0,w,h)

        surface.SetTextColor(208,128,41,255)
        surface.SetFont("GModToolName")
        surface.SetTextPos(w * 0.1,h * 0.15)
        surface.DrawText("AUGMENTS")
    end

    //reset augments button
    local sb1x,sb1y = sb1:GetSize()
    local hate = vgui.Create("DButton",sb1)
    hate:SetPos(sb1x * 0.2, sb1y * 0.6)
    hate:SetSize(sb1x * 0.62,sb1y * 0.3)
    hate:SetText("")
    hate.Paint = function(self,w,h)
        draw.SimpleText( "RESET AUGMENTS - 100k credits", "GModToolHelp", w / 2,h / 2, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

        surface.SetDrawColor(208,128,41,255)
        surface.DrawOutlinedRect(0,0,w,h)
    end
    hate.DoClick = function()
        sFrame:Close()

        //open are you sure menu
        local ays = vgui.Create("DFrame")
        ays:SetSize(ScrW() * 0.3, ScrH() * 0.3)
        ays:Center()
        ays:MakePopup()
        ays:SetTitle("")
        ays:NoClipping(true)
        ays:SetDraggable(false)
        ays.Paint = function(self, w, h)
            surface.SetDrawColor(Color(38, 38, 38, 250))
            surface.DrawRect(0,0,w,h)

            draw.SimpleText( "ARE YOU SURE?", "GModToolName", w / 2,h * 0.1, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
            draw.SimpleText( "Resetting your augments will cost 100,000 credits and will refund all augments.", "GModToolHelp", w / 2,h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_TOP )
        end

        local aysx,aysy = ays:GetSize()

        local yes = vgui.Create("DButton",ays)
        yes:SetSize(aysx * 0.3, aysy * 0.2)
        yes:SetPos(aysx * 0.15, aysy * 0.7)
        yes:SetText("")
        yes.Paint = function(self,w,h)
            draw.SimpleText( "YES", "GModToolHelp", w / 2,h / 2, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(208,128,41,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        yes.DoClick = function()
            net.Start("VANILLAAUGMENTS_net_ResetTree")
            net.SendToServer()
            ays:Close()
        end

        local no = vgui.Create("DButton",ays)
        no:SetSize(aysx * 0.3, aysy * 0.2)
        no:SetPos(aysx * 0.55, aysy * 0.7)
        no:SetText("")
        no.Paint = function(self,w,h)
            draw.SimpleText( "NO", "GModToolHelp", w / 2,h / 2, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(208,128,41,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
        no.DoClick = function()
            ays:Close()
        end

    end


    //Sidebar Panel 2 - Skill information

    local sb2 = vgui.Create("DPanel", cFrame)
    sb2:Dock(FILL)
    sb2:DockMargin(0,30,0,30)
    sb2:SetSize(sx, sy * 0.6)

    //MiniPanel
    local mp1 = vgui.Create("DPanel", sb2)
    mp1:SetSize(sx,sy * 0.15)
    mp1:Dock(TOP)

    mp1:InvalidateParent( true )
    local mpx, mpy = mp1:GetSize()

    mp1.Paint = function()
        //Icon
        surface.SetDrawColor(255,255,255)
        surface.SetMaterial(Material(sidebar.Icon))
        surface.DrawTexturedRect(mpx * 0.1,mpy * 0.2,sx * 0.2,sx * 0.2)

        //Skill Name
        surface.SetFont("GModToolSubtitle")
        if string.StartWith(sidebar.Info,"[MYTHIC]") then
            surface.SetTextColor(HSVToColor(  ( CurTime() * 25 ) % 360, 1, 1 ))
        else
            surface.SetTextColor(255,255,255)
        end
        surface.SetTextPos(mpx * 0.35,mpy * 0.2)
        surface.DrawText(sidebar.Name)

        //Tree Name
        surface.SetTextColor(100,100,100)
        surface.SetTextPos(mpx * 0.35,mpy * 0.45)
        surface.DrawText(sidebar.Tree)
    end

    //Skill Description
    local sDesc = vgui.Create("DLabel", sb2)
    sDesc:Dock(TOP)
    sDesc:DockMargin(mpx * 0.1,mpy * 0.2,mpx * 0.1,0)
    sDesc:SetWrap(true)
    sDesc:SetFont("GModToolHelp")
    sDesc:SetAutoStretchVertical(true)

    local skillReq = ""

    sb2.Paint = function(self,w,h)
        surface.SetDrawColor(15, 15, 15, 200)
        surface.DrawRect(0,0,w,h)

        //Skill Requirments Text Generator
        if sidebar.Cost ~= "" then
            if sidebar.Req == "" then
                skillReq = ("Requires: " .. sidebar.Cost .. " points.")
            else
                skillReq = ("Requires: " .. sidebar.Cost .. " points + " .. sidebar.Req .. ".")
            end
        end

        //Skill Requirements
        surface.SetFont("GModToolHelp")
        surface.SetTextColor(textColour)
        surface.SetTextPos(mpx * 0.1,mpy * 1)
        surface.DrawText(skillReq)

        //Skill Description, Again
        if string.StartWith(sidebar.Info,"[MYTHIC]") then
            surface.SetFont("GModToolHelp")
            surface.SetTextPos(mpx * 0.1,mpy * 1.2)
            surface.SetTextColor(208,128,41,255)
            surface.DrawText("[MYTHIC]")
            sDesc:SetText(string.sub(sidebar.Info,9))
        else
            sDesc:SetText(sidebar.Info)
        end
    end

    local sBuy = vgui.Create("DButton", sb2)
    sBuy:SetText("")
    sBuy:SetSize(mpx,mpy * 0.3)
    sBuy:Dock(BOTTOM)
    sBuy:DockMargin(mpx * 0.1,mpy * 0.1,mpx * 0.1,mpy * 0.2)
    sBuy.Paint = function(self,w,h)
        if sidebar.Name ~= "Click on an Augment" and (not table.HasValue(plyData, sidebar.Name)) then
            draw.SimpleText( "PURCHASE", "GModToolHelp", w / 2,h / 2, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(208,128,41,255)
            surface.DrawOutlinedRect(0,0,w,h)
        elseif table.HasValue(plyData, sidebar.Name) then
            draw.SimpleText( "PURCHASED", "GModToolHelp", w / 2,h / 2, Color(208,128,41,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )

            surface.SetDrawColor(208,128,41,255)
            surface.DrawOutlinedRect(0,0,w,h)
        end
    end
    sBuy.DoClick = function()
        if (sidebar.Name ~= "Click on an Augment") and (not table.HasValue(plyData, sidebar.Name)) then
            AttemptToPurchase(sidebar.Name)
        end
    end

    //sidebar Panel 3 - Skill points

    local sb3 = vgui.Create("DPanel", cFrame)
    sb3:Dock(BOTTOM)
    sb3:SetSize(sx, sy * 0.2)
    sb3.Paint = function(self,w,h)
        surface.SetDrawColor(15, 15, 15, 200)
        surface.DrawRect(0,0,w,h)

        draw.SimpleText( "Augment Points: " .. augmentPoints, "GModToolSubtitle", w / 2,h / 2.2, Color(200,200,200,255), TEXT_ALIGN_CENTER,  TEXT_ALIGN_CENTER )
    end
end
net.Receive("VANILLAAUGMENTS_net_OpenSkillMenu", AugmentHUD)

net.Receive("VANILLAAUGMENTS_net_PurchaseSuccess",function()
    plyData = net.ReadTable()
    augmentPoints = plyData.Points
    HandleColours()
    surface.PlaySound("buttons/button9.wav")
end)

//Flashes requirements when purchase failed.
//Atrocious, I know.
net.Receive("VANILLAAUGMENTS_net_PurchaseFailed",function()
    surface.PlaySound( "buttons/combine_button_locked.wav")
    textColour = Color(0,0,0,0)
    timer.Simple(0.35,function()
    textColour = Color(255,255,255,255)
    timer.Simple(0.35,function()
    textColour = Color(0,0,0,0)
    timer.Simple(0.35,function()
    textColour = Color(255,255,255,255)
    end)
    end)
    end)
end)

local augmentsActive = true

surface.CreateFont("vanilla_font_info", {
        font = "Proxima Nova Rg",
        size = ScreenScale(6),
        weight = 800
    })

function DrawAugmentHUD()
    if augmentsActive == true then
        //CURRENT ACTIVE AUGMENTS HUD
        local icx = ScrW() * 0.02
        local padding = icx + (ScrW() * 0.005)

        surface.SetFont("vanilla_font_health");
        local hpOffset = surface.GetTextSize(LocalPlayer():Health());
        surface.SetFont("vanilla_font_hp");
        local maxHpOffset = surface.GetTextSize("/ " .. LocalPlayer():GetMaxHealth());

        local ipx = hpOffset + ScrW() * 0.065 + maxHpOffset;
        local ipy = ScrH() * 0.91;

        local anotherBlankTable = {}
        local activeAugments = util.JSONToTable(LocalPlayer():GetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments",util.TableToJSON(anotherBlankTable)))

        local colour;

        for k, v in pairs(activeAugments) do
            for k1, v1 in pairs(vanillaIGAugmentTree) do
                if v1.Name == v then
                    if string.StartWith(v1.Info,"[MYTHIC]") then
                        colour = ColorAlpha(HSVToColor(  ( CurTime() * 50 ) % 360, 1, 1 ), 100);
                    else
                        colour = Color(0,0,0,100);
                    end

                    _G.vanillaBlurPanel(ipx, ipy, icx, icx, colour);

                    surface.SetDrawColor(255,255,255,255)
                    surface.SetMaterial(Material(v1.Icon))
                    surface.DrawTexturedRect(ipx,ipy,icx,icx)
                    ipx = ipx + padding
                end
            end
        end
    end
end
hook.Add( "HUDPaint", "VANILLAAUGMENTS_hook_DrawAugmentHUD", DrawAugmentHUD)

local wookieMat = Material("vanilla/skillicon/wookiearms.png");
local resentMat = Material("vanilla/skillicon/personalresentment.png");
local auraMat = Material("vanilla/skillicon/inspiringaura.png");
local auraSourceMat = Material("vanilla/skillicon/survivalmythic.png");


local optimizedTable = {};


timer.Create("VANILLAAUGMENTS_timer_OptimizeDrawing", 2, 0, function()
        optimizedTable = player.GetAll();
end)

function CircleOnDaFloor()
    if LocalPlayer():GetNWBool("InspiringAuraSource") == true then
        cam.Start3D2D( LocalPlayer():GetPos(), Angle(0,0,0), 1 )
            surface.DrawCircle(0,0,200,255,255,255,15)
        cam.End3D2D()
    end

    for _, v in ipairs(optimizedTable) do
        if not IsValid(v) then return end;
        local vecPos = v:GetPos();
        local vecAng = LocalPlayer():EyeAngles();

        vecAng = Angle( 0, vecAng.y, 0 );
        vecAng:RotateAroundAxis( vecAng:Up(), -90 );

        local resentmentTable = util.JSONToTable(v:GetNWString("ResentmentSource","[]"));
        if (LocalPlayer():GetPos():Distance(vecPos) > 1000) then return end

        cam.Start3D2D(vecPos, vecAng, .25);

        if v:GetNWBool("WookieArmsTarget",false) then
            surface.SetDrawColor(255,255,255, 15);
            surface.SetMaterial(wookieMat);
            surface.DrawTexturedRect(-32,-32,64,64);
        end

        --if table.HasValue(resentmentTable, LocalPlayer():Nick()) then
        --    surface.SetDrawColor(255,255,255,15);
        --    surface.SetMaterial(resentMat);
        --    surface.DrawTexturedRect(-32,-32,64,64);
        --end

        if v:GetNWBool("InspiringAuraSource", false) and not v:GetNWBool("CamoEnabled", false) then
            surface.SetDrawColor(255,255,255,15);
            surface.SetMaterial(auraSourceMat);
            surface.DrawTexturedRectRotated( 0,0,64,64, (CurTime() % 360) * 25 );
            
            surface.SetDrawColor(255,255,255,15);
            surface.SetMaterial(auraMat);
            surface.DrawTexturedRect(-32,-32,64,64);
        end

        cam.End3D2D();
    end
end
hook.Add( "PostDrawOpaqueRenderables", "VANILLAAUGMENTS_hook_DrawInspiringAura", CircleOnDaFloor)

//SOUND EFFECTS!
local sounds = {
    "vanilla/eventhorizon.ogg",
    "vanilla/laststand.ogg",
    "vanilla/debtcollector2.ogg",
    "vanilla/unstoppableadvance.ogg",
    "vanilla/logisticsprime.ogg"
}
local texts = {
    "You've become numb to the pain...",
    "You're weapon is begging you to murder them...",
    "",
    "For the empire.",
    "You have received your weapon."
}

net.Receive("VANILLAAUGMENTS_net_PlaySound",function()
    local int = net.ReadInt(4);

    if int == 4 then
        if math.random(1000) <= 10 then
    		surface.PlaySound(sounds[int]);
		end
	else
		surface.PlaySound(sounds[int]);
	end

    if texts[int] == "" then return end

    chat.AddText(Color(255,255,255),"[",Color(244,187,255),"MYTHIC",Color(255,255,255),"] ",texts[int]);
end)

local haloColour = Color( 255, 125, 0, 100 );
local haloColour2 = Color( 255, 0, 0, 100 );

hook.Add( "PreDrawHalos", "VANILLAAUGMENTS_hook_PreDrawHalos", function()
        
    --local balls = {};
    --local sweatyBalls = {};

    --for _, v in ipairs(optimizedTable) do
    --    if not v:IsValid() then return end
    --    if (LocalPlayer():GetPos():Distance(v:GetPos()) > 1000) then return end
            
    --    if v:GetNWBool("WookieArmsTarget",false) then
    --        balls[#balls + 1] = v;
    --    end

    --    local cumTable = util.JSONToTable(v:GetNWString("ResentmentSource", "[]"));

    --    if table.HasValue(cumTable, LocalPlayer():Nick()) then
    --        sweatyBalls[#sweatyBalls + 1] = v;
    --    end
    --end

    --halo.Add( balls, haloColour, 5, 5, 2, true, false );
    --halo.Add( sweatyBalls, haloColour2, 5, 5, 2, true, false );
end )
