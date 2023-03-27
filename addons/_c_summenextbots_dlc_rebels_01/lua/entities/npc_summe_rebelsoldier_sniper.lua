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
ENT.PrintName = "Rebel Soldier Sniper"
ENT.Category = "Summe (Nextbots)"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/npc/linnea/swbf_rebel_soldierforest_linnea/swbf_rebel_soldierforest_linnea.mdl"
ENT.Weapon = "weapon_npc_dt20a"
ENT.HP = 200
ENT.ShootingRange = 1500
ENT.LooseRadius = 2000
ENT.Proficiency = .2

ENT.Melee = true
ENT.MeleeDamage = 25
ENT.MeleeDelay = 3

ENT.ThrowGrenades = false
ENT.Grenades = {"summe_gr_grenade"}

ENT.Sounds = false

ENT.Anims = {
    ["shoot"] = {"crouch_shoot_smg1"},
    ["reload"] = {"reload_smg1", "crouch_reload_smg1"},
    ["walk_slow"] = {"walkAlertHOLD_AR2_ALL1", "walkAlertAimALL1", "walk_RPG_Relaxed_all"},
    ["walk_fast"] = {"run_alert_holding_all", "run_aiming_all", "crouch_run_holding_RPG_all"},
    ["melee"] = {"range_melee_shove"},
}

local MaterialGlow = Material("sprites/light_glow02_add")
local ColorGlow = Color(255,255,255)

function ENT:Draw()
    self:DrawModel()
    self:DrawNameTag()

    local enemy = self:GetNWEntity("targetEnemy", false)
    if not enemy then return end

    if enemy != LocalPlayer() then return end

    local pos, ang = self:GetPos(), self:GetAngles()
    local drawpos = pos + ang:Forward() * 25 + ang:Right() * -4 + ang:Up() * 45

    render.SetMaterial(MaterialGlow)
    render.DrawSprite(drawpos, 75, 75, ColorGlow)
end

function ENT:ShootEnemy()
    local weapon = self:GetWeapon()
    local enemy = self:GetEnemy()
    local self_ = self

    if not IsValid(weapon) then return end
    if hook.Run("SummeNextbot.CannotTarget", enemy, self) then self:SetEnemy(false) return end

    if self.DisableShooting then return end

    weapon.LastEnemy = enemy

    local tr = util.TraceLine({
        start = weapon:GetPos() + Vector(0, 0, 50),
        endpos = enemy:HeadTarget(enemy:GetPos()) - Vector(0, 0, 10),
        filter = {weapon, self},
    })

    if tr.Entity != enemy then return end

    if weapon:Clip1() > 0 then
        if self.IsReloading then return end
        self:PlayAnimation("shoot")
        weapon:PrimaryAttack()
        if self.Sounds then
            self:MakeSound(table.Random(self.Sounds["attacking"] or {}), 95)
        end
    else
        if self.IsReloading then return end
        self.IsReloading = true
        self:MakeSound("weapons/bf3/standard_reload2.ogg", 0)
        self:PlayAnimation("reload")
        timer.Simple(3, function()
            if not IsValid(weapon) then return end
            weapon:SetClip1(self.NormalWeaponClip)
            self.IsReloading = false
        end)
    end
end