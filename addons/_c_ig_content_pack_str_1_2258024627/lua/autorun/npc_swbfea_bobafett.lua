local Category = "SWBFEA - Boba Fett"

local NPC =
{
	Name = "Boba Fett",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/nate159/swbf/hero/hero_gunslinger_bobafett.mdl",
	Health = "1000",
	Category = Category
}

list.Set( "NPC", "npc_bobbyf", NPC )

local Category = "SWBFEA - Boba Fett"

local NPC =
{
	Name = "Boba Fett Enemy",
	Class = "npc_combine_s",
	Model = "models/nate159/swbf/hero/hero_gunslinger_bobafett.mdl",
	Health = "1000",
	Category = Category
}

list.Set( "NPC", "npc_bobbyf_enemy", NPC )
