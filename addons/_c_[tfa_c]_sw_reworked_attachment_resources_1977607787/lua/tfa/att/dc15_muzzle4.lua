if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "CR-2 Muzzle"
ATTACHMENT.ShortName = "M4"
ATTACHMENT.Icon = "entities/att/m4.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Better Control", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["muzzle4"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["muzzle4"] = {
			["active"] = true
		},
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat/2 end,
		["KickDown"] = function(wep,stat) return stat/2 end,
		["KickHorizontal"] = function(wep,stat) return stat/2 end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat/2 end,
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
