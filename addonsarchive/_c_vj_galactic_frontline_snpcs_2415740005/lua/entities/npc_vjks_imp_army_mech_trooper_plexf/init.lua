if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("vj_base/npc_general.lua")
include("vj_base/npc_schedules.lua")
include("vj_base/npc_movetype_aa.lua")
include("shared.lua")
/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
	INFO: Used as a base for human SNPCs.
--------------------------------------------------*/
AccessorFunc(ENT,"m_iClass","NPCClass",FORCE_NUMBER)
AccessorFunc(ENT,"m_fMaxYawSpeed","MaxYawSpeed",FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/KriegSyntax/imperial/army/army_trooper_mech/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = ("95")
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- This is mostly used for massive or boss SNPCs, it affects certain part of the SNPC, for example the SNPC won't receive any knock back
	-- ====== Collision / Hitbox Variables ====== --
ENT.HullType = HULL_SMALL
ENT.HasHull = false -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
	-- ====== Sight & Speed Variables ====== --
ENT.SightDistance = 1000000 -- How far it can see
ENT.SightAngle = 80 -- The sight angle | Example: 180 would make the it see all around it | Measured in degrees and then converted to radians
ENT.TurningSpeed = 20 -- How fast it can turn
	-- ====== Movement Variables ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.CanTurnWhileStationary = true -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
	-- ====== Miscellaneous Variables ====== --
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
ENT.AllowPrintingInChat = false -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
	-- Common Classes: Combine = CLASS_COMBINE || Zombie = CLASS_ZOMBIE || Antlions = CLASS_ANTLION || Xen = CLASS_XEN || Player Friendly = CLASS_PLAYER_ALLY
ENT.FriendsWithAllPlayerAllies = true -- Should this SNPC be friends with all other player allies that are running on VJ Base?
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE -- Doesn't attack anything
	-- VJ_BEHAVIOR_AGGRESSIVE = Default behavior, attacks enemies || VJ_BEHAVIOR_NEUTRAL = Neutral to everything, unless provoked
	-- VJ_BEHAVIOR_PASSIVE = Doesn't attack, but can attacked by others || VJ_BEHAVIOR_PASSIVE_NATURE = Doesn't attack and is allied with everyone
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.NextMoveOutOfFriendlyPlayersWayTime = 1 -- How much time until it can moves out of the player's way?
ENT.BecomeEnemyToPlayer = false -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 2 -- How many times does the player have to hit the SNPC for it to become enemy?
	-- ====== Old Variables (Can still be used, but it's recommended not to use them) ====== --
ENT.VJ_FriendlyNPCsSingle = {}
ENT.VJ_FriendlyNPCsGroup = {}
ENT.PlayerFriendly = true -- Makes the SNPC friendly to the player and HL2 Resistance
	-- ====== Passive Behavior Variables ====== --
ENT.Passive_RunOnTouch = true -- Should it run away and make a alert sound when something collides with it?
ENT.Passive_NextRunOnTouchTime1 = 3 -- How much until it can run away again when something collides with it? | First # in the math.Rand
ENT.Passive_NextRunOnTouchTime2 = 4 -- How much until it can run away again when something collides with it? | Second # in the math.Rand
ENT.Passive_RunOnDamage = true -- Should it run when it's damaged? | This doesn't impact how self.Passive_AlliesRunOnDamage works
ENT.Passive_AlliesRunOnDamage = true -- Should its allies (other passive SNPCs) also run when it's damaged?
ENT.Passive_AlliesRunOnDamageDistance = 800 -- Any allies within this distance will run when it's damaged
ENT.Passive_NextRunOnDamageTime1 = 6 -- How much until it can run the code again? | First # in the math.Rand
ENT.Passive_NextRunOnDamageTime2 = 7 -- How much until it can run the code again? | Second # in the math.Rand
	-- ====== On Player Sight Variables ====== --
ENT.HasOnPlayerSight = false -- Should do something when it sees the enemy? Example: Play a sound
ENT.OnPlayerSightDistance = 200 -- How close should the player be until it runs the code?
ENT.OnPlayerSightDispositionLevel = 1 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.OnPlayerSightOnlyOnce = true -- Should it only run the code once?
ENT.OnPlayerSightNextTime1 = 15 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.OnPlayerSightNextTime2 = 20 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Call For Help Variables ====== --
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 2000 -- -- How far away the SNPC's call for help goes | Counted in World Units
ENT.NextCallForHelpTime = 4 -- Time until it calls for help again
ENT.HasCallForHelpAnimation = true -- if true, it will play the call for help animation
ENT.AnimTbl_CallForHelp = {"ks_signal_rally","ks_signal_laylow"} -- Call For Help Animations
ENT.CallForHelpAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.CallForHelpAnimationPlayBackRate = 0.5 -- How fast should the animation play? | Currently only for gestures!
ENT.CallForHelpStopAnimations = true -- Should it stop attacks for a certain amount of time?
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForHelpStopAnimationsTime = false -- How long should it stop attacks?
ENT.CallForHelpAnimationFaceEnemy = true -- Should it face the enemy when playing the animation?
ENT.NextCallForHelpAnimationTime = 30 -- How much time until it can play the animation again?
	-- ====== Medic Variables ====== --
ENT.IsMedicSNPC = false -- Is this SNPC a medic? Does it heal other friendly friendly SNPCs, and players(If friendly)
ENT.AnimTbl_Medic_GiveHealth = {"ks_signal_forward"} -- Animations is plays when giving health to an ally
ENT.Medic_CheckDistance = 600 -- How far does it check for allies that are hurt? | World units
ENT.Medic_HealDistance = 100 -- How close does it have to be until it stops moving and heals its ally?
ENT.Medic_HealthAmount = 25 -- How health does it give?
ENT.Medic_NextHealTime1 = 10 -- How much time until it can give health to an ally again | First number in the math.random
ENT.Medic_NextHealTime2 = 15 -- How much time until it can give health to an ally again | Second number in the math.random
ENT.Medic_SpawnPropOnHeal = true -- Should it spawn a prop, such as small health vial at a attachment when healing an ally?
ENT.Medic_SpawnPropOnHealModel = "models/healthvial.mdl" -- The model that it spawns
ENT.Medic_SpawnPropOnHealAttachment = "anim_attachment_LH" -- The attachment it spawns on
	-- ====== Follow Player Variables ====== --
	-- Will only follow a player that's friendly to it!
ENT.FollowPlayer = false -- Should the SNPC follow the player when the player presses a certain key?
ENT.FollowPlayerChat = true -- Should the SNPCs say things like "Blank stopped following you" | self.AllowPrintingInChat overrides this variable!
ENT.FollowPlayerKey = "Use" -- The key that the player presses to make the SNPC follow them
ENT.FollowPlayerCloseDistance = 150 -- If the SNPC is that close to the player then stand still until the player goes farther away
ENT.NextFollowPlayerTime = 1 -- Time until it runs to the player again
	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {ACT_IDLE_SMG1_RELAXED} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.DisableChasingEnemy = false -- Disables the SNPC chasing the enemy
	-- ====== Constantly Face Enemy Variables ====== --
ENT.ConstantlyFaceEnemy = true -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = false -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Both" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing
ENT.ConstantlyFaceEnemyDistance = 2500 -- How close does it have to be until it starts to face the enemy?
	-- ====== Pose Parameter Variables ====== --
ENT.HasPoseParameterLooking = true -- Does it look at its enemy using poseparameters?
ENT.PoseParameterLooking_InvertPitch = false -- Inverts the pitch poseparameters (X)
ENT.PoseParameterLooking_InvertYaw = false -- Inverts the yaw poseparameters (Y)
ENT.PoseParameterLooking_InvertRoll = false -- Inverts the roll poseparameters (Z)
ENT.PoseParameterLooking_TurningSpeed = 10 -- How fast does the parameter turn?
ENT.PoseParameterLooking_Names = {pitch={},yaw={},roll={}} -- Custom pose parameters to use, can put as many as needed
	-- ====== Sound Detection Variables ====== --
ENT.InvestigateSoundDistance = 9 -- How far away can the SNPC hear sounds? | This number is timed by the calculated volume of the detectable sound.
	-- ====== Control Variables ====== --
	-- Use these variables very careful! One wrong change can mess up the whole SNPC!
ENT.FindEnemy_UseSphere = false -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.FindEnemy_CanSeeThroughWalls = false -- Should it be able to see through walls and objects? | Can be useful if you want to make it know where the enemy is at all times
ENT.DisableFindEnemy = false -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = false -- Disables Schedule code, Custom Schedule can still work
ENT.DisableTakeDamageFindEnemy = false -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = false -- Disable the SNPC finding the enemy when being touched
ENT.DisableMakingSelfEnemyToNPCs = false -- Disables the "AddEntityRelationship" that runs in think
ENT.LastSeenEnemyTimeUntilReset = 15 -- Time until it resets its enemy if its current enemy is not visible
ENT.NextProcessTime = 1 -- Time until it runs the essential part of the AI, which can be performance heavy!
	-- ====== Miscellaneous Variables ====== --
ENT.DisableInitializeCapabilities = false -- If enabled, all of the Capabilities will be disabled, allowing you to add your own
ENT.AttackTimersCustom = {}
ENT.DistanceToRunFromEnemy = 150 -- When the enemy is this close, the SNPC will back away | Put to 0, to never back away
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Damaged / Injured Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Blood-Related Variables ====== --
ENT.Bleeds = false -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
	-- Types: "Red" || "Yellow" || "Green" || "Orange" || "Blue" || "Purple" || "White" || "Oil"
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.CustomBlood_Particle = {} -- Particles to spawn when it's damaged
ENT.CustomBlood_Decal = {} -- Decals to spawn when it's damaged
ENT.CustomBlood_Pool = {} -- Blood pool types after it dies
ENT.BloodPoolSize = "Normal" -- What's the size of the blood pool?
	-- Sizes: "Normal" || "Small" || "Tiny"
ENT.BloodDecalUseGMod = false -- Should use the current default decals defined by Garry's Mod? (This only applies for certain blood types only!)
ENT.BloodDecalDistance = 300 -- How far the decal can spawn in world units
	-- ====== Immunity Variables ====== --
ENT.GodMode = false -- Immune to everything
ENT.Immune_AcidPoisonRadiation = false -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = false -- Immune to bullet type damages
ENT.Immune_Blast = false -- Immune to explosive-type damages
ENT.Immune_Dissolve = false -- Immune to dissolving | Example: Combine Ball
ENT.Immune_Electricity = false -- Immune to electrical-type damages | Example: shock or laser
ENT.Immune_Fire = false -- Immune to fire-type damages
ENT.Immune_Melee = false -- Immune to melee-type damage | Example: Crowbar, slash damages
ENT.Immune_Physics = false -- Immune to physics impacts, won't take damage from props
ENT.Immune_Sonic = false -- Immune to sonic-type damages
ENT.ImmuneDamagesTable = {} -- Makes the SNPC immune to specific type of damages | Takes DMG_ enumerations
ENT.GetDamageFromIsHugeMonster = false -- Should it get damaged no matter what by SNPCs that are tagged as VJ_IsHugeMonster?
ENT.AllowIgnition = true -- Can this SNPC be set on fire?
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"Shoved_Backward_01","Shoved_Backward_02","Shoved_Backward_03","Shoved_Backward_04","Shoved_Backward_05"} -- If it uses normal based animation, use this
ENT.NextMoveAfterFlinchTime = "1.6" -- How much time until it can move, attack, etc. | Use this for schedules or else the base will set the time 0.6 if it sees it's a schedule!
ENT.NextFlinchTime = 0.5 -- How much time until it can flinch again?
ENT.HasHitGroupFlinching = false -- It will flinch when hit in certain hitgroups | It can also have certain animations to play in certain hitgroups
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = {
	{HitGroup = {1}, Animation = {"KSWoundHead"}}, --Head
	{HitGroup = {2}, Animation = {"Shoved_Backward_01","Shoved_Backward_02","Shoved_Backward_03","Shoved_Backward_04","Shoved_Backward_05"}}, --Chest
	{HitGroup = {4}, Animation = {"Shoved_Rightward_01"}}, --Left Arm
	{HitGroup = {5}, Animation = {"Shoved_Leftward_01"}}, --Right Arm
	{HitGroup = {6}, Animation = {"KSWoundLeftLeg"}}, --Left Leg
	{HitGroup = {7}, Animation = {"KSWoundRightLeg"}}, --Right Leg
}
	-- ====== Damage By Player Variables ====== --
ENT.HasDamageByPlayer = true -- Should the SNPC do something when it's hit by a player? Example: Play a sound or animation
ENT.DamageByPlayerDispositionLevel = 0 -- 0 = Run it every time | 1 = Run it only when friendly to player | 2 = Run it only when enemy to player
ENT.DamageByPlayerNextTime1 = 2 -- How much time should it pass until it runs the code again? | First number in math.random
ENT.DamageByPlayerNextTime2 = 2 -- How much time should it pass until it runs the code again? | Second number in math.random
	-- ====== Run Away On Unknown Damage Variables ====== --
ENT.RunAwayOnUnknownDamage = false -- Should run away on damage
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted
	-- ====== Call For Back On Damage Variables ====== --
ENT.CallForBackUpOnDamage = true -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.CallForBackUpOnDamageDistance = 800 -- How far away the SNPC's call for help goes | Counted in World Units
ENT.CallForBackUpOnDamageUseCertainAmount = true -- Should the SNPC only call certain amount of people?
ENT.CallForBackUpOnDamageUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
ENT.CallForBackUpOnDamageAnimation = {} -- Animation used if the SNPC does the CallForBackUpOnDamage function
	-- To let the base automatically detect the animation duration, set this to false:
ENT.CallForBackUpOnDamageAnimationTime = false -- How much time until it can use activities
ENT.NextCallForBackUpOnDamageTime1 = 9 -- Next time it use the CallForBackUpOnDamage function | The first # in math.random
ENT.NextCallForBackUpOnDamageTime2 = 11 -- Next time it use the CallForBackUpOnDamage function | The second # in math.random
ENT.DisableCallForBackUpOnDamageAnimation = false -- Disables the animation when the CallForBackUpOnDamage function is called
	-- ====== Taking Cover Variables ====== --
ENT.AnimTbl_TakingCover = {} -- The animation it plays when hiding in a covered position, leave empty to let the base decide
	-- ====== Move Or Hide On Damage Variables ====== --
ENT.MoveOrHideOnDamageByEnemy = true -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = false -- Should it only move and not hide?
ENT.AnimTbl_MoveOrHideOnDamageByEnemy = {} -- The activities it plays when it finds a hiding spot | This will override self.AnimTbl_TakingCover and and the base animations
ENT.MoveOrHideOnDamageByEnemy_HideTime1 = 3 -- How long should it hide? | First number in math.random
ENT.MoveOrHideOnDamageByEnemy_HideTime2 = 4 -- How long should it hide? | Second number in math.random
ENT.MoveOrHideOnDamageByEnemy_NextHideTime1 = 7 -- How long until it can hide again? | First number in math.random
ENT.MoveOrHideOnDamageByEnemy_NextHideTime2 = 8 -- How long until it can hide again? | Second number in math.random
ENT.NextMoveOrHideOnDamageByEnemy1 = 3 -- How much time until it moves or hides on damage by enemy? | The first # in math.random
ENT.NextMoveOrHideOnDamageByEnemy2 = 3.5 -- How much time until it moves or hides on damage by enemy? | The second # in math.random
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Killed & Corpse Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC
ENT.DeathCorpseEntityClass = "UseDefaultBehavior" -- The entity class it creates | "UseDefaultBehavior" = Let the base automatically detect the type
ENT.DeathCorpseModel = {} -- The corpse model that it will spawn when it dies | Leave empty to use the NPC's model | Put as many models as desired, the base will pick a random one.
ENT.DeathCorpseSkin = -1 -- Used to override the death skin | -1 = Use the skin that the SNPC had before it died
ENT.DeathCorpseSetBodyGroup = true -- Should it get the models bodygroups and set it to the corpse? When set to false, it uses the model's default bodygroups
	-- Set both of the following BodyGroup variables to a number greater than -1 to set a custom bodygroup for the corpse:
ENT.DeathBodyGroupA = -1 -- Used for Custom Bodygroup | Group = A
ENT.DeathBodyGroupB = -1 -- Used for Custom Bodygroup | Group = B
ENT.DeathCorpseAlwaysCollide = false -- Should the corpse always collide?
ENT.FadeCorpse = false -- Fades the ragdoll on death
ENT.FadeCorpseTime = 10 -- How much time until the ragdoll fades | Unit = Seconds
ENT.SetCorpseOnFire = false -- Sets the corpse on fire when the SNPC dies
ENT.UsesBoneAngle = true -- This can be used to stop the corpse glitching or flying on death
ENT.UsesDamageForceOnDeath = true -- Disables the damage force on death | Useful for SNPCs with Death Animations
ENT.WaitBeforeDeathTime = 0 -- Time until the SNPC spawns its corpse and gets removed
	-- ====== Death Animation Variables ====== --
ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"vjseq_death_01",
					"vjseq_death_02a",
					"vjseq_death_02c",
					"vjseq_death_03",
					"vjseq_death_05",
					"vjseq_death_06",
					"vjseq_death_07",
					"vjseq_death_08",
					"vjseq_death_08b",
					"vjseq_death_09",
					"vjseq_death_10ab",
					"vjseq_death_10b",
					"vjseq_death_10c",	--Commented out because they were too long-form deaths, not sudden enough for regular stormtroopers.
					"vjseq_death_11_01a",
					"vjseq_death_11_01b",
					"vjseq_death_11_02a",
					"vjseq_death_11_02b",
					"vjseq_death_11_02c",
					"vjseq_death_11_02d",
					"vjseq_death_11_03a",
					"vjseq_death_11_03b",
					"vjseq_death_11_03c",
					"deathrunning_01",
					"deathrunning_03",
					"deathrunning_04",
					"deathrunning_05",
					"deathrunning_06",
					"deathrunning_07",
					"deathrunning_08",
					"deathrunning_09",
					"deathrunning_10",
					"deathrunning_11a",
					"deathrunning_11b",
					"deathrunning_11c",
					"deathrunning_11d",
					"deathrunning_11e",
					"deathrunning_11f",
					"deathrunning_11g"} -- Death Animations
ENT.DeathAnimationChance = 1.5 -- Put 1 if you want it to play the animation all the time
	-- To let the base automatically detect the animation duration, set this to false:
	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = false -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = false -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {DMG_BLAST} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = false -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = false -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu
	-- ====== Item Drops On Death Variables ====== --
