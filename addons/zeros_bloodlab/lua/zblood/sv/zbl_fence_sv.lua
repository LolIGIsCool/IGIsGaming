if CLIENT then return end
zbl = zbl or {}
zbl.f = zbl.f or {}


function zbl.f.Fence_Initialize(Fence)
    zbl.f.EntList_Add(Fence)
end

function zbl.f.Fence_OnUse(Fence,ply)

    if zbl.config.Fence.unfold == false then return end

    if not ((ply:GetRegiment() == "439th Medical Company") or (ply:IsAdmin()) or (ply:IsEventMaster())) then
        return
    end

    Fence:SetTurnedOn(not Fence:GetTurnedOn())

    zbl.f.Fence_ToggleState(Fence)
end

function zbl.f.Fence_Trace(Fence,left)
    local tr_start = Fence:GetPos() + Fence:GetUp() * 25
    local tr_end

    if left then
        tr_end = tr_start + Fence:GetRight() * zbl.config.Fence.length
    else
        tr_end = tr_start - Fence:GetRight() * zbl.config.Fence.length
    end

    local tr = util.TraceLine({
        start = tr_start,
        endpos = tr_end,
        filter = Fence,
        //mask = 81931
    })

    if tr.Hit and tr.HitWorld and tr.HitPos then
        debugoverlay.Line(tr_start, tr.HitPos, 5, Color(0, 255, 0), true)

        return Fence:GetPos():Distance(tr.HitPos)
    else
        debugoverlay.Line(tr_start, tr_end, 5, Color(0, 255, 0), true)

        return zbl.config.Fence.length
    end
end

function zbl.f.Fence_ToggleState(Fence)

    DropEntityIfHeld( Fence )

    local ang = Fence:GetAngles()
    Fence:SetAngles(Angle(0,ang.y,0))

    Fence:DropToFloor()

    if Fence:GetTurnedOn() then
        Fence.PhysgunDisabled = true

        ang = Fence:GetAngles()

        local left_pos = (Fence:GetPos() - Fence:GetUp() * 1) + Fence:GetRight() * zbl.f.Fence_Trace(Fence,true)
        local left_dir =  left_pos - Fence:GetPos()
        local left_look = Angle(ang.p,left_dir:Angle().y,ang.r)
        Fence.PointLeft = zbl.f.Fence_CreateEndPoint(Fence,left_pos,left_look,true)
        Fence:SetLeftWall(Fence.PointLeft)

        local right_pos = (Fence:GetPos() - Fence:GetUp() * 1) - Fence:GetRight() * zbl.f.Fence_Trace(Fence,false)
        local right_dir =  right_pos - Fence:GetPos()
        local right_look = Angle(ang.p,right_dir:Angle().y,ang.r)
        Fence.PointRight = zbl.f.Fence_CreateEndPoint(Fence,right_pos,right_look,false)
        Fence:SetRightWall(Fence.PointRight)
    else

        Fence.PhysgunDisabled = false

        if IsValid(Fence.PointRight) then
            SafeRemoveEntity(Fence.PointRight)
        end

        if IsValid(Fence.PointLeft) then
            SafeRemoveEntity(Fence.PointLeft)
        end
    end
end


function zbl.f.Fence_CreateEndPoint(Fence, pos, ang, isleft)
    local ent = ents.Create("zbl_fence_end")
    ang:RotateAroundAxis(ang:Up(),-90)

    ent:SetPos(pos)
    ent:SetAngles(ang)
    ent:SetMain(Fence)
    ent:SetIsLeft(isleft)
    ent:Spawn()
    ent:Activate()
    Fence:DeleteOnRemove(ent)
    ent:SetParent(Fence)
    return ent
end

function zbl.f.Fence_OnDamage(Fence, dmginfo)
    local damage = dmginfo:GetDamage()
    local entHealth = zbl.config.Fence.health

    if entHealth > 0 then

        Fence.CurrentHealth = (Fence.CurrentHealth or entHealth) - damage

        if Fence.CurrentHealth <= 0 then

            if IsValid(Fence:GetLeftWall()) then
                zbl.f.Destruct(Fence:GetLeftWall():GetPos(), "HelicopterMegaBomb")
            end

            if IsValid(Fence:GetRightWall()) then
                zbl.f.Destruct(Fence:GetRightWall():GetPos(), "HelicopterMegaBomb")
            end

            zbl.f.Destruct(Fence:GetPos(), "HelicopterMegaBomb")

            SafeRemoveEntity(Fence)
        end
    end
