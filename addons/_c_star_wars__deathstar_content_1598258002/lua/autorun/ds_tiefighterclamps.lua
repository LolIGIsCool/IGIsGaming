-- Created by Oninoni

if game.GetMap() ~= "rp_deathstar" then return end

-- Number of Clamps
local clampCount = 18

-- Name used for the clamps. Followed by a number.
local clampName = "clamp"

if CLIENT then

end

if SERVER then
    hook.Add("Think", "TieFighterClamps.Think", function()
        for i=1, clampCount, 1 do
            local clampNameNumbered = clampName .. i
            local clamps =  ents.FindByName(clampNameNumbered)
            if #clamps ~= 1 then continue end
            local clamp = clamps[1]

            local angles = clamp:GetAngles()
            local up = angles:Up()
            local right = angles:Forward()
            local forward = -angles:Right()

            local translatedPos = clamp:GetPos() - up * 83
            local leftPos = translatedPos - right * 96
            local rightPos = translatedPos + right * 96

            local leftTrace = util.TraceLine({
                start = leftPos,
                endpos = leftPos - up * 20
            })

            local rightTrace = util.TraceLine({
                start = rightPos,
                endpos = rightPos - up * 20
            })

            if leftTrace.Hit and rightTrace.Hit then
                if IsValid(leftTrace.Entity) and leftTrace.Entity:GetClass() == "tie_ln_fighter" and IsValid(rightTrace.Entity) and rightTrace.Entity:GetClass() == "tie_ln_fighter" and leftTrace.Entity == rightTrace.Entity then
                    local tieFighter = leftTrace.Entity

                    if not clamp.Closed then
                        if not tieFighter.Inflight then
                            tieFighter:GetPhysicsObject():EnableMotion(false)

                            clamp.Closed = true
                            clamp:Fire("setanimation", "close")

                            tieFighter:ResetSequence(tieFighter:LookupSequence("TopOpen"))

                            local pilots = ents.FindInBox(translatedPos - Vector(150, 150, 100), translatedPos + Vector(150, 150, 50))
                            for _, ply in pairs(pilots) do
                                if IsValid(ply) and ply:IsPlayer() then
                                    local exitPos = clamp:GetAttachment(clamp:LookupAttachment("exit")).Pos

                                    ply:SetPos(exitPos)
                                end
                            end
                        end
                    else
                        if tieFighter.Inflight then
                            clamp.Closed = false
                            clamp:Fire("setanimation", "open")

                            tieFighter:ResetSequence(tieFighter:LookupSequence("TopClose"))
                        end
                    end

                    continue
                end
            end

            if clamp.Closed or clamp.Closed == nil then
                clamp.Closed = false
                clamp:Fire("setanimation", "open")
            end
        end
    end)
end