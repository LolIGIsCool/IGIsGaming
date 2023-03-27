local NPC = {
	Name = "Imperial Crewman (Hostile)",
	Class = "npc_combine_s",
	Category = "Imperial NPCs",
	Model = "models/zerohour/npc/male/crewman_h.mdl",
}
list.Set( "NPC", "npc_crewmanmale_h", NPC )

local NPC = {
	Name = "Imperial Crewman (Friendly)",
	Class = "npc_citizen",
	Category = "Imperial NPCs",
	Model = "models/zerohour/npc/male/crewman_f.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_crewmanmale_f", NPC )



local NPC = {
	Name = "Imperial Ground Crew (Hostile)",
	Class = "npc_combine_s",
	Category = "Imperial NPCs",
	Model = "models/zerohour/npc/male/groundcrew_h.mdl",
}
list.Set( "NPC", "npc_groundcrewmale_h", NPC )

local NPC = {
	Name = "Imperial Ground Crew (Friendly)",
	Class = "npc_citizen",
	Category = "Imperial NPCs",
	Model = "models/zerohour/npc/male/groundcrew_f.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_groundcrewmale_f", NPC )