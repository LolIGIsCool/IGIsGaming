ENT.Base 			= "npc_vj_human_base" -- Full list of bases is in the base, or go back to this link and read the list: https://saludos.sites.google.com/site/vrejgaming/makingvjbaseaddon
ENT.Type 			= "ai"
ENT.PrintName 		= "Storm Trooper"
ENT.Author 			= "Krieg_Strudel"
ENT.Purpose 		= "Spawn it and fight with it! For the Empire!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "NPC"

if (CLIENT) then
	local Name = "Storm Trooper"
	local LangName = "npc_vjks_strooper"
	language.Add(LangName, Name)
	killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end