local RADBOX = {}

 -- these models are always safe (regardless of bodygroups)
local immune_models = {
        ["models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"] = true,
        ["models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_04_b/pilot_imperial_orig_04_b.mdl"] = true,
        ["models/player/markus/swbf2/characters/hero/imperial_pilots/pilot_imperial_orig_01/pilot_imperial_orig_01.mdl"] = true,
        ["models/player/markus/starwars/custom/characters/imperial/atat_pilot/atat_pilot_01/atat_pilot_01_mesh.mdl"] = true,
        ["models/player/markus/swbf2/characters/imperial/imperial_tanktrooper/imperial_tanktrooper_04.mdl"] = true,
        ["models/interrogationdroid/interrogationdroid.mdl"] = true,
        ["models/ig/banks/astromech/imperial_astromech.mdl"] = true,
        ["models/seeker_droid2/seeker_droid2.mdl"] = true,
        ["models/kryptonite/ig88/ig88.mdl"] = true,
        ["models/player/jellik/starwars/highsinger.mdl"] = true,
        ["models/nikout/swtor/npc/hk47.mdl"] = true,
        ["models/kryptonite/4lom/4lom.mdl"] = true,
        ["models/nate159/swbf/hero/player/hero_sith_vader_player.mdl"] = true,
        ["models/zerochain/props_bloodlab/zbl_hazmat.mdl"] = true
}
function RADBOX:IsImmune(ent)
    -- wearing safe equipment?
    if (ent:GetModel() == "models/rising/models/navy_egofc.mdl") then
        return ent:GetBodygroup(2) == 2
    end
    if (ent:GetModel() == "models/zerohour/pms/male/groundcrew.mdl") then
        return ent:GetBodygroup(2) == 0
    end
    if (ent:GetModel() == "models/zerohour/pms/female/groundcrew.mdl.mdl") then
        return ent:GetBodygroup(2) == 0
    end
    if ent:GetModel() == "models/player/markus/ot_inferno_squad_del/ot_inferno_squad_del_playermodel.mdl" then
        return ent:GetBodygroup(7) == 1
    end
    if ent:GetModel() == "models/player/markus/ot_inferno_squad_hask/ot_inferno_squad_hask_playermodel.mdl" then
        return ent:GetBodygroup(3) == 1
    end
    if ent:GetModel() == "models/player/markus/ot_inferno_squad_iden_versio/ot_inferno_squad_iden_versio_playermodel.mdl" then
        return ent:GetBodygroup(3) == 1
    end
    -- droids are immune
    if ent:GetRegiment() == "Imperial Droid" then
        return true
    end
   
    return immune_models[ent:GetModel()] == true
end

local rad_counter = {}

if (game.GetMap() == "rp_stardestroyer_v2_5_inf") then
    timer.Create("RadiationZone", 2, 0, function()
        local new_counter = {}
        for k, v in pairs(ents.FindInBox(Vector(-3811, -707, -4176), Vector(-6128, 691, -6086))) do
            if (v:IsPlayer()) then
                if not RADBOX:IsImmune(v) then
                    local counter = rad_counter[v:SteamID()] or 0
                    new_counter[v:SteamID()] = counter + 1
                    if counter < 5 then continue end
                    local dmg = DamageInfo()
                    dmg:SetDamage(math.random(10, counter * 2))
                    dmg:SetDamageType(DMG_RADIATION)
                    dmg:SetAttacker(v)
                    v:TakeDamageInfo(dmg)
                end
            end
        end
        rad_counter = table.Copy(new_counter)
    end)
end