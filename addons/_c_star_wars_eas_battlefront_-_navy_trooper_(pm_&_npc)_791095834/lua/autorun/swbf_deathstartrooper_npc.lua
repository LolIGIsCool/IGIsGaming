local Category = "Star Wars: EA's Battlefront - Death Star Trooper"
local NPC =
{
	Name = "Death Star Trooper Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/swbf_deathstartrooper/swbf_deathstartrooper_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_deathstartrooper_friendly", NPC )

local NPC =
{
	Name = "Death Star Trooper Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/swbf_deathstartrooper/swbf_deathstartrooper_npc.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_deathstartrooper_enemy", NPC )

