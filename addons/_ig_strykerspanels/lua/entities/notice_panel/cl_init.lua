include("shared.lua")
local size = -1900 / 2

function math.inrange(val, min, max)
    return val <= max and val >= min
end

local arrow_icon = Material("materials/shared/arrow.png")
local implogo_icon = Material("materials/shared/implogo.png")
local iglogo_icon = Material("materials/shared/igicon.png")
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

surface.CreateFont("NOTICE:Title", {
    font = "Roboto",
    size = 100
})

IGNOTICES = {}
IGNOTICES.notice1title = ""
IGNOTICES.notice1 = ""
IGNOTICES.notice12 = ""
IGNOTICES.notice13 = ""
IGNOTICES.notice14 = ""
IGNOTICES.notice2title = ""
IGNOTICES.notice2 = ""
IGNOTICES.notice22 = ""
IGNOTICES.notice23 = ""
IGNOTICES.notice24 = ""
IGNOTICES.notice3title = ""
IGNOTICES.notice3 = ""
IGNOTICES.notice32 = ""
IGNOTICES.notice33 = ""
IGNOTICES.notice34 = ""
IGNOTICES.notice4title = ""
IGNOTICES.notice4 = ""
IGNOTICES.notice42 = ""
IGNOTICES.notice43 = ""
IGNOTICES.notice44 = ""
IGNOTICES.notice5title = ""
IGNOTICES.notice5 = ""
IGNOTICES.notice52 = ""
IGNOTICES.notice53 = ""
IGNOTICES.notice54 = ""
IGNOTICES.notice6title = ""
IGNOTICES.notice6 = ""
IGNOTICES.notice62 = ""
IGNOTICES.notice63 = ""
IGNOTICES.notice64 = ""
IGNOTICES.notice7title = ""
IGNOTICES.notice7 = ""
IGNOTICES.notice72 = ""
IGNOTICES.notice73 = ""
IGNOTICES.notice74 = ""
IGNOTICES.notice8title = ""
IGNOTICES.notice8 = ""
IGNOTICES.notice82 = ""
IGNOTICES.notice83 = ""
IGNOTICES.notice84 = ""
IGNOTICES.notice9title = ""
IGNOTICES.notice9 = ""
IGNOTICES.notice92 = ""
IGNOTICES.notice93 = ""
IGNOTICES.notice94 = ""
IGNOTICES.notice10title = ""
IGNOTICES.notice10 = ""
IGNOTICES.notice102 = ""
IGNOTICES.notice103 = ""
IGNOTICES.notice104 = ""

net.Receive("broadcastnoticeboard", function()
    local size = net.ReadUInt(32)
    local part = util.JSONToTable(util.Decompress(net.ReadData(size)))
    IGNOTICES = table.Copy(part)
end)

