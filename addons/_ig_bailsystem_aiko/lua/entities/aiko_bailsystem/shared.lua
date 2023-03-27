ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName		= "Bail Terminal"
ENT.Author			= "Aiko"
ENT.Contact         = "Aiko#0005"
ENT.Purpose			= "To removed to need to give tools to change saber"

ENT.Category = "Aiko's Entities"

ENT.Spawnable = true

AikoBailSystem = AikoBailSystem or {}
AikoBailSystem.Config = AikoBailSystem.Config or {}

AikoBailSystem.Config.BailCooldown = 10 -- Minutes

local bailprices = {
    [1] = 2500,
    [2] = 7500,
    [3] = 10000,
    [4] = 50000,
    [5] = 100000,
}
AikoBailSystem.Config.BailReasons = {
    -- {"CAE-01 High Treason", nil},
    -- {"CAE-02 Treason", nil},
    -- {"CAE-03 Petty Treason", nil},
    -- {"CAE-04 Terrorism", nil},
    -- {"CAE-05 Sedition", nil},
    -- {"CAE-06 War Crimes", nil},
    -- {"CAE-07 Unauthorised Access or Disclosure of Classified Material", nil},

    {"HC-01 Orders from Command Staff", nil},
    {"HC-02 Corruption", bailprices[5]},
    {"HC-03 Murder / Attempted Murder", bailprices[4]},
    {"HC-04 Kidnapping", bailprices[4]},
    {"HC-05 Assault", bailprices[3]},
    {"HC-06 Aiding and Abetting", nil},
    {"HC-07 Insubordination", bailprices[3]},
    {"HC-08 Impersonation", bailprices[3]},
    {"HC-09 Misconduct", bailprices[2]},
    {"HC-10 Posession or Distribution of Contraband or Narcotics", bailprices[3]},
    {"HC-11 Defacing, Theft or Destruction of Imperial Property", bailprices[2]},
    {"HC-12 Obstruction of Imperial Justice", bailprices[2]},
    {"HC-13 Animal Cruelty", bailprices[2]},

    {"LC-01 Trespassing", bailprices[1]},
    {"LC-02 Loitering", bailprices[1]},
    {"LC-03 Disrespect", bailprices[1]},
    {"LC-04 Defacing, Theft or Destruction of Personal Property", bailprices[1]},
    {"LC-05 Misuse of Imperial Equipment", bailprices[1]},
    {"LC-06 Discharging a Weapon Unlawfully", bailprices[1]},
    {"LC-07 Weapon out on Inappropriate DEFCON", bailprices[1]},
    {"LC-08 Operating a Vehicle Illegally or without a License", bailprices[1]},
}

AikoBailSystem.Config.AlertedRegiments = {
	["107th Shock Division"] = true,
	["107th Riot Company"] = true,
	["Inferno Squad"] = true,
    ["107th Medic"] = true,
    ["107th Heavy"] = true,
    ["107th Honour Guard"] = true,
	["Imperial Security Bureau"] = true
}

AikoBailSystem.Config.BlacklistedRegiments = {
	["Event"] = true,
	["Rebel Alliance"] = true
}

AikoBailSystem.Config.BailCooldown = AikoBailSystem.Config.BailCooldown * 60
