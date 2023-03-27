ENT.Type 							=  "anim"
ENT.Spawnable		            	=	true
ENT.AdminSpawnable		            =	true

ENT.PrintName		                =	"Ammo Box"
ENT.Author			                =	"Venator / Gredwitch"
ENT.Category                        =	"Star Wars Emplacements"
ENT.Model                         	=	"models/markus/custom/gameplay/objects/weaponcrate/weaponcrate_01_mesh.mdl"

ENT.Opened							= 	false
ENT.NextUse							=	0
ENT.Life							=	300
ENT.CurLife							=	ENT.Life
ENT.Attacker						=	nil

ENT.ExplosionDamage					=	1000
ENT.ExplosionRadius					=	1000

ENT.ExplosionSound 					=	"explosions/cache_explode.wav"
ENT.FarExplosionSound 				=	"explosions/cache_explode_distant.wav"
ENT.DistExplosionSound 				=	"explosions/cache_explode_far_distant.wav"
ENT.AdminOnly						=	true
ENT.Editable						=	true
ENT.AutomaticFrameAdvance			= 	true

function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Invincible", {KeyName = "Invincible", Edit = { type = "Boolean", category = "Logistic"}})
	-- self:NetworkVar("Float",0,"Life")
	-- if SERVER then
		-- self:SetLife(self.Life)
	-- end
end