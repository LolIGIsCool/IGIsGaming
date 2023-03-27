local Category = "[IG] Storm Trooper NPCs"
local NPC =
{
	Name = "StormTrooper GOOD!",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/stormtrooper/npc_stormtrooper.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_ig_stormtrooper_npc_friendly", NPC )

local NPC =
{
	Name = "StormTrooper BAD!",
	Class = "npc_combine_s",
	Model = "models/npc/stormtrooper/npc_stormtrooper.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_ig_stormtrooper_npc_enemy", NPC )

local NPC =
{
	Name = "StormTrooper Officer GOOD!",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/stormtrooper/npc_stormtrooper_officer.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_ig_stormtrooper_officer_npc_friendly", NPC )

local NPC =
{
	Name = "StormTrooper Officer BAD!",
	Class = "npc_combine_s",
	Model = "models/npc/stormtrooper/npc_stormtrooper_officer.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_ig_stormtrooper_officer_npc_enemy", NPC )

--Fuck you stryker

