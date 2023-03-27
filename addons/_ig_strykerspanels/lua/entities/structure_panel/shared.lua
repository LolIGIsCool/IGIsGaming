ENT.Base = "gmod_base"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Empire Structure Panel"
ENT.Category = "Stryker's Information Panels"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Page")
	self:NetworkVar("Float", 1, "Max")
	
	--[[CONFIG]]--
	
	--[[change max pages here]]--
	--[[You would do this if you plan on adding more pages with information or removing unnesscary pages]]--
	self:SetPage(1)
	self:SetMax(4) --[[Set This Value to 7 to hide the extra Formations - Staggered Column | Left Echelon | Right Echelon ]]--

	--[[Role Color and background | Role User Background and Color | Connectors | Specific Branch]]--
	self.rolecolor = Color(140, 140, 0)
	self.roletextcolor = Color(0, 0, 0)
	self.roleuser = Color(140, 140, 140)
	self.roleusertext = Color(0, 0, 0)
	self.connectors = Color(140, 140, 140)
	self.branch = Color(180, 0, 0)
		--[[Header Color and Background Color]]--
	self.hcolor = Color(25, 122, 248)
	self.bcolor = Color(34, 36, 43)
	--[[Header Text Color and Text Color]]--
	self.htextcolor = Color(255, 255, 255)
	self.textcolor = Color(255, 255, 255)
	--[[Page changing hint text color and page number color]]--
	self.hinttext = Color(255, 255, 255)
	self.pagenum = Color(255, 255, 255)
	--[[Changes the shade of the arrows when hovered over]]--
	self.pcolor = Color(0, 90, 255)
	
	
	--[[Ignore below]]--
	--[[====================================--
	--[[Imperial Army Command]]--
	self.grandgeneral = "Hammer"
	self.general1rank = "Surface Marshal"
	self.general1name =  "Lucky"
	self.general2rank = "General"
	self.general2name =  "Grif"
	self.general3rank = "General"
	self.general3name =  "Arcturusious"
	self.general4rank = "Lieutenant General"
	self.general4name =  "Theta"
	self.general5rank = "Major General"
	self.general5name =  "Tank"
	self.general6rank = "Major General"
	self.general6name =  "Loki"
	self.general7rank = "Major General"
	self.general7name =  "test"
	--[[Imperial Navy Command]]--
	self.navy1rank = "Admiral"
	self.navy1name = "K. Konstantine"
	self.navy2rank = "Rear Admiral"
	self.navy2name = "Alexander Sandhurst"
	self.engineerrank = "Deputy Director"
	self.engineername = "Rad Cop"
	self.airgeneral = "[VACANT]"
	self.commandleader = "Archer"
	--[[Imperial Government]]--
	self.moff = "Abran Balfour"
	self.chiefstaff = "Stathi"
	--[[Imperial Security Bureau]]--
	self.isbbureauchief = "Weiss"
	self.isbchief = "Arathilion .X"
	--====================================]]--
end