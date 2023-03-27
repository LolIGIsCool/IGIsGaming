local Category = "Doom Baron of Hell Npcs"

local NPC = { 	Name = "Baron of Hell Bad", 
				Class = "npc_combine_s",
				Model = "models/npcs/pizzaroll/baronofhellbad.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "baronofhellbad", NPC )


local NPC =
{
	Name = "Baron of Hell Good",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npcs/pizzaroll/baronofhellgood.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "baronofhellgood", NPC )