if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "proj_drg_default"

-- Misc --
-- ENT.Models = {"models/spitball_medium.mdl"}
ENT.PrintName = "Dilophosaurus Spit"
ENT.Category = "Jurassic Park"
ENT.AdminOnly = true
ENT.Spawnable = false
ENT.Parent = nil

-- Physics --
ENT.Gravity = true
ENT.Physgun = false
ENT.Gravgun = false

-- Contact --
ENT.OnContactDecals = {"YellowBlood"}


if SERVER then
	AddCSLuaFile()
	function ENT:CustomInitialize()
	ParticleEffectAttach("antlion_spit_player_splat", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("blood_advisor_shrapnel_impact", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("blood_advisor_shrapnel_spray_1", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("blood_advisor_shrapnel_spray_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("blood_advisor_shrapnel_spurt_1", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	ParticleEffectAttach("blood_advisor_shrapnel_spurt_2", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	-- self:DynamicLight(Color(150, 255, 0), 300, 0.1)
	-- self:DrawShadow(true)
	self:SetCollisionBounds(Vector(1, 1, 1), Vector(-1, -1, 0))
end

function ENT:OnContact(ent)
	self:EmitSound("bryanjp19/dilo/splat"..math.random(1,2)..".wav")
	self:RadiusDamage(25, DMG_POISON, 120)
	ParticleEffect("GrubSquashBlood", self:GetPos(), Angle(0,0,0), nil)
	ParticleEffect("blood_impact_green_01_droplets", self:GetPos(), Angle(0,0,0), nil)
	-- if (ent:IsPlayer()) then
		-- ent:ScreenFade(SCREENFADE.IN,Color(0,3,1,255),2.0,10.0)
		-- ent:ScreenFade(SCREENFADE.IN,Color(0,1,3,254),15.0,20.0)
		-- self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
	-- end
	self:Remove()
	end
end