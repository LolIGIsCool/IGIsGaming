local Category = "Star Wars: EA's Battlefront - Bossk"
local NPC =
{
	Name = "Bossk Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/swbf_bossk/swbf_bossk_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_swbf_bossk_friendly", NPC )

local NPC =
{
	Name = "Bossk Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/swbf_bossk/swbf_bossk_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_swbf_bossk_enemy", NPC )

