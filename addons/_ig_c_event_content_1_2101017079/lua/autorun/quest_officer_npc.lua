local Category = "Star Wars: Quest Officer"
local NPC =
{
	Name = "Quest Officer Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/imperial_officer/npc_officer.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_quest_officer_friendly", NPC )

local NPC =
{
	Name = "Quest Officer Enemy",
	Class = "npc_combine_s",
	Model = "models/imperial_officer/npc_officer.mdl",
	Health = "100",
	Category = Category
}
list.Set( "NPC", "npc_quest_officer_enemy", NPC )

