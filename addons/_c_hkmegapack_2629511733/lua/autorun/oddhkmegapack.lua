list.Set( "PlayerOptionsModel", "HK-47", "models/odd/nikout/swtor/player/hk47.mdl" )
player_manager.AddValidModel( "HK-47", "models/odd/nikout/swtor/player/hk47.mdl" )
list.Set( "PlayerOptionsModel", "HK-51", "models/odd/nikout/swtor/player/hk51.mdl" )
player_manager.AddValidModel( "HK-51", "models/odd/nikout/swtor/player/hk51.mdl" )
list.Set( "PlayerOptionsModel", "HK-51 Armored", "models/odd/swtor/player/hk51_a02.mdl" )
player_manager.AddValidModel( "HK-51 Armored", "models/odd/swtor/player/hk51_a02.mdl" )
list.Set( "PlayerOptionsModel", "HK-55", "models/odd/swtor/player/hk55.mdl" )
player_manager.AddValidModel( "HK-55", "models/odd/swtor/player/hk55.mdl" )
list.Set( "PlayerOptionsModel", "HK-55 Rebuilt", "models/odd/swtor/player/hk55rebuilt.mdl" )
player_manager.AddValidModel( "HK-55 Rebuilt", "models/odd/swtor/player/hk55rebuilt.mdl" )

-- HK47
local NPC = { Name = "HK-47 - Friendly", 
	      Class = "npc_citizen", 
	      Model = "models/odd/nikout/swtor/npcfriendly/hk47.mdl", 
	      Health = "500", 
	      KeyValues = { citizentype = 4 }, 
	      Category = "HK Assassin Droids",
		  Weapons = { "weapon_ar2" }
} 

list.Set( "NPC", "hk_47_odd_npc", NPC )
 
local NPC = {   Name = "HK-47 - Hostile", 
                Class = "npc_combine",
                Model = "models/odd/nikout/swtor/npchostile/hk47.mdl",
                Health = "500", 
				Category = "HK Assassin Droids",
				Weapons = { "weapon_ar2" }
}
                               
list.Set( "NPC", "hk_47_odd_enemy", NPC )

-- HK-51
local NPC = { Name = "HK-51 - Friendly", 
	      Class = "npc_citizen", 
	      Model = "models/odd/nikout/swtor/npcfriendly/hk51.mdl", 
	      Health = "500", 
	      KeyValues = { citizentype = 4 }, 
	      Category = "HK Assassin Droids",
		  Weapons = { "weapon_ar2" }
} 

list.Set( "NPC", "hk_51_npc", NPC )
 
local NPC = {   Name = "HK-51 - Hostile", 
                Class = "npc_combine",
                Model = "models/odd/nikout/swtor/npchostile/hk51.mdl",
                Health = "500", 
				Category = "HK Assassin Droids",
				Weapons = { "weapon_ar2" }
}
                               
list.Set( "NPC", "hk_51_enemy", NPC )


-- HK-51 Armored
local NPC = { Name = "HK-51 Armored - Friendly", 
	      Class = "npc_citizen", 
	      Model = "models/odd/swtor/npcfriendly/hk51_a02.mdl", 
	      Health = "500", 
	      KeyValues = { citizentype = 4 }, 
	      Category = "HK Assassin Droids",
		  Weapons = { "weapon_ar2" }
} 

list.Set( "NPC", "hk_51_armor_npc", NPC )
 
local NPC = {   Name = "HK-51 Armored - Hostile", 
                Class = "npc_combine",
                Model = "models/odd/swtor/npchostile/hk51_a02.mdl",
                Health = "500", 
				Category = "HK Assassin Droids",
				Weapons = { "weapon_ar2" }
}
                               
list.Set( "NPC", "hk_51_armor_enemy", NPC )


-- HK-55
local NPC = { Name = "HK-55 - Friendly", 
	      Class = "npc_citizen", 
	      Model = "models/odd/swtor/npcfriendly/hk55.mdl", 
	      Health = "500", 
	      KeyValues = { citizentype = 4 }, 
	      Category = "HK Assassin Droids",
		  Weapons = { "weapon_ar2" }
} 

list.Set( "NPC", "hk_55_npc", NPC )
 
local NPC = {   Name = "HK-55 - Hostile", 
                Class = "npc_combine",
                Model = "models/odd/swtor/npchostile/hk55.mdl",
                Health = "500", 
				Category = "HK Assassin Droids",
				Weapons = { "weapon_ar2" }
}
                               
list.Set( "NPC", "hk_55_enemy", NPC )

-- HK-55 Rebuilt
local NPC = { Name = "HK-55 Rebuilt - Friendly", 
	      Class = "npc_citizen", 
	      Model = "models/odd/swtor/npcfriendly/hk55rebuilt.mdl", 
	      Health = "500", 
	      KeyValues = { citizentype = 4 }, 
	      Category = "HK Assassin Droids",
		  Weapons = { "weapon_ar2" }
} 

list.Set( "NPC", "hk_55rebuilt_npc", NPC )
 
local NPC = {   Name = "HK-55 Rebuilt - Hostile", 
                Class = "npc_combine",
                Model = "models/odd/swtor/npchostile/hk55rebuilt.mdl",
                Health = "500", 
				Category = "HK Assassin Droids",
				Weapons = { "weapon_ar2" }
}
                               
list.Set( "NPC", "hk_55rebuilt_enemy", NPC )