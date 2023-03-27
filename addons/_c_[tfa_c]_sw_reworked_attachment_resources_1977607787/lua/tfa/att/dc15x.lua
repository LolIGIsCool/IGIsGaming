if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "X Mod"
ATTACHMENT.ShortName = "X-M"
ATTACHMENT.Icon = "entities/att/x_mod.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change to Anti-Material Mod", 
    TFA.AttachmentColors["+"], "+500% Damages", 
    TFA.AttachmentColors["-"], "-80% RPM", 
    TFA.AttachmentColors["-"], "-80% ClipSize", 
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = "w/dc15x.wav",
		["Damage"] = function(wep,stat) return stat*6 end,
		["RPM"] = function(wep,stat) return stat/5 end,
		["ClipSize"] = function(wep,stat) return stat/5 end,
		["Automatic"] = false,
	},
	["SelectiveFire"] = false,
	["FireModes"] = {
		"Single",
	}
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
