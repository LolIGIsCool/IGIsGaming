-----------------------------------------------------
-------------------------------------

---------------- Cuffs --------------

-------------------------------------

-- Copyright (c) 2015 Nathan Healy --

-------- All rights reserved --------

-------------------------------------

-- weapon_cuff_elastic.lua  SHARED --

--                                 --

-- Elastic handcuffs.              --

-------------------------------------



AddCSLuaFile()



SWEP.Base = "weapon_cuff_base"



SWEP.Category = "Handcuffs"

SWEP.Author = "my_hat_stinks"

SWEP.Instructions = "Stretchable restraint."



SWEP.Spawnable = true

SWEP.AdminOnly = true

SWEP.AdminSpawnable = true



SWEP.Slot = 1

SWEP.PrintName = "Elastic Restraint"



//

// Handcuff Vars

SWEP.CuffTime = 0.9 // Seconds to handcuff

SWEP.CuffSound = Sound( "buttons/lever7.wav" )



SWEP.CuffMaterial = "models/props_pipes/GutterMetal01a"

SWEP.CuffRope = "cable/red"

SWEP.CuffStrength = 1.0

SWEP.CuffRegen = 0.8

SWEP.RopeLength = 60

SWEP.CuffReusable = true



SWEP.CuffBlindfold = true

SWEP.CuffGag = true



SWEP.CuffStrengthVariance = 0.1 // Randomise strength

SWEP.CuffRegenVariance = 0.3 // Randomise regen