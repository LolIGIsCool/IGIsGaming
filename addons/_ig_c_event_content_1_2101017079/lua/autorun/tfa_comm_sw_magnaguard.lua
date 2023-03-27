player_manager.AddValidModel("TFA-SW-Magna-Guard-Trainer","models/tfa/comm/gg/pm_sw_magna_guard_trainer.mdl")
player_manager.AddValidModel("TFA-SW-Magna-Guard-Combined","models/tfa/comm/gg/pm_sw_magna_guard_combined.mdl")
player_manager.AddValidModel("TFA-SW-Magna-Guard-Season4","models/tfa/comm/gg/pm_sw_magna_guard_season4.mdl")

--Hostile NPC

local NPC = {
	Name = "Magna Guard ( Trainer, Hostile )",
	Class = "npc_combine_s",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_comb_magna_guard_trainer.mdl"
}
list.Set( "NPC", "npc_sw_magnag_trainer_h", NPC )

local NPC = {
	Name = "Magna Guard ( Combined, Hostile )",
	Class = "npc_combine_s",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_comb_magna_guard_combined.mdl"
}
list.Set( "NPC", "npc_sw_magnag_combined_h", NPC )

local NPC = {
	Name = "Magna Guard ( Season4, Hostile )",
	Class = "npc_combine_s",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_comb_magna_guard_season4.mdl"
}
list.Set( "NPC", "npc_sw_magnag_season4_h", NPC )

--Friendly NPC

local NPC = {
	Name = "Magna Guard ( Trainer, Friendly )",
	Class = "npc_citizen",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_reb_magna_guard_trainer.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_sw_magnag_trainer_f", NPC )

local NPC = {
	Name = "Magna Guard ( Combined, Friendly )",
	Class = "npc_citizen",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_reb_magna_guard_combined.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_sw_magnag_combined_f", NPC )

local NPC = {
	Name = "Magna Guard ( Season4, Friendly )",
	Class = "npc_citizen",
	Category = "CGI Magna Guards",
	Model = "models/tfa/comm/gg/npc_reb_magna_guard_season4.mdl",
	KeyValues = { citizentype = CT_UNIQUE }
}
list.Set( "NPC", "npc_sw_magnag_season4_f", NPC )