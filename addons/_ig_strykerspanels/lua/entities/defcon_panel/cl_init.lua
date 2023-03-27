include("shared.lua")

local size = -950 / 2

function math.inrange(val, min, max)
    return val <= max and val >= min
end

local arrow_icon = Material("materials/shared/arrow.png")
local implogo_icon = Material("materials/shared/implogo.png")
local replogo_icon = Material("materials/shared/replogo.png")
local security_icon = Material("materials/shared/security.png")
local impsecurity_icon = Material("materials/shared/impsecurity.png")

surface.CreateFont("FORMATION:Main", {
	font = "Roboto",
	size = 50
})

surface.CreateFont("FORMATION:Title", {
	font = "Roboto",
	size = 80
})

function ENT:Initialize()
	self.x = 0
	self.lx = 0
	self.t = 0

	self.min = 0
	self.max = 0

	self.tpage = self:GetPage()

	self:Work()
end

function ENT:Work()
	self.t = !self.t

	if self.t then 
		self.x = self.min
	else
		self.x = self.max
	end

	timer.Simple(1, function()
		if not IsValid(self) then return end
		self:Work()
	end)
end

function ENT:OnPage()
	if self.tpage == 3 then 
		self.x = -25
		self.lx = -25
		return
	end
	
	self.x = 0
	self.lx = 0
end

function ENT:Think()
	if self:GetPage() != self.tpage then 
		self.tpage = self:GetPage()

		self:OnPage()
	end
end

