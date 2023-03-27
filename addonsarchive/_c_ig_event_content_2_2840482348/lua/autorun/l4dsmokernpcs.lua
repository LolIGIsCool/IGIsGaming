local Category = "Left 4 Dead 2 Smoker Npcs"

local NPC = { 	Name = "Smoker Bad", 
				Class = "npc_combine_s",
				Model = "models/npcs/pizzaroll/l4dsmokerbad.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "l4dsmokerbad", NPC )


local NPC =
{
	Name = "Smoker Good",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npcs/pizzaroll/l4dsmokergood.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "l4dsmokergood", NPC )