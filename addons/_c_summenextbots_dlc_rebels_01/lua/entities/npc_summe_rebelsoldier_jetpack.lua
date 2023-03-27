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
ENT.PrintName = "Rebel Soldier Jetpack"
ENT.Category = "Summe (Nextbots)"
ENT.Spawnable = true
ENT.AdminOnly = false

ENT.Model = "models/npc/roger/swbf_rebel_soldierforest_roger/swbf_rebel_soldierforest_roger.mdl"
ENT.Weapon = "weapon_npc_a280"
ENT.HP = 1000
ENT.ShootingRange = 800
ENT.LooseRadius = 2000
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

function ENT:DoConfrontEnemy(ent)
    if not ent or not IsValid(ent) then return end

    local shootRange, looseRange = self:EnemyInRange()

    if shootRange then
        self:PathFollowerStop()

        self:ShootEnemy()

        self.loco:FaceTowards(ent:GetPos())
    else

        if not looseRange then
            self:SetEnemy(nil)
            return
        end

        if ent == self:GetNewEnemy() then
            if self.IsJetBoosting then return end
            if math.random(1, 200) >= 195 then
                self.IsJetBoosting = true
                self:JumpTo(ent:GetPos())
                
                timer.Simple(2, function()
                    self.IsJetBoosting = false 
                end)
            else
                self:RunTo(ent:GetPos(), self.Speed * 3)
            end
        end
    end
end

function ENT:OnNPCSpawn()
	self.loco:SetGravity(70)
    self.loco:SetStepHeight(40)
end

if SERVER then
    function ENT:Think()
        if not self.loco:IsOnGround() then
            self:SetNWBool("IsInAir", true)
        end
    end 

    function ENT:OnLandOnGround()
        self:SetNWBool("IsInAir", false)
    end

    function ENT:OnRemove()
        if self:GetNWBool("IsInAir", false) then
            self.Explo = ents.Create( "env_explosion" )
            self.Explo:SetKeyValue( "spawnflags", 144 )
            self.Explo:SetKeyValue( "iMagnitude", 15 )
            self.Explo:SetKeyValue( "iRadiusOverride", 256 )
            self.Explo:SetPos( self:GetPos() )
            self.Explo:Spawn()
            self.Explo:Fire( "explode", "", 0 )
        end
    end
end

if CLIENT then
    local colorRed = Color(150, 0, 0, 230)
    local colorGrey = Color(15, 15, 15, 230)
    local colorWhite = Color(255,255,255)
    local MaterialGlow = Material("sprites/light_glow02_add")
    local ColorGlow = Color(255,174,0)
    
    function ENT:Draw()
        self:DrawModel()
        self:DrawNameTag(colorRed, 0)

        if not self.JetPackSound then
            self.JetPackSound = CreateSound(self, "thrusters/jet03.wav")
        end

        if self:GetNWBool("IsInAir", false) then
            self:DrawJetpackFire()

            self.JetPackSound:PlayEx(0.5, 125)
        else
            self.JetPackSound:FadeOut(0.1)
        end
    end

    local MatHeatWave = Material( "sprites/heatwave" )
    local MatFire = Material( "effects/fire_cloud1" )

    local JetpackFireBlue = Color( 0 , 0 , 255 , 128 )
    local JetpackFireWhite = Color( 255 , 255 , 255 , 128 )
    local JetpackFireNone = Color( 255 , 255 , 255 , 0 )
    local JetpackFireRed = Color( 255 , 128 , 128 , 255 )

    function ENT:DrawJetpackFire()

        local forwardA = self:GetAngles()
        forwardA.pitch = 0

        local normal = Vector(0, 0, -1)
        local pos = self:GetPos() + Vector(0, 0, 40) + forwardA:Forward() * -10
        local scale = 0.25

        local scroll = 1000 + UnPredictedCurTime() * -10

        --the trace makes sure that the light or the flame don't end up inside walls
        --although it should be cached somehow, and only do the trace every tick

        local tracelength = 50

        render.SetMaterial( MatFire )

        render.StartBeam( 3 )
            render.AddBeam( pos, 8 * scale , scroll , JetpackFireBlue )
            render.AddBeam( pos + normal * 60 * scale , 32 * scale , scroll + 1, JetpackFireWhite )
            render.AddBeam( pos + normal * tracelength , 32 * scale , scroll + 3, JetpackFireNone )
        render.EndBeam()

        render.SetMaterial( MatFire )

        render.StartBeam( 3 )
            render.AddBeam( pos, 100 * scale , scroll , JetpackFireBlue )
            render.AddBeam( pos + normal * 60 * scale , 40 * scale , scroll + 1, JetpackFireWhite )
            render.AddBeam( pos + normal * tracelength , 32 * scale , scroll + 3, JetpackFireNone )
        render.EndBeam()

        render.SetMaterial(MaterialGlow)
        render.DrawSprite(pos, 75, 75, ColorGlow)
    end

    function ENT:OnRemove()
        if self.JetPackSound then
            self.JetPackSound:Stop()
        end
    end
end