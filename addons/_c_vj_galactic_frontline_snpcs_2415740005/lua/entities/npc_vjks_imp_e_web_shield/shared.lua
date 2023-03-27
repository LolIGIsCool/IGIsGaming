ENT.Base 			= "npc_vj_creature_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Stormtrooper Turret"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Emplacements"

if (CLIENT) then
	local Name = "Stormtrooper Turret"
	local LangName = "npc_vjks_stormturret"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
	/*
	function ENT:CustomOnDraw()
	    if !(self.NPCModel) then
			self.NPCModel = ClientsideModel("models/american/rifleman.mdl")
		end
		local npc = self.NPCModel
		npc:SetPos(self:GetPos() + self:GetForward()*-40 + self:GetUp()*-2)
		npc:SetAngles(self:GetAngles())
		npc:SetSequence("man_gun")
	end
	
	function ENT:OnRemove()
		self.NPCModel:Remove()
	end
	*/
end