ENT.DropWeaponOnDeath = false -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 14 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {"weapon_frag","item_healthvial"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
	-- ====== Ally Reaction On Death Variables ====== --
	-- Default: Creature base uses BringFriends and Human base uses AlertFriends
	-- BringFriendsOnDeath takes priority over AlertFriendsOnDeath!
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.BringFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.BringFriendsOnDeathUseCertainAmount = true -- Should the SNPC only call certain amount of people?
ENT.BringFriendsOnDeathUseCertainAmountNumber = 3 -- How many people should it call if certain amount is enabled?
ENT.AlertFriendsOnDeath = true -- Should the SNPCs allies get alerted when it dies? | Its allies will also need to have this variable set to true!
ENT.AlertFriendsOnDeathDistance = 800 -- How far away does the signal go? | Counted in World Units
ENT.AlertFriendsOnDeathUseCertainAmountNumber = 50 -- How many people should it alert?
ENT.AnimTbl_AlertFriendsOnDeath = {ACT_RANGE_ATTACK1} -- Animations it plays when an ally dies that also has AlertFriendsOnDeath set to true
	-- ====== Miscellaneous Variables ====== --
ENT.HasDeathNotice = false -- Set to true if you want it show a message after it dies
ENT.DeathNoticePosition = HUD_PRINTCENTER -- Were you want the message to show. Examples: HUD_PRINTCENTER, HUD_PRINTCONSOLE, HUD_PRINTTALK
ENT.DeathNoticeWriting = "Example: Spider Queen Has Been Defeated!" -- Message that will appear
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Melee Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = GetConVarNumber("vj_snpcdamage")
	-- ====== Animation Variables ====== --
ENT.AnimTbl_MeleeAttack = {"vjseq_swing"} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the melee attack animation?
ENT.MeleeAttackAnimationDecreaseLengthAmount = 0 -- This will decrease the time until starts chasing again. Use it to fix animation pauses until it chases the enemy.
	-- ====== Distance Variables ====== --
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackAngleRadius = 100 -- What is the attack angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.MeleeAttackDamageAngleRadius = 100 -- What is the damage angle radius? | 100 = In front of the SNPC | 180 = All around the SNPC
	-- ====== Timer Variables ====== --
	-- To use event-based attacks, set this to false:
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextMeleeAttackTime = 0 -- How much time until it can use a melee attack?
ENT.NextMeleeAttackTime_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
	-- To let the base automatically detect the attack duration, set this to false:
ENT.NextAnyAttackTime_Melee = false -- How much time until it can use any attack again? | Counted in Seconds
ENT.NextAnyAttackTime_Melee_DoRand = false -- False = Don't use random time | Number = Picks a random number between the regular timer and this timer
ENT.MeleeAttackReps = 1 -- How many times does it run the melee attack code?
ENT.MeleeAttackExtraTimers = {/* Ex: 1,1.4 */} -- Extra melee attack timers | it will run the damage code after the given amount of seconds
ENT.StopMeleeAttackAfterFirstHit = false -- Should it stop the melee attack from running rest of timers when it hits an enemy?
	-- ====== Control Variables ====== --
ENT.DisableMeleeAttackAnimation = false -- if true, it will disable the animation code
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Weapon Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.WeaponSpread = 3.5 -- What's the spread of the weapon? | Closer to 0 = better accuracy, Farther than 1 = worse accuracy
ENT.DisableWeapons = false -- If set to true, it won't be able to use weapons
ENT.Weapon_NoSpawnMenu = false -- If set to true, the NPC weapon setting in the spawnmenu will not be applied for this SNPC
	-- ====== Distance Variables ====== --
ENT.Weapon_FiringDistanceFar = 100000 -- How far away it can shoot
ENT.Weapon_FiringDistanceClose = 0.5 -- How close until it stops shooting
	-- ====== Standing-Firing Variables ====== --
ENT.AnimTbl_WeaponAttack = {} -- Animation played when the SNPC does weapon attack | For VJ Weapons
ENT.WeaponAttackSchedule = {SCHED_RANGE_ATTACK1} -- Schedule played when the SNPC does weapon attack | For None-VJ Weapons
ENT.CanCrouchOnWeaponAttack = true -- Can it crouch while shooting?
ENT.AnimTbl_WeaponAttackCrouch = {} -- Animation played when the SNPC does weapon attack while crouching | For VJ Weapons
ENT.CanCrouchOnWeaponAttackChance = 2.5 -- How much chance of crouching? | 1 = Crouch every time
ENT.AnimTbl_WeaponAttackFiringGesture = {} -- Firing Gesture animations used when the SNPC is firing the weapon | Leave empty for the base to decide
ENT.DisableWeaponFiringGesture = false -- If set to true, it will disable the weapon firing gestures
	-- ====== Moving-Firing Variables ====== --
ENT.HasShootWhileMoving = true -- Can it shoot while moving?
ENT.AnimTbl_ShootWhileMovingRun = {} -- Animations it will play when shooting while running | NOTE: Weapon may translate the animation that they see fit!
ENT.AnimTbl_ShootWhileMovingWalk = {} -- Animations it will play when shooting while walking | NOTE: Weapon may translate the animation that they see fit!
	-- ====== Reloading Variables ====== --
ENT.AllowWeaponReloading = true -- If false, the SNPC will no longer reload
ENT.DisableWeaponReloadAnimation = false -- if true, it will disable the animation code when reloading
ENT.AnimTbl_WeaponReload = {ACT_RELOAD} -- Animations that play when the SNPC reloads
ENT.AnimTbl_WeaponReloadBehindCover = {ACT_RELOAD_LOW, ACT_RELOAD_PISTOL_LOW} -- Animations that it plays when the SNPC reloads, but behind cover
ENT.WeaponReloadAnimationFaceEnemy = true -- Should it face the enemy while playing the weapon reload animation?
ENT.WeaponReloadAnimationDecreaseLengthAmount = 0 -- This will decrease the time until it starts moving or attack again. Use it to fix animation pauses until it chases the enemy.
ENT.WeaponReloadAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
	-- ====== Weapon Inventory Variables ====== --
	-- Weapons are given on spawn and the NPC will only switch to those if the requirements are met
	-- The items that are stored in self.WeaponInventory:
		-- Primary - Default weapon
		-- AntiArmor - Current enemy is an armored enemy (Usually vehicle) or a boss
		-- Melee - Current enemy is (very close and the NPC is out of ammo) OR (in regular melee attack distance) + NPC must have more than 25% health
ENT.WeaponInventory_AntiArmor = false -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_AntiArmorList = {} -- It will randomly be given one of these weapons
ENT.WeaponInventory_Melee = false -- If true, the NPC will spawn with one of the given weapons (Will only be given the weapon if it already has another!)
ENT.WeaponInventory_MeleeList = {"weapon_vjks_se14r"} -- It will randomly be given one of these weapons
	-- ====== Move Randomly While Firing Variables ====== --
ENT.MoveRandomlyWhenShooting = true -- Should it move randomly when shooting?
ENT.NextMoveRandomlyWhenShootingTime1 = 0.5 -- How much time until it can move randomly when shooting? | First number in math.random
ENT.NextMoveRandomlyWhenShootingTime2 = 1 -- How much time until it can move randomly when shooting? | Second number in math.random
	-- ====== Wait For Enemy To Come Out Variables ====== --
ENT.WaitForEnemyToComeOut = false -- Should it wait for the enemy to come out from hiding?
ENT.AnimTbl_CustomWaitForEnemyToComeOut = {} -- Leave empty to use the default animations from the base | The base will play the firing animations
ENT.WaitForEnemyToComeOutTime1 = 3 -- How much time should it wait until it starts chasing the enemy? | First number in math.random
ENT.WaitForEnemyToComeOutTime2 = 4 -- How much time should it wait until it starts chasing the enemy? | Second number in math.random
ENT.WaitForEnemyToComeOutDistance = 100 -- If it's this close to the enemy, it won't do it
	-- ====== Scared Behavior Variables ====== --
ENT.NoWeapon_UseScaredBehavior = true -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?
ENT.AnimTbl_ScaredBehaviorStand = {ACT_COWER} -- The animation it will when it's just standing still | Replaces the idle stand animation
ENT.AnimTbl_ScaredBehaviorMovement = {} -- The movement animation it will play | Leave empty for the base to decide the animation
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Grenade Attack Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vjks_thermaldetonator" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = "models/KriegSyntax/weapons/detonator_thermal/detonator_thermal.mdl" -- The model for the grenade entity
	-- ====== Animation Variables ====== --
ENT.AnimTbl_GrenadeAttack = {ACT_RANGE_ATTACK_THROW} -- Grenade Attack Animations
ENT.GrenadeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing the grenade attack animation?
	-- ====== Distance & Chance Variables ====== --
ENT.NextThrowGrenadeTime1 = 10 -- Time until it runs the throw grenade code again | The first # in math.random
ENT.NextThrowGrenadeTime2 = 15 -- Time until it runs the throw grenade code again | The second # in math.random
ENT.ThrowGrenadeChance = 4.5 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1000 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 100 -- How close until it stops throwing grenades
	-- ====== Timer Variables ====== --
ENT.TimeUntilGrenadeIsReleased = 0.62 -- Time until the grenade is released
	-- To let the base automatically detect the attack duration, set this to false:
ENT.GrenadeAttackAnimationStopAttacks = false -- Should it stop attacks for a certain amount of time?
ENT.GrenadeAttackAnimationStopAttacksTime = false -- How long should it stop attacks?
ENT.GrenadeAttackFussTime = 3 -- Time until the grenade explodes
	-- ====== Projectile Spawn & Velocity Variables ====== --
ENT.GrenadeAttackAttachment = "anim_attachment_LH" -- The attachment that the grenade will spawn at
ENT.GrenadeAttackVelUp1 = 200 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelUp2 = 200 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelForward1 = 500 -- Grenade attack velocity up | The first # in math.random
ENT.GrenadeAttackVelForward2 = 500 -- Grenade attack velocity up | The second # in math.random
ENT.GrenadeAttackVelRight1 = -20 -- Grenade attack velocity right | The first # in math.random
ENT.GrenadeAttackVelRight2 = 20 -- Grenade attack velocity right | The second # in math.random
	-- ====== Grenade Detection & Throwing Back Variables ====== --
ENT.CanDetectGrenades = true -- Set to false to disable the SNPC from running away from grenades
ENT.RunFromGrenadeDistance = 400 -- If the entity is this close to the it, then run!
	-- NOTE: The ability to throw grenades back only work if the SNPC can detect grenades AND has a grenade attack!
ENT.CanThrowBackDetectedGrenades = true -- Should it try to pick up the detected grenade and throw it back to the enemy?
	-- ====== Control Variables ====== --
ENT.DisableGrenadeAttackAnimation = false -- if true, it will disable the animation code when doing grenade attack
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasSounds = true -- Put to false to disable ALL sounds
	-- ====== Footstep Sound Variables ====== --
ENT.DisableFootStepSoundTimer = false -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events
ENT.FootStepTimeRun = 0.3 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = .5 -- Next foot step sound when it is walking
ENT.DisableFootStepOnRun = false -- It will not play the footstep sound when running
ENT.DisableFootStepOnWalk = false -- It will not play the footstep sound when walking
ENT.HasWorldShakeOnMove = false -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 1 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveAmplitude = 10 -- How much the screen will shake | From 1 to 16, 1 = really low 16 = really high
ENT.WorldShakeOnMoveRadius = 1000 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.DisableWorldShakeOnMoveWhileRunning = false -- It will not shake the world when it's running
ENT.DisableWorldShakeOnMoveWhileWalking = false -- It will not shake the world when it's walking
	-- The following custom variables are used for timer-based footstep & world shake
	-- Add any animations that should be used to trigger a sound or shake the world, only add animations if the base doesn't recognize an animation as a movement!
ENT.CustomWalkActivites = {} -- Custom walk activities
ENT.CustomRunActivites = {} -- Custom run activities
	-- ====== Idle Sound Variables ====== --
ENT.IdleSounds_NoRegularIdleOnAlerted = false -- if set to true, it will not play the regular idle sound table if the combat idle sound table is empty
	-- ====== Miscellaneous Variables ====== --
ENT.AlertSounds_OnlyOnce = false -- After it plays it once, it will never play it again
ENT.BeforeMeleeAttackSounds_WaitTime = 0 -- Time until it starts playing the Before Melee Attack sounds
ENT.OnlyDoKillEnemyWhenClear = true -- When there is no enemy in sight
	-- ====== Main Control Variables ====== --
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.HasBreathSound = true -- Should it make a breathing sound?
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.HasOnReceiveOrderSounds = true -- If set to false, it won't play any sound when it receives an order from an ally
ENT.HasFollowPlayerSounds_Follow = true -- If set to false, it won't play the follow player sounds
ENT.HasFollowPlayerSounds_UnFollow = true -- If set to false, it won't play the unfollow player sounds
ENT.HasMoveOutOfPlayersWaySounds = true -- If set to false, it won't play any sounds when it moves out of the player's way
ENT.HasMedicSounds_BeforeHeal = true -- If set to false, it won't play any sounds before it gives a med kit to an ally
ENT.HasMedicSounds_AfterHeal = true -- If set to false, it won't play any sounds after it gives a med kit to an ally
ENT.HasMedicSounds_ReceiveHeal = true -- If set to false, it won't play any sounds when it receives a medkit
ENT.HasOnPlayerSightSounds = true -- If set to false, it won't play the saw player sounds
ENT.HasInvestigateSounds = true -- If set to false, it won't play any sounds when it's investigating something
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasCallForHelpSounds = true -- If set to false, it won't play any sounds when it calls for help
ENT.HasBecomeEnemyToPlayerSounds = true -- If set to false, it won't play the become enemy to player sounds
ENT.HasSuppressingSounds = true -- If set to false, it won't play any sounds when firing a weapon
ENT.HasWeaponReloadSounds = true -- If set to false, it won't play any sound when reloading
ENT.HasMeleeAttackSounds = true -- If set to false, it won't play the melee attack sound
ENT.HasExtraMeleeAttackSounds = false -- Set to true to use the extra melee attack sounds
ENT.HasMeleeAttackMissSounds = true -- If set to false, it won't play the melee attack miss sound
ENT.HasGrenadeAttackSounds = true -- If set to false, it won't play any sound when doing grenade attack
ENT.HasOnGrenadeSightSounds = true -- If set to false, it won't play any sounds when it sees a grenade
ENT.HasOnKilledEnemySound = true -- Should it play a sound when it kills an enemy?
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasImpactSounds = true -- If set to false, it won't play the impact sounds
ENT.HasDamageByPlayerSounds = true -- If set to false, it won't play the damage by player sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds
ENT.HasSoundTrack = false -- Does the SNPC have a sound track?
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/metropolice/gear1.wav",
						"npc/metropolice/gear2.wav",
						"npc/metropolice/gear3.wav",
						"npc/metropolice/gear4.wav",
						"npc/metropolice/gear5.wav",
						"npc/metropolice/gear6.wav"}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {"kstrudel/imps/navytroop/idle/idle_1.wav",
					"kstrudel/imps/navytroop/idle/idle_2.wav",
					"kstrudel/imps/navytroop/idle/idle_3.wav"}
ENT.SoundTbl_CombatIdle = {}
ENT.SoundTbl_OnReceiveOrder = {"kstrudel/imps/imp_soldier/onrecievingorder/1.ogg",
							"kstrudel/imps/imp_soldier/onrecievingorder/2.ogg"}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_Alert = {"kstrudel/imps/imp_soldier/alert/1.ogg",
					"kstrudel/imps/imp_soldier/alert/2.ogg",
					"kstrudel/imps/imp_soldier/alert/3.ogg",
					"kstrudel/imps/imp_soldier/alert/4.ogg",
					"kstrudel/imps/imp_soldier/alert/5.ogg",
					"kstrudel/imps/imp_soldier/alert/6.ogg",
					"kstrudel/imps/imp_soldier/alert/7.ogg",
					"kstrudel/imps/imp_soldier/alert/8.ogg",
					"kstrudel/imps/imp_soldier/alert/9.ogg"}
ENT.SoundTbl_Investigate = {"kstrudel/imps/navytroop/alert/alert_1.wav",
							"kstrudel/imps/navytroop/alert/alert_2.wav",
							"kstrudel/imps/navytroop/alert/alert_3.wav",
							"kstrudel/imps/navytroop/alert/alert_4.wav",
							"kstrudel/imps/navytroop/alert/alert_5.wav",
							"kstrudel/imps/navytroop/alert/alert_6.wav",
							"kstrudel/imps/navytroop/alert/alert_7.wav",
							"kstrudel/imps/navytroop/alert/alert_8.wav",
							"kstrudel/imps/navytroop/alert/alert_9.wav"}
ENT.SoundTbl_CallForHelp = {"kstrudel/imps/imp_soldier/onrecievingorder/1.ogg",
							"kstrudel/imps/imp_soldier/onrecievingorder/2.ogg"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"kstrudel/imps/imp_soldier/alert/1.ogg",
					"kstrudel/imps/imp_soldier/alert/2.ogg",
					"kstrudel/imps/imp_soldier/alert/3.ogg",
					"kstrudel/imps/imp_soldier/alert/4.ogg",
					"kstrudel/imps/imp_soldier/alert/5.ogg",
					"kstrudel/imps/imp_soldier/alert/6.ogg",
					"kstrudel/imps/imp_soldier/alert/7.ogg",
					"kstrudel/imps/imp_soldier/alert/8.ogg",
					"kstrudel/imps/imp_soldier/alert/9.ogg"}
ENT.SoundTbl_Suppressing = {"kstrudel/imps/imp_soldier/suppressing/1.ogg",
					"kstrudel/imps/imp_soldier/suppressing/2.ogg",
					"kstrudel/imps/imp_soldier/suppressing/3.ogg",
					"kstrudel/imps/imp_soldier/suppressing/4.ogg",
					"kstrudel/imps/imp_soldier/suppressing/5.ogg",
					"kstrudel/imps/imp_soldier/suppressing/6.ogg"}
ENT.SoundTbl_WeaponReload = {"kstrudel/imps/imp_soldier/reloading/1.ogg",
					"kstrudel/imps/imp_soldier/reloading/2.ogg",
					"kstrudel/imps/imp_soldier/reloading/3.ogg",
					"kstrudel/imps/imp_soldier/reloading/4.ogg",
					"kstrudel/imps/imp_soldier/reloading/5.ogg",
					"kstrudel/imps/imp_soldier/reloading/6.ogg",
					"kstrudel/imps/imp_soldier/reloading/7.ogg",
					"kstrudel/imps/imp_soldier/reloading/8.ogg",
					"kstrudel/imps/imp_soldier/reloading/9.ogg",
					"kstrudel/imps/imp_soldier/reloading/10.ogg"}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {"kstrudel/imps/imp_soldier/ongrenadethrow/1.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/2.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/3.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/4.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/5.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/6.ogg",
					"kstrudel/imps/imp_soldier/ongrenadethrow/7.ogg"}
ENT.SoundTbl_OnGrenadeSight = {"kstrudel/imps/imp_soldier/ongrenadesight/1.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/2.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/3.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/4.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/5.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/6.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/7.ogg",
					"kstrudel/imps/imp_soldier/ongrenadesight/8.ogg"}
ENT.SoundTbl_OnKilledEnemy = {"kstrudel/imps/imp_soldier/onkilledenemy/1.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/2.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/3.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/4.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/5.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/6.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/7.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/8.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/9.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/10.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/11.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/12.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/13.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/14.ogg",
					"kstrudel/imps/imp_soldier/onkilledenemy/15.ogg"}
ENT.SoundTbl_Pain = {"kstrudel/imps/imp_soldier/pain/1.ogg",
					"kstrudel/imps/imp_soldier/pain/2.ogg",
					"kstrudel/imps/imp_soldier/pain/3.ogg",
					"kstrudel/imps/imp_soldier/pain/4.ogg",
					"kstrudel/imps/imp_soldier/pain/5.ogg",
					"kstrudel/imps/imp_soldier/pain/6.ogg",
					"kstrudel/imps/imp_soldier/pain/7.ogg",
					"kstrudel/imps/imp_soldier/pain/8.ogg",
					"kstrudel/imps/imp_soldier/pain/9.ogg",
					"kstrudel/imps/imp_soldier/pain/10.ogg",
					"kstrudel/imps/imp_soldier/pain/11.ogg",
					"kstrudel/imps/imp_soldier/pain/12.ogg",
					"kstrudel/imps/imp_soldier/pain/13.ogg"}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {"kstrudel/imps/imp_soldier/pain/1.ogg",
					"kstrudel/imps/imp_soldier/pain/2.ogg",
					"kstrudel/imps/imp_soldier/pain/3.ogg",
					"kstrudel/imps/imp_soldier/pain/4.ogg",
					"kstrudel/imps/imp_soldier/pain/5.ogg",
					"kstrudel/imps/imp_soldier/pain/6.ogg",
					"kstrudel/imps/imp_soldier/pain/7.ogg",
					"kstrudel/imps/imp_soldier/pain/8.ogg",
					"kstrudel/imps/imp_soldier/pain/9.ogg",
					"kstrudel/imps/imp_soldier/pain/10.ogg",
					"kstrudel/imps/imp_soldier/pain/11.ogg",
					"kstrudel/imps/imp_soldier/pain/12.ogg",
					"kstrudel/imps/imp_soldier/pain/13.ogg"}
