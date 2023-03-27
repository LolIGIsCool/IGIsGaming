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
ENT.PrintName = "Rebel Soldier Officer"
ENT.Category = "Summe (Nextbots)"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/npc/linnea/swbf_rebel_soldiersand_linnea/swbf_rebel_soldiersand_linnea.mdl"
ENT.Weapon = "weapon_npc_dh17"
ENT.HP = 200
ENT.ShootingRange = 860
ENT.LooseRadius = 1500
ENT.Proficiency = 0

ENT.Melee = true
ENT.MeleeDamage = 25
ENT.MeleeDelay = 3

ENT.ThrowGrenades = true
ENT.Grenades = {"summe_gr_grenade"}

ENT.Sounds = false

ENT.Anims = {
    ["shoot"] = {"shoot_smg1", "shoot_rpg", "crouch_shoot_smg1"},
    ["reload"] = {"reload_smg1", "crouch_reload_smg1"},
    ["walk_slow"] = {"walkAlertHOLD_AR2_ALL1", "walkAlertAimALL1", "walk_RPG_Relaxed_all"},
    ["walk_fast"] = {"run_alert_holding_all", "run_aiming_all", "crouch_run_holding_RPG_all"},
    ["melee"] = {"range_melee_shove"},
}


function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsBoosting", { KeyName = "CommandPostName", Edit = { type = "Generic", order = 1, category = "Settings"}})
end

local snd = Sound("HealthKit.Touch")

function ENT:EveryThreeSeconds()
    local ents_ = ents.FindInSphere(self:GetPos(), 500)
    local droids = 0

    for k, v in pairs(ents_) do
        if not v.SummeNextbot then continue end
        if v == self then continue end
        local hp, maxHp = v:Health(), v:GetMaxHealth()
        if hp >= maxHp then continue end

        v:SetHealth(math.Clamp(hp + maxHp * .2, 0, maxHp))

        local effectdata = EffectData()
        effectdata:SetOrigin(v:GetPos() + Vector(0, 0, 50))
        util.Effect("ManhackSparks", effectdata)

        v:EmitSound(snd)
        v:MakeSound("items/ammo_pickup.wav", 0)

        droids = droids + 1
    end

    if droids <= 0 then return end

    self:SetIsBoosting(true)
    timer.Simple(0.7, function()
        if not IsValid(self) then return end
        self:SetIsBoosting(false)
    end)
end

local material = Material("particle/particle_ring_wave_addnofog")
local red = Color(255,225,53,84)
ENT.intPol = 0

function ENT:Draw()
    self:DrawModel()
    self:DrawNameTag()

    if not self:GetIsBoosting() then self.intPol = 0 return end

    render.SetMaterial(material)
    self.intPol = Lerp(FrameTime() * 3, self.intPol, 500 * 2)
    render.DrawQuadEasy(self:GetPos(), Vector(0, 0, 1), self.intPol, self.intPol, red, 0)
end