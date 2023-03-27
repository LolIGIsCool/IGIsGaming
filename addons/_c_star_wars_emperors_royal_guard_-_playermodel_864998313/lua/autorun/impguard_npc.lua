local Category = "Star Wars: Emperor's Royal Guard"
local NPC =
{
	Name = "Royal Guard Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/player/ven/guard_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_royalguard_friendly", NPC )

local NPC =
{
	Name = "Royal Guard Enemy",
	Class = "npc_combine_s",
	Model = "models/player/ven/guard_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_royalguard_enemy", NPC )