ENT.SoundTbl_Death = {"kstrudel/imps/imp_soldier/death/1.ogg",
					"kstrudel/imps/imp_soldier/death/2.ogg",
					"kstrudel/imps/imp_soldier/death/3.ogg",
					"kstrudel/imps/imp_soldier/death/4.ogg",
					"kstrudel/imps/imp_soldier/death/5.ogg",
					"kstrudel/imps/imp_soldier/death/6.ogg",
					"kstrudel/imps/imp_soldier/death/7.ogg",
					"kstrudel/imps/imp_soldier/death/8.ogg",
					"kstrudel/imps/imp_soldier/death/9.ogg",
					"kstrudel/imps/imp_soldier/death/10.ogg",
					"kstrudel/imps/imp_soldier/death/11.ogg",
					"kstrudel/imps/imp_soldier/death/12.ogg",
					"kstrudel/imps/imp_soldier/death/13.ogg",
					"kstrudel/imps/imp_soldier/death/14.ogg"}
					
ENT.SoundTbl_OnPlayerSight = {"kstrudel/imps/imp_soldier/onplayersight/1.ogg",
					"kstrudel/imps/imp_soldier/onplayersight/2.ogg",
					"kstrudel/imps/imp_soldier/onplayersight/3.ogg",
					"kstrudel/imps/imp_soldier/onplayersight/4.ogg",
					"kstrudel/imps/imp_soldier/onplayersight/5.ogg",
					"kstrudel/imps/imp_soldier/onplayersight/6.ogg"}
					
					
function ENT:CustomOnInitialize()
	if math.random(1,0) == 1 then
		self:SetSkin(math.random(0,0))
		self:SetBodygroup(0,math.random(1,1)) -- Uniform
		self:SetBodygroup(2,math.random(0,10)) -- Head
		self:SetBodygroup(3,math.random(0,5)) -- Helmet
		self:SetBodygroup(4,math.random(1,1)) -- Backpack
		self:SetBodygroup(5,math.random(0,3)) -- Webbings
		self:SetBodygroup(6,math.random(0,0)) -- Ammo Pouch
	end
end
					
					
					
					
ENT.SoundTbl_SoundTrack = {}
	-- ====== Fade Out Time Variables ====== --
	-- Put to 0 if you want it to stop instantly
ENT.SoundTrackFadeOutTime = 2
	-- ====== Sound Chance Variables ====== --
	-- Higher number = less chance of playing | 1 = Always play
ENT.IdleSoundChance = 8
ENT.CombatIdleSoundChance = 1
ENT.OnReceiveOrderSoundChance = 1
ENT.FollowPlayerSoundChance = 1
ENT.UnFollowPlayerSoundChance = 1
ENT.MoveOutOfPlayersWaySoundChance = 2
ENT.MedicBeforeHealSoundChance = 1
ENT.MedicAfterHealSoundChance = 1
ENT.MedicReceiveHealSoundChance = 1
ENT.OnPlayerSightSoundChance = 1
ENT.InvestigateSoundChance = 1
ENT.AlertSoundChance = 1
ENT.CallForHelpSoundChance = 1
ENT.BecomeEnemyToPlayerChance = 1
ENT.BeforeMeleeAttackSoundChance = 1
ENT.MeleeAttackSoundChance = 1
ENT.ExtraMeleeSoundChance = 1
ENT.MeleeAttackMissSoundChance = 1
ENT.GrenadeAttackSoundChance = 1
ENT.OnGrenadeSightSoundChance = 1
ENT.SuppressingSoundChance = 2
ENT.WeaponReloadSoundChance = 1
ENT.OnKilledEnemySoundChance = 1
ENT.PainSoundChance = 1
ENT.ImpactSoundChance = 1
ENT.DamageByPlayerSoundChance = 1
ENT.DeathSoundChance = 1
ENT.SoundTrackChance = 1
	-- ====== Timer Variables ====== --
	-- Randomized time between the two variables, x amount of time has to pass for the sound to play again | Counted in seconds
ENT.NextSoundTime_Breath_BaseDecide = true -- Let the base decide the next sound time, if it can't it will use the numbers below
ENT.NextSoundTime_Breath1 = 1
ENT.NextSoundTime_Breath2 = 1
ENT.NextSoundTime_Idle1 = 8
ENT.NextSoundTime_Idle2 = 25
ENT.NextSoundTime_Investigate1 = 5
ENT.NextSoundTime_Investigate2 = 5
ENT.NextSoundTime_Alert1 = 2
ENT.NextSoundTime_Alert2 = 3
ENT.NextSoundTime_OnGrenadeSight1 = 3
ENT.NextSoundTime_OnGrenadeSight2 = 3
ENT.NextSoundTime_Suppressing1 = 7
ENT.NextSoundTime_Suppressing2 = 15
ENT.NextSoundTime_WeaponReload1 = 3
ENT.NextSoundTime_WeaponReload2 = 5
ENT.NextSoundTime_OnKilledEnemy1 = 3
ENT.NextSoundTime_OnKilledEnemy2 = 5
ENT.NextSoundTime_Pain1 = 2
ENT.NextSoundTime_Pain2 = 2
ENT.NextSoundTime_DamageByPlayer1 = 2
ENT.NextSoundTime_DamageByPlayer2 = 2.3
	-- ====== Volume Variables ====== --
	-- Number must be between 0 and 1
	-- 0 = No sound, 1 = normal/loudest
ENT.SoundTrackVolume = 1
	-- ====== Sound Level Variables ====== --
	-- The proper number are usually range from 0 to 180, though it can go as high as 511
	-- More Information: https://developer.valvesoftware.com/wiki/Soundscripts#SoundLevel_Flags
ENT.FootStepSoundLevel = 70
ENT.BreathSoundLevel = 60
ENT.IdleSoundLevel = 75
ENT.CombatIdleSoundLevel = 80
ENT.OnReceiveOrderSoundLevel = 80
ENT.FollowPlayerSoundLevel = 75
ENT.UnFollowPlayerSoundLevel = 75
ENT.MoveOutOfPlayersWaySoundLevel = 75
ENT.BeforeHealSoundLevel = 75
ENT.AfterHealSoundLevel = 75
ENT.MedicReceiveHealSoundLevel = 75
ENT.OnPlayerSightSoundLevel = 75
ENT.InvestigateSoundLevel = 80
ENT.AlertSoundLevel = 80
ENT.CallForHelpSoundLevel = 80
ENT.BecomeEnemyToPlayerSoundLevel = 75
ENT.BeforeMeleeAttackSoundLevel = 75
ENT.MeleeAttackSoundLevel = 75
ENT.ExtraMeleeAttackSoundLevel = 75
ENT.MeleeAttackMissSoundLevel = 75
ENT.SuppressingSoundLevel = 80
ENT.WeaponReloadSoundLevel = 80
ENT.GrenadeAttackSoundLevel = 80
ENT.OnGrenadeSightSoundLevel = 80
ENT.OnKilledEnemySoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 60
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
//ENT.SoundTrackLevel = 0.9
	-- ====== Sound Pitch Variables ====== --
	-- Higher number = Higher pitch | Lower number = Lower pitch
	-- Highest acceptable number is 254
ENT.UseTheSameGeneralSoundPitch = true
	-- If set to true, it will make the game decide a number when the SNPC is created and use it for all sound pitches set to "UseGeneralPitch"
	-- It picks the number between these two variables below:
ENT.GeneralSoundPitch1 = 90
ENT.GeneralSoundPitch2 = 100
	-- These two variables control any sound pitch variable that is set to "UseGeneralPitch"
	-- To not use these variables for a certain sound pitch, just put the desired number in the specific sound pitch
ENT.FootStepPitch1 = 80
ENT.FootStepPitch2 = 100
ENT.BreathSoundPitch1 = 100
ENT.BreathSoundPitch2 = 100
ENT.IdleSoundPitch1 = "UseGeneralPitch"
ENT.IdleSoundPitch2 = "UseGeneralPitch"
ENT.CombatIdleSoundPitch1 = "UseGeneralPitch"
ENT.CombatIdleSoundPitch2 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch1 = "UseGeneralPitch"
ENT.OnReceiveOrderSoundPitch2 = "UseGeneralPitch"
ENT.FollowPlayerPitch1 = "UseGeneralPitch"
ENT.FollowPlayerPitch2 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch1 = "UseGeneralPitch"
ENT.UnFollowPlayerPitch2 = "UseGeneralPitch"
ENT.MoveOutOfPlayersWaySoundPitch1 = "UseGeneralPitch"
ENT.MoveOutOfPlayersWaySoundPitch2 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch1 = "UseGeneralPitch"
ENT.BeforeHealSoundPitch2 = "UseGeneralPitch"
ENT.AfterHealSoundPitch1 = 100
ENT.AfterHealSoundPitch2 = 100
ENT.MedicReceiveHealSoundPitch1 = "UseGeneralPitch"
ENT.MedicReceiveHealSoundPitch2 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch1 = "UseGeneralPitch"
ENT.OnPlayerSightSoundPitch2 = "UseGeneralPitch"
ENT.InvestigateSoundPitch1 = "UseGeneralPitch"
ENT.InvestigateSoundPitch2 = "UseGeneralPitch"
ENT.AlertSoundPitch1 = "UseGeneralPitch"
ENT.AlertSoundPitch2 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch1 = "UseGeneralPitch"
ENT.CallForHelpSoundPitch2 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch1 = "UseGeneralPitch"
ENT.BecomeEnemyToPlayerPitch2 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch1 = "UseGeneralPitch"
ENT.BeforeMeleeAttackSoundPitch2 = "UseGeneralPitch"
ENT.MeleeAttackSoundPitch1 = 95
ENT.MeleeAttackSoundPitch2 = 100
ENT.ExtraMeleeSoundPitch1 = 80
ENT.ExtraMeleeSoundPitch2 = 100
ENT.MeleeAttackMissSoundPitch1 = 90
ENT.MeleeAttackMissSoundPitch2 = 100
ENT.SuppressingPitch1 = "UseGeneralPitch"
ENT.SuppressingPitch2 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch1 = "UseGeneralPitch"
ENT.WeaponReloadSoundPitch2 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch1 = "UseGeneralPitch"
ENT.GrenadeAttackSoundPitch2 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch1 = "UseGeneralPitch"
ENT.OnGrenadeSightSoundPitch2 = "UseGeneralPitch"
ENT.OnKilledEnemySoundPitch1 = "UseGeneralPitch"
ENT.OnKilledEnemySoundPitch2 = "UseGeneralPitch"
ENT.PainSoundPitch1 = "UseGeneralPitch"
ENT.PainSoundPitch2 = "UseGeneralPitch"
ENT.ImpactSoundPitch1 = 90
ENT.ImpactSoundPitch2 = 100
ENT.DamageByPlayerPitch1 = "UseGeneralPitch"
ENT.DamageByPlayerPitch2 = "UseGeneralPitch"
ENT.DeathSoundPitch1 = "UseGeneralPitch"
ENT.DeathSoundPitch2 = "UseGeneralPitch"
	-- ====== Playback Rate Variables ====== --
	-- Decides how fast the sound should play
	-- Examples: 1 = normal, 2 = twice the normal speed, 0.5 = half the normal speed
ENT.SoundTrackPlaybackRate = 1

--Below is code from Panzer Elite, contact him if you wish to you use it!
ENT.WeaponUseEnemyEyePos = true
ENT.AnimTbl_TakingCover = {"crouch_idle_rpg"}
ENT.CanDetectGrenades = true

ENT.Reloadwhenidle = true
ENT.Reloadwhenidle_timer = 0
ENT.Reloadwhenidle_timersec = 2
ENT.Reloadwhenidle_chance = 2

ENT.Reloadwhenattacking = true
ENT.Reloadwhenattacking_chance = 2
ENT.Reloadwhenattacking_NextT = 0
ENT.Reloadwhenattacking_Nexttime = 2

ENT.CanDoSmartGrenadeThrow = true
ENT.SmartGrenadeThrow_timer = 0
ENT.SmartGrenadeThrow_timersec = 2.58
ENT.SmartGrenadeThrow_chance = 2
ENT.NextThrowSmartGrenadeT = 0
ENT.ThrowSmartGrenadeChance = 2

ENT.CanRememberEnemyPosition = true
ENT.SmartGrenadeThrow_enemyvisibletimer = 0
ENT.SmartGrenadeThrow_enemyvisible_previously = 0
ENT.SmartGrenadeThrow_enemyvisible_lastposition = Vector(0,0,0)
ENT.SmartGrenadeThrow_enemyvisible_NextT = 0
ENT.SmartGrenadeThrow_enemyvisible_Next = 12
ENT.SmartGrenadeThrow_enemyvisibleshare_NextT = 0
ENT.SmartGrenadeThrow_enemyvisibleshare_Next = 4
ENT.SmartGrenadeThrow_enemyvisibleshared = 0

ENT.CanDoGrenadeThrowHigh = true
ENT.GrenadeThrowHigh_chance = -2
ENT.GrenadeThrowHigh_veltable = {vel1=1.00,vel2=1.01,forvel=5,upvel1=0,upvel2=10}

ENT.CanSmartAiming = true
ENT.SmartAiming_timer = 0
ENT.SmartAiming_timersec = 1
ENT.SmartAiming_chance = 2
ENT.SmartAiming_attacktime = 1.5
ENT.SmartAiming_activated = 0
ENT.SmartAiming_originalshootrange = 400000
ENT.SmartAiming_allychargelimit = 1

ENT.CanFlankEnemy = true
ENT.FlankEnemy_NextT = 0
ENT.FlankEnemy_Nexttime = 1
ENT.FlankEnemy_chance = 1
ENT.FlankEnemy_activated = 0
ENT.FlankEnemy_allylimit = 9
ENT.FlankEnemy_ResetNextT = 0
ENT.FlankEnemy_StopNextT = 0
ENT.FlankEnemy_attackallylimit = 12
ENT.FlankEnemy_failed = 0
ENT.FlankEnemy_minrange = 650000

ENT.CanForceWeaponFire = true
ENT.ForceWeaponFire_activated = 0
ENT.ForceWeaponFire_NPCNextPrimaryFireT = 0
ENT.ForceWeaponFire_cooldown = 0

ENT.CanBlindFireCover = true
ENT.BlindFire_activated = 0
ENT.BlindFire_NextT = 0
ENT.BlindFire_Nexttime = 1
ENT.BlindFire_durationT = 0
ENT.BlindFire_duration = 3
ENT.BlindFire_Cooltime = 4
ENT.BlindFire_Var = {CanFlinch=0,CanCover=true,CanPose=true,WeaponSpread=0,durationextra=7}
ENT.BlindFire_Chance = 4 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.BlindFire_range = 10000

ENT.CanProneCover = true
ENT.CanProneCoverFire = true
ENT.ProneCover_activated = 0
ENT.ProneCover_NextT = 0
ENT.ProneCover_Nexttime = 1
ENT.ProneCover_durationT = 0
ENT.ProneCover_Var = {CanFlinch=0,CanCallHelp=false,CanCover=true,CanPose=true,WeaponSpread=1,Collidebound1=Vector(0,0,0),Collidebound2=Vector(0,0,0),Physbound1=Vector(0,0,0),Physbound2=Vector(0,0,0),duration=3,durationextra=25,Cooltime=1,rangemin=240}
ENT.ProneCover_Chance = 1 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.ProneCover_goingprone = 0

ENT.CanSmartAttackPos = true
--ENT.CanSmartAttackPos_Unreachonly = false
ENT.SmartAttackPos_activated = 0
ENT.SmartAttackPos_NextT = 0
ENT.SmartAttackPos_Var = {Nexttime=.3,Chance=1,Range=80000}
ENT.CurrentCoveringPosition = Vector(0,0,0)
ENT.CanLookForCover = true --cannot detect prop, lots of bugs --fixed
ENT.LookForCover_activated = 0
ENT.LookForCover_NextT = 0
ENT.LookForCover_Var = {Nexttime=.5,Chance=1,Range=7500}
ENT.CoverAttackReloadCheck = 0

ENT.CanAimCorrect = true
ENT.AimCorrect_activated = 0
ENT.AimCorrect_NextT = 0
ENT.AimCorrect_Var = {Nexttime=3.5,Chance=2}

ENT.CanThrowBlindGrenade = true

ENT.CanCornerCover = true
ENT.CornerCover_activated = 0
ENT.CornerCover_deactivated = 0
ENT.CornerCover_CheckNextT = 0
ENT.CornerCover_NextT = 0
ENT.CornerCover_Nexttime = 1.5
ENT.CornerCover_Nexttime2 = 2
ENT.CornerCover_durationT = 0
ENT.CornerCover_duration = 8.00
ENT.CornerCover_Cooltime = 4.5
ENT.CornerCover_Var = {CanFlinch=0,CanCover=true,CanPose=true,durationextra=8,durationextra2=6,Friction=1}
ENT.CornerCover_Chance = 1 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.CornerCover_range = 10000
ENT.CornerCover_GoHide = 0
ENT.CornerCover_Hiding = 1
ENT.CornerCover_Reloading = 1
ENT.CornerCover_HideChance = 6
ENT.CornerCover_ShootNextT = 0
ENT.CornerCover_ShootCheckNextT = 0
ENT.CornerCover_Shootnexttime = 2.0
ENT.CornerCover_Shootduration = 1.1
ENT.CornerCover_PosHide = Vector(0,0,0)
ENT.CornerCover_PosShoot = Vector(0,0,0)
ENT.CornerCover_ShootingPose = 1

ENT.CanCoordinatedChasing = true
ENT.CoordinatedChasing_NextT = 0
ENT.CoordinatedChasing_Nexttime = 1.5
ENT.CoordinatedChasing_range = 50000
ENT.CoordinatedChasing_activated = 0
ENT.CoordinatedChasing_activatedbyothers = 0
ENT.CoordinatedChasing_maxsoldier = 12

ENT.CanRegroupWhenHurt = true
ENT.RegroupWhenHurt_NextT = 0
ENT.RegroupWhenHurt_Nexttime = 1
ENT.RegroupWhenHurt_cooldown = 5
ENT.RegroupWhenHurt_Range = 1200
ENT.RegroupWhenHurt_RangeDone = 180
ENT.RegroupWhenHurt_start = 0
ENT.RegroupWhenHurt_activated = 0
ENT.RegroupWhenHurt_durationT = 0
ENT.RegroupWhenHurt_duration = 10
ENT.RegroupWhenHurt_threshold = 0.5
ENT.RegroupWhenHurt_NextT2 = 0

ENT.CanPredictNextEnemy = true
ENT.PredictNextEnemy_NextT = 0
ENT.PredictNextEnemy_Nexttime = 0.8
ENT.PredictNextEnemy_Range = 32000

ENT.CanPathAvoidClog = true
ENT.PathAvoidClog_NextT = 0
ENT.PathAvoidClog_Next = 1
ENT.PathAvoidClog_Entity = NULL
ENT.PathAvoidClog_lastpos = Vector(0,0,0)
ENT.PathAvoidClog_schedule = nil
ENT.PathAvoidClog_mindist = 90

ENT.CanFixPathFailed = true
ENT.FixPathFailed_NextT = 0
ENT.FixPathFailed_Next = 0.3
ENT.FixPathFailed_duration = 0
ENT.FixPathFailed_schedule = 0

ENT.CanFlankAttackPosition = true
ENT.FlankAttackPosition_NextT = 0
ENT.FlankAttackPosition_Nexttime = 2.0
ENT.FlankAttackPosition_chance = 4
ENT.FlankAttackPosition_activated = 0
ENT.FlankAttackPosition_maxrange = 3200
ENT.FlankAttackPosition_minrrange = 800
ENT.FlankAttackPosition_minrange = 400
ENT.FlankAttackPosition_thinking = 0
ENT.FlankAttackPosition_ResetNextT = 0
ENT.FlankAttackPosition_StopNextT = 0

