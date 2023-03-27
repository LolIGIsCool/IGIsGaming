ENT.Base 			= "npc_vj_tank_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Enemy Star Wars HQ"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Nazi Party"
 
if (CLIENT) then
local Name = "Enemy Star Wars HQ"
local LangName = "npc_swbfimp_building_spawner"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
