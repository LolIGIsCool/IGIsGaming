ENT.Base 			= "npc_vj_creature_base" -- List of all base types: https://github.com/DrVrej/VJ-Base/wiki/Base-Types
ENT.Type 			= "ai"
ENT.PrintName 		= "DT Sentry Droid"
ENT.Author 			= "Orion, Sirius, Zmaj"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "NPC/SNPC Battles or any other things"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "[AOTR] Droid"

if (CLIENT) then
	local Name = "DT Sentry Droid"
	local LangName = "npc_vj_dtdroid"
	language.Add(LangName, Name)
	killicon.Add(LangName,"",Color(255,0,0,0))
	language.Add("#"..LangName, Name)
	killicon.Add("#"..LangName,"",Color(255,0,0,0))
end