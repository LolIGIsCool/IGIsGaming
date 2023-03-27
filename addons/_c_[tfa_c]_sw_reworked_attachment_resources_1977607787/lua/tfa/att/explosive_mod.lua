if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Explosive Mod"
ATTACHMENT.ShortName = "E-M"
ATTACHMENT.Icon = "entities/att/exp_mod.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change to Explosive Rounds",
    TFA.AttachmentColors["+"], "Add Blast Damages",
    TFA.AttachmentColors["-"], "+400% Ammo Consumption",
    TFA.AttachmentColors["-"], "-66% RPM",
    TFA.AttachmentColors["-"], "+220% Kick",
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = "w/ci_heavy.wav",
		["Damage"] = function(wep,stat) return stat*1 end,
		["RPM"] = function(wep,stat) return stat*0.33 end,
		["DamageType"] = DMG_DIRECT,
		["AmmoConsumption"] = 5,
		["KickUp"] = function(wep,stat) return stat*32/5 end,
		["KickDown"] = function(wep,stat) return stat*32/5 end,
	},
	
	["Secondary"] = {
		["ClipSize"] = 1,
	},

	["TracerName"] = "rw_sw_laser_yellow",

	["VElements"] = {
		["cell_mod"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["cell_mod"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "sw_explosion"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end