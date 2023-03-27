local Category = "Left 4 Dead 2 Tank Npcs"

local NPC = { 	Name = "Tank Bad", 
				Class = "npc_combine_s",
				Model = "models/npcs/pizzaroll/l4dtankbad.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "l4dtankbad", NPC )


local NPC =
{
	Name = "Tank Good",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npcs/pizzaroll/l4dtankgood.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "l4dtankgood", NPC )

local NPC = { 	Name = "Train Car Tank Bad", 
				Class = "npc_combine_s",
				Model = "models/npcs/pizzaroll/l4dtraincartankbad.mdl",
				Weapons = { "weapon_ar2" },
				Category = Category	}

list.Set( "NPC", "l4dtraincartankbad", NPC )


local NPC =
{
	Name = "Train Car Tank Good",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npcs/pizzaroll/l4dtraincartankgood.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "l4dtraincartankgood", NPC )