end

function zbl.f.Fence_OnRemove(Fence)
end


function zbl.f.Fence_SpamCheck(Fence,other)
    if other.zbl_LastFenceScan and other.zbl_LastFenceScan < CurTime() then
        other.zbl_LastScanCount = 0
    end

    other.zbl_LastScanCount = (other.zbl_LastScanCount or 0) + 1
    other.zbl_LastFenceScan = CurTime() + 10

    // Does the player spamm this machine
    if other.zbl_LastScanCount and other.zbl_LastScanCount >= 5 then

        // Punish
        other.zbl_LastScanCount = 0

        return true
    else
        return false
    end
end

function zbl.f.Fence_ShockPlayer(Fence,ply,minge)
    local d = DamageInfo()
    d:SetDamage(zbl.config.Fence.dmg_per_touch)
    if minge then
        d:ScaleDamage(5)
    end
    if ply:GetActiveWeapon() and ply:GetActiveWeapon() == "climb_swep2" then
        d:ScaleDamage(10)
    end
    d:SetAttacker(Fence)
    d:SetDamageForce(ply:GetPos() + ply:GetUp() * 15)
    d:SetDamagePosition(ply:GetPos() + Vector(0,0,50))
    d:SetDamageType(DMG_SHOCK)
    ply:TakeDamageInfo(d)

    zbl.f.CreateNetEffect("player_shock",ply)
end

function zbl.f.Fence_OnStartTouch(Fence,other)

    if Fence:GetScanResult() ~= -1 then return end
    if not IsValid(other) then return end
    if not other:IsPlayer() then return end
    if not other:Alive() then return end

    if zbl.config.Fence.AntiSpam == true and zbl.f.Fence_SpamCheck(Fence,other) then

        Fence:EmitSound("zbl_gate_punish")

        Fence:SetScanResult(3)

        timer.Simple(2,function()
            if IsValid(other) and other:Alive() and IsValid(Fence) then

                Fence:EmitSound("zbl_gate_cauterize")

                timer.Simple(1, function()
                    if IsValid(other) and other:Alive() and IsValid(Fence) then

                        zbl.f.Fence_ShockPlayer(Fence,other,true)

                        local effectdata = EffectData()
                        effectdata:SetOrigin(Fence:GetPos() + Vector(0,0,50))
                        effectdata:SetMagnitude(100)
                        effectdata:SetStart(other:GetPos() + Vector(0,0,50))
                        effectdata:SetScale(25)
                        effectdata:SetRadius(100)
                        util.Effect("tooltracer", effectdata)

                        Fence:SetScanResult(-1)

                    elseif IsValid(Fence) then
                        Fence:SetScanResult(-1)
                    end
                end)

            elseif IsValid(Fence) then

                Fence:SetScanResult(-1)
            end
        end)
    else

        if zbl.config.Fence.contaminate == true and zbl.f.OV_IsContaminated(other) then

			zbl.f.Player_ForceCure(other)

            zbl.f.CreateNetEffect("fence_disinfect",Fence)

            Fence:SetScanResult(2)

            timer.Simple(0.35, function()
                if IsValid(Fence) then
                    Fence:EmitSound("zbl_gate_sterilize")
                end
            end)
        else
            if zbl.f.Player_IsInfected(other) then
                Fence:EmitSound("zbl_gate_scan_bad")

                timer.Simple(0.35, function()
                    if IsValid(Fence) then
                        Fence:EmitSound("zbl_gate_scan_infection")
                    end
                end)

                Fence:SetScanResult(0)
            else
                Fence:EmitSound("zbl_gate_scan_good")

                Fence:SetScanResult(1)
            end
        end

        hook.Run("zbl_OnPlayerFenceScanned", other, Fence)

        timer.Simple(1,function()
            if IsValid(Fence) then
                Fence:SetScanResult(-1)
            end
        end)
    end
end
