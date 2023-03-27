ENT.Base = "gmod_base"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "Ranks & Clearance Panel"
ENT.Category = "Stryker's Information Panels"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Page")
	self:NetworkVar("Float", 1, "Max")
	
	--[[CONFIG]]--
	
	--[[change max pages here]]--
	--[[You would do this if you plan on adding more pages with information or removing unnesscary pages]]--
	self:SetPage(1)
	self:SetMax(11) --[[Set This Value to 7 to hide the extra Formations - Staggered Column | Left Echelon | Right Echelon ]]--
	
	--[[Header Color and Background Color]]--
	self.hcolor = Color(25, 122, 248)
	self.bcolor = Color(34, 36, 43)
	--[[Header Text Color and Text Color]]--
	self.htextcolor = Color(255, 255, 255)
	self.textcolor = Color(255, 255, 255)
	--[[Clearance Level Color Code]]--
	self.enlistedtext = Color(109,158,235)
	self.jnrnco = Color(147,196,125)
	self.snrnco = Color(106,168,79)
	self.jnrco = Color(255,217,102)
	self.snrco = Color(246,178,107)
	self.snrco2 = Color(230,145,56)
	self.commandstaff = Color(224,102,102)
	self.commandstaff2 = Color(204,65,37)
	self.snrcommandstaff = Color(179, 66, 245)
	--[[Page changing hint text color and page number color]]--
	self.hinttext = Color(255, 255, 255)
	self.pagenum = Color(255, 255, 255)
	--[[Changes the shade of the arrows when hovered over]]--
	self.pcolor = Color(0, 90, 255)
	
end