local Category = "Star Wars: EA's Battlefront - Dengar"
local NPC =
{
	Name = "Dengar Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/swbf_dengar/swbf_dengar_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_dengar_friendly", NPC )

local NPC =
{
	Name = "Dengar Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/swbf_dengar/swbf_dengar_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_dengar_enemy", NPC )

