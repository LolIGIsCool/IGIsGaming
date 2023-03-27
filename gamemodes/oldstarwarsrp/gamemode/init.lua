AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddWorkshop("828048302")

function GM:UpdateAnimation()
end

function GM:CalcMainActivity(ply, velocity)
    return ply.CalcIdeal, -1
end

local voiceHooks = table.Copy(hook.GetTable()["PlayerCanHearPlayersVoice"])
local hooks = hook.GetTable()

-- Remove all current voice hooks
for name, func in pairs(voiceHooks) do
    hook.Remove("PlayerCanHearPlayersVoice", name)
end

-- Prevent any future voice hooks
setmetatable(hooks["PlayerCanHearPlayersVoice"], {
    __newindex = function(self, index, value)
        voiceHooks[index] = value
    end
})

function GM:PlayerCanHearPlayersVoice(listener, talker)
    local ply = talker

    if ply.Checked ~= CurTime() then
        local wep = ply:GetActiveWeapon()
        ply.Checked = CurTime()
        ply.CalcIdeal = ACT_MP_STAND_IDLE
        ply.m_bInSwim = false

        if ply:Crouching() then
            if ply:GetVelocity():Length2DSqr() > 0.25 then
                ply.CalcIdeal = ACT_MP_CROUCHWALK
            else
                ply.CalcIdeal = ACT_MP_CROUCH_IDLE
            end
        elseif ply:WaterLevel() > 2 and not ply:OnGround() then
            ply.CalcIdeal = ACT_MP_SWIM
            ply.m_bInSwim = true
        else
            local len2d = ply:GetVelocity():Length2DSqr()

            if len2d > 22500 then
                ply.CalcIdeal = ACT_MP_RUN
            elseif len2d > 0.25 then
                ply.CalcIdeal = ACT_MP_WALK
            end
        end

        wep = ply:GetActiveWeapon()

        if IsValid(wep) and wep.PlayerThink and wep.IsTFAWeapon then
            wep:PlayerThink(ply)
        end
    end

    if listener.FSpectating and IsValid(listener.FSpectatingEnt) and (listener.FSpectatingEnt == talker or talker:GetPos():DistToSqr(listener.FSpectatingEnt:GetPos()) < 300000) then
        return true
    elseif listener.FSpectating and listener.FSpectatePos and isvector(listener.FSpectatePos) and talker:GetPos():DistToSqr(listener.FSpectatePos) < 200000 then
        return true
    end

    if (talker.IsSquadVoice and listener:GetSquadName() ~= "") then return listener:GetSquadName() == talker:GetSquadName() end
    if talker:HasWeapon("voice_amplifier") and talker:GetActiveWeapon():GetClass() == "voice_amplifier" and not talker.debriefvmode then return true end

    local voicelvl = ply.voicelevel or "normal"
    local dist1 = 300000

    if talker:HasWeapon("voice_amplifier") and talker:GetActiveWeapon():GetClass() == "voice_amplifier" and talker.debriefvmode then
        dist1 = dist1 * 3
    elseif voicelvl == "whisper" then
        dist1 = dist1 * 0.1
    elseif voicelvl == "yelling" then
        dist1 = dist1 * 1.3
    end

    local dist = talker:GetPos():DistToSqr(listener:GetPos()) < dist1


    return dist, true
end

function GM:GetFallDamage(ply, flFallSpeed)
    local damage = (flFallSpeed - 526.5) * (100 / 396)
    local plylegbrokenanti = tonumber(ply:GetNWInt("igquestprogress", 0)) or 0

    if (damage >= 15 and math.random(1, 10) <= 4 and plylegbrokenanti < 20) then
        ply:SetNWBool("igbrokenleg", true)
        ply:ChatPrint("Ouch! You have broken your leg, wait for it to heal or see a medic for a splint.")
    end

    return damage
end

function GM:CanDrive(ply, ent)
    return false
end

function GM:TranslateActivity()
end

function GM:PlayerButtonDown()
end

function GM:PlayerButtonUp()
end

function GM:Move()
end

function GM:SetupMove()
end

function GM:FinishMove()
end