--[[
	local weapon = {}
	weapon.ID = "tfa_swch_dc15a" // The tntiy of the weapon Q Menu < Weapons < Right Click < Copy to clipboard
	weapon.Name = 'DC15a Blaster' // Name of weapon you want it to be
	weapon.Price = 45000 // Price of wep
	weapon.Model = "models/weapons/w_dc15a.mdl" // model path to the weapon
	weapon.Usergroup = {"Donator", "Owner"} // Usergroups *****IF NO USERGROUP THEN REMOVE THIS LINE ******
	weapon.Job = {TEAM_CITIZEN, TEAM_POLICE} // Teams *****IF NOT TEAM THEN REMOVE THIS LINE ******
	weapon.DeployCost = 250 // DeployCost *****IF NO DEPLOY COST THEN REMOVE THIS LINE ****
	weapon.Blacklist = {TEAM_CITIZEN, TEAM_MAYOR},
	weapon.GiveOnSpawn = true (true: gives weapon everys spawn false: no or leave blank)
	SArmory.Action.registerWeapon(weapon) <---- ALWAYS HAVE THIS AT THE END OF THE WEAPON

--]]

-----------------------------------
--------------Pistols--------------
-----------------------------------
--[[
local weapon = {}
weapon.ID = "rw_sw_scoutblaster"
weapon.Name = 'EC-17 hold-out blaster'
weapon.Price = 20000
weapon.Model = "models/kuro/sw_battlefront/weapons/bf1/scouttrooper_pistol.mdl"
weapon.DeployCost = 100
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_dual_rk3"
weapon.Name = 'Dual RK-3'
weapon.Price = 35000
weapon.DeployCost = 200
weapon.Model = "models/markus/fo_rk3_blaster_pistol/fo_rk3_blaster_pistol.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_relbyk23"
weapon.Name = 'Relby K-23'
weapon.Price = 45000
weapon.DeployCost = 300
weapon.Model = "models/hauptmann/star wars/weapons/relby_k23.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_se14"
weapon.Name = 'SE-14r'
weapon.Price = 60000
weapon.DeployCost = 400
weapon.Model = "models/sw_battlefront/weapons/2019/se14_pistol.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_se14cc"
weapon.Name = 'SE-14c'
weapon.Price = 75000
weapon.DeployCost = 500
weapon.Model = "models/hauptmann/star wars/weapons/se14c.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
--------------Rifles---------------
-----------------------------------
local weapon = {}
weapon.ID = "rw_sw_dc15a"
weapon.Name = 'DC-15A'
weapon.Price = 30000
weapon.DeployCost = 150
weapon.Model = "models/sw_battlefront/weapons/dc15a_rifle.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_t21"
weapon.Name = 'T-21'
weapon.Price = 45000
weapon.DeployCost = 250
weapon.Model = "models/kuro/sw_battlefront/weapons/bf1/t21.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_westarm5"
weapon.Name = 'Westar-M5'
weapon.Price = 60000
weapon.DeployCost = 350
weapon.Model = "models/sw_battlefront/weapons/new/westar_m5_blaster_rifle.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
---------Long-Range Rifles---------
-----------------------------------
local weapon = {}
weapon.ID = "rw_sw_dlt20a"
weapon.Name = 'DLT-20a'
weapon.Price = 75000
weapon.DeployCost = 750
weapon.Model = "models/kuro/sw_battlefront/weapons/bf1/dlt20a.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_nt242c"
weapon.Name = 'NT-242'
weapon.Price = 150000
weapon.DeployCost = 1500
weapon.Model = "models/sw_battlefront/weapons/nt242_longblaster.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
-----------Heavy Rifles------------
-----------------------------------
local weapon = {}
weapon.ID = "rw_sw_dlt19"
weapon.Name = 'DLT-19'
weapon.Price = 40000
weapon.DeployCost = 200
weapon.Model = "models/kuro/sw_battlefront/weapons/bf1/dlt19.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_tl50"
weapon.Name = 'TL-50 Repeater'
weapon.Price = 70000
weapon.DeployCost = 400
weapon.Model = "models/sw_battlefront/weapons/tl50_repeater.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
------------CQC Weapons------------
-----------------------------------
local weapon = {}
weapon.ID = "rw_sw_huntershotgun"
weapon.Name = 'Hunter Shotgun'
weapon.Price = 50000
weapon.DeployCost = 250
weapon.Model = "models/kuro/sw_battlefront/weapons/bf1/scattergun.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
---------Explosive Weapons---------
-----------------------------------
local weapon = {}
weapon.ID = "rw_sw_nade_thermal"
weapon.Name = 'Thermal Detonator'
weapon.Price = 75000
weapon.DeployCost = 0
weapon.GiveOnSpawn = true
weapon.Model = "models/weapons/tfa_starwars/w_thermal.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_pinglauncher"
weapon.Name = 'Micro Grenade Launcher'
weapon.Price = 125000
weapon.DeployCost = 2500
weapon.Model = "models/sw_battlefront/weapons/pinglauncher.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "weapon_jew_det"
weapon.Name = 'Detonator Device'
weapon.Price = 250000
weapon.DeployCost = 1500
weapon.Model = "models/weapons/w_swrcdeton.mdl"
SArmory.Action.registerWeapon(weapon)

-----------------------------------
--------------Utility--------------
-----------------------------------
local weapon = {}
weapon.ID = "weapon_rpw_binoculars_nvg"
weapon.Name = 'NV Electrobinoculars'
weapon.Price = 25000
weapon.DeployCost = 0
weapon.GiveOnSpawn = true
weapon.Model = "models/weapons/w_nvbinoculars.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "rw_sw_nade_smoke"
weapon.Name = 'Smoke Grenade'
weapon.Price = 100000
weapon.DeployCost = 0
weapon.GiveOnSpawn = true
weapon.Model = "models/weapons/tfa_starwars/w_smoke.mdl"
SArmory.Action.registerWeapon(weapon)

local weapon = {}
weapon.ID = "stryker_adrenaline"
weapon.Name = 'Adrenaline Shot'
weapon.Price = 200000
weapon.DeployCost = 1000
weapon.Model = "models/weapons/w_eq_healthshot.mdl"
SArmory.Action.registerWeapon(weapon)
--]]