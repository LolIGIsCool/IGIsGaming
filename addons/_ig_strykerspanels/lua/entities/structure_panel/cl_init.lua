include("shared.lua")
local size = -1450 / 2

function math.inrange(val, min, max)
    return val <= max and val >= min
end

local arrow_icon = Material("materials/shared/arrow.png")
local implogo_icon = Material("materials/shared/implogo.png")

surface.CreateFont("FORMATION:Main", {
    font = "Roboto",
    size = 50
})

surface.CreateFont("FORMATION:Hint", {
    font = "Roboto",
    size = 40
})

surface.CreateFont("FORMATION:Title", {
    font = "Roboto",
    size = 80
})

IGRANKS = {}

net.Receive("broadcastrankboard", function()
    IGRANKS = net.ReadTable()
end)

function ENT:Initialize()
    self.min = 0
    self.max = 0
    self.tpage = self:GetPage()
end

function ENT:Think()
    if self:GetPage() ~= self.tpage then
        self.tpage = self:GetPage()
    end
end

function ENT:Page(number)
    if number == 1 then
		draw.RoundedBox(0, 0, -420, 5, 540, self.connectors)
		draw.RoundedBox(0, 640, -515, 5, 265, self.connectors)
		--draw.RoundedBox(0, 630, -260, 120, 5, self.connectors)
		--draw.RoundedBox(0, 920, -215, 5, 150, self.connectors)


        draw.RoundedBox(0, -220, -600, 440, 90, self.rolecolor)
        draw.RoundedBox(0, -220, -510, 440, 90, self.roleuser)
        draw.SimpleText("Imperial Center", "FORMATION:Rank", 0, -550, self.roletextcolor, 1, 1)
        draw.SimpleText("Coruscant", "FORMATION:Rank", 0, -460, self.roletextcolor, 1, 1)

        draw.RoundedBox(0, 420, -250, 450, 90, self.rolecolor)
        draw.RoundedBox(0, 420, -160, 450, 90, self.roleuser)
        draw.SimpleText("Lord", "FORMATION:Rank", 645, -200, self.roletextcolor, 1, 1)
        draw.SimpleText("Vader", "FORMATION:Rank", 645, -110, self.roletextcolor, 1, 1)

        draw.RoundedBox(0, -550, 0, 1100, 90, self.hcolor)
		
		draw.RoundedBox(0, -670, -515, 5, 325, self.connectors)

        draw.RoundedBox(0, -252.5, -363, 506, 66, self.connectors) 
        draw.RoundedBox(15, -250, -360, 500, 60, self.branch)
        draw.SimpleText("Imperial Military Command", "FORMATION:Main", 0, -330, self.roletextcolor, 1, 1)
        
        draw.RoundedBox(0, -982.5, -363, 666, 66, self.connectors) 
        draw.RoundedBox(15, -980, -360, 660, 60, self.branch)
        draw.SimpleText("Imperial Security Bureau Command", "FORMATION:Main", -650, -330, self.roletextcolor, 1, 1)
        
        draw.RoundedBox(0, 335, -363, 636, 66, self.connectors) 
        draw.RoundedBox(15, 337.5, -360, 630, 60, self.branch)
        draw.SimpleText("Imperial Inquisitorious Command", "FORMATION:Main", 650, -330, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -723, -453, 506, 66, self.connectors)
        --draw.RoundedBox(15, -720, -450, 500, 60, self.branch)
		--draw.SimpleText("Imperial Guard", "FORMATION:Main", -470, -420, self.roletextcolor, 1, 1)

		--draw.RoundedBox(0, -700, -350, 450, 90, self.rolecolor)
        --draw.RoundedBox(0, -700, -260, 450, 90, self.roleuser)
		--draw.SimpleText("Director", "FORMATION:Rank", -475, -300, self.roletextcolor, 1, 1)
        --draw.SimpleText("Orson Krennic", "FORMATION:Rank", -475, -210, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -723, -93, 506, 66, self.connectors)
        --draw.RoundedBox(15, -720, -90, 500, 60, self.branch)
		--draw.SimpleText("Imperial Guard Division", "FORMATION:Main", -470, -60, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, -1150, -350, 410, 90, self.rolecolor)
        --draw.RoundedBox(0, -1150, -260, 410, 90, self.roleuser)
        --draw.SimpleText(IGRANKS.isbrank1, "FORMATION:Rank", -950, -300, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.isbname1, "FORMATION:Rank", -950, -210, self.roletextcolor, 1, 1)
        draw.RoundedBox(0, -875, -250, 410, 90, self.rolecolor)
        draw.RoundedBox(0, -875, -160, 410, 90, self.roleuser)
        draw.SimpleText(IGRANKS.isbrank1, "FORMATION:Rank", -665, -200, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.isbname1, "FORMATION:Rank", -665, -110, self.roletextcolor, 1, 1)

		--draw.RoundedBox(0, 217, -453, 456, 66, self.connectors)
       -- draw.RoundedBox(15, 220, -450, 450, 60, self.branch)
		--draw.SimpleText("Imperial Inquisitorius", "FORMATION:Main", 450, -420, self.roletextcolor, 1, 1)
		
        --draw.RoundedBox(0, 730, -350, 410, 90, self.rolecolor)
        --draw.RoundedBox(0, 730, -260, 410, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.sovprotrank, "FORMATION:Rank", 935, -300, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.sovprotname, "FORMATION:Rank", 935, -210, self.roletextcolor, 1, 1)
		draw.RoundedBox(0, -205, -250, 410, 90, self.rolecolor)
        draw.RoundedBox(0, -205, -160, 410, 90, self.roleuser)
		draw.SimpleText(IGRANKS.sovprotrank, "FORMATION:Rank", 0, -200, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.sovprotname, "FORMATION:Rank", 0, -110, self.roletextcolor, 1, 1)
        
        --draw.RoundedBox(0, 667, -93, 506, 66, self.connectors)
        --draw.RoundedBox(15, 670, -90, 500, 60, self.branch)
		--draw.SimpleText("Inquisitorius Regiments", "FORMATION:Main", 920, -60, self.roletextcolor, 1, 1)
		
        draw.SimpleText("Imperial High Command", "FORMATION:Rank", 0, 50, self.htextcolor, 1, 1)


        -- NHC
        draw.RoundedBox(0, -803, 417, 506, 66, self.connectors)
        draw.RoundedBox(0, -550, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, -550, 380, 5, 40, self.connectors)
        draw.RoundedBox(15, -800, 420, 500, 60, self.branch)
        draw.RoundedBox(0, -750, 200, 400, 90, self.rolecolor)
        draw.RoundedBox(0, -750, 290, 400, 90, self.roleuser)
        draw.SimpleText(IGRANKS.nhcheadrank, "FORMATION:Rank", -550, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.nhcheadname, "FORMATION:Rank", -550, 340, self.roletextcolor, 1, 1)
        draw.SimpleText("Naval Command", "FORMATION:Main", -550, 450, self.roletextcolor, 1, 1)

        -- IA
        draw.RoundedBox(0, -0, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, -0, 380, 5, 40, self.connectors)
        draw.RoundedBox(0, -250, 417, 506, 66, self.connectors) 
        draw.RoundedBox(0, -200, 200, 400, 90, self.rolecolor)
        draw.RoundedBox(0, -200, 290, 400, 90, self.roleuser)
        draw.RoundedBox(15, -247.5, 420, 500, 60, self.branch)
        draw.SimpleText(IGRANKS.administratorrank, "FORMATION:Rank", -0, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.administratorname, "FORMATION:Rank", -0, 340, self.roletextcolor, 1, 1)
        draw.SimpleText("Imperial Administration", "FORMATION:Main", -0, 450, self.roletextcolor, 1, 1)

        -- AHC
        draw.RoundedBox(0, 297, 417, 506, 66, self.connectors) 
        draw.RoundedBox(0, 550, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, 550, 380, 5, 40, self.connectors)
        draw.RoundedBox(0, 350, 200, 400, 90, self.rolecolor) 
        draw.RoundedBox(0, 350, 290, 400, 90, self.roleuser)
        draw.RoundedBox(15, 300, 420, 500, 60, self.branch)
        draw.SimpleText(IGRANKS.ahcheadrank, "FORMATION:Rank", 550, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.ahcheadname, "FORMATION:Rank", 550, 340, self.roletextcolor, 1, 1)
        draw.SimpleText("Army Command", "FORMATION:Main", 550, 450, self.roletextcolor, 1, 1)
        
        draw.RoundedBox(0, 200, -515, 440, 5, self.connectors)
        draw.RoundedBox(0, -665, -515, 650, 5, self.connectors)
        draw.RoundedBox(0, -550, 120, 1100, 5, self.connectors)
        --draw.RoundedBox(0, -800, -260, 120, 5, self.connectors)

        --draw.RoundedBox(0, -650, -600, 400, 90, self.rolecolor)
        --draw.RoundedBox(0, -650, -510, 400, 90, self.roleuser)
        --draw.SimpleText("COMPNOR Director", "FORMATION:Rank", -450, -550, self.roletextcolor, 1, 1)
        --draw.SimpleText("Armand Isard", "FORMATION:Rank", -450, -460, self.roletextcolor, 1, 1)

        --draw.RoundedBox(0, 240, -600, 400, 90, self.rolecolor)
        --draw.RoundedBox(0, 240, -510, 400, 90, self.roleuser)
        --draw.SimpleText("Imperial Enforcer", "FORMATION:Rank", 440, -550, self.roletextcolor, 1, 1)
        --draw.SimpleText("Lord Vader", "FORMATION:Rank", 440, -460, self.roletextcolor, 1, 1)
    end

    if number == 2 then
		draw.RoundedBox(0, 0, -450, 5, 930, self.connectors)
        --draw.RoundedBox(0, -800, -300, 1600, 5, self.connectors)
		--draw.RoundedBox(0, -800, -300, 5, 780, self.connectors)
        --draw.RoundedBox(0, 800, -300, 5, 780, self.connectors)
        draw.RoundedBox(0, -403, -553, 806, 106, self.connectors)
        draw.RoundedBox(15, -400, -550, 800, 100, self.branch)
        draw.SimpleText("Imperial Navy Command", "FORMATION:Title", -0, -500, self.roletextcolor, 1, 1)
        --draw.RoundedBox(0, -1100, -200, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1100, -110, 600, 90, self.roleuser)
        --draw.RoundedBox(0, -1100, -20, 600, 90, self.roleuser)
        --draw.RoundedBox(0, -1100, 130, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1100, 220, 600, 90, self.roleuser)
        draw.RoundedBox(0, -300, -360, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, -270, 600, 90, self.roleuser)
		draw.RoundedBox(0, -300, -70, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, 20, 600, 90, self.roleuser)
		--draw.RoundedBox(0, -300, 220, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -300, 310, 600, 90, self.roleuser)
        --draw.RoundedBox(0, 500, -200, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, 500, -110, 600, 90, self.roleuser)
        --draw.RoundedBox(0, 500, -20, 600, 90, self.roleuser)
        --draw.RoundedBox(0, 500, 130, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, 500, 220, 600, 90, self.roleuser)
        --draw.SimpleText("Navy", "FORMATION:Rank", -800, -150, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.navy1rank, "FORMATION:Rank", -800, -60, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.navy1name, "FORMATION:Rank", -800, 30, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.navy2rank, "FORMATION:Rank", -800, 180, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.navy2name, "FORMATION:Rank", -800, 270, self.roletextcolor, 1, 1)]]
        draw.SimpleText(IGRANKS.navy1rank, "FORMATION:Rank", 0, -310, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.navy1name, "FORMATION:Rank", 0, -220, self.roletextcolor, 1, 1)
		draw.SimpleText(IGRANKS.navy2rank, "FORMATION:Rank", 0, -20, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.navy2name, "FORMATION:Rank", 0, 70, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.navy3rank, "FORMATION:Rank", 0, 270, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.navy3name, "FORMATION:Rank", 0, 360, self.roletextcolor, 1, 1)
        --draw.SimpleText("Imperial Starfighter Corps", "FORMATION:Rank", 800, -150, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.iscrank1, "FORMATION:Rank", 800, -60, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.iscname1, "FORMATION:Rank", 800, 30, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.iscrank2, "FORMATION:Rank", 800, 180, self.roletextcolor, 1, 1)
        --draw.SimpleText(IGRANKS.iscname2, "FORMATION:Rank", 800, 270, self.roletextcolor, 1, 1)
        --draw.RoundedBox(0, -1103, 477, 606, 66, self.connectors)
        draw.RoundedBox(0, -303, 477, 606, 66, self.connectors)
        --draw.RoundedBox(0, 497, 477, 606, 66, self.connectors)
        --draw.RoundedBox(15, -1100, 480, 600, 60, self.branch)
        draw.RoundedBox(15, -300, 480, 600, 60, self.branch)
        --draw.RoundedBox(15, 500, 480, 600, 60, self.branch)
        --draw.SimpleText("Navy", "FORMATION:Main", -800, 510, self.roletextcolor, 1, 1)
        draw.SimpleText("Navy Associated Regiments", "FORMATION:Main", 0, 510, self.roletextcolor, 1, 1)
        --draw.SimpleText("Imperial Starfighter Corps", "FORMATION:Main", 800, 510, self.roletextcolor, 1, 1)
    end

    if number == 3 then 
		draw.RoundedBox(0, 0, -450, 5, 570, self.connectors)
		--draw.RoundedBox(0, 700, -180, 5, 300, self.connectors)
		--draw.RoundedBox(0, -700, -180, 5, 300, self.connectors)
		--draw.RoundedBox(0, -700, -180, 1400, 5, self.connectors)
		
		draw.RoundedBox(0, -403, -553, 806, 106, self.connectors)
        draw.RoundedBox(15, -400, -550, 800, 100, self.branch)
        draw.SimpleText("Imperial Army Command", "FORMATION:Title", -0, -500, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -300, -400, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, -310, 600, 90, self.roleuser)
		
		--draw.RoundedBox(0, -300, 140, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -300, 230, 600, 90, self.roleuser)
        
        --draw.RoundedBox(0, -300, -130, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -300, -40, 600, 90, self.roleuser)
		
        --draw.RoundedBox(0, -1000, -130, 600, 90, self.rolecolor)
		--draw.RoundedBox(0, -1000, -40, 600, 90, self.roleuser)
		
		--draw.RoundedBox(0, 400, -130, 600, 90, self.rolecolor)
		--draw.RoundedBox(0, 400, -40, 600, 90, self.roleuser)
		
		--draw.RoundedBox(0, -1000, 140, 600, 90, self.rolecolor)
		--draw.RoundedBox(0, -1000, 230, 600, 90, self.roleuser)
		
		--draw.RoundedBox(0, 400, 140, 600, 90, self.rolecolor)
		--draw.RoundedBox(0, 400, 230, 600, 90, self.roleuser)
		
		draw.SimpleText(IGRANKS.general1rank, "FORMATION:Rank", 0, -350, self.roletextcolor, 1, 1)
		draw.SimpleText(IGRANKS.general1name, "FORMATION:Rank", 0, -270, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general2rank, "FORMATION:Rank", -700, -80, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general2name, "FORMATION:Rank", -700, 0, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general3rank, "FORMATION:Rank", 0, -80, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general3name, "FORMATION:Rank", 0, 0, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general4rank, "FORMATION:Rank", 700, -80, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general4name, "FORMATION:Rank", 700, 0, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general5rank, "FORMATION:Rank", -700, 190, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general5name, "FORMATION:Rank", -700, 270, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general6rank, "FORMATION:Rank", 0, 190, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general6name, "FORMATION:Rank", 0, 270, self.roletextcolor, 1, 1)
		
		--draw.SimpleText(IGRANKS.general7rank, "FORMATION:Rank", 700, 190, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.general7name, "FORMATION:Rank", 700, 270, self.roletextcolor, 1, 1)

		draw.RoundedBox(0, -1000, 200, 400, 90, self.rolecolor)
        draw.RoundedBox(0, -1000, 290, 400, 90, self.roleuser)
        draw.RoundedBox(0, -470, 200, 400, 90, self.rolecolor)
        draw.RoundedBox(0, -470, 290, 400, 90, self.roleuser)
        draw.RoundedBox(0, 50, 200, 450, 90, self.rolecolor)
        draw.RoundedBox(0, 50, 290, 450, 90, self.roleuser)
        draw.RoundedBox(0, 600, 200, 400, 90, self.rolecolor)
        draw.RoundedBox(0, 600, 290, 400, 90, self.roleuser)
        draw.RoundedBox(0, -1053, 417, 506, 66, self.connectors)
        draw.RoundedBox(0, -523, 417, 506, 66, self.connectors)
        draw.RoundedBox(0, 22, 417, 506, 66, self.connectors)
        draw.RoundedBox(0, 547, 417, 506, 66, self.connectors)
        draw.RoundedBox(15, -1050, 420, 500, 60, self.branch)
        draw.RoundedBox(15, -520, 420, 500, 60, self.branch)
        draw.RoundedBox(15, 25, 420, 500, 60, self.branch)
        draw.RoundedBox(15, 550, 420, 500, 60, self.branch)
        
        -- Battalion CO Names --
        draw.SimpleText(IGRANKS.battalionco439th, "FORMATION:Rank", -800, 340, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco275th, "FORMATION:Rank", -270, 340, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco107th, "FORMATION:Rank", 270, 340, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco501st, "FORMATION:Rank", 800, 340, self.roletextcolor, 1, 1)
        --

        -- Battalion CO Rank Names -- 
        draw.SimpleText(IGRANKS.battalionco501strank, "FORMATION:Rank", 800, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco439thrank, "FORMATION:Rank", -800, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco107thrank, "FORMATION:Rank", 270, 250, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.battalionco275thrank, "FORMATION:Rank", -270, 250, self.roletextcolor, 1, 1)
        -- Battalion CO Rank Names -- 

        -- Battalion Names -- 
        draw.SimpleText("439th Battalion", "FORMATION:Main", -800, 450, self.roletextcolor, 1, 1)
        draw.SimpleText("275th Battalion", "FORMATION:Main", -270, 450, self.roletextcolor, 1, 1)
        draw.SimpleText("107th Battalion", "FORMATION:Main", 270, 450, self.roletextcolor, 1, 1)
        draw.SimpleText("501st Legion", "FORMATION:Main", 800, 450, self.roletextcolor, 1, 1)
        -- Battalion Names -- 

        draw.RoundedBox(0, -800, 120, 1600, 5, self.connectors)
        draw.RoundedBox(0, -800, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, -270, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, 270, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, 800, 120, 5, 80, self.connectors)
        draw.RoundedBox(0, -800, 380, 5, 40, self.connectors)
        draw.RoundedBox(0, -270, 380, 5, 40, self.connectors)
        draw.RoundedBox(0, 270, 380, 5, 40, self.connectors)
        draw.RoundedBox(0, 800, 380, 5, 40, self.connectors)
	end
    if number == 4 then 
		--draw.RoundedBox(0, -750, -503, 1100, 5, self.connectors)
		--draw.RoundedBox(0, -403, -553, 806, 106, self.connectors)

        --draw.RoundedBox(0, -350, -503, 1100, 5, self.connectors)
		--draw.RoundedBox(0, -403, -450, 806, 106, self.connectors)

        --draw.RoundedBox(15, -400, -550, 800, 100, self.branch)
        --draw.SimpleText("COMPNOR Director", "FORMATION:Title", -0, -500, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -750, -503, 5, 1000, self.connectors)
        --draw.RoundedBox(0, 750, -503, 5, 1000, self.connectors)

		--draw.RoundedBox(0, -450, -250, 1200, 5, self.connectors)
		--draw.RoundedBox(0, 0, -450, 5, 350, self.connectors)
        --draw.SimpleText("Director Armand Isard", "FORMATION:Main", -0, -400, self.roletextcolor, 1, 1)

		--draw.RoundedBox(0, -1053, -443, 606, 66, self.connectors)
        --draw.RoundedBox(15, -1050, -440, 600, 60, self.branch)
        --draw.SimpleText("COMPNOR", "FORMATION:Main", -750, -410, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, -1053, 477, 606, 66, self.connectors)
        --draw.RoundedBox(15, -1050, 480, 600, 60, self.branch)
        --draw.SimpleText("ISB Associated Regiments", "FORMATION:Main", -750, 510, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, -1050, -300, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1050, -210, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.isbdirectorrank, "FORMATION:Rank", -750, -250, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.isbdirectorname, "FORMATION:Rank", -750, -160, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -1050, -150, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1050, -60, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.isbadmiralrank, "FORMATION:Rank", -750, -100, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.isbadmiralname, "FORMATION:Rank", -750, -10, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -1050, -50, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1050, 40, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.isbrank1, "FORMATION:Rank", -750, 0, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.isbname1, "FORMATION:Rank", -750, 90, self.roletextcolor, 1, 1)
		--draw.RoundedBox(0, -1050, 210, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -1050, 300, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.isbrank2, "FORMATION:Rank", -750, 260, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.isbname2, "FORMATION:Rank", -750, 350, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, -293, -10, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, -293, 80, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.cfprank, "FORMATION:Rank", 7, 40, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.cfpname, "FORMATION:Rank", 7, 130, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, 447, -50, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, 447, 40, 600, 90, self.roleuser)
		--draw.SimpleText(IGRANKS.IICommanderRank, "FORMATION:Rank", 757, 0, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.IICommanderName, "FORMATION:Rank", 757, 90, self.roletextcolor, 1, 1)
		
		--draw.RoundedBox(0, 447, -403, 606, 66, self.connectors)
        --draw.RoundedBox(15, 450, -400, 600, 60, self.branch)
        --draw.SimpleText("Imperial Intelligence", "FORMATION:Main", 750, -370, self.roletextcolor, 1, 1)
        
        --draw.RoundedBox(0, 447, -300, 600, 90, self.rolecolor)
        --draw.RoundedBox(0, 447, -210, 600, 90, self.roleuser)
        --draw.SimpleText(IGRANKS.IIDirectorRank, "FORMATION:Rank", 757, -250, self.roletextcolor, 1, 1)
		--draw.SimpleText(IGRANKS.IIDirectorName, "FORMATION:Rank", 757, -160, self.roletextcolor, 1, 1)
        
		--draw.RoundedBox(0, 447, 415, 606, 66, self.connectors)
        --draw.RoundedBox(15, 450, 417.5, 600, 60, self.branch)
        --draw.SimpleText("Death Troopers", "FORMATION:Main", 750, 447.5, self.roletextcolor, 1, 1)

		--draw.RoundedBox(0, 447, 477, 606, 66, self.connectors)
        --draw.RoundedBox(15, 450, 480, 600, 60, self.branch)
        --draw.SimpleText("Imperial Intelligence", "FORMATION:Main", 750, 510, self.roletextcolor, 1, 1)


		--draw.RoundedBox(0, -297, -153, 606, 66, self.connectors)
        --draw.RoundedBox(15, -294, -150, 600, 60, self.branch)
        --draw.SimpleText("Coalition for Progress", "FORMATION:Main", 0, -120, self.roletextcolor, 1, 1)
        
        draw.RoundedBox(0, 0, -450, 5, 930, self.connectors)
        draw.RoundedBox(0, -543, -553, 1086, 106, self.connectors)
        draw.RoundedBox(15, -540, -550, 1080, 100, self.branch)
        draw.SimpleText("Imperial Security Bureau Command", "FORMATION:Title", -0, -500, self.roletextcolor, 1, 1)
        draw.RoundedBox(0, -300, -360, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, -270, 600, 90, self.roleuser)
		draw.RoundedBox(0, -300, -70, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, 20, 600, 90, self.roleuser)
        draw.SimpleText(IGRANKS.isbrank1, "FORMATION:Rank", 0, -310, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.isbname1, "FORMATION:Rank", 0, -220, self.roletextcolor, 1, 1)
		draw.SimpleText(IGRANKS.isbrank2, "FORMATION:Rank", 0, -20, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.isbname2, "FORMATION:Rank", 0, 70, self.roletextcolor, 1, 1)
        draw.RoundedBox(0, -303, 477, 606, 66, self.connectors)
        draw.RoundedBox(15, -300, 480, 600, 60, self.branch)
        draw.SimpleText("ISB Associated Regiments", "FORMATION:Main", 0, 510, self.roletextcolor, 1, 1)

	end
    if number == 5 then 
		draw.RoundedBox(0, -750, -553, 350, 5, self.connectors)
		draw.RoundedBox(0, -750, -553, 5, 253, self.connectors)
		draw.RoundedBox(0, 0, -450, 5, 930, self.connectors)
		draw.RoundedBox(0, -403, -553, 806, 106, self.connectors)
        draw.RoundedBox(15, -400, -550, 800, 100, self.branch)
        draw.SimpleText("Regional Government", "FORMATION:Title", -0, -500, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -1050, -390, 600, 90, self.rolecolor)
		draw.RoundedBox(0, -1050, -300, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -1050, -210, 600, 90, self.roleuser)
		draw.SimpleText("Military Adjunct", "FORMATION:Rank", -750, -330, self.roletextcolor, 1, 1)
		draw.SimpleText(IGRANKS.tarkinadjutantrank, "FORMATION:Rank", -750, -250, self.roletextcolor, 1, 1)
		draw.SimpleText(IGRANKS.tarkinadjutantname, "FORMATION:Rank", -750, -170, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -300, -200, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, -110, 600, 90, self.roleuser)
		draw.SimpleText(IGRANKS.govrank1, "FORMATION:Rank", 0, -150, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.govname1, "FORMATION:Rank", 0, -60, self.roletextcolor, 1, 1)
		draw.RoundedBox(0, -300, 140, 600, 90, self.rolecolor)
        draw.RoundedBox(0, -300, 230, 600, 90, self.roleuser)
		draw.SimpleText(IGRANKS.govrank2, "FORMATION:Rank", 0, 190, self.roletextcolor, 1, 1)
        draw.SimpleText(IGRANKS.govname2, "FORMATION:Rank", 0, 280, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -303, -300, 606, 66, self.connectors)
        draw.RoundedBox(15, -300, -297, 600, 60, self.branch)
		draw.SimpleText("Regional Governors", "FORMATION:Main", 0, -265, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -303, 47, 606, 66, self.connectors)
        draw.RoundedBox(15, -300, 50, 600, 60, self.branch)
		draw.SimpleText("Governors Office", "FORMATION:Main", 0, 80, self.roletextcolor, 1, 1)
		
		draw.RoundedBox(0, -303, 477, 606, 66, self.connectors)
        draw.RoundedBox(15, -300, 480, 600, 60, self.branch)
		draw.SimpleText("Secretary Division", "FORMATION:Main", 0, 510, self.roletextcolor, 1, 1)
	end