function ENT:Page(number)
if number == 1 then 
		draw.SimpleText("Alert Condition Information", "FORMATION:Title", 0, size + 50, self.htextcolor, 1, 1)
		--[[Defcon Colored Squares]]
		--draw.RoundedBox(15, -800, -350, 115, 115, self.def5color)
		--draw.RoundedBox(15, -800, -220, 115, 115, self.def4color)
		--draw.RoundedBox(15, -800, -90, 115, 115, self.def3color)
		--draw.RoundedBox(15, -800, 40, 115, 115, self.def2color)
		--draw.RoundedBox(15, -800, 170, 115, 115, self.def1color)
		--[[Defcon Numerical Values]]
		--draw.SimpleText("5", "FORMATION:Title", -745, -290, self.deftextcolor, 1, 1)
		--draw.SimpleText("4", "FORMATION:Title", -745, -160, self.deftextcolor, 1, 1)
		--draw.SimpleText("3", "FORMATION:Title", -745, -30, self.deftextcolor, 1, 1)
		--draw.SimpleText("2", "FORMATION:Title", -745, 100, self.deftextcolor, 1, 1)
		--draw.SimpleText("1", "FORMATION:Title", -745, 230, self.deftextcolor, 1, 1)
        --[[Defcon Colored Squares Bigger]]
		draw.RoundedBox(15, -900, -350, 305, 80, self.def1color)
		draw.RoundedBox(15, -900, -250, 305, 80, self.def3color)
		draw.RoundedBox(15, -900, -150, 305, 80, self.def4color)
		draw.RoundedBox(15, -900, -50, 305, 80, self.def1color)
		draw.RoundedBox(15, -900, 50, 305, 80, self.def1color)
		draw.RoundedBox(15, -900, 150, 305, 80, self.def2color)
        draw.RoundedBox(15, -900, 250, 305, 80, self.def2color)
        draw.RoundedBox(15, -900, 350, 305, 80, self.def3color)
		--[[Defcon Names]]
		draw.SimpleText("Battle Stations", "FORMATION:Main", -745, -310, self.deftextcolor, 1, 1)
		draw.SimpleText("Standby Alert", "FORMATION:Main", -745, -210, self.deftextcolor, 1, 1)
		draw.SimpleText("Regular Duties", "FORMATION:Main", -745, -110, self.deftextcolor, 1, 1)
		draw.SimpleText("Protocol 13", "FORMATION:Main", -745, -10, self.deftextcolor, 1, 1)
		draw.SimpleText("Evacuation", "FORMATION:Main", -745, 90, self.deftextcolor, 1, 1)
        draw.SimpleText("Full Lockdown", "FORMATION:Main", -745, 190, self.deftextcolor, 1, 1)
        draw.SimpleText("Intruder Alert", "FORMATION:Main", -745, 290, self.deftextcolor, 1, 1)
        draw.SimpleText("Hazard Alarm", "FORMATION:Main", -745, 390, self.deftextcolor, 1, 1)
		--[[Defcon Basic Outline]]
		draw.SimpleText("The Alert Conditions are in place to shorten response time and", "FORMATION:Main", 0, -300, self.textcolor, 1, 1)
		draw.SimpleText("mitigate panic in emergency situations. Each condition", "FORMATION:Main", 0, -250, self.textcolor, 1, 1)
		draw.SimpleText("outlines a specific response from Troopers, Command and Navy", "FORMATION:Main", 0, -200, self.textcolor, 1, 1)
		--[[Defcon Panel Information]]
		draw.SimpleText("Each page will focus primarily on one each of the conditions", "FORMATION:Main", 0, -50, self.textcolor, 1, 1)
        draw.SimpleText("and elaborate on its purpose. On the bottom right you", "FORMATION:Main", 0, 0, self.textcolor, 1, 1)
		draw.SimpleText("will notice the current alert condition displayed.", "FORMATION:Main", 0, 50, self.textcolor, 1, 1)
		--[[How to change page 101]]
		draw.SimpleText("Press E [USE] On Arrows to change page", "FORMATION:Main", 0, 350, self.hinttext, 1, 1)
		if self.era == true then 
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(security_icon)
		surface.DrawTexturedRectRotated(size + 1200, -size - 470, 392, 804, 0)
		elseif self.era == false then
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(impsecurity_icon)
		surface.DrawTexturedRectRotated(size + 1200, -size - 470, 392, 804, 0)
		end
		end
		
	if number == 2 then 
		draw.SimpleText("General Alerts", "FORMATION:Title", 0, size + 50, self.htextcolor, 1, 1)
        --[[Defcon 5 Information]]
		draw.SimpleText("Regular Duties", "FORMATION:Main", 0, -350, self.def4color, 1, 1)
		draw.SimpleText("'All Clear' alert, returning crews to their normal, day-to-day non-combat duties.", "FORMATION:Main", 0, -300, self.textcolor, 1, 1)	
		draw.SimpleText("All personnel are to have their weapons holstered and perform regular operations.", "FORMATION:Main", 0, -250, self.textcolor, 1, 1)
        --[[Defcon 5 Information]]
        draw.SimpleText("Standby Alert", "FORMATION:Main", 0, -150, self.def3color, 1, 1)
		draw.SimpleText("Threat is probable, but not present. Crew readiness is somewhat more relaxed than full readiness.", "FORMATION:Main", 0, -100, self.textcolor, 1, 1)	
		draw.SimpleText("Personnel maintain standard duty operations but are ready", "FORMATION:Main", 0, -50, self.textcolor, 1, 1)
        draw.SimpleText("to report to action stations at a moments notice.", "FORMATION:Main", 0, 0, self.textcolor, 1, 1)
        draw.SimpleText("Some personel especially Naval officers may be called on during standby alert.", "FORMATION:Main", 0, 50, self.textcolor, 1, 1)
        --[[Defcon 5 Information]]
        draw.SimpleText("Battle Stations", "FORMATION:Main", 0, 150, self.def1color, 1, 1)
        draw.SimpleText("Attack is present, or imminent. This alert places the ship, base or installation", "FORMATION:Main", 0, 200, self.textcolor, 1, 1)
        draw.SimpleText("at its highest state of readiness. All crews go to their combat posts.", "FORMATION:Main", 0, 250, self.textcolor, 1, 1)
        
        
	end
        
    if number == 3 then 
		draw.SimpleText("Evacuation Alerts", "FORMATION:Title", 0, size + 50, self.htextcolor, 1, 1)
        --[[Defcon 5 Information]]
		draw.SimpleText("Protocol 13", "FORMATION:Main", 0, -350, self.def1color, 1, 1)
        draw.SimpleText("All Imperial Forces are to withdraw from an Imperial occupied planet,", "FORMATION:Main", 0, -300, self.textcolor, 1, 1)
		draw.SimpleText("they are required to head immediately to their nearest rally point", "FORMATION:Main", -600, -250, self.textcolor, 0, 1)
		draw.SimpleText("to prepare for a full planetary withdrawful. Follow scuttle procedures as directed.", "FORMATION:Main", -700, -200, self.textcolor, 0, 1)
        --[[Defcon 5 Information]]
     	draw.SimpleText("Evacuation", "FORMATION:Main", 0, -100, self.def1color, 1, 1)
        draw.SimpleText("Abandon ship, base or installation as directed.", "FORMATION:Main", 0, -50, self.textcolor, 1, 1)
		draw.SimpleText("Report to your nearest hangar bay or evacuation site for immediate departure.", "FORMATION:Main", 0, 0, self.textcolor, 1, 1)	
		draw.SimpleText("Follow scuttle procedures as directed.", "FORMATION:Main", 0, 50, self.textcolor, 1, 1)
	end
   
	if number == 4 then 
		draw.SimpleText("Miscellaneous Alerts", "FORMATION:Title", 0, size + 50, self.htextcolor, 1, 1)
		--[[Defcon 3 Information]]
        draw.SimpleText("Full Lockdown", "FORMATION:Main", 0, -350, self.def2color, 1, 1)
		draw.SimpleText("Blastdoors are sealed to restrict movement and key areas secured.", "FORMATION:Main", 0, -300, self.textcolor, 1, 1)
		draw.SimpleText("Personnel are to move to designated critical areas and exits to secure them.", "FORMATION:Main", 0, -250, self.textcolor, 1, 1)	
		draw.SimpleText("Nobody is permitted on or off the installation, facility or ship during lockdown.", "FORMATION:Main", 0, -200, self.textcolor, 1, 1)
        --[[Defcon 3 Information]]
        draw.SimpleText("Intruder Alert", "FORMATION:Main", 0, -100, self.def2color, 1, 1)
		draw.SimpleText("Possible intruder has been identified or is suspected as present. Be alert for suspicious activity.", "FORMATION:Main", 0, -50, self.textcolor, 1, 1)
		draw.SimpleText("Personnel are to conduct search procedures and locate and detain any intruders.", "FORMATION:Main", 0, 0, self.textcolor, 1, 1)	
		draw.SimpleText("Prepare to receive instruction from Command for search operations.", "FORMATION:Main", 0, 50, self.textcolor, 1, 1)
        --[[Defcon 3 Information]]
        draw.SimpleText("Hazard Alarm", "FORMATION:Main", 0, 150, self.def3color, 1, 1)
		draw.SimpleText("A radiological, biological hazard or inanimate threat such as a fire has been detected.", "FORMATION:Main", 0, 200, self.textcolor, 1, 1)
		draw.SimpleText("Personnel are to maintain standard duty operations if safe to do so", "FORMATION:Main", 0, 250, self.textcolor, 1, 1)	
		draw.SimpleText("and report and dangers identified but are ready to receive instructions.", "FORMATION:Main", 0, 300, self.textcolor, 1, 1)
	end
    end

