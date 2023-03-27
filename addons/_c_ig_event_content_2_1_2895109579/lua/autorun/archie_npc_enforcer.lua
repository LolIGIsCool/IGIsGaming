local Category = "RAGE Authority"

local NPC =
{
	Name = "Enforcer (Ally)",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4,
		SquadName = "resistance"
	},
	Model = "models/archie/rage_enforcer_npc_ally.mdl",
	Health = "100",
	Weapons = { "weapon_ar2" },
	Category = Category
}

list.Set( "NPC", "authorityenforcerally", NPC )

local NPC = { 	Name = "Enforcer (Enemy)", 
				Class = "npc_combine_s",
				KeyValues =
				{
					SquadName = "overwatch",
					Numgrenades = 5
				},
				Model = "models/archie/rage_enforcer_npc_enemy.mdl",
				Weapons = { "weapon_ar2", "weapon_smg1" },
				Category = Category
			}

list.Set( "NPC", "authorityenforcerenemy", NPC )