ENT.CanTargetExposedEnemy = true
ENT.TargetExposedEnemy_range = 1000
ENT.TargetExposedEnemy_chance = 2
ENT.TargetExposedEnemy_NextT = 0
ENT.TargetExposedEnemy_Nexttime = 1.5
ENT.TargetExposedEnemy_cooldown = 4

ENT.CanTrickShoot = false
ENT.TrickShoot_OnlyWhenEnemyLooking = true
ENT.TrickShoot_OnlyWhenEnemyLookingradius = 100000
ENT.TrickShoot_activated = 0
ENT.TrickShoot_NextT = 0
ENT.TrickShoot_Nexttime = 4.2
ENT.TrickShoot_Chance = 3
ENT.TrickShoot_Rangemin = 35
ENT.TrickShoot_Rangemax = 55
ENT.TrickShoot_Range = 24000000
ENT.TrickShoot_Cooldown = 2

ENT.CanCornerTrickShoot = false
ENT.CornerTrickShoot_activated = 0
ENT.CornerTrickShoot_NextT = 0
ENT.CornerTrickShoot_Nexttime = 3
ENT.CornerTrickShoot_Side = "left" --"right"
ENT.CornerTrickShoot_durationT = 0
ENT.CornerTrickShoot_duration = 2
ENT.CornerTrickShoot_chance = 1
ENT.CornerTrickShoot_durationextra = 100 -- divided by 100
ENT.CornerTrickShoot_hidingspot = Vector(0,0,0)
ENT.CornerTrickShoot_shootingspot = Vector(0,0,0)
ENT.CornerTrickShoot_maxtimeT = 0
ENT.CornerTrickShoot_maxtime = 6

ENT.CanTrickShootHide = true
ENT.TrickShootHide_GoHide = 0
ENT.TrickShootHide_NextT = 0
ENT.TrickShootHide_chance = 2
ENT.TrickShootHide_Nexttime = 0.5
ENT.TrickShootHide_cooldown = 1.2

ENT.CanPerformMeleeCharge = true
ENT.isMeleeCharging = 0
ENT.MeleeCharge_range = 200
ENT.MeleeCharge_forwardvel1 = 150
ENT.MeleeCharge_forwardvel2 = 200
ENT.MeleeCharge_upvel1 = 0
ENT.MeleeCharge_knockbackvel = 200
ENT.MeleeCharge_dmg = 40
ENT.MeleeCharge_timer = 0
ENT.MeleeCharge_timersec = 0.5
ENT.MeleeCharge_timer2 = 0
ENT.MeleeCharge_timersec2 = 4
ENT.MeleeCharge_chance = 2
ENT.AnimTbl_MeleeChargeAttack = {ACT_MELEE_ATTACK_SWING}
ENT.TimeUntilMeleeChargeDamage = 5
ENT.MeleeCharge_Vel = Vector(0,0,0)
ENT.MeleeChargeAttackDamageAngleRadius = 100
ENT.MeleeCharge_damagedentity = {}
ENT.MeleeChargeAttackDamageDistance = 30
ENT.MeleeCharge_originalfriction = 1
ENT.MeleeCharge_hit = 0

ENT.CanFlankBehind = true
ENT.FlankBehind_Range = 2000
ENT.FlankBehind_NextT = 0
ENT.FlankBehind_Nexttime = 2
ENT.FlankBehind_Chance = 3

ENT.CanGroupRush = true
ENT.GroupRush_NextT = 0
ENT.GroupRush_Nexttime = 4
ENT.GroupRush_CallRange = 12000 --Center at enemy
ENT.GroupRush_StopRange = 150
ENT.GroupRush_activated = 0
ENT.GroupRush_activatedbyothers = 0
ENT.GroupRush_charging = 0
ENT.GroupRush_chance = 4
ENT.GroupRush_minsoldier = 3
ENT.GroupRush_maxsoldier = 9
ENT.GroupRush_GatherPos = Vector(0,0,0)
ENT.GroupRush_durationT = 0

ENT.CanRegenHealth = true
ENT.RegenHealth_wait = 9
ENT.RegenHealth_NextT = 0
ENT.RegenHealth_healwait = 1
ENT.RegenHealth_heal = 5




------------------------------------------------------------------------------------Running Death Animation -DrVrej
--function ENT:OnTakeDamage(dmginfo)

--	if self:IsOnFire() && self.Immune_Fire == false then -- Yete gragi vera e
--	if self:IsOnFire() && self:WaterLevel() == 2 then self:Extinguish() end -- If we are in water, then extinguish the fire
--	if self.AllowIgnition == false && self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame" then self:Extinguish() return end
--	if self.Immune_Fire == true && (DamageType == DMG_BURN or DamageType == DMG_SLOWBURN or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() == "entityflame" && DamageAttacker:GetClass() == "entityflame")) then return end
--	if self.HasBloodParticle == true && ((!self:IsOnFire()) or (self:IsOnFire() && IsValid(DamageInflictor) && IsValid(DamageAttacker) && DamageInflictor:GetClass() != "entityflame" && DamageAttacker:GetClass() != "entityflame")) then self:SpawnBloodParticles(dmginfo,hitgroup) end
--
--			VJ_EmitSound(self,VJ_PICK({"stormscream_1.wav",
--			"stormscream_2.wav",
	--		"stormscream_3.wav",
--			"stormscream_4.wav",
--			"stormscream_5.wav"}),90,math.random(80,100))
--			self.AnimTbl_IdleStand = {ACT_IDLE_ON_FIRE}
--			self.AnimTbl_Walk = {ACT_RUN_ON_FIRE}
--			self.AnimTbl_Run = {ACT_RUN_ON_FIRE}
--		else
--	end
--end
------------------------------------------------------------------------------------














function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup) 

	if self.Dead == true then return end
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()

	local DamageType = dmginfo:GetDamageType()

	if self.CanRegroupWhenHurt == true then
	if math.random(0,9) >= 3 and self.RegroupWhenHurt_activated == 0 and self.RegroupWhenHurt_start == 0 and self:Health() > 0 and self:Health() <= self:GetMaxHealth()*self.RegroupWhenHurt_threshold*( math.random(9,13)/10 ) then
		self.RegroupWhenHurt_start = 1
		self.RegroupWhenHurt_NextT2 = CurTime() + 5
		if self.RegroupWhenHurt_NextT > CurTime()-1.2 then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		end
	end
	end
	
	--if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	--if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	if self.CanProneCover == true and CurTime() > self.ProneCover_durationT and self.ProneCover_goingprone != 1 and DamageAttacker != nil and IsValid(DamageAttacker) and DamageType != nil then
	if self.ProneCover_activated != 1 and self.BlindFire_activated == 0 and self.ProneCover_NextT < CurTime() and math.random(1,10) >= self.ProneCover_Chance and (dmginfo:IsBulletDamage() or DamageType == DMG_AIRBOAT or DamageType == DMG_BUCKSHOT) then
	if self.vACT_StopAttacks == false and dmginfo:GetDamage() != nil and dmginfo:GetDamage() > 8 and self:Health() <= self:GetMaxHealth()/1.3 and self:Health() -dmginfo:GetDamage() > 0 and (DamageAttacker:IsNPC() or DamageAttacker:IsPlayer()) then
	local shouldprone = 0
	self.ProneCover_NextT = CurTime() + self.ProneCover_Nexttime
	if self:DoRelationshipCheck(DamageAttacker) != false or (DamageAttacker.vj_doi_isteam != nil and DamageAttacker.vj_doi_isteam != self.vj_doi_isteam) then
	if self:GetPos():DistToSqr( DamageAttacker:GetPos() ) >= self.ProneCover_Var.rangemin*self.ProneCover_Var.rangemin then
			local trctbl = {
							start = self:GetPos()+self:GetUp()*28,
							endpos = DamageAttacker:EyePos(),
							filter = {self}
							}
			if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then trctbl.filter = {self,self:GetActiveWeapon()} end
			
			local trc = util.TraceLine(trctbl)
		
		if trc.HitWorld == true or (trc.Entity != nil and trc.Entity != NULL and !trc.Entity:IsNPC() and !trc.Entity:IsPlayer() and trc.Entity:IsSolid() ) then
		
		if self:GetEnemy() == nil or !IsValid(self:GetEnemy()) then
		shouldprone = 2
		else
		if self:GetEnemy() == DamageAttacker then
		
			local soldierlist = ents.FindInSphere(self:GetPos(),1000)
			for kc,vc in ipairs(soldierlist) do
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and (IsValid(vc:GetEnemy()) and vc:GetEnemy() == DamageAttacker and vc:Visible(DamageAttacker) ) then
		
				shouldprone = shouldprone + 2
		
			end
			end
			end
			
		
		end
		end
		
		if shouldprone >= 2 then 
			local clearside = self:VJ_CheckAllFourSides(80)
			if clearside.Forward and clearside.Backward then
				self.ProneCover_activated = 1
				self.ProneCover_Var.CanFlinch = self.CanFlinch
				self.ProneCover_Var.CanCallHelp = self.CallForHelp
				self.ProneCover_Var.CanFindEnemy = self.DisableTakeDamageFindEnemy
				self.ProneCover_Var.CanRunAway = self.RunAwayOnUnknownDamage 
				self.ProneCover_Var.CanCover = self.MoveOrHideOnDamageByEnemy
				self.CanFlinch = 0
				self.CallForBackUpOnDamage = false
				self.DisableTakeDamageFindEnemy = false
				self.RunAwayOnUnknownDamage = false
				self.MoveOrHideOnDamageByEnemy = false
				self.CallForHelp = false
			end
		end
		
		end
	end
	end
	
	end
	end
	end

end

function ENT:CustomOnWeaponReload()
					/*
					if self.CoverAttackReloadCheck == 0 then
					if (self.SmartAttackPos_activated == 1 or self.LookForCover_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(0.15,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:ClearSchedule() 
							self.CoverAttackReloadCheck = 1
						end
						end)
						timer.Simple(2.5,function()
						if IsValid(self) and self.Dead != true then
							self.CoverAttackReloadCheck = 0
						end
						end)
					end
					end
					*/
end

function ENT:CustomOnWeaponReload_AfterRanToCover()

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(2.7,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
						end
						end)
					end
						
						timer.Simple(4,function()
						if IsValid(self) and self.Dead != true then
						if self.vACT_StopAttacks != true and ((self:GetActivity() >= 376 and self:GetActivity() <= 381) or (self:GetActivity() >= 66 and self:GetActivity() <= 69)) then
							self:SelectSchedule()
							self.NextChaseTime = CurTime() + 0.5
						end
						end
						end)
end

function ENT:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup) 

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(1.1,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						end
						end)
					end

end

function ENT:CustomOnGrenadeThrow_After() 

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(2.1,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						end
						end)
					end

end

function ENT:CustomOnMovingPathFailed()

--x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end

	if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) and self.CanFixPathFailed == true then
	if self.LastSeenEnemyTime > 2 then
		if math.abs(CurTime() -self.NextChaseTime) >= 2 then self.NextChaseTime = CurTime() + 2.0 end
		self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime/2.5 + math.random(0,10)/10
		--self.FlankEnemy_ResetNextT = CurTime() + 2
		--self.FlankEnemy_StopNextT = CurTime() + 1
		self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime/2.5 + math.random(0,15)/10
		self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime/2.5 + math.random(0,15)/10
		self.NextIdleTime = CurTime() + 2
		self.SmartAttackPos_activated = 0
		self.LookForCover_activated = 0
		self.RegroupWhenHurt_activated = 0
		self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime/2.1 + math.random(0,15)/10
		self.FlankAttackPosition_activated = 0
		--print("nigged")
	end
	end

end

function ENT:CustomOnTouch(entity)

	if self.CanPathAvoidClog == true then
	if self.PathAvoidClog_NextT < CurTime() then
	--if IsValid(entity) then
	
	self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next*0.25
	local CurSched = self.CurrentSchedule
	local CurSched2 = nil
	local shouldmove = 1
	if CurSched != nil and IsValid(entity) and self.MovementType == VJ_MOVETYPE_GROUND and (self.PathAvoidClog_Entity == NULL or !IsValid(self.PathAvoidClog_Entity) ) then
	if (CurSched.IsMovingTask_Walk == true or CurSched.IsMovingTask_Run == true) and CurSched.PathAvoidClog != true then
	
		if entity:IsNPC() or entity:IsPlayer() or entity:GetClass() == "prop_physics" or entity:GetClass() == "prop_dynamic" then
	
		if entity:IsNPC() and entity:IsMoving() then shouldmove = 0 end
		if entity:IsPlayer() and self:DoRelationshipCheck(entity) == true then shouldmove = 0 end
		if !IsValid( entity:GetPhysicsObject() ) then shouldmove = 0 end
	
		if shouldmove == 1 then
			self.PathAvoidClog_Entity = entity
			self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next
			
			timer.Simple(1.4,function()
			if IsValid(self) then
			
			if IsValid(self.PathAvoidClog_Entity) and self.CurrentSchedule != nil and self.CurrentSchedule == CurSched then
			if self:GetPos():DistToSqr( self.PathAvoidClog_Entity:GetPos() ) < 24*24 then
			
			self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next*1 + 2.6
			if CurSched.Name == "vj_goto_lastpos" or CurSched.Name == "vj_flank_enemy" then
				self.PathAvoidClog_lastpos = self.CurrentCoveringPosition
				else
				self.PathAvoidClog_lastpos = Vector(0,0,0)
			end
			self.PathAvoidClog_schedule = self.CurrentSchedule
			
						local randpos = math.random(120,160)
						--local checkdist = self:VJ_CheckAllFourSides(randpos)
						
						local checkdist = {Forward=false, Backward=false, Right=false, Left=false}
						local ii = 0
						for k,vn in ipairs({self:GetForward(),-self:GetForward(),self:GetRight(),-self:GetRight()}) do
						ii = ii +1
							local trce = util.TraceLine({
							start = self:GetPos() +self:OBBCenter(),
							endpos = self:GetPos() +self:OBBCenter() +vn *randpos,
							filter = self
						})
							if self:GetPos():DistToSqr(trce.HitPos) >= self.PathAvoidClog_mindist*self.PathAvoidClog_mindist then
							if ii == 1 then checkdist.Forward = true end
							if ii == 2 then checkdist.Backward = true end
							if ii == 3 then checkdist.Right = true end
							if ii == 4 then checkdist.Left = true  end
							end
						end
						
						
						local randmove = {}
						if checkdist.Backward == true then table.insert(randmove,"Backward") end
						if checkdist.Right == true then table.insert(randmove,"Right") end
						if checkdist.Left == true then table.insert(randmove,"Left") end
						local pickmove = VJ_PICKRANDOMTABLE(randmove)
						if pickmove == "Backward" then self:SetLastPosition(self:GetPos() + self:GetForward()*-randpos) end
						if pickmove == "Right" then self:SetLastPosition(self:GetPos() + self:GetRight()*randpos) end
						if pickmove == "Left" then self:SetLastPosition(self:GetPos() + self:GetRight()*-randpos) end
						if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
						self:StopMoving()
						self:VJ_TASK_GOTO_LASTPOS(VJ_PICKRANDOMTABLE({"TASK_RUN_PATH","TASK_RUN_PATH"}),function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.PathAvoidClog = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						
						timer.Simple(2.5,function()
						if IsValid(self) then
						if self.PathAvoidClog_lastpos != Vector(0,0,0) then
							self:SetLastPosition(self.PathAvoidClog_lastpos)
						end
							self:StartSchedule(self.PathAvoidClog_schedule)
						end
						end)
						
						end
						self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2)

			end
			end
			
			self.PathAvoidClog_Entity = NULL
			end
			end)
			
			
		end
		
		end
			
	end
	end
	
	end
	end

end

function ENT:CustomOnCallForHelp()

		if IsValid(self:GetEnemy()) then
		if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < 1600*1600 then
			self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime/2
		end
		end
		
					if self.HasCallForHelpAnimation == true && self.vACT_StopAttacks != true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ_PICKRANDOMTABLE(self.AnimTbl_CallForHelp)
						self:VJ_ACT_PLAYACTIVITY(pickanim,self.CallForHelpStopAnimations,self:DecideAnimationLength(pickanim,self.CallForHelpStopAnimationsTime),self.CallForHelpAnimationFaceEnemy,self.CallForHelpAnimationDelay,{PlayBackRate=self.CallForHelpAnimationPlayBackRate})
						self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime
					end

end

function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor) 

	if self.CanPredictNextEnemy == true then
	if self.PredictNextEnemy_NextT < CurTime() and !IsValid(self:GetEnemy()) then
		self.PredictNextEnemy_NextT = CurTime() + self.PredictNextEnemy_Nexttime
		local foundents = 0
		local soldierlist = ents.FindInSphere(self.SmartGrenadeThrow_enemyvisible_lastposition,self.PredictNextEnemy_Range)
		if soldierlist != nil then		
			for kc,vc in ipairs(soldierlist) do
			if foundents == 0 then
			if !vc:IsNPC() and !vc:IsPlayer() then continue end
			if vc:EntIndex() != self:EntIndex() && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == true then
				foundents = vc
			end
			end
			end
			end
		end
		if IsValid(vc) then
			self:VJ_DoSetEnemy(vc,false)
		end
	end
	end

	if self.CanRegroupWhenHurt == true then
	if self.RegroupWhenHurt_activated == 0 and self.RegroupWhenHurt_start == 0 and !IsValid(self:GetEnemy()) and self:Health() > 0 and self:Health() <= self:GetMaxHealth()*self.RegroupWhenHurt_threshold then
		self.RegroupWhenHurt_start = 1
		self.RegroupWhenHurt_NextT2 = CurTime() + 4
		if self.RegroupWhenHurt_NextT > CurTime()-1.2 then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		end
	end
	end


end

function ENT:CustomManipulateBone(ent,bonename,ang)

	if IsValid(ent) and bonename != nil and ang != nil then
		local id = ent:LookupBone( bonename )
		local newang = Angle(ang.y,ang.p,ang.r)
		if id != nil then 
			ent:ManipulateBoneAngles( id, ang ) 
		end
	end
	
end

function ENT:VJ_TASK_FLANK_ENEMY(UseLOSChase)
	UseLOSChase = UseLOSChase or false
	//if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_flank_enemy" then return end
	if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_flank_enemy" then return end
	if self:GetActivity() == ACT_CLIMB_UP or self:GetActivity() == ACT_CLIMB_DOWN or self:GetActivity() == ACT_CLIMB_DISMOUNT then return end
	self:SetMovementActivity(VJ_PICKRANDOMTABLE(self.AnimTbl_Run))

		local vsched = ai_vj_schedule.New("vj_flank_enemy")
		vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vsched:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		//vsched:EngTask("TASK_FACE_ENEMY", 0)
		--vsched.ResetOnFail = false
		vsched.CanShootWhenMoving = true
		//vsched.StopScheduleIfNotMoving = true
		vsched.StopScheduleIfNotMoving = true
		--vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.IsMovingTask_Run = true
		vsched:EngTask("TASK_FACE_ENEMY", 0)
		vsched.ConstantlyFaceEnemy = true
		vsched.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end
		self:StartSchedule(vsched)

end