function ENT:Draw()
    self:DrawModel()
    if not self.textnotice then return end
	local trace = LocalPlayer():GetEyeTrace()
	if not trace.Entity == self then return end

	local cursor = self:WorldToLocal(trace.HitPos) * Vector(10, 10, 10)
    local pos = self:LocalToWorld(Vector(0, 0, 2.5))
    local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
    --[[Change the distance at which clients will render the panel]]
    --
    if LocalPlayer():GetPos():Distance(self:GetPos()) >= 500 then return end
	
    cam.Start3D2D(pos, ang, 0.1)
    draw.RoundedBox(0, -2370 / 2, -1900 / 2, 2370, 100, self.hcolor)
    draw.RoundedBox(0, -2370 / 2, -1700 / 2, 2370, 1800, self.bcolor)
    cam.End3D2D()
	
    cam.Start3D2D(pos, ang, 0.1)
    draw.SimpleText("Imperial Gaming Noticeboard", "FORMATION:Title", 0, size + 60, self.htextcolor, 1, 1)
	draw.RoundedBox(0, -1135, -805 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, -1135, -455 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, -1135, -105 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, -1135, 245 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, -1135, 595 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, -1130, -695 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, -1130, -345 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, -1130, 5 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, -1130, 355 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, -1130, 705 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, -1130, -800 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, -1130, -450 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, -1130, -100 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, -1130, 250 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, -1130, 600 , 1100, 100, self.noticeheader)
	draw.DrawText(IGNOTICES.notice1title, "NOTICE:Title", -582, -800, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice1, "FORMATION:Main", -1100, -695, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice12, "FORMATION:Main", -1100, -645, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice13, "FORMATION:Main", -1100, -595, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice14, "FORMATION:Main", -1100, -545, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice3title, "NOTICE:Title", -582, -450, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice3, "FORMATION:Main", -1100, -345, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice32, "FORMATION:Main", -1100, -295, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice33, "FORMATION:Main", -1100, -245, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice34, "FORMATION:Main", -1100, -195, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice5title, "NOTICE:Title", -582, -100, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice5, "FORMATION:Main", -1100, 5, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice52, "FORMATION:Main", -1100, 55, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice53, "FORMATION:Main", -1100, 105, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice54, "FORMATION:Main", -1100, 155, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice7title, "NOTICE:Title", -582, 250, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice7, "FORMATION:Main", -1100, 355, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice72, "FORMATION:Main", -1100, 405, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice73, "FORMATION:Main", -1100, 455, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice74, "FORMATION:Main", -1100, 505, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice9title, "NOTICE:Title", -582, 600, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice9, "FORMATION:Main", -1100, 705, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice92, "FORMATION:Main", -1100, 755, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice93, "FORMATION:Main", -1100, 805, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice94, "FORMATION:Main", -1100, 855, self.textnotice, 0, 2) 
	cam.End3D2D()
	
	cam.Start3D2D(pos, ang, 0.1)
	draw.RoundedBox(0, 25, -805 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, 25, -455 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, 25, -105 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, 25, 245 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, 25, 595 , 1110, 315, self.noticeborder)
	draw.RoundedBox(0, 30, -695 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, 30, -345 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, 30, 5 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, 30, 355 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, 30, 705 , 1100, 200, self.noticeback)
	draw.RoundedBox(0, 30, -800 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, 30, -450 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, 30, -100 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, 30, 250 , 1100, 100, self.noticeheader)
	draw.RoundedBox(0, 30, 600 , 1100, 100, self.noticeheader)
	
	draw.DrawText(IGNOTICES.notice2title, "NOTICE:Title", 582, -800, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice2, "FORMATION:Main", 60, -695, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice22, "FORMATION:Main", 60, -645, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice23, "FORMATION:Main", 60, -595, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice24, "FORMATION:Main", 60, -545, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice4title, "NOTICE:Title", 582, -450, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice4, "FORMATION:Main", 60, -345, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice42, "FORMATION:Main", 60, -295, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice43, "FORMATION:Main", 60, -245, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice44, "FORMATION:Main", 60, -195, self.textnotice, 0, 2) 
	
	draw.DrawText(IGNOTICES.notice6title, "NOTICE:Title", 582, -100, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice6, "FORMATION:Main", 60, 5, self.textnotice, 0, 2) 
	draw.DrawText(IGNOTICES.notice62, "FORMATION:Main", 60, 55, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice63, "FORMATION:Main", 60, 105, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice64, "FORMATION:Main", 60, 155, self.textnotice, 0, 2)
	
	draw.DrawText(IGNOTICES.notice8title, "NOTICE:Title", 582, 250, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice8, "FORMATION:Main", 60, 355, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice82, "FORMATION:Main", 60, 405, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice83, "FORMATION:Main", 60, 455, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice84, "FORMATION:Main", 60, 505, self.textnotice, 0, 2)
	
	draw.DrawText(IGNOTICES.notice10title, "NOTICE:Title", 582, 600, self.textnotice, 1) 
	draw.DrawText(IGNOTICES.notice10, "FORMATION:Main", 60, 705, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice102, "FORMATION:Main", 60, 755, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice103, "FORMATION:Main", 60, 805, self.textnotice, 0, 2)
	draw.DrawText(IGNOTICES.notice104, "FORMATION:Main", 60, 855, self.textnotice, 0, 2)	
	cam.End3D2D()
	
	
	cam.Start3D2D(pos, ang, 0.1)
	if LocalPlayer():IsSuperAdmin() then 
	draw.SimpleText("SuperAdmin Only", "FORMATION:Hint", 800, -930, self.hinttext, 1, 1) 
	draw.SimpleText("'!notice' to edit/add Notices", "FORMATION:Hint", 800, -880, self.hinttext, 1, 1)
	end
	cam.End3D2D()
	
    cam.Start3D2D(pos, ang, 0.1)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.SetMaterial(implogo_icon)
        surface.DrawTexturedRectRotated(size + -180, -size - 1850, 85, 85, 0)
		draw.RoundedBox(25, 1091, -940 , 80, 80, self.noticeborder)
        surface.SetDrawColor(Color(255, 255, 255))
        surface.SetMaterial(iglogo_icon)
        surface.DrawTexturedRectRotated(size + 2080, -size - 1850, 85, 85, 0)
    cam.End3D2D()
end