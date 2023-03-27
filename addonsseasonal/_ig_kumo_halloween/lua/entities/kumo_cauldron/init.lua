AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/zerochain/props_halloween/witchcauldron.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_IDLE)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetMaxYawSpeed(90)
    self:DropToFloor()
    self:SetTrigger(true)
end
local lasttime = 0
function ENT:Think()
    if lasttime > CurTime() then return end
    lasttime = CurTime() + math.random(120,600)
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetOrigin( vPoint )
    effectdata:SetMagnitude(0)
    util.Effect( "VortDispel", effectdata )
end

function ENT:Touch(ent)
    if ent:GetClass() == "kumo_spookitem" then
        timer.Simple(0.01, function()
            ParticleEffectAttach("mortar_burst_halloween_demon", PATTACH_POINT, self, 2)
            local vPoint = self:GetPos()
            local effectdata = EffectData()
            effectdata:SetOrigin( vPoint )
            effectdata:SetMagnitude(0)
            util.Effect( "VortDispel", effectdata )
        end)

        sound.Play("fireworks/mortar_fire.wav", self:GetPos(), 75, 100, 1)
        local playerr = ent.lasttouch
        if playerr:GetNWString("halloweenteam", "none") ~= "none" then
        	IGHALLOWEEN:UpdatePoints(playerr:GetNWString("halloweenteam", "none"), 10,playerr,"collecting a cauldron item")
    	end
        timer.Remove("despawn" .. ent:EntIndex())
        ent:Remove()
    end
end

function ENT:AcceptInput(strName, activator, caller)
    if (strName == "Use" and caller:IsPlayer() and caller:Alive() and caller:GetPos():Distance(self:GetPos()) < 75 and caller:GetEyeTrace().Entity == self and caller:GetNWString("halloweenteam", "none") == "none") then
        net.Start("OpenHalloweenChooser")
        net.Send(caller)
    end
end