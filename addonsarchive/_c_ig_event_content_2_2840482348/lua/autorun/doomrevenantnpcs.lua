local Category = "Doom Revenant Npcs"

local NPC = { 	Name = "Revenant Bad", 
				Class = "npc_combine_s",
				Model = "models/npcs/pizzaroll/revenantbad.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "revenantbad", NPC )


local NPC =
{
	Name = "Revenant Good",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npcs/pizzaroll/revenantgood.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "revenantgood", NPC )