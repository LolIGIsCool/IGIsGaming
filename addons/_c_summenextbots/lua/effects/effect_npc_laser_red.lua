TRACER_FLAG_USEATTACHMENT = 0x0002
SOUND_FROM_WORLD = 0
CHAN_STATIC = 6

EFFECT.Speed = 6500
EFFECT.Length = 64
EFFECT.WhizDistance = 72

local MaterialMain = Material("effects/sw_laser_red_main")
local MaterialFront = Material("effects/sw_laser_red_front")
local MaterialGlow = Material("sprites/light_glow02_add")
local ColorRed = Color(255, 0, 0)

function EFFECT:GetTracerOrigin(data)
    local start = data:GetStart()

    if (bit.band(data:GetFlags(), TRACER_FLAG_USEATTACHMENT) == TRACER_FLAG_USEATTACHMENT) then
        local entity = data:GetEntity()

        if (not IsValid(entity)) then
            return start
        end
        if (not game.SinglePlayer() and entity:IsEFlagSet(EFL_DORMANT)) then
            return start
        end

        if (entity:IsWeapon() and entity:IsCarriedByLocalPlayer()) then
            local pl = entity:GetOwner()
            if (IsValid(pl)) then
                local vm = pl:GetViewModel()
                if (IsValid(vm) and not LocalPlayer():ShouldDrawLocalPlayer()) then
                    entity = vm
                else
                    if (entity.WorldModel) then
                        entity:SetModel(entity.WorldModel)
                    end
                end
            end
        end

        local attachment = entity:GetAttachment(data:GetAttachment())
        if (attachment) then
            start = attachment.Pos
        end
    end

    return start
end

function EFFECT:Init(data)
    self.StartPos = self:GetTracerOrigin(data)
    self.EndPos = data:GetOrigin()

    self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

    local diff = (self.EndPos - self.StartPos)

    self.Normal = diff:GetNormal()
    self.StartTime = 0
    self.LifeTime = (diff:Length() + self.Length) / self.Speed

    local weapon = data:GetEntity()
    if (IsValid(weapon) and (not weapon:IsWeapon() or not weapon:IsCarriedByLocalPlayer())) then
        local dist, pos, time = util.DistanceToLine(self.StartPos, self.EndPos, EyePos())
    end
end

function EFFECT:Think()
    self.LifeTime = self.LifeTime - FrameTime()
    self.StartTime = self.StartTime + FrameTime()

    return self.LifeTime > 0
end

function EFFECT:Render()
    local endDistance = self.Speed * self.StartTime
    local startDistance = endDistance - self.Length

    startDistance = math.max(0, startDistance)
    endDistance = math.max(0, endDistance)

    local startPos = self.StartPos + self.Normal * startDistance
    local endPos = self.StartPos + self.Normal * endDistance

    render.SetMaterial(MaterialFront)
    render.DrawSprite(endPos, 8, 8, color_white)

    render.SetMaterial(MaterialMain)
    render.DrawBeam(startPos, endPos, 10, 0, 1, color_white)

    render.SetMaterial(MaterialGlow)
    render.DrawSprite(startPos, 50, 50, ColorRed)
end
