include( "ballistic_shields/sh_bs_util.lua" )

--------------------- BALLISTIC SHIELDS V1.1.4 -------------------------

---- CONFIG ----
-- AVALAIBLE LANGUAGES - English
bshields.config.language = "English"
-- DISABLE HUD
bshields.config.disablehud = false
-- MINIMUM RIOT SHIELD DAMAGE
bshields.config.rshielddmgmin = 16
-- MAXIMUM RIOT SHIELD DAMAGE
bshields.config.rshielddmgmax = 24
-- HEAVY SHIELD EXPLOSION DAMAGE REDUCITON (IN %)
bshields.config.hshieldexpl = 50
-- HEAVY SHIELD MELEE DAMAGE REDUCTION (IN %)
bshields.config.hshieldmelee = 20
-- RIOT SHIELD MELEE DAMAGE REDUCTION (IN %)
bshields.config.rshieldmelee = 60
-- HEAVY SHIELD BREACH COOLDOWN (IN SECONDS)
bshields.config.hshieldcd = 20
-- DOOR RESPAWN TIMER (IN SECONDS)
bshields.config.doorrespawn = 60
-- MAXIMUM AMOUNT OF DEPLOYED SHIELDS
bshields.config.maxshields = 10
-- SHOULD FADING DOORS BE BREACHABLE?
bshields.config.breachfdoors = true
-- ALLOW BREACHING UNOWNED DOORS
bshields.config.breachudoors = true

-------- CUSTOM TEXTURES, LEAVE "" FOR DEFAULT "POLICE" TEXT. ----------
--- FOR EDITING USE THE 256x256 TEMPLATE INCLUDED IN THE MAIN FOLDER ---

-- HEAVY SHIELD
bshields.config.hShieldTexture = "https://imgur.com/hO4Y6GD.png"
-- RIOT SHIELD
bshields.config.rShieldTexture = "https://imgur.com/cjr0Noe.png"
-- DEPLOYABLE SHIELD
bshields.config.dShieldTexture = "https://imgur.com/9FhM4Vk.png" 
-- PLAYERS MIGHT HAVE TO RECONNECT IN ORDER TO SEE THE NEW TEXTURES! ---

-- [CW2 ONLY] YOU NEED THIS ADDON: https://steamcommunity.com/sharedfiles/filedetails/?id=1771994451
-- SHOULD RIOT SHIELD BE BULLETPROOF? --
bshields.config.rshieldbp = false