end

function ENT:Draw()
    self:DrawModel()

	local trace = LocalPlayer():GetEyeTrace()
	if not trace.Entity == self then return end

	local cursor = self:WorldToLocal(trace.HitPos) * Vector(10, 10, 10)
    local pos = self:LocalToWorld(Vector(0, 0, 2.5))
    local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
    --[[Change the distance at which clients will render the panel]]
    --
    if LocalPlayer():GetPos():Distance(self:GetPos()) >= 500 then return end
    cam.Start3D2D(pos, ang, 0.1)
    draw.RoundedBox(0, -2370 / 2, -1420 / 2, 2370, 100, self.hcolor)
    draw.RoundedBox(0, -2370 / 2, -1240 / 2, 2370, 1330, self.bcolor)

    --[[---------------------------------------------------------
			Name: Arrows
		-----------------------------------------------------------]]
    if math.inrange(cursor.y, -size - 64 - 64, -size) and math.inrange(cursor.x, -size - 64 - 64, -size) then
        surface.SetDrawColor(self.pcolor)
    else
        surface.SetDrawColor(Color(255, 255, 255))
    end

    surface.SetMaterial(arrow_icon)
    surface.DrawTexturedRectRotated(-size - 64, -size - 64, 64, 64, 180)

    if math.inrange(cursor.y, size, size + 64 + 64) and math.inrange(cursor.x, -size - 64 - 64, -size) then
    if self:GetPage() == 1 then 
        surface.SetDrawColor(Color(255, 0, 0)) else
		surface.SetDrawColor(self.pcolor)
	end
		else
	if self:GetPage() == 1 then 
        surface.SetDrawColor(Color(255, 0, 0)) else surface.SetDrawColor(Color(255, 255, 255))
	end
	end
	


    surface.SetMaterial(arrow_icon)
    surface.DrawTexturedRectRotated(size + 64, -size - 64, 64, 64, 0)
    draw.SimpleText("Page " .. self:GetPage() .. " of " .. self:GetMax(), "FORMATION:Main", 0, -size - 64, self.pagenum, 1, 1)
    self:Page(self:GetPage())
    cam.End3D2D()
    cam.Start3D2D(pos, ang, 0.1)
    draw.SimpleText("Empire Command Structure", "FORMATION:Title", 0, size + 60, self.htextcolor, 1, 1)
    draw.SimpleText("Press E [USE] On Arrows to change page", "FORMATION:Main", 0, 600, self.hinttext, 1, 1)
	--draw.SimpleText("'!structure' to open Portable Structure Menu", "FORMATION:Hint", -750, -644, self.hinttext, 1, 1)
    cam.End3D2D()
	
	cam.Start3D2D(pos, ang, 0.1)
	if LocalPlayer():IsSuperAdmin() then 
	draw.SimpleText("SuperAdmin Only", "FORMATION:Hint", 800, -680, self.hinttext, 1, 1) 
	draw.SimpleText("'!structranks' to edit Ranks/Roles", "FORMATION:Hint", 800, -640, self.hinttext, 1, 1)
	end
	cam.End3D2D()
	
    cam.Start3D2D(pos, ang, 0.1)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.SetMaterial(implogo_icon)
        surface.DrawTexturedRectRotated(size + -400, -size - 1390, 85, 85, 0)
    cam.End3D2D()
end