
-----------------------------------------------------
-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_cuff_tactical.lua SHARED --
--                                 --
-- Quick-restraint handcuffs.      --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "Fast-action but weak restraint."

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 1
SWEP.PrintName = "Tactical Restraint"

//
// Handcuff Vars
SWEP.CuffTime = 0.3 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "phoenix_storms/bluemetal"
SWEP.CuffRope = "cable/blue"
SWEP.CuffStrength = 0.9
SWEP.CuffRegen = 0.8
SWEP.RopeLength = 0

SWEP.CuffReusable = true
SWEP.CuffRecharge = 20 // Time before re-use

SWEP.CuffBlindfold = false
SWEP.CuffGag = false

SWEP.CuffStrengthVariance = 0.1 // Randomise strangth
SWEP.CuffRegenVariance = 0.3 // Randomise regen
