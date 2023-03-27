include("shared.lua")

local size = -1450 / 2

function math.inrange(val, min, max)
    return val <= max and val >= min
end

local arrow_icon = Material("materials/shared/arrow.png")
local implogo_icon = Material("materials/shared/implogo.png")

surface.CreateFont("FORMATION:Main", {
	font = "Roboto",
	size = 45
})

surface.CreateFont("FORMATION:Title", {
	font = "Roboto",
	size = 55
})

surface.CreateFont("FORMATION:Rank", {
	font = "Roboto",
	size = 50
})

surface.CreateFont("FORMATION:Cube", {
	font = "Roboto",
	size = 40
})

function ENT:Initialize()
	self.min = 0
	self.max = 0
	self.tpage = self:GetPage()
end

function ENT:Think()
	if self:GetPage() != self.tpage then 
		self.tpage = self:GetPage()

	end
end

function ENT:Page(number)
if number == 1 then 
		draw.SimpleText("Army Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("High General", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("General", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Lieutenant General", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Major General", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Colonel", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Lieutenant Colonel", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Major", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Captain", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Second Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Chief Warrant Officer", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Warrant Officer", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Warrant Officer", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Warrant Officer", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Sergeant Major", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("First Sergeant", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Sergeant", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Staff Sergeant", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Sergeant", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Sergeant", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Senior Corporal", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
		draw.SimpleText("Corporal", "FORMATION:Rank", 350, 190, self.enlistedtext, 1, 1)
		draw.SimpleText("Junior Corporal", "FORMATION:Rank", 350, 260, self.enlistedtext, 1, 1)
		draw.SimpleText("Lance Corporal", "FORMATION:Rank", 350, 330, self.enlistedtext, 1, 1)
		draw.SimpleText("Private First Class", "FORMATION:Rank", 350, 400, self.enlistedtext, 1, 1)
		draw.SimpleText("Private Second Class", "FORMATION:Rank", 350, 470, self.enlistedtext, 1, 1)
		draw.SimpleText("Private | Trainee", "FORMATION:Rank", 350, 540, self.enlistedtext, 1, 1)
		end
		
	if number == 2 then 
		draw.SimpleText("Naval Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Fleet Admiral", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Admiral", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Vice Admiral", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Rear Admiral", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Commodore", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Captain", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Senior Commander", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Lieutenant Commander", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Ensign", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Midshipman", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Midshipman", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Midshipman", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Acting Midshipman", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Chief Petty Officer", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Petty Officer", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Petty Officer", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Petty Officer", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Petty Officer", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Leading Crewman", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
		draw.SimpleText("Master Crewman", "FORMATION:Rank", 350, 190, self.enlistedtext, 1, 1)
		draw.SimpleText("Senior Crewman", "FORMATION:Rank", 350, 260, self.enlistedtext, 1, 1)
		draw.SimpleText("Able Crewman", "FORMATION:Rank", 350, 330, self.enlistedtext, 1, 1)
		draw.SimpleText("Crewman", "FORMATION:Rank", 350, 400, self.enlistedtext, 1, 1)
		draw.SimpleText("Junior Crewman", "FORMATION:Rank", 350, 470, self.enlistedtext, 1, 1)
		draw.SimpleText("Cadet", "FORMATION:Rank", 350, 540, self.enlistedtext, 1, 1)
	end

	if number == 3 then 
		draw.SimpleText("ISC Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Fleet Admiral", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Admiral", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Vice Admiral", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Rear Admiral", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Flight Commodore", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Flight Captain", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Senior Flight Commander", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Flight Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Lieutenant Flight Commander", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Flight Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Flight Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Flight Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Chief Flight Officer", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Flight Officer", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Flight Officer", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Flight Officer", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Flight Master Chief", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Flight Chief", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Flight Master Sergeant", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Flight Sergeant", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Flight Sergeant", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Flight Sergeant", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Senior Flight Corporal", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
		draw.SimpleText("Flight Corporal", "FORMATION:Rank", 350, 190, self.enlistedtext, 1, 1)
		draw.SimpleText("Junior Flight Corporal", "FORMATION:Rank", 350, 260, self.enlistedtext, 1, 1)
		draw.SimpleText("Flight Lance Corporal", "FORMATION:Rank", 350, 330, self.enlistedtext, 1, 1)
		draw.SimpleText("Senior Flight Specialist", "FORMATION:Rank", 350, 400, self.enlistedtext, 1, 1)
		draw.SimpleText("Flight Specialist", "FORMATION:Rank", 350, 470, self.enlistedtext, 1, 1)
		draw.SimpleText("Flight Cadet", "FORMATION:Rank", 350, 540, self.enlistedtext, 1, 1)
	end
	
	if number == 4 then 
		draw.SimpleText("Engineer Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Fleet Admiral", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Admiral", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Vice Admiral", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Rear Admiral", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Chief Foreman", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Senior Foreman", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Foreman", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Deputy Foreman", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Chief Engineer", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Engineer", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Engineer", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Engineer", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Engineer Apprentice", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Mechanic", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Mechanic", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Mechanic", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Master Chief Technician", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Chief Technician", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Technician", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Technician", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Technician", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Technician", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Leading Workman", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
		draw.SimpleText("Master Workman", "FORMATION:Rank", 350, 190, self.enlistedtext, 1, 1)
		draw.SimpleText("Senior Workman", "FORMATION:Rank", 350, 260, self.enlistedtext, 1, 1)
		draw.SimpleText("Able Workman", "FORMATION:Rank", 350, 330, self.enlistedtext, 1, 1)
		draw.SimpleText("Workman", "FORMATION:Rank", 350, 400, self.enlistedtext, 1, 1)
		draw.SimpleText("Junior Workman", "FORMATION:Rank", 350, 470, self.enlistedtext, 1, 1)
		draw.SimpleText("Apprentice", "FORMATION:Rank", 350, 540, self.enlistedtext, 1, 1)
	end

	if number == 5 then 
		draw.SimpleText("ISB Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Director", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Deputy Director", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Inspector General", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Chief", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Colonel", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Lieutenant Colonel", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Major", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Captain", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Special Agent", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Agent", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Agent", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Agent", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Acting Agent", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Lead Operative", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Operative", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Operative", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Operative", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Operative", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Acting Operative", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)

	end
	
	--if number == 6 then 
	--	draw.SimpleText("Coalition for Progress Ranks", "FORMATION:Title", 0, -460, Color(255, 255, 255), 1, 1)
	--	draw.SimpleText("COMPNOR Director", "FORMATION:Rank", -350, -360, self.commandstaff, 1, 1)
	--	draw.SimpleText("Deputy Director", "FORMATION:Rank", -350, -280, self.snrco2, 1, 1)
	--	draw.SimpleText("Chief Commissioner", "FORMATION:Rank", -350, -200, self.snrco2, 1, 1)
	--	draw.SimpleText("Commissioner", "FORMATION:Rank", -350, -120, self.snrco2, 1, 1)
	--	draw.SimpleText("Bureau Chief", "FORMATION:Rank", -350, -40, self.snrco, 1, 1)
	--	draw.SimpleText("Superintendent", "FORMATION:Rank", -350, 40, self.snrco, 1, 1)
	--	draw.SimpleText("Chief Administrator", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
	--	draw.SimpleText("Administrator", "FORMATION:Rank", -350, 200, self.jnrco, 1, 1)
	--	draw.SimpleText("Administrative Manager", "FORMATION:Rank", -350, 280, self.jnrco, 1, 1)
	--	draw.SimpleText("Administrative Officer", "FORMATION:Rank", -350, 360, self.jnrco, 1, 1)
	--	draw.SimpleText("Sub-Administrator", "FORMATION:Rank", -350, 440, self.snrnco, 1, 1)
	--	draw.SimpleText("Captain", "FORMATION:Rank", -350, 520, self.snrnco, 1, 1)
	--	draw.SimpleText("Community Officer", "FORMATION:Rank", 350, -360, self.snrnco, 1, 1)
	--	draw.SimpleText("Project Officer", "FORMATION:Rank", 350, -280, self.snrnco, 1, 1)
	--	draw.SimpleText("Chief Clerk", "FORMATION:Rank", 350, -200, self.jnrnco, 1, 1)
	--	draw.SimpleText("Clerk", "FORMATION:Rank", 350, -120, self.jnrnco, 1, 1)
	--	draw.SimpleText("Deputy Clerk", "FORMATION:Rank", 350, -40, self.jnrnco, 1, 1)
	--	draw.SimpleText("Leading Assistant", "FORMATION:Rank", 350, 40, self.jnrnco, 1, 1)
	--	draw.SimpleText("Senior Assistant", "FORMATION:Rank", 350, 120, self.jnrnco, 1, 1)
	--	draw.SimpleText("Assistant", "FORMATION:Rank", 350, 200, self.jnrnco, 1, 1)
	--	draw.SimpleText("Senior Member", "FORMATION:Rank", 350, 280, self.enlistedtext, 1, 1)
	--	draw.SimpleText("Member", "FORMATION:Rank", 350, 360, self.enlistedtext, 1, 1)
	--	draw.SimpleText("", "FORMATION:Rank", 350, 440, self.enlistedtext, 1, 1)
	--	draw.SimpleText("", "FORMATION:Rank", 350, 520, self.enlistedtext, 1, 1)
	--end
	
	if number == 6 then 
		draw.SimpleText("Inferno Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Director", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Deputy Director", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Inspector General", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Chief", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Colonel", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Lieutenant Colonel", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Senior Commander", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Senior Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Lieutenant Commander", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Special Agent", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Agent", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Agent", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Agent", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Acting Agent", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Lead Operative", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Operative", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Operative", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Operative", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Operative", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Acting Operative", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
	end

	if number == 7 then 
		draw.SimpleText("Imperial Intelligence Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Director", "FORMATION:Rank", -350, -430, self.commandstaff2, 1, 1)
		draw.SimpleText("Deputy Director", "FORMATION:Rank", -350, -300, self.commandstaff2, 1, 1)
		draw.SimpleText("Senior Chief", "FORMATION:Rank", -350, -230, self.commandstaff, 1, 1)
		draw.SimpleText("Chief", "FORMATION:Rank", -350, -160, self.commandstaff, 1, 1)
		-- SNR GRADE CO
		draw.SimpleText("Colonel", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Lieutenant Colonel", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Major", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Commander", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Captain", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Senior Lieutenant", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Lieutenant", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Junior Lieutenant", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Special Agent", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Senior Agent", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Agent", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Junior Agent", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Acting Agent", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Lead Operative", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Master Operative", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Operative", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Operative", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Operative", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Acting Operative", "FORMATION:Rank", 350, 120, self.enlistedtext, 1, 1)
	end

	if number == 8 then
		draw.SimpleText("Imperial Administration Ranks", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)

		-- SNR GRADE CO
		draw.SimpleText("Chief Administrator", "FORMATION:Rank", -350, -90, self.snrco2, 1, 1)
		draw.SimpleText("Senior Administrator", "FORMATION:Rank", -350, -20, self.snrco2, 1, 1)
		draw.SimpleText("Administrator", "FORMATION:Rank", -350, 50, self.snrco, 1, 1)
		draw.SimpleText("Deputy Administrator", "FORMATION:Rank", -350, 120, self.snrco, 1, 1)
		draw.SimpleText("Junior Administrator", "FORMATION:Rank", -350, 190, self.snrco, 1, 1)
		-- JNR GRADE CO
		draw.SimpleText("Executive Secretary", "FORMATION:Rank", -350, 260, self.jnrco, 1, 1)
		draw.SimpleText("Secretary", "FORMATION:Rank", -350, 330, self.jnrco, 1, 1)
		draw.SimpleText("Deputy Secretary", "FORMATION:Rank", -350, 400, self.jnrco, 1, 1)
		draw.SimpleText("Under Secretary", "FORMATION:Rank", -350, 470, self.jnrco, 1, 1)
		-- SNR GRADE NCO
		draw.SimpleText("Principal Clerk", "FORMATION:Rank", -350, 540, self.snrnco, 1, 1)
		draw.SimpleText("Clerk", "FORMATION:Rank", 350, -440, self.snrnco, 1, 1)
		draw.SimpleText("Deputy Clerk", "FORMATION:Rank", 350, -370, self.snrnco, 1, 1)
		draw.SimpleText("Under Clerk", "FORMATION:Rank", 350, -300, self.snrnco, 1, 1)
		-- JNR GRADE NCO
		draw.SimpleText("Lead Administrative Assistant", "FORMATION:Rank", 350, -230, self.jnrnco, 1, 1)
		draw.SimpleText("Administrative Assistant", "FORMATION:Rank", 350, -160, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Assistant", "FORMATION:Rank", 350, -90, self.jnrnco, 1, 1)
		draw.SimpleText("Assistant", "FORMATION:Rank", 350, -20, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Assistant", "FORMATION:Rank", 350, 50, self.jnrnco, 1, 1)
		-- ENLISTED
		draw.SimpleText("Intern", "FORMATION:Rank", 350, 540, self.enlistedtext, 1, 1)
	end
	
	--[[if number == 9 then 
		draw.SimpleText("Other", "FORMATION:Title", 0, -490, Color(255, 255, 255), 1, 1)
		--draw.RoundedBox(15, -300, -400, 660, 240, Color(130, 130, 130))
		draw.SimpleText("Unique Roles", "FORMATION:Title", -300, -360, self.htextcolor, 1, 1)
		draw.SimpleText("Counselor - Senior Command Staff", "FORMATION:Rank", -300, -280, self.commandstaff, 1, 1)
		draw.SimpleText("Phase Zero - CLASSIFIED", "FORMATION:Rank", -300, -200, self.commandstaff, 1, 1)
		draw.SimpleText("Hunter Droid - CLASSIFIED", "FORMATION:Rank", -300, -120, self.commandstaff, 1, 1)
		--draw.RoundedBox(15, -650, -60, 510, 410, Color(90, 90, 90))
		draw.SimpleText("Senior Command Staff", "FORMATION:Title", 0, 80, self.htextcolor, 1, 1)
		draw.SimpleText("Galactic Emperor Palpatine", "FORMATION:Rank", 0, 160, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Grand Moff Tarkin", "FORMATION:Rank", 0, 240, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Director Isard", "FORMATION:Rank", 0, 320, self.snrcommandstaff, 1, 1)

		--draw.RoundedBox(15, -100, -60, 750, 330, Color(40, 40, 40))
		draw.SimpleText("Area Access", "FORMATION:Title", 300, -360, self.htextcolor, 1, 1)
		draw.SimpleText("Imperial Droids", "FORMATION:Rank", 300, -280, self.commandstaff2, 1, 1)
		draw.SimpleText("Bounty Hunters", "FORMATION:Rank", 300, -200, self.commandstaff2, 1, 1)
		draw.SimpleText("ID10", "FORMATION:Rank", 300, -120, self.commandstaff2, 1, 1)
		draw.SimpleText("Doctor", "FORMATION:Rank", 300, -40, self.commandstaff2, 1, 1)
	end]]--
	
	if number == 9 then 
		draw.SimpleText("Inquisitorious Ranks", "FORMATION:Title", 0, -460, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Galactic Emperor Palpatine", "FORMATION:Title", -0, -360, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Lord Vader", "FORMATION:Rank", -0, -280, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Shadow Guard", "FORMATION:Title", 0, -120, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Sovereign Protector", "FORMATION:Rank", -350, -40, self.commandstaff2, 1, 1)
		draw.SimpleText("Protector", "FORMATION:Rank", -350, 40, self.commandstaff, 1, 1)
		draw.SimpleText("High Commander", "FORMATION:Rank", -350, 200, self.jnrco, 1, 1)
		draw.SimpleText("Commander", "FORMATION:Rank", -350, 280, self.jnrco, 1, 1)
		draw.SimpleText("Sentinel", "FORMATION:Rank", -350, 440, self.snrnco, 1, 1)
		draw.SimpleText("Defender", "FORMATION:Rank", -350, 520, self.snrnco, 1, 1)
		draw.SimpleText("Warden", "FORMATION:Rank", 350, -40, self.snrnco, 1, 1)
		draw.SimpleText("Guardian", "FORMATION:Rank", 350, 40, self.jnrnco, 1, 1)
		draw.SimpleText("Senior Guardsman", "FORMATION:Rank", 350, 200, self.jnrnco, 1, 1)
		draw.SimpleText("Gardsman", "FORMATION:Rank", 350, 280, self.jnrnco, 1, 1)
		draw.SimpleText("Junior Guardsman", "FORMATION:Rank", 350, 440, self.jnrnco, 1, 1)
		draw.SimpleText("Initiate", "FORMATION:Rank", 350, 520, self.jnrnco, 1, 1)
	end
	
	if number == 10 then 
		draw.SimpleText("Inquisitorious Ranks", "FORMATION:Title", 0, -460, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Galactic Emperor Palpatine", "FORMATION:Title", -0, -360, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Lord Vader", "FORMATION:Rank", -0, -280, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Imperial Inquisitors", "FORMATION:Title", 0, -150, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Grand Inquisitor", "FORMATION:Rank", -350, -40, self.commandstaff2, 1, 1)
		draw.SimpleText("High Inquisitor", "FORMATION:Rank", -350, 40, self.commandstaff, 1, 1)
		draw.SimpleText("Seventh Sister", "FORMATION:Rank", -350, 200, self.snrco2, 1, 1)
		draw.SimpleText("Sibling", "FORMATION:Rank", -350, 280, self.snrco, 1, 1)
		draw.SimpleText("Inquisitor", "FORMATION:Rank", -350, 440, self.jnrco, 1, 1)
		draw.SimpleText("Inquisitor I", "FORMATION:Rank", -350, 520, self.jnrco, 1, 1)
		draw.SimpleText("Inquisitor II", "FORMATION:Rank", 350, -40, self.snrnco, 1, 1)
		draw.SimpleText("Inquisitor III", "FORMATION:Rank", 350, 40, self.snrnco, 1, 1)
		draw.SimpleText("Inquisitor IV", "FORMATION:Rank", 350, 200, self.jnrnco, 1, 1)
		draw.SimpleText("Inquisitor V", "FORMATION:Rank", 350, 280, self.jnrnco, 1, 1)
		draw.SimpleText("Adept", "FORMATION:Rank", 350, 440, self.jnrnco, 1, 1)
		draw.SimpleText("Initiate", "FORMATION:Rank", 350, 520, self.jnrnco, 1, 1)
	end

	if number == 11 then 
		draw.SimpleText("Inquisitorious Ranks", "FORMATION:Title", 0, -460, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Galactic Emperor Palpatine", "FORMATION:Title", -0, -360, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Lord Vader", "FORMATION:Rank", -0, -280, self.snrcommandstaff, 1, 1)
		draw.SimpleText("Imperial Marauders", "FORMATION:Title", 0, -150, Color(255, 255, 255), 1, 1)
		draw.SimpleText("Grand Inquisitor", "FORMATION:Rank", -350, -40, self.commandstaff2, 1, 1)
		draw.SimpleText("High Inquisitor", "FORMATION:Rank", -350, 40, self.commandstaff, 1, 1)
		draw.SimpleText("Vanquisher", "FORMATION:Rank", -350, 200, self.snrco2, 1, 1)
		draw.SimpleText("Harbringer", "FORMATION:Rank", -350, 280, self.snrco, 1, 1)
		draw.SimpleText("Conqueror", "FORMATION:Rank", -350, 440, self.jnrco, 1, 1)
		draw.SimpleText("Templar", "FORMATION:Rank", -350, 520, self.jnrco, 1, 1)
		draw.SimpleText("Reaper", "FORMATION:Rank", 350, -40, self.snrnco, 1, 1)
		draw.SimpleText("Warrior", "FORMATION:Rank", 350, 40, self.snrnco, 1, 1)
		draw.SimpleText("Crusader", "FORMATION:Rank", 350, 200, self.jnrnco, 1, 1)
		draw.SimpleText("Acolyte", "FORMATION:Rank", 350, 280, self.jnrnco, 1, 1)
		draw.SimpleText("Adept", "FORMATION:Rank", 350, 440, self.jnrnco, 1, 1)
		draw.SimpleText("Initiate", "FORMATION:Rank", 350, 520, self.jnrnco, 1, 1)
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
		draw.RoundedBox(0, -1423 / 2, -1420 / 2, 1423, 100, self.hcolor)
		draw.RoundedBox(0, -1423 / 2, -1240 / 2, 1423, 1330, self.bcolor)

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

		draw.SimpleText("Page ".. self:GetPage().. " of ".. self:GetMax(), "FORMATION:Main", -400, -size - 64, self.pagenum, 1, 1)

		self:Page(self:GetPage())
		
		

	cam.End3D2D()
	cam.Start3D2D(pos, ang, 0.1)
		draw.SimpleText("Rank System", "FORMATION:Title", 0, size + 60, self.htextcolor, 1, 1)
		draw.SimpleText("|    Press E [USE] On Arrows to change page", "FORMATION:Main", 140, 660, self.hinttext, 1, 1)

		draw.SimpleText("Salute Commissioned Officer+", "FORMATION:Main", 0, 610, self.jnrco, 1, 1)

		draw.RoundedBoxEx( 35, -693, -600, 180, 70, self.enlistedtext, false, true, false, true )
		draw.RoundedBoxEx( 35, -493, -600, 180, 70, self.jnrnco, false, true, false, true )
		draw.RoundedBoxEx( 35, -293, -600, 180, 70, self.snrnco, false, true, false, true )
		draw.RoundedBoxEx( 35, -93, -600, 180, 70, self.jnrco, false, true, false, true )
		draw.RoundedBoxEx( 35, 108, -600, 180, 70, self.snrco, false, true, false, true )
		draw.RoundedBoxEx( 35, 308, -600, 180, 70, self.snrco2, false, true, false, true )
		draw.RoundedBoxEx( 35, 508, -600, 180, 70, self.snrcommandstaff, false, true, false, true )
		draw.SimpleText("Enlisted", "FORMATION:Cube", -680, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("JNR NCO", "FORMATION:Cube", -480, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("SNR NCO", "FORMATION:Cube", -280, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("JNR CO", "FORMATION:Cube", -80, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("SNR CO", "FORMATION:Cube", 120, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("Command", "FORMATION:Cube", 320, -565, Color(0, 0, 0), 0, 1)
		draw.SimpleText("Executive", "FORMATION:Cube", 525, -565, Color(0, 0, 0), 0, 1)

		cam.End3D2D()
cam.Start3D2D(pos, ang, 0.1)
	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial(implogo_icon)
	surface.DrawTexturedRectRotated(size + 80, -size - 1390, 85, 85, 0)
cam.End3D2D()

end