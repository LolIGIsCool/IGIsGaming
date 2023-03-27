--Add Playermodel
player_manager.AddValidModel( "EG-5 Jedi Hunter Droid", "models/jazzmcfly/jka/eg5/jka_eg5.mdl")


--Add NPC
local NPC =
{
	Name = "EG-5 Jedi Hunter Droid",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/jazzmcfly/jka/eg5/jka_eg5_npc.mdl",
	Category = "Star Wars"
}

list.Set( "NPC", "npc_mcfly_eg5", NPC )
