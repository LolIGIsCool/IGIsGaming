
AddCSLuaFile("cl_init.lua") -- This one is still wack
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/hunter/blocks/cube1x1x025.mdl")

    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType( MOVETYPE_NONE )
    self:PhysicsInitStatic(SOLID_VPHYSICS)

    self:SharedInit()
end


function ENT:Think()

    local pos = self:GetPos()
    local radS = self:GetCaptureRange()*self:GetCaptureRange()

    local rate = 1

    local count = 0

    for index, ply in ipairs(player.GetHumans()) do
        if ply:GetPos():DistToSqr(pos) < radS then
            count = count + 1
        end
    end

    local val = self:GetCaptureValue()

    local max = self:GetMaxCaptureValue()

    if val == max then
        if not self.Captured then
            self.Captured = true
            hook.Call("wOS.PES.CapturePoint.Captured", nil, self)
            self:NextThink(CurTime() + 30)
            return true
            -- Emit a hook?
        end
        return true
    end

    if count == 0 then
        self:SetCaptureValue( math.max(0, val - rate))
    else
        self:SetCaptureValue( math.min(max, val + rate*count))
    end

    self:NextThink(CurTime() + 1)
    return true
end
