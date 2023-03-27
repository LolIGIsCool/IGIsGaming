local Category = "Star Wars Battlefront II - Battledroids"
local NPC =
{
	Name = "Super Battledroid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/b2_battledroid/b2_battledroid.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_b2_battledroid_npc_friendly", NPC )

local NPC =
{
	Name = "Super Battledroid Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/b2_battledroid/b2_battledroid.mdl",
	Health = "1000",
	Category = Category
}
list.Set( "NPC", "npc_b2_battledroid_npc_enemy", NPC )