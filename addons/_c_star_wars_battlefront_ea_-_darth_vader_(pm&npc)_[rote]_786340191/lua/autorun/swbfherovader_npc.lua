local Category = "Star Wars Battlefront 2015"

local NPC =
{
	Name = "Darth Vader",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/nate159/swbf/hero/player/hero_sith_vader_npc.mdl",
	Health = "1000",
	Category = Category
}

list.Set( "NPC", "npc_vaderea", NPC )
local Category = "Star Wars Battlefront 2015"

local NPC =
{
	Name = "Darth Vader Enemy",
	Class = "npc_combine_s",
	Model = "models/nate159/swbf/hero/player/hero_sith_vader_npc.mdl",
	Health = "1000",
	Category = Category
}

list.Set( "NPC", "npc_vaderea_enemy", NPC )