-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "obj_vj_grenade_rifle"
ENT.PrintName		= "Rifle Grenade"
ENT.Author 			= "Zippy"
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.RadiusDamage = 40

local trail_lifetime = 1.5
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
    self:SetNoDraw(true)

    self.grenadeprop = ents.Create("prop_dynamic")
    self.grenadeprop:SetModel("models/weapons/ar2_grenade.mdl")
    self.grenadeprop:SetPos(self:GetPos())
    self.grenadeprop:SetAngles(self:GetAngles())
    self.grenadeprop:SetParent(self)
    self.grenadeprop:Spawn()

    util.SpriteTrail(self.grenadeprop, 0, Color(255,0,0), true, 12, 0, trail_lifetime, 0.008, "trails/laser")
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
    self.grenadeprop:SetAngles(self:GetVelocity():Angle())
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DeathEffects()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetScale( 1.4 )
	util.Effect( "vjks_sw_effect_explosion_big", effectdata )
	--util.Effect( "vj_small_explosion1", effectdata )
	util.Effect( "ManhackSparks", effectdata )
	util.Effect( "ManhackSparks", effectdata )
	util.Effect( "ManhackSparks", effectdata )
	util.Effect( "Explosion", effectdata )
	--util.Effect( "cball_explode", effectdata )
	util.Effect( "ThumperDust", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self:GetPos())
	self.ExplosionLight1:SetLocalAngles( self:GetAngles() )
	self.ExplosionLight1:Fire("Color", "255 150 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	self:SetLocalPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the entity is too close to the ground
	local tr = util.TraceLine({
	start = self:GetPos(),
	endpos = self:GetPos() - Vector(0, 0, 100),
	filter = self })
	util.Decal(VJ_PICK(self.DecalTbl_DeathDecals),tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
	
	self:DoDamageCode()
	self:SetDeathVariablesTrue(nil,nil,false)
	self:Remove()
end