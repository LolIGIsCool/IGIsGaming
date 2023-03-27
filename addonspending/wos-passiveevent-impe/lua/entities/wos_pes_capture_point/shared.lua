ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.PrintName		= "PES Capture Point"
ENT.Author			= "Oliver (wiltOS)"
ENT.Purpose			= "N/A"

ENT.RenderGroup     = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "CaptureValue")
    self:NetworkVar("Float", 1, "MaxCaptureValue")
    self:NetworkVar("Float", 2, "CaptureRange")

    if SERVER then
        self:SetCaptureValue(0)
        self:SetMaxCaptureValue(10)
        self:SetCaptureRange(60)
    end
end

function ENT:SharedInit()
    local phys = self:GetPhysicsObject()
    if ( IsValid( phys ) ) then
        phys:EnableMotion( false )
        phys:EnableDrag( false )
        phys:EnableGravity( false )
        phys:Sleep()

        phys:AddGameFlag(FVPHYSICS_CONSTRAINT_STATIC)
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
        phys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
        phys:AddGameFlag(FVPHYSICS_NO_PLAYER_PICKUP)
        phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
    end

    self:AddEffects(EF_NORECEIVESHADOW)
    self:AddEffects(EF_NOINTERP)

    self:AddFlags(FL_STATICPROP)
    self:AddFlags(FL_DONTTOUCH)

    self:AddEFlags(EFL_NO_DAMAGE_FORCES)
    self:AddEFlags(EFL_NO_GAME_PHYSICS_SIMULATION)
    self:AddEFlags(EFL_NO_DISSOLVE)
    self:AddEFlags(EFL_NO_MEGAPHYSCANNON_RAGDOLL)
    self:AddEFlags(EFL_NO_PHYSCANNON_INTERACTION)
    self:AddEFlags(EFL_NO_ROTORWASH_PUSH)
    self:AddEFlags(EFL_NO_WATER_VELOCITY_CHANGE)
end
