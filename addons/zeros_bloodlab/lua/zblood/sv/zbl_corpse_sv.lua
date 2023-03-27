if CLIENT then return end
zbl = zbl or {}
zbl.f = zbl.f or {}

zbl.zbl_CorpseList = zbl.zbl_CorpseList or {}

// Adds a flask to the players internal list to keep track
function zbl.f.Corpse_Add(corpse)
    table.insert(zbl.zbl_CorpseList,corpse)
end

function zbl.f.Corpse_Remove(corpse)

    table.RemoveByValue(zbl.zbl_CorpseList,corpse)
end

function zbl.f.Corpse_Spawn(ply,vac_id,vac_stage)

    if not IsValid(ply) then return end

    local pos = ply:GetPos()
    local ang = ply:GetAngles()
    local model = ply:GetModel()

    local tr = util.TraceLine( {
        start = pos + Vector(0,0,50),
        endpos = pos - Vector(0,0,10000),
        mask = 81931, // Hit only the world + brushes please
    } )


    if tr and tr.Hit and tr.HitPos then

        //debugoverlay.Line(pos + Vector(0,0,50), tr.HitPos, 5, Color(0, 255, 0), false)

        pos = tr.HitPos
        ang = tr.HitNormal:Angle()
        ang:RotateAroundAxis(ang:Right(),-90)

        ang:RotateAroundAxis(ang:Up(),math.random(0,360))
    end

    local ent = ents.Create("zbl_corpse")
    ent:Spawn()
    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:Activate()

    ent:SetModel(model)

    // Play death animation
    local death_anims = {"death_01","death_02","death_03","death_04"}
    local sequence = death_anims[math.random(#death_anims)]
    zbl.f.PlayAnimation(ent,sequence, 1)

    // Play death idle animation delayed
    local seq_dur = ent:SequenceDuration(sequence)
    timer.Simple(seq_dur,function()
        if IsValid(ent) then
            sequence = zbl.config.Corpse.anim[math.random(#zbl.config.Corpse.anim)]
            zbl.f.PlayAnimation(ent,sequence, 1)
        end
    end)

    // Apply virus material if defined
    if zbl.config.Corpse.infection_visible then
        local vac_data = zbl.config.Vaccines[vac_id]
        if vac_data.mat then
            ent:SetMaterial(vac_data.mat)
        end
    end

    zbl.f.Corpse_Add(ent)

    ent:SetNWInt("zbl_Vaccine",vac_id)
    ent:SetNWInt("zbl_VaccineStage",vac_stage)

    ent:SetPlayerID(ply:AccountID())
    ent:SetPlayerName(ply:Nick())

    SafeRemoveEntityDelayed(ent,zbl.config.Corpse.life_time)

    return ent
end

function zbl.f.Corpse_OnRemove(corpse)
    if zbl.config.Corpse.ExplodeOnDespawn and CurTime() >= ((corpse:GetCreationTime() + zbl.config.Corpse.life_time) - 1) then

        local virus_id = corpse:GetNWInt("zbl_Vaccine",1)
        zbl.f.Infect_Proximity(virus_id,corpse:GetNWInt("zbl_VaccineStage",1), corpse:GetPos(), 200, 35)

        zbl.f.Ctmn_ProximityContaminate(corpse:GetPos(), 200, virus_id)
    end
    zbl.f.Corpse_Remove(corpse)
end