function ENT:CustomOnThink_AIEnabledExtracode()

	if self.CanJetpackJump == true then
	
	
	if self.JetpackJump_activated == 1 and self.JetpackJump_jumping == 1 then
	
	local tracedataAD = {}
	tracedataAD.start = self:GetPos() + Vector(0,0,40)
	tracedataAD.endpos = self:GetPos() + Vector(0,0,-30)
	tracedataAD.filter = {self}
	local trAD = util.TraceLine(tracedataAD)
	
	if (self.JetpackJump_durationT < CurTime()) or ( trAD.HitWorld ) or ( trAD.Entity != nil and IsValid(trAD.Entity) and trAD.Entity != self:GetActiveWeapon() and trAD.Entity != self) then
	
		self.JetpackJump_jumping = 0
		self:SetFriction(self.JetpackJump_originalgravity)
		self.CurrentAttackAnimation = self.JetpackJump_landanim
		--self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -0.1,function()
			if IsValid(self) then
				self.MovementType = self.JetpackJump_originalmovetype
				self.CanFlinch = self.JetpackJump_originalflinch
				self.CanTurnWhileStationary = true
				--self:SetFriction(self.JetpackJump_originalgravity)
				local physw11 = self:GetPhysicsObject()
						if ( IsValid( physw11 ) ) then
							physw11:EnableDrag(self.JetpackJump_originaldrag)
						end	
				timer.Simple(1,function()
				if IsValid(self) then
				self.CanPerformMeleeCharge = self.JetpackJump_originalmelee 
				end 
				end)
				self.vACT_StopAttacks = false
				self.NextChaseTime = CurTime() + 0.2
				self.NextIdleTime = CurTime() 
				self.JetpackJump_NextT = CurTime() + self.JetpackJump_Cooldown
				self:ClearSchedule()
				self.JetpackJump_activated = 0
				self:VJ_ACT_PLAYACTIVITY( VJ_PICKRANDOMTABLE(self.AnimTbl_IdleStand),false,0.2,false,0,{})
				if IsValid(self.JetpackJump_originalenemy) and self.JetpackJump_originalenemy != NULL then
					self:FaceCertainPosition(self.JetpackJump_originalenemy:GetPos())
				end
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,0.5,false,0,{SequenceDuration=(0.5)})
		
	end
	
	end
	
	if self.JetpackJump_NextT < CurTime() and self.JetpackJump_activated == 0 and self.MovementType == VJ_MOVETYPE_GROUND and self.vACT_StopAttacks == false then
	
	if (IsValid(self:GetEnemy()) and math.random(1,10) >= self.JetpackJump_Chance) or (self.JetpackJumpEscape_activated == 1) then
	self.JetpackJump_NextT = CurTime() + self.JetpackJump_Nexttime
	if (IsValid(self:GetEnemy()) and self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < self.JetpackJump_Rangemax*self.JetpackJump_Rangemax and self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) > self.JetpackJump_Rangeclose*self.JetpackJump_Rangeclose) or (self.JetpackJumpEscape_activated == 1) then
	
		local targetent = self
		if IsValid(self:GetEnemy()) and self.JetpackJumpEscape_activated != 1 then
			targetent = self:GetEnemy()
		end
		local attackspottbl = {targetent:GetForward()*math.random(0,100) +targetent:GetRight()*math.random(-100,100),
			targetent:GetForward()*math.random(-100,80) +targetent:GetRight()*math.random(-100,100),
			targetent:GetForward()*math.random(-100,80) +targetent:GetRight()*math.random(-120,120),
			targetent:GetForward()*math.random(-120,0) +targetent:GetRight()*math.random(-150,150),
			targetent:GetForward()*math.random(-120,0) +targetent:GetRight()*math.random(-50,50)}
		local chosenpos = Vector(0,0,0)
		local sutiableattackpos = {}
		local actualattackpos = Vector(0,0,0)
		local tracss = {}
		local tracc = {}
		local tracssdata = {}
		local tracsscx = {}
		--local enemydirection = Vector(0,0,0)
		local enemyeyepos = targetent:EyePos()
		local postocheck = Vector(0,0,0)
		--local timeaddition = 0
		local isenemyunreachable = false
		if IsValid(self:GetEnemy()) and self.JetpackJumpEscape_activated != 1 and self:IsUnreachable(self:GetEnemy()) == true and self:GetEnemy():GetPos().z > self:GetPos().z then
			isenemyunreachable = true
		end
		--print("niggs")
			for k,vapos in ipairs(attackspottbl) do
			if table.Count( sutiableattackpos ) <= 3 then
			--print("ni99a")
				tracssdata = {
						start = enemyeyepos,
						endpos = enemyeyepos +vapos:GetNormalized()*math.random(self.JetpackJump_Rangemin+100,self.JetpackJump_Rangeclose),
						filter = {self,self:GetActiveWeapon(),targetent}
						}
				if self.JetpackJumpEscape_activated == 1 then tracssdata.endpos = enemyeyepos +vapos:GetNormalized()*math.random(self.JetpackJump_Rangeclose,self.JetpackJump_Rangemax) end
				if IsValid(self:GetEnemy()) and self.JetpackJumpEscape_activated != 1 and self:GetEnemy():GetActiveWeapon() != NULL and self:GetEnemy():GetActiveWeapon() != nil then tracssdata.filter = {self,self:GetActiveWeapon(),targetent,self:GetEnemy():GetActiveWeapon()} end
				
				tracss = util.TraceLine(tracssdata)
				

				
				--if tracss.HitWorld == true or (tracss.Entity != nil and tracss.Entity != NULL and (tracss.Entity:GetClass() == "prop_physics" or tracss.Entity:GetClass() == "prop_dynamic" ) ) then 
				if tracss.HitPos:DistToSqr(enemyeyepos) > self.JetpackJump_Rangemin*self.JetpackJump_Rangemin then
				
				tracc = util.TraceLine({
						start = tracss.HitPos,--trace11.HitPos + Vector(0,0,70),
						endpos = tracss.HitPos + Vector(0,0,-128),
						filter = {self,self:GetActiveWeapon()}
						})
				if tracc.HitWorld == true or (tracc.Entity != NULL and tracc.Entity != nil and (tracc.Entity:GetClass() == "prop_dynamic" or tracc.Entity:GetClass() == "prop_physics")) then
				--table.insert( sutiableattackpos, pointa:GetPos() )
				--table.insert( sutiableattackpos, tracss.HitPos+Vector(0,0,-15) )
				postocheck = tracss.HitPos+Vector(0,0,-10)
				if isenemyunreachable == true then
				tracsscx = util.TraceLine({
						start = postocheck,
						endpos = postocheck+Vector(0,0,-800),
						filter = {self,self:GetActiveWeapon()}
						})
				if tracsscx.HitWorld == true then postocheck = tracsscx.HitPos +Vector(0,0,20) end
				end

				local greShootVel = postocheck -self:GetPos()

				local selfpos = self:GetPos() + self:GetUp()*50
				local heightdifference = postocheck.z - selfpos.z
			
			--if math.random(self.GrenadeThrowHigh_chance,50) > -40 then
				postocheck = postocheck + Vector(0,0,5)
			
				local targetdir = postocheck -selfpos
				local Midpoint = Vector((selfpos.x + postocheck.x)/2,(selfpos.y + postocheck.y)/2,(selfpos.z + postocheck.z)/2)
				local midpointdist = selfpos:Distance( Midpoint )
				local midpointupper = Midpoint + Vector(0,0, midpointdist*1.732 ) --/1 for tan45 , 1.731 for tan60 (sqroot 3)
				heightdifference = postocheck.z - selfpos.z
			


				local vel_range = 0
				local vel_force	= 0
				local failedsecondcheck = 0
				local failedsecondchecka = 0
				local failedsecondcheck2 = 0
				local failedsecondcheck2a = 0
				--local failedsecondcheck3 = 0
				local issutiablepos = 0
				local tr2 = util.TraceEntity({
							start = midpointupper,
							endpos = postocheck,
							filter = {self}
							},self)
				local tr3 = util.TraceEntity({
							start = selfpos,
							endpos = midpointupper,
							filter = {self}
							},self)
				if tr2.HitPos:DistToSqr(postocheck) > 64*64 then failedsecondcheck = 1 end
				if tr3.HitPos:DistToSqr(midpointupper) > 64*64 then failedsecondchecka = 1 end
			
				if failedsecondcheck == 0 and failedsecondchecka == 0 then
				greShootVel = midpointupper -self:GetPos()
				issutiablepos = 1
				--local vel_lengthz = math.sqrt( 22.86*(midpointupper.z - selfpos.z) ) 
				--local vel_lengthx = (midpointdist*2)/((vel_lengthz*2)/11.43) --calculate the flight time of grenade
				--local vel_force =  math.sqrt( vel_lengthx*vel_lengthx + vel_lengthz*vel_lengthz )
				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/1.732)
				vel_force = math.sqrt( (11.43*vel_range)/(0.8632) ) --1 unit = 0.01905m sin 2.1 rad = 0.8632
				
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
				
				else
				midpointupper = Midpoint + Vector(0,0, midpointdist/1 ) --try 45 degrees
				--if math.abs(heightdifference) > 1 then 
				--midpointupper = midpointupper + Vector(0,0, heightdifference/2) + targetdir:GetNormalized()*(heightdifference/2)
				--end

						
				local tr2a = util.TraceEntity({
							start = midpointupper,
							endpos = postocheck,
							filter = {self}
							},self)
				local tr3a = util.TraceEntity({
							start = selfpos,
							endpos = midpointupper,
							filter = {self}
							},self)
				if tr2a.HitPos:DistToSqr(postocheck) > 64*64 then failedsecondcheck2 = 1 end
				if tr3a.HitPos:DistToSqr(midpointupper) > 64*64 then failedsecondcheck2a = 1 end

				if failedsecondcheck2 == 0 and failedsecondcheck2a == 0 then 
				greShootVel = midpointupper -self:GetPos()
				issutiablepos = 1
				
				--local vel_lengthz = math.sqrt( 22.86*(midpointupper.z - selfpos.z) ) 
				--local vel_lengthx = (midpointdist*2)/( (vel_lengthz*2)/11.43 ) --calculate the flight time of grenade
				--local vel_force =  math.sqrt( vel_lengthx*vel_lengthx + vel_lengthz*vel_lengthz )

				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/1)
				vel_force = math.sqrt( (11.43*vel_range)/(1) ) --1 unit = 0.01905m sin 1.57 rad = 0.99999
	
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
				
				end
				

				end
				
				
				if issutiablepos == 1 then
				table.insert( sutiableattackpos, greShootVel )
				--print("ni")
				end
				
				--end
				
				
				
			end
			end
			end
	
	
	
	
	
	
			end
			
					if actualattackpos == Vector(0,0,0) and table.Count( sutiableattackpos ) >= 1 then
						local useablepos = VJ_PICKRANDOMTABLE(sutiableattackpos)
						if useablepos != nil and useablepos != NULL and useablepos != Vector(0,0,0) and useablepos != false then
							actualattackpos = useablepos
						end
					end
					
					if actualattackpos != Vector(0,0,0) then 
					
						self.JetpackJump_activated = 1
						if self.JetpackJumpEscape_activated == 1 then self.JetpackJumpEscape_activated = 0 end
						self.JetpackJump_NextT = CurTime() + self.JetpackJump_Cooldown
						self.JetpackJump_originalgravity = self:GetFriction()
						self.JetpackJump_originalmovetype = self.MovementType
						self.JetpackJump_originalflinch = self.CanFlinch
						self.JetpackJump_originalmelee = self.CanPerformMeleeCharge
						self.CanPerformMeleeCharge = false
						self.CanFlinch = 0
						self.MovementType = VJ_MOVETYPE_STATIONARY
						self.CanTurnWhileStationary = false
						self:SetFriction(0)
						self:FaceCertainPosition( self:GetPos() +actualattackpos:GetNormalized()*1000 )
						self.CurrentAttackAnimation = self.JetpackJump_anim
						self:ClearSchedule()
						self:StopMoving()
						self.Weapon_ShotsSinceLastReload = 0
						if IsValid(self:GetEnemy()) then
						self.JetpackJump_originalenemy = self:GetEnemy()
						else
						self.JetpackJump_originalenemy = NULL
						end
						self.JetpackJump_durationT = CurTime() + self.JetpackJump_duration
				
						self:StopAttacks(true)
						self.vACT_StopAttacks = true
						self.NextChaseTime = CurTime() + self.JetpackJump_duration + 0.6
						self.NextIdleTime = CurTime() + self.JetpackJump_duration + 0.6
			
						self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,false,(self.JetpackJump_duration+0.5),false,0,{SequenceDuration=(self.JetpackJump_duration+0.5)})
	
						local physw1 = self:GetPhysicsObject()
						if ( IsValid( physw1 ) ) then
							--self.JetpackJump_originaldragn = 0
							self.JetpackJump_originaldrag = physw1:IsDragEnabled() 
							physw1:EnableDrag(false)
							--physw1:SetVelocity(actualattackpos +self:GetUp()*math.random(0,10) )
				
						end
	
						self:SetVelocity( actualattackpos +self:GetUp()*math.random(0,10) )
						
						timer.Simple(0.4,function()
						if IsValid(self) then
						if self.JetpackJump_jumping != 1 and self.JetpackJump_activated == 1 then
							self.JetpackJump_jumping = 1
						end
						end
						end)
						
							if self.HasSounds != false then
							local soundtbl = self.SoundTbl_JetpackSound
							if VJ_PICKRANDOMTABLE(soundtbl) != false then
								self.CurrentMeleeAttackSound = VJ_CreateSound(self,soundtbl,90,100)
							end
							end
	
					end
			
			
	end

	end
	end
	end

end