function ENT:Draw()
	self:DrawModel()

	local trace = LocalPlayer():GetEyeTrace()
	if not trace.Entity == self then return end

	local cursor = self:WorldToLocal(trace.HitPos) * Vector(10, 10, 10)

	local pos = self:LocalToWorld(Vector(0, 0, 2.5))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 0))
	--[[Change the distance at which clients will render the panel]]--
	if LocalPlayer():GetPos():Distance(self:GetPos()) >= 500 then return end 

	cam.Start3D2D(pos, ang, 0.1)
		draw.RoundedBox(0, -1900 / 2, -950 / 2, 1900, 100, self.hcolor)
		draw.RoundedBox(0, -1900 / 2, -770 / 2, 1900, 860, self.bcolor)

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

	if math.inrange(cursor.y, size , size + 64 + 64) and math.inrange(cursor.x, -size - 64 - 64, -size) then 
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

		draw.SimpleText("Page ".. self:GetPage().. " of ".. self:GetMax(), "FORMATION:Main", 0, -size - 64, self.pagenum, 1, 1)

		self:Page(self:GetPage())
		
		

	cam.End3D2D()
	
cam.Start3D2D(pos, ang, 0.1)
if self.era == true then 
		surface.SetDrawColor(Color(255, 255, 255))
		surface.SetMaterial(replogo_icon)
		surface.DrawTexturedRectRotated(size + -420, -size - 905, 85, 85, 0)
	elseif self.era == false then
	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial(implogo_icon)
	surface.DrawTexturedRectRotated(size + -420, -size - 905, 85, 85, 0)
	end
cam.End3D2D()

end 