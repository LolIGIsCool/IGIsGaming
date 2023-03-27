AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/npc_sw_gempire/misc_building_hqtent.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 1200
ENT.vj_doi_isteam = "Axis"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GERMAN"} -- NPCs with the same class with be allied to each other

-- Tank Base
ENT.Tank_GunnerENT = "npc_vj_mili_tiger_redg"
ENT.Tank_SpawningAngle = 0
ENT.Tank_CollisionBoundSize = 52
ENT.Tank_CollisionBoundUp = 105
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_ForwardSpead = 0 -- Forward speed
ENT.Tank_MoveAwaySpeed = 0 -- Move away speed
ENT.Tank_UseGetRightForSpeed = false -- Should it use GetRight instead of GetForward when driving?
ENT.Tank_SeeClose = 600 -- If the enemy is closer than this number, than move!
ENT.Tank_DeathSoldierModels = {"models/VJ_WAFFEN/german_soldier1.mdl","models/VJ_WAFFEN/german_soldier2.mdl","models/VJ_WAFFEN/german_soldier3.mdl","models/VJ_WAFFEN/german_soldier4.mdl","models/VJ_WAFFEN/german_soldier5.mdl","models/VJ_WAFFEN/german_soldier6.mdl"}

ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false
ENT.DisableFindEnemy = true
ENT.PlayerFriendly = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE 
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.Passive_RunOnTouch = false
ENT.Passive_RunOnDamage = false
ENT.ConstantlyFaceEnemy = false
ENT.ConstantlyFaceEnemy_IfVisible = false
ENT.ConstantlyFaceEnemy_IfAttacking = false
ENT.DisableSelectSchedule = true
ENT.DisableTakeDamageFindEnemy = true 
ENT.DisableTouchFindEnemy = true 
ENT.DisableMakingSelfEnemyToNPCs = true 
ENT.BringFriendsOnDeath = false
ENT.CallForBackUpOnDamage = false 
ENT.MoveOrHideOnDamageByEnemy = false 
ENT.Immune_AcidPoisonRadiation = false
ENT.Immune_Bullet = false

--CUSTOM SPAWNER

ENT.Spawner_CanSpawn = true
ENT.Spawner_RunCodeNextT = 0
ENT.Spawner_RunCodenexttime = 1
--ENT.Spawner_RangeCheck_activated = 0
--ENT.Spawner_RangeCheck_NextT = 0
--ENT.Spawner_RangeCheck_nexttime = 0

ENT.Spawner_Spawntime_min = 4
ENT.Spawner_Spawntime_max = 6
ENT.Spawner_Spawntime_bonustime = 3 --When soldiers alive is more than half of max soldier
ENT.Spawner_Spawntime_NextT = 0


ENT.Spawner_Actorlimit = 6 -- include the "special" actor
--ENT.Spawner_Actortablelist = {{Entityclass="npc_doi_german_waffen_shutze",Weaponclass="weapon_doi_german_g43"}, --Put "none" in Weaponclass for no weapon
--						{Entityclass="npc_doi_german_waffen_shutze",Weaponclass="weapon_doi_german_g43"},
--						{Entityclass="npc_doi_german_waffen_shutze",Weaponclass="weapon_doi_german_stg44"},
	--					{Entityclass="npc_doi_german_waffen_leader",Weaponclass="weapon_doi_german_stg44"},
--						{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_g43"}
--						}

ENT.Spawner_SpecialActorlimit = 1 --The spawner will prioritize filling the "special" type actor before doing the normal ones -- Put zero to not have "special" actor
ENT.Spawner_SpecialActorNextT = 0
ENT.Spawner_SpecialActorNexttime = 4 --Timer to spawn special actor again, overridden by the normal timer
--ENT.Spawner_SpecialActortablelist = {{Entityclass="npc_doi_german_heer_engineer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_engineer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_waffen_sniper",Weaponclass="weapon_doi_german_g43sniper"}
--						}
--ENT.Spawner_SpawnPositionTbl = {Vector(-27,-81,12),Vector(26,-81,12)} --Local to World
--ENT.Spawner_SpawnPositionCheckRadius = 30

--ENT.Spawner_EnemyCheckRadius = 5000
ENT.Spawner_EnemyCheckNextT = 0
ENT.Spawner_EnemyCheckNexttime = 5
ENT.Spawner_EnemyFound = NULL

--ENT.Prop_table = {{Model="models/npc_doi/misc_building_gercrate01.mdl",Pos=Vector(57,42,0),Ang=Angle(0,0,0)},{Model="models/npc_doi/misc_building_gercrate02.mdl",Pos=Vector(61,-36,0),Ang=Angle(0,0,0)}}

ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
ENT.SoundTbl_SpawnEntity = {}
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch1 = 80
ENT.SpawnEntitySoundPitch2 = 100
	-- Independent Variables ------


---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() +self:GetUp()*92 +self:GetRight()*-20
end
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:CustomOnInitialize()

	self:PhysicsInit(SOLID_BBOX) // SOLID_VPHYSICS
	self:SetSolid(SOLID_BBOX)
	self:SetAngles(self:GetAngles()+Angle(0,self.Tank_SpawningAngle,0))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, -10))
	self:CustomInitialize_CustomTank()
	self.Spawner_SpawnPositionTbl = {Vector(-27,-91,12),Vector(26,-91,12)}
	self.Spawner_Actortablelist = {{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"}, --Put "none" in Weaponclass for no weapon
						{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"},
						{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"},
						{Entityclass="npc_swbfimp_stormcaptain",Weaponclass="weapon_swbfimp_e11"},
						{Entityclass="npc_swbfimp_stormgunner",Weaponclass="weapon_swbfimp_dlt19"},
						{Entityclass="npc_swbfimp_scofficer",Weaponclass="weapon_swbfimp_se14r"},
						{Entityclass="npc_swbfimp_scofficer",Weaponclass="weapon_swbfimp_se14r"},
						{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"}
						}
	self.Spawner_SpecialActortablelist = {{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"},
						{Entityclass="npc_swbfimp_stormtrooper",Weaponclass="weapon_swbfimp_e11"}
						}
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(30000)
	end

	self.Gunner = ents.Create("prop_dynamic")
	self.Gunner:SetModel("models/npc_doi/misc_building_gercrate01.mdl")
	self.Gunner:SetPos(self:Tank_GunnerSpawnPosition())
	self.Gunner:SetAngles(self:GetAngles())
	self.Gunner:Spawn()
	self.Gunner:SetParent(self)
	self.Gunner:SetNoDraw(true)
	
	self:SetSkin( 0 )
	
	//self:DropToFloor()

end
---------------------------------------------------------------------------------------------------------------------------------------------

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/