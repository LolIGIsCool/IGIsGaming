ENT.Base 			= "npc_vjks_galfr_human_base" -- Full list of bases is in the base, or go back to this link and read the list: https://saludos.sites.google.com/site/vrejgaming/makingvjbaseaddon
ENT.Type 			= "ai"
ENT.PrintName 		= "Imperial Training Stormtrooper"
ENT.Author 			= "Krieg_Strudel"
ENT.Purpose 		= "Spawn it and fight with it! For the Empire!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "NPC"

ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AutomaticFrameAdvance = false

ENT.IsVJBaseSNPC = true -- Is it a VJ Base SNPC?
ENT.IsVJBaseSNPC_Human = true -- Is it a VJ Base human?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetAutomaticFrameAdvance(val)
	self.AutomaticFrameAdvance = val
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MatFootStepQCEvent(data)
	-- Return true to apply all changes done to the data table.
	-- Return false to prevent the sound from playing.
	-- Return nil or nothing to play the sound without altering it.
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
