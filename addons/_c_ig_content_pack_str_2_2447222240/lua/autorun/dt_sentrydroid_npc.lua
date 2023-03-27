local Category = "DT Sentry Droid NPC"
local NPC =
{
	Name = "DT Sentry droid Friendly",
	Class = "npc_citizen",
	KeyValues =
	{
		citizentype = 4
	},
	Model = "models/defcon/loudmantis/npc/sentry.mdl",
	Health = "1000",
	Category = Category
}
list.Set( "NPC", "npc_dt_sentrydroid_npc_friendly", NPC )

local NPC =
{
	Name = "DT Sentry droid Enemy",
	Class = "npc_combine_s",
	Model = "models/defcon/loudmantis/npc/sentry.mdl",
	Health = "1000",
	Category = Category
}
list.Set( "NPC", "npc_dt_sentrydroid_npc_enemy", NPC )