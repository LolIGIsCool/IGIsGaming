local Category = "Star Wars Battlefront II - Battledroids"
local NPC =
{
	Name = "Assault Battledroid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/b1_battledroids/assault/b1_battledroid_assault.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_assault_npc_friendly", NPC )

local NPC =
{
	Name = "Assault Battledroid Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/b1_battledroids/assault/b1_battledroid_assault.mdl",
	Health = "200",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_assault_npc_enemy", NPC )

local NPC =
{
	Name = "Heavy Battledroid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/b1_battledroids/heavy/b1_battledroid_heavy.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_heavy_npc_friendly", NPC )

local NPC =
{
	Name = "Heavy Battledroid Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/b1_battledroids/heavy/b1_battledroid_heavy.mdl",
	Health = "600",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_heavy_npc_enemy", NPC )

local NPC =
{
	Name = "Officer Battledroid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/b1_battledroids/officer/b1_battledroid_officer.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_officer_npc_friendly", NPC )

local NPC =
{
	Name = "Officer Battledroid Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/b1_battledroids/officer/b1_battledroid_officer.mdl",
	Health = "400",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_officer_npc_enemy", NPC )

local NPC =
{
	Name = "Specialist Battledroid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/npc/b1_battledroids/specialist/b1_battledroid_specialist.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_specialist_npc_friendly", NPC )

local NPC =
{
	Name = "Specialist Battledroid Enemy",
	Class = "npc_combine_s",
	Model = "models/npc/b1_battledroids/specialist/b1_battledroid_specialist.mdl",
	Health = "300",
	Category = Category
}
list.Set( "NPC", "npc_b1_battledroid_specialist_npc_enemy", NPC )