AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include("shared.lua")
util.AddNetworkString("DROIDOpenHealMenu")
util.AddNetworkString("DROIDHealing")
util.AddNetworkString("DROIDLeg")
util.AddNetworkString("DROIDHpUpdate")

function ENT:Initialize()
    self:SetModel("models/props/starwars/medical/health_droid.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_STEP)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

if (SERVER) then
    hook.Add("EntityTakeDamage", "checkdamageshiz", function(activator, damage)
        if activator:IsPlayer() then
            activator.dmgtime = CurTime() + 15
        end
    end)
end

function ENT:Use(activator, caller)
    local HealSound = Sound("HealthKit.Touch")

    -- was 0.25
    if CurTime() < activator.dmgtime then
        activator:ChatPrint("The Medical Droid refuses to heal you within 15 seconds of taking damage!")
        activator:ChatPrint("Time left: " .. string.ToMinutesSeconds(activator.dmgtime - CurTime()))

        return
    end

    need = math.min(activator:GetMaxHealth() - activator:Health(), activator:GetMaxHealth() * .40)

    if activator:IsPlayer() and activator:GetMaxHealth() > activator:Health() then
        if activator:SH_CanAffordPremium(200) then
            activator:SetHealth(math.min(activator:GetMaxHealth(), activator:Health() + need))
            activator:ChatPrint("You have been slightly healed and charged 200 Credits!")
            activator:SH_AddPremiumPoints(-200)
            activator:EmitSound(HealSound)

			for i = 1, need do
				_G.AdvanceQuest(activator,"Daily","Redemption I");
            	_G.AdvanceQuest(activator,"Daily","Redemption II");
            	_G.AdvanceQuest(activator,"Daily","Redemption III");
			end
        else
            return activator:ChatPrint("You do not have enough credits to pay for this medical service!")
        end

        if activator.brokenleg and activator:SH_CanAffordPremium(150) then
            activator:ChatPrint("Your broken leg has been healed, and you have been charged 150 Credits!")
            activator:SH_AddPremiumPoints(-150)
            activator.brokenleg = false
            local movespeed = activator:GetJobTable().WalkSpeed
            local runspeed = activator:GetJobTable().RunSpeed

        local sprintSpeedModifier
        local sithRegiments = {
            "Shadow Guard",
            "Imperial Inquisitor",
            "Imperial Marauder",
            "Emperor's Enforcer"
        }
        if table.HasValue(sithRegiments,activator:GetRegiment()) then
            sprintSpeedModifier = 0.05 / 2
        else
            sprintSpeedModifier = 0.05
        end
		
        activator:SetRunSpeed(runspeed)
        activator:SetWalkSpeed(movespeed)
		
        if _G.HasAugment(activator, "Faster Than Light I") then
            local sprintSpeed = activator:GetRunSpeed()
            activator:SetRunSpeed(sprintSpeed + (sprintSpeed * sprintSpeedModifier))
        end
        if _G.HasAugment(activator, "Faster Than Light II") then
            local sprintSpeed = activator:GetRunSpeed()
            activator:SetRunSpeed(sprintSpeed + (sprintSpeed * sprintSpeedModifier))
        end
        if _G.HasAugment(activator, "Faster Than Light III") then
            local sprintSpeed = activator:GetRunSpeed()
            activator:SetRunSpeed(sprintSpeed + (sprintSpeed * sprintSpeedModifier))
        end
        else
            return activator:ChatPrint("Broken Leg not detected |Or| Not Enough Credits to fix broken leg")
        end
    elseif activator:IsPlayer() and activator:GetMaxHealth() == activator:Health() then
        activator:ChatPrint("You are in perfect physical condition!")
    end
end
--[[
function mediccount()
    local medicscount
    local medictable = {}

    for k, v in pairs(player.GetAll()) do
        if v:GetRegiment() == "439th Medical Company" then
            table.insert(medictable, v:Nick())
        end
    end

    medicscount = table.Count(medictable)

    if medicscount == nil then
        medicscount = 0
    end

    return medicscount
end

local medics

function ENT:Use(activator, caller)
    medics = mediccount()
    local healthmax = caller:GetMaxHealth()
    local health = caller:Health()
    net.Start("DROIDOpenHealMenu")
    net.WriteInt(health, 32)
    net.WriteInt(healthmax, 32)
    net.WriteInt(medics, 32)
    net.Send(caller)
end

net.Receive("DROIDHealing", function(len, pl)
    local credits = net.ReadInt(32)
    local creditstrue = credits
    local ccredits = pl:SH_GetPremiumPoints()
    medics = mediccount() + 1
    local trueprice = math.Clamp(creditstrue * medics,0,500)

    if pl:SH_CanAffordPremium(creditstrue) then
        pl:SH_SetPremiumPoints(ccredits - trueprice, false, false)
        pl:SetHealth(pl:GetMaxHealth())
    end

    local healthmax = pl:GetMaxHealth()
    local health = pl:Health()
    net.Start("DROIDOpenHealMenu")
    net.WriteInt(health, 32)
    net.WriteInt(healthmax, 32)
    net.Send(pl)
end)

net.Receive("DROIDLeg", function(len, pl)
    local credits = 50
    local ccredits = pl:SH_GetPremiumPoints()

    if IsValid(pl) and pl:SH_CanAffordPremium(credits) then
        if pl:GetRegiment() == "439th Medical Company" then
            if pl.brokenleg then
                pl:ChatPrint("Your broken leg has been healed for free!")
                pl.brokenleg = false
                local movespeed = pl:GetJobTable().WalkSpeed
                local runspeed = pl:GetJobTable().RunSpeed

                if pl:GetNWInt("igprogressc", 0) >= 6 then
                    pl:SetRunSpeed(runspeed * 1.1)
                    pl:SetWalkSpeed(movespeed)
                elseif pl:GetNWInt("igprogressc", 0) >= 3 then
                    pl:SetRunSpeed(runspeed * 1.05)
                    pl:SetWalkSpeed(movespeed)
                else
                    pl:SetRunSpeed(runspeed)
                    pl:SetWalkSpeed(movespeed)
                end
            end
        else
            pl:SH_SetPremiumPoints(ccredits - 50, false, false)

            if pl.brokenleg then
                pl:ChatPrint("Your broken leg has been healed!")
                pl.brokenleg = false
                local movespeed = pl:GetJobTable().WalkSpeed
                local runspeed = pl:GetJobTable().RunSpeed

                if pl:GetNWInt("igprogressc", 0) >= 6 then
                    pl:SetRunSpeed(runspeed * 1.1)
                    pl:SetWalkSpeed(movespeed)
                elseif pl:GetNWInt("igprogressc", 0) >= 3 then
                    pl:SetRunSpeed(runspeed * 1.05)
                    pl:SetWalkSpeed(movespeed)
                else
                    pl:SetRunSpeed(runspeed)
                    pl:SetWalkSpeed(movespeed)
                end
            end
        end
    end
end)]]--