function ENT:CustomOnThink_AIEnabled()

	if self.Dead == true then return end
	
	self:CustomOnThink_AIEnabledExtracode()
	
	if self.CanFixPathFailed == true then
	local CurSchedc = self.CurrentSchedule
	
	if CurSchedc == nil then
	if self.FixPathFailed_schedule == 1 then
	if (!self:IsMoving() or (self:GetBlockingEntity() != nil && self:GetBlockingEntity():IsNPC())) then 
		self:CustomOnMovingPathFailed()
	end
	end
		self.FixPathFailed_schedule = 0
	end
	
	if CurSchedc != nil then
	if CurSchedc.StopScheduleIfNotMoving == true then
		self.FixPathFailed_schedule = 1
	else
		self.FixPathFailed_schedule = 0
	end
	end
	
	end
	
	
	/*
	if self.CanFixPathFailed == true and self.FixPathFailed_NextT < CurTime() then
	self.FixPathFailed_NextT = CurTime() + self.FixPathFailed_Next
	local CurSchedc = self.CurrentSchedule
	if CurSchedc != nil then
		if CurSchedc.StopScheduleIfNotMovingEx == true && (!self:IsMoving() or (self:GetBlockingEntity() != nil && self:GetBlockingEntity():IsNPC())) then
			--if self.FixPathFailed_schedule != CurSchedc then
			--self.FixPathFailed_schedule = CurSchedc
			--self.FixPathFailed_duration = 0
			--else
			--self.FixPathFailed_duration = self.FixPathFailed_duration+0.5
			--end
			--if self.FixPathFailed_duration >= 1.2 then
			if self:DoRunCode_OnFail(CurSchedc) == true then
				--self:ClearCondition(35)
				self:ScheduleFinished(CurSchedc)
			end
		--	end
			--if CurSchedc.AlreadyRanCode_OnFail != true then
			--	if CurSchedc.RunCode_OnFail != nil then CurSchedc.AlreadyRanCode_OnFail = true CurSchedc.RunCode_OnFail() end
			--end
		end
	end
	
	end
	*/
	
	
	
	if self.CanSmartDetectGrenades == true and CurTime() > self.NextProcessT then
	
		self:SmartCheckForGrenades()
	
	end
	
	if self.CanAimCorrect == true then 
	if self.AimCorrect_NextT < CurTime() and self.vACT_StopAttacks != true and self.Weapon_StartingAmmoAmount != nil and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and IsValid(self:GetEnemy()) and (self:VJ_HasActiveWeapon() != false) then
	self.AimCorrect_NextT = CurTime() + self.AimCorrect_Var.Nexttime
	if self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.DoingWeaponAttack == true and self:GetActiveWeapon():LookupAttachment("muzzle_flash") > 0 and self:Visible(self:GetEnemy()) then
	local bulletpos = self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle_flash")).Pos
	local enemypos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
	local aimhigher = true
	local hitent = false
	local trx = util.TraceLine({
		start = bulletpos,
		endpos = enemypos,
		filter = {self,self:GetActiveWeapon()}
	})

	if trx.Entity != self:GetEnemy() then
	for k,v in ipairs(ents.FindInSphere(trx.HitPos,5)) do
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitent = true
		end
	end
	end
	
	if hitent == true then aimhigher = false end
	if trx.Entity == self:GetEnemy() and trx.HitWorld == true then aimhigher = false end
	if aimhigher == true then
		self.AimCorrect_activated = 1
	else
		self.AimCorrect_activated = 0
	end
	
	else
	if !self:Visible(self:GetEnemy()) or self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount then
		self.AimCorrect_activated = 0
	end
	
	end
	
	end
	
		if self.AimCorrect_activated == 1 then
			self.WeaponUseEnemyEyePos = true
		end
	
	end
	
	
	if self.CanLookForCover == true then
	if self.LookForCover_NextT < CurTime() and self.LookForCover_activated != 1 and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and self.vACT_StopAttacks != true and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_goto_lastpos") or (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_flank_enemy" and self.FlankEnemy_ResetNextT <= CurTime() + 17)) then
	self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime

	if self.SmartAttackPos_NextT < CurTime() then
	self.SmartAttackPos_NextT = CurTime() + 0.8
	end
	
	if IsValid(self:GetEnemy()) and math.random(1,10) >= self.LookForCover_Var.Chance then
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < self.Weapon_FiringDistanceFar*self.Weapon_FiringDistanceFar and self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) > 200*200 then
	--print("nig1")
		local tras = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tras.HitWorld != true and ( (tras.Entity != nil and tras.Entity != NULL and tras.Entity == self:GetEnemy() ) ) ) or self:NearestPoint(self:GetPos() +self:OBBCenter()):DistToSqr(tras.HitPos) > 60*60 then 
	
		--local hidingspot = self:GetForward()*10 + self:GetRight()*10
		local orgpos = self:GetPos() +self:GetUp()*36
		/*
		local randomnumber = math.random(1,10)
	
		if randomnumber == 1 then hidingspot = self:GetForward()*2.679 +self:GetRight()*10 end		--15 degree
		if randomnumber == 2 then hidingspot = self:GetForward()*2.679 +self:GetRight()*-10 end 
		if randomnumber == 3 then hidingspot = self:GetForward()*5.773 +self:GetRight()*10 end		--30 degree
		if randomnumber == 4 then hidingspot = self:GetForward()*5.773 +self:GetRight()*-10 end		
		if randomnumber == 5 then hidingspot = self:GetForward()*10 +self:GetRight()*10 end		--45 degree
		if randomnumber == 6 then hidingspot = self:GetForward()*10 +self:GetRight()*-10 end
		if randomnumber == 7 then hidingspot = self:GetForward()*17.32 +self:GetRight()*10 end
		if randomnumber == 8 then hidingspot = self:GetForward()*17.32 +self:GetRight()*-10 end
		if randomnumber == 9 then hidingspot = self:GetForward()*37.32 +self:GetRight()*10 end
		if randomnumber == 10 then hidingspot = self:GetForward()*37.32 +self:GetRight()*-10 end
		*/
		
		local hidingspottbl = {self:GetForward()*2.679 +self:GetRight()*10,
			self:GetForward()*2.679 +self:GetRight()*-10,
			self:GetForward()*5.773 +self:GetRight()*10,	
			self:GetForward()*5.773 +self:GetRight()*-10,
			self:GetForward()*10 +self:GetRight()*10,
			self:GetForward()*10 +self:GetRight()*-10,
			self:GetForward()*17.32 +self:GetRight()*10,
			self:GetForward()*17.32 +self:GetRight()*-10,
			self:GetForward()*37.32 +self:GetRight()*10,
			self:GetForward()*37.32 +self:GetRight()*-10}
		local chosenspot = Vector(0,0,0)
		local usablespots = {}
		local actualcoverpos = Vector(0,0,0)
		local trac = {}
		local trac1 = {}
		local trac2 = {}
		local trac2a = {}
		local trac2aendingpos = Vector(0,0,0)
		local enemydir = Vector(0,0,0)
		local uselastenemypos = false
		if self.SmartGrenadeThrow_enemyvisible_lastposition != Vector(0,0,0) and self.SmartGrenadeThrow_enemyvisible_NextT > CurTime() +self.SmartGrenadeThrow_enemyvisible_Next/2 and self.SmartGrenadeThrow_enemyvisible_previously == 1 and self.SmartGrenadeThrow_enemyvisibleshared == 0 then
		trac2aendingpos = Vector(self.SmartGrenadeThrow_enemyvisible_lastposition.x,self.SmartGrenadeThrow_enemyvisible_lastposition.y,self:GetEnemy():EyePos().z)
		uselastenemypos = true
		end
		if (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_flank_enemy" and self.FlankEnemy_ResetNextT > CurTime() + 14)  then
		uselastenemypos = false
		end
		if math.random(1,10) >= 4 then 
		local orgdirection = self:GetForward()*math.random(-450,-100) +self:GetRight()*math.random(-64,64)
		local traca = util.TraceLine({
						start = orgpos,
						endpos = orgpos + orgdirection,--self:GetForward()*math.random(-450,-100),
						filter = {self,self:GetActiveWeapon()}
						})
		orgpos = traca.HitPos + orgdirection:GetNormalized()*-20 --self:GetForward()*20
		end
		--local hidingspotdir = hidingspot:GetNormalized()
		for k,vpos in ipairs(hidingspottbl) do
		if chosenspot == Vector(0,0,0) or table.Count( usablespots ) <= 5 then
		--print("ni99a")
				trac = util.TraceLine({
						start = orgpos,
						endpos = orgpos +vpos:GetNormalized()*self.LookForCover_Var.Range,
						filter = {self,self:GetActiveWeapon()}
						})
				if trac.HitWorld == true or (trac.Entity != nil and trac.Entity != NULL and (trac.Entity:GetClass() == "prop_physics" or trac.Entity:GetClass() == "prop_dynamic" ) ) then 
				enemydir = (self:GetEnemy():GetPos() +self:GetEnemy():GetUp()*36 ) -trac.HitPos
				actualcoverpos = trac.HitPos + enemydir:GetNormalized()*(-20)
				
				--print("ni9")
				trac1 = util.TraceLine({
						start = actualcoverpos + Vector(0,0,0),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})

						
				if (trac1.HitWorld == true or (trac1.Entity != nil and trac1.Entity != NULL and (trac1.Entity:GetClass() == "prop_physics" or trac1.Entity:GetClass() == "prop_dynamic" ) )) then 
				
				trac2 = util.TraceLine({
						start = actualcoverpos + Vector(0,0,19),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
				if uselastenemypos == true then
						trac2a = util.TraceLine({
						start = actualcoverpos + Vector(0,0,19),
						endpos = trac2aendingpos,
						filter = {self,self:GetActiveWeapon()}
						})
				end
				
				if (trac2.HitWorld != true and ( self:GetEnemy():EyePos():DistToSqr(trac2.HitPos) <= 22*22 or (trac2.Entity != nil and trac2.Entity != NULL and trac2.Entity == self:GetEnemy() ) )) or (uselastenemypos == true and trac2a.HitWorld != true and trac2aendingpos:DistToSqr(trac2a.HitPos) <= 20*20 ) then

				--chosenspot = actualcoverpos
					table.insert( usablespots, actualcoverpos )
					local isclosestone = 1
					for ku,usepos in pairs(usablespots) do
					if usepos != nil and usepos != NULL then
					if self:GetPos():DistToSqr(usepos) < self:GetPos():DistToSqr(actualcoverpos) then 
						--chosenspot = actualcoverpos
						isclosestone = 0
					end
					end
					end
					if isclosestone == 1 then chosenspot = actualcoverpos end
					
				end
				end
				end
			end
			end
			
			if chosenspot != Vector(0,0,0) then
					self:SetLastPosition(chosenspot)
					self.CurrentCoveringPosition = chosenspot
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 1
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.2
					self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime*3.0
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*2
					self.NextChaseTime = CurTime() + 5
					self.NextIdleTime = CurTime() + 5
					self.LookForCover_activated = 1
					--print("nigdone")
					timer.Simple(5,function()
					if IsValid(self) then
					if self.LookForCover_activated == 1 then self.LookForCover_activated = 0 end
					end
					end)
			end
			
			
		end
	end
	end
	
	if self.CanTrickShoot == true then
	if CurTime() > self.TrickShoot_NextT and self.TrickShoot_activated == 0 and self.MovementType == VJ_MOVETYPE_GROUND and /*self.CurrentSchedule == nil and self:IsMoving() == false and*/ self.vACT_StopAttacks == false then
	self.TrickShoot_NextT = CurTime() + self.TrickShoot_Nexttime
	--	print("n199a")
	if IsValid(self:GetEnemy()) and ((self.DoingWeaponAttack == true and self.DoingWeaponAttack_Standing == true) or (self.LastSeenEnemyTime < 4)) and math.random(1,10) >= self.TrickShoot_Chance then
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < self.TrickShoot_Range*self.TrickShoot_Range then
	if (self.TrickShoot_OnlyWhenEnemyLooking == false) or (self:GetEnemy():GetForward():Dot((self:GetPos() -self:GetEnemy():GetPos()):GetNormalized()) > math.cos(math.rad(self.TrickShoot_OnlyWhenEnemyLookingradius))) then
		
		local chosenspottododge = Vector(0,0,0)
		local randomside = 1
		if math.random(0,1) == 1 then randomside = -1 end
		local isincover = true
		local canonlychooseoneside = false
		local ismovingnow = false
		local trase = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (trase.HitWorld != true and ( (trase.Entity != nil and trase.Entity != NULL and trase.Entity == self:GetEnemy() ) ) ) or self:NearestPoint(self:GetPos() +self:OBBCenter()):DistToSqr(trase.HitPos) > 120*120 then 
			isincover = false
		end
		
		if self.CurrentSchedule != nil and self:IsMoving() == true then
			ismovingnow = true
			canonlychooseoneside = true
			local velpos = self:GetPos() +self:GetVelocity():GetNormalized()*100 --self:GetGroundSpeedVelocity():GetNormalized()*100
			if velpos:DistToSqr( (self:GetPos() +self:GetRight()*100) ) < velpos:DistToSqr( (self:GetPos() +self:GetRight()*-100) ) then 
				randomside = 1
			else
				randomside = -1
			end
		end
		
		local trace11tbl = {
						start = self:GetPos() +self:GetUp()*5,
						endpos = self:GetPos() +self:GetUp()*5 +self:GetRight()*math.random(self.TrickShoot_Rangemin+5,self.TrickShoot_Rangemax)*randomside,
						filter = {self,self:GetActiveWeapon()}
						}
		local trace11 = {}
		local trace11b = {}
		local trace11c = {}
		local trace11c2 = {}
		local trace11c3 = {}
		local trace11d = {}
		trace11 = util.TraceEntity(trace11tbl,self)
		--print("n1994")
		if self:GetPos():DistToSqr( trace11.HitPos ) >= self.TrickShoot_Rangemin*self.TrickShoot_Rangemin then
		trac11b = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:EyePos().z-15),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})

						
			if (trac11b.HitPos:DistToSqr(self:GetEnemy():EyePos()) <= 2*2 or trac11b.Entity == self:GetEnemy()) or self.TrickShootHide_GoHide == 1 then
			
			trac11c = util.TraceLine({
						start = trace11.HitPos,--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(0,0,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c2 = util.TraceLine({
						start = trace11.HitPos + Vector(10,10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(10,10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c3 = util.TraceLine({
						start = trace11.HitPos + Vector(-10,-10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(-10,-10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			if trac11c.HitWorld == true and trac11c2.HitWorld == true and trac11c3.HitWorld == true then
			
				if isincover == true then 
					trac11d = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:NearestPoint(self:GetPos()+self:OBBCenter()).z),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
					if trac11d.HitWorld == true or (trac11d.Entity != NULL and trac11d.Entity != nil and (trac11d.Entity:GetClass() == "prop_dynamic" or trac11d.Entity:GetClass() == "prop_physics")) then 
						chosenspottododge = trace11.HitPos
					end
				else
					chosenspottododge = trace11.HitPos
				end
				
			end
			
			end
		end
		if chosenspottododge == Vector(0,0,0) and canonlychooseoneside == false then
		trace11tbl = {
						start = self:GetPos() +self:GetUp()*5,
						endpos = self:GetPos() +self:GetUp()*5 +self:GetRight()*math.random(self.TrickShoot_Rangemin+5,self.TrickShoot_Rangemax)*randomside*-1,
						filter = {self,self:GetActiveWeapon()}
						}
		trace11 = util.TraceEntity(trace11tbl,self)
		--print("n19944")
		if self:GetPos():DistToSqr( trace11.HitPos ) >= self.TrickShoot_Rangemin*self.TrickShoot_Rangemin then
		trac11b = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:EyePos().z-15),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
			if (trac11b.HitPos:DistToSqr(self:GetEnemy():EyePos()) <= 2*2 or trac11b.Entity == self:GetEnemy()) or self.TrickShootHide_GoHide == 1 then
			
			trac11c = util.TraceLine({
						start = trace11.HitPos,--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(0,0,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c2 = util.TraceLine({
						start = trace11.HitPos + Vector(10,10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(10,10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c3 = util.TraceLine({
						start = trace11.HitPos + Vector(-10,-10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(-10,-10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			if trac11c.HitWorld == true and trac11c2.HitWorld == true and trac11c3.HitWorld == true then
			
				if isincover == true then 
					trac11d = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:NearestPoint(self:GetPos()+self:OBBCenter()).z),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
					if trac11d.HitWorld == true or (trac11d.Entity != NULL and trac11d.Entity != nil and (trac11d.Entity:GetClass() == "prop_dynamic" or trac11d.Entity:GetClass() == "prop_physics")) then 
						chosenspottododge = trace11.HitPos
					end
				else
					chosenspottododge = trace11.HitPos
				end
				
			end
			
			end
		end
		end
		if self.TrickShootHide_GoHide == 1 then self.TrickShootHide_GoHide = 0 end
		if chosenspottododge != Vector(0,0,0) then
			self.TrickShoot_activated = 1
			self.TrickShoot_NextT = CurTime() + self.TrickShoot_Cooldown
			self.ProneCover_NextT = CurTime() + self.ProneCover_Nexttime*3
			self.BlindFire_NextT = CurTime() + self.BlindFire_Nexttime*2
				
			local greShootVel = chosenspottododge -self:GetPos()
			local selfpos = self:GetPos()
			local heightdifference = chosenspottododge.z - selfpos.z
			local targetdir = chosenspottododge -selfpos
			local Midpoint = Vector((selfpos.x + chosenspottododge.x)/2,(selfpos.y + chosenspottododge.y)/2,(selfpos.z + chosenspottododge.z)/2)
			local midpointdist = selfpos:Distance( Midpoint )
			local midpointupper = Midpoint + Vector(0,0, midpointdist*0.3639 ) --/1 for tan45 , 1.731 for tan60 (sqroot 3), 0.5773 tan 30 , tan 20 0.36397
			local tr = util.TraceLine({
							start = self:GetPos() + self:GetUp()*85,
							endpos = midpointupper,
							filter = {self}
							})
			local vel_range = 0
			local vel_force	= 0
				greShootVel = midpointupper -selfpos
				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/0.3639)
				vel_force = math.sqrt( (11.43*vel_range)/(0.6428) ) --1 unit = 0.01905m sin 2.1 rad = 0.8632 -- 11.43 sin 0.6981 rad
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
			local enabledrag = true
			local physo = self:GetPhysicsObject()
			if (physo:IsValid()) then
				enabledrag = physo:IsDragEnabled()
				physo:EnableDrag( false )
			end
			self:SetGroundEntity(NULL)
			self:SetVelocity(greShootVel*1.0)
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(15,-9,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Thigh",Angle(-15,0,0))
		--	print("n199")
			timer.Simple(0.5,function()
			if IsValid(self) then
			if self.TrickShoot_activated == 1 then
				self.TrickShoot_activated = 0
				if (physo:IsValid()) then
				physo:EnableDrag( enabledrag )
				end
				self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,0,0))
				self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Thigh",Angle(0,0,0))
				--print("h1009")
			end
			end
			end)
			
		end
	end
	end
	end
	
	end
	end
	
	end
	end
	
	


	
	if self.CanProneCover == true then
	
	if self.ProneCover_activated == 1 and self.ProneCover_goingprone != 1 and CurTime() > self.ProneCover_durationT and self.ThrowingGrenade != true and self.vACT_StopAttacks != true and self.Flinching != true and self.BlindFire_activated == 0 and self.CornerCover_activated == 0 then

		local tra = util.TraceLine({
						start = self:GetPos() + self:GetForward()*75,
						endpos =  self:GetPos() + self:GetForward()*75 + Vector(0,0,-90),
						filter = {self,self:GetActiveWeapon()}
						})
		if tra.HitWorld == true or (tra.Entity != nil and tra.Entity != NULL and !tra.Entity:IsNPC() and !tra.Entity:IsPlayer() ) then 
	
		local pronecoverduration = self.ProneCover_Var.duration + (math.random(0,self.ProneCover_Var.durationextra)/10)
		--self.ProneCover_goingprone = 1
		self.ProneCover_durationT = CurTime() + pronecoverduration
		self.NextChaseTime = CurTime() + pronecoverduration + 0.8
		self.TakingCoverT = CurTime() + pronecoverduration + 0.8
		self.NextCallForHelpT = CurTime() + pronecoverduration + self.NextCallForHelpTime
		self.NextWeaponAttackT = CurTime() + (pronecoverduration + 0.8)
		self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + pronecoverduration/2
		self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + pronecoverduration/2
		self.CanFlinch = 0
		self.MoveOrHideOnDamageByEnemy = false
		self:ClearPoseParameters()
		self.ProneCover_Var.CanPose = self.HasPoseParameterLooking
		self.HasPoseParameterLooking = false
		self.ProneCover_Var.WeaponSpread = self.WeaponSpread
		self.WeaponSpread = self.WeaponSpread*1.2
		--self.ProneCover_Var.Hulltype = self:GetHullType()
		local vec1, vec2 = self:GetCollisionBounds()
		if vec1 != nil then
			self.ProneCover_Var.Collidebound1 = vec1
			self.ProneCover_Var.Collidebound2 = vec2
		end
		
		self.CurrentAttackAnimation = "vjseq_arrestidle"
	
		self.PlayingAttackAnimation = true
		timer.Simple( (pronecoverduration+1) -0,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:FaceCertainEntity(self:GetEnemy(),false)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,(pronecoverduration+0),true,0,{SequenceDuration=(pronecoverduration+0)})
		self:SetAbsVelocity( self:GetForward()*120 + self:GetUp()*50 ) 
		timer.Simple(0.35,function()
		if IsValid(self) then
			--self:SetHullType(HULL_TINY)
			--self:SetHullSizeNormal() 

			print(self:GetHullType())
			self.ProneCover_goingprone = 1
			--self.ForceWeaponFire_activated = 1
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(-45,0,60))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,-15,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(30,90,-30))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine4",Angle(0,-30,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_UpperArm",Angle(0,30,60))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Calf",Angle(0,-105,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Calf",Angle(0,-105,0))
			timer.Simple(0.08,function()
			if IsValid(self) then
				self:SetCollisionBounds(Vector(35, 22 , 25), Vector(-35, -22, 0))
			end
			end)
			timer.Simple(0.35,function()
			if IsValid(self) then
			if !IsValid(self:GetEnemy()) and self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance).ItFoundAllies == true then
				self:BringAlliesToMe(self.CallForBackUpOnDamageDistance,self.CallForBackUpOnDamageUseCertainAmount,self.CallForBackUpOnDamageUseCertainAmountNumber)
			end
			end
			end)
		end 
		end)
	
		end
	

	end
	
	
	if self.ProneCover_goingprone == 1 then
	if self.ProneCover_durationT < CurTime() or ((self.ProneCover_durationT-(self.ProneCover_Var.duration/1.5)) < CurTime() and self:GetSequenceName(self:GetSequence()) != "arrestidle" ) or self.Flinching == true then
	--print(self:GetSequenceName(self:GetSequence()))
	self.ProneCover_activated = 0
	self.ProneCover_goingprone = 0
	self.ProneCover_NextT = CurTime() + self.ProneCover_Var.Cooltime
	self.ForceWeaponFire_activated = 0
	
	self.CanFlinch = self.ProneCover_Var.CanFlinch
	self.CallForHelp = self.ProneCover_Var.CanCallHelp
	self.DisableTakeDamageFindEnemy = self.ProneCover_Var.CanFindEnemy
	self.RunAwayOnUnknownDamage = self.ProneCover_Var.CanRunAway
	self.MoveOrHideOnDamageByEnemy = self.ProneCover_Var.CanCover
	self.CallForBackUpOnDamage = self.ProneCover_Var.CanCallHelp
	self.HasPoseParameterLooking = self.ProneCover_Var.CanPose
	self.WeaponSpread = self.ProneCover_Var.WeaponSpread
	--if self.HasHull == true then 
	--self:SetHullType(self.ProneCover_Var.Hulltype) 
	--self:SetHullSizeNormal() 
	--print(self:GetHullType())
	--end
	if self.ProneCover_Var.Collidebound1.x > self.ProneCover_Var.Collidebound2.x then
	self:SetCollisionBounds(self.ProneCover_Var.Collidebound1, self.ProneCover_Var.Collidebound2)
	else
	self:SetCollisionBounds(self.ProneCover_Var.Collidebound2, self.ProneCover_Var.Collidebound1)
	end
		timer.Simple(0.12,function()
		if IsValid(self) then
		self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine4",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_L_UpperArm",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Calf",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Calf",Angle(0,0,0))
		end
		end)
	if self.ProneCover_durationT < CurTime() and self:GetSequenceName(self:GetSequence()) == "arrestidle" then 
		--self:DoIdleAnimation()
		self.CurrentAttackAnimation = "vjseq_crouch_idled"
		self.PlayingAttackAnimation = true
		timer.Simple((0.6),function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,(0.6),true,0,{SequenceDuration=(0.6)})
		print("11")
		print(self:GetHullType())
	else
	print( self:GetSequenceName(self:GetSequence()) )
	end
	
	if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then
	if self:GetActiveWeapon().NPC_isRangeCooldown != nil then
		self:GetActiveWeapon().NPC_isRangeCooldown = 0
		self:GetActiveWeapon().NPC_firecontrolshotfired = 0
	end
	end
	
	
	end
	end
	
	end

	


	
	if self.CanForceWeaponFire == true and self.ForceWeaponFire_activated == 1 then
	
	if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
	if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
	
	self:GetActiveWeapon():PrimaryAttack()
	self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
	
	end
	end
	
	timer.Simple(0.03,function()
	if IsValid(self) then
		if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
		if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
		self:GetActiveWeapon():PrimaryAttack()
		self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
		end
		end
	end
	end)
	
	timer.Simple(0.06,function()
	if IsValid(self) then
		if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
		if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
		self:GetActiveWeapon():PrimaryAttack()
		self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
		end
		end
	end
	end)
	
	
	
	end

	
	if self.CanFlankEnemy == true then
	
	if self.FlankEnemy_ResetNextT < CurTime() and self:GetEnemy() == nil and self.CurrentSchedule != nil then
	if self.CurrentSchedule.Name == "vj_flank_enemy" then 
	self:ClearSchedule()
	self.FlankEnemy_ResetNextT = CurTime() + 20
	self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime
	end
	end
	
	if self.FlankEnemy_StopNextT < CurTime() and self:GetEnemy() != nil and self.CurrentSchedule != nil then
	if self.CurrentSchedule.Name == "vj_flank_enemy" then 
	self.FlankEnemy_StopNextT = CurTime() + 2.5
	if self.LastSeenEnemyTime > 2 then self.LastSeenEnemyTime = self.LastSeenEnemyTime - 1.5 end
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= 280*280 and self:GetEnemy():Visible(self) then
		self:ClearSchedule()
		self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3
	end
	end
	end
	

	
	end

	if self.CanFlankAttackPosition == true then
	
	if self.FlankAttackPosition_ResetNextT < CurTime() and !IsValid(self:GetEnemy()) and self.CurrentSchedule != nil then
	if self.CurrentSchedule.IsFlankAttacking == true then 
	self:ClearSchedule()
	self.FlankAttackPosition_ResetNextT = CurTime() + 15
	self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime
	end
	end
	
	if self.FlankAttackPosition_StopNextT < CurTime() and IsValid(self:GetEnemy()) and self.CurrentSchedule != nil then
	if self.CurrentSchedule.IsFlankAttacking == true then 
	self.FlankAttackPosition_StopNextT = CurTime() + 2.5
	if self.LastSeenEnemyTime > 2 then self.LastSeenEnemyTime = self.LastSeenEnemyTime - 1.5 end
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= 300*300 and self:GetEnemy():Visible(self) then
		self:ClearSchedule()
		self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime*1.2
	end
	end
	end
	
	if self.FlankAttackPosition_NextT < CurTime() and self.FlankAttackPosition_thinking != 1 and self.FlankAttackPosition_activated != 1 and self.vACT_StopAttacks == false and self.MovementType == VJ_MOVETYPE_GROUND and IsValid(self:GetEnemy()) and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) then
	self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime
	
	if math.random(1,10) >= self.FlankAttackPosition_chance and self:GetPos():DistToSqr(self:GetEnemy():GetPos()) <= 3000*3000 and (self:GetEnemy():GetForward():Dot((self:GetPos() -self:GetEnemy():GetPos()):GetNormalized()) > math.cos(math.rad(80))) then
		local incoverfromenemy = 0
		
		local traca2 = util.TraceLine({
						start = self:EyePos(),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
				
		if (traca2.HitWorld != true and ( self:GetEnemy():EyePos():DistToSqr(traca2.HitPos) <= 24*24 or (traca2.Entity != nil and traca2.Entity != NULL and traca2.Entity == self:GetEnemy() ) )) then
		local tracs1 = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tracs1.HitWorld == true or (tracs1.Entity != nil and tracs1.Entity != NULL and (tracs1.Entity:GetClass() == "prop_physics" or tracs1.Entity:GetClass() == "prop_dynamic" ) )) then 
				incoverfromenemy = 1
		end
		end
		
		if incoverfromenemy == 0 then
		
		self.FlankAttackPosition_thinking = 1
		local attackspottbl = {self:GetEnemy():GetForward()*math.random(0,100) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-100,100) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-100,100) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-120,0) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-120,0) +self:GetEnemy():GetRight()*math.random(-50,50)}
		local chosenpos = Vector(0,0,0)
		local sutiableattackpos = {}
		local actualattackpos = Vector(0,0,0)
		local tracss = {}
		local tracssdata = {}
		local tracsscx = {}
		--local enemydirection = Vector(0,0,0)
		local enemyeyepos = self:GetEnemy():EyePos()
		local postocheck = Vector(0,0,0)
		--local timeaddition = 0
		local isenemyunreachable = false
		if self:IsUnreachable(self:GetEnemy()) == true and self:GetEnemy():GetPos().z > self:GetPos().z then
			isenemyunreachable = true
		end
		
			for k,vapos in ipairs(attackspottbl) do
			if chosenpos == Vector(0,0,0) or table.Count( sutiableattackpos ) <= 5 then
			--print("ni99a")
				tracssdata = {
						start = enemyeyepos,
						endpos = enemyeyepos +vapos:GetNormalized()*math.random(self.FlankAttackPosition_minrrange,self.FlankAttackPosition_maxrange),
						filter = {self,self:GetActiveWeapon(),self:GetEnemy()}
						}
				if self:GetEnemy():GetActiveWeapon() != NULL and self:GetEnemy():GetActiveWeapon() != nil then tracssdata.filter = {self,self:GetActiveWeapon(),self:GetEnemy(),self:GetEnemy():GetActiveWeapon()} end
				tracss = util.TraceLine(tracssdata)
				
				if tracss.HitWorld == true or (tracss.Entity != nil and tracss.Entity != NULL and (tracss.Entity:GetClass() == "prop_physics" or tracss.Entity:GetClass() == "prop_dynamic" ) ) then 
				if tracss.HitPos:DistToSqr(self:GetEnemy():GetPos()) > self.FlankAttackPosition_minrange*self.FlankAttackPosition_minrange then
				
				--table.insert( sutiableattackpos, pointa:GetPos() )
				--table.insert( sutiableattackpos, tracss.HitPos+Vector(0,0,-15) )
				postocheck = tracss.HitPos+Vector(0,0,-10)
				if isenemyunreachable == true then
				tracsscx = util.TraceLine({
						start = postocheck,
						endpos = postocheck+Vector(0,0,-800),
						filter = {self,self:GetActiveWeapon()}
						})
				if tracsscx.HitWorld == true then postocheck = tracsscx.HitPos +Vector(0,0,20) end
				end
				local pointa = ents.Create("prop_dynamic")
				pointa:SetModel("models/vj_weapons/w_grenade.mdl")
				pointa:SetPos(postocheck)
				pointa:SetAngles( Angle(0,0,0) )
				pointa:Spawn()
				pointa:SetNoDraw( true ) 
				self:DeleteOnRemove(pointa)
				local physaa = pointa:GetPhysicsObject()
				if (physaa:IsValid()) then
					physaa:EnableCollisions(false)
				end
				timer.Simple(0.3,function()
				if IsValid(self) and IsValid(pointa) then
					pointa:Remove()
					--self.FlankAttackPosition_thinking = 0
				end
				end)
			
				timer.Simple(0.15,function()
				if IsValid(self) and IsValid(pointa) then
				--pointa:SetPos(tracss.HitPos+Vector(0,0,-10))
				if self:IsUnreachable(pointa) == false and IsValid(self:GetEnemy()) then
				table.insert( sutiableattackpos, pointa:GetPos() )
				--if math.abs( self.NextChaseTime - CurTime() ) < 4 then
				--	self.NextChaseTime = CurTime() + 5
				--end
				end
				end
				end)
				


				end
				end
				
			end
			end
			
			
				timer.Simple(0.3,function()
				if IsValid(self) then
				if self.FlankAttackPosition_thinking == 1 and self.FlankAttackPosition_activated != 1 and self.vACT_StopAttacks == false and self.MovementType == VJ_MOVETYPE_GROUND and IsValid(self:GetEnemy()) and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) then
	
					for ku,useablepos in pairs(sutiableattackpos) do
					if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
					if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(135))) then 
						--chosenspot = actualcoverpos
						--isclosestone = 0
						chosenpos = useablepos
					end
					end
					end
					if chosenpos == Vector(0,0,0) then
						for ku,useablepos in pairs(sutiableattackpos) do
						if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
						if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(80))) then 
							chosenpos = useablepos
						end
						end
						end
					end
					if chosenpos == Vector(0,0,0) then
						for ku,useablepos in pairs(sutiableattackpos) do
						if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
						if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(60))) then 
							chosenpos = useablepos
						end
						end
						end
					end
					
					if chosenpos != Vector(0,0,0) then
										
					self:SetLastPosition(chosenpos)
					self.CurrentCoveringPosition = chosenpos
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.IsFlankAttacking = true x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 1
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.3
					self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime*1.0
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*2.5
					self.NextChaseTime = CurTime() + 5
					self.NextIdleTime = CurTime() + 5
					self.FlankAttackPosition_activated = 1
					
					self.FlankAttackPosition_ResetNextT = CurTime() + 15
					self.FlankAttackPosition_StopNextT = CurTime() + 3
					
					--print("danigdone")
					timer.Simple(9,function()
					if IsValid(self) then
					if self.FlankAttackPosition_activated == 1 then self.FlankAttackPosition_activated = 0 end
					end
					end)
					
					end
				self.FlankAttackPosition_thinking = 0
					
				end
				end
				end)
			
		end
	
	end
	
	end
	end	
	
	if self.CanTargetExposedEnemy == true then
	if self.TargetExposedEnemy_NextT < CurTime() then
	self.TargetExposedEnemy_NextT = CurTime() + self.TargetExposedEnemy_Nexttime
	
	if IsValid(self:GetEnemy()) and math.random(1,10) >= self.TargetExposedEnemy_chance then
	if self:GetPos():DistToSqr(self:GetEnemy():GetPos()) < 2500*2500 and self.LastSeenEnemyTime < 0.5 then
	
		local tracs112 = util.TraceLine({
						start = self:EyePos()+self:GetUp()*-5,
						endpos = self:GetEnemy():NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter())+self:GetEnemy():GetUp()*8, --self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tracs112.HitWorld == true or (tracs112.Entity != nil and tracs112.Entity != NULL and (tracs112.Entity:GetClass() == "prop_physics" or tracs112.Entity:GetClass() == "prop_dynamic" ) )) then 
				--incoverfromenemy = 1
				self.TargetExposedEnemy_NextT = CurTime() + self.TargetExposedEnemy_cooldown
				local foundenemyents = 0
				local thesoldierlist = ents.FindInSphere(self:GetEnemy():GetPos(),self.TargetExposedEnemy_range)
				if thesoldierlist != nil then		
					for kc,vcca in ipairs(thesoldierlist) do
					if foundenemyents == 0 then
					if !vcca:IsNPC() and !vcca:IsPlayer() then continue end
					if IsValid(vcca) and vcca:EntIndex() != self:EntIndex() && vcca:Health() > 0 && (vcca.IsVJBaseSNPC == true && vcca.Dead != true) then
					if self:DoRelationshipCheck(vcca) == true then
						local trase221 = util.TraceLine({
						start = self:EyePos()+self:GetUp()*-5,
						endpos = vcca:NearestPoint(vcca:GetPos() +vcca:OBBCenter())+vcca:GetUp()*-10, --self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
						--foundenemyents = 1
						if (trase221.HitWorld != true and ( (trase221.Entity != nil and trase221.Entity != NULL and trase221.Entity == self:GetEnemy() ) ) ) then 
							foundenemyents = vcca
						end
					end
					end
					end
					end
				end
				if foundenemyents != 0 and IsValid(foundenemyents) then
					self:VJ_DoSetEnemy(foundenemyents,false)
				end
				
		end
	
	
	end
	end
	
	end
	end
	
	
	
	
	if self.CanRegroupWhenHurt == true then
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_NextT2 < CurTime() then
			self.RegroupWhenHurt_start = 0
		end
		if self.RegroupWhenHurt_NextT < CurTime() and self.vACT_StopAttacks == false then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		
		if self.RegroupWhenHurt_activated == 1 then
			if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
				if self:GetPos():DistToSqr(self.CurrentCoveringPosition) <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				self:ClearSchedule()
				self:StopMoving()
				self:DoIdleAnimation()
				end
			end
			if self.CurrentSchedule == nil then
				self.RegroupWhenHurt_activated = 0
			end
			if self.RegroupWhenHurt_durationT < CurTime() then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
					self:ClearSchedule()
					self:StopMoving()
					self:DoIdleAnimation()
				end
			end
			
		end
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_activated == 0 and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) and self.MovementType == VJ_MOVETYPE_GROUND then
		if !IsValid(self:GetEnemy()) or ( self.LastSeenEnemyTime > 2.0 ) then
		
		local foundtargetally = 0
		local foundtargetally_dist = 0
		local foundtargetallynear = 0
		local stopswitching = 0
		local allysoldierlist = ents.FindInSphere(self:GetPos(),self.RegroupWhenHurt_Range)
		
			for kc,vc in ipairs(allysoldierlist) do
			if foundtargetallynear == 0 then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) and vc:GetActiveWeapon() != NULL and vc:GetActiveWeapon() != nil then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.vACT_StopAttacks == false and vc.Weapon_ShotsSinceLastReload < vc.Weapon_StartingAmmoAmount then
			
			if foundtargetally == 0	then 
			foundtargetally = vc 
			foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
			else
				if math.random(1,10) >= 4 and stopswitching == 0 then
				if self:GetPos():DistToSqr(vc:GetPos()) > foundtargetally_dist then
					foundtargetally = vc 
					foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
				end
				else
					stopswitching = 1
				end
			end
				if foundtargetally_dist <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then foundtargetallynear = 1 end
			
			end
			end
			end
			end
			
			if foundtargetally != 0 and foundtargetallynear == 0 and IsValid(foundtargetally) then
			self.RegroupWhenHurt_activated = 1
			self.RegroupWhenHurt_start = 0
			self.RegroupWhenHurt_durationT = CurTime() + self.RegroupWhenHurt_duration
			
					self:SetLastPosition(foundtargetally:GetPos())
					self.CurrentCoveringPosition = foundtargetally:GetPos()
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.isRegrouping = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 0.5
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.8
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3.2
					self.NextChaseTime = CurTime() + 6
					self.NextIdleTime = CurTime() + 6
			
			end
		
		end
		end
		
		end
		
	end	
	
	if self.CanRegroupWhenHurt == true then
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_NextT2 < CurTime() then
			self.RegroupWhenHurt_start = 0
		end
		if self.RegroupWhenHurt_NextT < CurTime() and self.vACT_StopAttacks == false then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		
		if self.RegroupWhenHurt_activated == 1 then
			if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
				if self:GetPos():DistToSqr(self.CurrentCoveringPosition) <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				self:ClearSchedule()
				self:StopMoving()
				self:DoIdleAnimation()
				end
			end
			if self.CurrentSchedule == nil then
				self.RegroupWhenHurt_activated = 0
			end
			if self.RegroupWhenHurt_durationT < CurTime() then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
					self:ClearSchedule()
					self:StopMoving()
					self:DoIdleAnimation()
				end
			end
			
		end
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_activated == 0 and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) and self.MovementType == VJ_MOVETYPE_GROUND then
		if !IsValid(self:GetEnemy()) or ( self.LastSeenEnemyTime > 2.0 ) then
		
		local foundtargetally = 0
		local foundtargetally_dist = 0
		local foundtargetallynear = 0
		local stopswitching = 0
		local allysoldierlist = ents.FindInSphere(self:GetPos(),self.RegroupWhenHurt_Range)
		
			for kc,vc in ipairs(allysoldierlist) do
			if foundtargetallynear == 0 then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) and vc:GetActiveWeapon() != NULL and vc:GetActiveWeapon() != nil then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.vACT_StopAttacks == false and vc.Weapon_ShotsSinceLastReload < vc.Weapon_StartingAmmoAmount then
			
			if foundtargetally == 0	then 
			foundtargetally = vc 
			foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
			else
				if math.random(1,10) >= 4 and stopswitching == 0 then
				if self:GetPos():DistToSqr(vc:GetPos()) > foundtargetally_dist then
					foundtargetally = vc 
					foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
				end
				else
					stopswitching = 1
				end
			end
				if foundtargetally_dist <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then foundtargetallynear = 1 end
			
			end
			end
			end
			end
			
			if foundtargetally != 0 and foundtargetallynear == 0 and IsValid(foundtargetally) then
			self.RegroupWhenHurt_activated = 1
			self.RegroupWhenHurt_start = 0
			self.RegroupWhenHurt_durationT = CurTime() + self.RegroupWhenHurt_duration
			
					self:SetLastPosition(foundtargetally:GetPos())
					self.CurrentCoveringPosition = foundtargetally:GetPos()
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.isRegrouping = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 0.5
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.8
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3.2
					self.NextChaseTime = CurTime() + 6
					self.NextIdleTime = CurTime() + 6
			
			end
		
		end
		end
		
		end
		
	end	
	
	if self.CanCoordinatedChasing == true then
	if self.CoordinatedChasing_NextT < CurTime() and self.CoordinatedChasing_activated == 0 and self.CoordinatedChasing_activatedbyothers == 0 and self.CurrentSchedule != nil and self.vACT_StopAttacks == false then
	if IsValid(self:GetEnemy()) and (self.CurrentSchedule.Name == "vj_chase_enemy" or self.CurrentSchedule.Name == "vj_flank_enemy" or (self.CurrentSchedule.Name == "vj_goto_lastpos" and self.LookForCover_activated == 1 and self.CurrentCoveringPosition != Vector(0,0,0)) ) then
		self.CoordinatedChasing_NextT = CurTime() + self.CoordinatedChasing_Nexttime
		local mode = "chase"
		
		if self.CurrentSchedule.Name == "vj_flank_enemy" then
			mode = "flank"
		end
		
		if self.CurrentSchedule.Name == "vj_goto_lastpos" and self.LookForCover_activated == 1 and self.CurrentCoveringPosition != Vector(0,0,0) then
			mode = "cover"
		end
		
			--local checkdist = {}
			local soldierlist = ents.FindInSphere(self:GetPos(),self.CoordinatedChasing_range)
			local hasallies = 0
			for kc,vc in ipairs(soldierlist) do
			if hasallies < self.CoordinatedChasing_maxsoldier then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) and vc:GetActiveWeapon() != NULL and vc:GetActiveWeapon() != nil and vc.MovementType == VJ_MOVETYPE_GROUND then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.CoordinatedChasing_activatedbyothers == 0 and vc.vACT_StopAttacks == false and vc.CurrentSchedule == nil and vc.Weapon_ShotsSinceLastReload < vc.Weapon_StartingAmmoAmount then
		
			if IsValid(vc:GetEnemy()) and vc:GetEnemy() != self:GetEnemy() then
			
				if vc.Weapon_TimeSinceLastShot > 2 and !vc:Visible(vc:GetEnemy()) then
					--vc.NextChaseTime = CurTime() + 0.5
					vc:VJ_DoSetEnemy(self:GetEnemy(),false)
					--vc:VJ_TASK_CHASE_ENEMY(false)
					hasallies = hasallies + 1
					if math.random(1,10) <= 3 then hasallies = hasallies + 1 end
					vc.CoordinatedChasing_activatedbyothers = 1
					timer.Simple(self.CoordinatedChasing_Nexttime/1.5,function()
					if IsValid(vc) then
					vc.CoordinatedChasing_activatedbyothers = 0
					end
					end)
					if mode == "chase" and math.random(1,10) > 3 then
						vc:VJ_TASK_CHASE_ENEMY(false)
					end
					if mode == "flank" then
					if vc:IsUnreachable(self) == false then
					--vc:VJ_TASK_CHASE_ENEMY(false)
								if math.abs( vc.NextChaseTime - CurTime() ) < 4 then
								vc.NextChaseTime = CurTime() + 5
								end
							vc.CurrentCoveringPosition = self.CurrentCoveringPosition
							vc:SetLastPosition( vc.CurrentCoveringPosition ) 
							vc:VJ_TASK_FLANK_ENEMY()
							vc.FlankEnemy_ResetNextT = CurTime() + 20
							vc.FlankEnemy_StopNextT = CurTime() + 5
							vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 0.5
					end
					end
					if mode == "cover" then
					if vc:IsUnreachable(self) == false then
					vc:SetLastPosition(self.CurrentCoveringPosition)
					vc.CurrentCoveringPosition = self.CurrentCoveringPosition
					vc:StopMoving()
					vc:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 1
					vc.SmartAttackPos_NextT = CurTime() + vc.SmartAttackPos_Var.Nexttime*1.2
					vc.LookForCover_NextT = CurTime() + vc.LookForCover_Var.Nexttime*1.5
					vc.FlankEnemy_NextT = CurTime() + vc.FlankEnemy_Nexttime*1.5
					vc.NextChaseTime = CurTime() + 3
					vc.NextIdleTime = CurTime() + 3
					vc.LookForCover_activated = 1

						timer.Simple(3,function()
						if IsValid(vc) then
						if vc.LookForCover_activated == 1 then vc.LookForCover_activated = 0 end
						end
						end)
					end
					end
					
				end
				
			else
				if !vc:Visible(self:GetEnemy()) then
				if vc:GetEnemy() != self:GetEnemy() then
					vc:VJ_DoSetEnemy(self:GetEnemy(),false)
				end
					--vc.NextChaseTime = CurTime() + 0.5
					--vc:VJ_TASK_CHASE_ENEMY(false)
					hasallies = hasallies + 1
					if math.random(1,10) <= 3 then hasallies = hasallies + 1 end
					vc.CoordinatedChasing_activatedbyothers = 1
					timer.Simple(self.CoordinatedChasing_Nexttime/1.4,function()
					if IsValid(vc) then
					vc.CoordinatedChasing_activatedbyothers = 0
					end
					end)
					
					if mode == "chase" and math.random(1,10) > 3 then
						vc:VJ_TASK_CHASE_ENEMY(false)
					end
					if mode == "flank" then
					if vc:IsUnreachable(self) == false then
					--vc:VJ_TASK_CHASE_ENEMY(false)
								if math.abs( vc.NextChaseTime - CurTime() ) < 4 then
								vc.NextChaseTime = CurTime() + 5
								end
							vc.CurrentCoveringPosition = self.CurrentCoveringPosition
							vc:SetLastPosition( vc.CurrentCoveringPosition ) 
							vc:VJ_TASK_FLANK_ENEMY()
							vc.FlankEnemy_ResetNextT = CurTime() + 20
							vc.FlankEnemy_StopNextT = CurTime() + 5
							vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 0.5
					end
					end
					if mode == "cover" then
					if vc:IsUnreachable(self) == false then
					vc:SetLastPosition(self.CurrentCoveringPosition)
					vc.CurrentCoveringPosition = self.CurrentCoveringPosition
					vc:StopMoving()
					vc:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 1
					vc.SmartAttackPos_NextT = CurTime() + vc.SmartAttackPos_Var.Nexttime*1.2
					vc.LookForCover_NextT = CurTime() + vc.LookForCover_Var.Nexttime*1.5
					vc.FlankEnemy_NextT = CurTime() + vc.FlankEnemy_Nexttime*1.5
					vc.NextChaseTime = CurTime() + 3
					vc.NextIdleTime = CurTime() + 3
					vc.LookForCover_activated = 1

						timer.Simple(3,function()
						if IsValid(vc) then
						if vc.LookForCover_activated == 1 then vc.LookForCover_activated = 0 end
						end
						end)
					end
					end
					
				end
			end
				
			end
			end
			end
			end
			
			if hasallies > 0 then
				self.CoordinatedChasing_activated = 1
				timer.Simple(self.CoordinatedChasing_Nexttime/1.4,function()
				if IsValid(self) then
				self.CoordinatedChasing_activated = 0
				end
				end)
			end
			
	end
	end
	end
	
	if self.CanSmartAiming == true and self.AimCorrect_NextT > CurTime() and self.vACT_StopAttacks == false and self.Weapon_StartingAmmoAmount != nil and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and (self:VJ_HasActiveWeapon() != false) and self.CurrentSchedule == nil then 
	if self.SmartAiming_timer == 0 and CurTime() > self.LastHiddenZoneT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.FlankEnemy_activated == 0 and self:GetEnemy() != nil and math.random(1,self.SmartAiming_chance) == 1 and self.Weapon_TimeSinceLastShot < 2 and self.DoingWeaponAttack_Standing == true and self.SmartAiming_activated == 0 then
	self.SmartAiming_timer = 1
			local tras = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		timer.Simple(self.SmartAiming_timersec,function()
		if IsValid(self) then
		self.SmartAiming_timer = 0
		end
		end)
	
	
	end
	end

	
	if self.CanDoSmartGrenadeThrow == true and self.HasGrenadeAttack == true then
	
	if self.SmartGrenadeThrow_timer == 0 and self:GetEnemy() != nil then
	self.SmartGrenadeThrow_timer = 1
	
			if self.HasGrenadeAttack == true && CurTime() > self.NextThrowSmartGrenadeT && (self.SmartGrenadeThrow_enemyvisible_previously != 0 or self.CanThrowBlindGrenade == true ) && self.vACT_StopAttacks == false && self.ThrowingGrenade != true && math.random(1,self.SmartGrenadeThrow_chance) == 1 && self.IsReloadingWeapon == false && CurTime() > self.TakingCoverT && (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) != false)  then
				local isbeingcontrolled = false
				local isbeingcontrolled_attack = false
				if self.VJ_IsBeingControlled == true then isbeingcontrolled = true end
					
					local trc = util.TraceLine({
					start = self:EyePos(),
					endpos = self.SmartGrenadeThrow_enemyvisible_lastposition,
					filter = self
					})
				if (trc.HitWorld != true and ( trc.Entity == nil or trc.Entity == NULL or (self:GetActiveWeapon() != NULL and trc.Entity == self:GetActiveWeapon()) ) and self.SmartGrenadeThrow_enemyvisible_lastposition:DistToSqr(trc.HitPos) <= 20*20) or self.CanThrowBlindGrenade == true then
				--local checkdist = self:VJ_CheckAllFourSides(150)
				
				if CurTime() > self.NextThrowSmartGrenadeT then
					local chancevar = self.ThrowSmartGrenadeChance
					local grenchance = math.random(1,chancevar)
					if grenchance == 1 then
						local EnemyDistance = self:GetPos():DistToSqr(self:GetEnemy():GetPos()) --self:GetPos():Distance(self:GetEnemy():GetPos())
						if (isbeingcontrolled_attack == true) or (EnemyDistance < self.GrenadeAttackThrowDistance*self.GrenadeAttackThrowDistance && EnemyDistance > self.GrenadeAttackThrowDistanceClose*self.GrenadeAttackThrowDistanceClose) then
							self:ThrowGrenadeCode()
							self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
							self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
						end
					end
				end
				end
			end
	
	
		timer.Simple(self.SmartGrenadeThrow_timersec,function()
		if IsValid(self) then
		self.SmartGrenadeThrow_timer = 0
		end
		end)
		
	end
	

	

	
	end

	
	if self.CanRememberEnemyPosition == true then
	
	if self.SmartGrenadeThrow_enemyvisibletimer == 0 then
	self.SmartGrenadeThrow_enemyvisibletimer = 1
	
	if CurTime() > self.SmartGrenadeThrow_enemyvisible_NextT then
		self.SmartGrenadeThrow_enemyvisible_previously = 0
	end
	if self:GetEnemy() != nil then
	if (self:GetEnemy() != nil) and (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) == false) then
		self.SmartGrenadeThrow_enemyvisible_previously = 1
		self.SmartGrenadeThrow_enemyvisible_NextT = CurTime() + self.SmartGrenadeThrow_enemyvisible_Next

		self.SmartGrenadeThrow_enemyvisible_lastposition = self:GetEnemy():GetPos() + self:GetEnemy():GetUp()*75
		self.SmartGrenadeThrow_enemyvisibleshared = 0
		
		--print("enemy last visible")
		if self.SmartGrenadeThrow_enemyvisibleshare_NextT < CurTime() then
		self.SmartGrenadeThrow_enemyvisibleshare_NextT = CurTime() + self.SmartGrenadeThrow_enemyvisibleshare_Next
		if self.SmartGrenadeThrow_enemyvisibleshare_NextT != 0 then 
		
			for kc,vc in ipairs(ents.FindInSphere(self:GetPos(),900)) do
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == false and vc.SmartGrenadeThrow_enemyvisible_lastposition != nil and vc.SmartGrenadeThrow_enemyvisible_previously != nil then
			if vc.SmartGrenadeThrow_enemyvisible_previously == 0 then --and (vc:VJ_ForwardIsHidingZone(vc:EyePos(),self.SmartGrenadeThrow_enemyvisible_lastposition,true) == false) then
			vc.SmartGrenadeThrow_enemyvisible_lastposition = self.SmartGrenadeThrow_enemyvisible_lastposition + Vector(0,0,40)
			vc.SmartGrenadeThrow_enemyvisible_previously = 1
			vc.SmartGrenadeThrow_enemyvisibleshared = 1
			end
			end
			end
			end
		
		end
		end
	end
	end
		timer.Simple(1.2,function()
		if IsValid(self) then
		self.SmartGrenadeThrow_enemyvisibletimer = 0
		end
		end)
	
	end
	
	end

	


	

	if self.CanUseSecondaryweapon == true then
	
	if self.IsReloadingWeapon == true and self.Reloadwhenidle_activated != 1 then
	if self.Secondaryweapon_timer == 0 then
	self.Secondaryweapon_timer = 1
	local EnemyDist = 0
	if self:GetEnemy() != nil then
		EnemyDist = self:GetPos():DistToSqr( self:GetEnemy():GetPos() )
	end
	
	if math.random(1,self.Secondaryweapon_switchchance) == 1 and self.Secondaryweapon_Switchingmyweapon == 0 and self.isMeleeCharging != 1 and EnemyDist > 60*60 and EnemyDist <= self.Secondaryweapon_Range*self.Secondaryweapon_Range and ( self:GetEnemy() == nil or self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false,{SetLastHiddenTime=true}) != true) and self:Visible(self:GetEnemy()) then
	
	if self.Secondaryweapon_Usingsecondaryweapon == 0 then
	
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self.Secondaryweapon_originalclass = self:GetActiveWeapon():GetClass() end
		self.Secondaryweapon_Usingsecondaryweapon = 1
		self.Secondaryweapon_Switchingmyweapon = 1
		self.Weapon_ShotsSinceLastReload = 0
		self.IsReloadingWeapon = true
		self:ClearSchedule()
		self:VJ_TASK_IDLE_STAND()

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation,true,0.65,false,0,{SequenceDuration=0.65,PlayBackRate=1.5})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_class)
			self.Weapon_ShotsSinceLastReload = 0
			--self.IsReloadingWeapon = false
			self.Secondaryweapon_Switchingmyweapon = 0
			self:ClearSchedule()
			self:SelectSchedule()
				timer.Simple(0.2,function()
				if IsValid(self) then
					self.IsReloadingWeapon = false
				end
				end)
		end
		end)
		
		timer.Simple(0.65,function()
		if IsValid(self) then
				self:ClearSchedule()
				self:VJ_TASK_IDLE_STAND()
		end
		end)
		
		end
		end)
	else
	
		self.Secondaryweapon_Usingsecondaryweapon = 0
		self.Secondaryweapon_Switchingmyweapon = 1
		self:ClearSchedule() 
		self:VJ_TASK_IDLE_STAND()
		self.IsReloadingWeapon = true

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation2,true,0.8,false,0,{SequenceDuration=0.8,PlayBackRate=1.4})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_originalclass)
			--self.Weapon_ShotsSinceLastReload = 1000
			self.Secondaryweapon_Switchingmyweapon = 0
		end
		end)
		
		timer.Simple(0.85,function()
		if IsValid(self) then
			self:VJ_TASK_IDLE_STAND()
			self.Weapon_ShotsSinceLastReload = 1000
			self.IsReloadingWeapon = false
		end
		end)
		
		end
		end)
		
	
	end
	
	end
	
		
		timer.Simple(self.Secondaryweapon_timersec,function()
		if IsValid(self) then
		self.Secondaryweapon_timer = 0
		end
		end)
	
	end
	end
	
	
	if self.Secondaryweapon_Usingsecondaryweapon == 1 and self.Secondaryweapon_Switchingmyweapon == 0 then
	if self.Secondaryweapon_timer2 == 0 then
	self.Secondaryweapon_timer2 = 1
	
	if (self.vACT_StopAttacks == false or self.IsReloadingWeapon == true) and (self:GetEnemy() == nil or self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false,{SetLastHiddenTime=true}) == true or self.LastSeenEnemyTime > 5) then
	if math.random(1,self.Secondaryweapon_switchchance) == 1 and self.Secondaryweapon_Switchingmyweapon == 0 and self.isMeleeCharging != 1 then
	
		self.Secondaryweapon_Usingsecondaryweapon = 0
		self.Secondaryweapon_Switchingmyweapon = 1
		self:ClearSchedule()
		self:VJ_TASK_IDLE_STAND()
		self.IsReloadingWeapon = true

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation2,true,0.8,false,0,{SequenceDuration=0.8,PlayBackRate=1.4})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_originalclass)
			--self.Weapon_ShotsSinceLastReload = 1000
			self.Secondaryweapon_Switchingmyweapon = 0
		end
		end)
		
		timer.Simple(0.85,function()
		if IsValid(self) then
			self.IsReloadingWeapon = false
			self:VJ_TASK_IDLE_STAND()
			self.Weapon_ShotsSinceLastReload = 1000
		end
		end)
	
		end	
		end)
	
	end
	end
	
		timer.Simple(self.Secondaryweapon_timer2sec,function()
		if IsValid(self) then
		self.Secondaryweapon_timer2 = 0
		end
		end)
		
	end
	end
	
	end	
	
	if self.CanPerformMeleeCharge == true then
	
		if self.isMeleeCharging == 1 and self.MeleeCharge_Vel != Vector(0,0,0) then
			if self.MeleeCharge_hit == 0 then
				self:SetVelocity(self.MeleeCharge_Vel +self:GetForward()*math.Rand(self.MeleeCharge_forwardvel1,self.MeleeCharge_forwardvel2))
			else
				self:SetFriction( self.MeleeCharge_originalfriction ) 
				self:SetVelocity(self:GetVelocity()/2 )
			end
			self:MeleeChargeAttackCode()
		end
	
	
	
	if self.MeleeCharge_timer == 0 and self:GetEnemy() != nil then
	self.MeleeCharge_timer = 1
	
	local EnemyDist = 0
	if self:GetEnemy() != nil then
		EnemyDist = self:GetPos():DistToSqr( self:GetEnemy():GetPos() )
	end
	
	if self.vACT_StopAttacks == false and self.MeleeCharge_timer2 == 0 and self.Weapon_StartingAmmoAmount != nil and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.Secondaryweapon_Switchingmyweapon != 1 and self.isMeleeCharging != 1 and self:Visible(self:GetEnemy()) and self:CanDoCertainAttack("MeleeAttack") and self.IsReloadingWeapon == false and EnemyDist <= self.MeleeCharge_range*self.MeleeCharge_range and EnemyDist > 70*70 then
		self.MeleeCharge_timer2 = 1

			--self:VJ_TASK_IDLE_STAND()
			local originalmove = self.MovementType
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.MeleeAttacking = true
			self.AlreadyDoneMeleeAttackFirstHit = false
			self.IsAbleToMeleeAttack = false
			self.AlreadyDoneFirstMeleeAttack = false
			self.AllowWeaponReloading = false
			self:MeleeChargeAttackSoundCode()
			self.NextAlertSoundT = CurTime() + 0.4
			self.NextWeaponAttackT = CurTime() + 1.0
			self.NextChaseTime = CurTime() + 1.2
			if self.DisableMeleeAttackAnimation == false then
						self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_MeleeChargeAttack)
						self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount
						self.PlayingAttackAnimation = true
						timer.Simple(self.CurrentAttackAnimationDuration,function()
							if IsValid(self) then
								self.PlayingAttackAnimation = false
							end
						end)
						self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,1.0,false,self.MeleeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
			end
			local ChargePos = self:GetPos() + self:GetForward()*300
			if IsValid(self:GetEnemy()) then 
			ChargePos = self:GetEnemy():GetPos() 
			self:FaceCertainEntity(self:GetEnemy(),false)
			end
			local ChargeVel = ChargePos -self:GetPos() 
			local phys = self:GetPhysicsObject()
			--local originalfriction = self:GetFriction()
			self.MeleeCharge_originalfriction = self:GetFriction()
			ChargeVel = Vector(ChargeVel.x, ChargeVel.y, 0)
			self.MeleeCharge_Vel = ChargeVel:GetNormalized() 
			if (phys:IsValid()) then
				--phys:SetVelocity(ChargeVel +self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) +self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) +self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
			end
			timer.Simple(0.2,function()
			if IsValid(self) then
				self.isMeleeCharging = 1
				self:SetFriction( 0 ) 
				self:SetVelocity(self.MeleeCharge_Vel +self:GetUp()*math.random(self.MeleeCharge_upvel1,self.MeleeCharge_upvel1) +self:GetForward()*math.Rand(self.MeleeCharge_forwardvel1,self.MeleeCharge_forwardvel2))
				self.MeleeCharge_damagedentity = {}
				self.MeleeCharge_hit = 0
			end
			end)
			timer.Simple(0.6,function()
			if IsValid(self) then
				self:SetFriction( self.MeleeCharge_originalfriction ) 
				self.AllowWeaponReloading = true
				self.MovementType = originalmove
			if self.isMeleeCharging == 1 then
				self.isMeleeCharging = 0
				self.MeleeCharge_hit = 0
				self.MeleeCharge_damagedentity = {}
			end
			end
			end)
			--timer.Create( "timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeChargeDamage, 1, function() self:MeleeChargeAttackCode() end)
	
		timer.Simple(self.MeleeCharge_timersec2,function()
		if IsValid(self) then
		self.MeleeCharge_timer2 = 0
		end
		end)
	
	
	end
	
		timer.Simple(self.MeleeCharge_timersec,function()
		if IsValid(self) then
		self.MeleeCharge_timer = 0
		end
		end)
	
	end
	end
	
	
end

function ENT:MeleeChargeAttackCode()
	if self.Dead == true or self.Flinching == true or self.ThrowingGrenade == true then return end
	if self.StopMeleeAttackAfterFirstHit == true && self.AlreadyDoneMeleeAttackFirstHit == true then return end
	--if /*self.VJ_IsBeingControlled == false &&*/ self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	//self.MeleeAttacking = true
	local FindEnts = ents.FindInSphere(self:GetPos() + self:GetForward(),self.MeleeChargeAttackDamageDistance)
	local hitentity = false
	local HasHitNonPropEnt = false
	
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
			if (v:IsNPC() || (v:IsPlayer() && v:Alive())) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or (v:GetClass() == "prop_physics") or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
				if (table.HasValue( self.MeleeCharge_damagedentity, v ) == false) and (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeChargeAttackDamageAngleRadius))) then
					local doactualdmg = DamageInfo()
					doactualdmg:SetDamage(self:VJ_GetDifficultyValue(self.MeleeCharge_dmg))
					if v:IsNPC() or v:IsPlayer() then doactualdmg:SetDamageForce(self:GetForward()*((doactualdmg:GetDamage()+100)*70)) end
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(self)
					v:TakeDamageInfo(doactualdmg, self)
					v:SetVelocity(self:GetForward()*self.MeleeCharge_knockbackvel)
					if self.MeleeCharge_hit == 0 then
						self.MeleeCharge_hit = 1
					end
					table.insert( self.MeleeCharge_damagedentity, v )
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1,1)*10,math.random(-1,1)*10,math.random(-1,1)*10))
				end
				VJ_DestroyCombineTurret(self,v)
				if v:GetClass() != "prop_physics" then HasHitNonPropEnt = true end
				if v:GetClass() == "prop_physics" && HasHitNonPropEnt == false then
					//if VJ_HasValue(self.EntitiesToDestoryModel,v:GetModel()) or VJ_HasValue(self.EntitiesToPushModel,v:GetModel()) then
					//hitentity = true else hitentity = false end
					hitentity = false
				else
					hitentity = true
					end
				end
			end
		end
	end
	if hitentity == true then
		self:MeleeAttackSoundCode()
		if self.StopMeleeAttackAfterFirstHit == true then self.AlreadyDoneMeleeAttackFirstHit = true /*self:StopMoving()*/ end
	else
		self:CustomOnMeleeAttack_Miss()
		self:MeleeAttackMissSoundCode()
	end
	if self.AlreadyDoneFirstMeleeAttack == false && self.TimeUntilMeleeAttackDamage != false then
		self:MeleeAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstMeleeAttack = true
end

function ENT:MeleeChargeAttackSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,1)
	local soundtbl = self.SoundTbl_MeleeChargeAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomattacksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_RegularChange = CurTime() + 1
		self.CurrentBeforeMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.BeforeMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch1,self.BeforeMeleeAttackSoundPitch2))
	end
end






/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make human SNPCs
--------------------------------------------------*/