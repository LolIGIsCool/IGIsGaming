if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Shotgun Module"
ATTACHMENT.ShortName = "Sg.M."
ATTACHMENT.Icon = "entities/dc17m_shotgun.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change for the Shotgun module.", 
    TFA.AttachmentColors["+"], "35x5 Damage",
    TFA.AttachmentColors["+"], "-2600% Accuracy",
    TFA.AttachmentColors["-"], "-185% RPM",
    TFA.AttachmentColors["-"], "+800% Kickback",
    TFA.AttachmentColors["="], "8 Cells/Clip",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rifle_module"] = {["active"] = false},
		["rifle_mag"] = {["active"] = false},
		["shotgun_module"] = {["active"] = true},
		["sniper_magext"] = {["active"] = true},
	},
	["WElements"] = {
		["rifle_module"] = {["active"] = false},
		["rifle_mag"] = {["active"] = false},
		["shotgun_module"] = {["active"] = true},
		["sniper_magext"] = {["active"] = true},
	},

	["Primary"] = {
		["Sound"] = "w/dc17mshotgun.wav",
		["KickUp"] = function(wep,stat) return stat * 8 end,
		["KickDown"] = function(wep,stat) return stat * 8 end,
		["ClipSize"] = 8,
		["RPM"] = 150,
		["Damage"] = 20,
		["Spread"] = 0.13,
		["IronAccuracy"] = 0.08,
		["NumShots"] = 8,
	},
	["IronSightsPos"] = function( wep, val ) return wep.ScopeSgPos or val, true end,
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
	wep:Reload( true )
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
	wep:Reload( true )
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
