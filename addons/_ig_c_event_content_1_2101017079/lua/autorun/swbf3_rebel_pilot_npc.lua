local Category = "Star Wars Battlefront 3 Rebel Pilot NPCs"

local NPC = { Name = "Rebel Pilot(Hostile)",
            Class = "npc_combine_s",
            Model = "models/swbf3_rebels/rebel_pilot_hostile.mdl",
			Health = "80",
            Squadname = "swbf3_rebel_pilots",
			Weapons = { "weapon_ar2" },
            Numgrenades = "4",
            Category = Category    }
list.Set( "NPC", "npc_swbf3_rebel_pilot_hostile", NPC )


local NPC = { Name = "Rebel Pilot(Friendly)",
            Class = "npc_citizen",      
            Model = "models/swbf3_rebels/rebel_pilot_friendly.mdl",
            Health = "80",
			Weapons = { "weapon_ar2" },
            KeyValues = { citizentype = 4 },
            Category = Category    }
list.Set( "NPC", "npc_swbf3_rebel_pilot_friendly", NPC )