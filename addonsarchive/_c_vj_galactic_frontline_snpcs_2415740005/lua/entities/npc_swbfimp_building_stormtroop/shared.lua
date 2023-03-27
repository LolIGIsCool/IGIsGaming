ENT.Base 			= "npc_swbfimp_building_spawner"
ENT.Type 			= "ai"
ENT.PrintName 		= "Enemy Imperial Stormtrooper Corps HQ"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Nazi Party"
 
if (CLIENT) then
local Name = "Enemy Imperial Stormtrooper Corps HQ"
local LangName = "npc_swbfimp_building_stormtroop"
language.Add(LangName, Name)
killicon.Add(LangName,"HUD/killicons/default",Color(255,80,0,255))
language.Add("#"..LangName, Name)
killicon.Add("#"..LangName,"HUD/killicons/default",Color(255,80,0,255))
end
---------------------------------------------------------------------------------------------------------------------------------------------
