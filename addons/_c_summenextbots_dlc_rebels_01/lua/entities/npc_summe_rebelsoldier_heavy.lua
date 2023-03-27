--[[
   _____ _    _ __  __ __  __ ______                   
  / ____| |  | |  \/  |  \/  |  ____|                  
 | (___ | |  | | \  / | \  / | |__                     
  \___ \| |  | | |\/| | |\/| |  __|                    
  ____) | |__| | |  | | |  | | |____                   
 |_____/_\____/|_| _|_|_|__|_|______|___ _______ _____ 
 | \ | |  ____\ \ / /__   __|  _ \ / __ \__   __/ ____|
 |  \| | |__   \ V /   | |  | |_) | |  | | | | | (___  
 | . ` |  __|   > <    | |  |  _ <| |  | | | |  \___ \ 
 | |\  | |____ / . \   | |  | |_) | |__| | | |  ____) |
 |_| \_|______/_/ \_\  |_|  |____/ \____/  |_| |_____/ 
                                                       
    Created by Summe: https://steamcommunity.com/id/DerSumme/ 
    Purchased content: https://discord.gg/k6YdMwj9w2
]]--

AddCSLuaFile()
ENT.Base = "summe_nextbot"
ENT.PrintName = "Rebel Soldier Heavy"
ENT.Category = "Summe (Nextbots)"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/npc/roger/swbf_rebel_soldiermagma_roger/swbf_rebel_soldiermagma_roger.mdl"
ENT.Weapon = "weapon_npc_rt97c"
ENT.HP = 800
ENT.ShootingRange = 860
ENT.LooseRadius = 1500
ENT.Proficiency = .25

ENT.Melee = true
ENT.MeleeDamage = 25
ENT.MeleeDelay = 3

ENT.ThrowGrenades = true
ENT.Grenades = {"summe_gr_impact"}

ENT.Sounds = false

ENT.Anims = {
    ["shoot"] = {"shoot_smg1", "shoot_rpg", "crouch_shoot_smg1"},
    ["reload"] = {"reload_smg1", "crouch_reload_smg1"},
    ["walk_slow"] = {"walkAlertHOLD_AR2_ALL1", "walkAlertAimALL1", "walk_RPG_Relaxed_all"},
    ["walk_fast"] = {"run_alert_holding_all", "run_aiming_all", "crouch_run_holding_RPG_all"},
    ["melee"] = {"range_melee_shove"},
}