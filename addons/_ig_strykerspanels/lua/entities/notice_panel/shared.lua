ENT.Base = "gmod_base"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName = "IG Noticeboard Panel"
ENT.Category = "Stryker's Information Panels"
ENT.Spawnable = true

function ENT:SetupDataTables()
	
	--[[CONFIG]]--
	--[[Role Color and background | Role User Background and Color | Connectors | Specific Branch]]--
	self.rolecolor = Color(140, 140, 0)
	self.roletextcolor = Color(0, 0, 0)
	self.roleuser = Color(140, 140, 140)
	self.roleusertext = Color(0, 0, 0)
	self.connectors = Color(140, 140, 140)
	self.branch = Color(180, 0, 0)
	self.noticeback = Color(140, 140, 140)
	self.noticeborder = Color(0, 0, 0)
	self.noticeheader = Color(200, 0, 0)
	
		--[[Header Color and Background Color]]--
	self.hcolor = Color(25, 122, 248)
	self.bcolor = Color(34, 36, 43)
	--[[Header Text Color and Text Color]]--
	self.htextcolor = Color(255, 255, 255)
	self.textcolor = Color(255, 255, 255)
	self.textnotice = Color(0, 0, 0)
	--[[Page changing hint text color and page number color]]--
	self.hinttext = Color(255, 255, 255)
	self.pagenum = Color(255, 255, 255)
	--[[Changes the shade of the arrows when hovered over]]--
	self.pcolor = Color(0, 90, 255)
	
end